% 文件路径
filename = '/Users/patron/Downloads/12.recondbt/0.06x25_withFSM_total_EN2000_120umMC203040H_blankimgcorr_postlog_SA75_3000x900x49.raw';
% 数据维度
dims = [3000, 900, 49];  % 确保与保存时的维度一致
% 数据类型
datatype = 'float';  % 确保与保存时的类型一致（这里是单精度浮点型）
% 打开文件
fid = fopen(filename, 'r');
% 检查文件是否成功打开
if fid == -1
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
withMC_folder = '/Users/patron/Downloads/with_MC/';
noMC_folder = '/Users/patron/Downloads/no_MC/';
% 将含微钙化的切片（22-32）存储到 withMC 文件夹
for i = 22:32
    slice_data = data(:,:,i);  % 提取第 i 个切片
    filename = fullfile(withMC_folder, sprintf('slice_%d.raw', i));  % 创建文件名
    fid = fopen(filename, 'wb');  % 打开文件
    fwrite(fid, slice_data, 'float');  % 写入数据（假设数据类型为 float）
    fclose(fid);  % 关闭文件
end
% 将没有微钙化的切片（其他切片）存储到 noMC 文件夹
for i = [1:21, 33:49]
    slice_data = data(:,:,i);  % 提取第 i 个切片
    filename = fullfile(noMC_folder, sprintf('slice_%d.raw', i));  % 创建文件名
    fid = fopen(filename, 'wb');  % 打开文件
    fwrite(fid, slice_data, 'float');  % 写入数据
    fclose(fid);  % 关闭文件
end
