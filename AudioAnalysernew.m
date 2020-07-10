function varargout = AudioAnalysernew(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AudioAnalysernew_OpeningFcn, ...
                   'gui_OutputFcn',  @AudioAnalysernew_OutputFcn, ...
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


% --- Executes just before AudioAnalysernew is made visible.
function AudioAnalysernew_OpeningFcn(hObject, eventdata, handles, varargin)
set(handles.axes1,'YTick',[]);
set(handles.axes1,'XTick',[]);
set(handles.axes2,'YTick',[]);
set(handles.axes2,'XTick',[]);
% Choose default command line output for AudioAnalysernew
handles.output = hObject;
handles.clip = 0;
handles.S =0;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes AudioAnalysernew wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = AudioAnalysernew_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
% Call modaldlg with the argument 'Position'.
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


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Playtogglebutton2.
function Playtogglebutton2_Callback(hObject, eventdata, handles)
% hObject    handle to Playtogglebutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Playtogglebutton2
% global player;
if length(handles.S) >10
        userrespoense = get(hObject,'Value');
    if userrespoense 
        A=imread('pause.jpg'); 
        B = imresize(A,0.3); 
        set(hObject,'CData',B);
        resume(handles.player1);
    else
        A=imread('play.jpg'); 
        B = imresize(A,0.3); 
        set(hObject,'CData',B);
        pause(handles.player1);
    end
else
    errordlg('File not found','File Error');
end



% --- Executes on button press in Stoppushbtn2.
function Stoppushbtn2_Callback(hObject, eventdata, handles)
% hObject    handle to Stoppushbtn2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if length(handles.S) >10
    stop(handles.player1)
else
   errordlg('File not found','File Error');
end
% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes2


% --- Executes during object creation, after setting all properties.
function Playtogglebutton2_CreateFcn(hObject, ~, handles)
% hObject    handle to Playtogglebutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
A=imread('play.jpg'); 
B = imresize(A,0.3); 
set(hObject,'CData',B);
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Processpushbutton.
function Processpushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Processpushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
noise = str2num(get(handles.Noiseleledit,'String'));
frame = str2num(get(handles.Frameedit,'String'));
n=frame;
len = length(handles.clip);
clip= handles.clip;
%nbFrame = floor((l - n) / m) + 1;
nbFrame = floor(len/n);
M = zeros(n,nbFrame);
    for j = 1:nbFrame
      tm = ((j - 1) * n);
      M(:, j) = clip(tm+1:tm+n);         %% consist matrix of frame size and spacing
    end           
E=20*log10(std(M)+eps);% Energies
max1=max(E);%Maximum
I=(E>max1-noise) & (E>-55);%Indicator       %30
[~ , d] = size(I);
S = [];
for j = 1:nbFrame
   M(:, j) = M(:,j).*I(1,j);         %% consist matrix of frame size and spacing
   S = [S M(:,j)'];
end

S = S(find(S~=0));
%sound(S,fs)
handles.S = S;
%create player
    player1 = audioplayer(S,handles.fs);handles.player1 = player1;
    guidata(hObject, handles);
%set  parameters
    len1 = round(length(S)/handles.fs);
    len1 = num2str(len1);
set(handles.Lengthnoise,'String',len1);
plot(handles.axes2,S);
set(handles.axes2,'YTick',[]);
set(handles.axes2,'XTick',[]);
title('Silence Removed');

% --- Executes on button press in Playtogglebutton1.
function Playtogglebutton1_Callback(hObject, eventdata, handles)
% hObject    handle to Playtogglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Playtogglebutton1
if length(handles.clip) >10
        userrespoense = get(hObject,'Value');
    if userrespoense 
        A=imread('pause.jpg');
        B = imresize(A,0.3); 
        set(hObject,'CData',B);
        resume(handles.player);
    else
        A=imread('play.jpg'); 
        B = imresize(A,0.3); 
        set(hObject,'CData',B);
        pause(handles.player);  
    end
else
    errordlg('File not found','File Error');
end

% --- Executes on button press in Stoppushbutton1.
function Stoppushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to Stoppushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if length(handles.clip) >10
    stop(handles.player)
else
   errordlg('File not found','File Error');
end

function Filnoisedit_Callback(hObject, eventdata, handles)
% hObject    handle to Filnoisedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Filnoisedit as text
%        str2double(get(hObject,'String')) returns contents of Filnoisedit as a double
val = str2double(get(hObject,'String'));
if val>40 || val < 1
    msgbox('Input values between 1 to 40 dB');
    set(hObject,'String','20');
end

% --- Executes during object creation, after setting all properties.
function Filnoisedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Filnoisedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function filframeedit_Callback(hObject, eventdata, handles)
% hObject    handle to filframeedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filframeedit as text
%        str2double(get(hObject,'String')) returns contents of filframeedit as a double
val = str2double(get(hObject,'String'));
val = round(val);
if val <10 || val > 256
    msgbox('Input values between 10 to 256');
    set(hObject,'String','256');
end

% --- Executes during object creation, after setting all properties.
function filframeedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filframeedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Noiseleledit_Callback(hObject, eventdata, handles)
% hObject    handle to Noiseleledit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Noiseleledit as text
%        str2double(get(hObject,'String')) returns contents of Noiseleledit as a double
val = str2double(get(hObject,'String'));
if val>40 || val < 1
    msgbox('Input values between 1 to 40 dB');
    set(hObject,'String','30');
end

% --- Executes during object creation, after setting all properties.
function Noiseleledit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Noiseleledit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Frameedit_Callback(hObject, eventdata, handles)
% hObject    handle to Frameedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Frameedit as text
%        str2double(get(hObject,'String')) returns contents of Frameedit as a double
val = str2double(get(hObject,'String'));
val = round(val);
if val<10 || val > 256
    msgbox('Input values between 10 to 256');
    set(hObject,'String','256');
end

% --- Executes during object creation, after setting all properties.
function Frameedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Frameedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SaveNewClippushbutton.
function SaveNewClippushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to SaveNewClippushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
flname = handles.filename;
flname = flname(1:(length(flname)-4));
save_path = [handles.pathname,flname,'_silenceremoved'];
wav_path = [save_path,'.wav'];
audiowrite(wav_path,handles.S,handles.fs);
guidata(hObject, handles);
msgbox('Successfuly saved...','Saving processed clip')

% --- Executes during object deletion, before destroying properties.
function axes1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Resetpushbutton.
function Resetpushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Resetpushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.figure1);
AudioAnalysernew();


% --------------------------------------------------------------------
function plot_ax2_Callback(hObject, eventdata, handles)
% hObject    handle to plot_ax2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes2fig = figure;
% Copy the axes and size it to the figure
axes2copy = copyobj(handles.axes2,axes2fig);
set(axes2copy,'Units','Normalized',...
              'Position',[.05,.20,.90,.60])
% Assemble a title for this new figure
str = get(handles.text25,'String');
title(str,'Fontweight','bold')
% Save handles to new fig and axes in case
%  we want to do anything else to them
handles.axes1fig = axes2fig;
handles.axes1copy = axes2copy;
guidata(hObject,handles);

% --------------------------------------------------------------------
function plot_ax1_Callback(hObject, eventdata, handles)
% hObject    handle to plot_ax1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes1fig = figure;
% Copy the axes and size it to the figure
axes1copy = copyobj(handles.axes1,axes1fig);
set(axes1copy,'Units','Normalized',...
              'Position',[.05,.20,.90,.60])
% Assemble a title for this new figure
str = get(handles.text24,'String');
title(str,'Fontweight','bold')
% Save handles to new fig and axes in case
% we want to do anything else to them
handles.axes1fig = axes1fig;
handles.axes1copy = axes1copy;
guidata(hObject,handles);

% --------------------------------------------------------------------
function plot_Axes1_Callback(hObject, eventdata, handles)
% hObject    handle to plot_Axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function plot_Axes2_Callback(hObject, eventdata, handles)
% hObject    handle to plot_Axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function Playtogglebutton1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Playtogglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
A=imread('play.jpg'); 
B = imresize(A,0.3); 
set(hObject,'CData',B);


% --- Executes during object creation, after setting all properties.
function Stoppushbutton1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Stoppushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
A=imread('stop.jpg'); 
B = imresize(A,0.3); 
set(hObject,'CData',B);


% --- Executes during object creation, after setting all properties.
function Stoppushbtn2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Stoppushbtn2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
A=imread('stop.jpg'); 
B = imresize(A,0.3); 
set(hObject,'CData',B);


% --- Executes on slider movement.
function slider6_Callback(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.slider6,'Max',str2num(get(handles.Length,'String')));
pos = get(hObject,'Value');
pos = round(pos);
disp(pos)

% --- Executes during object creation, after setting all properties.
function slider6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider7_Callback(hObject, eventdata, handles)
% hObject    handle to slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider




% --- Executes during object creation, after setting all properties.
function slider7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on key press with focus on Playtogglebutton2 and none of its controls.
function Playtogglebutton2_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to Playtogglebutton2 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Openpushbutton.
function Openpushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Openpushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile( ...
    {'*.wav', 'All WAV-Files (*.wav)'; ...
        '*.*','All Files (*.*)'}, ...
    'Select Audio Clip');
% If "Cancel" is selected then return
handles.filename = filename;
handles.pathname = pathname;
guidata(hObject, handles);
if isequal([filename,pathname],[0,0])
    return
    % Otherwise construct the fullfilename and Check and load the file.
else
    File = fullfile(pathname,filename);
    % if the MAT-file is not valid, do not save the name
    if exist(File,'file') == 2
    [s fs] = audioread(File);
    handles.clip = s;
    handles.fs = fs;
    player = audioplayer(s,fs);
    handles.player = player;
    guidata(hObject, handles);
    clip = handles.clip;
    disp(player)
    len = round(length(clip)/handles.fs);
    len = num2str(len);
    set(handles.Length,'String',len);
%    %plot
        ax = handles.axes1;
        plot(ax,clip);
        set(handles.axes1,'YTick',[]);
        set(handles.axes1,'XTick',[]);
        title('Original Clip');
    end
end

% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1
