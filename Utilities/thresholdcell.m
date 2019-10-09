function M = thresholdcell(C,thresh,sigma,slope)
%This function thresholds a 3D image to segment the cell. It returns a
%binary mask of type uint16 where 1 is in the cell and 0 is outside of 
%the cell. The threshLevel can go from 0 to 2.
%
%   M = thresholdcell(C,thresh,sigma) 
%
%Author: William Colgan
%Date: 4/4/17
%Contact: colgan.william@gmail.com

%make new channel and set threshold
M = zeros(size(C),'uint16');
thresh = multithresh(C)*thresh;
numplanes = size(C,3);

%for threshold each plane
for i = 1:numplanes
    P = C(:,:,i);
    if(sigma > 0)
        P = imgaussfilt(P,sigma); %apply gaussfilt
    end
    P = uint16(P>thresh*(1-i*slope+numplanes*slope/2)); %threshold
    SE = strel('diamond',10);
    P = imdilate(P, SE); %dilate to close gaps
    [x,y] = size(P);
    P(1,:) = 0;
    P(:,1) = 0;
    P(:,y) = 0;
    P(x,:) = 0;
    P = imfill(P, 'holes'); %fill holes
    P = imerode(P,SE); %undo dilation
    M(:,:,i) = P;
end
SE = strel('cube',5);
M = imerode(M,SE);
M = bwareaopen(M,100000);
M  = imdilate(M, SE);
M = uint16(M);

end