clc;
clear;
allImages = imageDatastore('training', 'IncludeSubfolders', true,...
     'LabelSource','foldernames');
[trainingImages, testImages] = splitEachLabel(allImages, 0.8, 'randomize');
alex = alexnet; 
layers = alex.Layers ;
lr=0.001;
layers(23) = fullyConnectedLayer(2); % change this based on # of classes
layers(25) = classificationLayer;
maxEpochs=80;
miniBatchSize = 100;
opts = trainingOptions('sgdm', ...
    'LearnRateSchedule', 'none',...
    'InitialLearnRate', lr,... 
    'MaxEpochs', maxEpochs, ...
     'MiniBatchSize', miniBatchSize,...
     'ValidationData',testImages, ...
     'ValidationFrequency',5,...
    'Plots','training-progress');
trainingImages.ReadFcn = @readFunctionTrain;
testImages.ReadFcn = @readFunctionTrain;
myNet = trainNetwork(trainingImages, layers, opts);
YPred = classify(myNet,testImages);
YValidation = testImages.Labels;
accuracy = sum(YPred == YValidation)/numel(YValidation);


save myNet myNet

