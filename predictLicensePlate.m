function predictedStr = predictLicensePlate(charsCell, templatesDB, allChars)
    
    % First, I need to know exactly how many characters I'm dealing with.
    numChars = length(charsCell);
    
    % I'll initialize an empty string where I can build my final predicted license plate.
    predictedStr = '';
    
    % Now, I'm going to loop through each individual character I previously isolated.
    for i = 1:numChars
        % I'll grab the current character image from the cell array.
        charImg = charsCell{i};
        
        % I need a baseline score to beat, so I'll set the starting maximum score very low.
        maxScore = -9999; 
        
        % I'll also assume the first template is the best match until proven otherwise.
        bestMatchIdx = 1;
        
        % Time to compare this specific character against every single template in my database.
        for t = 1:length(templatesDB)
            % I'm pulling out the "ideal" version of the current letter/number to test against.
            tempIdeal = templatesDB{t};
            
            % 'verd' (green) represents true positives. I'm counting pixels that overlap perfectly.
            verd = sum(sum(charImg & tempIdeal));     
            
            % 'blau' (blue) represents false negatives. These are pixels the template has, but my image missed.
            blau = sum(sum(tempIdeal & ~charImg));    
            
            % 'vermell' (red) represents false positives. These are extra, noisy pixels my image has that the template doesn't.
            vermell = sum(sum(charImg & ~tempIdeal)); 
            
            % Now I'll calculate a final score. 
            % I reward matches, but heavily penalize missing pieces (x16) and extra noise (x40).
            score = (1.0 * verd) - (16 * blau) - (40 * vermell);
            
            % If this template scores better than my current best, I'll update my records.
            if score > maxScore
                maxScore = score;
                bestMatchIdx = t;
            end
        end
        
        % Now that I've checked all templates, I'll grab the actual text character corresponding to the highest score.
        predictedChar = allChars(bestMatchIdx);
        
        % Based on standard license plate rules for this specific format, 
        % if I predicted a '0' (zero), I'll forcefully correct it to an 'O' (the letter).
        if predictedChar == '0'
            predictedChar = 'O';
        end
        
        % Finally, I'll append this winning character to my final string and move on to the next one.
        predictedStr = [predictedStr, predictedChar];
    end
end