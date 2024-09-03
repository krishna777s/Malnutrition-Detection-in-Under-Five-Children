load Net
[filename,pathname]=uigetfile('*.*','Pick a Input Image');
filename=strcat(pathname,filename);
im=imread(filename);
im=imresize(im,[275,275]);
label=char(classify(Net,im));
figure;
imshow(im);
title(label);
