% 清空工作空间和命令窗口
clear;
clc;

% 定义系统的分子和分母多项式系数
num = [1 0 0];          % z^2
den = [1 -3/4 1/8];     % z^2 - (3/4)z + 1/8

% 创建离散频率点 (使用较少的点以显示离散特性)
N = 32;  % 频率点数
w = linspace(0, pi, N);

% 计算频率响应
z = exp(1j * w);
H = polyval(num, z) ./ polyval(den, z);

% 计算幅频响应（以分贝为单位）和相频响应（以度为单位）
magnitude_db = 20 * log10(abs(H));
phase_deg = angle(H) * 180 / pi;

% 创建子图1：幅频特性
subplot(2,1,1);
stem(w/pi, magnitude_db, 'filled', 'LineWidth', 1.5);
grid on;
xlabel('归一化频率 (\omega/\pi)');
ylabel('幅度 (dB)');
title('幅频响应');

% 创建子图2：相频特性
subplot(2,1,2);
stem(w/pi, phase_deg, 'filled', 'LineWidth', 1.5);
grid on;
xlabel('归一化频率 (\omega/\pi)');
ylabel('相位 (度)');
title('相频响应');

% 添加一些图形美化
set(gcf, 'Position', [100, 100, 800, 600]);  % 设置图窗大小

% 计算并显示关键频率点的响应
fprintf('频率响应的关键点：\n\n');

% 计算0、π/4、π/2、3π/4和π处的响应
key_freqs = [0 pi/4 pi/2 3*pi/4 pi];
key_freq_names = {'0', 'π/4', 'π/2', '3π/4', 'π'};

for i = 1:length(key_freqs)
    z_key = exp(1j * key_freqs(i));
    H_key = polyval(num, z_key) / polyval(den, z_key);
    mag_db = 20 * log10(abs(H_key));
    phase = angle(H_key) * 180 / pi;
    
    fprintf('在 ω = %s:\n', key_freq_names{i});
    fprintf('幅度: %.2f dB\n', mag_db);
    fprintf('相位: %.2f 度\n\n', phase);
end

% 计算系统的一些特性
fprintf('系统特性：\n');

% 计算最大增益和对应频率
[max_gain, max_idx] = max(magnitude_db);
max_freq = w(max_idx);
fprintf('最大增益: %.2f dB 在 ω = %.4f π\n', max_gain, max_freq/pi);

% 找出最接近-3dB的点
db_3 = magnitude_db - max_gain;
[~, idx_3db] = min(abs(db_3 + 3));
if ~isempty(idx_3db)
    fprintf('最接近-3dB的频点：ω = %.4f π\n', w(idx_3db)/pi);
end
