load('./Output_FCN8s/00688_output.mat')
tsum = sum(exp(res), 1);
T_res_1 = exp(res(21,:,:))./tsum;
T_1(:,:) = T_res_1(1,:,:);
TT = T_1./max(max(T_1));
imshow(TT)