clc;clear;close all;


%%%%%%%%%%%%%%%%%%%%%%%% read me %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this package uses the Kernel density Estimate Matlab-based toolbox developed by
% Alexander Ihler (http://www.ics.uci.edu/~ihler/code/kde.html).

%%
%%%%%%%%%%%%%% what this does %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%1) loads data set - it has to be in correct mat file format
%2) applies density valley clustering

%%
%%%%%%%%%%%%%%%%%%%%pick data file %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Pick main file with data set.
%mat file with variable "data" inside, rows are data points and columns n dimensions of the data
% [FileName,PathName] =  uigetfile('*.*');

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

            % cluster
            clusterDv_3_function(data);

            % save
            for i = 1:3

                % call gcf
                figure(i)

                % axis equal
                if i == 3
                    axis equal;
                end

                % save
                save_full_path = strrep(full_path,'.mat',sprintf('_figure-%d.png',i));
                saveas(gcf,save_full_path);

            end

            close all;

        end
    end

end