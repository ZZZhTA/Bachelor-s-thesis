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