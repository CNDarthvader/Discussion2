% 清空工作空间和命令窗口
clear;
clc;

% 定义分子和分母的系数向量
num = [2 16 44 56 32];
den = [3 3 -15 18 -12];

% 使用 residuez 函数求部分分式展开
[r, p, k] = residuez(num, den);

% 显示结果
fprintf('部分分式展开结果：\n\n');

% 格式化复数输出
for i = 1:length(r)
    fprintf('极点 p%d = %s\n', i, format_complex(p(i)));
    fprintf('留数 r%d = %s\n\n', i, format_complex(r(i)));
end

% 如果有直接项，显示直接项
if ~isempty(k)
    fprintf('直接项 k = ');
    disp(k);
end

% 构建完整的展开式字符串
expansion = '展开式:X(z) = ';
for i = 1:length(r)
    if i > 1
        expansion = [expansion ' + '];
    end
    expansion = [expansion sprintf('(%s)/(z-(%s))', ...
        format_complex(r(i)), format_complex(p(i)))];
end

% 显示完整展开式
fprintf('\n%s\n', expansion);

% 验证结果
fprintf('\n验证结果:\n');
[num_test, den_test] = zp2tf(p, [], 1);  % 获取分母多项式

% 初始化 num_recovered 为与 num_test 相同长度的零向量
num_recovered = zeros(1, length(num_test));

% 如果有直接项，加入直接项的影响
if ~isempty(k)
    num_recovered = k * num_test;
end

for i = 1:length(r)
    % 计算每个部分分式项
    current_num = r(i) * conv(deconv(num_test, [1, -p(i)]), [1]);
    
    % 确保两个向量长度相同
    if length(current_num) < length(num_recovered)
        current_num = [current_num, zeros(1, length(num_recovered) - length(current_num))];
    elseif length(current_num) > length(num_recovered)
        num_recovered = [num_recovered, zeros(1, length(current_num) - length(num_recovered))];
    end
    
    % 累加结果
    num_recovered = num_recovered + current_num;
end

% 比较系数
num_recovered = round(real(num_recovered), 6);  % 取实部并四舍五入
num_original = conv(num, den_test);

% 调整向量长度使其相等
max_length = max(length(num_original), length(num_recovered));
num_original = [num_original, zeros(1, max_length - length(num_original))];
num_recovered = [num_recovered, zeros(1, max_length - length(num_recovered))];

if isequal(round(num_original, 6), round(num_recovered, 6))
    fprintf('验证成功：展开式正确！\n');
else
    fprintf('警告：展开式可能有误，请检查计算过程。\n');
end

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

