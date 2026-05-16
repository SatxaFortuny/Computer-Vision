function mask = isolateColor(picture, hMin, hMax, sMin, sMax, vMin, vMax)

    if isa(picture, 'uint8')
        picture = im2double(picture);
    end

    hsv = rgb2hsv(picture);
    H = hsv(:,:,1);
    S = hsv(:,:,2);
    V = hsv(:,:,3);

    mask = (H >= hMin & H <= hMax) & ...
              (S >= sMin & S <= sMax) & ...
              (V >= vMin & V <= vMax);

    %mask = imopen(mask, strel('disk', 4));
    mask = imclose(mask, strel('disk', 1));
end