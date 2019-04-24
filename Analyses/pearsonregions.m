function result = pearsonregions(I,M,R,channel1,channel2,name)
%This function calculates the pearson correleation coefficient for the
%region in the binary mask M.
%
%   colocalization = pearson(I,,channel1,channel2)
%
%Author: William Molgan
%Date: 2/14/17
%Montact: colgan.william@gmail.com

%Analyze whole cell

%Apply the mask to each channel
C1 = I(:,:,:,channel1).*M;
C2 = I(:,:,:,channel2).*M;

%get the mean for each channel
mean1 = sum(sum(sum(C1)))/sum(sum(sum(M)));
mean2 = sum(sum(sum(C2)))/sum(sum(sum(M)));

%get the covariance of the channels
covariance = sum(sum(sum((C1-mean1).*(C2-mean2).*M)));

%get the standard deveation of each channel
sum1 = sum(sum(sum(((C1-mean1).*M).^2)));
sum2 = sum(sum(sum(((C2-mean2).*M).^2)));

%calcluate the pearson correleation coefficient
colocalization = double(covariance/sqrt(sum1*sum2));
analysis = strcat('whole_c',int2str(channel1),'_coloc_c',int2str(channel2));
result = table(colocalization,'VariableNames',{analysis},'RowNames',{name});

%Analyze each region
for i = 1:size(R,2)
    RI = R{i};

    %Apply the mask to each channel
    C1 = I(:,:,:,channel1).*RI;
    C2 = I(:,:,:,channel2).*RI;

    %get the mean for each channel
    mean1 = sum(sum(sum(C1)))/sum(sum(sum(RI)));
    mean2 = sum(sum(sum(C2)))/sum(sum(sum(RI)));

    %get the covariance of the channels
    covariance = sum(sum(sum((C1-mean1).*(C2-mean2).*RI)));

    %get the standard deveation of each channel
    sum1 = sum(sum(sum(((C1-mean1).*RI).^2)));
    sum2 = sum(sum(sum(((C2-mean2).*RI).^2)));

    %calcluate the pearson correleation coefficient
    colocalization = double(covariance/sqrt(sum1*sum2));
    analysis = strcat('region',int2str(i),'_c',int2str(channel1), ...
    '_coloc_c',int2str(channel2));
    value = table(colocalization,'VariableNames',  ...
    {analysis},'RowNames',{name});

    result = [result,value];
end
