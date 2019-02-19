function [] = build_functionalmask_standard(func_targetdir, anat_targetdir, func_file, tpmdir, tpm_file, sub_name)

%% Build standard masks based on TPM files.

%func_targetdir: path to NIfTI functional data: func_targetdir(i,1)
%anat_targetdir: path to NIfTI anatomical data: anat_targetdir(i,1)
%func_file: file output from the previous func step, i.e. smooth: '^swrof4D.*\.*'
%tpmdir: path to TPM masks: tpmdir
%tpm_file: TPM masks: '^TPM.*\.*'
%sub_name: name current subject: sbj_fold(i).name

%%
%%

do_build_functionalmask_standard  = 1;

if do_build_functionalmask_standard
        ibatch = 1;
        clear matlabbatch;
        matlabbatch{ibatch}.spm.util.imcalc.input = {
            spm_select('ExtFPList', func_targetdir, func_file, 1)
            spm_select('ExtFPList', tpmdir, tpm_file, 1)
            };

        disp(matlabbatch{ibatch}.spm.util.imcalc.input);
        matlabbatch{ibatch}.spm.util.imcalc.output = 'stdgrey.nii';
        matlabbatch{ibatch}.spm.util.imcalc.outdir = anat_targetdir;

        matlabbatch{ibatch}.spm.util.imcalc.expression = 'i2>0.1';
        matlabbatch{ibatch}.spm.util.imcalc.var = struct('name', {}, 'value', {});
        matlabbatch{ibatch}.spm.util.imcalc.options.dmtx = 0;
        matlabbatch{ibatch}.spm.util.imcalc.options.mask = 0;
        matlabbatch{ibatch}.spm.util.imcalc.options.interp = -7;
        matlabbatch{ibatch}.spm.util.imcalc.options.dtype = 4;

        ibatch = ibatch + 1;
        matlabbatch{ibatch}.spm.util.imcalc.input = {
            spm_select('ExtFPList', func_targetdir,func_file, 1)
            spm_select('ExtFPList', tpmdir, tpm_file, 2)
            };
        matlabbatch{ibatch}.spm.util.imcalc.output = 'stdwhite.nii';
        matlabbatch{ibatch}.spm.util.imcalc.outdir = anat_targetdir;
        matlabbatch{ibatch}.spm.util.imcalc.expression = 'i2>0.1';
        matlabbatch{ibatch}.spm.util.imcalc.var = struct('name', {}, 'value', {});
        matlabbatch{ibatch}.spm.util.imcalc.options.dmtx = 0;
        matlabbatch{ibatch}.spm.util.imcalc.options.mask = 0;
        matlabbatch{ibatch}.spm.util.imcalc.options.interp = -7;
        matlabbatch{ibatch}.spm.util.imcalc.options.dtype = 4;

        ibatch = ibatch + 1;
        matlabbatch{ibatch}.spm.util.imcalc.input = {
            spm_select('ExtFPList', func_targetdir,func_file, 1)
            spm_select('ExtFPList', tpmdir, tpm_file, 3)
            };
        matlabbatch{ibatch}.spm.util.imcalc.output = 'stdcsf.nii';
        matlabbatch{ibatch}.spm.util.imcalc.outdir = anat_targetdir;
        matlabbatch{ibatch}.spm.util.imcalc.expression = 'i2>0.1';
        matlabbatch{ibatch}.spm.util.imcalc.var = struct('name', {}, 'value', {});
        matlabbatch{ibatch}.spm.util.imcalc.options.dmtx = 0;
        matlabbatch{ibatch}.spm.util.imcalc.options.mask = 0;
        matlabbatch{ibatch}.spm.util.imcalc.options.interp = -7;
        matlabbatch{ibatch}.spm.util.imcalc.options.dtype = 4;
        disp('Building functional masks ----');
        disp(sprintf(sub_name));
        disp('     ----      ');
        spm_jobman('run',matlabbatch);
        disp('Building functional masks are done!');
end
end
