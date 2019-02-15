function result = sphericity(M,voxel,name)
%This function calculates the sphericity of a cell.
%
%   result = sphericity(I,M,name)
%
%Author: William Colgan
%Date: 2/14/17
%Contact: colgan.william@gmail.com

%get volume
volume = imVolume(M,voxel);

%get suface area
surface = imSurface(M,13,voxel);

%get sphericity
value = (pi^(1/3)*(6*volume)^(2/3))/surface;

analysis = 'sphericity';
result = table(value,'VariableNames',{analysis},'RowNames',{name});

end