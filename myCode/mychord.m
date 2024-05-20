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