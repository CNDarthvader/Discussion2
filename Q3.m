function discrete_frequency_response()
    % 离散系统频率响应分析程序
    % 功能：分析并绘制离散系统的频率响应
    % 系统传递函数：H(z) = z^2 / (z^2 - (3/4)z + 1/8)
    
    % 清空工作空间和命令窗口
    clear;
    clc;
    
    % ====== 参数设置 ======
    params.N = 32;          % 频率点数
    params.phase_opt = 'unwrap';    % 相位显示选项：'wrap' 或 'unwrap'
    params.magnitude_opt = 'db';    % 幅度显示选项：'db' 或 'linear'
    
    % ====== 系统定义 ======
    % 定义系统的分子和分母多项式系数
    num = [1 0 0];          % z^2
    den = [1 -3/4 1/8];     % z^2 - (3/4)z + 1/8
    
    try
        % ====== 频率响应计算 ======
        [H, w] = calculate_response(num, den, params);
        
        % ====== 绘制频率响应 ======
        plot_response(H, w, params);
        
        % ====== 分析系统特性 ======
        analyze_system(H, w);
        
    catch ME
        fprintf('错误：%s\n', ME.message);
        return;
    end
    
    end
    
    function [H, w] = calculate_response(num, den, params)
    % 计算频率响应
    
    % 创建频率向量
    w = linspace(0, pi, params.N);
    z = exp(1j * w);
    
    % 计算频率响应
    H = polyval(num, z) ./ polyval(den, z);
    
    % 验证计算结果
    if any(isnan(H)) || any(isinf(H))
        error('频率响应计算出现无效值');
    end
    end
    
    function plot_response(H, w, params)
    % 绘制频率响应图
    
    % 计算幅频响应
    if strcmp(params.magnitude_opt, 'db')
        magnitude = 20 * log10(abs(H));
        mag_label = '幅度 (dB)';
    else
        magnitude = abs(H);
        mag_label = '幅度';
    end
    
    % 计算相频响应
    if strcmp(params.phase_opt, 'unwrap')
        phase = unwrap(angle(H)) * 180 / pi;
    else
        phase = angle(H) * 180 / pi;
    end
    
    % 创建图窗
    fig = figure('Position', [100, 100, 800, 600]);
    
    % 绘制幅频响应
    subplot(2,1,1);
    stem(w/pi, magnitude, 'filled', 'LineWidth', 1.5);
    grid on;
    xlabel('归一化频率 (\omega/\pi)');
    ylabel(mag_label);
    title('幅频响应');
    
    % 绘制相频响应
    subplot(2,1,2);
    stem(w/pi, phase, 'filled', 'LineWidth', 1.5);
    grid on;
    xlabel('归一化频率 (\omega/\pi)');
    ylabel('相位 (度)');
    title('相频响应');
    
    % 添加图形美化
    set(findall(gcf,'type','axes'),'FontSize',10);
    set(findall(gcf,'type','text'),'FontSize',10);
    
    % 启用数据光标
    dcm = datacursormode(fig);
    set(dcm, 'UpdateFcn', @custom_datatip);
    end
    
    function analyze_system(H, w)
    % 分析系统特性
    
    % 计算幅频特性
    magnitude_db = 20 * log10(abs(H));
    
    % 计算关键频率点的响应
    key_freqs = [0 pi/4 pi/2 3*pi/4 pi];
    key_freq_names = {'0', 'π/4', 'π/2', '3π/4', 'π'};
    
    fprintf('\n====== 系统频率响应分析 ======\n\n');
    
    for i = 1:length(key_freqs)
        idx = find(abs(w - key_freqs(i)) == min(abs(w - key_freqs(i))), 1);
        fprintf('频率 ω = %s:\n', key_freq_names{i});
        fprintf('  幅度: %.2f dB\n', magnitude_db(idx));
        fprintf('  相位: %.2f 度\n\n', angle(H(idx)) * 180 / pi);
    end
    
    % 分析系统特性
    [max_gain, max_idx] = max(magnitude_db);
    fprintf('系统特性：\n');
    fprintf('  最大增益: %.2f dB 在 ω = %.4f π\n', max_gain, w(max_idx)/pi);
    
    % 查找-3dB点
    db_3 = magnitude_db - max_gain;
    crossings = find(abs(db_3 + 3) == min(abs(db_3 + 3)));
    if ~isempty(crossings)
        fprintf('  最接近-3dB的频点：ω = %.4f π\n', w(crossings(1))/pi);
    end
    end
    
    function txt = custom_datatip(~, event_obj)
    % 自定义数据提示
    pos = get(event_obj, 'Position');
    txt = {sprintf('频率: %.3fπ', pos(1)),...
           sprintf('数值: %.2f', pos(2))};
    end
    