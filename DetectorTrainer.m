%https://www.youtube.com/watch?v=UnXDQmjYvDk&list=PLn8PRpmsu08oLufaYWEvcuez8Rq7q4O7D&index=32

%Sets program path to the parent of the current file
%This is necessary to make load work in any computer
CurrFPath = matlab.desktop.editor.getActiveFilename;
CurrFPath = CurrFPath(1:end-20);
cd(CurrFPath)
%% Detector Training
% Gangster

load('gangster_labels.mat')
%%
%Create training data from ground truth
    %In case of multiple labels in the object:
gangster_truth = selectLabels(gTruth,'gangster')
%extracts a subset of ground truth dataset
training_data = objectDetectorTrainingData(gangster_truth)
summary(training_data)
%train de ACF detector
detector = trainACFObjectDetector(training_data,'NumStages',5)
save('gangster_detector.mat','detector');
%% 
% Test de gangster detector

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
%% 
% Police

load('police_labels.mat')
%Create training data from ground truth
    %In case of multiple labels in the object:
police_truth = selectLabels(gTruth,'police')
%%
%extracts a subset of ground truth dataset
training_data = objectDetectorTrainingData(police_truth)
summary(training_data)
%train de ACF detector
detector = trainACFObjectDetector(training_data,'NumStages',5)
save('police_detector.mat','detector');
%% 
% Test de police detector

cd val_data/

img = imread('Gate25_B.jpg');

[bboxes,scores] = detect(detector,img, 'SelectStrongest',true);

%Display the detection results and insert the bounding boxes for objects into the image.

for i = 1:length(scores)
   annotation = sprintf('Confidence = %.1f',scores(i));
   img = insertObjectAnnotation(img,'rectangle',bboxes(i,:),annotation);
end

figure
imshow(img)

cd ../