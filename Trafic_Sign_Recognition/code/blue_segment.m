function new_s = blue_segment(h,s,v)
    img_seg = ( h > 0.54 & h < 0.65 ) & (s > 0.3) & (v > 0.2);
%     img_seg = ( h > 0.59 & h < 0.62 ) & (s > 0.3) & (v > 0.2);
    s = regionprops(img_seg, 'BoundingBox');
    new_s = cell(1,0); j = 1;
    for i = 1:length(s)
        if s(i).BoundingBox(3) > 20 && s(i).BoundingBox(4) > 20 ...
                && s(i).BoundingBox(3) < 100 && s(i).BoundingBox(4) < 100 ...
                && s(i).BoundingBox(3)/s(i).BoundingBox(4) < 1.1 ...
                && s(i).BoundingBox(4)/s(i).BoundingBox(3) < 1.4
              new_s{j} = s(i); j = j+1;
        end
    end
end

