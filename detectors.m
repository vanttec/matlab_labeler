%https://www.youtube.com/watch?v=UnXDQmjYvDk&list=PLn8PRpmsu08oLufaYWEvcuez8Rq7q4O7D&index=32
%%
%Sets program path to the parent of the current file
%This is necessary to make load work in any computer
CurrFPath = matlab.desktop.editor.getActiveFilename;
CurrFPath = CurrFPath(1:end-14);
cd(CurrFPath)
%% Load Ground Truth


load('police_labels.mat')
%%
%Create training data from ground truth
    %In case of multiple labels in the object:
police_truth = selectLabels(gTruth,'police')
%%
%Create folder for training data
%if isfolder(fullfile('training_data'))
%   cd training_data
%else
%    mkdir training_data
%end
%addpath('training_data')

%%
%extracts a subset of ground truth dataset
training_data = objectDetectorTrainingData(police_truth)
summary(training_data)
%%
%This segment of code extracts the image size (x,y) for each image in the
%training data
imageSizes = table('Size', [height(training_data), 2], 'VariableTypes', {'double', 'double'}, 'VariableNames', {'X', 'Y'});
 for k=1:height(training_data)
    img = imread(char(training_data.('imageFilename')(k))); 
    ims = imshow(img);
    % Get pixel dimensions of image 
    imagePixelDimX = [ims.XData(2)]; % width in pixels
    imagePixelDimY = [ims.YData(2)]; % height in pixels
    imageSizes.('X')(k) = imagePixelDimX;
    imageSizes.('Y')(k) = imagePixelDimY;
 end
 
 %Here it adds the columns of size x and size y to each picture in the
 %training data
 
 training_data = [training_data imageSizes];
%%
%train de ACF detector
detector = trainACFObjectDetector(training_data,'NumStages',5)
%%
save('police_detector.mat','detector');
%rmpath('training_data');
%%
% Specify the folder where the files are.
cd train_data/

% Assign train data folder path to var myFolder
myFolder = pwd;

% Gets a list of all files in the folder with .jpg extension
filePattern = fullfile(myFolder, '*.jpg');
theFiles = dir(filePattern);
%Create an array with the name of all files
FilesTable = struct2table(theFiles) 
ImageNames = FilesTable.name

%%
%Makes a new table with ROI coordinates, width and height of the images in the
%training session
NewCoord = training_data(:, {'police', 'X', 'Y'})

%Here we converted the matlab format, which is x & y from the bottom left
%corner to x and y from the center point. 
for iX = 1:height(training_data)
    NewCoord{iX, 1}{1}(1) = (NewCoord{iX, 'police'}{1}(1) + ((NewCoord{iX, 'police'}{1}(3))/2));
    NewCoord{iX, 1}{1}(2) = (NewCoord{iX, 'police'}{1}(2) - ((NewCoord{iX, 'police'}{1}(4))/2));
end

%Here we normalize the coordinates relative to the x size and y size
for iX = 1:height(training_data)
    NewCoord{iX, 1}{1}(1) = (NewCoord{iX, 'police'}{1}(1)/ NewCoord{iX, "X"});
    NewCoord{iX, 1}{1}(2) = (NewCoord{iX, 'police'}{1}(2)/ NewCoord{iX, "Y"});
    NewCoord{iX, 1}{1}(3) = (NewCoord{iX, 'police'}{1}(1)/ NewCoord{iX, "X"});
    NewCoord{iX, 1}{1}(4) = (NewCoord{iX, 'police'}{1}(2)/ NewCoord{iX, "Y"});
end

%%
%Read the data and write it


%For loop to write the .txt for each image 
for iK = 1 : height(training_data)
    %Here we change the filename of each image to .txt
    currTxtName = ImageNames{iK, 1}(1:end-4) + ".txt";
    %Open a new file
    TrainDataOut = fopen(currTxtName, 'a')
    %Print the converted coordinates to  the file
    fprintf(TrainDataOut, "0\t");
    fprintf(TrainDataOut, '%.6f\t', NewCoord{iK,1}{1});
    fprintf(TrainDataOut, '\n');
    %Close the file
    fclose(TrainDataOut);
end
%%
%Ejecuta Pol_detectors que crea las labels del policia y agrega sus
%coordenadas a los .txt ya existentes

pol_detectors;