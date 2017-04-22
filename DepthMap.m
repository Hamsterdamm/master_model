close all;
clear all;
clc;

resize=1;

% %%
% %загрузка изображений
% 
% im1{1}=imresize(imread('left.png'),resize);
% im2{1}=imresize(imread('right.png'),resize);
% 
% %оконтуривание
% im1{1} = edge(im1{1},'canny',0.1);
% im2{1} = edge(im2{1},'canny',0.1);
% 
% im1{1}=im2double(im1{1});
% im2{1}=im2double(im2{1});

max_disparity=50;

%
%загрузка изображений
stereo_pair=rgb2gray(imread('stereo_pair.jpg'));
field1='left';
value1=imresize(stereo_pair(:,1:838/2-120),resize);
field2='right';
value2=imresize(stereo_pair(:,838/2+120+1:838),resize);
[rows,cols]=size(value1);
field3='disparity';
value3=zeros(rows,cols);
field4='P_I1_I2';
value4=zeros(256,256);
field5='num_correspondence';
value5=0;
field6='P_I1';
value6=zeros(1,256);
field7='P_I2';
value7=zeros(1,256);
field8='cost';
value8=zeros(rows,cols,max_disparity*2-1);
field9='h1';
value9=zeros(1,256);
field10='h2';
value10=zeros(1,256);
field11='h12';
value11=zeros(256,256);
field12='cost_s';
value12=zeros(rows,cols,max_disparity*2-1);

stereo_sg=struct(field1,value1,field2,value2,field3,value3,field4,value4,field5,value5,field6,value6,field7,value7,field8,value8,field9,value9,field10,value10,field11,value11,field12,value12,'rows',rows,'cols',cols);

%оконтуривание
% stereo_sg.left = edge(stereo_sg.left,'canny',0.1);
% stereo_sg.right = edge(stereo_sg.right,'canny',0.1);

stereo_sg.left=double(stereo_sg.left);
stereo_sg.right=double(stereo_sg.right);

%%
%расчет взаимной информации

for x=1:stereo_sg.cols
    
    for y=1:stereo_sg.rows

        d=stereo_sg.disparity(y,x);
        i=stereo_sg.left(y,x)+1;
        k=stereo_sg.right(y,x-d)+1;
        stereo_sg.P_I1_I2(i,k)=stereo_sg.P_I1_I2(i,k)+1;
        
    end;
    
end;

stereo_sg.num_correspondence=sum(sum(stereo_sg.P_I1_I2));
stereo_sg.P_I1_I2=stereo_sg.P_I1_I2/stereo_sg.num_correspondence;

for i=1:256
    
    stereo_sg.P_I1(i)=sum(stereo_sg.P_I1_I2(i,:));
    stereo_sg.P_I2(i)=sum(stereo_sg.P_I1_I2(:,i));
    
end;

for i=1:256
    
    stereo_sg.h1(i)=-1/stereo_sg.num_correspondence*log2(stereo_sg.P_I1(i));
    stereo_sg.h2(i)=-1/stereo_sg.num_correspondence*log2(stereo_sg.P_I2(i));
    
    for k=1:256
        
        stereo_sg.h12(i,k)=-1/stereo_sg.num_correspondence*log2(stereo_sg.P_I1_I2(i,k));
        
    end;
    
end;

h = waitbar(0,'Please wait...');

for x=1:stereo_sg.cols
    
    waitbar(x/stereo_sg.cols)
    
    for y=1:stereo_sg.rows
        
        for d=1:(max_disparity*2-1)
            
            if(((x-d+max_disparity)>0)&&((x-d+max_disparity)<=stereo_sg.cols))
            
                i=stereo_sg.left(y,x)+1;
                k=stereo_sg.right(y,x-d+max_disparity)+1;
                stereo_sg.cost(y,x,d)=stereo_sg.h12(i,k)-stereo_sg.h1(i)-stereo_sg.h2(k);
        
            end;
            
        end;
            
    end;
    
end;

close(h);


%%
%ограничения
h = waitbar(0,'Please wait...');

for x=1:stereo_sg.cols
    
    waitbar(x/stereo_sg.cols)
    
    for y=1:stereo_sg.rows
        
        for d=1:(max_disparity*2-1)
            
            for xr=-1:1

                for yr=-1:1

                    %cost_s_d=
                    stereo_sg.cost_s(y,x,d)=stereo_sg.cost_s(y,x,d)+path_sg(xr,yr,x,y,d,stereo_sg.cost,0.5,0.8, max_disparity, stereo_sg.cols, stereo_sg.rows);

                end;

            end;

        end;
            
    end;
    
end;

close(h);
%%
%[M,N]=size(im1{1}); %размер изображения
B=0.2; %база (расстояние между центрами камер)
f=0.025; %фокусное расстояние
l=6.5*10^(-6); %размер пиксела

%размер блока
blk_sz=7;


%массивы найденных соответствий точек (инициализация нулями)
crd = zeros(M*N,5);
im1{2} = zeros(M,N);
k=1;%нумерация элементов этого массива

% mask = [1 1 1; 1 0 1; 1 1 1];






%%
%поиск соответствующих точек
% h = waitbar(0,'Please wait...');
% 
% max_dist=0;%максимальная дальность (инициализация нулем)
% 
% 
% waitbar(i/(N-mod(N,blk_sz)-1))
% close(h);

h

%%
%вывод изображений
% figure; imshow(im1{1});
% figure; imshow(im2{1});
% 
% % im1{2}=exp(50.*im1{2});
% 
% figure;
% surf(im1{2});
% 
% max_dist=max(max(im1{2}));
% im1{2}=im1{2}/max_dist;
% 
% %im1{2}=im1{2}/max_dist;
% figure;
% imshow(im1{2});
% 
% figure;
% filtered=medfilt2(im1{2},[1*blk_sz 1*blk_sz]);
% imshow(filtered);
% 
% figure;
% mesh(filtered);
% 
% figure;
% imshow(filtered.*im1{1});


                
