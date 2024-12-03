clear all
g = zeros(3000, 1504, 25);  % 用于存储最终的投影数据
deg = -50:2.08333:50;  % 投影角度
I0 = zeros(3000, 1504, 25);
pre_set1 = dir('/Users/patron/Downloads/C1_0.06x25_withFSM/*.raw');  % 投影数据路径
blank_set = dir('/Users/patron/Downloads/C1_blank/*.raw');  % blank 数据路径
for ii = 1:25
    disp(ii);
    % 读取当前投影图像
    pre_name = pre_set1(ii).name;
    fin1 = fopen(['/Users/patron/Downloads/C1_0.06x25_withFSM/', pre_name], 'r');
    pre_temp = fread(fin1, 3000*1504*2, 'float');
    pre0 = reshape(pre_temp, 3000, 1504, 2);
    pre = 0.001469 * flipud(pre0(:,:,1)) * (6/6);  % 处理投影图像
    % 读取对应的 blank 图像
    blank_name = blank_set(ii).name;
    fin2 = fopen(['/Users/patron/Downloads/C1_blank/', blank_name], 'r');
    blank_temp = fread(fin2, 3000*1504*2, 'float');
    blank0 = reshape(blank_temp, 3000, 1504, 2);
    blank = 0.001469 * flipud(blank0(:,:,1));  % 处理 blank 图像
    % 对每个投影图像进行归一化
    I_norm = pre ./ blank;  % 使用当前的 blank 图像进行归一化
    % 计算衰减数据 g_temp
    g_temp = -log(I_norm);  % 求对数，得到衰减值
    g(:,:,ii) = g_temp;  % 存储当前视角的衰减数据
    I0(:,:,ii) = blank; % 很关键的一步，在ml算法中会用到
    %proj = I0 * exp(-g);%投影数据吗
    % 设置 I0 为当前视角的 blank 图像
    %I0 = blank;  % 每个视角对应的 I0 即为该视角的 blank 图像
    % 这里调用 ML_dbt 时，传递 g 和 I0 数据
    % 假设 ML_dbt 函数的参数是 g, I0 等
    % [img, cost] = ML_dbt(Gt, g, x0, I0, niter, stepsize, saveiter);
end
%
g(find(g==inf)) = 0.5;
%==================================
%User Defines the scanner geometry
%==================================
 dso = 60.8; %in cm: dist. from the source to the rotation center
 dod = 4.75;  %in cm: dist. from the rotation center to the detector
 dsd = dso+dod; %in cm: dist. from source to the detector
 
 orbit = 50;  %in degree: angular span
 na = size(g,3); %number of projection views
 ds = 0.0085; %0.005; %in cm: detector element pixel size in the 's' direction; 
 dt = 0.0085; %0.005; %in cm: detector element pixel size in the 's' direction; 
            %'s', the x-ray tube moving direction, positive pointing toward right.           
            %'t', the perpendicular direction to 's' direction, positive pointing toward the nipple.            
 
 ns = size(g,1); %number of detector elements in the 's' direction
 nt = size(g,2); %number of detector elements in the 's' direction
 offset_s = 0; %detector center offset along the 's' direction in pixels relative to the tube rotation center
 offset_t = -nt/2; % detector center offset along the 't' direction in pixels relative to the tube rotation center
 d_objbottom_det = 1.545;%in cm,the distance from the bottom of the object to the center detector.
%=======================================
%User defines the recon volume geometry:
%=======================================
%%treat the x-ray tube rotation center as the origin of the 3D coordinate
%%system ( see the coordinate system sketch in the instruction document)
%x: posive direction points toward right, 
%y: positive direction points toward the nipple
%z: positive direction points toward the x-ray source
% voxel size (drx, dry, drz) in cm, 
% dimensions (nrx, nry, nrz) and 
% FOV center offsets (offset_x, offset_y, offset_z): in pixels relative to the rotation center.
% For example, if the coordinates of the FOV center is (xctr, yctr, zctr) relative tothe rotation center,
% then offset_x=-xctr, offset_y=-yctr and offset_z=-zctr.
% nrx      = 2706;
% nry      = 1402;
% drx      = 0.0085;  
nrx      = 3000; %for detectors in 85um pixel size
nry      = 1504; %for detectors in 85um pixel size
drx      = 0.0085; %for detectors in 85um pixel size
% nrx      = 5100; %for detectors in 50um pixel size
% nry      = 2000; %for detectors in 50um pixel size
% drx      = 0.005; %for detectors in 50um pixel size
dry      = drx; 
drz      = 0.1; 
nrz      = 49; 
offset_x = 0; %in pixels
offset_y = -nry/2;% in pixels. 0 for full cone, -nry/2 for half cone
zfov     = nrz*drz;
offset_z = (dod - (zfov/2 + d_objbottom_det-drz/2))/drz; %in pixels: offset of the volume ctr to the rotation ctr in the z direction; 
 %===================
 %Reconstruction
 %===================
 %Generate the system matrix                          
igr = image_geom('nx', nrx, 'ny',nry, 'nz', nrz, 'dx',drx, 'dz', drz,...
       'offset_y', offset_y,'offset_z', offset_z,'down', 1);  
btg = bt_geom('arc', 'ns', ns, 'nt', nt, 'na', na, ...
		'ds', ds, ...%'dt', dv, ... defautly dt = -ds;
		'down', 1, ...
        'orbit_start', 0, ...
        'orbit', orbit,...
        'offset_s', 0, ...  
		'offset_t', offset_t, ...
  		'dso', dso, 'dod', dod, 'dfs',inf);      
Gtr = Gtomo_syn(btg,igr);
%FBP reconstruction
disp 'FBP'
tic
xfbp = fbp_dbt(Gtr,btg,igr, g,'hann75');
toc
xfbp2 = xfbp(:,1:900,:);
% xfbp2 = xfbp(:,1:1530,:);
name = '/Users/patron/Downloads/12.recondbt';
fin = fopen(name, 'w+');
cnt = fwrite(fin,xfbp2,'float');
fclose(fin);
% SART reconstruction
xbp = BP(Gtr, g); % initialization for SART
disp(size(xbp));
disp 'SART'
tic
[xartt, costart] = SART_dbt(Gtr, g, xbp, 2, 0.5);
[xartt, costart] = SART_dbt(Gtr,g,zeros(3000, 1504, 49),2,0.5);
disp 'SART time '
toc
% ML recosntruction
xbp = BP(Gtr, g);
disp 'ML'
tic
[xmlt, costml] = ML_dbt(Gtr,g,xbp,I0,3,0.5);
disp 'ML time'
toc
disp 'Recon completed';
--------------------
img = xmlt(:,:,8);  % 获取第 ii 个切片
imshow(img, []);  % 使用 imshow 显示图像，[] 会自动根据图像数据调整显示范围
