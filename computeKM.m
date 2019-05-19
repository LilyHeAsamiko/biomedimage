function [K] = computeKM(x,y,sigma)
% DESCRIPTION
% Compute Kernel Matrix
% x: iuput samples 
% y: estimator
% simga: kernel width
% n1,n2: number of samples
% d: characteristic dimension of the samples
% K: kernelMatrix 
%-------------------------------------------------------------%
x_sum = sum(x.^2,2);
y_sum = sum(y.^2,2);
K = exp((bsxfun(@minus,bsxfun(@minus,2*x*y',x_sum),y_sum'))/sigma^2);
end