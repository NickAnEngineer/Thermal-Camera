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
    in.vidName = input('Enter a name for the video file: ','s') ; % Asks for a file name for vid
    vColour = VideoWriter([reprocessedDir in.vidName ' Colour'],in.format); % Directory and format of vid
    vColour.FrameRate=in.frameRate; % Set the frame rate of the video
    open(vColour);
	if in.includeGrey == 1
		vGrey = VideoWriter([reprocessedDir in.vidName ' Grey'],in.format); % Directory and format of vid
		vGrey.FrameRate=in.frameRate; % Set the frame rate of the video
		open(vGrey);
	end
end

if strcmp(in.individualOrRange,'individual')
    imageRange = 1 ;
elseif strcmp(in.individualOrRange,'range')
    imageRange = in.imageRange ;
else
    error('Define where a single image or a stack of images is being processed')
end

fprintf('Progress: 000.0%%');

for imageNo = imageRange % Don't know if a for loop is the best way for this
	
    if strcmp(in.individualOrRange,'individual')
        fullFilename = [in.imageDir in.individualImageName '.tif'] ;
    else
        fullFilename = [in.imageRangeHangle num2str(imageNo, ['%0' num2str(in.numberPadding) 'd']) '.tif'] ;
    end
    
    [ColourImage, GreyImage] = tempCal(fullFilename, in); % Replace this function with the calibration curve function
    
	if in.cropImage == 1
        ColourImage = imcrop(ColourImage, in.croppedDIM);
		if in.includeGrey == 1
			GreyImage = imcrop(GreyImage, in.croppedDIM);
		end
	end
	
	if in.createVideo == 1 % Add frame to video
        writeVideo(vColour, ColourImage);
		if in.includeGrey == 1
			writeVideo(vGrey, (double(GreyImage) / 65536));
		end
	end
	
	if in.writeImages == 1 % Save re-processed image to specified location
        imwrite(ColourImage, [reprocessedDir num2str(imageNo) '.png']) ;
		if in.includeGrey == 1
			imwrite(GreyImage, [reprocessedDir num2str(imageNo) '.tif']) ;
		end
	end

	% display progress 
	fprintf('\b\b\b\b'); %delete previous
	fprintf('%3.1f%%', ((imageNo / length(imageRange)) * 100));
end

if in.createVideo == 1
    close(vColour);
	if in.includeGrey == 1
		close(vGrey)
	end
end


