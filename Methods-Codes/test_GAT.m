clear;clc;
imgindex = 174;
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