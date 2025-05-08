function B_noisy = add_noise(B, sigma)
% ADD_NOISE 为磁场测量值添加高斯白噪声
%   B_noisy = add_noise(B, sigma) 返回添加噪声后的磁场测量值
%
%   输入参数:
%   B     - 原始磁场测量矩阵 (N x 3)
%   sigma - 噪声标准差
%
%   输出参数:
%   B_noisy - 含噪声的磁场测量矩阵 (N x 3)

    % 生成与输入矩阵相同大小的高斯白噪声
    noise = sigma * randn(size(B));
    
    % 将噪声添加到原始信号
    B_noisy = B + noise;
end