function [] = removefirstf(convert3D, removefirstf, convert4D, func_targetdir, file1, file2, sub_name)

%% Remove dummy scans.

%convert3D: choose whether you want to convert a 4D file (if you start with one) to 3D files in order to remove dummy scans: 0 (no) or 1 (yes)
%removefirstf: choose whether you want to remove dummy scans: 0 (no) or 1 (yes)
%convert4D: choose whether you want to convert the remaining 3D files to a 4D file: 0 (no) or 1 (yes)
%func_targetdir: path to NIfTI functional data: func_targetdir(i,1)
%file1: 4D file (if any): '.*\.*'
%file2: 3D files: '^f.*\.*'
%sub_name: name current subject: sbj_fold(i).name

%% REMARK: (1) adapt the number of to be removed scans (line 45 etc.) 
%          (2) do not forget to change file 1/2 (correct prefix)
%%

do_4Dto3D = convert3D; %0 
do_removefirstf = removefirstf; %1 %pulse before fixation cross = first scan; rest before first scan is removed - normally 8; but 5 for pp 2,7&9 and 7 for pp 8&34
do_3Dto4D = convert4D; %1

for irun = 1:1 %1x functional data (verb generation task)
        
        if irun == 1
            rundir = func_targetdir;
        end
        
        if do_4Dto3D %not tested yet
            ibatch = 1;
            clear matlabbatch;
            
            matlabbatch{ibatch}.spm.util.split.vol = cellstr(spm_select('FPList', rundir, file1));
            matlabbatch{ibatch}.spm.util.split.outdir = rundir;
            disp('Converting a 4D file to 3D ----');
            disp(sprintf(sub_name));
            disp('     ----      ');
            spm_jobman('run',matlabbatch);
            disp('Converting done!');

        end
        
        if do_removefirstf %pulse before fixation cross = first scan; rest before first scan is removed - normally 8; but 5 for pp 2,7&9 and 7 for pp 8&34
            ibatch = 1;
            clear matlabbatch;
            
            matlabbatch{ibatch}.cfg_basicio.file_dir.file_ops.file_move.files = [cellstr(spm_select('FPList', rundir, '.*\.*00001.*\.*'));
                                                                                 cellstr(spm_select('FPList', rundir, '.*\.*00002.*\.*'));
                                                                                 cellstr(spm_select('FPList', rundir, '.*\.*00003.*\.*'));
                                                                                 cellstr(spm_select('FPList', rundir, '.*\.*00004.*\.*'));
                                                                                 cellstr(spm_select('FPList', rundir, '.*\.*00005.*\.*'));   
                                                                                 cellstr(spm_select('FPList', rundir, '.*\.*00006.*\.*'));
                                                                                 cellstr(spm_select('FPList', rundir, '.*\.*00007.*\.*'));
                                                                                 cellstr(spm_select('FPList', rundir, '.*\.*00008.*\.*'));  
                                                                                 ];
            matlabbatch{ibatch}.cfg_basicio.file_dir.file_ops.file_move.action.delete = true;
            disp('Removing first X dummy scans ----');
            disp(sprintf(sub_name));
            disp('     ----      ');
            spm_jobman('run',matlabbatch);
            disp('Removing done!');
        end
            
            
        if do_3Dto4D
            ibatch = 1;
            clear matlabbatch;        
            
            matlabbatch{ibatch}.spm.util.cat.vols = cellstr(spm_select('FPList', rundir, file2));
            matlabbatch{ibatch}.spm.util.cat.name = 'f4D';
            matlabbatch{ibatch}.spm.util.cat.dtype = 16;
            disp('Converting 3D files to 4D ----');
            disp(sprintf(sub_name));
            disp('     ----      ');
            spm_jobman('run',matlabbatch);
            disp('Converting done!');
       end
end
end
