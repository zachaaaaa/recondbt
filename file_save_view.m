for ii = 1:49
    img = xartt(:,:,ii);
    % 设置文件名
    filename = sprintf('c4_sart_stepsize_sart_recon_%02d.png', ii);  % 生成文件名
    % 将图像保存为 PNG 文件
    imwrite(img, filename);
end
--------

name = '/Users/patron/Downloads/12.recondbt/c4_sart_0.8_0.06x25_withFSM_total_EN2000_120umMC203040H_3000x900x49.raw';
fin = fopen(name, 'w+');
cnt = fwrite(fin,xartt,'float');
fclose(fin);

