% 清空工作空间和命令窗口
clear;
clc;

% 定义系统的分子和分母多项式系数
num = [2 -1.6 -0.9];    % 分子系数：2z^2 - 1.6z - 0.9
den = [1 -2.5 1.96 -0.48];  % 分母系数：z^3 - 2.5z^2 + 1.96z - 0.48

% 计算零点和极点
zeros = roots(num);  % 计算零点
poles = roots(den);  % 计算极点

% 创建新图窗
figure;
hold on;

% 绘制单位圆
theta = linspace(0, 2*pi, 100);
plot(cos(theta), sin(theta), 'k--');  % 绘制虚线单位圆

% 绘制零点和极点
zeroPlot = plot(real(zeros), imag(zeros), 'o', 'MarkerSize', 10);  % 零点用圆圈表示
polePlot = plot(real(poles), imag(poles), 'x', 'MarkerSize', 10);  % 极点用叉表示

% 添加图例
legend([zeroPlot, polePlot], '零点', '极点');

% 设置坐标轴
grid on;
axis equal;
xlabel('实部');
ylabel('虚部');
title('系统零极点图');

% 添加坐标轴
axisLength = max(max(abs([real(zeros); imag(zeros); real(poles); imag(poles)]))) + 0.2;
axis([-axisLength axisLength -axisLength axisLength]);
plot([-axisLength axisLength], [0 0], 'k-', 'LineWidth', 0.5);  % x轴
plot([0 0], [-axisLength axisLength], 'k-', 'LineWidth', 0.5);  % y轴

% 判断系统稳定性
fprintf('\n系统极点：\n');
for i = 1:length(poles)
    fprintf('p%d = %s\n', i, format_complex(poles(i)));
end

fprintf('\n系统零点：\n');
for i = 1:length(zeros)
    fprintf('z%d = %s\n', i, format_complex(zeros(i)));
end

% 判断稳定性
isStable = all(abs(poles) < 1);
fprintf('\n稳定性分析：\n');
if isStable
    fprintf('系统稳定：所有极点都位于单位圆内。\n');
else
    fprintf('系统不稳定：存在极点位于单位圆外或单位圆上。\n');
    % 显示不稳定极点
    unstablePoles = poles(abs(poles) >= 1);
    fprintf('不稳定极点：\n');
    for i = 1:length(unstablePoles)
        fprintf('p = %s, |p| = %.4f\n', format_complex(unstablePoles(i)), abs(unstablePoles(i)));
    end
end

% 1. 添加稳定裕度计算
margin = 1 - max(abs(poles));
fprintf('稳定裕度：%.4f\n', margin);

% 2. 添加交互式功能
datacursormode on;  % 允许用鼠标查看具体点的值

% 3. 添加系统类型判断
system_type = '';
if all(abs(poles) < 1)
    if any(abs(poles) > 0.95)
        system_type = '临界稳定';
    else
        system_type = '渐进稳定';
    end
else
    system_type = '不稳定';
end
fprintf('系统类型：%s\n', system_type);

% 辅助函数：格式化复数输出
function str = format_complex(z)
    if imag(z) == 0
        str = sprintf('%.4f', real(z));
    elseif real(z) == 0
        str = sprintf('%.4fi', imag(z));
    elseif imag(z) < 0
        str = sprintf('%.4f - %.4fi', real(z), -imag(z));
    else
        str = sprintf('%.4f + %.4fi', real(z), imag(z));
    end
end

