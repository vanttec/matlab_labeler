%% 
% This segment sets a common path for the code to work in any computer

CurrFPath = matlab.desktop.editor.getActiveFilename;
CurrFPath = CurrFPath(1:end-18);
cd(CurrFPath)

%%
%Name of label
labelName = 'gangster'

%Labels to train with
labels = 'gangster_labels.mat'

%Name of the detector
detectorName = 'gangster_detector.mat'

%% Detector Training
% First we load the label to train with

load(labels)
%% 
% This segment extracts the specific label we want and also filters images without 
% labels

%Create training data from ground truth
    %In case of multiple labels in the object:
gangster_truth = selectLabels(gTruth,labelName)
%extracts a subset of ground truth dataset
training_data = objectDetectorTrainingData(gangster_truth)
summary(training_data)
%train de ACF detector
detector = trainACFObjectDetector(training_data,'NumStages', 10)
save(detectorName,'detector');
%% 
% Test del detector

cd val_data/

img = imread('Gate25_B.jpg');

[bboxes,scores] = detect(detector,img);

%Display the detection results and insert the bounding boxes for objects into the image.

for i = 1:length(scores)
   annotation = sprintf('Confidence = %.1f',scores(i));
   img = insertObjectAnnotation(img,'rectangle',bboxes(i,:),annotation);
end

figure
imshow(img)

cd ../