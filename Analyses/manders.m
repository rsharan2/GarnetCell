function result = manders(I,M,channel1,channel2,percentile1,percentile2,voxel,name)
%This function quantifies the distribuiton of a particular channel, after
% thresholding at the specified precentile.
%
%   result = manders(I,M,channel1,channel2,percentile1,percentile2,voxel,name)
%
%Author: William Molgan
%Date: 2/14/17
%Montact: colgan.william@gmail.com

%apply gaussian blur and threshold to channel 1
C1 = I(:,:,:,channel1).*M;
C1 = imgaussfilt(C1,.1/voxel(1));
thresh = getthresh(C1,M,percentile1);
C1 = uint16(imbinarize(C1,thresh));
%C1 = uint16(C1>thresh);

%apply gaussian blur and threshold to channel 2
C2 = I(:,:,:,channel2).*M;
C2 = imgaussfilt(C2,.1/voxel(1));
thresh = getthresh(C2,M,percentile2);
C2 = uint16(imbinarize(C2,thresh));
%C2 = uint16(C2>thresh);

%get overlap
O = C1.*C2;

%Analyze whole cell
overlap = sum(sum(sum(O.*M)))/sum(sum(sum(C1.*M)));

%create result table
analysis = strcat('whole_c',int2str(channel1),'_overlap_c',int2str(channel2));
result = table(overlap,'VariableNames',{analysis},'RowNames',{name});

end