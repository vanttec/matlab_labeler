%% *LABEL CREATION*

CurrFPath = matlab.desktop.editor.getActiveFilename;
CurrFPath = CurrFPath(1:end-23);
cd(CurrFPath)
%% 
% This is the part where you choose which detector to use to create labels

%Name of detector to load
detectorName = 'gangster_detector.mat'
%Name of label
labelName = 'gangster'
%Name of label definition to load
labelDefName = 'gangster_label_def.mat'
%Name of exit labels (detector labels)
exitLabelsName = "gangster_det_labels.mat";
%% 
% Loads the detector and label definitions

load(detectorName);
labelDef = load(labelDefName);
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
LabelCoords = table('Size', [height(FilesTable), 1], 'VariableTypes', {'cell'}, 'VariableNames', {'gangster'});
 for k=1:height(FilesTable)
    img = imread(char(FilesTable.(1)(k))); 
    
    [bboxes,scores] = detect(detector,img, 'SelectStrongest',true);
    
    NoROI = isempty(bboxes);

%Display the detection results and insert the bounding boxes for objects into the image.

for i = 1:length(scores)
   annotation = sprintf('Confidence = %.1f',scores(i));
   img = insertObjectAnnotation(img,'rectangle',bboxes(i,:),annotation);
end

figure
imshow(img)
    
    if NoROI == false 
        LabelCoords.(labelName)(k) = {bboxes};
    end
 end
%% 
% *Creation of new labels from the detector*

 gtSource = groundTruthDataSource(FilesTable.name);
 det_labels = groundTruth(gtSource, labelDef.labelDefs, LabelCoords);
 cd ../
 
 save(exitLabelsName, 'det_labels')