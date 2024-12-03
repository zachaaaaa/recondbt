clear all;
for tt = 1:30
    id_sp_test = randperm(10, 8); % 随机选_个作为测试集
    id_sa_test = id_sp_test;
    id_sp_tr = setdiff(1:10, id_sp_test); % 剩下的作为训练集
    id_sa_tr = setdiff(1:10,id_sa_test);
    channel_width = 120 / 50; 
    % 路径设置
    path1 = '/Users/patron/Downloads/no_MC/slice_';
    path3 = '.raw';
    % 读取第一个文件
    path = [path1 num2str(1) path3]; & 这个1是第一个数据文件后面的索引
    fin = fopen(path, 'r');
    tempimg = fread(fin, 71*71, 'float');
    fclose(fin);
    img0 = reshape(tempimg, 71, 71);
    saroi = img0(11:61, 11:61); % 提取ROI
    % 读取剩余文件（从2到21）&这个不同的文件集有不同的索引，到时候再说吧
    for ii = 2:21
        path = [path1 num2str(ii) path3];
        fin = fopen(path, 'r');
        tempimg = fread(fin, 71*71, 'float');
        fclose(fin);
        img = reshape(tempimg, 71, 71);
        saroi = cat(3, saroi, img(11:61, 11:61)); % 拼接ROI
    end
    % 读取文件32到49
    for ii = 33:49
        path = [path1 num2str(ii) path3];
        fin = fopen(path, 'r');
        tempimg = fread(fin, 71*71, 'float');
        fclose(fin);
        img = reshape(tempimg, 71, 71);
        saroi = cat(3, saroi, img(11:61, 11:61)); % 拼接ROI
    end
    % 第二组路径
    path4 = '/Users/patron/Downloads/with_MC/slice_';
    path6 = '.raw';
    % 读取第一个文件
    path = [path4 num2str(22) path6];
    fin2 = fopen(path, 'r');
    tempimg = fread(fin2, 71*71, 'float');
    fclose(fin2);
    img00 = reshape(tempimg, 71, 71);
    sproi = img00(11:61, 11:61); % 提取ROI
    % 读取文件（从2到21）
    for ii = 22:32
        path = [path4 num2str(ii) path6];
        fin2 = fopen(path, 'r');
        tempimg = fread(fin2, 71*71, 'float');
        fclose(fin2);
        img = reshape(tempimg, 71, 71);
        sproi = cat(3, sproi, img(11:61, 11:61)); % 拼接ROI
    end
    nsa = size(saroi, 3); % SA文件数量
    nsp = size(sproi, 3); % SP文件数量
    % 计算SNR
    for nchannel = 1:15
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
