close all;
clear all;
clc;

%%
%������� ������ � ���������
left=rgb2gray(imread('data/Teddy_L.png'));
right=rgb2gray(imread('data/Teddy_R.png'));
[rows,cols]=size(left);
min_disparity=0;
max_disparity=16*4;
P1=8;
P2=32;

%%
%����� ����������� �� �����
figure;
imshow(left,[0 255]);
figure;
imshow(right,[0 255]);

%%
%������ ����� �������
disparity_map=stereo_sg_func( left, right , max_disparity, P1, P2);
%����� ����� ������� �� �����
figure;
imshow(disparity_map,[min_disparity max(max(disparity_map))]);



% %%
% %[M,N]=size(im1{1}); %������ �����������
% B=0.2; %���� (���������� ����� �������� �����)
% f=0.025; %�������� ����������
% l=6.5*10^(-6); %������ �������
% 
% %������ �����
% blk_sz=7;


%%
%����� �����������
 
% figure;
% surf(im1{2});
% 
% figure;
% filtered=medfilt2(im1{2},[1*blk_sz 1*blk_sz]);
% imshow(filtered);
% 
% figure;
% mesh(filtered);



                
