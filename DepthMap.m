close all;
clear all;
clc;

resize=1;

min_disparity=0;
max_disparity=16*4;
P1=8;
P2=32;

%
%загрузка изображений

left=rgb2gray(imresize(imread('Teddy_L.png'),resize));
right=rgb2gray(imresize(imread('Teddy_R.png'),resize));
[rows,cols]=size(left);



figure;
imshow(left,[0 255]);
figure;
imshow(right,[0 255]);

resize_0=1/8;
left_0=imresize(left,resize_0);
right_0=imresize(right,resize_0);
max_disparity_0=max_disparity*resize_0;
init_disp=zeros(size(left_0));

disparity_est=stereo_sg_func( left_0, right_0 , init_disp, max_disparity_0, P1, P2);

figure;
imshow(disparity_est,[min_disparity max_disparity]);

resize_1=1/4;
left_1=imresize(left,resize_1);
right_1=imresize(right,resize_1);
max_disparity_1=max_disparity*resize_1;
disparity_est=round(imresize(disparity_est,size(left_1)));
disparity_est=stereo_sg_func( left_1, right_1 , disparity_est, max_disparity_1, P1, P2);

figure;
imshow(disparity_est,[min_disparity max_disparity]);

resize_2=1/2;
left_2=imresize(left,resize_2);
right_2=imresize(right,resize_2);
max_disparity_2=max_disparity*resize_2;
disparity_est=round(imresize(disparity_est,size(left_2)));
disparity_est=stereo_sg_func( left_2, right_2 , disparity_est, max_disparity_2, P1, P2);

figure;
imshow(disparity_est,[min_disparity max_disparity]);

resize_3=1;
left_3=imresize(left,resize_3);
right_3=imresize(right,resize_3);
max_disparity_3=max_disparity*resize_3;
disparity_est=round(imresize(disparity_est,size(left_3)));
disparity_est=stereo_sg_func( left_3, right_3 , disparity_est, max_disparity_3, P1, P2);

figure;
imshow(disparity_est,[min_disparity max_disparity]);



%%
%[M,N]=size(im1{1}); %размер изображения
B=0.2; %база (расстояние между центрами камер)
f=0.025; %фокусное расстояние
l=6.5*10^(-6); %размер пиксела

%размер блока
blk_sz=7;


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



                
