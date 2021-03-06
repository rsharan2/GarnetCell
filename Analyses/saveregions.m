function saveregion(M,R,filename)
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

I = cat(4,R{1},R{2},R{3});
%for each plane
for i = 1:size(I,3)
   imwrite(squeeze(I(:,:,i,:)).*255,filename,'tif', 'WriteMode', 'append','Compression','none');
end

end