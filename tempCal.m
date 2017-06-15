function [ColourImage, GreyImage] = tempCal(fullFilename, in)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    [rawImage] = imread(fullFilename); % Load the image
    
    colourMap = jet(in.contrastRange) ; % Set the colour map
    
	switch in.intensityCrv
        case 1 % Raw intensities

        case 2 % Intensities fourth rooted
			intensityImage = rawImage + 1 ;
            convertedImage = (double(intensityImage)).^0.25 * in.contrastRange/(in.contrastRange).^0.25 ;
            convertedImage = floor(intensityImage) ;
			
		case 3 % Calibrated Temperature Conversion
			load(in.tempMapLoc);
			if exist('calData', 'var')
				intensityImage = double(rawImage);
				% clip data to low end of cal
				intensityImage(rawImage < calData(1,2)) = calData(1,2);
				% clip data to high end of cal
				intensityImage(rawImage > calData(end,2)) = calData(end,2);
				
				convertedImage = interp1(calData(:,2), calData(:,1), double(intensityImage), 'nearest');
				if in.units == 'c'
					convertedImage = convertedImage - 273.15;
				end
			end
	end
    
	%round to allow easy saving at 16 bit
	convertedImage = round(convertedImage, 0);
	GreyImage = uint16(convertedImage);
    ColourImage = ind2rgb(convertedImage, colourMap);
  
end

