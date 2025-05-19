function optimization_strategy()
% 创建图2-5 磁梯度张量定位系统两阶段混合优化策略流程图
% 作者：刘子涵

% 创建新图形窗口
figure('Name', '磁梯度张量定位系统两阶段混合优化策略流程图', 'Position', [100, 100, 900, 700]);

% 设置图形背景颜色为白色
set(gcf, 'Color', 'white');

% 清空当前图形
clf;

% 隐藏坐标轴
ax = gca;
set(ax, 'Visible', 'off');
axis off;

% 设置合适的显示区域
axis([0 1 0 1]);

% 添加标题
annotation('textbox', [0.15, 0.92, 0.7, 0.05], 'String', '磁梯度张量定位系统两阶段混合优化策略流程图', ...
    'FontSize', 16, 'FontWeight', 'bold', 'EdgeColor', 'none', ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');

% 第一阶段标题栏
annotation('rectangle', [0.15, 0.75, 0.7, 0.1], 'Color', [0.4, 0.6, 0.9], 'FaceColor', [0.4, 0.6, 0.9]);
annotation('textbox', [0.15, 0.75, 0.7, 0.1], 'String', '第一阶段：初值估计', ...
    'FontSize', 14, 'FontWeight', 'bold', 'Color', 'white', 'EdgeColor', 'none', ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');

% 第一阶段流程框
boxWidth = 0.2;
boxHeight = 0.1;
y1 = 0.62;

% SVD分解框
annotation('rectangle', [0.15, y1, boxWidth, boxHeight], 'Color', [0.4, 0.6, 0.9], 'LineWidth', 1);
annotation('textbox', [0.15, y1, boxWidth, boxHeight], 'String', '磁梯度张量G奇异值分解', ...
    'FontSize', 11, 'EdgeColor', 'none', 'FaceAlpha', 0, ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');

% 奇异值分解
annotation('rectangle', [0.4, y1, boxWidth, boxHeight], 'Color', [0.4, 0.6, 0.9], 'LineWidth', 1);
annotation('textbox', [0.4, y1, boxWidth, boxHeight], 'String', 'G = UΣV^T', ...
    'FontSize', 11, 'EdgeColor', 'none', 'FaceAlpha', 0, ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');

% 截断小奇异值
annotation('rectangle', [0.65, y1, boxWidth, boxHeight], 'Color', [0.4, 0.6, 0.9], 'LineWidth', 1);
annotation('textbox', [0.65, y1, boxWidth, boxHeight], 'String', '截断小奇异值(σᵢ < 10⁻³)', ...
    'FontSize', 11, 'EdgeColor', 'none', 'FaceAlpha', 0, ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');

% 生成初始解
annotation('rectangle', [0.4, 0.48, boxWidth, boxHeight], 'Color', [0.4, 0.6, 0.9], 'LineWidth', 1);
annotation('textbox', [0.4, 0.48, boxWidth, boxHeight], 'String', '生成初始解r₀', ...
    'FontSize', 11, 'EdgeColor', 'none', 'FaceAlpha', 0, ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');

% 连接箭头
annotation('arrow', [0.35, 0.4], [y1+boxHeight/2, y1+boxHeight/2], 'LineWidth', 1.5, 'Color', 'k');
annotation('arrow', [0.6, 0.65], [y1+boxHeight/2, y1+boxHeight/2], 'LineWidth', 1.5, 'Color', 'k');
annotation('arrow', [0.5, 0.5], [y1, 0.58], 'LineWidth', 1.5, 'Color', 'k');

% 第二阶段标题栏 
annotation('rectangle', [0.15, 0.4, 0.7, 0.1], 'Color', [0.95, 0.6, 0.2], 'FaceColor', [0.95, 0.6, 0.2]);
annotation('textbox', [0.15, 0.4, 0.7, 0.1], 'String', '第二阶段：多初始点混合优化', ...
    'FontSize', 14, 'FontWeight', 'bold', 'Color', 'white', 'EdgeColor', 'none', ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');

% 阶段连接箭头
annotation('arrow', [0.5, 0.5], [0.48, 0.5], 'LineWidth', 1.5, 'Color', 'k');

% 一些关键技术点
annotation('textbox', [0.2, 0.45, 0.3, 0.05], 'String', '• 对张量对角元素设置1.5倍权重系数', ...
    'FontSize', 10, 'EdgeColor', 'none', 'FaceAlpha', 0);
annotation('textbox', [0.55, 0.45, 0.3, 0.05], 'String', '• 提高全局收敛率至>95%', ...
    'FontSize', 10, 'EdgeColor', 'none', 'FaceAlpha', 0);

% 第二阶段流程框
y2 = 0.28;
boxWidth2 = 0.2;
boxHeight2 = 0.09;

% 生成初始点
annotation('rectangle', [0.15, y2, boxWidth2, boxHeight2], 'Color', [0.95, 0.6, 0.2], 'LineWidth', 1);
annotation('textbox', [0.15, y2, boxWidth2, boxHeight2], 'String', '生成15个初始猜测点', ...
    'FontSize', 11, 'EdgeColor', 'none', 'FaceAlpha', 0, ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');

% LM算法
annotation('rectangle', [0.4, y2, boxWidth2, boxHeight2], 'Color', [0.2, 0.7, 0.3], 'LineWidth', 1);
annotation('textbox', [0.4, y2, boxWidth2, boxHeight2], 'String', 'Levenberg-Marquardt算法', ...
    'FontSize', 11, 'EdgeColor', 'none', 'FaceAlpha', 0, ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');

% TR算法
annotation('rectangle', [0.65, y2, boxWidth2, boxHeight2], 'Color', [0.2, 0.7, 0.3], 'LineWidth', 1);
annotation('textbox', [0.65, y2, boxWidth2, boxHeight2], 'String', 'Trust-Region-Reflective算法', ...
    'FontSize', 11, 'EdgeColor', 'none', 'FaceAlpha', 0, ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');

% 连接箭头
annotation('arrow', [0.35, 0.4], [y2+boxHeight2/2, y2+boxHeight2/2], 'LineWidth', 1.5, 'Color', 'k');
annotation('arrow', [0.6, 0.65], [y2+boxHeight2/2, y2+boxHeight2/2], 'LineWidth', 1.5, 'Color', 'k');

% 交替使用
y3 = 0.18;
annotation('rectangle', [0.4, y3, boxWidth2, boxHeight2], 'Color', [0.95, 0.6, 0.2], 'LineWidth', 1);
annotation('textbox', [0.4, y3, boxWidth2, boxHeight2], 'String', '交替使用两种算法', ...
    'FontSize', 11, 'EdgeColor', 'none', 'FaceAlpha', 0, ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');

% 连接箭头
annotation('arrow', [0.5, 0.5], [y2, y3+boxHeight2], 'LineWidth', 1.5, 'Color', 'k');

% 选择最优解和二次精细化
y4 = 0.08;
annotation('rectangle', [0.28, y4, boxWidth2, boxHeight2], 'Color', [0.95, 0.6, 0.2], 'LineWidth', 1);
annotation('textbox', [0.28, y4, boxWidth2, boxHeight2], 'String', '选择最优解', ...
    'FontSize', 11, 'EdgeColor', 'none', 'FaceAlpha', 0, ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');

annotation('rectangle', [0.52, y4, boxWidth2, boxHeight2], 'Color', [0.95, 0.6, 0.2], 'LineWidth', 1);
annotation('textbox', [0.52, y4, boxWidth2, boxHeight2], 'String', '二次精细化优化', ...
    'FontSize', 11, 'EdgeColor', 'none', 'FaceAlpha', 0, ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');

% 二次精细化附注
annotation('textbox', [0.15, 0.17, 0.25, 0.05], 'String', '• 二次精细化降低误差7.5%', ...
    'FontSize', 10, 'EdgeColor', 'none', 'FaceAlpha', 0);

% 连接箭头
annotation('arrow', [0.45, 0.35], [y3, y4+boxHeight2], 'LineWidth', 1.5, 'Color', 'k');
annotation('arrow', [0.45, 0.55], [y4+boxHeight2/2, y4+boxHeight2/2], 'LineWidth', 1.5, 'Color', 'k');

% 最终结果
annotation('textbox', [0.35, y4-0.07, 0.3, 0.05], 'String', '最终定位结果', ...
    'FontSize', 12, 'FontWeight', 'bold', 'EdgeColor', 'none', 'FaceAlpha', 0, ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');

% 连接箭头到最终结果
annotation('arrow', [0.38, 0.4], [y4, y4-0.05], 'LineWidth', 1.5, 'Color', 'k');
annotation('arrow', [0.62, 0.6], [y4, y4-0.05], 'LineWidth', 1.5, 'Color', 'k');

% 保存图像
print('图/optimization_strategy', '-dpng', '-r300');
saveas(gcf, '图/optimization_strategy.png');
disp('优化策略流程图已保存至 图/optimization_strategy.png');

end