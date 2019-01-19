function M = loadmask(filename)
%This function loads the mask give a file.
%
%   C1 = loadmask('test.tif')
%
%Author: William Colgan
%Date: 4/4/17
%Contact: colgan.william@gmail.com

%get the info
info = imfinfo(filename);

%get dimensions
x = info.Height;
y = info.Width;
z = size(info,1);

%create matrix
M = zeros(x,y,z,strcat('uint16'));

%for each plane
for i = 1:z
   M(:,:,i) = imread(filename,i)/255;
end

end