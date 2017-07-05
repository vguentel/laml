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

% Last Modified by GUIDE v2.5 05-Jul-2017 11:27:52

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
% End initialization code - DO NOT EDIT


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

% UIWAIT makes hausuebung wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = hausuebung_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function txtImgUrl_Callback(hObject, eventdata, handles)
% hObject    handle to txtImgUrl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtImgUrl as text
%        str2double(get(hObject,'String')) returns contents of txtImgUrl as a double


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
global image

[filename,pathname] = uigetfile();
image = imread([pathname filename]);
display()


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
% hObject    handle to sldBrightness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function display()
global image 
global brightness
global toggle
tmpimg = 0;

if toggle == 0.0
    tmpimg = image./brightness;
else
    tmpimg = rgb2gray(image);
    tmpimg = tmpimg./brightness;
end

imshow(tmpimg)

function init()
global image
global brightness
global toggle

brightness = 1
toggle = 1.0
