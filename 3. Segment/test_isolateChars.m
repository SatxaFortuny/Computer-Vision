
mask1 = imread('2. Locate/masks/greenMask1.png');
mask2 = imread('2. Locate/masks/greenMask2.png');
mask3 = imread('2. Locate/masks/greenMask3.png');

blobs1 = isolateChars(mask1);
blobs2 = isolateChars(mask2);
blobs3 = isolateChars(mask3);

% ==================================================================

figure('Name', 'Test isolateChars 1');
imshow(mask1); hold on;
for i = 1:length(blobs1)
    bb = blobs1(i).BoundingBox;
    rectangle('Position', bb, 'EdgeColor', 'red', 'LineWidth', 2);
    text(bb(1), bb(2) - 5, num2str(i), ...
         'Color', 'yellow', 'FontSize', 14, 'FontWeight', 'bold');
end
title(sprintf('%d plate 1 chars detected', length(blobs1)));
hold off;

frame = getframe(gca);
imwrite(frame.cdata, '3. Segment/chars/result1.png');

% ==================================================================

figure('Name', 'Test isolateChars 2');
imshow(mask2); hold on;
for i = 1:length(blobs2)
    bb = blobs2(i).BoundingBox;
    rectangle('Position', bb, 'EdgeColor', 'red', 'LineWidth', 2);
    text(bb(1), bb(2) - 5, num2str(i), ...
         'Color', 'yellow', 'FontSize', 14, 'FontWeight', 'bold');
end
title(sprintf('%d plate 2 chars detected', length(blobs2)));
hold off;

frame = getframe(gca);
imwrite(frame.cdata, '3. Segment/chars/result2.png');

% ==================================================================

figure('Name', 'Test isolateChars 3');
imshow(mask3); hold on;
for i = 1:length(blobs3)
    bb = blobs3(i).BoundingBox;
    rectangle('Position', bb, 'EdgeColor', 'red', 'LineWidth', 2);
    text(bb(1), bb(2) - 5, num2str(i), ...
         'Color', 'yellow', 'FontSize', 14, 'FontWeight', 'bold');
end
title(sprintf('%d plate 3 chars detected', length(blobs3)));
hold off;

frame = getframe(gca);
imwrite(frame.cdata, '3. Segment/chars/result3.png');