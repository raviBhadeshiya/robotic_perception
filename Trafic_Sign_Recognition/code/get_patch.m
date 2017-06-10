function patch = get_patch( img, s )
    patch = cell(length(s),1);
    for i=1:length(s)
        patch{i} = imresize(imcrop(img,s{i}.BoundingBox),[64,64]);            
    end
end

