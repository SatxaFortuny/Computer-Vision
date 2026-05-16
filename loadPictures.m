function [pictures, expectedPlates] = loadPictures(folder)
    files = dir(fullfile(folder, '*.png'));
    if isempty(files)
        error('Files not found in: %s', folder);
    end
    
    fprintf('Loading %d pictures\n', length(files));
    
    pictures = cell(length(files), 1);
    expectedPlates = cell(length(files), 1); 
    
    for i = 1:length(files)
        filename = files(i).name;
        path = fullfile(folder, filename);
        
        pictures{i} = imread(path);
        
        if startsWith(filename, 'cam_1')
            expectedPlates{i} = 'VO1KHQ';
        elseif startsWith(filename, 'cam_2')
            expectedPlates{i} = 'WTG38N';
        elseif startsWith(filename, 'cam_3')
            expectedPlates{i} = 'T67YVU'; 
        else
            expectedPlates{i} = 'UNKNOWN';
        end
        
        fprintf('Loaded: %s | Expected Plate: %s\n', filename, expectedPlates{i});
    end
end