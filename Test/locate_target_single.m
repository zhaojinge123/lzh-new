function [r_estimated, cost_history] = locate_target_single(T_measured, initial_guess, m, mu0)
% LOCATE_TARGET_SINGLE 使用单一初始点的非线性优化方法估计磁偶极子位置
%   [r_estimated, cost_history] = locate_target_single(T_measured, initial_guess, m, mu0)
%   通过最小化测量张量与理论张量之间的Frobenius范数来估计目标位置，仅使用单个初始点
%
%   输入参数:
%   T_measured    - 测量的磁场梯度张量 (3 x 3)
%   initial_guess - 初始位置猜测值 [x, y, z]
%   m            - 磁偶极子磁矩 [mx, my, mz]
%   mu0          - 真空磁导率
%
%   输出参数:
%   r_estimated  - 估计的目标位置 [x, y, z]
%   cost_history - 优化过程中的代价函数历史记录

    % 仅使用一个初始点，不生成多个初始猜测
    fprintf('\n使用单一初始点优化...\n');

    % 设置边界约束，防止优化过程中跑到不合理的位置
    lb = [-5, -5, -5]; % 下界
    ub = [5, 5, 5];    % 上界
    
    % 创建一个数组来存储优化历史
    history = [];
    
    % 使用Levenberg-Marquardt算法
    options = optimset('Display', 'off', ...
                  'MaxIter', 3000, ...
                  'TolFun', 1e-15, ...
                  'TolX', 1e-15, ...
                  'Algorithm', 'levenberg-marquardt', ...
                  'ScaleProblem', 'jacobian', ...
                  'FinDiffType', 'central', ...
                  'MaxFunEvals', 5000, ...
                  'TypicalX', [1 1 1]);
    
    % 定义输出函数来记录每次迭代的代价函数值
    options = optimset(options, 'OutputFcn', @output_function);
    
    % 定义代价函数
    cost_fun = @(r) tensor_cost_function(r, T_measured, m, mu0);
    
    % 使用非线性最小二乘法求解，添加边界约束
    fprintf('初始猜测: [%.2f, %.2f, %.2f]\n', initial_guess(1), initial_guess(2), initial_guess(3));
    [r_estimated, resnorm, ~, exitflag, output] = lsqnonlin(cost_fun, initial_guess, lb, ub, options);
    
    % 输出结果
    fprintf('结果: [%.2f, %.2f, %.2f], 残差: %.6e, 迭代: %d\n', ...
        r_estimated(1), r_estimated(2), r_estimated(3), resnorm, output.iterations);
    
    % 返回优化历史记录
    cost_history = history;
    
    % 嵌套函数：输出函数，用于记录优化历史
    function stop = output_function(x, optimValues, state)
        stop = false;
        
        switch state
            case 'iter'
                % 在每次迭代时记录残差平方和
                if isfield(optimValues, 'resnorm')
                    % 如果存在resnorm字段，使用它
                    history(end+1) = optimValues.resnorm;
                elseif isfield(optimValues, 'residual')
                    % 否则，如果有residual字段，计算残差平方和
                    history(end+1) = sum(optimValues.residual.^2);
                end
        end
    end
end

function cost = tensor_cost_function(r, T_measured, m, mu0)
% 计算测量张量与理论张量之间的误差

    % 计算理论梯度张量
    T_theory = calculate_theoretical_tensor(r, m, mu0);
    
    % 计算Frobenius范数作为代价函数
    diff_tensor = T_measured - T_theory;
    % 返回差异张量的每个元素作为残差向量，以便lsqnonlin可以正确优化
    cost = reshape(diff_tensor, [], 1);
    
    % 添加权重因子，使对角元素误差更重要
    weights = ones(size(cost));
    % 增加对角元素权重
    diag_indices = [1, 5, 9]; % 对应于3x3矩阵重塑为9x1向量后的对角元素索引
    weights(diag_indices) = 1.5;
    
    % 应用权重
    cost = cost .* weights;
end

function T = calculate_theoretical_tensor(r, m, mu0)
% 计算给定位置的理论梯度张量

    % 初始化梯度张量
    T = zeros(3, 3);
    
    % 计算r的范数 - 添加保护以避免除零错误
    r_norm = norm(r);
    if r_norm < 1e-10
        r_norm = 1e-10; % 防止除零
    end
    
    % 计算归一化的位置向量
    r_unit = r / r_norm;
    
    % 计算m和r的点积
    m_dot_r = dot(m, r_unit);
    
    % 计算常数项 - 修正系数 (3µ0/4π)
    const = 3 * mu0 / (4*pi * r_norm^4);
    
    % 计算3x3张量
    for i = 1:3
        for j = 1:3
            % 计算张量的各个分量 - 使用更精确的公式
            delta_ij = (i == j);  % 克罗内克delta函数
            
            T(i,j) = const * (5 * r_unit(i) * r_unit(j) * m_dot_r - ...
                             r_unit(i) * m(j) - ...
                             r_unit(j) * m(i) - ...
                             delta_ij * m_dot_r);
        end
    end
    
    % 确保张量对称性和零迹
    T = (T + T')/2;
    trace_T = trace(T);
    
    % 强制张量的迹为零（磁场的散度为零）
    for i = 1:3
        T(i,i) = T(i,i) - trace_T/3;
    end
end 