function corner_pts = cornerPoints(lines)
corner_pts=[];
for i = 1:length(lines)-1
    for j = i+1:length(lines)
        
        xy1 = [lines(i).point1; lines(i).point2];
        xy2 = [lines(j).point1; lines(j).point2];
        %intersection of two lines (the current line and the previous one)
        slopee = @(line) (line(2,2) - line(1,2))/(line(2,1) - line(1,1));
        m1 = slopee(xy1);
        m2 = slopee(xy2);
        
        intercept = @(line,m) line(1,2) - m*line(1,1);
        b1 = intercept(xy1,m1);
        b2 = intercept(xy2,m2);
        xintersect = (b2-b1)/(m1-m2);
        yintersect = m1*xintersect + b1;
        if (xintersect > 0 && yintersect >0)
            corner =[xintersect,yintersect];
            corner_pts=[corner_pts;corner];
        end
    end
end


end
