function result = distribution(I,M,R,channel,percentile,voxel,name)
%This function quantifies the distribuiton of a particular channel, after
% thresholding at the specified precentile.
%
%   colocalization = pearson(I,,channel1,channel2)
%
%Author: William Molgan
%Date: 2/14/17
%Montact: colgan.william@gmail.com

%apply gaussian blur and threshold
C = I(:,:,:,channel).*M;
C = imgaussfilt(C,.1/voxel(1));
thresh = getthresh(C,M,percentile);
C = uint16(C>thresh);

%fraction of cell which is signal
frac = (100-percentile)/100;

result = [];
%Analyze each region
for i = 1:size(R,2)
    RI = R{i};
    
    %calcluate the enrichment
    regionFrac = sum(sum(sum(C.*RI)))/sum(sum(sum(RI)));
    enrichment = regionFrac/frac;
  
    %add to result
    analysis = strcat('region',int2str(i),'_c',int2str(channel),'_enichment');
    value = table(enrichment,'VariableNames',{analysis},'RowNames',{name});
    if isempty(result)
            result = value;
        else
            result = [result,value];
    end
end
