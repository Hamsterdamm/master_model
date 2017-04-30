function [ disp ] = stereo_sg_func( left, right , max_disparity, P1, P2, uniquenessRatio)
%stereo_sg_func функция для одного прохода методом Semi-Global Matching
%   Detailed explanation goes here

%оконтуривание
% left = edge(left,'canny',0.1);
% right = edge(right,'canny',0.1);

%[rows,cols]=size(left);%размеры изображения

init_disp=zeros(size(left),'uint8');

h = waitbar(0,'Cost computation in progress...');

for i=0:3
    
    waitbar(i/3)
    
    resize=1/2^(3-i);
    left_res=imresize(left,resize);
    right_res=imresize(right,resize);
    max_disparity_res=max_disparity*resize;
    init_disp=2*round(imresize(init_disp,size(left_res)));
    
%     figure;
%     imshow(init_disp,[0 max_disparity_res]);
    [rows_res,cols_res]=size(left_res);%размеры изображения
    
    cost=stereo_sg_cost( left_res, right_res , init_disp, max_disparity_res);
    init_disp=stereo_sg_map( rows_res, cols_res, cost, uniquenessRatio);
    
    figure;
    imshow(init_disp,[0 max_disparity_res]);
        
end

close(h);

%%
cost_s=stereo_sg_cost_sum(rows_res,cols_res, cost, max_disparity_res, P1, P2);

%%
disp_prefilt=stereo_sg_map( rows_res,cols_res, cost_s, uniquenessRatio);

disp=medfilt2(disp_prefilt);

end

