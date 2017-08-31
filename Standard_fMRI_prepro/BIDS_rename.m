function [] = BIDS_rename(anat_targetdir, func_targetdir, file1, file2, typebold, sub_name)

%% Rename files: BIDS format.

%anat_targetdir: path to NIfTI anatomical data: anat_targetdir(i,1)
%func_targetdir: path to NIfTI functional data: func_targetdir(i,1)
%file1: anatomical NIfTI file: '*.nii'
%file2: file output (4D) from the previous func step, i.e. removefirstf: 'f4D*.nii'
%typebold: 'rest' or 'task'
%sub_name: name current subject: sbj_fold(i).name

%% REMARK: (1) do not forget to change typebold
%          (2) do not forget to change line 29; removes all 3D files
%%

for irun = 1:2 %anatomical data and 1x functional data (verb generation task)

        if irun == 1
            file_select = dir([anat_targetdir{1} file1]);
            file_old = sprintf('%s%s%s%s', anat_targetdir{1}, file_select.name);
            file_new = sprintf('%s%s%s%s', anat_targetdir{1}, [sub_name '_T1w.nii']);
            movefile(file_old, file_new);
        else
            file_select = dir([func_targetdir{1} file2]);
            file_old = sprintf('%s%s%s%s', func_targetdir{1}, file_select.name);
            file_new = sprintf('%s%s%s%s', func_targetdir{1}, ['f4D_' sub_name '_' typebold '_bold.nii']);
            movefile(file_old, file_new);
            cd(func_targetdir{1});
            !rm *-01.nii 
        end
end
end      