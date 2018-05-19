%% 论文方法
%%
clear;clc;
imgindex = 924;
img = imread(['../../data/images_data_crop/' sprintf('%05d',imgindex) '.jpg']);
load(['../../data/images_mask/' sprintf('%05d', imgindex) '_mask.mat']); % mask
load(['./Output_PortraitFCN/' sprintf('%05d',imgindex) '_output.mat']); % res
load(['./Affined_shapemask/' sprintf('%05d',imgindex) '_affinedshape.mat']); % affined_mask
shapemask = imread('meanmask.png');
shapemask = double(shapemask)./255;
img = rgb2gray(img);
img = double(img);
%%
T_res_1(:,:) = double(res(1,:,:));
T_res_2(:,:) = double(res(2,:,:));
T_res_c_1 = 1./(1+exp(T_res_2 - T_res_1));
T_res_c_2 = 1./(1+exp(T_res_1 - T_res_2));
diffs = exp(T_res_2 - T_res_1);
finalres = diffs./(1+diffs);
%%
sigma=.8;
G=fspecial('gaussian',15,sigma);
Img_smooth=conv2(img,G,'same');
[Ix,Iy]=gradient(img);
f=Ix.^2+Iy.^2;
g=1./(1+f);
%%
c0 = 200;
initLSF = -(finalres*2*c0 - c0);
T_initLSF = initLSF;
smoothRatio = 100;
initLSF = filter2(fspecial('average',smoothRatio), initLSF); % 平滑
P1 = filter2(fspecial('average',smoothRatio), T_res_c_2);
P2 = filter2(fspecial('average',smoothRatio), T_res_c_1);
figure;
subplot(1,2,1);imshow(img./255);hold on;axis off,axis equal;contour(T_res_c_2,[0.5 0.5],'r');hold off;
subplot(1,2,2);imshow(img./255);hold on;axis off,axis equal;contour(affined_mask,[0.5 0.5],'r');hold off;
u = initLSF;
figure;imshow(img./255);hold on;axis off,axis equal
title('Initial contour');
[c,h] = contour(u,[0 0],'g');
contour(T_initLSF ,[0 0],'b');
pause(0.1);
%%
iterNum = 200;
timestep = 2;
epsilon = 0.5;
pi1 = 1;
pi2 = 1;
mu = 0.1/timestep;
lambda = 5;
alfa = 3;
%%
for n = 1:iterNum
    u = exp5_RSF(u, g, P1, P2, affined_mask, 1-affined_mask, mu, timestep, epsilon, lambda, alfa, pi1, pi2 , 1, 'double-well');
    if mod(n, 10) == 0
        pause(0.05);
        imshow(img./255);hold on;axis off,axis equal
        contour(u,[0 0],'r');
        contour(initLSF,[0 0],'g');
        contour(T_initLSF ,[0 0],'b');
        iN = [num2str(n), ' iterations'];
        title(iN);
        hold off;
    end
end

%%
finalreg1 = double(u<0);
IoU = sum(finalreg1(:).*mask(:))/sum(double((finalreg1(:)+mask(:))>0));
finalreg2 = double(finalres>0.5);
originalIoU = sum(finalreg2(:).*mask(:))/sum(double((finalreg2(:)+mask(:))>0));
fprintf('Level set: %f\n', IoU);
fprintf('PortraitFCN: %f\n', originalIoU);