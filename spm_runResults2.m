function spm_runResults2_jsh(stats_dir)

spm('defaults','FMRI');
% SETUP BATCH JOB STRUCTURE
results = struct;
% spmmat
results.matlabbatch{1}.spm.stats.results.spmmat = {[stats_dir filesep 'SPM.mat']};
% conspec
results.matlabbatch{1}.spm.stats.results.conspec.titlestr = '';
results.matlabbatch{1}.spm.stats.results.conspec.contrasts = 1;
results.matlabbatch{1}.spm.stats.results.conspec.threshdesc = 'FWE';
results.matlabbatch{1}.spm.stats.results.conspec.thresh = 0.0500;
results.matlabbatch{1}.spm.stats.results.conspec.extent = 0;
results.matlabbatch{1}.spm.stats.results.conspec.conjunction = 1;
results.matlabbatch{1}.spm.stats.results.conspec.mask.none = 1;
% units
results.matlabbatch{1}.spm.stats.results.units = 1;
% export
results.matlabbatch{1}.spm.stats.results.export{1}.ps = 1;
cfg_util('run',results.matlabbatch);
% RUN BATCH JOB
% spmmat
results.matlabbatch{2}.spm.stats.results.spmmat = {[stats_dir filesep 'SPM_f.mat']};
% conspec
results.matlabbatch{2}.spm.stats.results.conspec.titlestr = '';
results.matlabbatch{2}.spm.stats.results.conspec.contrasts = 1;
results.matlabbatch{2}.spm.stats.results.conspec.threshdesc = 'FWE';
results.matlabbatch{2}.spm.stats.results.conspec.thresh = 0.0500;
results.matlabbatch{2}.spm.stats.results.conspec.extent = 0;
results.matlabbatch{2}.spm.stats.results.conspec.conjunction = 1;
results.matlabbatch{2}.spm.stats.results.conspec.mask.none = 1;
% units
results.matlabbatch{2}.spm.stats.results.units = 1;
% export
results.matlabbatch{2}.spm.stats.results.export{2}.ps = 1;
cfg_util('run',results.matlabbatch);