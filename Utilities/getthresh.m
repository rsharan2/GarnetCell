function thresh = getthresh(C,M,percentile)
%gets a percentilecentile of the data
%
%   thresh = getthresh(C,M,percentile)
%
%Author: William Colgan
%Date: 6/28/17
%Contact: colgan.william@gmail.com

C = C.*M;
if max(max(max(C))) ~= 0
    [x,y,z] = size(C);
    v1 = sort(reshape(C,[x*y*z,1]));
    k = find(v1);
    v1 = v1(k(1):end);
    thresh = prctile(v1,percentile);
else
    thresh = 1;
end
end