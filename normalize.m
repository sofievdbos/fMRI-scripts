function [] = normalize(anat_targetdir, func_targetdir, anat_file, funct_file, voxel_size, interp, sub_name)

%% Running functional normalization.

%anat_targetdir: path to NIfTI anatomical data: anat_targetdir(i,1)
%func_targetdir: path to NIfTI functional data: func_targetdir(i,1)
%anat_file: file output from the previous anat step, i.e. coregistration: '^y_c.*\.*'
%funct_file: file output from the previous func step, i.e. realign: '^rof4D.*\.*'
%voxel_size: original voxel size of the functional images; in this example: [3 3 3]
%interp: interpolation; default value as indicated in the SPM batch: 4
%sub_name: name current subject: sbj_fold(i).name

%% REMARK: do not forget to change the voxel_size to the original voxel size of the functional images!
%%

do_normalize = 1;

if do_normalize
        %% normalise (write)
        ibatch = 1;
        clear matlabbatch;

        matlabbatch{ibatch}.spm.spatial.normalise.write.subj.def(1) = cellstr(spm_select('FPList', anat_targetdir, anat_file));
        matlabbatch{ibatch}.spm.spatial.normalise.write.subj.resample = cellstr(spm_select('ExtFPList', func_targetdir, funct_file, Inf));;
        
        matlabbatch{ibatch}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
            78 76 85];
        
        matlabbatch{ibatch}.spm.spatial.normalise.write.woptions.vox = voxel_size; 
        matlabbatch{ibatch}.spm.spatial.normalise.write.woptions.interp = interp; 
        matlabbatch{ibatch}.spm.spatial.normalise.write.woptions.prefix = 'w'; 
        disp('Calculating normalization with SPM batch ----');
        disp(sprintf(sub_name));
        spm_jobman('run',matlabbatch);
        disp('Normalization of functional done!');
end
end