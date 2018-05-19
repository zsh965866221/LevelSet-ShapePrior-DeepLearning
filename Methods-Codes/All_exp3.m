clear;clc;
All_IoU = [];
All_IoU_Portrait = [];

load('../../data/testlist.mat')
for index=1:length(testlist)
    imgindex = testlist(index);
    if exist(['./Output_PortraitFCN/' sprintf('%05d',imgindex) '_output.mat'],'file')
		img = imread(['../../data/images_data_crop/' sprintf('%05d',imgindex) '.jpg']);
		load(['../../data/images_mask/' sprintf('%05d', imgindex) '_mask.mat']); % mask
		load(['./Output_PortraitFCN/' sprintf('%05d',imgindex) '_output.mat']); % res
		load(['./Affined_shapemask/' sprintf('%05d',imgindex) '_affinedshape.mat']); % affined_mask
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
		c0 = 200;
		initLSF = -(finalres*2*c0 - c0);
		T_initLSF = initLSF;
		smoothRatio = 1;
		initLSF = filter2(fspecial('average',smoothRatio), initLSF); % 平滑
		P1 = filter2(fspecial('average',smoothRatio), T_res_c_2);
		P2 = filter2(fspecial('average',smoothRatio), T_res_c_1);
		u = initLSF;
		%%
		iterNum = 200;
		timestep = .2;
		epsilon = 0.5;
		sigma = 4.0;
		lambda1 = 20.0;
		lambda2 = 20.0;
		rho1 = 0.05;
		rho2 = 0.05;
		pi1 = 2 * 500.0;
		pi2 = 2 * 500.0;
		nu = 0.005*255*255; % length
		mu = 1.0; % regularization
		%%
		K = fspecial('gaussian', round(2*sigma)*2+1, sigma);
		I = img;
		KI = conv2(img, K, 'same');
		KONE = conv2(ones(size(img)), K, 'same');
		%%
		for n = 1:iterNum
			u = exp2_RSF(u, I, K, KI, KONE, P1, P2, timestep, epsilon, lambda1, lambda2, rho1, rho2, pi1, pi2, affined_mask, 1-affined_mask, nu, mu, 1);
		end
		%%
		finalreg1 = double(u<0);
		IoU = sum(finalreg1(:).*mask(:))/sum(double((finalreg1(:)+mask(:))>0));
		finalreg2 = double(finalres>0.5);
		originalIoU = sum(finalreg2(:).*mask(:))/sum(double((finalreg2(:)+mask(:))>0));
		fprintf('%05d - Level set: %f\n', imgindex, IoU);
		fprintf('%05d - PortraitFCN: %f\n', imgindex, originalIoU);
		All_IoU = [All_IoU IoU];
		All_IoU_Portrait = [All_IoU_Portrait originalIoU];
		%%
        fprintf('%05d OK\n', imgindex);
    end
end
fprintf('Mean Level Set: %f\n', mean(All_IoU));
fprintf('Mean PortraitFCN: %f\n', mean(All_IoU_Portrait));
save('./IoU_PortraitFCN/IoU.mat', 'All_IoU', 'All_IoU_Portrait');