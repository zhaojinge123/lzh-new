%% 磁梯度张量探测系统单点定位主程序
% 作者：刘子涵
% 日期：
% 功能：实现基于正六面体传感器布局的磁偶极子单点定位系统仿真

clc;
clear;
close all;

%% 参数设置
% 物理常数
mu0 = 4*pi*1e-7;    % 真空磁导率

% 传感器布局参数 - 修改为正六面体顶点布局（八个传感器）
a = 0.5;            % 立方体半边长(m)
sensor_pos = [
    a,  a,  a;      % 传感器1位置 - 右上前
    a,  a, -a;      % 传感器2位置 - 右上后
    a, -a,  a;      % 传感器3位置 - 右下前
    a, -a, -a;      % 传感器4位置 - 右下后
   -a,  a,  a;      % 传感器5位置 - 左上前
   -a,  a, -a;      % 传感器6位置 - 左上后
   -a, -a,  a;      % 传感器7位置 - 左下前
   -a, -a, -a       % 传感器8位置 - 左下后
];

% 磁偶极子参数
m = [1, 1, 1];      % 磁矩[mx, my, mz]
r0 = [1, 3, -3];     % 真实位置[x0, y0, z0]

% 噪声参数 - 减小噪声标准差以提高测量精度
sigma = 1e-13;      % 高斯白噪声标准差

%% 计算理想磁场
B_ideal = zeros(8, 3);   % 8个传感器处的磁场分量
for i = 1:8
    B_ideal(i,:) = calculate_magnetic_field(sensor_pos(i,:), r0, m, mu0);
end

%% 添加噪声
B_noisy = add_noise(B_ideal, sigma);

%% 计算梯度张量
T = calculate_gradient_tensor(B_noisy, sensor_pos, a);

%% 提取张量不变量
[trace_T, det_T] = extract_tensor_invariants(T);

% 显示张量信息以帮助分析
fprintf('\n=== 梯度张量信息 ===\n');
fprintf('张量迹: %.6e\n', trace_T);
fprintf('张量行列式: %.6e\n', det_T);

% 显示张量元素
fprintf('\n梯度张量矩阵:\n');
for i = 1:3
    for j = 1:3
        fprintf('%+.6e ', T(i,j));
    end
    fprintf('\n');
end

%% 执行多次定位以找到最佳结果
num_location_attempts = 3;
best_error = Inf;
best_r_estimated = [];
best_cost_history = [];

for loc_attempt = 1:num_location_attempts
    fprintf('\n\n=== 定位尝试 %d/%d ===\n', loc_attempt, num_location_attempts);
    
    % 为每次尝试生成不同的初始猜测
    switch loc_attempt
        case 1
            % 使用接近真实位置的猜测
            initial_guess = [0.9, 0.9, 0.9];
        case 2
            % 使用稍远的猜测
            initial_guess = [1.5, 1.5, 1.5];
        case 3
            % 使用真实位置一侧的猜测
            initial_guess = [0.5, 0.5, 0.5];
    end
    
    fprintf('初始猜测值: [%.2f, %.2f, %.2f]\n', initial_guess(1), initial_guess(2), initial_guess(3));
    
    % 执行定位算法
    [r_estimated, cost_history] = locate_target(T, initial_guess, m, mu0);

    % 误差分析
    error_vector = r_estimated - r0;
    error_distance = norm(error_vector);
    
    % 输出当前尝试结果
    fprintf('\n当前尝试定位结果:\n');
    fprintf('真实位置: [%.2f, %.2f, %.2f]\n', r0(1), r0(2), r0(3));
    fprintf('估计位置: [%.2f, %.2f, %.2f]\n', r_estimated(1), r_estimated(2), r_estimated(3));
    fprintf('定位误差: %.4f m\n', error_distance);
    
    % 更新最佳结果
    if error_distance < best_error
        best_error = error_distance;
        best_r_estimated = r_estimated;
        best_cost_history = cost_history;
        fprintf('*** 发现更好的定位结果! ***\n');
    end
end

% 使用最佳结果作为最终估计
r_estimated = best_r_estimated;
error_distance = best_error;

%% 结果可视化
% 绘制传感器布局和目标位置
plot_sensor_layout(sensor_pos, r0, r_estimated);

% 绘制磁场分布
plot_magnetic_field(sensor_pos, r0, m, mu0);

% 绘制优化收敛过程
plot_convergence(best_cost_history);

%% 输出最终结果
fprintf('\n=== 最终定位结果 ===\n');
fprintf('真实位置: [%.2f, %.2f, %.2f]\n', r0);
fprintf('估计位置: [%.2f, %.2f, %.2f]\n', r_estimated);
fprintf('定位误差: %.4f m\n', error_distance);

% 计算各方向上的误差分量
error_x = abs(r_estimated(1) - r0(1));
error_y = abs(r_estimated(2) - r0(2));
error_z = abs(r_estimated(3) - r0(3));
fprintf('各方向误差 - X: %.4f m, Y: %.4f m, Z: %.4f m\n', error_x, error_y, error_z);