function R = makeregions(M,dist1,dist2,voxel)
%This function generates the 3 regions given two distances
%
%   colocalization = makeregions(M,dist1,dist2,voxel)
%
%Author: William Colgan
%Date: 2/14/17
%Contact: colgan.william@gmail.com

%resize image so that the voxels are cubes
[x,y,z] = size(M);
scale = voxel(3)/voxel(1);
s = voxel(1);
C = imresize3(M,[x,y,round(z*scale)],'nearest');

%find regions with distance transform
D = bwdist(~C);
C1 = uint16(D > dist1/s);
C2 = uint16(D > dist2/s);
R1 = C - C1;
R2 = C1 - C2;
R3 = C2;

%resize regions to origional size
R1 = imresize3(R1,[x,y,z],'nearest');
R2 = imresize3(R2,[x,y,z],'nearest');
R3 = imresize3(R3,[x,y,z],'nearest');

R = {R1,R2,R3};

end