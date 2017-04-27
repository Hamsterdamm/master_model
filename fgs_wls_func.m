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

