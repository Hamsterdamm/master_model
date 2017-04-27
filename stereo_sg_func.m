function [ disp ] = stereo_sg_func( left, right , init_disp, max_disparity, P1, P2)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

[rows,cols]=size(left);

stereo_sg=struct(   'left', left,...
                    'right', right,...
                    'disparity',init_disp,...
                    'disparity_est',zeros(rows,cols),...
                    'P_I1_I2',zeros(256,256),...
                    'num_correspondence',0,...
                    'P_I1',zeros(1,256),...
                    'P_I2',zeros(1,256),...
                    'cost',zeros(rows,cols,max_disparity),...
                    'h1',zeros(1,256),...
                    'h2',zeros(1,256),...
                    'h12',zeros(256,256),...
                    'cost_s',zeros(rows,cols,max_disparity),...
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
        if (x-d>0)&&(x-d<stereo_sg.cols)
        i=stereo_sg.left(y,x)+1;
       
        k=stereo_sg.right(y,x-d)+1;
        
        stereo_sg.P_I1_I2(k,i)=stereo_sg.P_I1_I2(k,i)+1;
        end       
    end
    
end

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
        
        for d=1:(max_disparity)
            
            if(((x-d)>0)&&((x-d)<=stereo_sg.cols))
            
                i=stereo_sg.left(y,x)+1;
                k=stereo_sg.right(y,x-d)+1;
                stereo_sg.cost(y,x,d)=stereo_sg.h12(i,k)-stereo_sg.h1(i)-stereo_sg.h2(k);
        
            end
            
        end
            
    end
    
end

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

wb=0;

waitbar(wb/5)

stereo_sg.cost_s(1,:,:)=stereo_sg.cost(1,:,:);
stereo_sg.cost_s(:,1,:)=stereo_sg.cost(:,1,:);
stereo_sg.cost_s(stereo_sg.rows,:,:)=stereo_sg.cost(stereo_sg.rows,:,:);
stereo_sg.cost_s(:,stereo_sg.cols,:)=stereo_sg.cost(:,stereo_sg.cols,:);

minLi=zeros(1,max_disparity);

wb=0;
waitbar(wb/5)

x0=1;

for y0=1:stereo_sg.rows

    wb=wb+y0/stereo_sg.rows;
    waitbar(wb/5)
    
    for xr=-1:1

        for yr=-1:1
            
            x=x0+xr; y=y0+yr;

            while (x>1)&&(x<stereo_sg.cols)&&(y>1)&&(y<stereo_sg.rows)
            
            minLk=min(stereo_sg.cost(y-yr,x-xr,:));

            for d=1:(max_disparity)

                if (d==1)
                    minLi(d)=min([minLk+P2 stereo_sg.cost(y-yr,x-xr,d) stereo_sg.cost(y-yr,x-xr,d+1)+P1]);
                elseif (d==(max_disparity))
                    minLi(d)=min([minLk+P2 stereo_sg.cost(y-yr,x-xr,d-1)+P1 stereo_sg.cost(y-yr,x-xr,d)]);
                else
                    minLi(d)=min([minLk+P2 stereo_sg.cost(y-yr,x-xr,d-1)+P1 stereo_sg.cost(y-yr,x-xr,d) stereo_sg.cost(y-yr,x-xr,d+1)+P1]);
                end

                stereo_sg.cost_s(y,x,d)=stereo_sg.cost_s(y,x,d)+stereo_sg.cost(y,x,d)+minLi(d)-minLk;
               
            end

            x=x+xr; y=y+yr;
            
            end

        end

    end

end

x0=stereo_sg.cols;

for y0=1:stereo_sg.rows
    
	wb=wb+y0/stereo_sg.rows;
    waitbar(wb/5)

    for xr=-1:1

        for yr=-1:1
            
            x=x0+xr; y=y0+yr;

            while (x>1)&&(x<stereo_sg.cols)&&(y>1)&&(y<stereo_sg.rows)
            
            minLk=min(stereo_sg.cost(y-yr,x-xr,:));

            for d=1:(max_disparity)

                if (d==1)
                    minLi(d)=min([minLk+P2 stereo_sg.cost(y-yr,x-xr,d) stereo_sg.cost(y-yr,x-xr,d+1)+P1]);
                elseif (d==(max_disparity))
                    minLi(d)=min([minLk+P2 stereo_sg.cost(y-yr,x-xr,d-1)+P1 stereo_sg.cost(y-yr,x-xr,d)]);
                else
                    minLi(d)=min([minLk+P2 stereo_sg.cost(y-yr,x-xr,d-1)+P1 stereo_sg.cost(y-yr,x-xr,d) stereo_sg.cost(y-yr,x-xr,d+1)+P1]);
                end

                stereo_sg.cost_s(y,x,d)=stereo_sg.cost_s(y,x,d)+stereo_sg.cost(y,x,d)+minLi(d)-minLk;
               
            end

            x=x+xr; y=y+yr;
            
            end

        end

    end

end

y0=1;

for x0=1:stereo_sg.cols
    
	wb=wb+x0/stereo_sg.rows;
    waitbar(wb/5)

    for xr=-1:1

        for yr=-1:1
            
            x=x0+xr; y=y0+yr;

            while (x>1)&&(x<stereo_sg.cols)&&(y>1)&&(y<stereo_sg.rows)
            
            minLk=min(stereo_sg.cost(y-yr,x-xr,:));

            for d=1:(max_disparity)

                if (d==1)
                    minLi(d)=min([minLk+P2 stereo_sg.cost(y-yr,x-xr,d) stereo_sg.cost(y-yr,x-xr,d+1)+P1]);
                elseif (d==(max_disparity))
                    minLi(d)=min([minLk+P2 stereo_sg.cost(y-yr,x-xr,d-1)+P1 stereo_sg.cost(y-yr,x-xr,d)]);
                else
                    minLi(d)=min([minLk+P2 stereo_sg.cost(y-yr,x-xr,d-1)+P1 stereo_sg.cost(y-yr,x-xr,d) stereo_sg.cost(y-yr,x-xr,d+1)+P1]);
                end

                stereo_sg.cost_s(y,x,d)=stereo_sg.cost_s(y,x,d)+stereo_sg.cost(y,x,d)+minLi(d)-minLk;
               
            end

            x=x+xr; y=y+yr;
            
            end

        end

    end

end

y0=stereo_sg.rows;

for x0=1:stereo_sg.cols
    
	wb=wb+x0/stereo_sg.rows;
    waitbar(wb/5)

    for xr=-1:1

        for yr=-1:1
            
            x=x0+xr; y=y0+yr;

            while (x>1)&&(x<stereo_sg.cols)&&(y>1)&&(y<stereo_sg.rows)
            
            minLk=min(stereo_sg.cost(y-yr,x-xr,:));

            for d=1:(max_disparity)

                if (d==1)
                    minLi(d)=min([minLk+P2 stereo_sg.cost(y-yr,x-xr,d) stereo_sg.cost(y-yr,x-xr,d+1)+P1]);
                elseif (d==(max_disparity))
                    minLi(d)=min([minLk+P2 stereo_sg.cost(y-yr,x-xr,d-1)+P1 stereo_sg.cost(y-yr,x-xr,d)]);
                else
                    minLi(d)=min([minLk+P2 stereo_sg.cost(y-yr,x-xr,d-1)+P1 stereo_sg.cost(y-yr,x-xr,d) stereo_sg.cost(y-yr,x-xr,d+1)+P1]);
                end

                stereo_sg.cost_s(y,x,d)=stereo_sg.cost_s(y,x,d)+stereo_sg.cost(y,x,d)+minLi(d)-minLk;
               
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

%расчет "стоимостей"
for x=1:stereo_sg.cols
    
    waitbar(x/stereo_sg.cols)
    
    for y=1:stereo_sg.rows
        
        [~,disp]=min(stereo_sg.cost_s(y,x,:));
        stereo_sg.disparity_est(y,x)=disp;
                    
    end
    
end

close(h);

disp=stereo_sg.disparity_est;

end

