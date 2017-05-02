function [ cost ] = stereo_sg_cost( left, right , init_disp, max_disparity)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[rows,cols]=size(left);%размеры изображения

P_I1_I2=zeros(256,256);%инициализация нулями взаимной плотности вероятности
cost=inf(rows,cols,max_disparity);%инициализация нулями матрицы счетов

%расчет взаимной информации

%взаимная плотность вероятности
for x=1:cols 
    
    for y=1:rows

        d=init_disp(y,x);%значение дальности для (x,y) пиксела
        
        if isfinite(d)&&(x-d>0)&&(x-d<cols)%если смещенный пиксел находится в пределах изображения
            i=left(y,x)+1;%i-я яркость - яркость пиксела (x,y)
            k=right(y,x-d)+1;%k-я яркость - яркость смещенного пиксела (x-d,y)
            %добавляем 1 т.к. яркости от 0 до 255, а массив плотности
            %вероятности от 1 до 256

            P_I1_I2(k,i)=P_I1_I2(k,i)+1;%запоминаем +1 пиксел 
                                        %с яркостью i на левом изображении 
                                        %и яркостью k на правом
        end       
    end
end

num_correspondence=sum(sum(P_I1_I2)); %число соответствий
P_I1_I2=P_I1_I2/num_correspondence; %делим распределение на число соответствий

%распределение вероятности для каждого изображения
P_I1=sum(P_I1_I2);%суммируем все вероятности вдоль столбцов
P_I2=sum(transpose(P_I1_I2));%суммируем все вероятности вдоль строк

% filter2d = fspecial('gaussian', size(P_I1_I2)); % gaussian kernel
% filter1d = fspecial('gaussian', size(P_I1)); % gaussian kernel
% P_I1_I2_F=conv2(P_I1_I2, filter2d, 'same');
% P_I1_F=conv(P_I1, filter1d, 'same');
% P_I2_F=conv(P_I2, filter1d, 'same');
% 
% P_I1_I2_F_log=log(P_I1_I2_F);
% P_I1_F_log=log(P_I1_F);
% P_I2_F_log=log(P_I2_F);
% P_I1_I2_F_log(~isfinite(P_I1_I2_F_log))=0;
% P_I1_F_log(~isfinite(P_I1_F_log))=0;
% P_I2_F_log(~isfinite(P_I2_F_log))=0;
% 
% P_I1_I2_F_log_F=conv2(P_I1_I2_F_log, filter2d, 'same');
% P_I1_F_log_F=conv(P_I1_F_log, filter1d, 'same');
% P_I2_F_log_F=conv(P_I2_F_log, filter1d, 'same');
% 
% %энтропия
% h12=P_I1_I2_F_log_F*(-1/num_correspondence);
% h1=P_I1_F_log_F*(-1/num_correspondence);
% h2=P_I2_F_log_F*(-1/num_correspondence);

%энтропия
h12=-log(P_I1_I2)/num_correspondence;
h1=-log(P_I1)/num_correspondence;
h2=-log(P_I2)/num_correspondence;

h = waitbar(0,'Cost computation in progress...');

%расчет "стоимостей"
for x=1:cols
    
    waitbar(x/cols)
    
    for y=1:rows
        
        for d=0:(max_disparity-1)
            
            if(((x-d)>0)&&((x-d)<=cols))
            
                i=left(y,x)+1;
                k=right(y,x-d)+1;
                cost(y,x,d+1)=-(-h12(k,i));%h1(i)+h2(k)
        
            end
            
        end
            
    end
    
end


%cost(~isfinite(cost))=0;

close(h);

end

