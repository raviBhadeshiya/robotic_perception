function cubeProject(frame,corner_pts)

K=1.0e+02*[6.29302552,0.001,3.30766408;
    0,6.35529018,2.51004731;
    0,0,0.0100000];

pr = [ 1 0 0;
    0 1 0 ];

tag_width = 0.10;
tag_height = 0.10;
cube_depth = -0.10;

corner_pt = [  tag_width/2,  tag_height/2;
    -tag_width/2,  tag_height/2;
    -tag_width/2, -tag_height/2;
    tag_width/2, -tag_height/2 ];

render_points = [ corner_pt, zeros(4,1);
    corner_pt, (cube_depth)*ones(4,1) ];

p = (pr*(K \ [corner_pts'; ones(1,4)]))';
H = est_homography(corner_pt,p);

[proj_pts, ~, ~] = ar_cube(H,render_points,K);
inds = [ 1,2, 1,4, 1,5, 2,3, 2,6, 3,4, 3,7, 4,8, 5,6, 5,8, 6,7, 7,8 ];

X = proj_pts(inds,:);

for j = 1:2:length(X)
    Xj = X([j,j+1],:);
    line(round(Xj(:,1)), round(Xj(:,2)),'LineWidth', 3,'color','green');
end
pause(1/10);
end