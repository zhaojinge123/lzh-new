% 测试定位算法的脚本
% 用于验证修改后的定位算法是否能够正确收敛到真实位置

clc;
clear;
close all;

%% 参数设置
% 物理常数
mu0 = 4*pi*1e-7;    % 真空磁导率

% 传感器布局参数 - 八个传感器的正六面体顶点布局
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
r0 = [2, 2, -2];    % 真实位置[x0, y0, z0]

% 噪声参数
sigma = 1e-12;      % 高斯白噪声标准差

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

%% 迭代优化求解目标位置
initial_guess = [1.5, 1.5, 1.5];    % 初始猜测值
[r_estimated, cost_history] = locate_target(T, initial_guess, m, mu0);

%% 误差分析
error_vector = r_estimated - r0;
error_distance = norm(error_vector);

%% 输出结果
fprintf('\n=== 定位结果 === \n');
fprintf('真实位置: [%.2f, %.2f, %.2f] \n', r0(1), r0(2), r0(3));
fprintf('估计位置: [%.2f, %.2f, %.2f] \n', r_estimated(1), r_estimated(2), r_estimated(3));
fprintf('定位误差: %.4f m \n', error_distance);

%% 绘制优化过程
figure;
semilogy(cost_history, 'LineWidth', 2);
grid on;
xlabel('迭代次数');
ylabel('代价函数值');
title('优化过程收敛曲线');