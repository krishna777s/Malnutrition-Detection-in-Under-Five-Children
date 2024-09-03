clc;
clear all;
close all;
digitDatasetPath = fullfile('C:\Users\Sandeep\Desktop\Main Project\training');
imds = imageDatastore(digitDatasetPath,'IncludeSubfolders',true,'LabelSource','foldernames','FileExtensions','.jpg');
numberOfImages=length(imds.Files);
for k = 1:numberOfImages
    inputFileName=imds.Files{k};
    rgbImage=imread(inputFileName);
    [rows,columns,numberOfColorChannels]=size(rgbImage);
    if numberOfColorChannels ==3
        grayImage = rgb2gray(rgbImage);
        imwrite(grayImage,inputFileName);
    end
end
[imdsTrain,imdsValidation]=splitEachLabel(imds,.7,.3,'randomize');
imageSize = [275 275 1];
imageAugmenter = imageDataAugmenter( ...
    'RandRotation',[-20,20], ...
    'RandXTranslation',[-30 30], ...
    'RandYTranslation',[-30 30]);
augimdsTrain = augmentedImageDatastore(imageSize,imdsTrain,'DataAugmentation',imageAugmenter);
augimdsValidation = augmentedImageDatastore(imageSize,imdsValidation,'DataAugmentation',imageAugmenter);
layers = [
    imageInputLayer([275 275 1])
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
    'MaxEpochs',80, ...
    'MiniBatchSize',70, ...
    'Shuffle','every-epoch', ...
    'ValidationData',augimdsValidation, ...
    'ValidationFrequency',5, ...
    'Verbose',false, ...
    'Plots','training-progress');

Net = trainNetwork(augimdsTrain,layers,options);
save Net Net