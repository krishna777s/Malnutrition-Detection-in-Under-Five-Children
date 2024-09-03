function varargout = alexgui(varargin)
% ALEXGUI MATLAB code for alexgui.fig
%      ALEXGUI, by itself, creates a new ALEXGUI or raises the existing
%      singleton*.
%
%      H = ALEXGUI returns the handle to a new ALEXGUI or the handle to
%      the existing singleton*.
%
%      ALEXGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ALEXGUI.M with the given input arguments.
%
%      ALEXGUI('Property','Value',...) creates a new ALEXGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before alexgui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to alexgui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help alexgui

% Last Modified by GUIDE v2.5 11-Jun-2021 21:41:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @alexgui_OpeningFcn, ...
                   'gui_OutputFcn',  @alexgui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before alexgui is made visible.
function alexgui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to alexgui (see VARARGIN)

% Choose default command line output for alexgui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes alexgui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = alexgui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Browse.
function Browse_Callback(hObject, eventdata, handles)
% hObject    handle to Browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile('*.*', 'Pick a MATLAB code file');
if isequal(filename,0) || isequal(pathname,0)
   warndlg('User pressed cancel')
else
    filename=strcat(pathname,filename);
    im=imread(filename);
    axes(handles.axes1);
    imshow(im);
    handles.im = im;
end
% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in Train.
function Train_Callback(hObject, eventdata, handles)
% hObject    handle to Train (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
allImages = imageDatastore('TrainingDataset', 'IncludeSubfolders', true,...
    'LabelSource', 'foldernames');
[trainingImages, testImages] = splitEachLabel(allImages, 0.98, 'randomize');
alex = alexnet; 
layers = alex.Layers ;
lr=0.001;
layers(23) = fullyConnectedLayer(2); % change this based on # of classes
layers(25) = classificationLayer;
maxEpochs=100;
miniBatchSize = 128;
opts = trainingOptions('sgdm', ...
    'LearnRateSchedule', 'none',...
    'InitialLearnRate', lr,... 
    'MaxEpochs', maxEpochs, ...
     'MiniBatchSize', miniBatchSize,...
    'Plots','training-progress');
trainingImages.ReadFcn = @readFunctionTrain;
myNet = trainNetwork(trainingImages, layers, opts);

save myNet myNet


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load('mynet');
im=handles.im;
% axes(handles.axes2);
  picture=im;
    picture = imresize(picture,[227,227]);  % Resize the picture
%     axes(handles.axes2);
    imshow(picture);
    label = classify(myNet, picture);   
    label=char(label);
    % classify the picture
    set(handles.edit1,'String',label);
   
%        str2double(get(hObject,'String')) returns contents of edit1 as a double



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end