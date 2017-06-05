# Thermal-Camera
ImageReprocessor.m is the main code which will call all the functions

inputParams.m contains all the user options e.g. where the images are saved, whether to create a video or not etc. The main code will ask the user to locate the inputParams files. This means multiple versions can be saved (i.e. for different image sets) and this file can be renamed accordingly without having to change the main code. There is no need to commit changes to this code unless more inputs are to be added which will be required by the main code

tempCal is just a basic function that is fourth rooting the intensities. This needs to be replaced with the proper cal curve.

![Alt text](processingWorkflow.png?raw=true "Optional Title")
