%% *LABEL CREATION*

CurrFPath = matlab.desktop.editor.getActiveFilename;
CurrFPath = CurrFPath(1:end-22);
cd(CurrFPath)

load('gangster_detector.mat');
%%
%This segment of the code focuses on creating the labels for the validation
%images

% Specify the folder where the files are.
cd val_data/

% Assign train data folder path to var myFolder
myFolder = pwd;

% Gets a list of all files in the folder with .jpg extension
filePattern = fullfile(myFolder, '*.jpg');
theFiles = dir(filePattern);
%Create an array with the name of all files
FilesTable = struct2table(theFiles)
%% 
% *This segment of code uses the detector for each image and stores the data 
% in tables*

%This segment of code extracts the image size (x,y) for each image in the
%training data
imageSizes = table('Size', [height(FilesTable), 2], 'VariableTypes', {'double', 'double'}, 'VariableNames', {'X', 'Y'});
 for k=1:height(FilesTable)
    img = imread(char(FilesTable.(1)(k))); 
    ims = imshow(img);
    
    [bboxes,scores] = detect(detector,img, 'SelectStrongest',true);
    
    NoROI = isempty(bboxes);

%Display the detection results and insert the bounding boxes for objects into the image.

for i = 1:length(scores)
   annotation = sprintf('Confidence = %.1f',scores(i));
   img = insertObjectAnnotation(img,'rectangle',bboxes(i,:),annotation);
end

figure
imshow(img)

    % Get pixel dimensions of the image 
    imagePixelDimX = [ims.XData(2)]; % width in pixels
    imagePixelDimY = [ims.YData(2)]; % height in pixels
    
    if NoROI == false 
        imageSizes.('BBX')(k) = bboxes(1,1);
        imageSizes.('BBY')(k) = bboxes(1,2);
        imageSizes.('BBW')(k) = bboxes(1,3);
        imageSizes.('BBH')(k) = bboxes(1,4);
    end
    
    imageSizes.('X')(k) = imagePixelDimX;
    imageSizes.('Y')(k) = imagePixelDimY;
 end
 
 %Here it adds the columns of size x and size y to each picture in the
 %training data
 
 BboxesTable = [FilesTable.('name') imageSizes];

%%
%Makes a new table with ROI coordinates, width and height of the images in the
%training session
NewCoord = BboxesTable;

%Here we converted the matlab format, which is x & y from the top-left
%corner to x and y from the center point. 
for iX = 1:height(NewCoord)
    NewCoord{iX, 'BBX'} = NewCoord{iX, 'BBX'} + (NewCoord{iX, 'BBW'}/2);
    NewCoord{iX, 'BBY'} = NewCoord{iX, 'BBY'} + (NewCoord{iX, 'BBH'}/2);
end

%Here we normalize the coordinates relative to the x size and y size
for iX = 1:height(NewCoord)
    NewCoord{iX, 'BBX'} = NewCoord{iX, 'BBX'} / NewCoord{iX, 'X'};
    NewCoord{iX, 'BBY'} = NewCoord{iX, 'BBY'} / NewCoord{iX, 'Y'};
    NewCoord{iX, 'BBW'} = NewCoord{iX, 'BBW'} / NewCoord{iX, 'X'};
    NewCoord{iX, 'BBH'} = NewCoord{iX, 'BBH'} / NewCoord{iX, 'Y'};
end

%%
%For loop to write the .txt for each image 
for iK = 1 : height(NewCoord)
    %Here we change the filename of each image to .txt
    currTxtName = NewCoord.Var1{iK}(1:end-4) + ".txt";
    %Open a new file
a    TrainDataOut = fopen(currTxtName, 'w')
    %Print the converted coordinates to  the file
    fprintf(TrainDataOut, "0\t");
    fprintf(TrainDataOut, '%.6f\t', NewCoord{iK,'BBX'});
    fprintf(TrainDataOut, '%.6f\t', NewCoord{iK,'BBY'});
    fprintf(TrainDataOut, '%.6f\t', NewCoord{iK,'BBW'});
    fprintf(TrainDataOut, '%.6f\t', NewCoord{iK,'BBH'});
    fprintf(TrainDataOut, '\n');
    %Close the file
    fclose(TrainDataOut);
end
%% Load Ground Truth - Police

CurrFPath = matlab.desktop.editor.getActiveFilename;
CurrFPath = CurrFPath(1:end-22);
cd(CurrFPath)

load('police_detector.mat');
%%
%This segment of the code focuses on creating the labels for the validation
%images

% Specify the folder where the files are.
cd val_data/

% Assign train data folder path to var myFolder
myFolder = pwd;

% Gets a list of all files in the folder with .jpg extension
filePattern = fullfile(myFolder, '*.jpg');
theFiles = dir(filePattern);
%Create an array with the name of all files
FilesTable = struct2table(theFiles)
%% 
% *This segment of code uses the detector for each image and stores the data 
% in tables*

%This segment of code extracts the image size (x,y) for each image in the
%training data
imageSizes = table('Size', [height(FilesTable), 2], 'VariableTypes', {'double', 'double'}, 'VariableNames', {'X', 'Y'});
 for k=1:height(FilesTable)
    img = imread(char(FilesTable.(1)(k))); 
    ims = imshow(img);
    
    [bboxes,scores] = detect(detector,img, 'SelectStrongest',true);
    
    NoROI = isempty(bboxes);

%Display the detection results and insert the bounding boxes for objects into the image.

for i = 1:length(scores)
   annotation = sprintf('Confidence = %.1f',scores(i));
   img = insertObjectAnnotation(img,'rectangle',bboxes(i,:),annotation);
end

figure
imshow(img)

    % Get pixel dimensions of the image 
    imagePixelDimX = [ims.XData(2)]; % width in pixels
    imagePixelDimY = [ims.YData(2)]; % height in pixels
    
    if NoROI == false 
        imageSizes.('BBX')(k) = bboxes(1,1);
        imageSizes.('BBY')(k) = bboxes(1,2);
        imageSizes.('BBW')(k) = bboxes(1,3);
        imageSizes.('BBH')(k) = bboxes(1,4);
    end
    
    imageSizes.('X')(k) = imagePixelDimX;
    imageSizes.('Y')(k) = imagePixelDimY;
 end
 
 %Here it adds the columns of size x and size y to each picture in the
 %training data
 
 BboxesTable = [FilesTable.('name') imageSizes];

%%
%Makes a new table with ROI coordinates, width and height of the images in the
%training session
NewCoord = BboxesTable;

%Here we converted the matlab format, which is x & y from the top-left
%corner to x and y from the center point. 
for iX = 1:height(NewCoord)
    NewCoord{iX, 'BBX'} = NewCoord{iX, 'BBX'} + (NewCoord{iX, 'BBW'}/2);
    NewCoord{iX, 'BBY'} = NewCoord{iX, 'BBY'} + (NewCoord{iX, 'BBH'}/2);
end

%Here we normalize the coordinates relative to the x size and y size
for iX = 1:height(NewCoord)
    NewCoord{iX, 'BBX'} = NewCoord{iX, 'BBX'} / NewCoord{iX, 'X'};
    NewCoord{iX, 'BBY'} = NewCoord{iX, 'BBY'} / NewCoord{iX, 'Y'};
    NewCoord{iX, 'BBW'} = NewCoord{iX, 'BBW'} / NewCoord{iX, 'X'};
    NewCoord{iX, 'BBH'} = NewCoord{iX, 'BBH'} / NewCoord{iX, 'Y'};
end

%%
%For loop to write the .txt for each image 
for iK = 1 : height(NewCoord)
    %Here we change the filename of each image to .txt
    currTxtName = NewCoord.Var1{iK}(1:end-4) + ".txt";
    %Open a new file
    TrainDataOut = fopen(currTxtName, 'a')
    %Print the converted coordinates to  the file
    fprintf(TrainDataOut, "1\t");
    fprintf(TrainDataOut, '%.6f\t', NewCoord{iK,'BBX'});
    fprintf(TrainDataOut, '%.6f\t', NewCoord{iK,'BBY'});
    fprintf(TrainDataOut, '%.6f\t', NewCoord{iK,'BBW'});
    fprintf(TrainDataOut, '%.6f\t', NewCoord{iK,'BBH'});
    fprintf(TrainDataOut, '\n');
    %Close the file
    fclose(TrainDataOut);
end