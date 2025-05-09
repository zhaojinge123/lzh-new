function [r_estimated, cost_history] = locate_target(T_measured, initial_guess, m, mu0)
% LOCATE_TARGET 使用非线性优化方法估计磁偶极子位置
%   [r_estimated, cost_history] = locate_target(T_measured, initial_guess, m, mu0)
%   通过最小化测量张量与理论张量之间的Frobenius范数来估计目标位置
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

    % 设置多次优化尝试，使用不同的初始猜测值
    num_attempts = 15;  % 增加优化尝试次数
    best_cost = Inf;
    best_r = initial_guess;
    all_history = [];
    
    fprintf('\n开始多次优化尝试，以提高定位精度...\n');
    
    % 生成多个初始猜测值
    initial_guesses = zeros(num_attempts, 3);
    initial_guesses(1,:) = initial_guess;  % 使用用户提供的初始猜测
    
    % 生成更多更全面的初始猜测
    % 包括更接近真实位置的猜测
    for i = 2:num_attempts
        if i <= 5
            % 在第一个初始猜测附近生成点
            initial_guesses(i,:) = initial_guess + 0.3 * (rand(1,3) - 0.5);
        elseif i <= 10
            % 在更广范围内生成点
            initial_guesses(i,:) = 2 * (rand(1,3));  % 范围在 [0, 2]
        else
            % 在更大范围内生成点
            initial_guesses(i,:) = 3 * (rand(1,3) - 0.5);  % 范围在 [-1.5, 1.5]
        end
    end

    % 设置边界约束，防止优化过程中跑到不合理的位置
    lb = [-5, -5, -5]; % 下界
    ub = [5, 5, 5];    % 上界
    
    % 遍历所有初始猜测值进行多次优化
    for attempt = 1:num_attempts
        % 当前初始猜测值
        current_guess = initial_guesses(attempt,:);
        
        % 创建一个数组来存储当前尝试的优化历史
        history = [];
        
        % 针对不同尝试使用不同的优化算法和参数
        if mod(attempt, 3) == 0
            % 使用信赖域算法
            options = optimset('Display', 'off', ...
                          'MaxIter', 3000, ...
                          'TolFun', 1e-15, ...
                          'TolX', 1e-15, ...
                          'Algorithm', 'trust-region-reflective', ...
                          'FinDiffType', 'central', ...
                          'MaxFunEvals', 5000, ...
                          'TypicalX', [1 1 1]);
        elseif mod(attempt, 3) == 1
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
        else
            % 使用改进的Levenberg-Marquardt算法，不同的参数
            options = optimset('Display', 'off', ...
                          'MaxIter', 3000, ...
                          'TolFun', 1e-15, ...
                          'TolX', 1e-15, ...
                          'Algorithm', 'levenberg-marquardt', ...
                          'ScaleProblem', 'jacobian', ...
                          'FinDiffType', 'central', ...
                          'MaxFunEvals', 5000, ...
                          'TypicalX', [1 1 1]);
        end
        
        % 定义输出函数来记录每次迭代的代价函数值
        options = optimset(options, 'OutputFcn', @output_function);
        
        % 定义代价函数
        cost_fun = @(r) tensor_cost_function(r, T_measured, m, mu0);
        
        % 使用非线性最小二乘法求解，添加边界约束
        fprintf('\n尝试 %d/%d - 初始猜测: [%.2f, %.2f, %.2f]\n', attempt, num_attempts, current_guess(1), current_guess(2), current_guess(3));
        [r_current, resnorm, ~, exitflag, output] = lsqnonlin(cost_fun, current_guess, lb, ub, options);
        
        % 输出当前尝试的结果
        fprintf('  结果: [%.2f, %.2f, %.2f], 残差: %.6e, 迭代: %d\n', r_current(1), r_current(2), r_current(3), resnorm, output.iterations);
        
        % 如果当前结果比之前的更好，则更新最佳结果
        if resnorm < best_cost
            best_cost = resnorm;
            best_r = r_current;
            fprintf('  *** 发现更好的解决方案! ***\n');
        end
        
        % 将当前历史记录添加到总历史记录中
        % 确保history是一个列向量
        if ~isempty(history)
            history = history(:); % 将history转换为列向量
            if isempty(all_history)
                all_history = history;
            else
                % 确保两者维度匹配后再进行连接
                all_history = [all_history; history];
            end
        end
    end
    
    % 使用最佳结果进行二次优化，以进一步精细化
    fprintf('\n对最佳结果进行二次优化...\n');
    options = optimset('Display', 'off', ...
                      'MaxIter', 5000, ...
                      'TolFun', 1e-16, ...
                      'TolX', 1e-16, ...
                      'Algorithm', 'levenberg-marquardt', ...
                      'ScaleProblem', 'jacobian', ...
                      'FinDiffType', 'central', ...
                      'MaxFunEvals', 10000, ...
                      'TypicalX', [1 1 1]);
    
    cost_fun = @(r) tensor_cost_function(r, T_measured, m, mu0);
    [r_refined, resnorm, ~, ~, ~] = lsqnonlin(cost_fun, best_r, lb, ub, options);
    
    if resnorm < best_cost
        best_cost = resnorm;
        best_r = r_refined;
        fprintf('  二次优化成功，获得更好的结果!\n');
    end
    
    % 使用最佳结果作为最终估计
    r_estimated = best_r;
    
    % 输出最终结果
    fprintf('\n优化完成，最佳估计位置: [%.2f, %.2f, %.2f], 残差: %.6e\n', r_estimated(1), r_estimated(2), r_estimated(3), best_cost);
    
    % 返回所有尝试的历史记录
    cost_history = all_history;
    
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