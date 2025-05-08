function [trace_T, det_T] = extract_tensor_invariants(T)
% EXTRACT_TENSOR_INVARIANTS 提取磁场梯度张量的不变量
%   [trace_T, det_T] = extract_tensor_invariants(T) 计算张量的迹和行列式
%
%   输入参数:
%   T       - 磁场梯度张量 (3 x 3)
%
%   输出参数:
%   trace_T - 张量的迹
%   det_T   - 张量的行列式

    % 计算张量的迹（对角线元素之和）
    trace_T = trace(T);
    
    % 计算张量的行列式
    det_T = det(T);
    
    % 验证迹是否接近于0（磁偶极子模型的特性）
    if abs(trace_T) > 1e-10
        warning('张量的迹不为0，可能存在测量误差或计算误差');
    end
end