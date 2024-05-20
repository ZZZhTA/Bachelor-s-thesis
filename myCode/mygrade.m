%% 热风险分级——横向百分比堆叠柱状图
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
