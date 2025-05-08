function B = calculate_magnetic_field(r, r0, m, mu0)
% CALCULATE_MAGNETIC_FIELD 计算磁偶极子在空间任意点产生的磁场
%   B = calculate_magnetic_field(r, r0, m, mu0) 返回在位置r处的磁场向量
%
%   输入参数:
%   r  - 观测点位置 [x, y, z]
%   r0 - 磁偶极子位置 [x0, y0, z0]
%   m  - 磁偶极子磁矩 [mx, my, mz]
%   mu0 - 真空磁导率
%
%   输出参数:
%   B  - 磁场向量 [Bx, By, Bz]

    % 计算相对位置向量
    r_prime = r - r0;
    r_prime_norm = norm(r_prime);
    
    % 添加安全检查，防止零除
    if r_prime_norm < 1e-10
        r_prime_norm = 1e-10;
        % 警告但不停止计算
        warning('观测点非常接近磁偶极子位置，计算可能不准确');
    end
    
    % 归一化的相对位置向量
    r_prime_unit = r_prime / r_prime_norm;
    
    % 计算磁矩与相对位置向量的点积
    m_dot_r = dot(m, r_prime_unit);
    
    % 使用更精确的双精度计算
    % B = (µ0/4π) * (3(m·r̂)r̂ - m)/r³
    B = (mu0/(4*pi*r_prime_norm^3)) * (3 * m_dot_r * r_prime_unit - m);
    
    % 额外的精度检查和修正
    % 确保磁场计算结果的数值稳定性
    if any(isnan(B)) || any(isinf(B))
        warning('磁场计算结果包含NaN或Inf值，已替换为0');
        B(isnan(B) | isinf(B)) = 0;
    end
end