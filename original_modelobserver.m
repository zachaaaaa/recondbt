clear all; %close all;

for tt = 1:30
    id_sp_test=randperm(38,13); %[1:ntrain];
    id_sa_test=id_sp_test;
    %     id_sa_test=id_sp_test+38;
    id_sp_tr = setdiff(1:38,id_sp_test);
    id_sa_tr=setdiff(1:38,id_sa_test);
    %     id_sa_tr=setdiff(39:2*38,id_sa_test);
    channel_width = 120/50; %(((120+65)/85)*(120/85))^0.5; %((120+65)/85+120/85)/2; %(120*655/615+65)/85; %(120+15)/85;
    path1 = 'C:\Users\xiduan\microcalcification\diff_detector\ModelObserver_ST35\0.03x20_0.18x5_withFSM_total_TFT2000_postlog_SA75ST35\noMC\';
    path2 = 'noMC_0.03x20_0.18x5_withFSM_total_TFT2000_postlog_SA75ST35_ROI';
    path3 = '_71x71.raw';
    
    path = [path1 path2 num2str(1) path3];
    fin = fopen(path,'r');
    
    tempimg = fread(fin, 71*71 ,'float');
    fclose(fin);
    img0 = reshape(tempimg, 71,71);
    saroi = img0(11:61,11:61); %51*51
    
    %     tempimg = fread(fin, 121*121 ,'float');
    %     fclose(fin);
    %     img0 = reshape(tempimg, 121,121);
    %     saroi = img0(13:99,17:103); %51*51
    
    for ii =2:38
        path = [path1 path2 num2str(ii) path3];
        fin = fopen(path,'r');
        
        tempimg = fread(fin, 71*71 ,'float');
        fclose(fin);
        img = reshape(tempimg, 71,71);
        saroi = cat(3,saroi,img(11:61,11:61));
        
        %         tempimg = fread(fin, 121*121 ,'float');
        %         fclose(fin);
        %         img = reshape(tempimg, 121,121);
        %         saroi = cat(3,saroi,img(13:99,17:103));
        
    end
    
    path4 = 'C:\Users\xiduan\microcalcification\diff_detector\ModelObserver_ST35\0.03x20_0.18x5_withFSM_total_TFT2000_postlog_SA75ST35\withMC\';;
    path5 = 'withMC_0.03x20_0.18x5_withFSM_total_TFT2000_postlog_SA75ST35_ROI';
    
    path6 = '_71x71.raw';
    
    path = [path4 path5 num2str(1) path6];
    fin2 = fopen(path,'r');
    
    tempimg = fread(fin2, 71*71 ,'float');
    fclose(fin2);
    img00 = reshape(tempimg, 71,71);
    sproi = img00(11:61,11:61);
    
    %     tempimg = fread(fin2, 121*121 ,'float');
    %     fclose(fin2);
    %     img00 = reshape(tempimg, 121,121);
    %     sproi = img00(13:99,17:103);
    
    for ii =2:38
        path = [path4 path5 num2str(ii) path6];
        fin2 = fopen(path,'r');
        
        tempimg = fread(fin2, 71*71 ,'float');
        fclose(fin2);
        img = reshape(tempimg, 71,71);
        sproi = cat(3,sproi,img(11:61,11:61));
        
        %         tempimg = fread(fin2, 121*121 ,'float');
        %         fclose(fin2);
        %         img = reshape(tempimg, 121,121);
        %         sproi = cat(3,sproi,img(13:99,17:103));
        
    end
    
    nsa = size(saroi,3); %number of SA cases
    nsp = size(sproi,3); %number of SP cases
    
    %     figure(),
    for nchannel = 1:15
        %         disp(['nchannel = ' num2str(nchannel)]);
        %             [snr(jj-1,nchannel,index), t_sp, t_sa, chimg,tplimg,meanSP,meanSA,meanSig, k_ch]=conv_LG_CHO_2d(saroi(:,:,id_sa_tr), sproi(:,:,id_sp_tr), saroi(:,:,id_sa_test), sproi(:,:,id_sp_test),channel_width,nchannel,1);
        [snr(nchannel,tt), t_sp, t_sa, chimg,tplimg_4(:,:,nchannel,tt),meanSP,meanSA,meanSig, k_ch]=conv_LG_CHO_2d(saroi(:,:,id_sa_tr), sproi(:,:,id_sp_tr), saroi(:,:,id_sa_test), sproi(:,:,id_sp_test),channel_width,nchannel,1);
    end
    %         max_snr2(ii) = max(snr2);
    
    %     subplot(2,4,nchannel), imagesc(tplimg); hold on,
end
%     figure(),
%     subplot(2,2,1), imagesc(chimg(:,:,1));
%     hold on, subplot(2,2,2), imagesc(chimg(:,:,2));
%     hold on, subplot(2,2,3), imagesc(chimg(:,:,3));
%     hold on, subplot(2,2,4), imagesc(chimg(:,:,4));

%     end

snr_ave = mean(snr,2);
std = std(snr(2,:));
figure(), plot(snr_ave);
max(snr_ave)
