Instructions are given in the main script, as well as in the subscripts.

### SCRIPT STRUCTURE

**MAIN: fMRI_preprocessing_pipeline_SPM.m**\
fMRI (resting-state or task) standard preprocessing pipeline for one task using SPM (BIDS folder format) created on MATLAB_R2015b. The file names are adapted to the BIDS format as well (http://bids.neuroimaging.io/). \
When preprocessing rs-fMRI an additional preprocessing step is added: denoise.m (subscript 14)\
**Only compatible with 1 task**

#### SUBSCRIPTS (i.e. preprocessing steps): 
	1.  ima.m
	2.  removefirstf.m -> (!!) different for different sessions/participants 
	3.  BIDS_rename.m  -> can be uncommented
	4.  slicetiming.m
	5.  realign.m
	6.  coregistration.m
	7.  segmentation.m
	8.  normalize_func.m
	9.  smoothing.m
	10. normalize_anat.m
	11. build_functionalmask_normalized.m OR
	%12. build_functionalmask_standard.m
	13. brain.m
	%14. denoise.m -> only for resting-state fMRI
	
Remark: Conversion to the BIDS format can also be done before the removal of the dummy scans.

### FOLDER/FILE STRUCTURE after BIDS_rename.m

	dicomdir: sub-01: anat       my_dataset: sub-01: anat: sub-01_T1w.nii, ...
	          	  func                           func: f4D_sub-01_task_bold.nii, ...
	  	  sub-02: anat                   sub-02: anat
 	          	  func                           func
	  	  ...                            ...
		  
For each preprocessing step, a prefix is added in front of the (anat or func) file name.
