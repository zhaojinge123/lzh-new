function plot_sensor_layout(sensor_pos, r0, r_estimated)
% PLOT_SENSOR_LAYOUT 绘制传感器布局和目标位置
%   plot_sensor_layout(sensor_pos, r0, r_estimated) 绘制三维空间中的传感器布局
%   以及真实目标位置和估计位置
%
%   输入参数:
%   sensor_pos   - 传感器位置矩阵 (6 x 3)
%   r0          - 真实目标位置 [x0, y0, z0]
%   r_estimated - 估计目标位置 [x, y, z]

    % 创建新图窗
    figure('Name', '传感器布局与目标位置');
    
    % 绘制传感器位置
    scatter3(sensor_pos(:,1), sensor_pos(:,2), sensor_pos(:,3), 100, 'b', 'filled');
    hold on;
    
    % 绘制真实目标位置
    scatter3(r0(1), r0(2), r0(3), 200, 'r', 'filled');
    
    % 绘制估计目标位置
    scatter3(r_estimated(1), r_estimated(2), r_estimated(3), 200, 'g', 'filled');
    
    % 连接真实位置和估计位置
    plot3([r0(1), r_estimated(1)], [r0(2), r_estimated(2)], [r0(3), r_estimated(3)], 'k--');
    
    % 添加图例
    legend('传感器', '真实位置', '估计位置', 'Location', 'best');
    
    % 设置坐标轴标签
    xlabel('X (m)');
    ylabel('Y (m)');
    zlabel('Z (m)');
    
    % 设置坐标轴等比例
    axis equal;
    grid on;
    
    % 添加标题
    title('传感器布局与目标位置对比');
    
    % 调整视角
    view(45, 30);
end