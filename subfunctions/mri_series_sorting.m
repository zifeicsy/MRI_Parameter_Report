function mri_series_sorting(raw_dir)
% batch for resting data sorting

cd (raw_dir); 
sub_list = dir(raw_dir);

for ii = 1:length(sub_list)
    if strcmp(sub_list(1).name,'.') || strcmp(sub_list(1).name,'..')
        sub_list = sub_list(2:end);
    end
end
    
    
for ii = 1:length(sub_list)
    subid = [];
    if isfolder(sub_list(ii).name)
        subid = [subid;sub_list(ii)];
    end
end

for n=1:size(subid,1)
    cd (fullfile(raw_dir, subid(n).name));
    sequence_run = dir(fullfile(raw_dir, subid(n).name));
    for ii = 1:length(sequence_run)
        if strcmp(sequence_run(1).name,'.') || strcmp(sequence_run(1).name,'..')
            sequence_run = sequence_run(2:end);
        end
    end
    
    for m =1:size(sequence_run,1)
        path = fullfile(raw_dir, subid(n).name, sequence_run(m).name);

        dcm_list = spm_get('Files',path,'*.dcm');
        if isempty(dcm_list)
            dcm_list = spm_get('Files',path,'*.DCM');
            if isempty(dcm_list)
                dcm_list = spm_get('Files',path,'*.IMA');
            end
            if isempty(dcm_list)
                dcm_list = spm_get('Files',path,'*.ima');
            end
        end
        
        hdrs = spm_dicom_headers(dcm_list(1,:));
        dir_name = hdrs{1}.SeriesDescription;
        new_name = fullfile(raw_dir, subid(n).name, dir_name);
        if strcmp(path,new_name) == 0
            movefile(path,new_name);
        end
    end
    disp(['Sub',num2str(n),' ----- ',subid(n).name,' ----- Data Sorting Done ---------']);
end
