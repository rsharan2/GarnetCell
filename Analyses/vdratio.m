function result = vdratio(I,M,channel,percentile,voxel,name)

%get dorsal and ventral regions
l = sum(sum(M));
l = reshape(l,[size(l,3),1]);
k = round(COG(l));
D = uint16(zeros(size(M)));
D(:,:,(1:k)) = 1;
V = uint16(zeros(size(M)));
V(:,:,(k+1:end)) = 1;
D = M.*D;
V = M.*V;

%apply gaussian blur and threshold
C = I(:,:,:,channel).*M;
C = imgaussfilt(C,.1/voxel(1));
thresh = getthresh(C,M,percentile,'adaptive');
C = uint16(imbinarize(C,thresh));
%C = uint16(C>thresh);

ratio = sum(sum(sum(C.*V)))/sum(sum(sum(I(:,:,:,channel).*D)));
analysis = strcat('vdratio_c',int2str(channel));
result = table(ratio,'VariableNames',{analysis},'RowNames',{name});