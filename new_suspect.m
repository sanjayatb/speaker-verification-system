function varargout = new_suspect(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @new_suspect_OpeningFcn, ...
                   'gui_OutputFcn',  @new_suspect_OutputFcn, ...
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


% --- Executes just before new_suspect is made visible.
function new_suspect_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;
handles.suspect_clip = '';
handles.fs = '';
handles.path = '';
handles.filename = '';% Update handles structure
set(handles.Name, 'Enable', 'off' );
set(handles.NIC, 'Enable', 'off' );
set(handles.birthday, 'Enable', 'off' );
set(handles.Address, 'Enable', 'off' );
set(handles.Recording_date, 'Enable', 'off' );
set(handles.save, 'Enable', 'off' );
set(handles.Suspect, 'Enable', 'off' );
set(handles.remarks, 'Enable', 'off' );
set(handles.gender, 'Enable', 'off' );
set(handles.mismatchedit, 'Enable', 'off' );
set(handles.verificationpopupmenu, 'Enable', 'off' );
guidata(hObject, handles);

% UIWAIT makes new_suspect wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = new_suspect_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;



function Name_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function Name_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function NIC_Callback(~, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function NIC_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Address_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function Address_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in birthday.
function birthday_Callback(hObject, eventdata, handles)

 uicalendar('SelectionType', 1, 'DestinationUI',handles.birthday);
 

% --- Executes during object creation, after setting all properties.
function birthday_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in gender.
function gender_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function gender_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Suspect.
function Suspect_Callback(hObject, eventdata, handles)

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
    [suspect_clip suspect_fs] = audioread(File);
    handles.suspect_clip = suspect_clip;
    handles.fs = suspect_fs;
    handles.path = File;
    [a b] = fileparts(filename);
    handles.filename = b;
    end
    set(handles.Suspect, 'String', [File]);
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Suspect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Suspect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
ID = get(handles.CaseIDedit,'String');
name = get(handles.Name,'String');
NIC = get(handles.NIC,'String');
bday = get(handles.birthday,'String');
gender = get(handles.gender,'Value');
address = get(handles.Address,'String');
recording_date = get(handles.Recording_date,'String');
mismatch= get(handles.mismatchedit,'String');
remarks= get(handles.remarks,'String');
option = get(handles.verificationpopupmenu,'Value');
clip_length = length(handles.suspect_clip)/handles.fs;

if ((strcmp(ID,'') == 0) && (strcmp(mismatch,'') == 0) &&(strcmp(name,'') == 0) && (strcmp(handles.path,'') == 0) )
    display(handles.filename);
    M = HashStore();
    result= M.add_suspect(option,ID,name,NIC,bday,gender,address,recording_date,mismatch, remarks,handles.suspect_clip,handles.fs,handles.path,handles.filename,clip_length);
    msgbox(result,'Saving new Suspect');
    
    path = 'C:\Forensic_Audio_workspace\cases';
    pathofcase  = [path, '\', ID,'\Suspects\Option',num2str(option)];
    if(exist(pathofcase,'dir'))
        display('folder found');
        msgbox('Case Found.');
    else
        mkdir(pathofcase);
    end
    
    audiowrite([pathofcase,'\',handles.filename,'.wav'],handles.suspect_clip,handles.fs);    
else
     errordlg('* marked feilds must be fill','File Error');
end
% --- Executes on button press in add_Clip.
function add_Clip_Callback(hObject, eventdata, handles)

% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)


% --- Executes on selection change in Recording_date.
function Recording_date_Callback(hObject, eventdata, handles)
 uicalendar('SelectionType', 1, 'DestinationUI',handles.Recording_date);

% --- Executes during object creation, after setting all properties.
function Recording_date_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)

set(handles.CaseIDedit,'String','');
set(handles.Suspect, 'String', 'select');
set(handles.Name,'String','');
set(handles.birthday,'String','select');
set(handles.NIC,'String','');
set(handles.remarks,'String','');
set(handles.Address,'String','');
set(handles.Recording_date,'String','select');
handles.suspect_clip = '';
handles.fs = '';
handles.path = '';
handles.filename = '';
set(handles.Name, 'Enable', 'off' );
set(handles.NIC, 'Enable', 'off' );
set(handles.birthday, 'Enable', 'off' );
set(handles.Address, 'Enable', 'off' );
set(handles.Recording_date, 'Enable', 'off' );
set(handles.save, 'Enable', 'off' );
set(handles.Suspect, 'Enable', 'off' );
set(handles.remarks, 'Enable', 'off' )
set(handles.gender, 'Enable', 'off' );
set(handles.mismatchedit, 'Enable', 'off' );
set(handles.verificationpopupmenu, 'Enable', 'off' );


guidata(hObject, handles);
% --- Executes during object creation, after setting all properties.
function text1_CreateFcn(hObject, eventdata, handles)

function figure1_CloseRequestFcn(hObject, eventdata, handles)

user_response = closebutton('Title','Confirm Close');
switch user_response
case {'No'}
	% take no action
case 'Yes'
	% Prepare to close GUI application window
	%                  .
	%                  .
	%                  .
 	delete(handles.figure1)
end



function remarks_Callback(hObject, eventdata, handles)

function remarks_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function CaseIDedit_Callback(hObject, eventdata, handles)

function CaseIDedit_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in verificationpopupmenu.
function verificationpopupmenu_Callback(hObject, eventdata, handles)


function verificationpopupmenu_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mismatchedit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function mismatchedit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in loadpushbutton.
function loadpushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to loadpushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
path = 'C:\Forensic_Audio_workspace\cases';
pathofcase  = [path, '\', get(handles.CaseIDedit,'String')];
if(exist(pathofcase,'dir'))
    display('folder found');
    msgbox('Case Found');
    set(handles.Name, 'Enable', 'on' );
    set(handles.NIC, 'Enable', 'on' );
    set(handles.birthday, 'Enable', 'on' );
    set(handles.Address, 'Enable', 'on' );
    set(handles.Recording_date, 'Enable', 'on' );
    set(handles.save, 'Enable', 'on' );
    set(handles.Suspect, 'Enable', 'on' );
    set(handles.gender, 'Enable', 'on' );
    set(handles.remarks, 'Enable', 'on' );
    set(handles.mismatchedit, 'Enable', 'on' );
    set(handles.verificationpopupmenu, 'Enable', 'on' );
else
    errordlg('Case File Not Found. To create new case go to ''New case'' tab');
                new_case;
end
