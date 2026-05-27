function blobs = isolateChars(mask)
  
    % I'll start by extracting the properties of all the connected components (blobs) in the mask.
    % I specifically need their bounding boxes, areas, and the actual image data.
    props = regionprops(mask, 'BoundingBox', 'Area', 'Image');
    
    % Just a quick safety check to make sure I actually found something.
    % If the mask is empty, I'll throw an error so the program doesn't crash silently later.
    if isempty(props)
        error('Blobs not found');
    end
    
    % To figure out what a "normal" character looks like, I'll find the largest blob in the image.
    areas = [props.Area];
    [~, idxMax] = max(areas);
    
    % I'm going to use the height and vertical center of this largest blob as my standard reference.
    bbRef      = props(idxMax).BoundingBox;
    reference  = bbRef(4);
    yCentreRef = bbRef(2) + bbRef(4) / 2;
    
    % Now I'm setting up my tolerance rules to filter out noise. 
    % I want blobs that are roughly the same height, aren't too wide, and sit on the same horizontal line.
    factorMin      = 0.50;
    factorMax      = 1.50;
    aspectRatioMin = 0.8;
    yTolerance     = 0.5;
    
    % I'll create a logical array to keep track of which blobs pass my tests.
    valid = false(length(props), 1);
    
    % I'm going to loop through every blob I found and check it against my rules.
    for i = 1:length(props)
        % I'll pull out the height, width, aspect ratio, and center Y-coordinate for this specific blob.
        bb          = props(i).BoundingBox;
        height      = bb(4);
        width       = bb(3);
        aspectRatio = height / width;
        yCentre     = bb(2) + bb(4) / 2;
        
        % If it matches my criteria for height, shape, and alignment, I'll mark it as a valid character.
        if height >= reference * factorMin && ...
           height <= reference * factorMax && ...
           aspectRatio >= aspectRatioMin   && ...
           abs(yCentre - yCentreRef) <= reference * yTolerance
            valid(i) = true;
        end
    end
    
    % Now I'll throw away all the blobs that didn't pass my tests.
    props = props(valid);
    
    % Another quick check—if my filters were too aggressive and removed everything, I'll throw an error.
    if isempty(props)
        error('Blobs not found');
    end
    
    % Sometimes characters touch each other and form one giant blob.
    % To fix this, I'll calculate the median width of my valid blobs to use as a baseline.
    widths = arrayfun(@(p) p.BoundingBox(3), props);
    widthRef = median(widths);
    
    % I need an empty array to store my final, properly separated blobs.
    blobsFinals = [];
    
    % I'll iterate through my filtered blobs to check if any of them are suspiciously wide.
    for i = 1:length(props)
        bb     = props(i).BoundingBox;
        width  = bb(3);
        
        % I'll divide the current blob's width by the reference width and round it to guess how many characters are stuck together.
        nChars = round(width / widthRef);
        
        if nChars <= 1
            % If it's just one character (or less), I'll just add it to my final list as-is.
            blobsFinals = [blobsFinals, props(i)];
        else
            % But if it looks like multiple characters stuck together, I'll split it up into equal-sized chunks.
            widthPart = width / nChars;
            
            % I'll create new bounding boxes for each chunk and add them to my final list.
            for j = 1:nChars
                nouBlob = props(i);
                nouBlob.BoundingBox(1) = bb(1) + (j-1) * widthPart;
                nouBlob.BoundingBox(3) = widthPart;
                nouBlob.Image = [];
                nouBlob.Area  = props(i).Area / nChars;
                blobsFinals = [blobsFinals, nouBlob];
            end
        end
    end
    
    % Characters need to be read from left to right, so I'll sort my final blobs based on their X-coordinates.
    xPositions = arrayfun(@(p) p.BoundingBox(1), blobsFinals);
    [~, order] = sort(xPositions);
    blobs = blobsFinals(order);
    
    % Finally, if I somehow ended up with more than 6 characters, I'll assume some noise got through.
    % I'll just keep the first 3 and the last 3 to match my expected format.
    if length(blobs) > 6
        blobs = [blobs(1:3), blobs(end-2:end)];
    end
end