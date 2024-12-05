withMC_folder = '/Users/patron/Downloads/12.5with/';
noMC_folder = '/Users/patron/Downloads/12.5no/';
% 将含微钙化的切片（22-32）存储到 withMC 文件夹
% 第一轮循环，存储 12 到 25 的切片
for i = 12:25
    slice_data = data(:,:,i);  % 提取第 i 个切片
    filename = fullfile(withMC_folder, sprintf('slice_%d.raw', i));  % 创建文件名
    fid = fopen(filename, 'wb');  % 打开文件
    fwrite(fid, slice_data, 'float');  % 写入数据（假设数据类型为 float）
    fclose(fid);  % 关闭文件
end
% 第二轮循环，存储 26 到 39 的切片
for i = 26:39
    slice_data = data(:,:,mod(i-1, 14) + 12);  % 循环使用 12 到 25 的切片
    filename = fullfile(withMC_folder, sprintf('slice_%d.raw', i));  % 创建文件名
    fid = fopen(filename, 'wb');  % 打开文件
    fwrite(fid, slice_data, 'float');  % 写入数据（假设数据类型为 float）
    fclose(fid);  % 关闭文件
end
% 第三轮循环，存储 40 到 49 的切片，使用 12 到 25 的切片
for i = 40:49
    slice_data = data(:,:,mod(i-1, 14) + 12);  % 循环使用 12 到 25 的切片
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
for i = 50:53
    slice_data = data(:,:,mod(i-1, 3) + 1);  % 循环使用 1 到 3 的切片
    filename = fullfile(noMC_folder, sprintf('slice_%d.raw', i));  % 创建文件名
    fid = fopen(filename, 'wb');  % 打开文件
    fwrite(fid, slice_data, 'float');  % 写入数据
    fclose(fid);  % 关闭文件
end
end
