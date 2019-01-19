function M = separatecells(M,radius,voxel)
%This function removes abbuting cells
%
%   M = separatecells(M,radius,voxel) 
%
%Author: William Colgan
%Date: 5/4/17
%Contact: colgan.william@gmail.com
scale = voxel(3)/voxel(1);
[x,y,z] = size(M);
C = imresize3(M,[round(x/scale),round(y/scale),z],'linear');
D = bwdist(~C);
D = -D;
D(~C) = Inf;
R = makeseed(C,radius);
D(R==1) = -Inf;
F = double(D);
L = watershed(D);
L(~C) = 0;
[x1,y1,z1] = size(L);
i = L(round(x1/2),round(y1/2),round(z1/2));
C = double(L==i);
M = imresize3(C,[x,y,z],'nearest');
SE = strel('sphere',3);
M  = imdilate(M, SE);
SE = strel('sphere',5);
M = imerode(M,SE);
M = double(M);
end

