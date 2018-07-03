% -----------------------------------------------------------
% -----------------------------------------------------------
% -----------------------------------------------------------

function varargout = Audio_Plots(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Audio_Plots_OpeningFcn, ...
                   'gui_OutputFcn',  @Audio_Plots_OutputFcn, ...
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


% -----------------------------------------------------------
% -----------------------------------------------------------
% -----------------------------------------------------------

% --- Executes just before Audio_Plots is made visible.
function Audio_Plots_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Audio_Plots (see VARARGIN)

% Choose default command line output for Audio_Plots
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Audio_Plots wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% -----------------------------------------------------------
% -----------------------------------------------------------
% -----------------------------------------------------------


% --- Outputs from this function are returned to the command line.
function varargout = Audio_Plots_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% -----------------------------------------------------------
% -----------------------------------------------------------
% -----------------------------------------------------------


% --- Executes on button press in audioPlot.
function audioPlot_Callback(hObject, eventdata, handles)

cla(handles.axes1)

%-- Prompt User in order to get full path and name of file
[fileName, pathName] = uigetfile({'*.wav';'*.mp3'}, 'Select Audio File');
fullFName = strcat(pathName, fileName);

% -- Set Duration
info = audioinfo(fullFName);
duration = floor(info.Duration);
set(handles.edit2, 'string', duration);

% -- Doing the Real Calculation
[amplitude,fs] = audioread(fullFName);
amplitude = amplitude(:,1);

dt = 1/fs;
t = 0:dt:(length(amplitude)*dt)-dt;

% -- Plotting
plot(handles.axes1,t,amplitude);
xlabel(handles.axes1, 'Time (seconds)');
ylabel(handles.axes1, 'Amplitude');

% -- To be used by FFT
handles.amplitude = amplitude;
handles.fs = fs;

% -- Make 'plotFFT' available only when an audio file has been uploaded
set(handles.pushbutton2, 'Enable', 'on')
cla(handles.axes2)

guidata(hObject,handles);
% -----------------------------------------------------------
% -----------------------------------------------------------
% -----------------------------------------------------------


% --- Executes on button press in plotFFT.
function plotFFT_Callback(hObject, eventdata, handles)

amplitude = handles.amplitude;
p = 1024;
Y = fft(amplitude,p);

fs = handles.fs;
f = fs/2*linspace(0,1,p/2+1);

plot(f,abs(Y(1:p/2+1)));
xlabel(handles.axes2,'Frequency');
ylabel(handles.axes2,'Imaginary');


% -----------------------------------------------------------
% -----------------------------------------------------------
% -----------------------------------------------------------


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)

% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.


if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
