close all;
clear all;
clc;

%%
%входные данные и параметры
left=rgb2gray(imread('data/Teddy_L.png'));
right=rgb2gray(imread('data/Teddy_R.png'));
[rows,cols]=size(left);
min_disparity=0;
max_disparity=16*4;
P1=8;
P2=32;

%%
%вывод изображений на экран
figure;
imshow(left,[0 255]);
figure;
imshow(right,[0 255]);

%%
%расчет карты глубины
disparity_map=stereo_sg_func( left, right , max_disparity, P1, P2);
%вывод карты глубины на экран
figure;
imshow(disparity_map,[min_disparity max(max(disparity_map))]);



% %%
% %[M,N]=size(im1{1}); %размер изображения
% B=0.2; %база (расстояние между центрами камер)
% f=0.025; %фокусное расстояние
% l=6.5*10^(-6); %размер пиксела
% 
% %размер блока
% blk_sz=7;


%%
%вывод изображений
 
% figure;
% surf(im1{2});
% 
% figure;
% filtered=medfilt2(im1{2},[1*blk_sz 1*blk_sz]);
% imshow(filtered);
% 
% figure;
% mesh(filtered);



                
