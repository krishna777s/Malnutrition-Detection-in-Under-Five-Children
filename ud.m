clc;
clear all;
close all;
digitDatasetPath = fullfile('C:\Users\Sandeep\Desktop\Main Project\training');
imds = imageDatastore(digitDatasetPath, ...
    'IncludeSubfolders',true,'LabelSource',...
    'foldernames');
perm = randperm(200,20);
for i = 1:20
subplot(4,5,i);
imshow(imds.Files{perm(i)});
end
labelCount = countEachLabel(imds);
size(labelCount)
img = readimage(imds,3);
size(img)
[imdsTrain,imdsValidation]=splitEachLabel(imds,.6,.4,'randomize');
imdsTrain.ReadFcn = @readFunctionTrain;
imdsValidation.ReadFcn = @readFunctionTrain;
layers = [
    imageInputLayer([275 275 3])
    convolution2dLayer(3,4,'Padding','same')
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer(2,'Stride',2)
    convolution2dLayer(3,4,'Padding','same')
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer(2,'Stride',2)
    convolution2dLayer(3,4,'Padding','same')
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer(2,'Stride',2)
    fullyConnectedLayer(275,"Name","fc1")
     fullyConnectedLayer(275,"Name","fc2")
      fullyConnectedLayer(2,"Name","fc3")
    softmaxLayer
    classificationLayer];
options = trainingOptions('sgdm', ...
    'InitialLearnRate',0.001, ...
    'MiniBatchSize',70, ...
    'MaxEpochs',80, ...
    'Shuffle','every-epoch', ...
    'ValidationData',imdsValidation, ...
    'ValidationFrequency',5, ...
    'Verbose',false, ...
    'Plots','training-progress');
net = trainNetwork(imdsTrain,layers,options);
YPred = classify(net,imdsValidation);
YValidation = imdsValidation.Labels;
accuracy = sum(YPred == YValidation)/numel(YValidation);

save net net