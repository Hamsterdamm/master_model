function [ Result ] = path_sg(xr,yr, x,y, d, cost, P1, P2, max_disparity, cols, rows )
%path Summary of this function goes here
%   Detailed explanation goes here

if ((x==1)||(y==1)||(x==cols)||(y==rows))
    
    Result=cost(y,x,d);
    
else

    if ((x-xr>0)&&(y-yr>0)&&(d-1>0)&&(d+1<max_disparity*2-1))

        path_d=zeros(1,max_disparity*2-1);
        
        for id=1:(max_disparity*2-1)
            
            path_d(id)=path_sg(xr,yr, x-xr,y-yr, id, cost, P1, P2, max_disparity, cols, rows  );

        end;
        
        min_path=min(path_d);

        %for id=1:(max_disparity*2-1)
            
        path_d_0=path_d(d);
        path_d_m1=path_d(d-1);
        path_d_p1=path_d(d+1);
        
        term=min([path_d_0, path_d_m1+P1, path_d_p1+P1, min_path+P2]);
        Result=cost(y,x,d)+term-min_path;
        
        %end

    else

        Result=cost(y,x,d);

    end;
    
end


end

