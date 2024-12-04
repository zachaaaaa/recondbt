
% 文件路径
filename = '/Users/patron/Documents/MATLAB/modelobserver/12.recondbt/c5_sart_2_0.5_0.06x25_withFSM_total_EN2000_120umMC203040H_3000x900x49.raw';
% 数据维度
dims = [3000, 900, 49];  % 确保与保存时的维度一致
% 数据类型
datatype = 'float';  % 确保与保存时的类型一致（这里是单精度浮点型）
% 打开文件
fid = fopen(filename, 'r');
% 检查文件是否成功打开
if fin2 == -1
    error('Failed to open file. Check the file path.');
end
% 按数据类型读取文件内容
data = fread(fid, prod(dims), datatype);
% 关闭文件
fclose(fid);
% 将数据从一维重构为三维矩阵
data = reshape(data, dims);
% 验证数据尺寸
disp(size(data));  % 应显示 [3000, 900, 49]
-------
% 查看第25层
slice = data(:, :, 25);
% 可视化切片
imagesc(slice);
colormap('gray');
colorbar;
title('Slice 25');
-------
% 假设你的三维数据为 data，大小为 3000x900x49
% 将切片存储到对应的文件夹
withMC_folder = '/Users/patron/Downloads/12.4_c5_2_0.5_sart_with/';
noMC_folder = '/Users/patron/Downloads/12.4_c5_2_0.5_sart_no/';
% 将含微钙化的切片（22-32）存储到 withMC 文件夹
for i = 12:25
    slice_data = data(:,:,i);  % 提取第 i 个切片
    filename = fullfile(withMC_folder, sprintf('slice_%d.raw', i));  % 创建文件名
    fid = fopen(filename, 'wb');  % 打开文件
    fwrite(fid, slice_data, 'float');  % 写入数据（假设数据类型为 float）
    fclose(fid);  % 关闭文件
end
% 将没有微钙化的切片（其他切片）存储到 noMC 文件夹
for i = [1:11, 26:49]
    slice_data = data(:,:,i);  % 提取第 i 个切片
    filename = fullfile(noMC_folder, sprintf('slice_%d.raw', i));  % 创建文件名
    fid = fopen(filename, 'wb');  % 打开文件
    fwrite(fid, slice_data, 'float');  % 写入数据
    fclose(fid);  % 关闭文件
end


--------- 200-500最大



clear all;
for tt = 1:30
    id_sp_test = randperm(38, 13); % 随机选_个作为测试集
    id_sa_test = id_sp_test;
    id_sp_tr = setdiff(1:38, id_sp_test); % 剩下的作为训练集
    id_sa_tr = setdiff(1:38,id_sa_test);
    channel_width = 120 / 50; 
    % 路径设置
    path1 = '/Users/patron/Downloads/12.4_c5_2_0.5_sart_no/slice_';
    path3 = '.raw';
    % 读取第一个文件
    path = [path1 num2str(1) path3]; %这个1是第一个数据文件后面的索引
    fin = fopen(path, 'r');
    tempimg = fread(fin, 900*900 , 'float');
    fclose(fin);
    img0 = reshape(tempimg, 900, 900);
    saroi = img0(200:475, 200:475); % 提取ROI
    % 读取剩余文件（从2到21）&这个不同的文件集有不同的索引，到时候再说吧
    for ii = 2:11
        path = [path1 num2str(ii) path3];
        fin = fopen(path, 'r');
        tempimg = fread(fin, 900*900, 'float');
        fclose(fin);
        img = reshape(tempimg, 900, 900);
        saroi = cat(3, saroi, img(200:475, 200:475)); % 拼接ROI
    end
    % 读取文件32到49
    for ii = 26:52
        path = [path1 num2str(ii) path3];
        fin = fopen(path, 'r');
        tempimg = fread(fin, 900*900 , 'float');
        fclose(fin);
        img = reshape(tempimg, 900, 900);
        saroi = cat(3, saroi, img(200:475, 200:475)); % 拼接ROI
    end
    % 第二组路径
    path4 = '/Users/patron/Downloads/12.4_c5_2_0.5_sart_with/slice_';
    path6 = '.raw';
    % 读取第一个文件
    path = [path4 num2str(12) path6];
    fin2 = fopen(path, 'r');
    tempimg = fread(fin2, 900*900 ,'float');
    fclose(fin2);
    img00 = reshape(tempimg, 900,900);
    sproi = img00(200:475, 200:475); % 提取ROI
    % 读取文件（从2到21）
    for ii = 13:50
        path = [path4 num2str(ii) path6];
        fin2 = fopen(path, 'r');
        tempimg = fread(fin2, 900*900 ,'float');
        fclose(fin2);
        img = reshape(tempimg, 900, 900);
        sproi = cat(3, sproi, img(200:475, 200:475)); % 拼接ROI
    end
    nsa = size(saroi, 3); % SA文件数量
    nsp = size(sproi, 3); % SP文件数量
    % 计算SNR
    for nchannel = 1:5
        [snr(nchannel, tt), t_sp, t_sa, chimg, tplimg_4(:,:,nchannel,tt), meanSP, meanSA, meanSig, k_ch] = ...
            conv_LG_CHO_2d(saroi(:,:,id_sa_tr), sproi(:,:,id_sp_tr), ...
                           saroi(:,:,id_sa_test), sproi(:,:,id_sp_test), ...
                           channel_width, nchannel, 1);
    end
end
% 计算SNR平均值并绘图
snr_ave = mean(snr, 2);
figure(), plot(snr_ave);
disp(['Max SNR: ', num2str(max(snr_ave))]);


disp(nsa)
disp(nsp)
