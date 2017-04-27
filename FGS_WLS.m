close all;
clear all;
clc;

%загрузка изображения
image=double(rgb2gray(imread('Teddy_L.png')));
result=fgs_wls_func(image, image, 5, 3);

figure;
imshow(image,[0 255]);
figure;
imshow(result,[0 255]);
    