%% *LABEL CREATION*

CurrFPath = matlab.desktop.editor.getActiveFilename;
CurrFPath = CurrFPath(1:end-23);
cd(CurrFPath)
%% 
% This is the part where you choose which detector to use to create labels

%Name of detector to load
detectorName = 'police_detector.mat'
%Name of labels to load if preexistent -- Important
entryLabelsName = "gangster_det_labels.mat"
%Name of label to detect
labelName = 'police'
%Name of label definition to load
labelDefName = 'police_label_def.mat'
%Name of exit labels (detector labels)
exitLabelsName = "polgang_det_labels.mat";
%% 
% Loads the detector and label definitions, this code assumes they have the 
% same set of images to work with

load(detectorName);
labelDef = load(labelDefName);
%% 
% This segment verifies if the entry labels to load exist, then adds them in 
% the same table

bEntryLabelExist = isfile(entryLabelsName);

if (bEntryLabelExist)  
    load (entryLabelsName);
    labelDef.labelDefs = [det_labels.LabelDefinitions ; labelDef.labelDefs]
    
end
%%
%This segment of the code focuses on creating the labels for the validation
%images

% Specify the folder where the images are.
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
LabelCoords = table('Size', [height(FilesTable), 1], 'VariableTypes', {'cell'}, 'VariableNames', {labelName});
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
% This segment of the code adds the tables of the labels together if multiple 
% exist

if (bEntryLabelExist)
    LabelCoords = [LabelCoords det_labels.LabelData]
end
%% 
% *Creation of new labels from the detector*

 gtSource = groundTruthDataSource(FilesTable.name);
 
     det_labels = groundTruth(gtSource, labelDef.labelDefs, LabelCoords);
 
 cd ../
 
 save(exitLabelsName, 'det_labels')