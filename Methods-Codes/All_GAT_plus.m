clear;clc
load('../../data/testlist.mat')
shapemask = imread('meanmask.png');
shapemask = double(shapemask)./255;
for index=1:length(testlist)
    imgindex = testlist(index);
    if exist(['./Output_PortraitFCNplus/' sprintf('%05d',imgindex) '_output.mat'],'file')
        load(['../../data/images_mask/' sprintf('%05d', imgindex) '_mask.mat']);
        load(['./Output_PortraitFCNplus/' sprintf('%05d',imgindex) '_output.mat']);
		%%
		T_res_1(:,:) = double(res(1,:,:));
		T_res_2(:,:) = double(res(2,:,:));
		T_res_c_1 = 1./(1+exp(T_res_2 - T_res_1));
		T_res_c_2 = 1./(1+exp(T_res_1 - T_res_2));
		%% 把区域转换成边界，并在图片边缘补点
		shapeTro = 0.6;
		S = contourc(shapemask, [shapeTro shapeTro]);
		[m, n] = size(mask);
		for i = 1:m
			if shapemask(i,1)>=shapeTro
				S = [S, [1;i]];
			end
			if shapemask(i,n)>=shapeTro
				S = [S, [n;i]];
			end
		end
		for i = 1:n
			if shapemask(1,i)>=shapeTro
				S = [S, [i;1]];
			end
			if shapemask(m,i)>=shapeTro
				S = [S, [i;m]];
			end
		end
		T_Tro = 0.5;
		R = contourc(T_res_c_2, [T_Tro T_Tro]);
		for i = 1:m
			if T_res_c_2(i,1)>=T_Tro
				R = [R, [1;i]];
			end
			if T_res_c_2(i,n)>=T_Tro
				R = [R, [n;i]];
			end
		end
		for i = 1:n
			if T_res_c_2(1,i)>=T_Tro
				R = [R, [i;1]];
			end
			if T_res_c_2(m,i)>=T_Tro
				R = [R, [i;m]];
			end
		end
		%% 执行两次GAT
		[A1, b1] = GAT(S, R);
        A = A1; b = b1;
		S = A*S + b;
% 		T = [A(1,1) A(1,2) 0
% 			A(2,1) A(2,2) 0
% 			b(1) b(2) 1];
% 		tform = maketform('affine' ,T);
% 		affined_mask = imtransform(shapemask, tform, 'XData',[1 size(shapemask,2)],'YData',[1 size(shapemask,1)]);
% 		figure;
% 		subplot(1,3,1);imshow(T_res_c_2);
% 		subplot(1,3,2);imshow(shapemask);
% 		subplot(1,3,3);imshow(affined_mask);
		[A2, b2] = GAT(S, R);
		A = A2*A1;
		b = A2*b1 + b2;
		% [A, b] = GAT(S, R);
		T = [A(1,1) A(2,1) 0
			A(1,2) A(2,2) 0
			b(1) b(2) 1];
		tform = maketform('affine' ,T);
		affined_mask = imtransform(shapemask, tform, 'XData',[1 size(shapemask,2)],'YData',[1 size(shapemask,1)]);
% 		figure;
% 		subplot(1,3,1);imshow(T_res_c_2);
% 		subplot(1,3,2);imshow(shapemask);
% 		subplot(1,3,3);imshow(affined_mask);
		save(['./Affined_shapemaskplus/' sprintf('%05d', imgindex) '_affinedshape.mat'], 'affined_mask');
        fprintf('%05d OK\n', imgindex);
    end
end