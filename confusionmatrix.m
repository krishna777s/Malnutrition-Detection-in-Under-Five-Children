clc;
clear;
load Net
imds = imageDatastore('training','IncludeSubfolders',true,...
       'LabelSource','foldernames');

disp(imds);
%Step 2
[traindata,tesdata] = splitEachLabel(imds,0.7);
tesdata.ReadFcn = @readFunctionTrain;
[labels,err_test] = classify(mynet, tesdata, 'MiniBatchSize',70);
confusionchart(tesdata.Labels,labels);
figure;
plotconfusion(tesdata.Labels,labels)
 
