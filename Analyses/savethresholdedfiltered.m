function savethresholdedfiltered(I,M,R,channel1,channel2,percentile1,percentile2,minvolume,maxvolume,voxel,filename)
%This funciton saves an image containing the cell, regions, and 
%thresholded channels after filtering by volume.
%
%   savethresholdedfiltered(I,M,R,channel1,channel2,percentile1,
%   percentile2,minvolume,maxvolume,voxel,filename)
%
%Author: William Colgan
%Date: 10/19/19
%Contact: colgan.william@gmail.com

%delete existing file
if exist(filename, 'file') == 2
  delete(filename);
end

%apply gaussian blur and threshold to channel 1
C1 = I(:,:,:,channel1).*M;
C1 = imgaussfilt(C1,.1/voxel(1));
thresh = getthresh(C1,M,percentile1,'adaptive');
%C1 = uint16(C1>thresh);
C1 = uint16(imbinarize(C1,thresh));

%filter by volume
CC = bwconncomp(C1,6);
S = regionprops3(CC, 'Volume');
L = labelmatrix(CC);
C1 = ismember(L, find([S.Volume] > minvolume & [S.Volume] < maxvolume));

%apply gaussian blur and threshold to channel 2
C2 = I(:,:,:,channel2).*M;
C2 = imgaussfilt(C2,.1/voxel(1));
thresh = getthresh(C2,M,percentile2,'adaptive');
%C2 = uint16(C2>thresh);
C2 = uint16(imbinarize(C2,thresh));

%filter by volume
CC = bwconncomp(C2,6);
S = regionprops3(CC, 'Volume');
L = labelmatrix(CC);
C2 = ismember(L, find([S.Volume] > minvolume & [S.Volume] < maxvolume));

C3 = bwperim(R{1},4)*65535 + bwperim(R{3},4)*65535;

J = cat(4,C1,C2,C3);
%for each plane
for i = 1:size(J,3)
   imwrite(squeeze(J(:,:,i,:)).*255,filename,'tif', 'WriteMode', 'append','Compression','none');
end

end