function [ Result ] = path_sg(xr,yr, x,y, d, cost, P1, P2, max_disparity, cols, rows )
%path Summary of this function goes here
%   Detailed explanation goes here

Result=zeros(1,max_disparity*2-1);

if ((x==1)||(y==1)||(x==cols)||(y==rows))

    for id=1:(max_disparity*2-1)
        
        Result(id)=cost(y,x,id);
    
    end;
    
else

    if ((x-xr>0)&&(y-yr>0)&&(x-xr<=cols)&&(y-yr<=rows))

        %path_d=zeros(1,max_disparity*2-1);
        
        %for id=1:(max_disparity*2-1)
            
        path_d=path_sg(xr,yr, x-xr,y-yr, d, cost, P1, P2, max_disparity, cols, rows  );

        %end;
        
        min_path=min(path_d);
       
        for id=1:(max_disparity*2-1)
            
            path_d_0=path_d(id);
            
            if id-1>0
                path_d_m1=path_d(id-1);
            else
                path_d_m1=path_d_0;
            end


            if id+1<=max_disparity*2-1
                path_d_p1=path_d(id+1);
            else
                path_d_p1=path_d_0;
            end

            for id=1:(max_disparity*2-1)        


            term=min([path_d_0, path_d_m1+P1, path_d_p1+P1, min_path+P2]);

            Result(id)=cost(y,x,id)+term-min_path;


            end;
            
        end;

    else

        for id=1:(max_disparity*2-1)
        
            Result(id)=cost(y,x,id);
    
        end;

    end;
    
end


end

