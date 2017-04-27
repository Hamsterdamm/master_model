function [ output ] = fgs_wls_v( input, guidance, lambda, varargin )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

output=zeros(size(input));
out_ind=zeros(size(input));
[rows,cols]=size(input);
weights=zeros(rows,rows);
laplacian=zeros(rows,rows);
I=eye(rows);

for x=1:cols

f=input(:,x);
g=guidance(:,x);
variance=var(g);

for p=1:rows
    
    for q=1:rows
        
        weights(p,q)=exp(-abs(g(p)-g(q))/variance);
        
    end
    
end

for m=1:rows
    
    for n=1:rows
        
            
        if (m==n)
            if (m==1)
                laplacian(m,n)=weights(m,m+1);
            elseif (m==rows)
                laplacian(m,n)=weights(m,m-1);
            else
                laplacian(m,n)=weights(m,m-1)+weights(m,m+1);
            end
        elseif (n==(m-1))||(n==(m+1))
            laplacian(m,n)=-weights(m,n);
        else
            laplacian(m,n)=0;
        end
        

    end
    
end

output(:,x)=(I+lambda*laplacian)\f;

if size(varargin)>0
index=f(f>5);
out_ind(:,x)=(I+lambda*laplacian)\index;
output(:,x)=output(:,x)./out_ind(:,x);
end

end

end

