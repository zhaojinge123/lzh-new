function plot_convergence(cost_history)
% PLOT_CONVERGENCE 绘制优化算法的收敛过程
%   plot_convergence(cost_history) 绘制代价函数随迭代次数的变化曲线
%
%   输入参数:
%   cost_history - 优化过程中的代价函数历史记录

    % 创建新图窗
    figure('Name', '收敛过程');
    
    % 绘制收敛曲线
    semilogy(1:length(cost_history), cost_history, 'b-', 'LineWidth', 2);
    
    % 设置坐标轴标签
    xlabel('迭代次数');
    ylabel('代价函数值（对数尺度）');
    
    % 添加网格
    grid on;
    
    % 添加标题
    title('优化算法收敛过程');
    
    % 设置y轴为对数尺度
    set(gca, 'YScale', 'log');
end