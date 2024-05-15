%% calculate FAD
clc; clear;
[f90, r] = readgeoraster("D:\Desktop\process\UCP\1250res\13λf90\guangdong1250\guangzhou_112.9528,λf90.tif");
[f45, r] = readgeoraster("D:\Desktop\process\UCP\1250res\12λf45\guangdong1250\guangzhou_112.9528,λf45.tif");
[f135, r] = readgeoraster("D:\Desktop\process\UCP\1250res\11λf135\guangdong1250\guangzhou_112.9528,λf135.tif");
[f0, r] = readgeoraster("D:\Desktop\process\UCP\1250res\10λf0\guangdong1250\guangzhou_112.9528,λf0.tif");

fad = (f90+f0+f45+f135)/4;
figure;
imshow(fad);
geotiffwrite("fad.tif", fad, r);

%% calculate GardenCity, Suburban, City, Innercity
clc;
clear;
[fad, r] = readgeoraster("fad.tif");    % 迎风面积密度
[fvc, r] = readgeoraster("fvc.tif");    % 植被覆盖度

result = zeros(size(fvc, 1), size(fvc, 2));
pixelnum = size(fvc, 1)* size(fvc, 2);


countAbove0 = length(find(fad > 0));
pct = length(find(fad > prctile(fad, 20, 'all'))) / pixelnum;
pctfad = zeros(10, 1);
for i = 89 : 99
    index = i - 88;
    pctfad(index) = length(find(fad > prctile(fad, i, 'all'))) / countAbove0;
end

%% test threshold
clc;
clear;
[fad, rfad] = readgeoraster("fad.tif");    % 迎风面积密度
[fvc, rfvc] = readgeoraster("fvc.tif");    % 植被覆盖度
[glb, rglb] = readgeoraster("globe30.tif");    % globe30
[indus, rindus] = readgeoraster("com-indus.tif");   % commercial and industry
[ugs, rugs] = readgeoraster("urbangreen_new.tif");  % Urban Green Space

result1 = zeros(size(fvc, 1), size(fvc, 2));
%result2 = zeros(size(fvc, 1), size(fvc, 2));
pixelnum = size(fvc, 1)* size(fvc, 2);
countAbove0 = length(find(fad > 0));

count1 = 0;
count2 = 0;
count3 = 0;
count4 = 0;
t1 = prctile(fad, 90, 'all');
t2 = prctile(fad, 99, "all");
t3 = prctile(fad, 94, "all");
for i = 1: size(fad, 1)
    for j = 1: size(fad ,2)
        if fad(i, j) <= t1 && glb(i, j) ~= 0
            result1(i, j) = 6;
        end
        if fad(i, j) > t1
            count1 = count1 + 1;
            result1(i, j) = 1;
        end
        if fad(i, j) > t2
            count2 = count2 + 1;
            result1(i, j) = 2;
        end
        if fad(i, j) > t3 && fad(i, j) < t2
            count3 = count3 + 1;
            result1(i, j) = 3;
        end
        if fad(i, j) > t1 && fad(i, j) < t3
            count4 = count4 + 1;
            result1(i, j) = 4;
        end
    end
end

count5 = 0;
t4 = prctile(fvc, 65, "all");
for i = 1: size(fad, 1)
    for j = 1: size(fad ,2)
        if result1(i, j) == 4
            if fvc(i, j) > t4
                result1(i, j) = 5;
                count5 = count5 + 1;
            end
        end
    end
end

for i = 1: size(fvc, 1)
    for j = 1: size(fvc, 2)
        if glb(i, j)==255 || glb(i, j)==60
            result1(i, j) = 1;
        end
        if (glb(i, j)==10 || glb(i, j)==30 || glb(i, j)==50 || glb(i, j)==90) && result1(i, j)~=5
            result1(i, j) = 6;
        end
        if glb(i, j)==20 && result1(i, j)~=5    % gardencity优先级大于土地利用
            result1(i, j) = 7;
        end
    end
end

% calculate com-indus and ugs
for i = 1: size(fvc, 1)
    for j = 1: size(fvc, 2)
        if indus(i, j) ~= 0 && indus(i, j) ~= 2 && indus(i, j) ~= 3
            result1(i, j) = 8;
        end
        if ugs(i, j) ~= 0
            result1(i, j) = 9;
        end
    end
end

figure;
imshow(result1);
% imshow(mat2gray(result1));
% map = [0 0 1
%     0 1 0
%     1 0 0
%     0.5 0.5 0
%     0.5 0 0.5
%     0 0.5 0.5];
colormap('autumn');

geotiffwrite('ucmap_test3.tif', result1, rfad);

% legend;
% subplot(122);
% imshow(result2);

% count1 = gardencity+suburban+city+innercity = 227 204
% count2 = innercity = 23 113
% count3 = city = 115 566
% count4 = gardencity+suburb = 88 525
% count4 = count1-count2-count3
% count5 = gardencity = 11 316
% count_indus = 73 924
% count_ugs = 21 891

% legend: city=3  innercity=2  gardencity=5  suburban=4  water=1 
% openland=6  forest=7  com-indus=8  urbangreen = 9

% innercity / garden+suburban+city+innercity ~= 10%

%% synthetising map
clc;
clear;
[map, rmap] = readgeoraster("synthetized_new.tif");
stat = zeros(139, 1);
value = unique(map);

for i = 1:139
    stat(i, 1) = length(find(map==value(i)));
end

countabove0 = length(find(map>0));
countabove0 = length(find(map>0));

%% synthetising catogery
clc;
clear;
[map, rmap] = readgeoraster("synthetized_new.tif");

new = zeros(size(map, 1), size(map, 2));

for i = 1:size(map, 1)
    for j = 1:size(map, 2)
        if map(i, j) == 101 || map(i, j) == 102 || map(i, j) == 103
            new(i, j) = 101;
        elseif map(i, j) == 104 || map(i, j) == 105
            new(i, j) = 104;
        elseif map(i, j) == 106
            new(i, j) = 106;
        elseif map(i, j) == 108
            new(i, j) = 108;
        elseif map(i, j) == 109
            new(i, j) = 109;
        elseif map(i, j) == 111
            new(i, j) = 111;
        elseif map(i, j) == 112
            new(i, j) = 112;
        elseif map(i, j) == 114
            new(i, j) = 114;
        elseif map(i, j) == 117
            new(i, j) = 117;
        end
    end
end
for i = 1:size(map, 1)
    for j = 1:size(map, 2)
        if map(i, j) == 201 || map(i, j) == 202 || map(i, j) == 203
            new(i, j) = 201;
        elseif map(i, j) == 204 || map(i, j) == 205
            new(i, j) = 204;
        elseif map(i, j) == 206
            new(i, j) = 206;
        elseif map(i, j) == 208
            new(i, j) = 208;
        elseif map(i, j) == 209
            new(i, j) = 209;
        elseif map(i, j) == 211
            new(i, j) = 211;
        elseif map(i, j) == 212
            new(i, j) = 212;
        elseif map(i, j) == 214
            new(i, j) = 214;
        elseif map(i, j) == 217
            new(i, j) = 217;
        end
    end
end
for i = 1:size(map, 1)
    for j = 1:size(map, 2)
        if map(i, j) == 301 || map(i, j) == 302 || map(i, j) == 303
            new(i, j) = 301;
        elseif map(i, j) == 304 || map(i, j) == 305
            new(i, j) = 304;
        elseif map(i, j) == 306
            new(i, j) = 306;
        elseif map(i, j) == 308
            new(i, j) = 308;
        elseif map(i, j) == 309
            new(i, j) = 309;
        elseif map(i, j) == 311
            new(i, j) = 311;
        elseif map(i, j) == 312
            new(i, j) = 312;
        elseif map(i, j) == 314
            new(i, j) = 314;
        elseif map(i, j) == 317
            new(i, j) = 317;
        end
    end
end
for i = 1:size(map, 1)
    for j = 1:size(map, 2)
        if map(i, j) == 401 || map(i, j) == 402 || map(i, j) == 403
            new(i, j) = 401;
        elseif map(i, j) == 404 || map(i, j) == 405
            new(i, j) = 404;
        elseif map(i, j) == 406
            new(i, j) = 406;
        elseif map(i, j) == 408
            new(i, j) = 408;
        elseif map(i, j) == 409
            new(i, j) = 409;
        elseif map(i, j) == 411
            new(i, j) = 411;
        elseif map(i, j) == 412
            new(i, j) = 412;
        elseif map(i, j) == 414
            new(i, j) = 414;
        elseif map(i, j) == 417
            new(i, j) = 417;
        end
    end
end
for i = 1:size(map, 1)
    for j = 1:size(map, 2)
        if map(i, j) == 501 || map(i, j) == 502 || map(i, j) == 503
            new(i, j) = 501;
        elseif map(i, j) == 504 || map(i, j) == 505
            new(i, j) = 504;
        elseif map(i, j) == 506
            new(i, j) = 506;
        elseif map(i, j) == 508
            new(i, j) = 508;
        elseif map(i, j) == 509
            new(i, j) = 509;
        elseif map(i, j) == 511
            new(i, j) = 511;
        elseif map(i, j) == 512
            new(i, j) = 512;
        elseif map(i, j) == 514
            new(i, j) = 514;
        elseif map(i, j) == 517
            new(i, j) = 517;
        end
    end
end
for i = 1:size(map, 1)
    for j = 1:size(map, 2)
        if map(i, j) == 601 || map(i, j) == 602 || map(i, j) == 603
            new(i, j) = 601;
        elseif map(i, j) == 604 || map(i, j) == 605
            new(i, j) = 604;
        elseif map(i, j) == 606
            new(i, j) = 606;
        elseif map(i, j) == 608
            new(i, j) = 608;
        elseif map(i, j) == 609
            new(i, j) = 609;
        elseif map(i, j) == 611
            new(i, j) = 611;
        elseif map(i, j) == 612
            new(i, j) = 612;
        elseif map(i, j) == 614
            new(i, j) = 614;
        elseif map(i, j) == 617
            new(i, j) = 617;
        end
    end
end
for i = 1:size(map, 1)
    for j = 1:size(map, 2)
        if map(i, j) == 701 || map(i, j) == 702 || map(i, j) == 703
            new(i, j) = 701;
        elseif map(i, j) == 704 || map(i, j) == 705
            new(i, j) = 704;
        elseif map(i, j) == 706
            new(i, j) = 706;
        elseif map(i, j) == 708
            new(i, j) = 708;
        elseif map(i, j) == 709
            new(i, j) = 709;
        elseif map(i, j) == 711
            new(i, j) = 711;
        elseif map(i, j) == 712
            new(i, j) = 712;
        elseif map(i, j) == 714
            new(i, j) = 714;
        elseif map(i, j) == 717
            new(i, j) = 717;
        end
    end
end
for i = 1:size(map, 1)
    for j = 1:size(map, 2)
        if map(i, j) == 801 || map(i, j) == 802 || map(i, j) == 803
            new(i, j) = 801;
        elseif map(i, j) == 804 || map(i, j) == 805
            new(i, j) = 804;
        elseif map(i, j) == 806
            new(i, j) = 806;
        elseif map(i, j) == 808
            new(i, j) = 808;
        elseif map(i, j) == 809
            new(i, j) = 809;
        elseif map(i, j) == 811
            new(i, j) = 811;
        elseif map(i, j) == 812
            new(i, j) = 812;
        elseif map(i, j) == 814
            new(i, j) = 814;
        elseif map(i, j) == 817
            new(i, j) = 817;
        end
    end
end
for i = 1:size(map, 1)
    for j = 1:size(map, 2)
        if map(i, j) == 901 || map(i, j) == 902 || map(i, j) == 903
            new(i, j) = 901;
        elseif map(i, j) == 904 || map(i, j) == 905
            new(i, j) = 904;
        elseif map(i, j) == 906
            new(i, j) = 906;
        elseif map(i, j) == 908
            new(i, j) = 908;
        elseif map(i, j) == 909
            new(i, j) = 909;
        elseif map(i, j) == 911
            new(i, j) = 911;
        elseif map(i, j) == 912
            new(i, j) = 912;
        elseif map(i, j) == 914
            new(i, j) = 914;
        elseif map(i, j) == 917
            new(i, j) = 917;
        end
    end
end

% lcz-10
[lcz, rlcz] = readgeoraster("lcz_new.tif");
for i = 1: size(lcz, 1)
    for j = 1: size(lcz, 2)
        if lcz(i, j) == 10
            new(i, j) = 808;
        end
    end
end

figure;
imshow(new);

geotiffwrite("syn_catogeried", new, rmap);

%% weather
clc;
clear;
[map, rmap] = readgeoraster("synthetized_new.tif");
[hi, rhi] = readgeoraster("lst_night_mean5_gz.tif");


% water
index = find(map==114);
box114 = hi(index);
index = find(map==117);
box117 = hi(index);
rand114 = randsample(box114, 2000);
% rand114(find(rand114>4000)) = median(rand114, 'all');
rand114(find(rand114<1000)) = median(rand114, 'all');
rand117 = randsample(box117, 2000);
% rand117(find(rand117>4000)) = median(rand117, 'all');
rand117(find(rand117<1000)) = median(rand117, 'all');

% inner city
index = find(map==201 | map==202 | map==203);
box21 = hi(index);
index = find(map==204 | map==205);
box24 = hi(index);
index = find(map==206);
box26 = hi(index);
index = find(map==208);
box28 = hi(index);
rand21 = randsample(box21, 2000);
% rand21(find(rand21>4000)) = median(rand21, 'all');
rand21(find(rand21<1000)) = median(rand21, 'all');
rand24 = randsample(box24, 2000);
% rand24(find(rand24>4000)) = median(rand24, 'all');
rand24(find(rand24<1000)) = median(rand24, 'all');
rand26 = randsample(box26, 2000);
% rand26(find(rand26>4000)) = median(rand26, 'all');
rand26(find(rand26<1000)) = median(rand26, 'all');
rand28 = randsample(box28, 2000);
% rand28(find(rand28>4000)) = median(rand28, 'all');
rand28(find(rand28<1000)) = median(rand28, 'all');

% city
index = find(map==301 | map==302 | map==303);
box31 = hi(index);
index = find(map==304 | map==305);
box34 = hi(index);
index = find(map==306);
box36 = hi(index);
index = find(map==308);
box38 = hi(index);
rand31 = randsample(box31, 2000);
% rand31(find(rand31>4000)) = median(rand31, 'all');
rand31(find(rand31<1000)) = median(rand31, 'all');
rand34 = randsample(box34, 2000);
% rand34(find(rand34>4000)) = median(rand34, 'all');
rand34(find(rand34<1000)) = median(rand34, 'all');
rand36 = randsample(box36, 2000);
% rand36(find(rand36>4000)) = median(rand36, 'all');
rand36(find(rand36<1000)) = median(rand36, 'all');
rand38 = randsample(box38, 2000);
% rand38(find(rand38>4000)) = median(rand38, 'all');
rand38(find(rand38<1000)) = median(rand38, 'all');

% suburban
index = find(map==406);
box46 = hi(index);
index = find(map==408);
box48 = hi(index);
rand46 = randsample(box46, 2000);
% rand46(find(rand46>4000)) = median(rand46, 'all');
rand46(find(rand46<1000)) = median(rand46, 'all');
rand48 = randsample(box48, 2000);
% rand48(find(rand48>4000)) = median(rand48, 'all');
rand48(find(rand48<1000)) = median(rand48, 'all');

% garden city
index = find(map==506);
box56 = hi(index);
index = find(map==509);
box59 = hi(index);
index = find(map==511);
box511 = hi(index);
rand56 = randsample(box56, 2000);
% rand56(find(rand56>4000)) = median(rand56, 'all');
rand56(find(rand56<1000)) = median(rand56, 'all');
rand59 = randsample(box59, 2000);
% rand59(find(rand59>4000)) = median(rand59, 'all');
rand59(find(rand59<1000)) = median(rand59, 'all');
rand511 = randsample(box511, 2000);
% rand511(find(rand511>4000)) = median(rand511, 'all');
rand511(find(rand511<1000)) = median(rand511, 'all');

% open land
index = find(map==606);
box66 = hi(index);
index = find(map==609);
box69 = hi(index);
index = find(map==611);
box611 = hi(index);
rand66 = randsample(box66, 2000);
% rand66(find(rand66>4000)) = median(rand66, 'all');
rand66(find(rand66<1000)) = median(rand66, 'all');
rand69 = randsample(box69, 2000);
% rand69(find(rand69>4000)) = median(rand69, 'all');
rand69(find(rand69<1000)) = median(rand69, 'all');
rand611 = randsample(box611, 2000);
% rand611(find(rand611>4000)) = median(rand611, 'all');
rand611(find(rand611<1000)) = median(rand611, 'all');

% forest
index = find(map==711);
box711 = hi(index);
rand711 = randsample(box711, 2000);
% rand711(find(rand711>4000)) = median(rand711, 'all');
rand711(find(rand711<1000)) = median(rand711, 'all');

% com/indus
index = find(map==806);
box86 = hi(index);
index = find(map==808);
box88 = hi(index);
rand86 = randsample(box86, 2000);
% rand86(find(rand86>4000)) = median(rand86, 'all');
rand86(find(rand86<1000)) = median(rand86, 'all');
rand88 = randsample(box88, 2000);
% rand88(find(rand88>4000)) = median(rand88, 'all');
rand88(find(rand88<1000)) = median(rand88, 'all');

% urban green space
index = find(map==906);
box96 = hi(index);
index = find(map==908);
box98 = hi(index);
rand96 = randsample(box96, 2000);
% rand96(find(rand96>4000)) = median(rand96, 'all');
rand96(find(rand96<1000)) = median(rand96, 'all');
rand98 = randsample(box98, 2000);
% rand98(find(rand98>4000)) = median(rand98, 'all');
rand98(find(rand98<1000)) = median(rand98, 'all');


data = [rand114, rand117, rand21, rand24, rand26, rand28, ...
    rand31, rand34, rand36, rand38, rand46, rand48, ...
    rand56, rand59, rand511, rand66, rand69, rand611, rand711, ...
    rand86, rand88, rand96, rand98];
data = data*0.02-273.15;

group = [7, 8, 1, 2, 3, 4, 1, 2, 3, 4, 3, 4, 3, 5, 6, 3, 5, 6, 6, 3, 4, 3, 4];

mycolor = [140/255, 0, 0;...
    191/255, 77/255, 0;...
    255/255, 153/255, 85/255;...
    188/255, 188/255, 188/255;...
    255/255, 204/255, 170/255;
    0, 106/255, 0;
    185/255, 219/255, 121/255;
    106/255, 106/255, 1];

xlabel = ["Water", "", "Inner C.", "", "", "", "City", "", "", "", "Suburban", "", ...
    "Garden C.", "", "", "Openland", "", "", "Forest", "Com./Indus.", "", "Urban G.", ""];
figure;
zz = boxplot(data, 'PlotStyle', 'traditional', 'Widths',1 , 'OutlierSize',2, ...
    'Symbol','kx', ColorGroup=group, FactorGap=4, MedianStyle='line', Colors=mycolor);
set(gca,'XTickLabel',xlabel);
set(zz,'LineWidth',0.8);
set(gcf,'Position',[100 100 900 600])
grid on;
% gca.YGrid = 'on';

ylabel("SAT (℃)");

% violin plot
allcolor = [
% 140/255, 0, 0;...% 深红
% 191/255, 77/255, 0;...% 浅红
% 255/255, 153/255, 85/255;...% 橙
% 188/255, 188/255, 188/255;...% 灰
% 255/255, 204/255, 170/255;% 粉
% 0, 106/255, 0;% 深绿
% 185/255, 219/255, 121/255;% 浅绿
% 106/255, 106/255, 1;% 水蓝
    185/255, 219/255, 121/255;% 浅绿
    106/255, 106/255, 1;% 水蓝
    140/255, 0, 0;...% 深红
    191/255, 77/255, 0;...% 浅红
    255/255, 153/255, 85/255;...% 橙
    188/255, 188/255, 188/255;...% 灰
    140/255, 0, 0;...% 深红
    191/255, 77/255, 0;...% 浅红
    255/255, 153/255, 85/255;...% 橙
    188/255, 188/255, 188/255;...% 灰
    255/255, 153/255, 85/255;...% 橙
    188/255, 188/255, 188/255;...% 灰
    255/255, 153/255, 85/255;...% 橙
    255/255, 204/255, 170/255;% 粉
    0, 106/255, 0;% 深绿
    255/255, 153/255, 85/255;...% 橙
    255/255, 204/255, 170/255;% 粉
    0, 106/255, 0;% 深绿
    0, 106/255, 0;% 深绿
    255/255, 153/255, 85/255;...% 橙
    188/255, 188/255, 188/255;...% 灰
    255/255, 153/255, 85/255;...% 橙
    188/255, 188/255, 188/255;...% 灰
    ];

randdata = zeros(200, 23);
for i = 1:23
    randdata(:, i) = randsample(data(:, i), 200);
end

figure;
vc1 = violinplot(randdata, 23, 'Width', 0.4, 'ViolinColor', allcolor, 'ViolinAlpha', 0.5, ...
    'MarkerSize', 3, 'MedianMarkerSize', 10, ShowBox=false);
% set(vc1,'LineWidth',0.8);
set(gcf,'Position',[100 100 1500 600])
grid on;
xlabel = ["Water", "", "Inner C.", "", "", "", "City", "", "", "", "Suburban", "", ...
    "Garden C.", "", "", "Openland", "", "", "Forest", "Com./Indus.", "", "Urban G.", ""];
set(gca,'XTickLabel',xlabel);
ylabel("LST-Night (℃)");

%% modis lst
clc; clear;
% [lst1, rlst] = readgeoraster('D:\Desktop\process\tem\modis\2020\day1.tif');
% [lst2, rlst] = readgeoraster('D:\Desktop\process\tem\modis\2020\day2.tif');
% [lst3, rlst] = readgeoraster("D:\Desktop\process\tem\modis\2020\day3.tif");
% [lst4, rlst] = readgeoraster("D:\Desktop\process\tem\modis\2020\day4.tif");
% [lst5, rlst] = readgeoraster("D:\Desktop\process\tem\modis\2020\day5.tif");
% [lst6, rlst] = readgeoraster("D:\Desktop\process\tem\modis\2020\day6.tif");
% [lst7, rlst] = readgeoraster("D:\Desktop\process\tem\modis\2020\day7.tif");
% [lst8, rlst] = readgeoraster("D:\Desktop\process\tem\modis\2020\day8.tif");
% [lst9, rlst] = readgeoraster("D:\Desktop\process\tem\modis\2020\day9.tif");
% [lst10, rlst] = readgeoraster("D:\Desktop\process\tem\modis\2020\day10.tif");
% [lst11, rlst] = readgeoraster("D:\Desktop\process\tem\modis\2020\day11.tif");
% [lst12, rlst] = readgeoraster("D:\Desktop\process\tem\modis\2020\day12.tif");

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
        index = find(temp_lst > 10000);
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

%% 各类climatope中各类lcz——百分比堆叠柱状图
clc; clear;

% 对每行画一个堆叠柱
% 求每行和，生成一列
load stack.mat
data = stack;
sum2 = sum(data, 2);
data = data./sum2;

X=[1,2,3,4,5,6,7,8];%定义横轴


a = bar(data*100, 0.4,'stacked');

a(1).FaceColor = [140/255, 0, 0];
a(2).FaceColor = [191/255, 77/255, 0];
a(3).FaceColor = [255/255, 153/255, 85/255];
a(4).FaceColor = [188/255, 188/255, 188/255];
a(5).FaceColor = [255/255, 204/255, 170/255];
a(6).FaceColor = [0, 106/255, 0];
a(7).FaceColor = [0, 170/255, 1];
a(8).FaceColor = [185/255, 219/255, 121/255];
a(9).FaceColor = [106/255, 106/255, 1];

% 
% mycolor = [140/255, 0, 0;...
%     191/255, 77/255, 0;...
%     255/255, 153/255, 85/255;...
%     188/255, 188/255, 188/255;...
%     255/255, 204/255, 170/255;
%     0, 106/255, 0;
%     185/255, 219/255, 121/255;
%     106/255, 106/255, 1];

 
loca={'Water','Inner C.','City','Suburban','Garden C.','Openland','Forest','Com./Indus.', 'Urban G.'};

set(gca,'XTickLabel',loca);%设置x轴标注
% set(gca,'YTickLabel',{'0%','20%','40%','60%','80%','100%'});%y轴标注
ylim([0 100]);
set(gca, 'FontSize', 12);
hold on;
grid on;
title("各类Climatope内LCZ占比");
% set(gcf,'position',[100,100,300,300]); 


legend(a,'LCZ-1/2/3','LCZ-4/5','LCZ-6','LCZ-8','LCZ-9','LCZ-A', 'LCZ-B', ...
    'LCZ-D', 'LCZ-G', ...
    'location','southeastoutside','orientation','vertical', 'FontSize',12);
legend('boxoff');

%% 分级图层——横向百分比堆叠柱状图
clc;
clear;
[hi, rhi] = readgeoraster("hi_mean5.tif");
[sc, rsc] = readgeoraster("syn_catogeried_full.tif");
label = zeros(size(hi, 1), size(hi, 2));
hi = hi/100;
for i = 1: size(hi, 1)
    for j = 1: size(hi, 2)
        if hi(i, j)<27 && hi(i, j)~=0
            label(i, j) = 1;
        elseif hi(i, j)>=27 && hi(i, j)<32
            label(i, j) = 2;
        elseif hi(i, j)>=32 
            label(i, j) = 3;
        end
    end
end

stat = zeros(4, 10);
stat(1, :) = [201, 204, 208, 301, 304, 308, 408, 808, 906, 908];

for i = 1: size(hi, 1)
    for j = 1: size(hi, 2)
        for k = 1: 10
            if sc(i, j)==stat(1, k) && label(i, j)==1
                stat(2, k) = stat(2, k)+1;
            elseif sc(i, j)==stat(1, k) && label(i, j)==2
                stat(3, k) = stat(3, k)+1;
            elseif sc(i, j)==stat(1, k) && label(i, j)==3
                stat(4, k) = stat(4, k)+1;
            end
        end
    end
end

therm = stat(2:4, :);
sum1 = sum(therm, 1);
therm = therm./sum1;
therm = transpose(therm);
figure;

bb = barh(therm, 'stacked');
loca={'IC+1/2/3','IC+4/5','IC+8','C+1/2/3','C+4/5','C+8','SU+8','C/I+8', 'UGS+6', 'UGS+8'};
set(gca,'YTickLabel',loca);%设置x轴标注
xlim([0 1]);
set(gca, 'FontSize', 12);
bb(1).FaceColor = [0/255, 207/255, 0/255];
bb(2).FaceColor = [255/255, 207/255, 14/255];
bb(3).FaceColor = [255/255, 0/255, 0/255];
hold on;
grid on;
title("(b) sWBGT");
legend(bb,'Low Heat Stress','Moderate Heat Stress','High Heat Stress', ...
    'location','northeast','orientation','horizontal', 'FontSize',12);
legend('boxoff');
set(gcf,'Position',[100 100 750 600])

%% chord chart
clc;
clear;
load chord5.mat
% import chordChart
dataMat = chord5;

colName={'LCZ-1/2/3','LCZ-4/5','LCZ-6','LCZ-8','LCZ-9'};
rowName={'InnerC','City','SubU', 'Com/Indus', 'UrbanGS'};
% figure('Units','normalized', 'Position',[.02,.05,.8,.85])

figure('Units','normalized', 'Position',[.02,.05,.8,.85])
CC = chordChart(dataMat, 'colName',colName, 'rowName', rowName, 'Sep',1/80, 'SSqRatio',30/100);
CC = CC.draw();
% 修改上方方块颜色(Modify the color of the blocks above)
CListT = [140/255, 0, 0
    191/255, 77/255, 0
    255/255, 153/255, 85/255
    188/255, 188/255, 188/255
    255/255, 204/255, 170/255];

for i = 1:size(dataMat, 2)
    CC.setSquareT_N(i, 'FaceColor',CListT(i,:))
end
% 修改下方方块颜色(Modify the color of the blocks below)
CListF = [1,0,0
    1,170/255,0
    1,1,0
    204/255,204/255,204/255
    163/255,1,115/255
    ];
for i = 1:size(dataMat, 1)
    CC.setSquareF_N(i, 'FaceColor',CListF(i,:))
end
% 修改弦颜色(Modify chord color)
CListC = [115/255,0,0
    230/255,0,0
    1,0,0
    168/255,0,0
    1,66/255,0;
    255/255, 211/255, 127/255
    1, 170/255, 0
    230/255, 152/255, 0
    168/255, 112/255, 0
    255/255, 235/255, 190/255;
    1, 1, 190/255
    1, 1, 190/255
    230/255, 230/255, 0
    1, 1, 0
    1, 1, 190/255;
    225/255, 225/255, 225/255
    225/255, 225/255, 225/255
    130/255, 130/255, 130/255
    178/255, 178/255, 178/255
    225/255, 225/255, 225/255;
    233/255, 255/255, 190/255
    211/255, 255/255, 190/255
    76/255, 230/255, 0
    85/255, 1, 0
    233/255, 255/255, 190/255];
for i = 1:size(dataMat, 1)
    for j = 1:size(dataMat, 2)
        CC.setChordMN(i,j, 'FaceColor',CListC(5*(i-1)+j,:), 'FaceAlpha',.4)
    end
end
% 单独设置每一个弦末端方块(Set individual end blocks for each chord)
% Use obj.setEachSquareF_Prop 
% or  obj.setEachSquareT_Prop
% F means from (blocks below)
% T means to   (blocks above)
for i = 1:size(dataMat, 1)
    for j = 1:size(dataMat, 2)
        CC.setEachSquareT_Prop(i,j, 'FaceColor', CListF(i,:))
    end
end

for i = 1:size(dataMat, 1)
    for j = 1:size(dataMat, 2)
        CC.setEachSquareF_Prop(j,i, 'FaceColor', CListT(i,:))
    end
end
% 添加刻度
CC.tickState('on')
% 修改字体，字号及颜色
CC.setFont('FontName','Arial', 'FontSize',17)
% 隐藏下方标签
% textHdl = findobj(gca, 'Tag','ChordLabel');
% for i = 1:length(textHdl)
%     if textHdl(i).Position(2) < 0
%         set(textHdl(i), 'Visible','off')
%     end
% end
% 绘制图例(Draw legend)
% scatterHdl = scatter(10.*ones(size(dataMat,1)),10.*ones(size(dataMat,1)), ...
%                      55, 'filled');
% for i = 1:length(scatterHdl)
%     scatterHdl(i).CData = CListF(i,:);
% end
% lgdHdl = legend(scatterHdl, rowName, 'Location','best', 'FontSize',16, 'FontName','Cambria', 'Box','off');
% set(lgdHdl, 'Position',[.7482,.3577,.1658,.3254])

%% 统计各类climatope的温度中位数，与箱线图对比，目的是突出"识别热风险区的精度提升了"
clc;
clear;
[ucm, rucm] = readgeoraster("ucmap.tif");
[lstd, rlstd] = readgeoraster("lst_day_mean5_gz.tif");

stat = zeros(2, 9);
stat(1, :) = 1:9;

for i = 1:9
    index = find(ucm==i);
    x = lstd(index);
    mid = median(x, 'all');
    stat(2, i) = mid*0.02-273.15;
end

%% 风险区识别
% 201=5 301=4   908=3   808=2   906=1
clc;
clear;
[map, rmap] = readgeoraster("syn_catogeried_full.tif");
for i = 1: size(map, 1)
    for j = 1: size(map, 2)
        if map(i, j)==201
            map(i, j) = 5;
        elseif map(i, j)==301
            map(i, j) = 4;
        elseif map(i, j)==908
            map(i, j) = 3;
        elseif map(i, j)==808
            map(i, j) = 2;
        elseif map(i, j)==906
            map(i, j) = 1;
        else 
            map(i, j) = nan;
        end
    end
end
figure;
imshow(map);
colormap 'autumn';

geotiffwrite("risk_spots.tif", map, rmap);
