function preprocess(data_dir,spm_dir,subj)
%% INITIALIZATION
% Initialize file locations, image file names and other variables

addpath(spm_dir);
addpath(data_dir);
s_fn = [data_dir filesep subj filesep 'anat' filesep subj '_T1w.nii'];
f_fn = [data_dir filesep subj filesep 'func' filesep subj '_func_' subj '_task-passiveimageviewing_bold.nii'];
stats_dir = [data_dir filesep subj filesep 'stats'];
if ~exist(stats_dir,'dir')
    mkdir(stats_dir)
end
fwhm = 6;  % mm
%% PREPROCESSING

disp('PREPROCESSING')
% Preprocess structural and functional images (if not already)
[d, f, e] = fileparts(s_fn);
[d1, f1, e1] = fileparts(f_fn);
% if exist([d filesep 'rc1' f e], 'file')
%     disp('...preproc already done, saving variables...')
%     preproc_data = struct;
%     % Structural filenames
%     preproc_data.forward_transformation = [d filesep 'y_' f e];
%     preproc_data.inverse_transformation = [d filesep 'iy_' f e];
%     preproc_data.gm_fn = [d filesep 'c1' f e];
%     preproc_data.wm_fn = [d filesep 'c2' f e];
%     preproc_data.csf_fn = [d filesep 'c3' f e];
%     preproc_data.bone_fn = [d filesep 'c4' f e];
%     preproc_data.soft_fn = [d filesep 'c5' f e];
%     preproc_data.air_fn = [d filesep 'c6' f e];
%     preproc_data.rstructural_fn = [d filesep 'r' f e];
%     preproc_data.rgm_fn = [d filesep 'rc1' f e];
%     preproc_data.rwm_fn = [d filesep 'rc2' f e];
%     preproc_data.rcsf_fn = [d filesep 'rc3' f e];
%     preproc_data.rbone_fn = [d filesep 'rc4' f e];
%     preproc_data.rsoft_fn = [d filesep 'rc5' f e];
%     preproc_data.rair_fn = [d filesep 'rc6' f e];
%     % Functional filenames
%     preproc_data.rfunctional_fn = [d1 filesep 'r' f1 e1];
%     preproc_data.srfunctional_fn = [d1 filesep 'sr' f1 e1];
%     preproc_data.mp_fn = [d1 filesep 'rp_' f1 '.txt'];
%     preproc_data.MP = load(preproc_data.mp_fn);
% else
    disp('...running preprocessing batch jobs...')
    preproc_data = spm_standardPreproc2_jsh(f_fn, s_fn, fwhm, spm_dir);
%end

% Check coregistration and segmentation
spm_check_registration(f_fn, [preproc_data.rfunctional_fn ',1'], preproc_data.rgm_fn, preproc_data.rwm_fn, preproc_data.rcsf_fn)
disp('Preprocessing done!')
%% CREATE 1ST LEVEL STATS DESIGN
% Set up statistical design parameters, based on task data

sess_params = struct;
sess_params.timing_units = 'secs';
sess_params.timing_RT = 1.6;
sess_params.cond_name = 'Pictures';
sess_params.cond_onset = [0; 40.1; 77.2; 111.3; 143.3; 179.4; 218.5; 251.5; 299.6; 334.7; 374.8; 411.9; 445.9; 478.0; 514.1; 553.2];
sess_params.cond_duration = [24.1000; 24.06; 24.07; 24.06; 24.06; 24.07; 24.04; 24.06; 24.07; 24.10; 24.06; 24.06; 24.09; 24.09; 24.06; 24.07];
% Call script to set up design
spm_specify1stlevel2_jsh(stats_dir, preproc_data.srfunctional_fn, preproc_data.mp_fn, sess_params)
% Display/explore design matrix 
load([stats_dir filesep 'SPM.mat']);
spm_DesRep('fMRIDesMtx',SPM,1,1)
load([stats_dir filesep 'SPM_f.mat']);
spm_DesRep('fMRIDesMtx',SPM_f,1,1)
%% ESTIMATE MODEL

spm_estimateModel2_jsh(stats_dir)
%% SETUP TASK CONTRAST

[Ntt, Nregr] = size(SPM.xX.X);
contrast_params = struct;
contrast_params.weights = zeros(1, Nregr); 
contrast_params.weights(1) = 1;
contrast_params.name = 'Picture viewing';
spm_setupTaskContrast_jsh(stats_dir, contrast_params)
%% RUN RESULTS

spm_runResults2_jsh(stats_dir)