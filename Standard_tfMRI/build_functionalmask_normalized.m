function [] = build_functionalmask_normalized(func_targetdir, anat_targetdir, funct_file, wc1c, wc2c, wc3c, sub_name)

%% Building individual masks based on a normalized individual T1.

%func_targetdir: path to NIfTI functional data: func_targetdir(i,1)
%anat_targetdir: path to NIfTI anatomical data: anat_targetdir(i,1)
%funct_file: file output from the previous func step, i.e. smooth: '^swrof4D.*\.*'
%wc1c, wc2c, wc3c: file output from the previous anat step, i.e. normalize_struct: 'wc1c.*\.*', 'wc2c.*\.*', 'wc3c.*\.*'
%sub_name: name current subject: sbj_fold(i).name

%%
%%

do_build_functionalmask_normalized  = 1;

if do_build_functionalmask_normalized 
         
        ibatch = 1;
        clear matlabbatch;
        matlabbatch{ibatch}.spm.util.imcalc.input = {
            spm_select('ExtFPList', func_targetdir, funct_file, 1)
            spm_select('FPList', anat_targetdir, wc1c)
            };
        disp(matlabbatch{ibatch}.spm.util.imcalc.input);
        matlabbatch{ibatch}.spm.util.imcalc.output = 'wgrey.nii';
        matlabbatch{ibatch}.spm.util.imcalc.outdir = anat_targetdir;
        
        matlabbatch{ibatch}.spm.util.imcalc.expression = 'i2>0.1'; %image calculator makes a mask based on the resolution of the first image you put (swrf4D.nii) and makes calculations based on the second image i2>0.01. 
        matlabbatch{ibatch}.spm.util.imcalc.var = struct('name', {}, 'value', {});
        matlabbatch{ibatch}.spm.util.imcalc.options.dmtx = 0;
        matlabbatch{ibatch}.spm.util.imcalc.options.mask = 0;
        matlabbatch{ibatch}.spm.util.imcalc.options.interp = 1;
        matlabbatch{ibatch}.spm.util.imcalc.options.dtype = 4;
        
        ibatch = ibatch + 1;
        matlabbatch{ibatch}.spm.util.imcalc.input = {
            spm_select('ExtFPList', func_targetdir, funct_file, 1)
            spm_select('FPList', anat_targetdir, wc2c)
            };
        matlabbatch{ibatch}.spm.util.imcalc.output = 'wwhite.nii';
        matlabbatch{ibatch}.spm.util.imcalc.outdir = anat_targetdir;
        matlabbatch{ibatch}.spm.util.imcalc.expression = 'i2>0.1';
        matlabbatch{ibatch}.spm.util.imcalc.var = struct('name', {}, 'value', {});
        matlabbatch{ibatch}.spm.util.imcalc.options.dmtx = 0;
        matlabbatch{ibatch}.spm.util.imcalc.options.mask = 0;
        matlabbatch{ibatch}.spm.util.imcalc.options.interp = 1;
        matlabbatch{ibatch}.spm.util.imcalc.options.dtype = 4;
        
        ibatch = ibatch + 1;
        matlabbatch{ibatch}.spm.util.imcalc.input = {
            spm_select('ExtFPList', func_targetdir, funct_file, 1)
            spm_select('FPList', anat_targetdir, wc3c)
            };
        matlabbatch{ibatch}.spm.util.imcalc.output = 'wcsf.nii';
        matlabbatch{ibatch}.spm.util.imcalc.outdir = anat_targetdir;
        matlabbatch{ibatch}.spm.util.imcalc.expression = 'i2>0.1';
        matlabbatch{ibatch}.spm.util.imcalc.var = struct('name', {}, 'value', {});
        matlabbatch{ibatch}.spm.util.imcalc.options.dmtx = 0;
        matlabbatch{ibatch}.spm.util.imcalc.options.mask = 0;
        matlabbatch{ibatch}.spm.util.imcalc.options.interp = 1;
        matlabbatch{ibatch}.spm.util.imcalc.options.dtype = 4;
        disp('Building functional masks ----');
        disp(sprintf(sub_name));
        disp('     ----      ');
        spm_jobman('run',matlabbatch);
        disp('Building functional masks are done!');
end  
end