% rvm
clc
clear all
close all

addpath P:\biomedical imaging\ds000157_R1.0.3\ds000157_R1.0.3\RVM\RVM

data_dir = '/Users/he/Downloads/';
spm_dir = '/Users/he/Downloads/SPM12/spm12/spm12';

addpath(data_dir);
addpath(spm_dir);


load('SPM.mat');
count = 1;
for i = 1:8
     subj = ['stats_',num2str(i)];
     data1 = [data_dir filesep subj filesep '/spmT_0001.nii'];
     data2 = [data_dir filesep subj filesep '/beta_0005.nii'];
%     addpath(stats_dir);    
    s = spm_vol(data1);
    X = spm_read_vols(s);
    s2 = spm_vol(data2);
    Y = spm_read_vols(s2);
    for j = 1: size(X,3)
        XX = X(:,:,j);
        X_test(count,:) = XX(:);
        Y(isnan(Y)) = 0;
        YY = Y(:,:,j);
        Y_test(count,:) = YY(:);
        count = count +1;
    end
%dim = s.dim;
%figure; imagesc(squeeze(v(:,:,size(v,3)/2))); 
%colormap hot; colorbar;
end

% sinc funciton
fun = @(x) sin(abs(x))/abs(x);
% training samples
x = -10:0.5:9.5;
y = arrayfun(fun,x);
X = x';
Y = y';
% test samples0
x_test = -10:0.5:10;
y_test = arrayfun(fun,x_test);
X_test = x_test';
Y_test = y_test';

% train RVM model
[model]= rvm_train(X_test,Y_test);

% test  RVM model
[y_mu,y_var] = rvm_test(model,Y_test);

%
ypre = y_mu;

% 
figure
plot(X_test,Y_test,':o','LineWidth',1.5,'MarkerSize',4)
hold on
plot(X_test,model.y_mu,':o','LineWidth',1.5,'MarkerSize',4)
plot(X_test(model.rv_ind),Y(model.rv_ind),'go', ... 
    'LineWidth',1.5,'MarkerSize',8)

legend('training samples','prediction','relevance Vectors')

figure
xs = (1:size(X_test,1))';
% boundry
f1 = [y_mu(:,1)+3*sqrt(y_var(:,1)); flip(y_mu(:,1)-3*sqrt(y_var(:,1)),1)];
fill([xs; flip(xs,1)], f1, [5 5 5]/8)
hold on
plot(Y_test,'b:o','LineWidth',1.5,'MarkerSize',4)
plot(y_mu,'r:o','LineWidth',1.5,'MarkerSize',4)

xlabel('Samples')
ylabel('Predictions')
legend('boundary','test samples','prediction')




