function [I,voxel] = loadimage(filename)
%This funciton loads a tif image given a file. It returns a
% {x,y,z,c] matrix I and the voxel size if the image has 
%resolution data.
%
%   [I,voxel] = loadtif(file)
%
%Author: William Colgan
%Date: 4/4/17
%Contact: colgan.william@gmail.com

%get the info
info = imfinfo(filename);

%get dimensions
x = info.Height;
y = info.Width;
description = info.ImageDescription;
i = strfind(description,'channels');
c = str2double(description(i+9:i+10));
z = size(info,1)/c;

%get voxel size
xRes = info.XResolution;
if isempty(xRes) %if it does not have resolution
    voxel = [];
else
    xSize = 1/xRes;
    yRes = info.YResolution;
    ySize = 1/yRes;
    i = strfind(description,'spacing');
    line = strsplit(description(i+8:i+16));
    zSize = str2double(line{1});
    voxel = [xSize,ySize,zSize];
end

%get bit depth


%create image matrix
I = zeros(x,y,z,c,'uint16');

%for each plane
for i = 1:z
    for j = 1:c
        I(:,:,i,j) = imread(filename,c*(i-1)+j);
    end
end
    
%adjust for bit depth
depth = info.BitDepth;
if depth == 8
    I = I.*256;
end
if max(max(max(max(I))))<4096
    I = I.*16;
end

end