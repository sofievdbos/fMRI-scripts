function [] = ima(anat_sourcedir, func_sourcedir, anat_targetdir, func_targetdir, sub_name)

%% Converting IMA (DICOM) files to NIfTI.

%anat_sourcedir: source path anatomical data : anat_sourcedir(i,1)
%func_sourcedir: source path functional data: func_sourcedir(i,1)
%anat_targetdir: target path NIfTI anatomical data: anat_targetdir(i,1)
%func_targetdir: target path NIfTI functional data: func_targetdir(i,1)
%sub_name: name current subject: sbj_fold(i).name

%%
%%

do_ima = 1; 

for irun = 1:2 %anatomical data and 1x functional data 
        
        if irun == 1
            rundir = anat_sourcedir;
            file = cellstr(spm_select('FPList', [rundir '.*\.*']));
            savedir = anat_targetdir;
        else
            rundir = func_sourcedir;
            file = cellstr(spm_select('FPList', [rundir '.*\.*']));
            savedir = func_targetdir;
        end
        
        if do_ima
            ibatch = 1;
            clear matlabbatch;  
            
            matlabbatch{ibatch}.spm.util.import.dicom.data = file;
            matlabbatch{ibatch}.spm.util.import.dicom.root = 'flat';
            matlabbatch{ibatch}.spm.util.import.dicom.outdir = savedir; 
            matlabbatch{ibatch}.spm.util.import.dicom.protfilter = '.*';
            matlabbatch{ibatch}.spm.util.import.dicom.convopts.format = 'nii';
            matlabbatch{ibatch}.spm.util.import.dicom.convopts.icedims = 0;
            disp('Converting IMA (DICOM) file to NIfTI ----');
            disp(sprintf(sub_name));
            disp('     ----      ');
            spm_jobman('run',matlabbatch);
            disp('Converting done!');
            
       end            
end
end