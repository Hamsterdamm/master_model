function [ cost ] = stereo_sg_cost( left, right , init_disp, max_disparity)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[rows,cols]=size(left);%������� �����������

P_I1_I2=zeros(256,256);%������������� ������ �������� ��������� �����������
cost=zeros(rows,cols,max_disparity);%������������� ������ ������� ������

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


%��������
h1=log(P_I1)*(-1/num_correspondence);
h2=log(P_I2)*(-1/num_correspondence);
h12=log(P_I1_I2)*(-1/num_correspondence);

h = waitbar(0,'Please wait...');

%������ "����������"
for x=1:cols
    
    waitbar(x/cols)
    
    for y=1:rows
        
        for d=0:(max_disparity-1)
            
            if(((x-d)>0)&&((x-d)<=cols))
            
                i=left(y,x)+1;
                k=right(y,x-d)+1;
                cost(y,x,d+1)=-(h1(i)+h2(k)-h12(i,k));
        
            end
            
        end
            
    end
    
end

%temp_cost=zeros(size(cost));
cost(~isfinite(cost))=0;
%cost=temp_cost;
close(h);

end
