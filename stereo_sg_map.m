function [ disp ] = stereo_sg_map( rows, cols, cost, uniquenessRatio)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

disp=nan(rows, cols);

%формирование карты глубины

h = waitbar(0,'Depth map computation in progress...');

%расчет счетов
for x=1:cols
    
    waitbar(x/cols)
    
    for y=1:rows
       
        [dmin,d]=min(cost(y,x,:),[],3);
        if isfinite(dmin)
            disp(y,x)=d-1;
        else
            disp(y,x)=nan;
        end
         
    end
    
end

close(h);

end

