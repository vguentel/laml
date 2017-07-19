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
global heightdata
global refdata

%get filename and Path via pop-up menu
[filename,pathname] = uigetfile();
['File Choosen: ' pathname filename]
%get files contained in the path
files = strsplit(ls(pathname));

%get indexes of other files
dattmp = strfind(files,'.dat');
tfwtmp = strfind(files,'.tfw');
datindex = 0;
tfwindex = 0;
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
    'Found Heightdata and WorldFile'
    'Reading Image'
    image = imread([pathname filename]);
    'Reading Heightdata'
    readHeightData([pathname files{datindex}]);
    heightdata(:,1:10)
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
% hObject    handle to sldBrightness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function readHeightData(url)
global heightdata
fid = fopen(url);

%get linecount
linecount = 0;
while ~feof(fid)
    line = fgetl(fid);
    linecount = linecount+1;
end

fclose(fid);
fopen(url);
%init heightdata
heightdata = NaN(3,linecount);

for i = 1:1:linecount
    line = strsplit(fgetl(fid));
    heightdata(1,i) = str2num(line(2));
    heightdata(2,i) = str2num(line(3));
    heightdata(3,1) = str2num(line(4));
end
fclose(fid);


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
global heightdata

brightness = 1.0;
toggle = 1.0;

%Things to talk about:
%1 Everything is a hack; Do we even give a shit at this point?
%2 File chooser might be wrong
%3 Save BW image or create every time
%4 World file usage
%5 Remove Gui text Field?
%6 autoset filetype in filegui
%7 labelkram?
