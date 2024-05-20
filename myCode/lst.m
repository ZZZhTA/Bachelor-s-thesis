%% modis lst 逐年平均
clc; clear;

[lst1, rlst] = readgeoraster('D:\Desktop\process\tem\modis\2016\night1.tif');
[lst2, rlst] = readgeoraster('D:\Desktop\process\tem\modis\2016\night2.tif');
[lst3, rlst] = readgeoraster("D:\Desktop\process\tem\modis\2016\night3.tif");
[lst4, rlst] = readgeoraster("D:\Desktop\process\tem\modis\2016\night4.tif");
[lst5, rlst] = readgeoraster("D:\Desktop\process\tem\modis\2016\night5.tif");
[lst6, rlst] = readgeoraster("D:\Desktop\process\tem\modis\2016\night6.tif");
[lst7, rlst] = readgeoraster("D:\Desktop\process\tem\modis\2016\night7.tif");
[lst8, rlst] = readgeoraster("D:\Desktop\process\tem\modis\2016\night8.tif");
[lst9, rlst] = readgeoraster("D:\Desktop\process\tem\modis\2016\night9.tif");
[lst10, rlst] = readgeoraster("D:\Desktop\process\tem\modis\2016\night10.tif");
[lst11, rlst] = readgeoraster("D:\Desktop\process\tem\modis\2016\night11.tif");
[lst12, rlst] = readgeoraster("D:\Desktop\process\tem\modis\2016\night12.tif");

l_mean = zeros(1200, 2472);

for i = 1: 1200
    for j = 1: 2472
        temp_lst = [lst1(i, j), lst2(i, j), lst3(i, j), lst4(i, j), lst5(i, j), lst6(i, j), lst7(i, j), ...
            lst8(i, j), lst9(i, j), lst10(i, j), lst11(i, j), lst12(i, j)];
        index = find(temp_lst > 10000); % 每幅数据都是不全的
        valid = temp_lst(index);
        l_mean(i, j) = mean(valid, 'all');
    end
end

figure;
imshow(mat2gray(l_mean));

geotiffwrite("tem\modis\lst_night2016mean.tif", l_mean, rlst);

% l_mean(l_mean==0) = 100000;
testmin = min(l_mean, [], 'all');
testmax = max(l_mean, [], 'all');

%% modis 5 year mean
clc;
clear;
[lst1, rlst] = readgeoraster("tem\modis\lst_night2016mean.tif");
[lst2, rlst] = readgeoraster("tem\modis\lst_night2017mean.tif");
[lst3, rlst] = readgeoraster("tem\modis\lst_night2018mean.tif");
[lst4, rlst] = readgeoraster("tem\modis\lst_night2019mean.tif");
[lst5, rlst] = readgeoraster("tem\modis\lst_night2020mean.tif");

l_mean = zeros(1200, 2472);
for i = 1: 1200
    for j = 1: 2472
        temp_lst = [lst1(i, j), lst2(i, j), lst3(i, j), lst4(i, j), lst5(i, j)];
        index = find(temp_lst > 10000);
        valid = temp_lst(index);
        l_mean(i, j) = mean(valid, 'all');
    end
end

figure;
imshow(mat2gray(l_mean));

geotiffwrite("tem\modis\lst_night_mean5.tif", l_mean, rlst);

testmin = min(l_mean, [], 'all');
testmax = max(l_mean, [], 'all');