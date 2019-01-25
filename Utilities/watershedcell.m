function M = watershedcell(C,M,sigma)
%This function watersheds an image in 3D to refine the cell mask. It
%assumes the cell is in the center of the image. A good sigma is [2,2,.5]
%
%   M = watershedcell(C,M,sigma)
%
%Author: William Colgan
%Date: 4/4/17
%Contact: colgan.william@gmail.com

inside = M;
outside = zeros(size(M));

%set the edges to 1
[x,y,z] = size(outside);
outside(1,:,:) = 0;
outside(:,1,:) = 0;
outside(:,:,1) = 0;
outside(x,:,:) = 0;
outside(:,y,:) = 0;
outside(:,:,z) = 0;

if(sigma > 0)
C = imgaussfilt3(C,[sigma,sigma,1]); %apply gaussian filter
end
R = inside + outside; %set R to inside and outside
R = imimposemin(C,R); %make R local minimum for watershed
L = watershed(R); %watershed
%imshow(L(:,:,30).*100);
i = L(round(x/2),round(y/2),round(z/2)); %find value at center
M = double(L==i); %return L equal to value

end

