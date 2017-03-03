function projected_imgs=lenaProject(logo_pts,corner_pts,logo_img,frame)
            trans=fitgeotrans(logo_pts,corner_pts,'projective');
            warped=imwarp(logo_img,trans,'OutputView',imref2d(size(frame)));
            blob=findBlob(frame);
            blob3D=im2uint8(cat(3,blob,blob,blob));
            frame=bitand(frame,blob3D);
            projected_imgs=frame+warped;
end