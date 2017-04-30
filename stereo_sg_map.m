function [ disp ] = stereo_sg_map( rows, cols, cost, uniquenessRatio)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

disp=zeros(rows, cols,'uint8');

%формирование карты глубины

h = waitbar(0,'Please wait...');

%расчет счетов
for x=1:cols
    
    waitbar(x/cols)
    
    for y=1:rows
       
        [~,d]=min(cost(y,x,:),[],3);
        disp(y,x)=d-1;
         
    end
    
end

close(h);


end

