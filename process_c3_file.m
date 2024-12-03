clear all
g = zeros(3000, 1504, 25);  % 用于存储最终的投影数据
deg = -50:2.08333:50;  % 投影角度
I0 = zeros(3000, 1504, 25);
pre_set1 = dir('/Users/patron/Downloads/c3/C3_0.03x25_noFSM/*.raw');  % 投影数据路径
pre_set2 = dir('/Users/patron/Downloads/c3/C3_0.14x7_noFSM/*.raw');
blank_set = dir('/Users/patron/Downloads/c2/C2_C3_blank/*.raw');  % blank 数据路径
for ii = 1:25
    disp(['Processing slice: ', num2str(ii)]);
    if ii >= 1 && ii <= 9
        pre_name = pre_set1(ii).name;
        disp(['Reading from: ', pre_name]);
        fin1 = fopen(['/Users/patron/Downloads/c3/C3_0.03x25_noFSM/', pre_name], 'r');
        pre_temp = fread(fin1, 3000*1504*2, 'float');
        pre0 = reshape(pre_temp, 3000, 1504, 2);
        pre = 0.001469 * flipud(pre0(:,:,1)) * (6/6);  % 处理投影图像
    elseif ii >= 10 && ii <= 16
        pre_name = pre_set2(ii-9).name;
        disp(['Reading from: ', pre_name]);
        fin2 = fopen(['/Users/patron/Downloads/c3/C3_0.14x7_noFSM/', pre_name], 'r');
        pre_temp = fread(fin2, 3000*1504*2, 'float');
        pre0 = reshape(pre_temp, 3000, 1504, 2);
        pre = 0.001469 * flipud(pre0(:,:,1)) * (6/6);  % 处理投影图像
    else
        pre_name = pre_set1(ii).name;
        disp(['Reading from: ', pre_name]);
        fin1 = fopen(['/Users/patron/Downloads/c3/C3_0.03x25_noFSM/', pre_name], 'r');
        pre_temp = fread(fin1, 3000*1504*2, 'float');
        pre0 = reshape(pre_temp, 3000, 1504, 2);
        pre = 0.001469 * flipud(pre0(:,:,1)) * (6/6);  % 处理投影图像
    end
    % 读取对应的 blank 图像
    blank_name = blank_set(ii).name;
    disp(['Reading blank: ', blank_name]);
    fin3 = fopen(['/Users/patron/Downloads/c2/C2_C3_blank/', blank_name], 'r');
    blank_temp = fread(fin3, 3000*1504*2, 'float');
    blank0 = reshape(blank_temp, 3000, 1504, 2);
    blank = 0.001469 * flipud(blank0(:,:,1));  % 处理 blank 图像
    % 计算衰减数据 g_temp
    I_norm = pre ./ blank;  % 使用当前的 blank 图像进行归一化
    g_temp = -log(I_norm);  % 求对数，得到衰减值
    g(:,:,ii) = g_temp;  % 存储当前视角的衰减数据
    I0(:,:,ii) = blank;  % 存储当前视角的 blank 图像
    disp(['Finished slice: ', num2str(ii)]);
end
