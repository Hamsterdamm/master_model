function [ cost_s ] = stereo_sg_cost_sum( rows, cols, cost, max_disparity, P1, P2)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

cost_s=zeros(rows,cols,max_disparity);%инициализация нулями матрицы совокупных счетов

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

end

