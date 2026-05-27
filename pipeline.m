%[pictures, expectedPlates] = loadPictures('matricules'); 
[pictures, expectedPlates] = loadCamera(1);
% Threshold values obtained by trying with app (color thresholder)
hMin = 0.480; hMax = 0.570;
sMin = 0.440; sMax = 1.000;
vMin = 0.273; vMax = 1.000;

greenMask = {};
blobs = {};
plates = {};
allChars = ['0':'9', 'A':'Z'];
templatesDB = loadTemplate(allChars);

for i = 1:length(pictures)
    % First we straigthen the picture so the templates match properly
    pictures{i} = straightenPlate(pictures{i});
    
    % Then we filter by color
    greenMask{i} = isolateColor(pictures{i}, hMin, hMax, sMin, sMax, vMin, vMax);
    
    % Then we detect each char
    blobs{i} = isolateChars(greenMask{i});
    
    % Then we crop/extract each char
    chars = {};
    for j = 1:length(blobs{i})
        chars{j} = cropChar(blobs{i}(j), greenMask{i}); 
    end

    % Then we predict
    pred = predictLicensePlate(chars, templatesDB, allChars);
    
    % Then we check
    if ~strcmp(pred, expectedPlates{i})
        fprintf('Failed Plate %d -> Expected: %s \t Predicted: %s\n', i, expectedPlates{i}, pred);
        figName = sprintf('Failed Match - Plate %d', i);
        showFailedPrediction(chars, pred, expectedPlates{i}, templatesDB, allChars, figName);
    else 
        fprintf('Succesful Plate %d\n', i);
    end
end