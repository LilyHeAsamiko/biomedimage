function [y_mu,y_var] = rvm_test(model,X)
%       [y_mu,y_var] = rvm_test(model,X)
%
% INPUT
%   X            Test samples (N*d)
%                N: number of samples
%                d: number of features
%   y_mu         Mean of prediction
%   y_var        Variance of prediction
%
% OUTPUT
%   model        RVM model


L = size(X,1);
BASIS = [ones(L,1),computeKM(X,model.X,model.width)];

% mean of prediction (test samples)
y_mu = BASIS(:,model.rv_ind)*model.rv_mu;

% variance of prediction (test samples)
y_var = ones(L,1)/model.beta+ ... 
    diag(BASIS(:,model.rv_ind)* ... 
    model.sigma*BASIS(:,model.rv_ind)');

end