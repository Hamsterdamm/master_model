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

%
%загрузка изображений
stereo_pair=rgb2gray(imread('stereo_pair.jpg'));

im1{1}=imresize(stereo_pair(:,1:838/2-120),resize);
im2{1}=imresize(stereo_pair(:,838/2+120+1:838),resize);

%оконтуривание
im1{1} = edge(im1{1},'canny',0.1);
im2{1} = edge(im2{1},'canny',0.1);

im1{1}=im2double(im1{1});
im2{1}=im2double(im2{1});

%%
[M,N]=size(im1{1}); %размер изображения
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
%Фазовая корреляция 
%для поиска среднего смещения одного кадра относительно другого

%БПФ изображений
fft_im1=fft2(im1{1});
fft_im2=fft2(im2{1});

%figure; imshow(fft_im1);
%figure; imshow(fft_im2);

peak=max(max(abs(fft_im1)));%максимальное значение

hadamar=fft_im1.*conj(fft_im2)/peak^2;%взаимная спектральная плотность

%figure; imshow(hadamar);

ifft_hadamar=exp(ifft2(hadamar));%обратное БПФ
ifft_hadamar_max=max(max(ifft_hadamar));%пик фазовой корреляция
%figure; surf(ifft_hadamar);

%координаты пика фазовой корреляции
[Y_shift,X_shift] = find(ifft_hadamar==ifft_hadamar_max);
r_max=4*blk_sz; %максимальная длина вектора движения

%%
%поиск соответствующих точек (метод 3SS)
h = waitbar(0,'Please wait...');

max_dist=0;%максимальная дальность (инициализация нулем)

for i = 1:blk_sz:N-mod(N,blk_sz)-1 
    waitbar(i/(N-mod(N,blk_sz)-1))
        
    for j= 1:blk_sz:M-mod(M,blk_sz)-1 
        
        if (i+blk_sz-1)<N&&(j+blk_sz-1)<M
        
            crd(k,1)=i;
            crd(k,2)=j;
            crd(k,3)=i;
            crd(k,4)=j;
            
            block_ref=double(im1{1}(j:j+blk_sz-1,i:i+blk_sz-1));
            R_max=0;
        
            %число шагов
            
            %шаг перебора
            step=ceil((r_max+1)/2);
            step_count=ceil(log2(r_max+1));
            %начальное приближение
            X=crd(k,1)+X_shift;
            Y=crd(k,2)+Y_shift;

%             step=big_step;
            
%             for step_step=1:step_count
%                 step=ceil(big_step/2^(step_step-1));
                
            while step>=1
    
                    for q=(X-step):step:(X+step)
                        for w=Y
                
                            if q>0&&w>0&&(q+blk_sz-1)<N&&(w+blk_sz-1)<M
                
                                block_test=double(im2{1}(w:w+blk_sz-1,q:q+blk_sz-1));
                                R=abs(corr2(block_ref,block_test));
                                
                                    if R_max<R
                                        R_max=R;
                                        crd(k,3)=q;
                                        crd(k,4)=w;
                                        crd(k,5)=R_max;
                                        
                                    end;
                                    
                                    X=crd(k,3);Y=crd(k,4);
                            end;
                        end;
                    end;
                    
                    step=floor(step/2);
                    
            end;
        
           if (crd(k,5)>0.2)&&(crd(k,1)~=crd(k,3))    
            
                im1{2}(crd(k,2),crd(k,1))=abs(B*f/l./(crd(k,1)-crd(k,3)));
%                 if (im1{2}(crd(k,1),crd(k,2))==inf)
%                     im1{2}(crd(k,1),crd(k,2))=0;
%                 end;
                
                
%                 if (max_dist<im1{2}(crd(k,1),crd(k,2)))&&(im1{2}(crd(k,1),crd(k,2))~=inf)
%                     max_dist=im1{2}(crd(k,1),crd(k,2));
%                 end;
%             else
%             
%                 im1{2}(crd(k,1),crd(k,2))=inf;
            
            end;
%             im1{2}(crd(k,1),crd(k,2))=1/(im1{2}(crd(k,1),crd(k,2)));

            im1{2}(crd(k,2):crd(k,2)+blk_sz-1,crd(k,1):crd(k,1)+blk_sz-1)=im1{2}(crd(k,2),crd(k,1));
 
        k=k+1;
        end;
    
    end;
    
end;

close(h);

%вывод изображений
figure; imshow(im1{1});
figure; imshow(im2{1});

% im1{2}=exp(50.*im1{2});

figure;
surf(im1{2});

max_dist=max(max(im1{2}));
im1{2}=im1{2}/max_dist;

%im1{2}=im1{2}/max_dist;
figure;
imshow(im1{2});

figure;
filtered=medfilt2(im1{2},[1*blk_sz 1*blk_sz]);
imshow(filtered);

figure;
mesh(filtered);

figure;
imshow(filtered.*im1{1});


                
