%% boxplot & violin plot
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