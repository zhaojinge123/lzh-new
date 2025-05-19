function error_propagation_model()
% 创建图4.6 系统误差传播模型图
% 作者：刘子涵

% 创建新图形窗口
figure('Name', '系统误差传播模型图', 'Position', [100, 100, 900, 600]);

% 设置图形背景颜色为白色
set(gcf, 'Color', 'white');

% 清空当前图形并隐藏坐标轴
clf;
axis([0 1 0 1]);
set(gca, 'visible', 'off');
hold on;

% 定义主模块的位置
box_width = 0.25;
box_height = 0.25;
y_pos = 0.5;
sensor_box = [0.10, y_pos, box_width, box_height];     % 传感器测量误差
gradient_box = [0.40, y_pos, box_width, box_height];   % 梯度张量计算误差
algorithm_box = [0.70, y_pos, box_width, box_height];  % 算法优化求解误差
result_box = [0.40, 0.15, box_width, box_height];      % 定位结果误差

% 绘制标题
title_text = '系统误差传播模型图';
title_pos = [0.5, 0.9];
text(title_pos(1), title_pos(2), title_text, 'FontSize', 16, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');

% 绘制模块标题
sensor_title = '传感器测量误差';
gradient_title = '梯度张量计算误差';
algorithm_title = '算法优化求解误差';

% 绘制模块标题（放在模块上方）
text(sensor_box(1) + box_width/2, sensor_box(2) + box_height + 0.05, sensor_title, 'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
text(gradient_box(1) + box_width/2, gradient_box(2) + box_height + 0.05, gradient_title, 'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
text(algorithm_box(1) + box_width/2, algorithm_box(2) + box_height + 0.05, algorithm_title, 'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');

% 绘制四个模块框
plot_box(sensor_box, 'r', 2);
plot_box(gradient_box, 'g', 2);
plot_box(algorithm_box, 'b', 2);
plot_box(result_box, [0.7, 0.7, 0], 2);

% 添加误差比例
text(sensor_box(1) + box_width/2, sensor_box(2) + box_height/2, '62%', 'FontSize', 14, 'Color', 'r', 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
text(gradient_box(1) + box_width/2, gradient_box(2) + box_height/2, '25%', 'FontSize', 14, 'Color', 'r', 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
text(algorithm_box(1) + box_width/2, algorithm_box(2) + box_height/2, '13%', 'FontSize', 14, 'Color', 'r', 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
text(result_box(1) + box_width/2, result_box(2) - 0.04, '100%', 'FontSize', 14, 'Color', 'r', 'FontWeight', 'bold', 'HorizontalAlignment', 'center');

% 绘制数据流标记
text(0.05, y_pos + box_height/2, '测量噪声', 'FontSize', 11, 'HorizontalAlignment', 'center');
text((sensor_box(1) + sensor_box(3) + gradient_box(1))/2, y_pos + box_height/2 + 0.05, '实测磁场数据', 'FontSize', 11, 'HorizontalAlignment', 'center');
text((gradient_box(1) + gradient_box(3) + algorithm_box(1))/2, y_pos + box_height/2 + 0.05, '梯度张量数据', 'FontSize', 11, 'HorizontalAlignment', 'center');
text(algorithm_box(1) + box_width/2, (algorithm_box(2) + result_box(2) + box_height)/2 + 0.05, '位置计算数据', 'FontSize', 11, 'HorizontalAlignment', 'center');

% 绘制误差放大
text(sensor_box(1) + box_width, y_pos + box_height/4, '误差放大', 'FontSize', 11, 'Color', 'r', 'HorizontalAlignment', 'center');
text(gradient_box(1) + box_width, y_pos + box_height/4, '条件数放大', 'FontSize', 11, 'Color', 'r', 'HorizontalAlignment', 'center');

% 绘制主数据流箭头
% 测量噪声到传感器模块
arrow([0.08, sensor_box(1)], [y_pos + box_height/2, y_pos + box_height/2], 'k', 1.5);

% 传感器到梯度张量模块
arrow([sensor_box(1) + box_width, gradient_box(1)], [y_pos + box_height/2, y_pos + box_height/2], 'k', 2);

% 梯度张量到算法优化模块
arrow([gradient_box(1) + box_width, algorithm_box(1)], [y_pos + box_height/2, y_pos + box_height/2], 'k', 2);

% 算法优化到定位结果模块
arrow([algorithm_box(1) + box_width/2, result_box(1) + box_width/2], [y_pos, result_box(2) + box_height], 'k', 2);

% 绘制误差放大箭头
draw_dashed_arrow([sensor_box(1) + box_width/2, gradient_box(1) + box_width/2], [y_pos + box_height/4, y_pos + box_height/4], 'r');
draw_dashed_arrow([gradient_box(1) + box_width/2, algorithm_box(1) + box_width/2], [y_pos + box_height/4, y_pos + box_height/4], 'r');

% 保存图像
print('图/error_propagation', '-dpng', '-r300');
saveas(gcf, '图/error_propagation.png');
disp('系统误差传播模型图已保存至 图/error_propagation.png');

end

% 辅助函数：绘制矩形框
function plot_box(box_pos, color, lw)
    x = [box_pos(1), box_pos(1) + box_pos(3), box_pos(1) + box_pos(3), box_pos(1), box_pos(1)];
    y = [box_pos(2), box_pos(2), box_pos(2) + box_pos(4), box_pos(2) + box_pos(4), box_pos(2)];
    plot(x, y, 'Color', color, 'LineWidth', lw);
end

% 辅助函数：绘制箭头
function arrow(x, y, color, lw)
    if nargin < 4
        lw = 1.5;
    end
    if nargin < 3
        color = 'k';
    end
    
    % 绘制线段
    plot([x(1), x(2)], [y(1), y(2)], 'Color', color, 'LineWidth', lw);
    
    % 绘制箭头
    dx = x(2) - x(1);
    dy = y(2) - y(1);
    L = sqrt(dx^2 + dy^2);
    
    % 归一化方向向量
    dx = dx / L;
    dy = dy / L;
    
    % 计算垂直向量
    perpx = -dy;
    perpy = dx;
    
    % 箭头尺寸
    asize = 0.015;
    
    % 箭头点位置
    x2 = x(2) - asize * dx;
    y2 = y(2) - asize * dy;
    
    % 绘制箭头头部
    plot([x(2), x2 + asize * perpx], [y(2), y2 + asize * perpy], 'Color', color, 'LineWidth', lw);
    plot([x(2), x2 - asize * perpx], [y(2), y2 - asize * perpy], 'Color', color, 'LineWidth', lw);
end

% 辅助函数：绘制虚线箭头
function draw_dashed_arrow(x, y, color)
    % 绘制虚线
    plot([x(1), x(2)], [y(1), y(2)], '--', 'Color', color, 'LineWidth', 1);
    
    % 添加三角箭头
    dx = x(2) - x(1);
    dy = y(2) - y(1);
    L = sqrt(dx^2 + dy^2);
    
    % 归一化方向向量
    dx = dx / L;
    dy = dy / L;
    
    % 计算垂直向量
    perpx = -dy;
    perpy = dx;
    
    % 箭头尺寸
    asize = 0.01;
    
    % 箭头点位置
    x2 = x(2) - asize * dx;
    y2 = y(2) - asize * dy;
    
    % 绘制箭头头部
    plot([x(2), x2 + asize * perpx], [y(2), y2 + asize * perpy], 'Color', color, 'LineWidth', 1);
    plot([x(2), x2 - asize * perpx], [y(2), y2 - asize * perpy], 'Color', color, 'LineWidth', 1);
    
    % 绘制小三角形箭头填充
    fill([x(2), x2 + asize * perpx, x2 - asize * perpx], [y(2), y2 + asize * perpy, y2 - asize * perpy], color);
end 