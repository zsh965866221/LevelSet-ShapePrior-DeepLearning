clear;clc;
imgindex = 312;
img = imread(['./images_data_crop/' sprintf('%05d',imgindex) '.jpg']);
load(['./Output_PortraitFCN/' sprintf('%05d',imgindex) '_output.mat']);

T_res_1(:,:) = res(1,:,:);
T_res_2(:,:) = res(2,:,:);
res_d = res(2,:,:) - res(1,:,:);
T_res_d(:,:) = res_d(1,:,:);

img = rgb2gray(img);
img = double(img)/255;
imshow(img);
S = exp(T_res_1)+exp(T_res_2);
T_res_c_1 = exp(T_res_1)./S;
T_res_c_2 = exp(T_res_2)./S;
T_res_c_2(isnan(T_res_c_2)) = 1;
figure;
subplot(1,2,1);imagesc(T_res_c_2);
subplot(1,2,2);imagesc(T_res_c_1);

figure;
subplot(1,2,1);imshow(img .* T_res_c_2);
subplot(1,2,2);imshow(img .* T_res_c_1);