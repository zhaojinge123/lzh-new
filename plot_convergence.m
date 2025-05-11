function plot_convergence(cost_history)
% PLOT_CONVERGENCE 绘制优化算法的收敛过程
%   plot_convergence(cost_history) 绘制代价函数随迭代次数的变化曲线
%
%   输入参数:
%   cost_history - 优化过程中的代价函数历史记录

% 创建新图形窗口
figure('Name', '优化收敛过程', 'NumberTitle', 'off');

% 绘制半对数图
semilogy(cost_history, 'LineWidth', 2);
grid on;

% 添加标签和标题
xlabel('迭代次数', 'FontSize', 12);
ylabel('代价函数值', 'FontSize', 12);
title('定位算法的优化收敛过程', 'FontSize', 14);

% 设置坐标轴属性
ax = gca;
ax.FontSize = 10;
ax.LineWidth = 1.5;
ax.Box = 'on';

% 添加网格线
grid minor;

% 设置图形属性
set(gcf, 'Color', 'white');
set(gca, 'YScale', 'log');

% 添加图例说明
legend('代价函数值', 'Location', 'northeast');

% 优化图形显示
axis tight;
end