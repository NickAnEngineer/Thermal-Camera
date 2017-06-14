function [ColourImage] = tempCal(fullFilename, in)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    [rawImage] = imread(fullFilename); % Load the image
    
    colourMap = jet(in.contrastRange) ; % Set the colour map
    
    
    switch in.intensityCrv
        case 1 % Raw intensities

        case 2 % Intensities fourth rooted
			IMintensity = rawImage + 1 ;
            convertedImage = (double(IMintensity)).^0.25 * in.contrastRange/(in.contrastRange).^0.25 ;
            convertedImage = floor(IMintensity) ;
			
		case 3 % Calibrated Temperature Conversion
			calData = load(in.tempMapLoc);
			convertedImage = interp1(calData(:,2), calData(:,1), double(rawImage), 'nearest');
			if in.units == 'c'
				convertedImage = convertedImage - 273.15;
			end
    end
    
    ColourImage = ind2rgb(convertedImage, colourMap);
  
end

