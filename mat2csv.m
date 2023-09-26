dbstop if error

% clear
clc;clear;close all;

% chose the folder of files
path = uigetdir;

% if at least 1 file is choosed
if path ~= 0

    % get full paths of files
    list = get_all_files_of_a_certain_type_in_a_rootpath(path,'*.mat');

    % choose files
    [indx,tf] = listdlg('ListString',list,'ListSize',[800,600],'Name','Chose files to convert');

    % if at least 1 file is choosed
    if tf==1
        for ii = indx

            % load
            full_path = list{ii};
            load(full_path);

            % save
            save_full_path = strrep(full_path,'.mat','.csv');
            writematrix(data,save_full_path);

        end
    end

end