%%
% 
function varargout = main(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @main_OpeningFcn, ...
    'gui_OutputFcn',  @main_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end
if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
    %% 
end
% End initialization code - DO NOT EDIT
% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, ~, handles, varargin)
handles.output = hObject;
handles.clip = 0;
handles.S =0;
set(handles.axes1,'YTick',[]);
set(handles.axes1,'XTick',[]);
axes(handles.axes1);
imshow('logo.jpg');
axes(handles.axes2);
imshow('background.jpg');
for i=1:5
    handles.box{i} = 0;
end
guidata(hObject, handles);


function varargout = main_OutputFcn(~, ~, handles)
varargout{1} = handles.output;
function nclose( ~, ~)
disp(close);

function figure1_CreateFcn(~, ~, ~)

% --- Executes during object creation, after setting all properties.
function tabs_CreateFcn(hObject, eventdata, handles)
% --- Executes on button press in NewSuspectpushbutton.
% --- Executes on button press in NewCasepushbutton.

function NewCasepushbutton_Callback(hObject, eventdata, handles)
boxvisibilty(handles);
f=handles.tabs;
handles.box{1} = uiextras.BoxPanel( 'Parent',f, 'Title', 'Add New Evidance', 'Padding', 5 );
handles.box{1}.FontSize = 12;
handles.box{1}.FontWeight = 'bold';
guidata(hObject, handles);
new_case_build(handles.box{1});
set(handles.box{1}, 'Visible', 'on' );

% --- Executes on button press in NewEvidancepushbutton.
function NewEvidancepushbutton_Callback(hObject, eventdata, handles)
boxvisibilty(handles);
f=handles.tabs;
handles.box{2} = uiextras.BoxPanel( 'Parent',f, 'Title', 'Add New Evidance', 'Padding', 5 );
handles.box{2}.FontSize = 12;
handles.box{2}.FontWeight = 'bold';
guidata(hObject, handles);
new_evidence_build(handles.box{2});
set(handles.box{2}, 'Visible', 'on' );


function NewSuspectpushbutton_Callback(hObject, eventdata, handles)
boxvisibilty(handles);
f=handles.tabs;
handles.box{3} = uiextras.BoxPanel( 'Parent', f, 'Title', 'Add New Suspect', 'Padding', 5 );
handles.box{3}.FontSize = 12;
handles.box{3}.FontWeight = 'bold';
guidata(hObject, handles);
new_suspect_build(handles.box{3});
set(handles.box{3}, 'Visible', 'on' );

% --- Executes on button press in Verifypushbutton.
function Verifypushbutton_Callback(hObject, eventdata, handles)
boxvisibilty(handles);
f=handles.tabs;
handles.box{4} = uiextras.BoxPanel( 'Parent',f, 'Title', 'Vefication', 'Padding', 5 );
handles.box{4}.FontSize = 12;
handles.box{4}.FontWeight = 'bold';
guidata(hObject, handles);
verify_build(handles.box{4});
set(handles.box{4}, 'Visible', 'on' );

% --- Executes on button press in AudioAnalyserpushbutton.
function AudioAnalyserpushbutton_Callback(hObject, eventdata, handles)
boxvisibilty(handles);
handles.box{5} = uiextras.BoxPanel( 'Parent', handles.tabs, 'Title', 'Audio Analyser', 'Padding', 5 );
handles.box{5}.FontSize = 12;
handles.box{5}.FontWeight = 'bold';
guidata(hObject, handles);
AudioAnalysernew;
set(handles.box{5}, 'Visible', 'on' );

function boxvisibilty(handles)
for i=1:5
    set(handles.box{i}, 'Visible', 'off' );
end

% --- Executes during object creation, after setting all properties.
function buttons_CreateFcn(hObject, eventdata, handles)

% --- Executes on button press in Homepushbutton.
function Homepushbutton_Callback(hObject, eventdata, handles)
boxvisibilty(handles);
axes(handles.axes2);
imshow('background.jpg');
guidata(hObject, handles);

% --- Executes on button press in Graphspushbutton.
function Graphspushbutton_Callback(hObject, eventdata, handles)
boxvisibilty(handles);
axes(handles.axes2);
imshow('background.jpg');
graph1;
guidata(hObject, handles);


% --- Executes on button press in Helppushbutton.
function Helppushbutton_Callback(hObject, eventdata, handles)
