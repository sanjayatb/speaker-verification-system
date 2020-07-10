function varargout = new_case(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @new_case_OpeningFcn, ...
                   'gui_OutputFcn',  @new_case_OutputFcn, ...
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
% --- Executes just before new_case is made visible.
function new_case_OpeningFcn(hObject, ~, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = new_case_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function casenameedit_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function casenameedit_CreateFcn(hObject, eventdata, handles)
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function casenoedit_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function casenoedit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes on selection change in datepopupmenu.
function datepopupmenu_Callback(hObject, eventdata, handles)
uicalendar('SelectionType', 1, 'DestinationUI',handles.datepopupmenu);

% --- Executes during object creation, after setting all properties.
function datepopupmenu_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function detailsedit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function detailsedit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in savepushbutton.
function savepushbutton_Callback(hObject, eventdata, handles)
name = get(handles.casenameedit,'String');
ID = get(handles.casenoedit,'String');
Date = get(handles.datepopupmenu,'String');
officer_name = get(handles.nameofinchargeedit,'String');
officer_id = get(handles.IDnoedit,'String');
description = get(handles.detailsedit,'String');

if ((strcmp(name,'') == 0) && (strcmp(ID,'') == 0)  && (strcmp(Date,'select') == 0)&& (strcmp(officer_name,'') == 0) )
  
M = HashStore();
result= M.add_case(ID,name,Date,officer_name,officer_id,description)
msgbox(result,'Saving new case');

path = 'C:\Forensic_Audio_workspace\cases';
pathofcase  = [path, '\', ID];
if(exist(pathofcase,'dir'))
    display('folder found');
else
    mkdir(pathofcase);
end

else
     errordlg('Enter all fields','File Error');
end

% --- Executes on button press in resetpushbutton.
function resetpushbutton_Callback(hObject, eventdata, handles)
set(handles.datepopupmenu, 'String', 'select');
set(handles.detailsedit,'String','');
set(handles.casenameedit,'String','');
set(handles.casenoedit,'String','');
set(handles.nameofinchargeedit,'String','');
set(handles.IDnoedit,'String','');


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)

function nameofinchargeedit_Callback(~, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function nameofinchargeedit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function IDnoedit_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function IDnoedit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
