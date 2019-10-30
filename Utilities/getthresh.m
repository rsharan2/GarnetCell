function thresh = getthresh(C,M,percentile,varargin)
%gets a percentilecentile of the data
%
%   thresh = getthresh(C,M,percentile)
%
%Author: William Colgan
%Date: 6/28/17
%Contact: colgan.william@gmail.com

C = C.*M;

if ~isempty(varargin) && isequal(varargin{1},'adaptive')
    if percentile > 1
        percentile = double(percentile)/100;
    end
    thresh = adaptthresh(C,percentile);
elseif max(max(max(C))) ~= 0
    [x,y,z] = size(C);
    v1 = sort(reshape(C,[x*y*z,1]));
    k = find(v1);
    v1 = v1(k(1):end);
    thresh = prctile(v1,percentile);
else
    thresh = 1;
end

end