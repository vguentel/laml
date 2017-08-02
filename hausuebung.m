function varargout = hausuebung(varargin)
% HAUSUEBUNG MATLAB code for hausuebung.fig
%      HAUSUEBUNG, by itself, creates a new HAUSUEBUNG or raises the existing
%      singleton*.
%
%      H = HAUSUEBUNG returns the handle to a new HAUSUEBUNG or the handle to
%      the existing singleton*.
%
%      HAUSUEBUNG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HAUSUEBUNG.M with the given input arguments.
%
%      HAUSUEBUNG('Property','Value',...) creates a new HAUSUEBUNG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before hausuebung_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to hausuebung_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help hausuebung

% Last Modified by GUIDE v2.5 31-Jul-2017 18:49:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @hausuebung_OpeningFcn, ...
                   'gui_OutputFcn',  @hausuebung_OutputFcn, ...
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

% --- Executes just before hausuebung is made visible.
function hausuebung_OpeningFcn(hObject, eventdata, handles, varargin)
init()
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to hausuebung (see VARARGIN)

% Choose default command line output for hausuebung
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = hausuebung_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function txtImgUrl_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function txtImgUrl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtImgUrl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnBrowse.
function btnBrowse_Callback(hObject, eventdata, handles)
global original
global datadim

%get filename and Path via pop-up menu
[filename,pathname] = uigetfile('*.*');
disp(['File Choosen: ' pathname filename])
%get files contained in the path
files = strsplit(ls(pathname));

%get indexes of other files
dattmp = strfind(files,'.dat');
tfwtmp = strfind(files,'.tfw');
datindex = 0;
tfwindex = 0;

%find files
for i = 1:1:length(files)
    if isempty(dattmp{i}) == 0
        datindex = i;
    end
    if isempty(tfwtmp{i}) == 0
        tfwindex = i;
    end
end

%Check if the files have been found
if datindex == 0 || tfwindex == 0
    errordlg('File not Found')
else
    disp('Found Heightdata and WorldFile')
    disp('Reading Image')
    disp('Reading Heightdata')
    
    loadHeightData(load([pathname files{datindex}]));
    
    imageFull = imread([pathname filename]);
    sampleDim = floor(size(imageFull)/datadim);
    
    original = imageFull(1:sampleDim:end, 1:sampleDim:end, :);%subsample 
    original = original(1:datadim,1:datadim,:);%cut to size
    display()
end

% --- Executes on button press in btnColor.
function btnColor_Callback(hObject, eventdata, handles)
global toggle
toggle = get(hObject, 'Value');
display()

% --- Executes on slider movement.
function sldBrightness_Callback(hObject, eventdata, handles)
global brightness
brightness = get(hObject, 'Value');
display()

% --- Executes during object creation, after setting all properties.
function sldBrightness_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function axesImage_CreateFcn(hObject, eventdata, handles)
%Enable 3D rotation
set(rotate3d, 'Enable', 'on');

% --- Executes on button press in btnSave.
function btnSave_Callback(hObject, eventdata, handles)
disp('saving image')
frame = getframe;
[filename,pathname] = uiputfile();
imwrite(frame.cdata,[pathname filename]);
disp(['image saved to' pathname filename])

function loadHeightData(data)
global heightdata
global datadim
datadim = sqrt(size(data));
datadim = datadim(1);
heightdata = zeros(datadim);
for i = 1:datadim
    for j = 1:datadim
        heightdata(i,j) = data(((i-1) * datadim) + j,3);
    end
end

function display()
disp('displaying')
global image 
global brightness
global toggle
global heightdata
global original

if toggle == 0.0
    image = original./brightness;
    surf(heightdata, image, 'EdgeColor', 'none')
    colormap(hsv);
    disp('hsv')
else
    image = rgb2gray(original);
    image = image./brightness;
    surf(heightdata, image, 'EdgeColor', 'none')
    colormap(gray);
    disp('gray')
end

function init()
global image
global brightness
global toggle
global heightdata
global original
global datadim

brightness = 1.0;
toggle = 0.0;


