function [image, expectedPlate] = loadCamera(camera)
    % Validate input
    if camera < 1 || camera > 3
        error('Invalid camera number. Please provide 1, 2, or 3.');
    end

    % Assign expected plate based on camera
    switch camera
        case 1
            expectedPlate = {'VO1KHQ'};
        case 2
            expectedPlate = {'WTG38N'};
        case 3
            expectedPlate = {'T67YVU'};
    end

    % Define connection details
    ips = {'10.112.11.211', '10.112.11.212', '10.112.11.213'};
    users = {'root', 'root', 'root'};
    passwords = {'Vivotek1', 'Vivotek2', 'Vivotek3'};
    
    % Connection logic
    url_camera = sprintf('http://%s/video.mjpg', ips{camera});
    try            
        disp(['Connectant a la càmera ' num2str(camera) '...']);
        cam = ipcam(url_camera, users{camera}, passwords{camera});
        image = {snapshot(cam)};
        clear cam;
    catch ME
        disp('Error: Connection refused.');
        disp(ME.message);
    end
end