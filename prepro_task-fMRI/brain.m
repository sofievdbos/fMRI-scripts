function [] = brain(anat_targetdir, grey, white, csf, sub_name)

%% Create a subject-specific/standard total brain mask.

%anat_targetdir: path to NIfTI anatomical data: anat_targetdir(i,1)
%grey: file output from the previous anat step, i.e. build_functionalmask_normalized/standard: 'wgrey.nii'/stdgrey.nii
%white: file output from the previous anat step, i.e. build_functionalmask_normalized/standard: 'wwhite.nii'/'stdwhite.nii'
%csf: file output from the previous anat step, i.e. build_functionalmask_normalized/standard: 'wcsf.nii'/'stdcsf.nii'
%sub_name: name current subject: sbj_fold(i).name

%% REMARK: do not forget to change grey, white and csf to subject-specific vs. standard
%%

do_brain = 1;

if do_brain
        ibatch =1;
        clear matlabbatch;
        
       matlabbatch{ibatch}.spm.util.imcalc.input = {
       spm_select('FPList', anat_targetdir, grey)
       spm_select('FPList', anat_targetdir, white)
       spm_select('FPList', anat_targetdir, csf)
 
                                        };
        matlabbatch{ibatch}.spm.util.imcalc.output = 'brain.nii';
        matlabbatch{ibatch}.spm.util.imcalc.outdir = anat_targetdir;
        %matlabbatch{ibatch}.spm.util.imcalc.outdir = {''};
        matlabbatch{ibatch}.spm.util.imcalc.expression = '(i1+i2+i3)>0.1';
        matlabbatch{ibatch}.spm.util.imcalc.var = struct('name', {}, 'value', {});
        matlabbatch{ibatch}.spm.util.imcalc.options.dmtx = 0;
        matlabbatch{ibatch}.spm.util.imcalc.options.mask = 0;
        matlabbatch{ibatch}.spm.util.imcalc.options.interp = 1;
        matlabbatch{ibatch}.spm.util.imcalc.options.dtype = 4;

        disp('Building brain mask ----');
        disp(sprintf(sub_name));
        disp('     ----      ');
        spm_jobman('run',matlabbatch);
        disp('Building brain mask is done!');
end  
end
