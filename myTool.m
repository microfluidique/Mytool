function varargout = myTool(varargin)
% MYTOOL MATLAB code for myTool.fig
%      MYTOOL, by itself, creates a new MYTOOL or raises the existing
%      singleton*.
%
%      H = MYTOOL returns the handle to a new MYTOOL or the handle to
%      the existing singleton*.
%
%      MYTOOL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MYTOOL.M with the given input arguments.
%
%      MYTOOL('Property','Value',...) creates a new MYTOOL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before myTool_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to myTool_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modifunction myfy the response to help myTool

% Last Modified by GUIDE v2.5 08-Oct-2015 16:08:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @myTool_OpeningFcn, ...
                   'gui_OutputFcn',  @myTool_OutputFcn, ...
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


% --- Executes just before myTool is made visible.
function myTool_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to myTool (see VARARGIN)

% Choose default command line output for myTool
handles.output = hObject;
handles.number = 0;
handles.allData= struct;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes myTool wait for user response (see UIRESUME)
% uiwait(handles.figure1);
play = imread('play.jpg');
play = imresize(play, 0.2);
set(handles.start , 'Cdata', play);
img = imread('tv.jpg');


axes(handles.axes1);
imshow(img);
drawnow;

%hToolbar = get(hUndo,'Parent');  % an alternative
% hButtons = findall(hToolbar);
% set(hToolbar,'children',hButtons([4:end-4,2,3,end-3:end]));
% --- Outputs from this function are returned to the command line.
function varargout = myTool_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function path_Callback(hObject, eventdata, handles)
% hObject    handle to path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of path as text
%        str2double(get(hObject,'String')) returns contents of path as a double


% --- Executes during object creation, after setting all properties.
function path_CreateFcn(hObject, eventdata, handles)
% hObject    handle to path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
nbFrames = getappdata(handles.start , 'int');

value  = get(handles.slider, 'Value');
if(strcmp(get(handles.start,'String'),'Start'))
    uiresume();
    set(handles.start,'String','Pause');
    for k=value:nbFrames
        img=read(handles.videoObject,k);
        img = imadjust(rgb2gray(img)) ;
        axes(handles.axes1);
        imshow(img);
        drawnow;
        set(handles.nbFrame, 'String', round(k));
        set(handles.slider,'Value', k); 
    end
    
else
    set(handles.start,'String','Start');
    uiwait();
end



% --- Executes on slider movement.
function slider_Callback(hObject, eventdata, handles)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% global firstTime;
% global Zoom;
% firstTime = 1;
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
 % zoom = axis(handles.axes1);
% handles.zoom = zoom;
% disp('slide');
% disp(zoom);
% guidata(hObject, handles);

videoObject = handles.videoObject;
value  = get(handles.slider, 'Value');
img=read(videoObject,value);
img = imadjust(rgb2gray(img));

axes(handles.axes1);

set(handles.nbFrame, 'String',round(value));
% disp(handles.Zoom);
% 
% 
% if(isempty(handles.Zoom)) 
%      moi = 'fff';
% else
zoom reset;
ax=handles.Zoom; 
img= imcrop(img, [ax(1),ax(3),ax(2)-ax(1),ax(4)-ax(3)]);

  
imshow(img);
drawnow;
   

% --- Executes during object creation, after setting all properties.
function slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function nbFrame_Callback(hObject, eventdata, handles)
% hObject    handle to nbFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nbFrame as text
%        str2double(get(hObject,'String')) returns contents of nbFrame as a double


% --- Executes during object creation, after setting all properties.
function nbFrame_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nbFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --------------------------------------------------------------------
function video_Callback(hObject, eventdata, handles)
% hObject    handle to video (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%answer = inputdlg('fffff')
[ video_file_name,video_file_path ] = uigetfile({'*.*'},'Pick a video file');      %;*.png;*.yuv;*.bmp;*.tif'},'Pick a file');
if(video_file_path == 0)
    return;
end
input_video_file = [video_file_path,video_file_name];
set(handles.path,'String',input_video_file);
% Acquiring video
videoObject = VideoReader(input_video_file);
% Display first frame
frame_1 = read(videoObject,1);
 frame_1 = imadjust(rgb2gray(frame_1)) ;
axes(handles.axes1);
imshow(frame_1);
drawnow;
set(hObject, 'Enable', 'on')
axis(handles.axes1,'off');
% Display Frame Number
% set(handles.text3,'String','1');
% set(handles.text4,'String',['  /  ',num2str(videoObject.NumberOfFrames)]);
% set(handles.text2,'Visible','on');
% set(handles.text3,'Visible','on');
% set(handles.text4,'Visible','on');
% set(handles.pushbutton2,'Enable','on');
% set(handles.pushbutton1,'Enable','off');
%Update handles
handles.videoObject = videoObject;
guidata(hObject,handles);
videoObject = handles.videoObject;
nbFrames=videoObject.NumberOfFrames;

sliderMin = 1;
sliderMax = nbFrames; % this is variable
sliderStep = [1, 1]/(sliderMax-sliderMin); % major and minor steps of 1
set(handles.slider, 'Min', sliderMin);
set(handles.slider, 'Max', sliderMax);
set(handles.slider, 'SliderStep', sliderStep);
set(handles.slider, 'Value', sliderMin); % set to beginning of sequence 
setappdata(handles.start,'int',nbFrames);
table  = zeros(nbFrames, 1);
handles.data = table;
zoom = axis(handles.axes1);

handles.Zoom = zoom;
disp('zoom') ; 
disp(zoom) ; 
handles.originalZoom = zoom;
guidata(hObject,handles);
% --- Executes on button press in bud.

function event_Callback(hObject, eventdata, handles,event_number ,selected_row )

allData = handles.allData;
%allData(selected_row).events{event_number}{3} = {table};
value  = get(handles.slider, 'Value');

class(allData(selected_row).events{event_number}{3})
disp('lologl');
 disp(allData(selected_row).events{event_number}{3}(1));

 if allData(selected_row).events{event_number}{3}(round(value)) == 1
     allData(selected_row).events{event_number}{3}(round(value)) = 0;
     
     disp(round(value));
     disp(allData(selected_row).events{event_number}{3}(round(value)));
 else
     allData(selected_row).events{event_number}{3}(round(value)) = 1;
     disp(round(value));
     disp(allData(selected_row).events{event_number}{3}(round(value)));
 end
handles.allData = allData;
guidata(hObject,handles);
% handles.data = table;
% guidata(hObject,handles);
 nbFrames = getappdata(handles.start , 'int');
 x = [1:nbFrames];
% table = handles.data;
% save('results','table');

%  y = allData(1).events{1}{3};
%  
%   y2 = allData(1).events{2}{3};
% plot(handles.axes3, x,y,  x, y2 ); 

%  plot(handles.axes3, x, y2);

 
 
 
%   dataPlot =[  y  y2];
 
%  
 nbEvents = allData(selected_row).nbEvents;
 nbEvents = str2double(nbEvents);
 dataPlot= [];
 legends= [];
 for j=1:nbEvents
      dataPlot = [dataPlot allData(selected_row).events{j}{3}];
      legends = [legends ; allData(selected_row).events{j}{1}];
     
 end
 
 
  disp('dataPlot');
  disp(dataPlot);
  plot(handles.axes3, dataPlot);

  legend(handles.axes3 , legends);
    
% --- Executes on button press in bud.
function file_Callback(hObject, eventdata, handles)
% hObject    handle to bud (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in first.
function first_Callback(hObject, eventdata, handles)
% hObject    handle to first (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.slider,'Value', 1); 
set(handles.nbFrame, 'String',1);
frame_1 = read(handles.videoObject,1);

axes(handles.axes1);
imshow(frame_1);
drawnow;


% --- Executes on button press in last.
function last_Callback(hObject, eventdata, handles)
% hObject    handle to last (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.slider,'Value', inf); 
set(handles.nbFrame, 'String',inf);
frame_inf = read(handles.videoObject,inf);

axes(handles.axes1);
imshow(frame_inf);
drawnow;


% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

allData = handles.allData;
selected_row  = handles.selected_row  ; 
nbEvents = allData(selected_row).nbEvents;
nbEvents = str2double(nbEvents);
for k=1:nbEvents
    if strcmp(eventdata.Key,allData(selected_row).events{k}{2})
        event_Callback(hObject, eventdata, handles, k ,selected_row );
    end
end







% valueSlider  = get(handles.slider, 'Value');
% 
%  switch(eventdata.Key)
%     case 'rightarrow'
% 
% set(handles.slider,'Value',valueSlider+1);
%         slider_Callback(hObject, eventdata, handles);
%     case 'leftarrow'
% 
%       set(handles.slider,'Value',valueSlider-1);
%         slider_Callback(hObject, eventdata, handles);
%  end


% --- Executes when selected cell(s) is changed in uitable1.
function uitable1_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
data = get(hObject,'Data');
indices = eventdata.Indices;
r = indices(:,1);
selected_vals = data(r);

set(handles.nbFrame, 'String',selected_vals);
set(handles.slider,'Value', selected_vals);
guidata(hObject, handles);
slider_Callback(hObject, eventdata, handles);


% --------------------------------------------------------------------
function uitoggletool1_OnCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp(zoom);
handles.Zoom = zoom;
set(handles.Zoom,'ActionPostCallback',{@mouseFcn,handles});
guidata(hObject,handles);



function mouseFcn(hObject, eventdata, handles)

zoom = axis(handles.axes1);

handles.Zoom = zoom;
guidata(hObject,handles);

% Construct a questdlg with three options
choice = questdlg('Do you want to save this ROI?',...
      'Validation',...
      'Yes','No','Yes');
switch choice,
    case 'Yes',
  
        handles.number = handles.number +1;
        guidata(hObject,handles);
        ROI_informations(hObject, eventdata, handles)
        disp('LOLOLOLOLOLOLOLOLOLOLOLOLOLOL');
disp( handles.number);
     case 'No'
        uipushtool3_ClickedCallback(hObject, eventdata, handles)
end

set(handles.uitoggletool1, 'State', 'off');

% -------------------------------------------------------------------
function uipushtool3_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)re
handles.Zoom = handles.originalZoom;
guidata(hObject,handles);
slider_Callback(hObject, eventdata, handles);   

function ROI_informations(hObject, eventdata, handles)

Answers = inputdlg({'ROI Name?',...
            'Number of cells followed?','Number of events ?', 'Description?'},'ROI informations', [1 1 1 3]);
[name, nb,events,  descr] = Answers{:};

oldData = get(handles.ROI, 'Data');
id = handles.number;
ax=handles.Zoom;

handles.allData(id).name = {name};
handles.allData(id).nb = {nb};
handles.allData(id).descr = {descr};
handles.allData(id).nbEvents = {events};
newData = [oldData; [id , {name},{nb},{descr} ,{events},{ax(1)},{ax(2)},{ax(3)} ,{ax(4)}]];

% set (handles.ROI, 'Data',name,nb,descr);
% handles.ROI = newData;
% guidata(hObject,handles);
set(handles.ROI, 'Data',newData);
handles.nbEvents = str2num(events);
guidata(hObject,handles);
events_manage(hObject, eventdata, handles,id);


function events_manage(hObject, eventdata, handles,id)

allData = handles.allData;
nbEvents = handles.nbEvents;
set(handles.uitable8, 'Data', '');
for k=1:nbEvents
    prompt = {'Name event ','Shortkeys : '};
    dlg_title = ['Event n°:'  int2str(k)];
    num_lines = 1;
    defaultans = {['Event'  int2str(k)],int2str(k)};
    answers = inputdlg(prompt,dlg_title,num_lines,defaultans);
    [event,  shortkeys] = answers{:};
    oldData = get(handles.uitable8, 'Data');

    newData = [oldData; {event shortkeys}];
    
    allData(id).events{k} = {event shortkeys};
    allData(id).events{k}{3} = handles.data; % initialiser les tableaux avec des zeros pour les evenements
    set(handles.uitable8, 'Data', newData);
end
% disp('QQQQQQQQQQQQQQQ');
% disp(allData(1).events{3}{3});
handles.allData = allData;
guidata(hObject,handles);
%      disp(allData(1).ROI);
% --- Executes when selected cell(s) is changed in ROI.
function ROI_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to ROI (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
allData = handles.allData;
row = eventdata.Indices;
disp('row');
disp(row(1));

disp('selected_vals');
disp(row(1));
disp('selected_vals');
handles.selected_row = row(1);

row = row(1);
data=get(handles.ROI,'Data');

axa= data(row(1),6);
axb=data(row(1),7);
axc=data(row(1),8);
axd=data(row(1),9);
handles.Zoom =[ cell2mat(axa(1)), cell2mat(axb(1)), cell2mat(axc(1)), cell2mat(axd(1))]; 
guidata(hObject,handles);
slider_Callback(hObject, eventdata, handles);  
set_events(hObject, eventdata, handles,row);
allData = handles.allData;


function set_events(hObject, eventdata, handles,row)


set(handles.uitable8, 'Data', '');
allData = handles.allData;
nbEvents = allData(row).nbEvents;
nbEvents = str2double(nbEvents);
disp(nbEvents);
for k=1:nbEvents

    oldData = get(handles.uitable8, 'Data');
    newData = [oldData; {allData(row).events{k}{1} allData(row).events{k}{2}}];
    set(handles.uitable8, 'Data', newData);
end

%  newData = allData(row).events{3};
