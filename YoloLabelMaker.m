%% This code reads gTruth label data and converts it to a YOLO format, then creates a '.txt' per image and label data

CurrFPath = matlab.desktop.editor.getActiveFilename;
CurrFPath = CurrFPath(1:end-16);
cd(CurrFPath)

%%
%Specify which labels you will turn into yolo format
detLabelsName = 'detector_labels.mat'
%% 
% This segment of code loads the labels to conver and info of the labeled images

Labels = load(detLabelsName);
% Specify the folder where the files are.
cd val_data/

% Assign train data folder path to var myFolder
myFolder = pwd;

% Gets a list of all files in the folder with .jpg extension
filePattern = fullfile(myFolder, '*.jpg');
%Create an array with the name of all files
FilesTable = struct2table(dir(filePattern));
%% 
% *This segment of code extracts the size of each image*

imageSizes = table('Size', [height(FilesTable), 2], 'VariableTypes', {'double', 'double'}, 'VariableNames', {'SizeX', 'SizeY'});
 for k=1:height(FilesTable)
    img = imread(char(FilesTable.(1)(k))); 
    ims = imshow(img);
    % Get pixel dimensions of the image 
    imageSizes.('SizeX')(k) = ims.XData(2); % width in pixels
    imageSizes.('SizeY')(k) = ims.YData(2); % height in pixels
 end
%% 
% This segment of code creates a new table with all the data necessary to create 
% the .txt 
% 
% The variable cont tracks the label being converted

Label_Coords = Labels.gTruth.LabelData;

NumberOfLabels = width(Label_Coords);

for cont=1:NumberOfLabels
 

    Yolo_Coords = table('Size', [height(Label_Coords), 4], 'VariableTypes', {'double', 'double', 'double', 'double'}, 'VariableNames', {'X', 'Y', 'W', 'H'});
    
     for k=1:height(FilesTable)
         
        if not(isempty(Label_Coords.(cont){k}))
            Yolo_Coords.X(k) = Label_Coords{k,cont}{1,1}(1);
            Yolo_Coords.Y(k) = Label_Coords{k,cont}{1,1}(2);
            Yolo_Coords.W(k) = Label_Coords{k,cont}{1,1}(3);
            Yolo_Coords.H(k) = Label_Coords{k,cont}{1,1}(4);
        end
     end
     
     Yolo_Coords = [FilesTable(:,'name') imageSizes Yolo_Coords]
     
     
%% 
% Here we converted the matlab format, which is x & y from the top-left corner 
% to x and y from the center point, yolo format.


    for iX = 1:height(Yolo_Coords)
        Yolo_Coords{iX, 'X'} = Yolo_Coords{iX, 'X'} + (Yolo_Coords{iX, 'W'}/2);
        Yolo_Coords{iX, 'Y'} = Yolo_Coords{iX, 'Y'} + (Yolo_Coords{iX, 'H'}/2);
    end
    
    %Here we normalize the coordinates relative to the x size and y size
    for iX = 1:height(Yolo_Coords)
        Yolo_Coords{iX, 'X'} = Yolo_Coords{iX, 'X'} / Yolo_Coords{iX, 'SizeX'};
        Yolo_Coords{iX, 'Y'} = Yolo_Coords{iX, 'Y'} / Yolo_Coords{iX, 'SizeY'};
        Yolo_Coords{iX, 'W'} = Yolo_Coords{iX, 'W'} / Yolo_Coords{iX, 'SizeX'};
        Yolo_Coords{iX, 'H'} = Yolo_Coords{iX, 'H'} / Yolo_Coords{iX, 'SizeY'};
    end
%% 
% This segment of the code verifies if valid label coords exist, then creates 
% a new .txt if there isn't one already and prints the yolo format.

    %For loop to write the .txt for each image 
    for iK = 1 : height(Yolo_Coords)
        %Here we change the filename of each image to .txt
        currTxtName = Yolo_Coords.name{iK}(1:end-4) + ".txt";
        
        %First we verify the image has valid label coords
        if Yolo_Coords{iK, 'H'} ~= 0
        
        %Open a new file
        TrainDataOut = fopen(currTxtName, 'a')
        %Print the converted coordinates to  the file
        fprintf(TrainDataOut, '%d\t', (cont-1));
        fprintf(TrainDataOut, '%.6f\t', Yolo_Coords{iK,'X'});
        fprintf(TrainDataOut, '%.6f\t', Yolo_Coords{iK,'Y'});
        fprintf(TrainDataOut, '%.6f\t', Yolo_Coords{iK,'W'});
        fprintf(TrainDataOut, '%.6f\t', Yolo_Coords{iK,'H'});
        fprintf(TrainDataOut, '\n');
        %Close the file
        fclose(TrainDataOut);
            
        end    
    end
end