function blobs = isolateChars(mask)
  

    props = regionprops(mask, 'BoundingBox', 'Area', 'Image');

    if isempty(props)
        error('Blobs not found');
    end

    areas = [props.Area];
    [~, idxMax] = max(areas);
    bbRef      = props(idxMax).BoundingBox;
    reference  = bbRef(4);
    yCentreRef = bbRef(2) + bbRef(4) / 2;

    factorMin      = 0.50;
    factorMax      = 1.50;
    aspectRatioMin = 0.8;
    yTolerance     = 0.5;

    valid = false(length(props), 1);
    for i = 1:length(props)
        bb          = props(i).BoundingBox;
        height      = bb(4);
        width       = bb(3);
        aspectRatio = height / width;
        yCentre     = bb(2) + bb(4) / 2;

        if height >= reference * factorMin && ...
           height <= reference * factorMax && ...
           aspectRatio >= aspectRatioMin   && ...
           abs(yCentre - yCentreRef) <= reference * yTolerance
            valid(i) = true;
        end
    end

    props = props(valid);

    if isempty(props)
        error('Blobs not found');
    end

    widths = arrayfun(@(p) p.BoundingBox(3), props);
    widthRef = median(widths);

    blobsFinals = [];
    for i = 1:length(props)
        bb     = props(i).BoundingBox;
        width  = bb(3);
        nChars = round(width / widthRef);

        if nChars <= 1
            blobsFinals = [blobsFinals, props(i)];
        else
            widthPart = width / nChars;
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

    xPositions = arrayfun(@(p) p.BoundingBox(1), blobsFinals);
    [~, order] = sort(xPositions);
    blobs = blobsFinals(order);

    if length(blobs) > 6
        blobs = [blobs(1:3), blobs(end-2:end)];
    end

end