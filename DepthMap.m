close all;
clear all;
clc;

resize=1;


max_disparity=50;

%
%загрузка изображений

left=rgb2gray(imread('Teddy_L.png'));
right=rgb2gray(imread('Teddy_R.png'));
[rows,cols]=size(left);

stereo_sg=struct(   'left', imresize(left,resize),...
                    'right', imresize(right,resize),...
                    'disparity',zeros(rows,cols),...
                    'P_I1_I2',zeros(256,256),...
                    'num_correspondence',0,...
                    'P_I1',zeros(1,256),...
                    'P_I2',zeros(1,256),...
                    'cost',zeros(rows,cols,max_disparity*2-1),...
                    'h1',zeros(1,256),...
                    'h2',zeros(1,256),...
                    'h12',zeros(256,256),...
                    'cost_s',zeros(rows,cols,max_disparity*2-1),...
                    'rows',rows,...
                    'cols',cols...
                    );

%оконтуривание
% stereo_sg.left = edge(stereo_sg.left,'canny',0.1);
% stereo_sg.right = edge(stereo_sg.right,'canny',0.1);

stereo_sg.left=double(stereo_sg.left);
stereo_sg.right=double(stereo_sg.right);

%%
%расчет взаимной информации

%взаимная плотность вероятности

for x=1:stereo_sg.cols 
    
    for y=1:stereo_sg.rows

        d=stereo_sg.disparity(y,x);
        i=stereo_sg.left(y,x)+1;
        k=stereo_sg.right(y,x-d)+1;
        stereo_sg.P_I1_I2(k,i)=stereo_sg.P_I1_I2(k,i)+1;
        
    end;
    
end;

stereo_sg.num_correspondence=sum(sum(stereo_sg.P_I1_I2)); %число соответствий
stereo_sg.P_I1_I2=stereo_sg.P_I1_I2/stereo_sg.num_correspondence; %делим распределение на число соответствий

%распределение вероятности для каждого изображения
stereo_sg.P_I1=sum(stereo_sg.P_I1_I2);
stereo_sg.P_I2=sum(transpose(stereo_sg.P_I1_I2));


%энтропия
stereo_sg.h1=log2(stereo_sg.P_I1)*(-1/stereo_sg.num_correspondence);
stereo_sg.h2=log2(stereo_sg.P_I2)*(-1/stereo_sg.num_correspondence);
stereo_sg.h12=log2(stereo_sg.P_I1_I2)*(-1/stereo_sg.num_correspondence);

h = waitbar(0,'Please wait...');

%расчет "стоимостей"
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

%cost_s_d=zeros(1,max_disparity*2-1);

% for 
% if ((x==1)||(y==1)||(x==cols)||(y==rows))
% 
% stereo_sg.cost_s(y,x,d);
% 
% end;

stereo_sg.cost_s(1,:,:)=stereo_sg.cost(1,:,:);
stereo_sg.cost_s(:,1,:)=stereo_sg.cost(:,1,:);
stereo_sg.cost_s(stereo_sg.rows,:,:)=stereo_sg.cost(stereo_sg.rows,:,:);
stereo_sg.cost_s(:,stereo_sg.cols,:)=stereo_sg.cost(:,stereo_sg.cols,:);

for x=1:stereo_sg.cols
    
    waitbar(x/stereo_sg.cols)
    
    for y=1:stereo_sg.rows
        
        
            
        for xr=-1:1

            for yr=-1:1


                    cost_s_d=path_sg(xr,yr,x,y,d,stereo_sg.cost,0.5,0.8, max_disparity, stereo_sg.cols, stereo_sg.rows);
                    
                    for d=1:(max_disparity*2-1)
                    
                    stereo_sg.cost_s(y,x,d)=stereo_sg.cost_s(y,x,d)+cost_s_d(d);

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


                
