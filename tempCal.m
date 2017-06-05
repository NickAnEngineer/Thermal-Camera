function [ColourImage] = tempCal(fullFilename, in)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    [RGB] = imread(fullFilename); % Load the image
    
    colourMap = jet(in.contrastRange) ; % Set the colour map
    IMintensity = RGB + 1 ;
    
    switch in.intensityCrv
        case 1 % Raw intensities

        case 2 % Intensities fourth rooted
            IMintensity = (double(IMintensity)).^0.25 * in.contrastRange/(in.contrastRange).^0.25 ;
            IMintensity = floor(IMintensity) ;
    end
    
    ColourImage = ind2rgb(IMintensity, colourMap);
  
end

