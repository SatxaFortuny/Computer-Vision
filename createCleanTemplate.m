function baseImg = createCleanTemplate(charStr, fontName)
fig = figure('Visible', 'off', 'Color', 'k', 'Position', [100 100 200 200]);
axes('Position', [0 0 1 1], 'XColor', 'none', 'YColor', 'none', 'Color', 'k');
xlim([0 1]); ylim([0 1]);
text(0.5, 0.5, charStr, 'FontName', fontName, 'FontSize', 120, ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'w');
img = print(fig, '-RGBImage'); close(fig);
grayImg = rgb2gray(img); 
binaryMask = grayImg > 128; 
props = regionprops(binaryMask, 'BoundingBox');
if ~isempty(props)
    bb = round(props(1).BoundingBox);
    baseImg = imcrop(binaryMask, [max(1, bb(1)), max(1, bb(2)), bb(3), bb(4)]);
else
    baseImg = binaryMask;
end
end