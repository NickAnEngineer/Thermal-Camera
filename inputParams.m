% These are the input parameters for the main ImageReprocessor.m code

% Location of images 
in.imageDir = 'E:\My Documents\Post Doc\Staff and Student Projects\MAT4444\2017\Group 7 - Ashfan\Thermal camera images\6-1 mm 50ms\' ;
in.individualOrRange = 'range' ; % 'individual' for single image 'range' for a stack of images 
in.individualImageName = '6-2mm 50ms 3\' ;
in.imageRangeHangle = [in.imageDir 'Image_'] ; % First part of image filename excluding number
in.imageRange = 163:169 ; % Range of images to use ; %200 - 1300 or 742 to 978

% Image output options
in.writeImages = 1 ; % Write individual images
in.addImageText = 0 ; % Add text to images such as FPS and time stamp
in.cropImage = 1 ; % Crop the image according to properties listed below
in.imRotate = 90 ; % Angle to rotate image
in.contrastRange = 2^16 ; % Set the upper limit for intensity
in.intensityCrv = 2 ; % 1 - Intensities, 2 - pseudo temps (^4), 3 - Temp map
in.tempMapLoc = "PATH TO CalData.mat"; %mat file containing cal data temp in first col, dl in second col
in.croppedDIM = [150 0 2000 1800] ; % Image cropping [xmin ymin width height]

% Video output properties
in.createVideo = 0 ; % Create video
in.frameRate = 100 ; %FPS
in.format = 'MPEG-4' ;