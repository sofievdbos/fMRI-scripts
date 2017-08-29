function [] = normalize_anat(anat_targetdir, anat_file, c, c1, c2, c3, c4, c5, voxel_size, interp, sub_name)

%% Run anatomical normalization.

%anat_targetdir: path to NIfTI anatomical data: anat_targetdir(i,1)
%anat_file: file output from the previous anat step, i.e. segmentation: '^y_c.*\.*'
%c/c1/c2/c3/c4/c5: file output from the previous anat step, i.e. segmentation: '^c.*\.*', '^c1.*\.*', '^c2.*\.*', '^c3.*\.*', '^c4.*\.*', '^c5.*\.*'
%voxel_size: original voxel size of the anatomical images; in this example: [1 1 1]
%interp: interpolation; default value as indicated in the SPM batch: 4 - Roma: 7
%sub_name: name current subject: sbj_fold(i).name

%% REMARK: do not forget to change the voxel_size to the original voxel size of the anatomical images!
%%

do_normalize_struct = 1;

if do_normalize_struct
        %% normalise (write)
        ibatch = 1;
        clear matlabbatch;
        
        matlabbatch{ibatch}.spm.spatial.normalise.write.subj.def(1) = cellstr(spm_select('FPList', anat_targetdir,  anat_file));
        matlabbatch{ibatch}.spm.spatial.normalise.write.subj.resample = [cellstr(spm_select('FPList', anat_targetdir, c)); cellstr(spm_select('FPList', anat_targetdir, c1)); ...
                cellstr(spm_select('FPList', anat_targetdir, c2)); cellstr(spm_select('FPList', anat_targetdir, c3)); ...
                cellstr(spm_select('FPList', anat_targetdir, c4)); cellstr(spm_select('FPList', anat_targetdir, c5))];      
        matlabbatch{ibatch}.spm.spatial.normalise.write.woptions.bb = [-90 -126 -72
            90 90 108];
        
        matlabbatch{ibatch}.spm.spatial.normalise.write.woptions.vox = voxel_size;
        matlabbatch{ibatch}.spm.spatial.normalise.write.woptions.interp = interp;
        disp('Calculating normalization with SPM batch ----');
        disp(sprintf(sub_name));
        spm_jobman('run',matlabbatch);
        disp('Normalization of anatomical done!');
end
end
