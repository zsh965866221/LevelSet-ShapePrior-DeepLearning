clear;clc;
imgindex = 996; % 83 193 429
img = imread(['./images_data_crop/' sprintf('%05d',imgindex) '.jpg']);
load(['./data/images_mask/' sprintf('%05d', imgindex) '_mask.mat']);
load(['./Output_PortraitFCN/' sprintf('%05d',imgindex) '_output.mat']);
load(['./Affined_shapemask/' sprintf('%05d',imgindex) '_affinedshape.mat']);
shapemask = imread('meanmask.png');
shapemask = double(shapemask)./255;
%%
T_res_1(:,:) = double(res(1,:,:));
T_res_2(:,:) = double(res(2,:,:));
T_res_c_1 = 1./(1+exp(T_res_2 - T_res_1));
T_res_c_2 = 1./(1+exp(T_res_1 - T_res_2));
%%
subplot(1,5,1);imshow(img);
subplot(1,5,2);imshow(mask);
subplot(1,5,3);imshow(T_res_c_2);
subplot(1,5,4);imshow(affined_mask);
subplot(1,5,5);imshow(T_res_c_2.*affined_mask);
%%
% 1061
% 1056
% 1048
% 1026
% 1009
% 996 x
% 994
% 968
% 931
% 930
% 919
% 917
% 876
% 851
% 839
% 65
% 136
% 174 **

%%
% finalreg = double(T_res_c_2>0.5);
% B = labeloverlay(img, finalreg);
% figure;imshow(B)