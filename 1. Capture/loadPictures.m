function pictures = loadPictures(folder)

    files = dir(fullfile(folder, '*.png'));

    if isempty(files)
        error('Files not found in: %s', folder);
    end

    fprintf('Loading %d pictures\n', length(files));

    pictures = cell(length(files), 1);
    for i = 1:length(files)
        path = fullfile(folder, files(i).name);
        pictures{i} = imread(path);
        fprintf('Loaded: %s\n', files(i).name);
    end
end
