function result = brightness(I,M,channel,name)
%This function calculates the average intensity for a channel in the cell.
%
%   result = brightness(I,C,channel,name)
%
%Author: William Colgan
%Date: 2/14/17
%Contact: colgan.william@gmail.com

C = I(:,:,:,channel).*M;
volume = sum(sum(sum(M)));
average = sum(sum(sum(C)))/volume/2^16;
analysis = strcat('whole_c',int2str(channel),'_average');
result = table(average,'VariableNames',{analysis},'RowNames',{name});

end