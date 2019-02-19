function [] = slicetiming(func_targetdir, file, nslices, tr, sub_name)

%% Run slice time correction.

%func_targetdir: path to NIfTI functional data: func_targetdir(i,1)
%file: file output from the previous step; in this example removefirstf: '^f4D.*\.*'
%nslices: number of slices; in this example: 40
%tr: repetition time; in this example: 2.4
%sub_name: name current subject: sbj_fold(i).name

%% REMARK: adapt the slice order (line 20) and reference slice (line 21):
%          Interleaved top-down slice timing with the middle acquired slice as reference is used as default. 
%          Because of the interleaved acquisition, slice timing is run before realign (cf. Statistical Analysis of fMRI Data - p.57-58; according to Hannelore Aerts (UGent University).
%          Code examples for other options are available in the SPM batch.
%%

do_slicetiming = 1;

if do_slicetiming
        clear matlabbatch;
        ibatch = 1;       
        
        sequence = [nslices:-2:1, nslices-1:-2:1]; %interleaved top-down; Roma: 1:1:nslices
        refslice = sequence(floor(nslices/2)); %use middle acquired slice
        
        matlabbatch{ibatch}.spm.temporal.st.scans{1, 1} = cellstr(spm_select('ExtFPList', func_targetdir, file, Inf));
        
        matlabbatch{ibatch}.spm.temporal.st.nslices = nslices;
        matlabbatch{ibatch}.spm.temporal.st.tr = tr;
        matlabbatch{ibatch}.spm.temporal.st.ta = tr - (tr/nslices);
        matlabbatch{ibatch}.spm.temporal.st.so = sequence;
        matlabbatch{ibatch}.spm.temporal.st.refslice = refslice;
        matlabbatch{ibatch}.spm.temporal.st.prefix = 'o';
        disp('Running slice time correction with SPM batch ----');
        disp(sprintf(sub_name));
        disp('     ----      ');
        spm_jobman('run',matlabbatch);
        disp('Finished slice time correction!');
end
