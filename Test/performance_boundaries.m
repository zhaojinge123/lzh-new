function performance_boundaries()
% 系统在不同条件下的性能边界图 (图4.7)
% 作者：刘子涵

% 创建新图形窗口
figure('Name', '系统在不同条件下的性能边界', 'Position', [100, 100, 900, 600]);

% 设置图形背景颜色为白色
set(gcf, 'Color', 'white');

% 清空当前图形
clf;

% 创建2x2的子图布局，手动指定位置
subplot('Position', [0.1, 0.57, 0.35, 0.35]); % 距离界限
distance_boundary();

subplot('Position', [0.55, 0.57, 0.35, 0.35]); % 噪声容限
noise_boundary();

subplot('Position', [0.1, 0.1, 0.35, 0.35]); % 角度范围
angle_boundary();

subplot('Position', [0.55, 0.1, 0.35, 0.35]); % 实时性能
realtime_boundary();

% 添加总标题
sgtitle('', 'FontSize', 16, 'FontWeight', 'bold');

% 保存图像
print('图/performance_boundaries', '-dpng', '-r300');
saveas(gcf, '图/performance_boundaries.png');
disp('系统性能边界图已保存至 图/performance_boundaries.png');

end

% 子函数：距离界限图
function distance_boundary()
    % 定位误差随距离变化数据
    distances = [0.5, 1, 2, 3, 4, 5, 6, 7, 8];
    errors = [0.58, 1.2, 2.5, 5.85, 12.3, 21.5, 35.6, 57.2, 92.8];
    
    % 绘制曲线
    plot(distances, errors, '-o', 'LineWidth', 2, 'Color', [0.2, 0.6, 0.2], 'MarkerFaceColor', [0.2, 0.6, 0.2]);
    grid on;
    hold on;
    
    % 标记可接受误差区域和边界
    max_acceptable_error = 10; % 10 cm
    plot([0, 9], [max_acceptable_error, max_acceptable_error], '--', 'Color', [0.8, 0.2, 0.2], 'LineWidth', 1.5);
    
    % 查找临界点（距离~5米）
    boundary_x = 5;
    boundary_y = interp1(distances, errors, boundary_x);
    
    % 标记临界点
    plot(boundary_x, boundary_y, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
    text(boundary_x + 0.3, boundary_y + 5, '最大有效距离', 'FontSize', 10);
    
    % 设置坐标轴
    xlabel('目标距离 (m)', 'FontSize', 12);
    ylabel('定位误差 (mm)', 'FontSize', 12);
    xlim([0, 9]);
    ylim([0, 100]);
    
    % 添加标题
    title('距离界限 (噪声水平 \sigma=1e-13 T)', 'FontSize', 14);
    
    % 添加文本说明
    text(1, 85, '可接受误差区域', 'FontSize', 10, 'Color', [0.2, 0.6, 0.2]);
    
    % 使用标准注释方法替代textarrow
    % annotation('textarrow', [0.3, 0.2], [0.2, 0.15], 'String', '有效工作范围', 'FontSize', 9);
    text(2.5, 30, '有效工作范围', 'FontSize', 9, 'Color', [0, 0, 0.7]);
    annotation('arrow', [0.25, 0.2], [0.7, 0.67]);
end

% 子函数：噪声容限图
function noise_boundary()
    % 噪声水平与失败率关系
    noise_levels = [-14, -13, -12, -11, -10.3, -10];
    failure_rates = [0, 0, 0, 12, 35, 47];
    
    % 将噪声水平转换为可绘制的形式
    noise_values = 10.^(noise_levels);
    
    % 绘制曲线
    semilogx(noise_values, failure_rates, '-o', 'LineWidth', 2, 'Color', [0.2, 0.4, 0.8], 'MarkerFaceColor', [0.2, 0.4, 0.8]);
    grid on;
    hold on;
    
    % 标记临界噪声水平（5×10⁻¹¹ T）
    boundary_noise = 5e-11;
    boundary_failure = interp1(noise_values, failure_rates, boundary_noise);
    
    % 标记临界点
    plot(boundary_noise, boundary_failure, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
    text(boundary_noise*1.5, boundary_failure+3, '临界噪声水平', 'FontSize', 10);
    
    % 设置坐标轴
    xlabel('噪声水平 (T)', 'FontSize', 12);
    ylabel('定位失败率 (%)', 'FontSize', 12);
    xlim([1e-15, 1e-9]);
    ylim([0, 50]);
    
    % 设置刻度格式
    ax = gca;
    ax.XTickLabel = {'10^{-15}', '10^{-14}', '10^{-13}', '10^{-12}', '10^{-11}', '10^{-10}', '10^{-9}'};
    
    % 添加标题
    title('噪声容限 (目标距离3m)', 'FontSize', 14);
    
    % 使用标准注释方法替代textarrow
    % annotation('textarrow', [0.63, 0.57], [0.7, 0.65], 'String', '可靠工作区域', 'FontSize', 9);
    text(1e-13, 10, '可靠工作区域', 'FontSize', 9, 'Color', [0, 0, 0.7]);
    annotation('arrow', [0.6, 0.57], [0.7, 0.65]);
end

% 子函数：角度范围图
function angle_boundary()
    % 定义角度和相应的误差
    angles = [0, 45, 90, 135, 180, 225, 270, 315, 360];
    x_errors = [5.85, 6.2, 6.7, 6.3, 5.9, 6.4, 6.8, 6.1, 5.85];
    y_errors = [5.85, 5.9, 6.1, 6.3, 6.7, 6.5, 6.0, 5.8, 5.85];
    z_errors = [6.7, 6.8, 7.0, 6.9, 6.5, 6.8, 7.1, 6.7, 6.7];
    
    % 转换为极坐标以便于绘制
    angles_rad = angles * pi / 180;
    
    % 创建极坐标图
    polarplot(angles_rad, x_errors, '-', 'LineWidth', 2, 'Color', [0.8, 0.2, 0.2]);
    hold on;
    polarplot(angles_rad, y_errors, '-', 'LineWidth', 2, 'Color', [0.2, 0.6, 0.2]);
    polarplot(angles_rad, z_errors, '-', 'LineWidth', 2, 'Color', [0.2, 0.4, 0.8]);
    
    % 设置极坐标网格
    thetalim([0, 360]);
    rticks(0:2:10);
    rticklabels({'0', '2', '4', '6', '8', '10'});
    
    % 添加图例
    legend('X轴误差', 'Y轴误差', 'Z轴误差', 'Location', 'northoutside', 'Orientation', 'horizontal');
    
    % 设置标题
    title('角度范围 (误差单位: mm)', 'FontSize', 14);
    
    % 标记最大误差区域
    text(pi/4, 9, '最大误差≤15%', 'FontSize', 9, 'HorizontalAlignment', 'center');
end

% 子函数：实时性能图
function realtime_boundary()
    % 定义计算次数和对应的计算时间
    attempt_counts = [1, 3, 5, 7, 9, 11, 13, 15, 17, 19];
    compute_times = [0.07, 0.21, 0.32, 0.45, 0.58, 0.67, 0.72, 0.78, 0.83, 0.91];
    
    % 绘制计算时间曲线
    plot(attempt_counts, compute_times, '-o', 'LineWidth', 2, 'Color', [0.7, 0.4, 0]);
    grid on;
    hold on;
    
    % 标记当前系统使用的配置（15次尝试，0.78秒）
    current_attempts = 15;
    current_time = 0.78;
    plot(current_attempts, current_time, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
    text(current_attempts+0.5, current_time+0.02, '当前系统配置', 'FontSize', 10);
    
    % 标记实时性能区域
    real_time_threshold = 1.0; % 1秒阈值
    plot([0, 20], [real_time_threshold, real_time_threshold], '--', 'Color', [0.8, 0.2, 0.2], 'LineWidth', 1.5);
    
    % 设置坐标轴
    xlabel('优化尝试次数', 'FontSize', 12);
    ylabel('计算时间 (s)', 'FontSize', 12);
    xlim([0, 20]);
    ylim([0, 1.2]);
    
    % 添加标题
    title('实时性能', 'FontSize', 14);
    
    % 添加文本说明
    text(5, 1.1, '实时响应阈值', 'FontSize', 10, 'Color', [0.8, 0.2, 0.2]);
    text(5, 0.4, '准静态应用适用区域', 'FontSize', 10, 'Color', [0.7, 0.4, 0]);
end 