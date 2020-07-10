function varargout = option1(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @option1_OpeningFcn, ...
                   'gui_OutputFcn',  @option1_OutputFcn, ...
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


% --- Executes just before option1 is made visible.
function option1_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for option1
handles.output = hObject;
handles.evidence_filename = '';
handles.evidence_path = '';
handles.suspect_filename = '';
handles.suspect_path = '';
set(handles.dimensionpopupmenu, 'Enable', 'off' );
set(handles.Componentstext, 'Enable', 'off' );
set(handles.Dimensiontext, 'Enable', 'off' );
set(handles.componentspopupmenu, 'Enable', 'off' );
set(handles.Evidance_popupmenu,  'Enable', 'off' );
set(handles.Suspect_popupmenu,  'Enable', 'off' );
set(handles.background_popupmenu,  'Enable', 'off' );
set(handles.Verifypushbutton,  'Enable', 'off' );
set(handles.Reportpushbutton,  'Enable', 'off' );
% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = option1_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;


% --- Executes on selection change in gender_popupmenu.
function gender_popupmenu_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function gender_popupmenu_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Evidance_popupmenu.
function Evidance_popupmenu_Callback(hObject, eventdata, handles)

[filename, pathname] = uigetfile( ...
    {'*.wav', 'All WAV-Files (*.wav)'; ...
        '*.*','All Files (*.*)'},'Select Evidance Clip', ...
    handles.pathofcase);
% If "Cancel" is selected then return
if isequal([filename,pathname],[0,0])
    return
    % Otherwise construct the fullfilename and Check and load the file.
else
    File = fullfile(pathname,filename);
    % if the MAT-file is not valid, do not save the name
    if exist(File,'file') == 2;
    [a b] = fileparts(filename);
    handles.evidence_filename = b;
    handles.evidence_path = File;
    end
    set(handles.Evidance_popupmenu, 'String', [pathname,filename]);
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Evidance_popupmenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Suspect_popupmenu.
function Suspect_popupmenu_Callback(hObject, eventdata, handles)
[filename, pathname] = uigetfile( ...
    {'*.wav', 'All WAV-Files (*.wav)'; ...
        '*.*','All Files (*.*)'}, ...
    'Select Suspect Clip',handles.pathofcase);

% If "Cancel" is selected then return
if isequal([filename,pathname],[0,0])
    return
    % Otherwise construct the fullfilename and Check and load the file.
else
    File = fullfile(pathname,filename);
    % if the MAT-file is not valid, do not save the name
    if exist(File,'file') == 2
%     [Suspect_clip Suspect_fs] = audioread(File);
%      handles.fs = Suspect_fs;
    [a b] = fileparts(filename);
    handles.suspect_filename = b;
    handles.suspect_path = File;
    end
    set(handles.Suspect_popupmenu, 'String', File);
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Suspect_popupmenu_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in Reportpushbutton.
function Reportpushbutton_Callback(hObject, eventdata, handles)
 path = 'C:\Forensic_Audio_workspace\cases.mat';
  h = load(path);
  hTable = h.hTable;
i=handles.case_number;
key = hTable(i);
assignin('base','Number_Case',i);
assignin('base','Name_Case',key.Name);
assignin('base','Officer_ID',key.Officer_ID);
assignin('base','Date_Case',key.Date);
assignin('base','Officer_Name',key.Officer_name);
assignin('base','Description',key.Description);
evi = handles.evidence_filename;
evi = key.Evidence(evi);
assignin('base','Evid_Length',evi.clip_length);
assignin('base','Evid_Date',evi.Recording_Date);
assignin('base','Evid_Details',evi.remarks);
sus = handles.suspect_filename;
sus = key.Option1.Suspects(sus);
assignin('base','Suspect_Name',sus.Name);
assignin('base','NIC',sus.NIC);
assignin('base','Suspect_Gender',sus.Gender);
assignin('base','Suspect_Date',sus.Recording_Date);
assignin('base','Mismatch',sus.mismatch);
assignin('base','Result',handles.Result);
assignin('base','Score',handles.Scoretext);

report('version1.rpt');



% --- Executes on button press in Verifypushbutton.
function Verifypushbutton_Callback(hObject, eventdata, handles)

    M = HashStore();
    if (isKey(M.hTable,handles.case_number))
        key = M.hTable(handles.case_number);
        Evi = key.Evidence;
        Sus = key.Option1.Suspects;
        
        if (isKey(Evi,handles.evidence_filename))
            if (isKey(Sus,handles.suspect_filename))
                suspect = Sus(handles.suspect_filename);
                evidence = Evi(handles.evidence_filename);
                gender = suspect.Gender;
                type = get(handles.background_popupmenu, 'Value');
                
                if (strcmp(gender, 'male')==0)
                    if ( type == 1)
                        ubm_path = [pwd '\males_dept_ubm_8.mat'];  %% add the correct paths
                        table_path = [pwd '\Male_Table.mat'];
                    elseif ( type == 2)
                        ubm_path = [pwd '\males_dept_ubm_8.mat'];  %% add the correct
                        table_path = [pwd '\Male_Table.mat'];
                    else ubm_path = [pwd '\males_dept_ubm_8.mat'];  %% add the correct paths
                        table_path = [pwd '\Male_Table.mat'];
                    end
                    
                else
                    if ( type == 1)
                        ubm_path = [pwd '\females_dept_ubm.mat'];  %% add the correct paths
                        table_path = [pwd '\Female_Table.mat'];
                    elseif ( type == 2)
                        ubm_path = [pwd '\females_dept_ubm.mat'];  %% add the correct paths
                        table_path = [pwd '\Female_Table.mat'];
                    else ubm_path = [pwd '\females_dept_ubm.mat'];  %% add the correct paths
                        table_path = [pwd '\Female_Table.mat'];
                    end
                end
                ubm = load(ubm_path);
                Table = load(table_path);
                score = HashStore.verify(suspect,evidence,ubm);
                handles.score = score;
                display (score);
                Table = Table.Table;
                if (score <  min(Table(:,1)))
                    prob = '100';
                    
                elseif score > max(Table(:,1))
                    prob = '0';
                    
                else
                    Rscore =  round(score*100);
                    Table = round(Table*100);
                    I = find (Table(:,1)== Rscore);
                    prob = num2str(100-Table(I,3));
                    prob = prob(1,1);
                end
                str = [prob,' %'];
                set(handles.Result, 'String', str );
                set(handles.Scoretext, 'String', score);
            else
                errordlg('Suspect File Name mismatch','File Error');
            end
        else
            errordlg('Evidance File Name mismatch','File Error');
        end
    else
        errordlg('Case not found','File Error');
    end
    

    
    % --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)

user_response = closebutton('Title','Confirm Close');
switch user_response
case {'No'}
case 'Yes'
    delete(hObject);
end


function [s,fs] = loadfile(File)
if exist(File,'file') == 2
    [s fs] = audioread(File);
end


% --- Executes on selection change in componentspopupmenu.
function componentspopupmenu_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function componentspopupmenu_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in dimensionpopupmenu.
function dimensionpopupmenu_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function dimensionpopupmenu_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in AdvanceOptionsradiobutton.
function AdvanceOptionsradiobutton_Callback(hObject, eventdata, handles)

optionselect = get(hObject,'Value');
if (optionselect==0)
    set(handles.dimensionpopupmenu, 'Enable', 'off' );
    set(handles.Componentstext, 'Enable', 'off' );
    set(handles.Dimensiontext, 'Enable', 'off' );
    set(handles.componentspopupmenu, 'Enable', 'off' );
else
    set(handles.dimensionpopupmenu, 'Enable', 'on' );
    set(handles.Componentstext, 'Enable', 'on' );
    set(handles.Dimensiontext, 'Enable', 'on' );
    set(handles.componentspopupmenu, 'Enable', 'on' );
end



function casenumberedit_Callback(hObject, eventdata, handles)
% hObject    handle to casenumberedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of casenumberedit as text
%        str2double(get(hObject,'String')) returns contents of casenumberedit as a double


% --- Executes during object creation, after setting all properties.
function casenumberedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to casenumberedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Loadpushbutton.
function Loadpushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Loadpushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
case_number = get(handles.casenumberedit,'String');

path = 'C:\Forensic_Audio_workspace\cases\';
pathofcase  = [path,case_number];
handles.case_number =case_number;
handles.pathofcase = pathofcase;
guidata(hObject, handles);
M = HashStore();
if( strcmp(get(handles.casenumberedit,'String'),'')==0)
    if(exist(pathofcase,'dir'))
        display('folder found');
        key = M.hTable(handles.case_number)
        details = ['Case Found.      Case Name : ',key.Name];
%         details_build(details);
        msgbox(details);
        set(handles.Evidance_popupmenu,  'Enable', 'on' );
        set(handles.Suspect_popupmenu,  'Enable', 'on' );
        set(handles.background_popupmenu,  'Enable', 'on' );
        set(handles.Verifypushbutton,  'Enable', 'on' );
        set(handles.Reportpushbutton,  'Enable', 'on');
        set(handles.Evidance_popupmenu, 'String', handles.pathofcase);
        set(handles.Suspect_popupmenu, 'String', handles.pathofcase);
        guidata(hObject, handles);
    else
        errordlg('Case File Not Found. To create new case go to ''New case'' tab');
    end
else
    errordlg('Enter Case Number');
end


guidata(hObject, handles);

% --- Executes on selection change in background_popupmenu.
function background_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to background_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns background_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from background_popupmenu


% --- Executes during object creation, after setting all properties.
function background_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to background_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Reset.
function Reset_Callback(hObject, eventdata, handles)
% hObject    handle to Reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.figure1);
option1;
