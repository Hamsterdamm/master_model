function [ cost_s ] = stereo_sg_cost_travers( cost_s, x0, y0, cost, max_disparity, cols, rows, P1, P2 )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

minLi=zeros(1,max_disparity);

    for xr=-1:1

        for yr=-1:1
            
            if ((xr~=0)||(yr~=0))
            
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

end

