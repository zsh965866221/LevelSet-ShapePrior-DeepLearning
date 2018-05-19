clear;clc;
imgindex = 757;
img = imread(['./images_data_crop/' sprintf('%05d',imgindex) '.jpg']);
load(['./images_mask/' sprintf('%05d', imgindex) '_mask.mat']); % mask
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
B = filter2(fspecial('average',100), affined_mask);
A = T_res_c_2.*B;
figure; imshow(A);
%%
c0 = 200;
initLSF = -(finalres*2*c0 - c0);
T_initLSF = initLSF;
smoothRatio = 1;
initLSF = filter2(fspecial('average',smoothRatio), initLSF); % Æ½»¬
P1 = filter2(fspecial('average',smoothRatio), T_res_c_2);
P2 = filter2(fspecial('average',smoothRatio), T_res_c_1);
figure;
subplot(1,3,1);imshow(img./255);hold on;axis off,axis equal;contour(T_res_c_2,[0.5 0.5],'r');hold off;
subplot(1,3,2);imshow(img./255);hold on;axis off,axis equal;contour(affined_mask,[0.5 0.5],'r');hold off;
subplot(1,3,3);imshow(A);
u = initLSF;
figure;imshow(img./255);hold on;axis off,axis equal
title('Initial contour');
[c,h] = contour(u,[0 0],'g');
contour(T_initLSF ,[0 0],'b');
pause(0.1);
%%
iterNum = 2000;
timestep = .2;
epsilon = 0.5;
sigma = 4.0;
lambda1 = 2.0;
lambda2 = 2.0;
rho1 = 0.01;
rho2 = 0.01;
pi1 = 2 * 1000.0;
pi2 = 2 * 1000.0;
nu = 0.005*255*255; % length
mu = 1.0; % regularization
%%
K = fspecial('gaussian', round(2*sigma)*2+1, sigma);
I = img;
KI = conv2(img, K, 'same');
KONE = conv2(ones(size(img)), K, 'same');
%%
for n = 1:iterNum
    u = exp4_RSF(u, I, K, KI, KONE, A, 1-A, timestep, epsilon, lambda1, lambda2, rho1, rho2, pi1, pi2, A, 1-A, nu, mu, 1);
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