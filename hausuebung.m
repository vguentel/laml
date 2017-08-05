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

% Last Modified by GUIDE v2.5 05-Aug-2017 17:24:52

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

%init variables for logical check later
imageFile = 0;
imagePath = 0;
datFile  = 0;
datPath = 0;
tfwFile = 0;
tfwPath = 0;

%get Image via Pop-Up
[imageFile, imagePath] = uigetfile('*.tif', 'Choose Image');
disp(['Image file Choosen: ' imagePath imageFile])

%get Heightdata via Pop-Up
[datFile, datPath] = uigetfile('*.dat', 'Choose Heightdata');
disp(['Heightdata file Choosen: ' datPath datFile])

%get Worldfile via Pop-Up
[tfwFile, tfwPath] = uigetfile('*.tfw', 'Choose Worldfile');
disp(['Worldfile Choosen: ' tfwPath tfwFile])

%Check if the files have been found
if ~logical(datFile(1)) || ~logical(tfwFile(1)) || ~logical(imageFile(1))
    errordlg('File not Found')
else
    disp('All Files Found')
    
    disp('Reading Heightdata')
    loadHeightData(load([datPath datFile]));
    
    disp('Reading Image')
    imageFull = imread([imagePath imageFile]);
    sampleDim = floor(size(imageFull)/datadim);%calculate stepsize for subsample
    sampleDim = sampleDim(1);
    
    original = imageFull(1:sampleDim:end, 1:sampleDim:end, :);%subsample 
    original = original(1:datadim,1:datadim,:);%cut to size
    
    
    display()
end

% --- Executes on button press in btnColor.
% changes Value of global var toggle, which in turn changes the displayes
% colormap
function btnColor_Callback(hObject, eventdata, handles)
global toggle
toggle = get(hObject, 'Value');
if toggle == 0.0
    disp('Colormode: HSV')
else
    disp('Colormode: B/W')
end
display()

% --- Executes on slider movement.
% changes value of global var brightness, which in turn changes the brightness
% of the plot
function sldBrightness_Callback(hObject, eventdata, handles)
global brightness
brightness = get(hObject, 'Value');
disp(['Brightness: ' num2str(brightness)])
display()

% --- Executes during object creation, after setting all properties.
function sldBrightness_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function axesImage_CreateFcn(hObject, eventdata, handles)
set(rotate3d, 'Enable', 'on');%Enable 3D rotation

% --- Executes on button press in btnSave.
function btnSave_Callback(hObject, eventdata, handles)
disp('saving image')
frame = getframe;%Get current view of Plot
[filename,pathname] = uiputfile(); %get URL to save the File to
imwrite(frame.cdata,[pathname filename]);
disp(['Image saved to: ' pathname filename])

%take heightdata and Format them into matrix; increase resolution
%by upscalefactor
function loadHeightData(data)
global heightdata
global datadim

upscalefactor = 2;

%Build Matrix
datadim = sqrt(size(data));
datadim = datadim(1);
heightdata = zeros(datadim);
for i = 1:datadim
    for j = 1:datadim
        heightdata(i,j) = data(((i-1) * datadim) +j,3)/10;
    end
end

%Upscale MAtrix by interpolating
heightdata = interp2(heightdata, upscalefactor);
datadim = size(heightdata);
datadim = datadim(1);


%Displays data in Axis incl. Colormode and Brightness
function display()
global brightness
global toggle
global heightdata
global original
global datadim

if toggle == 0.0 %HSV
    image = original./brightness;%modify Brightness
    surf(heightdata, image, 'EdgeColor', 'none')
    axis([0 datadim 0 datadim 0 datadim/4]); %Limit axis; Z-axis/4 for better viewing 
    colormap default;
else %BW
    image = rgb2gray(original);%Change image to BW
    image = image./brightness;%Modify Brightness
    surf(heightdata, image, 'EdgeColor', 'none')
    axis([0 datadim 0 datadim 0 datadim/4]); %Limit axis; Z-axis/4 for better viewing 
    colormap gray;
end

%Init Function 
function init()
global brightness
global toggle
global heightdata
global original
global datadim

brightness = 1.0;
toggle = 0.0;
