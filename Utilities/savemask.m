function savemask(M,filename)
%This funciton saves a 1 channel tif image.
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

%for each plane
for i = 1:size(M,3)
   imwrite(M(:,:,i).*255,filename,'tif', 'WriteMode', 'append','Compression','none');
end

end