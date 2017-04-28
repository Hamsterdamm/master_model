function [ disp ] = stereo_sg_func( left, right , init_disp, max_disparity, P1, P2)
%stereo_sg_func функция для одного прохода методом Semi-Global Matching
%   Detailed explanation goes here

[rows,cols]=size(left);%размеры изображения

disparity_est=zeros(rows,cols);
P_I1_I2=zeros(256,256);%инициализация нулями взаимной плотности вероятности
cost=zeros(rows,cols,max_disparity);%инициализация нулями матрицы счетов
cost_s=zeros(rows,cols,max_disparity);%инициализация нулями матрицы совокупных счетов

%оконтуривание
% left = edge(left,'canny',0.1);
% right = edge(right,'canny',0.1);

%%
%расчет взаимной информации

%взаимная плотность вероятности
for x=1:cols 
    
    for y=1:rows

        d=init_disp(y,x);%значение дальности для (x,y) пиксела
        if isfinite(d)&&(x-d>0)&&(x-d<cols)%еслисмещенный пиксел находится в пределах изображения
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


%энтропия
h1=P_I1.*log(P_I1)*(-1/num_correspondence);
h2=P_I2.*log(P_I2)*(-1/num_correspondence);
h12=P_I1_I2.*log(P_I1_I2)*(-1/num_correspondence);

h = waitbar(0,'Please wait...');

%расчет "стоимостей"
for x=1:cols
    
    waitbar(x/cols)
    
    for y=1:rows
        
        for d=0:(max_disparity-1)
            
            if(((x-d)>0)&&((x-d)<=cols))
            
                i=left(y,x)+1;
                k=right(y,x-d)+1;
                cost(y,x,d+1)=-(h1(i)+h2(k)-h12(i,k));
        
            end
            
        end
            
    end
    
end

%temp_cost=zeros(size(cost));
cost(~isfinite(cost))=0;
%cost=temp_cost;
close(h);


%%
%ограничения
h = waitbar(0,'Please wait...');

wb=0;

waitbar(wb/5)

cost_s(1,:,:)=cost(1,:,:);
cost_s(:,1,:)=cost(:,1,:);
cost_s(rows,:,:)=cost(rows,:,:);
cost_s(:,cols,:)=cost(:,cols,:);

minLi=zeros(1,max_disparity);

wb=0;
waitbar(wb/5)

x0=1;

for y0=1:rows

    wb=wb+y0/rows;
    waitbar(wb/5)
    
    for xr=-1:1

        for yr=-1:1
            
            x=x0+xr; y=y0+yr;

            while (x>1)&&(x<cols)&&(y>1)&&(y<rows)
            
            minLk=min(cost(y-yr,x-xr,:));

            for d=1:(max_disparity)

                if (d==1)
                    minLi(d)=min([minLk+P2 cost(y-yr,x-xr,d) cost(y-yr,x-xr,d+1)+P1]);
                elseif (d==(max_disparity))
                    minLi(d)=min([minLk+P2 cost(y-yr,x-xr,d-1)+P1 cost(y-yr,x-xr,d)]);
                else
                    minLi(d)=min([minLk+P2 cost(y-yr,x-xr,d-1)+P1 cost(y-yr,x-xr,d) cost(y-yr,x-xr,d+1)+P1]);
                end

                cost_s(y,x,d)=cost_s(y,x,d)+cost(y,x,d)+minLi(d)-minLk;
               
            end

            x=x+xr; y=y+yr;
            
            end

        end

    end

end

x0=cols;

for y0=1:rows
    
	wb=wb+y0/rows;
    waitbar(wb/5)

    for xr=-1:1

        for yr=-1:1
            
            x=x0+xr; y=y0+yr;

            while (x>1)&&(x<cols)&&(y>1)&&(y<rows)
            
            minLk=min(cost(y-yr,x-xr,:));

            for d=1:(max_disparity)

                if (d==1)
                    minLi(d)=min([minLk+P2 cost(y-yr,x-xr,d) cost(y-yr,x-xr,d+1)+P1]);
                elseif (d==(max_disparity))
                    minLi(d)=min([minLk+P2 cost(y-yr,x-xr,d-1)+P1 cost(y-yr,x-xr,d)]);
                else
                    minLi(d)=min([minLk+P2 cost(y-yr,x-xr,d-1)+P1 cost(y-yr,x-xr,d) cost(y-yr,x-xr,d+1)+P1]);
                end

                cost_s(y,x,d)=cost_s(y,x,d)+cost(y,x,d)+minLi(d)-minLk;
               
            end

            x=x+xr; y=y+yr;
            
            end

        end

    end

end

y0=1;

for x0=1:cols
    
	wb=wb+x0/rows;
    waitbar(wb/5)

    for xr=-1:1

        for yr=-1:1
            
            x=x0+xr; y=y0+yr;

            while (x>1)&&(x<cols)&&(y>1)&&(y<rows)
            
            minLk=min(cost(y-yr,x-xr,:));

            for d=1:(max_disparity)

                if (d==1)
                    minLi(d)=min([minLk+P2 cost(y-yr,x-xr,d) cost(y-yr,x-xr,d+1)+P1]);
                elseif (d==(max_disparity))
                    minLi(d)=min([minLk+P2 cost(y-yr,x-xr,d-1)+P1 cost(y-yr,x-xr,d)]);
                else
                    minLi(d)=min([minLk+P2 cost(y-yr,x-xr,d-1)+P1 cost(y-yr,x-xr,d) cost(y-yr,x-xr,d+1)+P1]);
                end

                cost_s(y,x,d)=cost_s(y,x,d)+cost(y,x,d)+minLi(d)-minLk;
               
            end

            x=x+xr; y=y+yr;
            
            end

        end

    end

end

y0=rows;

for x0=1:cols
    
	wb=wb+x0/rows;
    waitbar(wb/5)

    for xr=-1:1

        for yr=-1:1
            
            x=x0+xr; y=y0+yr;

            while (x>1)&&(x<cols)&&(y>1)&&(y<rows)
            
            minLk=min(cost(y-yr,x-xr,:));

            for d=1:(max_disparity)

                if (d==1)
                    minLi(d)=min([minLk+P2 cost(y-yr,x-xr,d) cost(y-yr,x-xr,d+1)+P1]);
                elseif (d==(max_disparity))
                    minLi(d)=min([minLk+P2 cost(y-yr,x-xr,d-1)+P1 cost(y-yr,x-xr,d)]);
                else
                    minLi(d)=min([minLk+P2 cost(y-yr,x-xr,d-1)+P1 cost(y-yr,x-xr,d) cost(y-yr,x-xr,d+1)+P1]);
                end

                cost_s(y,x,d)=cost_s(y,x,d)+cost(y,x,d)+minLi(d)-minLk;
               
            end

            x=x+xr; y=y+yr;
            
            end

        end

    end

end

close(h);

%%
%формирование карты глубины

h = waitbar(0,'Please wait...');

%расчет счетов
for x=1:cols
    
    waitbar(x/cols)
    
    for y=1:rows
        
        [~,disp]=min(cost_s(y,x,:),[],3);
        disparity_est(y,x)=disp-1;
                    
    end
    
end

close(h);

disp=disparity_est;

end

