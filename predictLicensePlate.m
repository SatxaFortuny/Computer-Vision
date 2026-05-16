function predictedStr = predictLicensePlate(charsCell, templatesDB, allChars)
    numChars = length(charsCell);
    predictedStr = '';

    for i = 1:numChars
        charImg = charsCell{i};
        
        maxScore = -9999; 
        bestMatchIdx = 1;
        
        for t = 1:length(templatesDB)
            tempIdeal = templatesDB{t};
            
            verd = sum(sum(charImg & tempIdeal));     
            blau = sum(sum(tempIdeal & ~charImg));    
            vermell = sum(sum(charImg & ~tempIdeal)); 
            
            score = (1.0 * verd) - (16 * blau) - (40 * vermell);
            
            if score > maxScore
                maxScore = score;
                bestMatchIdx = t;
            end
        end
        
        predictedChar = allChars(bestMatchIdx);
        if predictedChar == '0'
            predictedChar = 'O';
        end
        predictedStr = [predictedStr, predictedChar];
    end
end