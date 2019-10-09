function savethresholded(I,M,percentile1,percentile2,percentile3,voxel,filename)
%This funciton saves an image containing the cell, regions, and 
%thresholded channels.
%
%   savetif1(C1,filename)
%
%Author: William Colgan
%Date: 4/4/17
%Contact: colgan.william@gmail.com

%delete existing file
if exist(filename, 'file') == 2
  delete(filename);
end

%apply gaussian blur and threshold to channel 1
C1 = I(:,:,:,1).*M;
C1 = imgaussfilt(C1,.1/voxel(1));
thresh = getthresh(C1,M,percentile1);
C1 = uint16(C1>thresh);

%apply gaussian blur and threshold to channel 2
C2 = I(:,:,:,2).*M;
C2 = imgaussfilt(C2,.1/voxel(1));
thresh = getthresh(C2,M,percentile2);
C2 = uint16(C2>thresh);

%apply gaussian blur and threshold to channel 2
C3 = I(:,:,:,3).*M;
C3 = imgaussfilt(C3,.1/voxel(1));
thresh = getthresh(C3,M,percentile3);
C3 = uint16(C3>thresh);


J = cat(4,C1,C2,C3);
%for each plane
for i = 1:size(J,3)
   imwrite(squeeze(J(:,:,i,:)).*255,filename,'tif', 'WriteMode', 'append','Compression','none');
end

end