function show3d(M)
%This function seperates attached cells
figure;

p = patch(isosurface(M));
p.FaceColor = 'red';
p.EdgeColor = 'none';
p.FaceAlpha = .5;
camlight;
lighting phong;