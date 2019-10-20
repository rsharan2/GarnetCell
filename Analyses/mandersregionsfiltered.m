function result = mandersregionsfiltered(I,M,R,channel1,channel2,percentile1,percentile2,minvolume,maxvolume,voxel,name)
%This function quantifies the distribuiton of a particular channel, after
% thresholding at the specified precentile.
%
%   result = manders(I,M,R,channel1,channel2,percentile1,percentile2,voxel,name)
%
%Author: William Molgan
%Date: 2/14/17
%Montact: colgan.william@gmail.com

%apply gaussian blur and threshold to channel 1
C1 = I(:,:,:,channel1).*M;
C1 = imgaussfilt(C1,.1/voxel(1));
thresh = getthresh(C1,M,percentile1);
C1 = uint16(C1>thresh);

%filter by volume
CC = bwconncomp(C1,6);
S = regionprops3(CC, 'Volume');
L = labelmatrix(CC);
C1 = uint16(ismember(L, find([S.Volume] > minvolume & [S.Volume] < maxvolume)));

%apply gaussian blur and threshold to channel 2
C2 = I(:,:,:,channel2).*M;
C2 = imgaussfilt(C2,.1/voxel(1));
thresh = getthresh(C2,M,percentile2);
C2 = uint16(C2>thresh);

%filter by volume
CC = bwconncomp(C2,6);
S = regionprops3(CC, 'Volume');
L = labelmatrix(CC);
C2 = uint16(ismember(L, find([S.Volume] > minvolume & [S.Volume] < maxvolume)));

%get overlap
O = C1.*C2;

%Analyze whole cell
overlap = sum(sum(sum(O.*M)))/sum(sum(sum(C1.*M)));

%create result table
analysis = strcat('whole_c',int2str(channel1),'_overlap_c',int2str(channel2));
result = table(overlap,'VariableNames',{analysis},'RowNames',{name});


%Analyze each region
for i = 1:size(R,2)
    RI = R{i};
    
    %calculate the overlap
    overlap = sum(sum(sum(O.*RI)))/sum(sum(sum(C1.*RI)));

    %add to result
    analysis = strcat('region',int2str(i),'_c',int2str(channel1), ...
        '_overlap_c',int2str(channel2));
    value = table(overlap,'VariableNames',{analysis},'RowNames',{name});
    result = [result,value];
end