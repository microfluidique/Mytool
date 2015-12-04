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

% Last Modified by GUIDE v2.5 04-Dec-2015 17:11:24

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
% eventdata  reserved - to be defined in a æfuture version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to myTool (see VARARGIN)

% Choose default command line output for myTool
handles.output = hObject;
handles.number = 0;
handles.allData= struct;
handles.pause = 0.0;
handles.openProject = 'no';
handles.contrastSlider = 0.0;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes myTool wait for user response (see UIRESUME)
% uiwait(handles.figure1);



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






% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
nbFrames = getappdata(handles.start , 'int');
ax=handles.Zoom; 
value  = get(handles.slider, 'Value');
if(strcmp(get(handles.start,'String'),'Start'))
    uiresume();
    set(handles.start,'String','Pause');
    for k=value:nbFrames
        img=read(handles.videoObject,k);
        img = imadjust(img, stretchlim(img, handles.contrastSlider), [0 1]);
        img= imcrop(img, [ax(1),ax(3),ax(2)-ax(1),ax(4)-ax(3)]);

        axes(handles.axes1);
        imshow(img);
        drawnow;
        set(handles.nbFrame, 'String', round(k));
        set(handles.slider,'Value', k); 
        pause(handles.pause);
      
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

videoObject = handles.videoObject;

value  = get(handles.slider, 'Value');

img=read(videoObject,value);
img = imadjust(img, stretchlim(img, handles.contrastSlider), [0 1]);

axes(handles.axes1);

set(handles.nbFrame, 'String',round(value));
% disp(handles.Zoom);
% 
% 
% if(isempty(handles.Zoom)) 
%      moi = 'fff';
% else

ax=handles.Zoom; 

img= imcrop(img, [ax(1),ax(3),ax(2)-ax(1),ax(4)-ax(3)]);
imshow(img);
drawnow;
   




function nbFrame_Callback(hObject, eventdata, handles)
% hObject    handle to nbFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nbFrame as text
%        str2double(get(hObject,'String')) returns contents of nbFrame as a double


value = str2double(get(hObject,'String'));
set(handles.slider,'Value', value);
guidata(hObject,handles);
slider_Callback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function video_Callback(hObject, eventdata, handles)
% hObject    handle to video (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%answer = inputdlg('fffff')
if (strcmp(handles.openProject ,'yes'))
    handles.videoPathSaved
   input_video_file =  handles.videoPathSaved;
else
    [ video_file_name,video_file_path ] = uigetfile({'*.*'},'Pick a video file');      %;*.png;*.yuv;*.bmp;*.tif'},'Pick a file');
    input_video_file = [video_file_path,video_file_name];

end


% if(input_video_file == 0)
%     return;
% end

set(handles.path,'String',input_video_file);
% Acquiring video
videoObject = VideoReader(input_video_file);
% Display first frame
img = read(videoObject,1);
 img = imadjust(img, stretchlim(img, handles.contrastSlider), [0 1]);
axes(handles.axes1);
imshow(img);
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
handles.nbFrames = nbFrames;
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

handles.originalZoom = zoom;
guidata(hObject,handles);
% --- Executes on button press in bud.

function event_Callback(hObject, eventdata, handles,event_number ,selected_row_roi )
set(handles.uitable1 ,'visible','on');
allData = handles.allData;
%allData(selected_row_roi).events{event_number}{3} = {table};
value  = get(handles.slider, 'Value');
set_table_last_events(hObject, eventdata, handles,event_number ,selected_row_roi,value  );


if allData(selected_row_roi).events{event_number}{3}(round(value)) == 1
    allData(selected_row_roi).events{event_number}{3}(round(value)) = 0;
    
else
    allData(selected_row_roi).events{event_number}{3}(round(value)) = 1;
  

end
handles.allData = allData;
guidata(hObject,handles);
  set_table_event(hObject, eventdata, handles,selected_row_roi,event_number);
plot_drawing(hObject, eventdata, handles,event_number, selected_row_roi);

function plot_drawing(hObject, eventdata, handles,event_number ,selected_row_roi )

allData = handles.allData;
nbFrames = getappdata(handles.start , 'int');

x = [1:nbFrames];
nbEvents = allData(selected_row_roi).nbEvents;
nbEvents = str2double(nbEvents);
dataPlot= [];
legends= [];
for j=1:nbEvents
  dataPlot = [dataPlot allData(selected_row_roi).events{j}{3}];
  legends = [legends ; allData(selected_row_roi).events{j}{1} blanks(50 - length(allData(selected_row_roi).events{j}{1}))];

end


plot(handles.axes3, dataPlot);

tableX =[1:nbFrames];
tableX = transpose(tableX);
tableY = allData(selected_row_roi).events{event_number}{3};
x=tableX(~(tableY ==0));
y= tableY(~(tableY ==0));

text(x, y,num2str(x),'Parent', handles.axes3 , 'FontSize',7, 'Color' , 'red','FontWeight', 'normal' ,'BackgroundColor',[.7 .9 .7],'VerticalAlignment' , 'top','HorizontalAlignment','center','Margin',0.1);
legend(handles.axes3 , legends);

function set_table_last_events(hObject, eventdata, handles,event_number ,selected_row_roi, value  )
allData =  handles.allData;
oldData = get(handles.uitable1, 'Data');

if allData(selected_row_roi).events{event_number}{3}(round(value)) == 1
    allData(selected_row_roi).events{event_number}{3}(round(value)) = 0;
else
    allData(selected_row_roi).events{event_number}{3}(round(value)) = 1;
end
newData = [oldData; {selected_row_roi allData(selected_row_roi).events{event_number}{1} round(value) allData(selected_row_roi).events{event_number}{3}(round(value))}];

newDataExtract = newData(end-14:end, :) ; % 5 derniers elements

set (handles.uitable1, 'Data', newDataExtract);        
        
        
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
ax=handles.Zoom;
set(handles.slider,'Value', 1); 
set(handles.nbFrame, 'String',1);
img = read(handles.videoObject,1);
img = imadjust(img, stretchlim(img, handles.contrastSlider), [0 1]);

img= imcrop(img, [ax(1),ax(3),ax(2)-ax(1),ax(4)-ax(3)]);
axes(handles.axes1);
imshow(img);
drawnow;


% --- Executes on button press in last.
function last_Callback(hObject, eventdata, handles)
% hObject    handle to last (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ax=handles.Zoom;
set(handles.slider,'Value', inf); 
set(handles.nbFrame, 'String',inf);
img = read(handles.videoObject,inf);
img = imadjust(img, stretchlim(img, handles.contrastSlider), [0 1]);
img= imcrop(img, [ax(1),ax(3),ax(2)-ax(1),ax(4)-ax(3)]);
axes(handles.axes1);
imshow(img);
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
selected_row_roi  = handles.selected_row_roi  ; 

nbEvents = allData(selected_row_roi).nbEvents;
nbEvents = str2double(nbEvents);
for k=1:nbEvents
    if strcmp(eventdata.Key,allData(selected_row_roi).events{k}{2})
        event_Callback(hObject, eventdata, handles, k ,selected_row_roi );
    end
end

valueSlider  = get(handles.slider, 'Value');

 switch(eventdata.Key)
    case 'rightarrow'
    right_Callback(hObject, eventdata, handles);
        
    case 'leftarrow'
     left_Callback(hObject, eventdata, handles);
 end



% % valueSlider  = get(handles.slider, 'Value');
% % 
% %  switch(eventdata.Key)
% %     case 'rightarrow'
% % 
% % set(handles.slider,'Value',valueSlider+1);
% %         slider_Callback(hObject, eventdata, handles);
% %     case 'leftarrow'
% % 
% %       set(handles.slider,'Value',valueSlider-1);
% %         slider_Callback(hObject, eventdata, handles);
% %  end


% % --- Executes when selected cell(s) is changed in uitable1.
% function uitable1_CellSelectionCallback(hObject, eventdata, handles)
% % hObject    handle to uitable1 (see GCBO)
% % eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
% %	Indices: row and column indices of the cell(s) currently selecteds
% % handles    structure with handles and user data (see GUIDATA)
% data = get(hObject,'Data');
% indices = eventdata.Indices;
% r = indices(:,1);
% selected_vals = data(r);
% 
% set(handles.nbFrame, 'String',selected_vals);
% set(handles.slider,'Value', selected_vals);
% guidata(hObject, handles);
% slider_Callback(hObject, eventdata, handles);


% --------------------------------------------------------------------
function zoomTool_OnCallback(hObject, eventdata, handles)
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
      

     case 'No'
        uipushtool3_ClickedCallback(hObject, eventdata, handles)
end

%   set(handles.uitoggletool1, 'State', 'off');
% p=datacursormode(handles.axes3);
% set(p,'Enable','on');
% %% ensuite j'ai un caractère qui me permet de savoir si j'ai cliqué ou non puis
% set(p,'Enable','off');
% p = datacursormode(gcf);
% p.removeAllDataCursors;

% -------------------------------------------------------------------
function uipushtool3_ClickedCallback(hObject, eventdata, handles)
handles.Zoom = handles.originalZoom;
guidata(hObject,handles);
slider_Callback(hObject, eventdata, handles);   

function ROI_informations(hObject, eventdata, handles)

Answers = inputdlg({'ROI Name?',...
            'Number of cells followed?','Number of events ?', 'Description?'},'ROI informations', [1 1 1 3]);
[name, nb,events,  descr] = Answers{:};
set(handles.ROI ,'visible','on');
oldData = get(handles.ROI, 'Data');
id = handles.number;
ax=handles.Zoom;

handles.allData(id).name = {name};
handles.allData(id).nb = {nb};
handles.allData(id).descr = {descr};
handles.allData(id).nbEvents = {events};
newData = [oldData; [id , {name},{nb},{descr} ,{events},{ax(1)},{ax(2)},{ax(3)} ,{ax(4)}]];
handles.selected_row_roi=id;
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
set(handles.uitable8 ,'visible','on');
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
 
handles.allData = allData;
guidata(hObject,handles);


% --- Executes when selected cell(s) is changed in ROI.
function ROI_CellSelectionCallback(hObject, eventdata, handles)
allData = handles.allData;
row = eventdata.Indices;
handles.selected_row_roi = row(1);
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
plot_drawing(hObject, eventdata, handles,1 ,row );

function set_events(hObject, eventdata, handles,row)


set(handles.uitable8, 'Data', '');
allData = handles.allData;
nbEvents = allData(row).nbEvents;
nbEvents = str2double(nbEvents);

for k=1:nbEvents

    oldData = get(handles.uitable8, 'Data');
    newData = [oldData; {allData(row).events{k}{1} allData(row).events{k}{2}}];
    set(handles.uitable8, 'Data', newData);
end

%  newData = allData(row).events{3};

% 
% % --- Executes on button press in forward.
% function forward_Callback(hObject, eventdata, handles)
% % hObject    handle to forward (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% handles.pause = handles.pause - 0.1;
% 
% if(handles.pause < 0)
%     handles.pause = 0.0;
% end
% set(handles.start,'String','Start');
% guidata(hObject,handles);
% start_Callback(hObject, eventdata, handles);
% 
% % --- Executes on button press in rewind.
% function rewind_Callback(hObject, eventdata, handles)
% % hObject    handle to rewind (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% 
% handles.pause = handles.pause + 0.1;
% if(handles.pause > 1.0)
%     handles.pause = 1.0;
% end
% 
%     set(handles.start,'String','Start');
% guidata(hObject,handles);
% start_Callback(hObject, eventdata, handles);
% 


% --- Executes on button press in export.
function export_Callback(hObject, eventdata, handles)
allData = handles.allData;
selected_row_roi  = handles.selected_row_roi  ; 
nbEvents = allData(selected_row_roi).nbEvents;
nbEvents = str2double(nbEvents);
newData = [];

for k=1:nbEvents
    newData = [newData,  allData(selected_row_roi).events{k}{3} ];
 
end
date = datestr(now,'_dd-mm-yy_HH:MM');
folder_name = uigetdir('./results','save csv file');
filename = [folder_name , '/export_',allData(selected_row_roi).name,date,'.csv'];
filename = [filename{1},filename{2},filename{3},filename{4}] ;
csvwrite(filename , newData);
msgbox('File exported !!');




% --------------------------------------------------------------------
function Quit_Callback(hObject, eventdata, handles)
delete(handles.figure1) ;


% --- Executes on button press in right.
function right_Callback(hObject, eventdata, handles)
value  = get(handles.slider, 'Value');
set(handles.slider,'Value', value+1); 
guidata(hObject,handles);

slider_Callback(hObject, eventdata, handles);

% --- Executes on button press in right.
function left_Callback(hObject, eventdata, handles)
value  = get(handles.slider, 'Value');
set(handles.slider,'Value', value-1); 
guidata(hObject,handles);

slider_Callback(hObject, eventdata, handles);


% --- Executes on slider movement.
function sliderSpeed_Callback(hObject, eventdata, handles)
value  = get(handles.sliderSpeed, 'Value');
handles.pause = (1-value);
guidata(hObject,handles);
set(handles.start,'String','Pause');
start_Callback(hObject, eventdata, handles);



% --------------------------------------------------------------------
function save_Callback(hObject, eventdata, handles)
allData = handles.allData;
answer = inputdlg('Enter your name project (without spaces)');
[name] = answer{:};
folder_name = uigetdir('./results','Save project');
filename = [folder_name,'/',name,'.mat' ];
valueSlider  = get(handles.slider, 'Value');
valueSlider = round(valueSlider);
videoObject = handles.videoObject;
nbFrames = handles.nbFrames;
zoom = handles.Zoom;
dataRoiTable=get(handles.ROI,'Data');
dataEventsTable=get(handles.uitable8,'Data');
dataHistoryTable=get(handles.uitable1,'Data');
save(filename,'allData', 'valueSlider' , 'videoObject', 'zoom','dataRoiTable', 'dataEventsTable','dataHistoryTable','nbFrames');

function open_Callback(hObject, eventdata, handles)
[ file_name,folder_name ] = uigetfile({'*.*'},'Select your file ')
path_file = [folder_name,file_name];
path_file
loadMatFile = load(path_file,'allData',  'valueSlider' , 'videoObject', 'zoom','dataRoiTable', 'dataEventsTable','dataHistoryTable' ,'nbFrames');
handles.openProject = 'yes';
videoPath = [loadMatFile.videoObject.Path, '/' , loadMatFile.videoObject.Name];
handles.videoPathSaved =videoPath;
handles.Zoom = loadMatFile.zoom;
handles.nbFrames = loadMatFile.nbFrames;
handles.allData = loadMatFile.allData;
videoObject = VideoReader(videoPath);
handles.videoObject = videoObject;
guidata(hObject,handles);
video_Callback(hObject, eventdata, handles);
value = loadMatFile.valueSlider;
set(handles.slider,'Value', value); 
guidata(hObject,handles);
slider_Callback(hObject, eventdata, handles);
set(handles.ROI ,'visible','on');
set(handles.ROI, 'Data',loadMatFile.dataRoiTable);
set(handles.uitable8 ,'visible','on');
set(handles.uitable8, 'Data',loadMatFile.dataEventsTable);
set(handles.uitable1 ,'visible','on');
set(handles.uitable1, 'Data',loadMatFile.dataHistoryTable);


function new_Callback(hObject, eventdata, handles)
close(gcbf);
myTool;


% --- Executes when selected cell(s) is changed in uitable8.
function uitable8_CellSelectionCallback(hObject, eventdata, handles)
row = eventdata.Indices;
selected_row_event = row(1);
handles.selected_row_event =selected_row_event;



selected_row_roi  = handles.selected_row_roi ;
guidata(hObject,handles);

set_table_event(hObject, eventdata, handles,selected_row_roi,selected_row_event);

function set_table_event(hObject, eventdata, handles,selected_row_roi,selected_row_event)

set(handles.events ,'visible','on');
set(handles.eventTxt ,'visible','on');

nbFrames = handles.nbFrames ;
images =[1:nbFrames];
images = transpose(images);
allData = handles.allData;

nameROI = allData(selected_row_roi).name;
nameEvent = allData(selected_row_roi).events{selected_row_event}{1};
dataEvent = [images allData(selected_row_roi).events{selected_row_event}{3}];

indices = find(dataEvent(:,2)==0);
dataEvent(indices,:) = [];


set(handles.events, 'Data', dataEvent);
set(handles.eventTxt, 'String', nameEvent);


% --- Executes when selected cell(s) is changed in events.
function events_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to events (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
indice = eventdata.Indices;
indice = indice(1);

selected_row_roi  = handles.selected_row_roi ;

selected_row_event = handles.selected_row_event;
% % 
images=get(handles.events,'Data');
image = images(indice);
set(handles.slider,'Value', image); 
guidata(hObject,handles);
slider_Callback(hObject, eventdata, handles);


% --------------------------------------------------------------------
function contrast_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to contrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% hObject    handle to contrastSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
state = get(handles.textContrast,'Visible');
if(strcmp(state, 'off'))
    set(handles.textContrast,'Visible','on');
    set(handles. sliderContrast,'Visible', 'on'); 
else
    set(handles.textContrast,'Visible','off');
    set(handles. sliderContrast,'Visible', 'off'); 
end


% --- Executes on slider movement.
function sliderContrast_Callback(hObject, eventdata, handles)
% hObject    handle to sliderContrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
T =[get(hObject, 'Value'), 1];
handles.contrastSlider = T;
guidata(hObject, handles);
slider_Callback(hObject, eventdata, handles);
