function [] = coregistration(func_targetdir, anat_targetdir, funct_file, anat_file, sub_name)

%% Running coregistration.

%func_targetdir: path to NIfTI functional data: func_targetdir(i,1)
%anat_targetdir: path to NIfTI anatomical data: anat_targetdir(i,1)
%funct_file: '^meanof4D.*\.*'
%anat_file: '^s.*\.*'
%sub_name: name current subject: sbj_fold(i).name

%%
%%

do_coregister = 1;

if do_coregister
        ibatch=1;
        clear matlabbatch;
        
        %Structure to function! 
        
        matlabbatch{ibatch}.spm.spatial.coreg.estwrite.ref(1) = cellstr(spm_select('ExtFPList', func_targetdir, funct_file, 1));
        matlabbatch{ibatch}.spm.spatial.coreg.estwrite.source = cellstr(spm_select('FPList',  anat_targetdir, anat_file));
        
        %matlabbatch{ibatch}.spm.spatial.coreg.estwrite.ref(1) = cellstr(spm_select('FPList', anat_targetdir(i,1), '^s.*\.nii$'));
        %matlabbatch{ibatch}.spm.spatial.coreg.estwrite.source = cellstr(spm_select('FPList',  rundir, '^mean.*.nii$'));
        %matlabbatch{ibatch}.spm.spatial.coreg.estwrite.other = cellstr(spm_select('FPList', rundir, '^raf.*.nii$'));
        matlabbatch{ibatch}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'nmi';
        matlabbatch{ibatch}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2];
        matlabbatch{ibatch}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
        matlabbatch{ibatch}.spm.spatial.coreg.estwrite.eoptions.fwhm = [7 7];
        matlabbatch{ibatch}.spm.spatial.coreg.estwrite.roptions.interp = 7;
        matlabbatch{ibatch}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
        matlabbatch{ibatch}.spm.spatial.coreg.estwrite.roptions.mask = 0;
        matlabbatch{ibatch}.spm.spatial.coreg.estwrite.roptions.prefix = 'c';
        disp('Running coregistration with SPM batch ----');
        disp(sprintf(sub_name));
        disp('     ----      ');
        spm_jobman('run', matlabbatch);
        disp('Finished coregistration!');
end
end