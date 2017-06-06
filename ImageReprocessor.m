clear all
clc

% ---------------------------- INPUTS -------------------------------------

[inFile,inPath] = uigetfile ; % Selects the input file which is inputParams in repository
run([inPath inFile])
% Ideally replace this with a UI at some point. All input parameters are
% structured under 'in' e.g. in.imageRange

% -------------------------------------------------------------------------

if in.createVideo + in.writeImages > 0 % Creates a folder in the images dir for the reprocessed images and/or vid
    reprocessedDir = [in.imageDir 'Reprocessed_' date '_' datestr(now,'HHMMSS') '\'] ; % Creates a name for dir based on date and time
    mkdir(reprocessedDir) % Creates the directory
end

if in.createVideo == 1 % Open video file to add frames
    in.vidName = input('Enter a name for the video file: ') ; % Asks for a file name for vid
    v = VideoWriter([reprocessedDir in.vidName],in.format); % Directory and format of vid
    v.FrameRate=frameRate; % Set the frame rate of the video
    open(v);
end

if strcmp(in.individualOrRange,'individual')
    imageRange = 1 ;
elseif strcmp(in.individualOrRange,'range')
    imageRange = in.imageRange ;
else
    error('Define where a single image or a stack of images is being processed')
end
PreviouslySaturated = false(2048,2048);
stefanb = 5.670373e-8 ;

for imageNo = imageRange % Don't know if a for loop is the best way for this
    
    if strcmp(in.individualOrRange,'individual')
        fullFilename = [in.imageDir in.individualImageName '.tif'] ;
    else
        fullFilename = [in.imageRangeHangle num2str(imageNo) '.tif'] ;
    end
    
    RawImage = imread(fullFilename);
    
    CurentlySaturated = RawImage==2^16-1;
    
    PreviouslySaturated = or(CurentlySaturated,PreviouslySaturated);
    
    emissivity = ones(2048,2048)*0.5;
    
    emissivity(PreviouslySaturated) = 0.27;
    
    [ColourImage, appTemps] = tempCal(fullFilename, emissivity, in); % Replace this function with the calibration curve function
    
    if in.cropImage == 1
        ColourImage = imcrop(ColourImage, in.croppedDIM) ;
    end

    if in.createVideo == 1 % Add frame to video 
        writeVideo(v,ColourImage);
    end
    
    if in.writeImages == 1 % Save re-processed image to specified location
        imwrite(ColourImage,[reprocessedDir num2str(imageNo) '.png']) ;
    end
    figure
    imagesc(ColourImage)
end

if in.createVideo == 1
    close(v);
end


