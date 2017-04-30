close all;
clear all;
clc;

%%
%входные данные и параметры
left=rgb2gray(imread('data/Teddy_L.png'));
right=rgb2gray(imread('data/Teddy_R.png'));
[rows,cols]=size(left);
max_disparity=8*8;
P1=8;
P2=32;
uniquenessRatio=2;
disp12MaxDiff=10;

%%
%вывод изображений на экран
%figure;
%imshow(left,[0 255]);
figure;
%imshow(right,[0 255]);
imshowpair(left,right,'montage');


%%
%расчет карты глубины

disparity_map_L=stereo_sg_func( left, right , max_disparity, P1, P2, uniquenessRatio);

%вывод карты глубины на экран
% figure;
% imshow(disparity_map_L,[0 max(max(disparity_map_L))]);

%%
%фильтрация

%загрузка изображения
result=fgs_wls_func(double(disparity_map_L), double(disparity_map_L), 0.5, 3, 0);
figure;
%imshow(result,[0 max(max(result))]);
imshowpair(disparity_map_L,result,'montage','Scaling','joint');

%%
% %для правого изображения
% disparity_map_R=stereo_sg_func( flip(right,2), flip(left,2) , max_disparity, P1, P2, uniquenessRatio);
% disparity_map_R=flip(disparity_map_R,2);
% [rows_disp,cols_disp]=size(disparity_map_L);
% disparity_map=zeros(rows_disp, cols_disp,'uint8');
% 
% for y=1:rows_disp
% 
%     for x=1:cols_disp
%     
%         if (x-disparity_map_L(y,x)>0)&&(x+disparity_map_R(y,x)<cols_disp)
%         
%             if (abs(disparity_map_L(y,x)-disparity_map_R(y,x-disparity_map_L(y,x)))<disp12MaxDiff)&&(abs(disparity_map_R(y,x)-disparity_map_L(y,x+disparity_map_R(y,x)))<disp12MaxDiff)
% 
%                 disparity_map(y,x)=disparity_map_L(y,x);
% 
%             end
%         
%         end
%                   
%     end
%     
% end



% figure;
% imshow(disparity_map_R,[0 max(max(disparity_map_R))]);
% figure;
% imshow(disparity_map,[0 max(max(disparity_map))]);

%%

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



                
