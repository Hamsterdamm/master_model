function [ Lr ] = stereo_sg_cost_travers( x0, y0, cost, max_disparity, cols, rows, P1, P2 )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

%cost_s_new=zeros(size(cost_s));

minLi=zeros(1,1,max_disparity);
Lr=zeros(size(cost));
Lr(y0,x0,:)=cost(y0,x0,:);

    for xr=-1:1

        for yr=-1:1
            
%             if ~(((xr==-2)&&(yr==-2))||((xr==2)&&(yr==2))||((xr==0)&&(yr==0)))
            
                x=x0+xr; y=y0+yr;

                while (x>1)&&(x<cols)&&(y>1)&&(y<rows)

                    minLr=min(Lr(y-yr,x-xr,:));

                    for d=1:(max_disparity)

                        if (d==1)
                            minLi(1,1,d)=min([minLr+P2 Lr(y-yr,x-xr,d) Lr(y-yr,x-xr,d+1)+P1]);
                        elseif (d==(max_disparity))
                            minLi(1,1,d)=min([minLr+P2 Lr(y-yr,x-xr,d-1)+P1 Lr(y-yr,x-xr,d)]);
                        else
                            minLi(1,1,d)=min([minLr+P2 Lr(y-yr,x-xr,d-1)+P1 Lr(y-yr,x-xr,d) Lr(y-yr,x-xr,d+1)+P1]);
                        end

                    end

                    Lr(y,x,:)=cost(y,x,:)+minLi(1,1,:)-minLr;

                    x=x+xr; y=y+yr;

                end

%             end
            
        end

    end

% cost_s=cost_s+Lr;

end

