% 比较单一初始点与多初始点方法的定位精度
% 用于生成论文图4.3的对比数据

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

% 测试位置集合 - 在不同距离和方向上测试
test_positions = [
    [1.0, 1.0, 1.0];   % 中等距离，对称方向
    [2.0, 2.0, 2.0];   % 较远距离，对称方向
    [3.0, 0.0, 0.0];   % 沿x轴
    [0.0, 3.0, 0.0];   % 沿y轴
    [0.0, 0.0, 3.0];   % 沿z轴
    [1.0, 3.0, -3.0];  % 非对称方向，与主程序一致
    [2.5, -1.5, 2.0];  % 复杂方向
    [4.0, 4.0, 4.0];   % 远距离，对称方向
    [-2.0, -2.0, -2.0] % 负方向
];

% 噪声参数 - 测试不同噪声水平
noise_levels = [1e-14, 1e-13, 1e-12, 1e-11];

% 初始化结果数组
num_positions = size(test_positions, 1);
num_noise_levels = length(noise_levels);

% 存储结果的数组
single_point_errors = zeros(num_positions, num_noise_levels);
multi_point_errors = zeros(num_positions, num_noise_levels);
single_point_times = zeros(num_positions, num_noise_levels);
multi_point_times = zeros(num_positions, num_noise_levels);

% 单一初始点设置
single_num_attempts = 1;

% 多初始点设置（完整算法）
multi_num_attempts = 15;

fprintf('开始比较单一初始点与多初始点方法的定位精度...\n\n');

%% 测试循环
for pos_idx = 1:num_positions
    r0 = test_positions(pos_idx, :);
    
    fprintf('===== 测试位置 %d/%d: [%.1f, %.1f, %.1f] =====\n', ...
        pos_idx, num_positions, r0(1), r0(2), r0(3));
    
    for noise_idx = 1:num_noise_levels
        sigma = noise_levels(noise_idx);
        
        fprintf('--- 噪声水平: %.0e ---\n', sigma);
        
        % 计算理想磁场
        B_ideal = zeros(8, 3);
        for i = 1:8
            B_ideal(i,:) = calculate_magnetic_field(sensor_pos(i,:), r0, m, mu0);
        end
        
        % 添加噪声
        B_noisy = add_noise(B_ideal, sigma);
        
        % 计算梯度张量
        T = calculate_gradient_tensor(B_noisy, sensor_pos, a);
        
        % 使用一致的初始猜测位置 - 远离真实位置
        initial_guess = [0.5, 0.5, 0.5];
        
        % 1. 单一初始点方法
        tic;
        [r_single, ~] = locate_target_single(T, initial_guess, m, mu0);
        single_time = toc;
        
        % 计算误差
        error_single = norm(r_single - r0);
        single_point_errors(pos_idx, noise_idx) = error_single;
        single_point_times(pos_idx, noise_idx) = single_time;
        
        fprintf('单一初始点: 误差 = %.4f m, 用时 = %.2f 秒\n', error_single, single_time);
        
        % 2. 多初始点方法
        tic;
        [r_multi, ~] = locate_target(T, initial_guess, m, mu0);
        multi_time = toc;
        
        % 计算误差
        error_multi = norm(r_multi - r0);
        multi_point_errors(pos_idx, noise_idx) = error_multi;
        multi_point_times(pos_idx, noise_idx) = multi_time;
        
        fprintf('多初始点: 误差 = %.4f m, 用时 = %.2f 秒\n', error_multi, multi_time);
        
        % 改进百分比
        improvement = (error_single - error_multi) / error_single * 100;
        fprintf('精度提升: %.1f%%\n\n', improvement);
    end
end

%% 计算平均误差
avg_single_errors = mean(single_point_errors, 1);
avg_multi_errors = mean(multi_point_errors, 1);
avg_improvement = (avg_single_errors - avg_multi_errors) ./ avg_single_errors * 100;

fprintf('===== 测试结果汇总 =====\n');
for i = 1:num_noise_levels
    fprintf('噪声水平 %.0e:\n', noise_levels(i));
    fprintf('  单一初始点平均误差: %.4f m\n', avg_single_errors(i));
    fprintf('  多初始点平均误差: %.4f m\n', avg_multi_errors(i));
    fprintf('  平均精度提升: %.1f%%\n\n', avg_improvement(i));
end

%% 绘制图4.3：单一初始点与多初始点方法的定位精度对比
% 创建图
figure('Name', '单一初始点与多初始点方法的定位精度对比', 'NumberTitle', 'off', 'Position', [100, 100, 800, 600]);

% 转换噪声水平为对数刻度标签
noise_labels = cell(num_noise_levels, 1);
for i = 1:num_noise_levels
    noise_labels{i} = sprintf('%.0e', noise_levels(i));
end

% 创建组合条形图
bar_width = 0.35;
bar_positions1 = 1:num_noise_levels;
bar_positions2 = bar_positions1 + bar_width;

% 设置不同的颜色
bar_color1 = [0.8, 0.2, 0.2]; % 红色系
bar_color2 = [0.2, 0.6, 0.8]; % 蓝色系

% 绘制条形图
bar1 = bar(bar_positions1, avg_single_errors, bar_width, 'FaceColor', bar_color1);
hold on;
bar2 = bar(bar_positions2, avg_multi_errors, bar_width, 'FaceColor', bar_color2);

% 添加误差线
errorbar(bar_positions1, avg_single_errors, std(single_point_errors, 0, 1), '.k');
errorbar(bar_positions2, avg_multi_errors, std(multi_point_errors, 0, 1), '.k');

% 添加数据标签
% 在每个柱子顶部添加具体数值
for i = 1:length(bar_positions1)
    text(bar_positions1(i), avg_single_errors(i), sprintf('%.3f', avg_single_errors(i)), ...
         'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', 8);
    text(bar_positions2(i), avg_multi_errors(i), sprintf('%.3f', avg_multi_errors(i)), ...
         'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', 8);
end

% 设置坐标轴和标签
set(gca, 'XTick', (bar_positions1 + bar_positions2)/2);
set(gca, 'XTickLabel', noise_labels);
set(gca, 'FontSize', 11);

xlabel('噪声水平 (T)', 'FontSize', 12);
ylabel('平均定位误差 (m)', 'FontSize', 12);
title('单一初始点与多初始点方法的定位精度对比', 'FontSize', 14);
legend('单一初始点方法', '多初始点方法', 'Location', 'northwest');

% 添加网格线，仅显示水平网格线
grid on;
set(gca, 'YGrid', 'on', 'XGrid', 'off');

% 美化图表
box on;
set(gcf, 'Color', 'white');

% 添加改进百分比标签
for i = 1:num_noise_levels
    x_pos = (bar_positions1(i) + bar_positions2(i)) / 2;
    y_pos = max([avg_single_errors(i), avg_multi_errors(i)]) * 1.1;
    text(x_pos, y_pos, sprintf('↓%.1f%%', avg_improvement(i)), 'HorizontalAlignment', 'center', 'FontSize', 10, 'FontWeight', 'bold');
end

hold off;

%% 保存图表
saveas(gcf, '单一初始点与多初始点方法的定位精度对比.png');
saveas(gcf, '单一初始点与多初始点方法的定位精度对比.fig');

fprintf('图表已保存为"单一初始点与多初始点方法的定位精度对比.png"和".fig"\n'); 