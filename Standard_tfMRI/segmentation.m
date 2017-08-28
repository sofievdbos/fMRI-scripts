function [] = segmentation(anat_targetdir, tpmdir, anat_file, tpm_file, sub_name)

%% Running segmentation.

%anat_targetdir: path to NIfTI anatomical data: anat_targetdir(i,1)
%tpmdir: path to TPM masks: tpmdir
%anat_file: file output from the previous anat step, i.e. coregistration: '^c.*\.*'
%tpm_file: TPM masks: '^TPM.*\.*'
%sub_name: name current subject: sbj_fold(i).name

%%
%%

do_segment = 1;

if do_segment
        clear matlabbatch;
        ibatch=1;
        
        matlabbatch{ibatch}.spm.spatial.preproc.channel.vols = cellstr(spm_select('FPList', anat_targetdir, anat_file ));
        matlabbatch{ibatch}.spm.spatial.preproc.channel.biasreg = 0.001;
        matlabbatch{ibatch}.spm.spatial.preproc.channel.biasfwhm = 60;
        matlabbatch{ibatch}.spm.spatial.preproc.channel.write = [0 1]; %bias corrected
        matlabbatch{ibatch}.spm.spatial.preproc.tissue(1).tpm =  cellstr(spm_select('ExtFPList',tpmdir, tpm_file,1));
        matlabbatch{ibatch}.spm.spatial.preproc.tissue(1).ngaus = 1;
        matlabbatch{ibatch}.spm.spatial.preproc.tissue(1).native = [1 0];
        matlabbatch{ibatch}.spm.spatial.preproc.tissue(1).warped = [0 0];
        matlabbatch{ibatch}.spm.spatial.preproc.tissue(2).tpm = cellstr(spm_select('ExtFPList',tpmdir, tpm_file,2));
        matlabbatch{ibatch}.spm.spatial.preproc.tissue(2).ngaus = 1;
        matlabbatch{ibatch}.spm.spatial.preproc.tissue(2).native = [1 0];
        matlabbatch{ibatch}.spm.spatial.preproc.tissue(2).warped = [0 0];
        matlabbatch{ibatch}.spm.spatial.preproc.tissue(3).tpm =  cellstr(spm_select('ExtFPList',tpmdir, tpm_file,3));
        matlabbatch{ibatch}.spm.spatial.preproc.tissue(3).ngaus = 2;
        matlabbatch{ibatch}.spm.spatial.preproc.tissue(3).native = [1 0];
        matlabbatch{ibatch}.spm.spatial.preproc.tissue(3).warped = [0 0];
        matlabbatch{ibatch}.spm.spatial.preproc.tissue(4).tpm =  cellstr(spm_select('ExtFPList',tpmdir, tpm_file,4));
        matlabbatch{ibatch}.spm.spatial.preproc.tissue(4).ngaus = 3;
        matlabbatch{ibatch}.spm.spatial.preproc.tissue(4).native = [1 0];
        matlabbatch{ibatch}.spm.spatial.preproc.tissue(4).warped = [0 0];
        matlabbatch{ibatch}.spm.spatial.preproc.tissue(5).tpm =  cellstr(spm_select('ExtFPList',tpmdir, tpm_file,5));
        matlabbatch{ibatch}.spm.spatial.preproc.tissue(5).ngaus = 4;
        matlabbatch{ibatch}.spm.spatial.preproc.tissue(5).native = [1 0];
        matlabbatch{ibatch}.spm.spatial.preproc.tissue(5).warped = [0 0];
        matlabbatch{ibatch}.spm.spatial.preproc.tissue(6).tpm =  cellstr(spm_select('ExtFPList',tpmdir, tpm_file,6));
        matlabbatch{ibatch}.spm.spatial.preproc.tissue(6).ngaus = 2;
        matlabbatch{ibatch}.spm.spatial.preproc.tissue(6).native = [0 0];
        matlabbatch{ibatch}.spm.spatial.preproc.tissue(6).warped = [0 0];
        matlabbatch{ibatch}.spm.spatial.preproc.warp.mrf = 1;
        matlabbatch{ibatch}.spm.spatial.preproc.warp.cleanup = 1;
        matlabbatch{ibatch}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
        matlabbatch{ibatch}.spm.spatial.preproc.warp.affreg = 'mni';
        matlabbatch{ibatch}.spm.spatial.preproc.warp.fwhm = 0;
        matlabbatch{ibatch}.spm.spatial.preproc.warp.samp = 3;
        matlabbatch{ibatch}.spm.spatial.preproc.warp.write = [1 1]; %inverse + forward - Ruth: inverse
        
        disp('Running segmentation with SPM batch ----');
        disp(sprintf(sub_name));
        disp('     ----      ');
        spm_jobman('run',matlabbatch);
        disp('Finished segmentation!');
end
end
