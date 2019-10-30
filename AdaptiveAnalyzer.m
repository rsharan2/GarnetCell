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
        R = makeregions(M,1,3,voxel);
        
        %create new result table
        result = brightness(I,M,3,name);
        
        %Change parameters here!
        %
        %for adaptive thresholding, the sensitivity is a number from [0,1] with 0
        %being strict and 1 being least strict.
        %
        %for percentile thresholding, the sensitivity is a number from
        %[0,100] with 100 being very strict and 0 being the least strict.
        sensitivity1 = .1;
        sensitivity2 = sensitivity1;
        min_volume = 10;
        max_volume = 2500;
        
        %add analyses here
        result = [result,brightness(I,M,1,name)];
        result = [result,distribution(I,M,R,2,sensitivity1,voxel,name)];
        result = [result,distribution(I,M,R,1,sensitivity1,voxel,name)];
        result = [result,mandersregionsfiltered(I,M,R,2,1,sensitivity1,sensitivity2,min_volume,max_volume,voxel,name)];
        result = [result,vdratio(I,M,1,sensitivity1,voxel,name)];
        
        %Uncomment this line to save threshoded image
        %regionspath = strcat(path,'/regions_',name,'.tif');
        %saveregions(M,R,regionspath);
        thresholdedpath = strcat(path,'/threholded_',name,'.tif');
        savethresholdedfiltered(I,M,R,1,2,sensitivity1,sensitivity2,min_volume,max_volume,voxel,thresholdedpath);
        
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



