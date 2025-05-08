function T = calculate_gradient_tensor(B, sensor_pos, a)
% CALCULATE_GRADIENT_TENSOR 计算磁场梯度张量
%   T = calculate_gradient_tensor(B, sensor_pos, a) 使用数值差分法计算梯度张量
%
%   输入参数:
%   B          - 传感器测量的磁场矩阵 (6 x 3)
%   sensor_pos - 传感器位置矩阵 (6 x 3)
%   a          - 立方体半边长
%
%   输出参数:
%   T          - 磁场梯度张量 (3 x 3)

    % 初始化梯度张量
    T = zeros(3, 3);
    
    % 定义传感器对应关系，增强代码可读性
    X_POS = 1; X_NEG = 2; % x轴正负方向传感器
    Y_POS = 3; Y_NEG = 4; % y轴正负方向传感器
    Z_POS = 5; Z_NEG = 6; % z轴正负方向传感器
    
    % 计算各方向上的距离，用于高精度梯度计算
    dx = norm(sensor_pos(X_POS,:) - sensor_pos(X_NEG,:));
    dy = norm(sensor_pos(Y_POS,:) - sensor_pos(Y_NEG,:));
    dz = norm(sensor_pos(Z_POS,:) - sensor_pos(Z_NEG,:));
    
    % 使用中心差分法计算梯度，更为准确
    % x方向梯度（使用传感器1和2）
    T(1:3,1) = (B(X_POS,:) - B(X_NEG,:))' / dx;
    
    % y方向梯度（使用传感器3和4）
    T(1:3,2) = (B(Y_POS,:) - B(Y_NEG,:))' / dy;
    
    % z方向梯度（使用传感器5和6）
    T(1:3,3) = (B(Z_POS,:) - B(Z_NEG,:))' / dz;
    
    % 应用Maxwell方程约束：梯度张量满足散度为零的约束
    % 确保梯度张量是对称的
    T = (T + T')/2;
    
    % 强制张量的迹为零（磁场散度为零）
    trace_T = trace(T);
    for i = 1:3
        T(i,i) = T(i,i) - trace_T/3;
    end
    
    % 检查数值误差
    % 计算张量的Frobenius范数，用于评估梯度张量的计算精度
    frob_norm = sqrt(sum(sum(T.^2)));
    
    % 如果梯度张量异常大或小，输出警告
    if frob_norm > 1e-6 || frob_norm < 1e-15
        warning('梯度张量范数异常: %.3e，可能存在数值问题', frob_norm);
    end
end