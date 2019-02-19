function [] = denoise(anat_targetdir, func_targetdir, anat_file1, anat_file2, anat_file3, func_file, rp_file, tr, bandpass)

%% Run additional steps for resting state fMRI: 
%% (1) removing noise from WM, CSF 
%% (2) regressing motion parameters
%% (3) filtering the data
%% (4) detrending the data

%anat_targetdir: path to NIfTI anatomical data: anat_targetdir(i,1)
%func_targetdir: path to NIfTI functional data: func_targetdir(i,1)
%anat_file1: file output from the previous anat previous step, i.e. brain: 'brain.nii'
%anat_file2: file output from a previous anat step, i.e. build_functionalmask_normalized/standard: 'wwhite.nii'/'stdwhite.nii'
%anat_file3: file output from a previous anat step, i.e. build_functionalmask_normalized/standard: 'wcsf.nii'/'stdcsf.nii'
%func_file: file output from the previous func step, i.e. smooth: '^swrof4D.*\.*'
%rp_file: file with the motion parameters: '^rp_.*\.txt'
%tr: repetition time; in this example: 2.4
%bandpass: HZ band for filtering; in this example: [0.01 0.09]

%% REMARK: (1) do not forget to change anat_file1/2 to subject-specific vs. standard
%          (2) do not forget to change tr and bandpass
%%

do_denoise = 1;

if do_denoise
        brainmask = spm_select('FPList', anat_targetdir, anat_file1);
        whitemask = spm_select('FPList', anat_targetdir, anat_file2);
        csfmask = spm_select('FPList', anat_targetdir, anat_file3);
       
        whiteV = spm_vol(whitemask);
        wholeV = spm_vol(brainmask); %Roma: wholemask - not correct

        white = spm_read_vols(whiteV);
        csfV = spm_vol(csfmask);
        csf = spm_read_vols(csfV);
	    whole = spm_read_vols(wholeV);        

        wind = find(white);
        csind = find(csf);
	    wholeind = find(whole);
        outind = find(whole == 0);

        fprintf('TR is %d \n', tr); %put your TR here
        Band = bandpass; 
        
        for irun = 1:1
            if irun == 1
                rundir = func_targetdir;
            end

            F = cellstr(spm_select('ExtFPList', rundir, func_file, Inf));
            V = spm_vol(F); %from img to a structure
            Vstruct = V;
            seq = max(size(V));
           
            data = [];
            for ind = 1:seq
                dat = spm_read_vols(V{ind}); %reads the data from the structure
                data(ind,:) = dat(:)'; %to have data in the format nvolumes x number of voxels
            end
              
            fprintf('Getting motion parameters from subject ----');
            RP_file = spm_select('FPList', rundir, rp_file);
            HMotion = load(RP_file);
            
            % *****************************************************
            % Data masking and regression: (1) and (2)
            % *****************************************************
          
            % Average over the whole time course for each voxel.
            %BRSIG = mean(data(:,brind),2);
            WSIG  = mean(data(:,wind),2);
            CSIG  = mean(data(:,csind),2);
            nobs = size(WSIG,1); %number of time points
            
            covariate = [ones(nobs,1) CSIG WSIG HMotion];
            beta = (covariate\data(:,wholeind)); %the backslash is different from divide /!!! See help
            data(:,wholeind) = data(:,wholeind) - covariate*beta;            

            % *****************************************************
            % (3) Filtering
            % *****************************************************
            
            fprintf('filtering\n');
            data(:,wholeind) = rest_IdealFilter(data(:,wholeind), tr, Band);
            
            % *****************************************************
            % (4) Detrending
            % *****************************************************
            fprintf('detrending\n');
            data(:,wholeind) = spm_detrend(data(:,wholeind),3); 

            data(:,outind) = 0; % zeroing voxels outside brain
            
            %% Demeaning and scaling by std each voxel TS.
            %  This you can decide to include or not! Some people do, some do not.
            %%
            %               for dem=1:size(data,2)
            
            %                  m = mean(data(:,dem));
            %                  s = std(data(:,dem));
            %                  data(:,dem) = (data(:,dem)-m);
            %                  if (s==0)
            
            %                 else
            
            %                 data(:,dem) = data(:,dem)/s;
            
            %                 end
            %              end
            %%
            
            V1 = Vstruct;
            
            for ind = 1:seq
                [path, name, ext] = fileparts(V1{ind}.fname);
                V1{ind}.fname = [ path '/' 'x' name ext];
                D = reshape(data(ind, :), V1{ind}.dim);
                Image = spm_write_vol(V1{ind}, D);
            end
        end
end
end
