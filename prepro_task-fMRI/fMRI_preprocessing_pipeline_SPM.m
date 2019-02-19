%% fMRI (rs or task) standard preprocessing pipeline for one task using SPM (BIDS folder format) created on MATLAB_R2015b (http://bids.neuroimaging.io/).
% The file names are partly adapted to the BIDS format.
% When preprocessing rs-fMRI an additional preprocessing step is added: denoise.m (line 69)
%
% To adapt: - line 16/74: Comment to eliminate parallel processing and change parfor to for (line 43); Else, choose the nr. of cores you want to run in parallel with (line 16).
%                         In case of an older version of Matlab, matlabpool() & matlabpool close is used.
%           - line 22-25: Change to your SPM (spmdir), REST toolbox (restdir) and subscript (fdir) directory.
%           - line 38: Change to your datadir.
%           - line 57-70: Change some arguments in the preprocessing steps. Check the REMARKs in the subscripts.
%           - line 67-68: Choose one of the two: subject-specific vs. standard.
%
% Credits: Written by Sofie Van Den Bossche, Department of Data Analysis, Faculty of Psychology, Ghent University.
%          Partly adapted from Roma Siugzdaite's pipeline (Ghent University).

tic
%parpool(8) %change to the number of cores you want to run in parallel with

%% **********************
% set path to toolboxes
%% **********************

spmdir = '/home/sofie/Programs/spm12/';
tpmdir = [spmdir 'tpm/'];
restdir = '/home/sofie/Programs/REST_V1.8_130615/';
scriptdir = '/media/sofie/Sofie_Disk2/02_Doctoraat/03_Collaboraties/Maaike/05_Scripts/Matlab/01_(Pre)processing/01_Preprocessing/Standard_fMRI/New_Pipeline/'; %path where the subscripts are stored

addpath(spmdir);
addpath(tpmdir);
addpath(restdir);
addpath(scriptdir);

spm_jobman('initcfg');

%% *****************
%% set path to data
%% *****************

datadir = '/media/sofie/Sofie_Disk4/Maaike_kids/test/';  
sourcedir = ([datadir 'dicomdir/']); %source folder
mkdir(fullfile([datadir 'my_dataset/']));targetdir = ([datadir 'my_dataset/']); %target folder
sbj_fold=dir([sourcedir 'sub*']); 

for i=1:1 %1:length(sbj_fold)
    
    %source and target folders for anatomical (anat/) and functional (func/) data 
    sbj_path(i,1)={[sourcedir sbj_fold(i).name '/']};
    
    mkdir(fullfile(targetdir, sbj_fold(i).name, '/anat/'));
    mkdir(fullfile(targetdir, sbj_fold(i).name, '/func/'));
    
    anat_sourcedir(i,1) = {sprintf('%s%s%s%s', sourcedir, sbj_fold(i).name, '/anat/')}; %anatomical data (DICOM/IMA)
    anat_targetdir(i,1) = {sprintf('%s%s%s%s', targetdir, sbj_fold(i).name, '/anat/')}; 
    func_sourcedir(i,1) = {sprintf('%s%s%s%s', sourcedir, sbj_fold(i).name, '/func/')}; %functional data (DICOM/IMA) 
    func_targetdir(i,1) = {sprintf('%s%s%s%s', targetdir, sbj_fold(i).name, '/func/')}; 
    
    %preprocessing pipeline
    ima(anat_sourcedir(i,1), func_sourcedir(i,1), anat_targetdir(i,1), func_targetdir(i,1), sbj_fold(i).name)
    removefirstf(0, 1, 1, func_targetdir(i,1), '.*\.*', '^f.*\.*', 'f4D', sbj_fold(i).name) 
    %BIDS_rename(anat_targetdir(i,1), func_targetdir(i,1), '*.nii', 'f4D*.nii', 'task-VG_run-01', sbj_fold(i).name)
    slicetiming(func_targetdir(i,1), '^f4D.*\.*', 40, 2.4, sbj_fold(i).name) 
    realign(func_targetdir(i,1), '^of4D.*\.*', 0.9, 2, 4 , sbj_fold(i).name)
    coregistration(func_targetdir(i,1), anat_targetdir(i,1), '^meanof4D.*\.*', '^s.*\.*', sbj_fold(i).name)
    segmentation(anat_targetdir(i,1), tpmdir, '^c.*\.*', '^TPM.*\.*', sbj_fold(i).name)
    normalize_func(anat_targetdir(i,1), func_targetdir(i,1), '^y_c.*\.*', '^rof4D.*\.*', [3 3 3], 4, sbj_fold(i).name)
    smoothing(func_targetdir(i,1), '^wrof4D.*\.*', [8 8 8], sbj_fold(i).name) 
    normalize_anat(anat_targetdir(i,1), '^y_.*\.*', '^c.*\.*', '^c1.*\.*', '^c2.*\.*', '^c3.*\.*', '^c4.*\.*', '^c5.*\.*', ...
        [1 1 1], 4, sbj_fold(i).name) 
    build_functionalmask_normalized(func_targetdir(i,1), anat_targetdir(i,1), '^swrof4D.*\.*', 'wc1c.*\.*', 'wc2c.*\.*', 'wc3c.*\.*', ...
        sbj_fold(i).name)
    %build_functionalmask_standard(func_targetdir(i,1), anat_targetdir(i,1), '^swrof4D.*\.*', tpmdir, '^TPM.*\.*', sbj_fold(i).name)
    brain(anat_targetdir(i,1), 'wgrey.nii', 'wwhite.nii', 'wcsf.nii', sbj_fold(i).name)
    %denoise(anat_targetdir(i,1), func_targetdir(i,1), 'brain.nii', 'wwhite.nii', 'wcsf.nii', '^swrof4D.*\.*', '^rp_.*\.txt', 2.4, [0.01 0.09])
    
end

toc
%delete(gcp('nocreate'))
%parpool close
