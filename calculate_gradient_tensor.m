function T = calculate_gradient_tensor(B, sensor_pos, a)
% CALCULATE_GRADIENT_TENSOR 计算磁场梯度张量
%   T = calculate_gradient_tensor(B, sensor_pos, a) 使用数值差分法计算梯度张量
%
%   输入参数:
%   B          - 传感器测量的磁场矩阵 (8 x 3)
%   sensor_pos - 传感器位置矩阵 (8 x 3)
%   a          - 立方体半边长
%
%   输出参数:
%   T          - 磁场梯度张量 (3 x 3)

    % 初始化梯度张量
    T = zeros(3, 3);
    
    % 定义传感器索引 - 正六面体顶点结构
    % 前四个传感器位于x正向，后四个位于x负向
    % 1-2-5-6在y正向，3-4-7-8在y负向
    % 1-3-5-7在z正向，2-4-6-8在z负向
    RIGHT_SENSORS = [1 2 3 4]; % x正方向传感器
    LEFT_SENSORS = [5 6 7 8];  % x负方向传感器
    UP_SENSORS = [1 2 5 6];    % y正方向传感器
    DOWN_SENSORS = [3 4 7 8];  % y负方向传感器
    FRONT_SENSORS = [1 3 5 7]; % z正方向传感器
    BACK_SENSORS = [2 4 6 8];  % z负方向传感器
    
    % 计算x方向梯度
    % 使用右侧四个传感器的平均值减去左侧四个传感器的平均值
    B_right = mean(B(RIGHT_SENSORS,:), 1);
    B_left = mean(B(LEFT_SENSORS,:), 1);
    dx = 2*a; % x方向上的距离
    T(1:3,1) = (B_right - B_left)' / dx;
    
    % 计算y方向梯度
    % 使用上方四个传感器的平均值减去下方四个传感器的平均值
    B_up = mean(B(UP_SENSORS,:), 1);
    B_down = mean(B(DOWN_SENSORS,:), 1);
    dy = 2*a; % y方向上的距离
    T(1:3,2) = (B_up - B_down)' / dy;
    
    % 计算z方向梯度
    % 使用前方四个传感器的平均值减去后方四个传感器的平均值
    B_front = mean(B(FRONT_SENSORS,:), 1);
    B_back = mean(B(BACK_SENSORS,:), 1);
    dz = 2*a; % z方向上的距离
    T(1:3,3) = (B_front - B_back)' / dz;
    
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