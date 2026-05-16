function showFailedPrediction(charsCell, predictedStr, expectedStr, templatesDB, allChars, figureName)
    numChars = length(charsCell);
    
    figure('Name', figureName, 'Position', [150, 50, 1200, 800]);
    
    sgtitle(sprintf('Expected: %s | Predicted: %s', expectedStr, predictedStr), 'Color', 'r', 'FontSize', 16, 'FontWeight', 'bold');
    
    for i = 1:numChars
        charImg = charsCell{i};
        predictedChar = predictedStr(i);

        bestMatchIdx = strfind(allChars, predictedChar);
        bestTemplate = templatesDB{bestMatchIdx};
        
        subplot(5, numChars, i);
        imshow(charImg);
        title(sprintf('Extret (%d)', i));
        
        subplot(5, numChars, i + numChars);
        imshow(bestTemplate);
        title(['Predicció: ', predictedChar]);
        
        [h, w] = size(charImg);
        rgbDiffPred = zeros(h, w, 3);
        rgbDiffPred(:,:,1) = charImg & ~bestTemplate;
        rgbDiffPred(:,:,2) = charImg & bestTemplate; 
        rgbDiffPred(:,:,3) = bestTemplate & ~charImg; 
        
        subplot(5, numChars, i + 2*numChars);
        imshow(rgbDiffPred);
        title('Dif vs Pred');
        
        if i <= length(expectedStr)
            expectedChar = expectedStr(i);
            
            expectedMatchIdx = strfind(allChars, expectedChar);
            
            if ~isempty(expectedMatchIdx) 
                expectedTemplate = templatesDB{expectedMatchIdx};
                
                subplot(5, numChars, i + 3*numChars);
                imshow(expectedTemplate);
                title(['Esperat: ', expectedChar]);
                
                rgbDiffExp = zeros(h, w, 3);
                rgbDiffExp(:,:,1) = charImg & ~expectedTemplate;
                rgbDiffExp(:,:,2) = charImg & expectedTemplate;  
                rgbDiffExp(:,:,3) = expectedTemplate & ~charImg; 
                
                subplot(5, numChars, i + 4*numChars);
                imshow(rgbDiffExp);
                title('Dif vs Esp');
            end
        end
    end
end