plate1 = imread('matricules/cam_1_08_25_02_05_2026.png');
plate2 = imread('matricules/cam_2_14_25_02_05_2026.png');
plate3 = imread('matricules/cam_3_16_20_02_05_2026.png');

hMin = 0.495; hMax = 0.581;
sMin = 0.276; sMax = 1.000;
vMin = 0.000; vMax = 1.000;

greenMask1 = isolateColor(plate1, hMin, hMax, sMin, sMax, vMin, vMax);
greenMask2 = isolateColor(plate2, hMin, hMax, sMin, sMax, vMin, vMax);
greenMask3 = isolateColor(plate3, hMin, hMax, sMin, sMax, vMin, vMax);

figure('Name', 'Test isolateColor - verd');

subplot(3,2,1); imshow(plate1);
title('Original plate 1');
subplot(3,2,3); imshow(plate2);
title('Original plate 2');
subplot(3,2,5); imshow(plate3);
title('Original plate 3');

subplot(3,2,2); imshow(greenMask1);
title('Filtered plate 1 numbers');
subplot(3,2,4); imshow(greenMask2);
title('Filtered plate 2 numbers');
subplot(3,2,6); imshow(greenMask3);
title('Filtered plate 3 numbers');

imwrite(greenMask1, '2. Locate/masks/greenMask1.png');
imwrite(greenMask2, '2. Locate/masks/greenMask2.png');
imwrite(greenMask3, '2. Locate/masks/greenMask3.png');