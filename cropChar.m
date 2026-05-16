function charImg = cropChar(blob, mask)
    ROWS = 30;
    COLS = 20;
    
    bb = round(blob.BoundingBox);
    x = max(1, bb(1));
    y = max(1, bb(2));
    w = min(bb(3), size(mask, 2) - x);
    h = min(bb(4), size(mask, 1) - y);
    
    originalChar = mask(y:y+h-1, x:x+w-1);
    
    charImg = imresize(originalChar, [ROWS, COLS]);
    
    charImg = charImg > 0.5;
end