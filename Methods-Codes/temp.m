clear;clc;
imgindex = 492;
load(['./images_mask/' sprintf('%05d', imgindex) '_mask.mat']);
load(['./Output_PortraitFCNplus/' sprintf('%05d',imgindex) '_output.mat']);
shapemask = imread('meanmask.png');
shapemask = double(shapemask)./255;
%%
T_res_1(:,:) = double(res(1,:,:));
T_res_2(:,:) = double(res(2,:,:));
T_res_c_1 = 1./(1+exp(T_res_2 - T_res_1));
T_res_c_2 = 1./(1+exp(T_res_1 - T_res_2));
%%
TEMP = ones(size(mask));
figure;imshow(T_res_c_2);
figure;
imshow(TEMP);hold on;axis off,axis equal;
contour(T_res_c_2,[0.5 0.5],'b');hold off;
figure;
imshow(TEMP);hold on;axis off,axis equal;
contour(shapemask,[0.6 0.6],'b');hold off;
