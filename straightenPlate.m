function rotatedImg = straightenPlate(img)
    
    if size(img, 3) == 3
        grayImg = rgb2gray(img);
    else
        grayImg = img;
    end
    
    edges = edge(grayImg, 'Canny'); 
    
    [H, T, R] = hough(edges);
    P = houghpeaks(H, 5, 'threshold', ceil(0.3*max(H(:)))); 
    lines = houghlines(edges, T, R, P, 'FillGap', 20, 'MinLength', 100);
    
    angles = [];
    for k = 1:length(lines)
        x1 = lines(k).point1(1); y1 = lines(k).point1(2);
        x2 = lines(k).point2(1); y2 = lines(k).point2(2);
        
        theta = atan2d(y2 - y1, x2 - x1);
        
        if abs(theta) < 15
            angles = [angles, theta];
        end
    end
    
    if ~isempty(angles)
        plateAngle = median(angles);
    else
        plateAngle = 0; 
    end
    
    rotatedImg = imrotate(img, plateAngle, 'bicubic', 'crop');
end