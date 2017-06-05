clear vars
clc

% ---------------------------- INPUTS -------------------------------------

% Ideally move these into a separate .mat input file or UI to avoid
% changing this code every time

% Location of images 
imageDir = 'E:\My Documents\Post Doc\Staff and Student Projects\MAT4444\2017\Group 7 - Ashfan\Thermal camera images\6-1 mm 50ms\' ;
individualOrRange = 'range' ; % 'individual' for single image 'range' for a stack of images 
individualImageName = '6-2mm 50ms 3' ;
imageRangeHangle = [imageDir 'Image_'] ; % First part of image filename excluding number
imageRange = 163:169 ; % Range of images to use ; %200 - 1300 or 742 to 978

% Image output options
writeImages = 1 ; % Write individual images
addImageText = 0 ; % Add text to images such as FPS and time stamp
cropImage = 1 ; % Crop the image according to properties listed below
imRotate = 90 ; % Angle to rotate image
contrastRange = 2^16 ; % Set the upper limit for intensity
intensityCrv = 2 ; % 1 - Intensities, 2 - pseudo temps (^4)
croppedDIM = [150 0 2000 1800] ; % Image cropping [xmin ymin width height]

% Video output properties
createVideo = 0 ; % Create video
vidName = [imageDir 'Reprocessed\vid10'] ;
frameRate = 100 ; %FPS
format = 'MPEG-4' ;
reprocessedDir = [imageDir 'Reprocessed\'] ;

% -------------------------------------------------------------------------

if createVideo == 1 % Open video file to add frames
    v = VideoWriter(vidName,format);
    v.FrameRate=frameRate;
    open(v);
end

if strcmp(individualOrRange,'individual')
    imageRange = 1 ;
elseif strcmp(individualOrRange,'range')
else
    error('Define where a single image or a stack of images is being processed')
end

for imageNo = imageRange % Don't know if a for loop is the best way for this
    
    if strcmp(individualOrRange,'individual')
        fullFilename = [imageDir individualImageName '.tif'] ;
    else
        fullFilename = [imageRangeHangle num2str(imageNo) '.tif'] ;
    end
    
    [ColourImage] = tempCal(fullFilename, contrastRange, intensityCrv); % Replace this function with the calibration curve function
    
    if cropImage == 1
        ColourImage = imcrop(ColourImage,croppedDIM) ;
    end

    if createVideo == 1 % Add frame to video 
        writeVideo(v,ColourImage);
    end
    
    if writeImages == 1 % Save re-processed image to specified location
        imwrite(ColourImage,[reprocessedDir num2str(imageNo) '.png']) ;
    end

end

if createVideo == 1
    close(v);
end


