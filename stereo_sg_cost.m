function [ cost ] = stereo_sg_cost( left, right , init_disp, max_disparity)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[rows,cols]=size(left);%������� �����������

P_I1_I2=zeros(256,256);%������������� ������ �������� ��������� �����������
cost=inf(rows,cols,max_disparity);%������������� ������ ������� ������

%������ �������� ����������

%�������� ��������� �����������
for x=1:cols 
    
    for y=1:rows

        d=init_disp(y,x);%�������� ��������� ��� (x,y) �������
        
        if isfinite(d)&&(x-d>0)&&(x-d<cols)%���� ��������� ������ ��������� � �������� �����������
            i=left(y,x)+1;%i-� ������� - ������� ������� (x,y)
            k=right(y,x-d)+1;%k-� ������� - ������� ���������� ������� (x-d,y)
            %��������� 1 �.�. ������� �� 0 �� 255, � ������ ���������
            %����������� �� 1 �� 256

            P_I1_I2(k,i)=P_I1_I2(k,i)+1;%���������� +1 ������ 
                                        %� �������� i �� ����� ����������� 
                                        %� �������� k �� ������
        end       
    end
end

num_correspondence=sum(sum(P_I1_I2)); %����� ������������
P_I1_I2=P_I1_I2/num_correspondence; %����� ������������� �� ����� ������������

%������������� ����������� ��� ������� �����������
P_I1=sum(P_I1_I2);%��������� ��� ����������� ����� ��������
P_I2=sum(transpose(P_I1_I2));%��������� ��� ����������� ����� �����

% filter2d = fspecial('gaussian', size(P_I1_I2)); % gaussian kernel
% filter1d = fspecial('gaussian', size(P_I1)); % gaussian kernel
% P_I1_I2_F=conv2(P_I1_I2, filter2d, 'same');
% P_I1_F=conv(P_I1, filter1d, 'same');
% P_I2_F=conv(P_I2, filter1d, 'same');
% 
% P_I1_I2_F_log=log(P_I1_I2_F);
% P_I1_F_log=log(P_I1_F);
% P_I2_F_log=log(P_I2_F);
% P_I1_I2_F_log(~isfinite(P_I1_I2_F_log))=0;
% P_I1_F_log(~isfinite(P_I1_F_log))=0;
% P_I2_F_log(~isfinite(P_I2_F_log))=0;
% 
% P_I1_I2_F_log_F=conv2(P_I1_I2_F_log, filter2d, 'same');
% P_I1_F_log_F=conv(P_I1_F_log, filter1d, 'same');
% P_I2_F_log_F=conv(P_I2_F_log, filter1d, 'same');
% 
% %��������
% h12=P_I1_I2_F_log_F*(-1/num_correspondence);
% h1=P_I1_F_log_F*(-1/num_correspondence);
% h2=P_I2_F_log_F*(-1/num_correspondence);

%��������
h12=-log(P_I1_I2)/num_correspondence;
h1=-log(P_I1)/num_correspondence;
h2=-log(P_I2)/num_correspondence;

h = waitbar(0,'Cost computation in progress...');

%������ "����������"
for x=1:cols
    
    waitbar(x/cols)
    
    for y=1:rows
        
        for d=0:(max_disparity-1)
            
            if(((x-d)>0)&&((x-d)<=cols))
            
                i=left(y,x)+1;
                k=right(y,x-d)+1;
                cost(y,x,d+1)=-(-h12(k,i));%h1(i)+h2(k)
        
            end
            
        end
            
    end
    
end


%cost(~isfinite(cost))=0;

close(h);

end

