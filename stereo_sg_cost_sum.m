function [ cost_s ] = stereo_sg_cost_sum( rows, cols, cost, max_disparity, P1, P2)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

cost(~isfinite(cost))=2*P2;
cost_s=zeros(rows,cols,max_disparity);%инициализация нулями матрицы совокупных счетов

%ограничения
h = waitbar(0,'Cost aggregation in progress...');

wb=0;

waitbar(wb/5)

% cost_s(1,:,:)=cost(1,:,:);
% cost_s(:,1,:)=cost(:,1,:);
% cost_s(rows,:,:)=cost(rows,:,:);
% cost_s(:,cols,:)=cost(:,cols,:);

wb=0;
waitbar(wb/4)

x0=1;
for y0=1:rows

    waitbar((wb+y0/rows)/4)
    cost_s=cost_s+stereo_sg_cost_travers( x0, y0, cost, max_disparity, cols, rows, P1, P2 );

end

wb=1;
waitbar(wb/4);

x0=cols;
for y0=1:rows
    
    waitbar((wb+y0/rows)/4)
    cost_s=cost_s+stereo_sg_cost_travers( x0, y0, cost, max_disparity, cols, rows, P1, P2 );

end

wb=2;
waitbar(wb/4);

y0=1;
for x0=1:cols
    
    waitbar((wb+x0/cols)/4)
    cost_s=cost_s+stereo_sg_cost_travers( x0, y0, cost, max_disparity, cols, rows, P1, P2 );

end

wb=3;
waitbar(wb/4);

y0=rows;
for x0=1:cols

    waitbar((wb+x0/cols)/4)
    cost_s=cost_s+stereo_sg_cost_travers( x0, y0, cost, max_disparity, cols, rows, P1, P2 );

end

wb=4;
waitbar(wb/4);
close(h);

end

