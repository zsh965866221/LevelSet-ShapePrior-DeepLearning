clear;clc;
imgindex = 147;
img = imread(['./images_data_crop/' sprintf('%05d',imgindex) '.jpg']);
load(['./images_mask/' sprintf('%05d', imgindex) '_mask.mat']);
load(['./Output_PortraitFCN/' sprintf('%05d',imgindex) '_output.mat']);
shapemask = imread('meanmask.png');
shapemask = double(shapemask)./255;
img = rgb2gray(img);
img = double(img);
%%
T_res_1(:,:) = double(res(1,:,:));
T_res_2(:,:) = double(res(2,:,:));
% S = exp(T_res_1)+exp(T_res_2);
% T_res_c_1 = exp(T_res_1)./S;
% T_res_c_2 = exp(T_res_2)./S;
% T_res_c_2(isnan(T_res_c_2)) = 1;
T_res_c_1 = 1./(1+exp(T_res_2 - T_res_1));
T_res_c_2 = 1./(1+exp(T_res_1 - T_res_2));
diffs = exp(T_res_2 - T_res_1);
finalres = diffs./(1+diffs);
%%
c0 = 200;
initLSF = -(finalres*2*c0 - c0);
T_initLSF = initLSF;
smoothRatio = 1;
initLSF = filter2(fspecial('average',smoothRatio), initLSF); % Æ½»¬
P1 = filter2(fspecial('average',smoothRatio), T_res_c_2);
P2 = filter2(fspecial('average',smoothRatio), T_res_c_1);
figure;
subplot(1,2,1);imshow(img./255);hold on;axis off,axis equal;contour(P1-0.5,[0 0],'r');hold off;
subplot(1,2,2);imshow(img./255);hold on;axis off,axis equal;contour(P2-0.5,[0 0],'r');hold off;
u = initLSF;
figure;imshow(img./255);hold on;axis off,axis equal
title('Initial contour');
[c,h] = contour(u,[0 0],'g');
contour(T_initLSF ,[0 0],'b');
pause(0.1);
%%
iterNum = 200;
timestep = .2;
epsilon = 0.5;
sigma = 8.0;
lambda1 = 40.0;
lambda2 = 40.0;
rho1 = 0.1;
rho2 = 0.1;
pi1 = 4 * 1000.0;
pi2 = 4 * 1000.0;
nu = 0.005*255*255; % length
mu = 1.0; % regularization
%%
K = fspecial('gaussian', round(2*sigma)*2+1, sigma);
I = img;
KI = conv2(img, K, 'same');
KONE = conv2(ones(size(img)), K, 'same');
%%
for n = 1:iterNum
    u = exp2_RSF(u, I, K, KI, KONE, P1, P2, timestep, epsilon, lambda1, lambda2, rho1, rho2, pi1, pi2, T_res_c_1.*shapemask, T_res_c_2.*(1-shapemask), nu, mu, 1);
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
p1reg = double(P1>0.5);
p1IoU = sum(p1reg(:).*mask(:))/sum(double((p1reg(:)+mask(:))>0));
fprintf('Smooth P: %f\n', p1IoU);
%%
% [L,N] = superpixels( img,500);
% figure
% BW = boundarymask(L);
% imshow(imoverlay(img./255 ,BW,'cyan'),'InitialMagnification',67)
%%
% subplot(1,2,1);
% imagesc(T_res_c_1);
% T = filter2(fspecial('average',200), T_res_c_1);
% subplot(1,2,2);
% imagesc(T);
%%
% diffs = exp(T_res_2 - T_res_1);
% finalres = diffs./(1+diffs);
% finalres_T = finalres > 0.5;
% figure;
% BW = boundarymask(finalres_T);
% imshow(imoverlay(img./255 ,BW,'cyan'),'InitialMagnification',67)

%%
% shapeTro = 0.7;
% S = contourc(shapemask, [shapeTro shapeTro]);
% [m, n] = size(img);
% for i = 1:m
%     if shapemask(i,1)>=shapeTro
%         S = [S, [1;i]];
%     end
%     if shapemask(i,n)>=shapeTro
%         S = [S, [n;i]];
%     end
% end
% for i = 1:n
%     if shapemask(1,i)>=shapeTro
%         S = [S, [i;1]];
%     end
%     if shapemask(m,i)>=shapeTro
%         S = [S, [i;m]];
%     end
% end
% T_Tro = 0.5;
% R = contourc(T_res_c_2, [T_Tro T_Tro]);
% for i = 1:m
%     if T_res_c_2(i,1)>=T_Tro
%         R = [R, [1;i]];
%     end
%     if T_res_c_2(i,n)>=T_Tro
%         R = [R, [n;i]];
%     end
% end
% for i = 1:n
%     if T_res_c_2(1,i)>=T_Tro
%         R = [R, [i;1]];
%     end
%     if T_res_c_2(m,i)>=T_Tro
%         R = [R, [i;m]];
%     end
% end
% subplot(1,2,1);scatter(S(1,:), S(2,:),'.');
% subplot(1,2,2);scatter(R(1,:), R(2,:), '.');
% %%
% 
% [A, b] = GAT(S, R);
% T = [A(1,1) A(1,2) 0
%     A(2,1) A(2,2) 0
%     b(1) b(2) 1];
% tform = maketform('affine' ,T);
% affined_mask = imtransform(shapemask, tform, 'XData',[1 size(shapemask,2)],'YData',[1 size(shapemask,1)]);
% figure;
% subplot(1,3,1);imshow(T_res_c_2);
% subplot(1,3,2);imshow(shapemask);
% subplot(1,3,3);imshow(affined_mask);