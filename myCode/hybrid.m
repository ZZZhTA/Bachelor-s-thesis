%% 混合图制作
% synthetized map栅格值 = ucmap*100 + lcz；即百位数字代表ucmap类别，后两位代表lcz类别
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