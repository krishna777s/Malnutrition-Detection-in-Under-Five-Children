clc;
clear;
load Net
imds = imageDatastore('training','IncludeSubfolders',true,...
       'LabelSource','foldernames');

disp(imds);
numberOfImages=length(imds.Files);
% disp(imds)
% figure;
% perm = randperm(3064,20);
for k = 1:numberOfImages
    inputFileName=imds.Files{k};
    rgbImage=imread(inputFileName);
    [rows,columns,numberOfColorChannels]=size(rgbImage);
    if numberOfColorChannels ==3
        grayImage = rgb2gray(rgbImage);
        imwrite(grayImage,inputFileName);
    end
end

%Step 2
[imdsTrain,imdsValidation]=splitEachLabel(imds,.7,.3,'randomize');
imageSize = [275 275 1];
augimdsValidation = augmentedImageDatastore(imageSize,imdsValidation);
[YPred,scores] = classify(Net,augimdsValidation);
idx = randperm(numel(imdsValidation.Files),4);
figure
for i = 1:4
    subplot(2,2,i)
    I = readimage(imdsValidation,idx(i));
    imshow(I)
    label = YPred(idx(i));
    title(string(label));
end
YValidation = imdsValidation.Labels;
accuracy = mean(YPred == YValidation);
disp(accuracy);
confusionchart(imdsValidation.Labels,labels);
figure;