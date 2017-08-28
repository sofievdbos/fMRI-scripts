function [] = realign(func_targetdir, file, quality, interp1, interp2, sub_name)

%% Running realign.

%func_targetdir: path to NIfTI functional data: func_targetdir(i,1)
%file: file output from the previous step; in this example slice timing: '^of4D.*\.*'
%quality: default value as indicated in the SPM batch: 0.9
%interp1: interpolation; default value as indicated in the SPM batch: 2
%interp2: interpolation; default value as indicated in the SPM batch: 4
%sub_name: name current subject: sbj_fold(i).name

%%
%%

do_realign = 1;

    if do_realign
        ibatch = 1;
        clear matlabbatch;
        
        matlabbatch{ibatch}.spm.spatial.realign.estwrite.data{1,1} = cellstr(spm_select('ExtFPList', func_targetdir, file, Inf));
        
        matlabbatch{ibatch}.spm.spatial.realign.estwrite.eoptions.quality = quality;
        matlabbatch{ibatch}.spm.spatial.realign.estwrite.eoptions.sep = 4;
        matlabbatch{ibatch}.spm.spatial.realign.estwrite.eoptions.fwhm = 5;
        matlabbatch{ibatch}.spm.spatial.realign.estwrite.eoptions.rtm = 0; 
        matlabbatch{ibatch}.spm.spatial.realign.estwrite.eoptions.interp = interp1; 
        matlabbatch{ibatch}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
        matlabbatch{ibatch}.spm.spatial.realign.estwrite.eoptions.weight = '';
        matlabbatch{ibatch}.spm.spatial.realign.estwrite.roptions.which = [2 1];
        matlabbatch{ibatch}.spm.spatial.realign.estwrite.roptions.interp = interp2; 
        matlabbatch{ibatch}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
        matlabbatch{ibatch}.spm.spatial.realign.estwrite.roptions.mask = 1;
        matlabbatch{ibatch}.spm.spatial.realign.estwrite.roptions.prefix = 'r';
        
        disp('Running realign with SPM batch ----');
        disp(sprintf(sub_name));
        disp('     ----      ');
        spm_jobman('run', matlabbatch);
        disp('Finished realign!');
    end
end