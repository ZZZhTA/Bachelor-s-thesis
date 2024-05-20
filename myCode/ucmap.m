%% test threshold
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

%% define climatope
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
geotiffwrite('ucmap_test3.tif', result1, rfad);

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
