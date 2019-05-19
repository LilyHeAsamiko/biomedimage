function [model]= rvm_train(X,Y)
%       [model]= rvm_train(X,Y)
%
% INPUT
%   X            Training samples (N*d)
%                N: number of samples
%                d: number of features
%   Y            Target samples (N*1)
%
% OUTPUT
%   model        RVM model
%
%


% kernei width
sigma = 5.5;  


L = size(X,1);
%
BASIS = [ones(L,1),computeKM(X,X,sigma)];

%BASIS = [ones(L,1),computeKM(X,X,sigma)];
%
% Set defaults
%
% Assume we will infer the noise in the Gaussian case
% 
OPTIONS.fixedNoise		= false;
%
% Option to allow subset of the basis (e.g. bias) to be unregularised
% 
OPTIONS.freeBasis		= [];
%
% Option to set max iterations to run for
%
%OPTIONS.iterations		= 100;
%
% Option to set max time to run for
%
%OPTIONS.time			= 1000; % seconds
%
% Set options for monitoring and recording the algorithm's progress
% 
OPTIONS.monitor			= 10;
OPTIONS.diagnosticLevel	= 'medium';
OPTIONS.diagnosticFID	= 1; % stdout
OPTIONS.diagnosticFile_	= 'diagnostic_log';
%
% Option to call a function during each iteration (to create demos etc)
% 
OPTIONS.callback		= false;
OPTIONS.callbackFunc	= [];
OPTIONS.callbackData	= {};

[PARAMETER, HYPERPARAMETER, DIAGNOSTIC] = ... 
    SparseBayes(BASIS, Y, [], OPTIONS);

model.rv_ind = PARAMETER.Relevant;
model.rv_mu = PARAMETER.Value;
model.width = sigma;
model.X = X;
model.beta = HYPERPARAMETER.beta;
model.sigma = DIAGNOSTIC.Sigma;

% mean of prediction (training samples)
model.y_mu = BASIS(:,model.rv_ind)*model.rv_mu;

% variance of prediction (training samples)
model.y_var = ones(L,1)/model.beta+ ... 
    diag(BASIS(:,model.rv_ind)* ... 
    model.sigma*BASIS(:,model.rv_ind)');

end