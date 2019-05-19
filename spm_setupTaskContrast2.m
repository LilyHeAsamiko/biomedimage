function spm_setupTaskContrast_jsh(stats_dir, params)

% SETUP BATCH JOB STRUCTURE
contrast = struct;
% spmmat
contrast.matlabbatch{1}.spm.stats.con.spmmat = {[stats_dir filesep 'SPM.mat']};
% consess
contrast.matlabbatch{1}.spm.stats.con.consess{1}.fcon.name = params.name;
contrast.matlabbatch{1}.spm.stats.con.consess{1}.fcon.weights = params.weights;
contrast.matlabbatch{1}.spm.stats.con.consess{1}.fcon.sessrep = 'none';
% delete
contrast.matlabbatch{1}.spm.stats.con.delete = 0;
% RUN BATCH JOB

% spmmat
contrast.matlabbatch{2}.spm.stats.con.spmmat = {[stats_dir filesep 'SPM.mat']};
% consess
contrast.matlabbatch{2}.spm.stats.con.consess{1}.fcon.name = contrast_params.name;
contrast.matlabbatch{2}.spm.stats.con.consess{1}.fcon.weights = contrast_params.weights;
contrast.matlabbatch{2}.spm.stats.con.consess{1}.fcon.sessrep = 'none';
% delete
contrast.matlabbatch{2}.spm.stats.con.delete = 0;
% RUN BATCH JOB
spm_jobman('run',matlabbatch{2});

cfg_util('run',contrast.matlabbatch);