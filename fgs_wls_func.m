function [ output ] = fgs_wls_func( input, guidance, lambda, T, varargin )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

temp=input;

for t=1:T
    lam=3/2*((4^(T-t))/(4^T-1))*lambda;
    temp=fgs_wls_h(temp,guidance,lam);
    temp=fgs_wls_v(temp,guidance,lam);
end

output=temp;

end

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

function [ output ] = fgs_wls_h( input, guidance, lambda, varargin )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

output=zeros(size(input));
out_ind=zeros(size(input));
[rows,cols]=size(input);
weights=zeros(cols,cols);
laplacian=zeros(cols,cols);
I=eye(cols);

for y=1:rows

f=input(y,:);
g=guidance(y,:);
variance=var(g);

for p=1:cols
    
    for q=1:cols
        
        weights(p,q)=exp(-abs(g(p)-g(q))/variance);
        
    end
    
end

for m=1:cols
    
    for n=1:cols
        
            
        if (m==n)
            if (m==1)
                laplacian(m,n)=weights(m,m+1);
            elseif (m==cols)
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

output(y,:)=(I+lambda*laplacian)\transpose(f);

if size(varargin)>0
index=f(f>5);
out_ind(y,:)=(I+lambda*laplacian)\transpose(index);
output(y,:)=output(y,:)./out_ind(y,:);
end

end

end

