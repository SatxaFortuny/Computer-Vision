function rotatedImg = straightenPlate(img)
    
    % First, I need to check if the image is in color (3 channels).
    % If it is, I'll convert it to grayscale to make edge detection easier.
    if size(img, 3) == 3
        grayImg = rgb2gray(img);
    else
        % It's already grayscale, so I'll just keep it as is.
        grayImg = img;
    end
    
    % Now I'm using the Canny method to find the edges in my grayscale image.
    edges = edge(grayImg, 'Canny'); 
    
    % Let's run the Hough transform to find the straight lines among those edges.
    [H, T, R] = hough(edges);
    
    % I'm picking the top 5 peaks in the Hough transform to identify the strongest lines.
    % I set a threshold here so it ignores the weaker signals.
    P = houghpeaks(H, 5, 'threshold', ceil(0.3*max(H(:)))); 
    
    % Here I'm extracting the actual line segments from the peaks.
    % I'll fill in small gaps (up to 20 pixels) and ignore lines shorter than 100 pixels.
    lines = houghlines(edges, T, R, P, 'FillGap', 20, 'MinLength', 100);
    
    % I need an empty array to store the angles of the lines I'm about to process.
    angles = [];
    
    % Time to loop through each line segment I detected.
    for k = 1:length(lines)
        % I'm grabbing the starting and ending (x,y) coordinates for the current line.
        x1 = lines(k).point1(1); y1 = lines(k).point1(2);
        x2 = lines(k).point2(1); y2 = lines(k).point2(2);
        
        % I'll calculate the angle of this line in degrees using arctangent.
        theta = atan2d(y2 - y1, x2 - x1);
        
        % Since I'm looking for a roughly horizontal license plate,
        % I'll only keep angles that are relatively flat (less than 15 degrees off).
        if abs(theta) < 15
            angles = [angles, theta];
        end
    end
    
    % Now I check if I actually found any horizontal-ish lines.
    if ~isempty(angles)
        % If I did, I'll take the median angle to avoid being thrown off by a random outlier.
        plateAngle = median(angles);
    else
        % If I didn't find any, I'll just assume the plate is already straight (0 degrees).
        plateAngle = 0; 
    end
    
    % Finally, I'll rotate the original image by the angle I calculated.
    % I'm using 'bicubic' for smoother visuals and 'crop' so the image dimensions don't change.
    rotatedImg = imrotate(img, plateAngle, 'bicubic', 'crop');
end