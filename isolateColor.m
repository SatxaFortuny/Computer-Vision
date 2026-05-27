function mask = isolateColor(picture, hMin, hMax, sMin, sMax, vMin, vMax)
    
    % First, I'm checking if the image data is using 8-bit integers.
    % If it is, I'll convert it to doubles (0 to 1 range) to make sure the math is predictable.
    if isa(picture, 'uint8')
        picture = im2double(picture);
    end
    
    % Now, I'll convert the image from standard RGB into the HSV color space.
    % HSV (Hue, Saturation, Value) makes it much easier to isolate specific colors regardless of lighting.
    hsv = rgb2hsv(picture);
    
    % I'm splitting the converted image into its three separate channels so I can evaluate them individually.
    H = hsv(:,:,1);
    S = hsv(:,:,2);
    V = hsv(:,:,3);
    
    % This is where I actually build the mask. 
    % I'm keeping only the pixels that strictly fall within the min and max thresholds I provided for all three channels.
    mask = (H >= hMin & H <= hMax) & ...
              (S >= sMin & S <= sMax) & ...
              (V >= vMin & V <= vMax);
              
    % Finally, I'm applying a morphological close using a tiny disk (radius 1).
    % This is just a quick cleanup step to fill in any single-pixel holes or tiny gaps in my final mask.
    mask = imclose(mask, strel('disk', 1));
end