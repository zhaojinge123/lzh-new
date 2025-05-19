%% 绘制图4.4：定位误差与噪声水平的关系
% 本脚本用于生成论文中图4.4，展示不同噪声水平下的定位精度变化
% 使用对数坐标系展示噪声水平与定位误差之间的指数关系

clc;
clear;
close all;

%% 数据定义（根据论文表4.3）
% 噪声水平 (T)
noise_levels = [1e-14, 1e-13, 1e-12, 1e-11, 1e-10];
% 平均定位误差 (mm)
positioning_errors = [0.53, 5.85, 58.7, 243.5, 867.3];
% 标准差 (mm)
error_std = [0.18, 1.73, 17.4, 95.6, 356.2];
% 相对误差 (%)
relative_errors = [0.015, 0.16, 1.63, 6.76, 24.1];
% 失败率 (%)
failure_rates = [0, 0, 0, 12, 47];

%% 创建图形
figure('Name', '定位误差与噪声水平的关系', 'NumberTitle', 'off', 'Position', [100, 100, 900, 700]);

%% 网格设置 - 创建更明显的网格背景
axes('Position', [0.13, 0.11, 0.775, 0.815]);
set(gca, 'Color', [0.97, 0.97, 0.97]);
grid on;
set(gca, 'GridLineStyle', ':');
set(gca, 'GridColor', [0.7, 0.7, 0.7]);
set(gca, 'GridAlpha', 0.8);
set(gca, 'XScale', 'log');
set(gca, 'YScale', 'log');
set(gca, 'Layer', 'bottom');

% 特殊强调的网格线（虚线）
hold on;
for i = [-14, -13, -12, -11, -10]
    line([10^i, 10^i], [0.1, 1000], 'LineStyle', ':', 'Color', [0.5, 0.5, 0.5], 'LineWidth', 1);
end
for i = [-1, 0, 1, 2, 3]
    line([1e-15, 1e-9], [10^i, 10^i], 'LineStyle', ':', 'Color', [0.5, 0.5, 0.5], 'LineWidth', 1);
end

%% 添加精度区域
% 毫米级精度区域（绿色）
rectangle('Position', [1e-15, 0.1, 1e-12-1e-15, 10-0.1], 'FaceColor', [0.8, 1, 0.8, 0.3], 'EdgeColor', 'none');
text(3e-15, 0.3, '毫米级精度区', 'FontSize', 12, 'Color', [0, 0.5, 0], 'FontWeight', 'bold');

% 厘米级精度区域（黄色）
rectangle('Position', [1e-12, 0.1, 1e-10-1e-12, 100-0.1], 'FaceColor', [1, 1, 0.8, 0.3], 'EdgeColor', 'none');
text(3e-12, 30, '厘米级精度区', 'FontSize', 12, 'Color', [0.6, 0.3, 0], 'FontWeight', 'bold');

% 分米级及更差精度区域（红色）
rectangle('Position', [1e-10, 0.1, 1e-9-1e-10, 1000-0.1], 'FaceColor', [1, 0.8, 0.8, 0.3], 'EdgeColor', 'none');
text(3e-10, 300, '分米级精度区', 'FontSize', 12, 'Color', [0.5, 0, 0], 'FontWeight', 'bold');

%% 主坐标轴：定位误差与噪声水平
% 设置更粗更明显的线，改为亮蓝色与截图匹配
h_line = loglog(noise_levels, positioning_errors, '-', 'LineWidth', 4, 'Color', [0, 0.7, 1]);
hold on;

% 添加标记点，使用圆形标记，更大更明显
h_markers = loglog(noise_levels, positioning_errors, 'o', 'MarkerSize', 12, 'MarkerFaceColor', [0, 0.7, 1], 'MarkerEdgeColor', [0, 0.4, 0.8], 'LineWidth', 1.5);

% 添加误差线（更接近截图样式）
for i = 1:length(noise_levels)
    % 绘制垂直误差线
    line([noise_levels(i), noise_levels(i)], ...
         [positioning_errors(i)-error_std(i), positioning_errors(i)+error_std(i)], ...
         'Color', 'k', 'LineWidth', 1.5);
    
    % 绘制误差线的上下横线
    line([noise_levels(i)*0.9, noise_levels(i)*1.1], ...
         [positioning_errors(i)+error_std(i), positioning_errors(i)+error_std(i)], ...
         'Color', 'k', 'LineWidth', 1.5);
    line([noise_levels(i)*0.9, noise_levels(i)*1.1], ...
         [positioning_errors(i)-error_std(i), positioning_errors(i)-error_std(i)], ...
         'Color', 'k', 'LineWidth', 1.5);
end

% 设置坐标轴属性
ax1 = gca;
ax1.LineWidth = 1.5;
ax1.Box = 'on';
ax1.FontSize = 14;
ax1.FontWeight = 'bold';
ax1.XTickLabel = {'10^{-14}', '10^{-13}', '10^{-12}', '10^{-11}', '10^{-10}'};

% 设置标签
xlabel('噪声水平 (T)', 'FontSize', 16, 'FontWeight', 'bold');
ylabel('平均定位误差 (mm)', 'FontSize', 16, 'FontWeight', 'bold');
title('定位误差与噪声水平的关系', 'FontSize', 18, 'FontWeight', 'bold');

%% 创建第二个Y轴：失败率
yyaxis right;
h_fail = semilogx(noise_levels, failure_rates, '--s', 'LineWidth', 3, 'MarkerSize', 10, 'Color', [0.8, 0, 0], 'MarkerFaceColor', [0.8, 0, 0]);

% 设置第二个Y轴的属性
ax2 = gca;
ax2.YColor = [0.8, 0, 0];
ax2.YLim = [0, 100];
ax2.YTick = 0:10:100;
ax2.FontSize = 14;
ax2.FontWeight = 'bold';
ylabel('定位失败率 (%)', 'FontSize', 16, 'FontWeight', 'bold', 'Color', [0.8, 0, 0]);

%% 绘制拟合趋势线
% 计算拟合曲线 (y = a*x^b)
log_noise = log10(noise_levels);
log_errors = log10(positioning_errors);
p = polyfit(log_noise, log_errors, 1);
a = 10^p(2);  % 系数
b = p(1);     % 指数

% 生成平滑的趋势线数据
x_fit = logspace(-15, -9, 100);
y_fit = a * x_fit.^b;

% 绘制趋势线 - 更轻细的虚线，不干扰主线条
h_trend = loglog(x_fit, y_fit, ':', 'Color', [0.5, 0.5, 0.5], 'LineWidth', 1.2);

%% 添加图例 - 更突出的图例
legend([h_line, h_fail, h_trend], {'平均定位误差', '失败率', '拟合趋势线'}, ...
    'FontSize', 14, 'Location', 'northwest', 'FontWeight', 'bold', 'Box', 'on');

%% 美化图表
set(gcf, 'Color', 'white');
box on;

% 调整坐标轴范围
xlim([8e-15, 3e-10]);
yyaxis left;
ylim([0.1, 1000]);

%% 保存图表
saveas(gcf, '定位误差与噪声水平的关系.png');
saveas(gcf, '定位误差与噪声水平的关系.fig');

fprintf('图表已保存为"定位误差与噪声水平的关系.png"和".fig"\n'); 