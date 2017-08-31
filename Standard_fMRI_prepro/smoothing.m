function [] = smoothing(func_targetdir, func_file, FWHM, sub_name)

%% Run smoothing.

%func_targetdir: path to NIfTI functional data: func_targetdir(i,1)
%func_file: file output from the previous func step; i.e. normalize: '^wrof4D.*\.*'
%FWHM: 2.5 x voxel size; in this example: [8 8 8] = default - Roma: [6 6 6] 
%sub_name: name current subject: sbj_fold(i).name

%% REMARK: do not forget to change the FWHM (2.5x voxel size)
%%

do_smooth = 1;

if do_smooth
        clear matlabbatch;
        ibatch=1;      
        
        matlabbatch{ibatch}.spm.spatial.smooth.data = cellstr(spm_select('ExtFPList', func_targetdir, func_file, Inf));
        matlabbatch{ibatch}.spm.spatial.smooth.fwhm = FWHM;
        disp('Running smoothing with SPM batch ----');
        disp(sprintf(sub_name));
        disp('     ----      ');
        spm_jobman('run',matlabbatch);
        disp('Smoothing done!');
end
end
