function charImg = cropChar(blob, mask)
    
    % I'm setting a standard target size here. 
    % Every character I crop will eventually be resized to 30 rows by 20 columns so they are all uniform.
    ROWS = 30;
    COLS = 20;
    
    % I need the bounding box coordinates for this specific character blob.
    % I'm rounding them to whole numbers because I can't reference a fraction of a pixel.
    bb = round(blob.BoundingBox);
    
    % Here I'm grabbing the starting x and y coordinates. 
    % I'm using 'max' with 1 just in case the bounding box tries to go off the top or left edge of the image.
    x = max(1, bb(1));
    y = max(1, bb(2));
    
    % Similarly, I'm setting up the width and height of my crop. 
    % I use 'min' to guarantee the crop box doesn't accidentally extend past the right or bottom edges of the mask.
    w = min(bb(3), size(mask, 2) - x);
    h = min(bb(4), size(mask, 1) - y);
    
    % Now I'm actually slicing the character out of the full image mask using those safe, verified coordinates.
    originalChar = mask(y:y+h-1, x:x+w-1);
    
    % Time to resize the cropped character to that standard 30x20 size I defined at the very beginning.
    charImg = imresize(originalChar, [ROWS, COLS]);
    
    % The resizing process usually introduces some blurry, gray pixels along the edges.
    % I'll apply a quick threshold at 0.5 to snap everything back into crisp black and white (logical 1s and 0s).
    charImg = charImg > 0.5;
end