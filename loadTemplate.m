function templatesDB = loadTemplate(allChars)
filename = 'templatesDB.mat';

if isfile(filename)
    disp('Loading templates...');
    load(filename, 'templatesDB');
    disp('Templates loaded');

else
    fontName = 'Florida License Plate';
    disp('Generating 30x20 templates...');
    templatesDB = cell(1, length(allChars));

    for i = 1:length(allChars)
        baseImg = createCleanTemplate(allChars(i), fontName);
        templatesDB{i} = imresize(baseImg, [30, 20]) > 0.5;
    end

    save(filename, 'templatesDB');
    disp('Templates generated and saved');
end