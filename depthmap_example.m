clc
clear all
close all


%Initialize images

resize=1/1.1015625;

%загрузка изображений
stereo_pair=rgb2gray(imread('stereo_pair.jpg'));

im1{1}=imresize(stereo_pair(:,1:838/2-120-17),resize);
im2{1}=imresize(stereo_pair(:,838/2+120+1:838-17),resize);

% %оконтуривание
% im1{1} = edge(im1{1},'canny',0.1);
% im2{1} = edge(im2{1},'canny',0.1);

im1{1}=im2double(im1{1})+0.001;
im2{1}=im2double(im2{1})+0.001;

% im_r=imread('Left_Checkerboard_rectified.bmp');
% im_l=imread('Right_Checkerboard_rectified.bmp');
im_r=im1{1};
im_l=im2{1};

%Initialize variables
w=10;
dispmax=55;
 
%Resize images
im_l_res=zeros(size(im_l,1)+2*w,size(im_l,2)+2*w+dispmax);
im_r_res=zeros(size(im_r,1)+2*w,size(im_r,2)+2*w+dispmax);
 
im_l_res(w:end-1-w,w:end-1-w-dispmax)=im_l;
im_r_res(w:end-1-w,w:end-1-w-dispmax)=im_r;
 
im_l_res=uint8(im_l_res);
im_r_res=uint8(im_r_res);
 
%Initialize SAD
%SAD=zeros(size(im_l_res,1),size(im_l_res,2),dispmax+1);
 
for y=w+1:1:size(im_l_res,1)-w %For each epipolar line (row)
y %to see where it is
for x=w+1:1:size(im_l_res,2)-w-dispmax  %For each pixel on that row
left=im_l_res(y-w:y+w,x-w:x+w);
 
for disp=0:1:dispmax
 
right=im_r_res(y-w:y+w,x-w+disp:x+w+disp);
 
%Take the sum of absolute difference
 
SAD(y-5,x-5,disp+1)=sum(abs(left(:)-right(:)));
end
 
end
 
end
 
[SAD_min,SAD_min_loc]=min(SAD,[],3);
imagesc(SAD_min_loc)