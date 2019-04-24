%This script analyzes a selected folder of image. The Excel
%file is saved in the folder you select.
%
%Author: William Colgan
%Date: 2/26/18
%Contact: colgan.william@gmail.com

%add Utilities and Analyses to path
addpath('./Analyses');
addpath('./Utilities');

%get the path for the directory
path = uigetdir();
addpath(path);

%get all files in the directory
[~,directory,~] = fileparts(path);
filenames = dir(path);
filenames = {filenames(:).name};

%create sheet to store the analysis
sheet = [];

%for each image in the directory
for i = 1:size(filenames,2)
    
    %check if it is a tif image with is not a mask
    filename = filenames{i};
    [~,name,ext] = fileparts(filename); 
    if(strcmp(ext,'.tif') && ~strcmp(name(1:4),'mask'))
        
        disp(strcat("Anayzing... ",name));
        
        %get mask and regions
        [I,voxel] = loadimage(filename);
        M = loadmask(strcat('mask_',filename));
        %R = makeregions(M,1,3,voxel);
        
        %create new result table
        result = manders(I,M,2,3,95,95,voxel,name);
        
        %add analyses here
        result = [result,manders(I,M,3,2,95,95,voxel,name)];
        result = [result,pearson(I,M,2,3,name)];
        %result = [result,distribution(I,M,R,3,95,voxel,name)];
        %result = [result,distribution(I,M,R,2,95,voxel,name)];
        %result = [result,manders(I,M,R,1,3,95,95,voxel,name)];
        
        %add the result to the sheet
        if isempty(sheet)
            sheet = result;
        else
            sheet = [sheet;result];
        end
        
    end
end

%Write to xlsx file
filename = strcat(path,'/',directory,'_analysis.xls');
writetable(sheet,filename,'WriteRowNames',true)



