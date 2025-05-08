function plot_magnetic_field(sensor_pos, r0, m, mu0)
% PLOT_MAGNETIC_FIELD 绘制空间磁场分布
%   plot_magnetic_field(sensor_pos, r0, m, mu0) 绘制三维空间中的磁场分布
%   包括磁场矢量和磁场强度等值面
%
%   输入参数:
%   sensor_pos - 传感器位置矩阵 (6 x 3)
%   r0        - 磁偶极子位置 [x0, y0, z0]
%   m         - 磁偶极子磁矩 [mx, my, mz]
%   mu0       - 真空磁导率

    % 创建网格点
    [x, y, z] = meshgrid(linspace(-3, 3, 20));
    
    % 初始化磁场分量矩阵
    Bx = zeros(size(x));
    By = zeros(size(y));
    Bz = zeros(size(z));
    B_mag = zeros(size(x));
    
    % 计算每个网格点的磁场
    for i = 1:size(x, 1)
        for j = 1:size(x, 2)
            for k = 1:size(x, 3)
                r = [x(i,j,k), y(i,j,k), z(i,j,k)];
                B = calculate_magnetic_field(r, r0, m, mu0);
                Bx(i,j,k) = B(1);
                By(i,j,k) = B(2);
                Bz(i,j,k) = B(3);
                B_mag(i,j,k) = norm(B);
            end
        end
    end
    
    % 创建新图窗
    figure('Name', '磁场分布');
    
    % 绘制磁场矢量
    quiver3(x, y, z, Bx, By, Bz, 2, 'b');
    hold on;
    
    % 绘制磁场强度等值面
    isosurface(x, y, z, B_mag, mean(B_mag(:)));
    isocolors(x, y, z, B_mag);
    
    % 绘制传感器位置
    scatter3(sensor_pos(:,1), sensor_pos(:,2), sensor_pos(:,3), 100, 'r', 'filled');
    
    % 绘制磁偶极子位置
    scatter3(r0(1), r0(2), r0(3), 200, 'g', 'filled');
    
    % 添加图例
    legend('磁场矢量', '等值面', '传感器', '磁偶极子', 'Location', 'best');
    
    % 设置坐标轴标签
    xlabel('X (m)');
    ylabel('Y (m)');
    zlabel('Z (m)');
    
    % 设置坐标轴等比例
    axis equal;
    grid on;
    
    % 添加标题
    title('空间磁场分布');
    
    % 设置光照
    lighting gouraud;
    camlight;
    alpha(0.3);
    
    % 调整视角
    view(45, 30);
end