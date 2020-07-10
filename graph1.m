function varargout = graph1(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @graph1_OpeningFcn, ...
                   'gui_OutputFcn',  @graph1_OutputFcn, ...
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


% --- Executes just before graph1 is made visible.
function graph1_OpeningFcn(hObject, eventdata, handles, varargin)
set(handles.axes1,'YTick',[]);
set(handles.axes1,'XTick',[]);
set(handles.axes2,'YTick',[]);
set(handles.axes2,'XTick',[]);
handles.output = hObject;
handles.evidence_filename = '';
handles.evidence_path = '';
handles.suspect_filename = '';
handles.suspect_path = '';
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes graph1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = graph1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in Evidance_popupmenu.
function Evidance_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to Evidance_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Evidance_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Evidance_popupmenu
[filename, pathname] = uigetfile( ...
    {'*.wav', 'All WAV-Files (*.wav)'; ...
        '*.*','All Files (*.*)'}, ...
    'Select Evidance Clip');
% If "Cancel" is selected then return
if isequal([filename,pathname],[0,0])
    return
    % Otherwise construct the fullfilename and Check and load the file.
else
    File = fullfile(pathname,filename);
    % if the MAT-file is not valid, do not save the name
    if exist(File,'file') == 2
    %[evidance_clip evidance_fs] = audioread(File);
    %handles.evi_clip = evidance_clip;
    %handles.fs = evidance_fs;
    [a b] = fileparts(filename);
    handles.evidence_filename = b;
    handles.evidence_path = File;
    end
    set(handles.Evidance_popupmenu, 'String', [pathname,filename]);
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Evidance_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Evidance_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Suspect_popupmenu.
function Suspect_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to Suspect_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Suspect_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Suspect_popupmenu
[filename, pathname] = uigetfile( ...
    {'*.wav', 'All WAV-Files (*.wav)'; ...
        '*.*','All Files (*.*)'}, ...
    'Select Suspect Clip');
% If "Cancel" is selected then return
if isequal([filename,pathname],[0,0])
    return
    % Otherwise construct the fullfilename and Check and load the file.
else
    File = fullfile(pathname,filename);
    % if the MAT-file is not valid, do not save the name
    if exist(File,'file') == 2
    [a b] = fileparts(filename);
    handles.suspect_filename = b;
    handles.suspect_path = File;
    end
    set(handles.Suspect_popupmenu, 'String', File);
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Suspect_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Suspect_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in mfcchistrogramcheckbox.
function mfcchistrogramcheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to mfcchistrogramcheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of mfcchistrogramcheckbox
try
select = get(hObject,'Value');
dim = get(handles.dimpopupmenu, 'Value');
if (dim==1)
    dimensin = 13;
elseif (dim==2)
    dimensin = 2;
elseif (dim==3)
    dimensin = 4;
elseif (dim==4)
    dimensin = 8;
elseif (dim==5)
    dimensin = 20;
end
if (select==1)
    path2 = get(handles.Suspect_popupmenu, 'String');
    path1 = get(handles.Evidance_popupmenu, 'String');
    msgbox('Processing....Please Wait......');
    [s_evidence, fs_evidence] = loadfile(path1);
    X_evidence = Utils.mfcc(s_evidence, fs_evidence,dimensin)';
    
    [s_suspect , fs_suspect] = loadfile(path2);
    X_suspect = Utils.mfcc(s_suspect, fs_suspect, dimensin)';
    
    axes(handles.axes1);
    hist(X_evidence(:),100);
    axes(handles.axes2);
    hist(X_suspect(:),100);
else
    clear all;
end
catch err
    msgbox('Enter relevant fields/out of memmory','Error','error');
end


function [s,fs] = loadfile(File)
if exist(File,'file') == 2
    [s fs] = audioread(File);
end


% --- Executes on selection change in dimpopupmenu.
function dimpopupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to dimpopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns dimpopupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from dimpopupmenu


% --- Executes during object creation, after setting all properties.
function dimpopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dimpopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
