function varargout = new_evidence(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @new_evidence_OpeningFcn, ...
                   'gui_OutputFcn',  @new_evidence_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before new_evidence is made visible.
function new_evidence_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
handles.evidence_clip = '';
handles.fs = '';
handles.path = '';
handles.filename = '';% Update handles structure
set(handles.evidanceclipedit, 'Enable', 'off' );
set(handles.remarks, 'Enable', 'off' );
set(handles.Recording_date, 'Enable', 'off' );
set(handles.save, 'Enable', 'off' );

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes new_evidence wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = new_evidence_OutputFcn(hObject, eventdata, handles)

varargout{1} = handles.output;


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)

function figure1_CloseRequestFcn(hObject, eventdata, handles)

delete(hObject);


% --- Executes during object creation, after setting all properties.
function text1_CreateFcn(hObject, eventdata, handles)


function Name_Callback(hObject, eventdata, handles)

function Name_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ID_Callback(hObject, eventdata, handles)

function ID_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Evidence.
function Evidence_Callback(hObject, eventdata, handles)

function Evidence_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Recording_date.
function Recording_date_Callback(hObject, eventdata, handles)
uicalendar('SelectionType', 1, 'DestinationUI',handles.Recording_date);

% --- Executes during object creation, after setting all properties.
function Recording_date_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function remarks_Callback(hObject, eventdata, handles)

function remarks_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)

ID = get(handles.ID,'String');
recording_date = get(handles.Recording_date,'String');
remarks = get(handles.remarks,'String');
clip_length = length(handles.evidence_clip)/handles.fs;

if ((strcmp(ID,'') == 0) && (strcmp(handles.path,'') == 0) )
M = HashStore();
result= M.add_evidence(ID,remarks,recording_date,handles.evidence_clip,handles.fs,handles.path,handles.filename,clip_length);
msgbox(result,'Saving new evidance');

path = 'C:\Forensic_Audio_workspace\cases';
pathofcase  = [path, '\', ID,'\Evidence'];
if(exist(pathofcase,'dir'))
    display('folder found');
    msgbox('Case Found');
else
    mkdir(pathofcase);
end

audiowrite([pathofcase,'\',handles.filename,'.wav'],handles.evidence_clip,handles.fs);


else
     errordlg('Enter * marked fields','File Error');
end


% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)

set(handles.ID,'String','');
set(handles.evidanceclipedit,'String','');
set(handles.remarks,'String','');
set(handles.Recording_date, 'String', 'select');
set(handles.evidanceclipedit, 'Enable', 'off' );
set(handles.remarks, 'Enable', 'off' );
set(handles.Recording_date, 'Enable', 'off' );
set(handles.save, 'Enable', 'off' );

% --- Executes on button press in Searchpushbutton.
function Searchpushbutton_Callback(hObject, eventdata, handles)

% M_case = HashStore();
% 
% if (isKey(M_suspect.hTable,handles.suspect_filename))
    
%     --- Executes on button press in Browsepushbutton.
function Browsepushbutton_Callback(hObject, eventdata, handles)
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
    [evidence_clip, fs] = audioread(File);
    handles.evidence_clip = evidence_clip;
    handles.fs = fs;
    handles.path = File;
    [a b] = fileparts(filename);
    handles.filename = b;
    end
    set(handles.evidanceclipedit, 'String', [File]);
end
guidata(hObject, handles);

function evidanceclipedit_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function evidanceclipedit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Loadpushbutton.
function Loadpushbutton_Callback(hObject, eventdata, handles)

path = 'C:\Forensic_Audio_workspace\cases';
pathofcase  = [path, '\', get(handles.ID,'String')];
if(exist(pathofcase,'dir'))
    display('folder found');
    msgbox('Case Found');
    set(handles.evidanceclipedit, 'Enable', 'on' );
    set(handles.remarks, 'Enable', 'on' );
    set(handles.Recording_date, 'Enable', 'on' );
    set(handles.save, 'Enable', 'on' );
else
    set(handles.evidanceclipedit, 'Enable', 'off' );
    set(handles.remarks, 'Enable', 'off' );
    set(handles.Recording_date, 'Enable', 'off' );
    set(handles.save, 'Enable', 'off' );
    errordlg('Case File Not Found. To create new case go to ''New case'' tab');
    new_case;
end
