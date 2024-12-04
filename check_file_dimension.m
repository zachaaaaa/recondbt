fid = fopen('your_data.raw', 'rb');
data = fread(fid, [x_dim, y_dim, z_dim], 'datatype');
fclose(fid);
dims = size(data);
disp(dims);
