clear
clc
load('../../data/testlist.mat')
for i=1:length(testlist)
    if exist(['../../data/portraitFCN_data/' sprintf('%05d',testlist(i)) '.mat'],'file')
        copyfile(['../../data/images_data_crop/' sprintf('%05d',testlist(i)) '.jpg'], './imgs_test/')
    end
end