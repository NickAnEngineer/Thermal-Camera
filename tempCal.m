function [ColourImage, appTemps] = tempCal(fullFilename, emissivity, in)
%UNTITLED Summary of this function goes here
stefanb = 5.670373e-8 ;
%   Detailed explanation goes here
    [RGB] = imread(fullFilename); % Load the image
    
    IMintensity = RGB + 1 ;
    
    switch in.intensityCrv
        case 1 % Raw intensities

        case 2 % Intensities fourth rooted
            appTemps = (double(IMintensity)./(stefanb*emissivity)).^0.25 ;
    end
    
    ColourImage = ind2rgb(floor(appTemps),jet(max(floor(appTemps(:)))));
  
end

