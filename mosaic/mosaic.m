function varargout = mosaic(varargin)
% MOSAIC M-file for mosaic.fig
%      MOSAIC, by itself, creates a new MOSAIC or raises the existing
%      singleton*.
%
%      H = MOSAIC returns the handle to a new MOSAIC or the handle to
%      the existing singleton*.
%
%      MOSAIC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MOSAIC.M with the given input arguments.
%
%      MOSAIC('Property','Value',...) creates a new MOSAIC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mosaic_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mosaic_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% 1. What type of images would reproduce an image well? 
% 2. How many images do we need? 
% 3. What most effectively contributes to the aesthetic value of the recreated image? 
% 4. What is the best way to select the correct tiles? 
% 5. How big does our photomosaic have to be so the tiles are still recognizeable? 
% 6. How do we reduce computation time?
%
% Daniel Claxton 06-10-2005
% dclaxton@ufl.edu
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Last Modified by GUIDE v2.5 12-Jun-2005 16:27:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mosaic_OpeningFcn, ...
                   'gui_OutputFcn',  @mosaic_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before mosaic is made visible.
function mosaic_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mosaic (see VARARGIN)

% Choose default command line output for mosaic
handles.output = hObject;

handles.MenuSave=uipushtool('CData',saveIcon,...
    'Separator','off',...
    'ToolTipString','Save Photomosaic',...
    'enable','on',...
    'ClickedCallback','mosaic(''save_pushbutton_Callback'',gcbo,3,guidata(gcbo))',...
    'Tag','MenuSave');
handles.MenuClear=uipushtool('CData',clearIcon,...
    'Separator','off',...
    'ToolTipString','Clear Memory',...
    'enable','on',...
    'ClickedCallback','mosaic(''clear_pushbutton_Callback'',gcbo,3,guidata(gcbo))',...
    'Tag','MenuClear');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mosaic wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = mosaic_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function clear_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to save_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.final = [];


% --- Executes on button press in save_pushbutton.
function save_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to save_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    img = handles.final;
    if isempty(img),
        return
    end
catch
    return
end
[filename, pathname, filterindex] = uiputfile( ...
       {'*.bmp',  'Bitmap (*.bmp)'; ...
        '*.jpg','Joint Photographic Experts Group (*.jpg)'; ...
        '*.png','Portable Network Graphics files (*.png)'; ...
        '*.tif','TIFF imges (*.tif)'; ...        
        '*.*',  'All Files (*.*)'}, ...
        'Save as');
[pathstr,name,ext,versn] = fileparts(filename);
fullpath = [pathname name];
    
switch filterindex,
    case 1,
        imwrite(img,[fullpath '.bmp'],'bmp');
    case 2,
        qual = jpegqual;
        imwrite(img,[fullpath '.jpg'],'jpg','quality',qual);
    case 3,
        imwrite(img,[fullpath '.png'],'png');
    case 4,
        imwrite(img,[fullpath '.tif'],'tif');
    case 5,
        imwrite(img,[fullpath 'bmp'],'bmp');
        qual = jpegqual;
        imwrite(img,[fullpath '.jpg'],'jpg','quality',qual);
        imwrite(img,[fullpath '.png'],'png');
        imwrite(img,[fullpath '.tif'],'tif');
end


function qual = jpegqual,
prompt={'Enter Jpeg Quality (0-100)'};
def={'75'};
dlgTitle='JPEG Compression Quality';
lineNo=1;
answer=inputdlg(prompt,dlgTitle,lineNo,def);
if isempty(answer),
    answer = 75;
end
qual = str2num(cell2mat(answer));


% --- Executes during object creation, after setting all properties.
function tile_dir_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tile_dir_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function tile_dir_edit_Callback(hObject, eventdata, handles)
% hObject    handle to tile_dir_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tile_dir_edit as text
%        str2double(get(hObject,'String')) returns contents of tile_dir_edit as a double
dbdir = get(hObject,'string');
db = dir(dbdir);
dblist = {db.name}';
if dblist,
    set(handles.selected_listbox,'string',dblist);
end

% --- Executes during object creation, after setting all properties.
function base_image_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to base_image_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function base_image_edit_Callback(hObject, eventdata, handles)
% hObject    handle to base_image_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of base_image_edit as text
%        str2double(get(hObject,'String')) returns contents of base_image_edit as a double


% --- Executes on button press in browse_tiles_push.
function browse_tiles_push_Callback(hObject, eventdata, handles)
% hObject    handle to browse_tiles_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[pathstr,name,ext,versn] = fileparts(get(handles.tile_dir_edit,'string'));
if isempty(pathstr),
    dbdir = uigetdir('--','Select an Image database');
else
    dbdir = uigetdir([pathstr '\' name],'Select an Image database');
end

if dbdir,
    set(handles.tile_dir_edit,'string',dbdir);
    db = dir(dbdir);
    dblist = {db.name}';    
    set(handles.selected_listbox,'string',dblist);
end

% --- Executes on button press in browse_base_push.
function browse_base_push_Callback(hObject, eventdata, handles)
% hObject    handle to browse_base_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[pathstr,name,ext,versn] = fileparts(get(handles.base_image_edit,'string'));
if ~isempty(pathstr),
    pathstr = [pathstr '\'];
end
[file,path] = uigetfile([pathstr '*.jpg'],'Select a base image');

% if dbdir,
try
    set(handles.base_image_edit,'string',[path file]);
    info = imfinfo([path file]);
    set(handles.width_edit,'string',info.Width);
    set(handles.height_edit,'string',info.Height);
    imshow([path file])
    h = gca;
    title('');
    set(h,'box','on')
catch
end
% end

% --- Executes during object creation, after setting all properties.
function selected_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selected_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in selected_listbox.
function selected_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to selected_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns selected_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from selected_listbox



function width_edit_Callback(hObject, eventdata, handles)
% hObject    handle to width_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of width_edit as text
%        str2double(get(hObject,'String')) returns contents of width_edit as a double


% --- Executes during object creation, after setting all properties.
function height_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to height_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function height_edit_Callback(hObject, eventdata, handles)
% hObject    handle to height_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of height_edit as text
%        str2double(get(hObject,'String')) returns contents of height_edit as a double


% --- Executes during object creation, after setting all properties.
function width_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to width_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in start_pushbutton.
function start_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to start_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.final = [];
handles.final = mkmosaic(handles);
guidata(hObject,handles);


%==========================================================================
%==========================================================================
%==========================================================================

function out = mkmosaic(handles)
warning off
% Get Variables
dbdir = get(handles.tile_dir_edit,'string');
baseim = get(handles.base_image_edit,'string');
img = imfinfo(baseim);
nx = str2num(get(handles.width_edit,'string'))/img.Width;
ny = str2num(get(handles.height_edit,'string'))/img.Height;
r = str2num(get(handles.radius_edit,'string'));
cc = get(handles.color_slider,'value');

db = dir(dbdir);                                        %
dblist = {db.name}';                                    %
pause(.05);
[data,tdim] = imsort(dblist,dbdir);                     % Process and rank image tiles
pause(.05);
workbar(0,'Loading Base Image','Progress');
baseimg = imread(baseim);                               % Read Base Image
[base,dx,dy] = basegrid(baseimg,tdim(2)/nx,tdim(1)/ny); % Divide base image into average color grid
order = randperm(length(base));                         % Random order of cell placement
match = imatch(baseimg,dx,dy,base,data,r,handles);      % Pick best tiles
numused = length(match);
numunique = length(unique(match));
tiles = {data.img};
try
    mos = imassem(baseimg,tiles(match),base,dx,dy,cc);  % Assemble tiles into large image
catch
    out = baseim;
    return
end
% bscale = imresize(baseimg,[size(mos,1),size(mos,2)]);  % Scale base image 
mix = get(handles.blend_slider,'value');
if mix,
    workbar(.99,'Post Processing','Progress');
    out = imfade(mos,imresize(baseimg,[size(mos,1),size(mos,2)]),mix);  % Blend Base image with mosaic
    workbar(1,'Post Processing','Progress');
else 
    out = mos;
end
figure('numbertitle','off','name',['Photomosaic: ' num2str(numunique) '/' num2str(numused)]);
title(['Unique/Total: ' num2str(numunique) '/' num2str(numused)]);
imshow(out);


function rgb = imavg(img),
for i=1:3,
    rgb(i) = mean(mean(img(:,:,i)));
end
rgb = rgb/255;


function [db2,tdim] = imsort(files,tiledir),

if isdb(tiledir),    
    answer=questdlg('Would you like to use cached thumbnails?', ...
        'Thumnails Found', ...
        'Yes','No','Yes');
    if strcmp(answer,'Yes'),
        pause(.05);
        workbar(0,'Loading cached tiles','Progress');
        load([tiledir '\db.mat']);
        return
    end
end

n = size(files,1);
k = 1;
for i=1:n,
    file = [tiledir '\' char(files(i,:))];
    [pathstr,name,ext,versn] = fileparts(file);
    if isimg(ext(2:end)),
        img = imread([pathstr '\' name ext]);
        db(k).name = [file];
        db(k).avg = imavg(img);
        db(k).score = clrdist(db(k).avg,[200 50 0]);    % Need to figure out sorting filter
        db(k).img = img;
        parts = imparts(img,3,3);
        for j=1:9,
            db(k).parts{j} = imavg(parts{j});
        end
        if k==1,
            tdim = size(img);
        end
        k = k+1;
    end
    workbar(i/n,[name ext],'Loading & Sorting Tile Images') 
end
[x,ind] = sort(cell2mat({db.score}));
for i=1:length(db),
    db2(i).score = db(ind(i)).score;
    db2(i).img = db(ind(i)).img;
    db2(i).name = db(ind(i)).name;
    db2(i).avg = db(ind(i)).avg;
    db2(i).parts = db(ind(i)).parts;
end
answer=questdlg('Would you like to save current database?', ...
        'Save Database', ...
        'Yes','No','Yes');
    if strcmp(answer,'Yes'),
        save([tiledir '\db'],'db2','tdim');   
    end


function out = isimg(ext),
formats = ['bmp';'jpg';'tif';'png';'gif';'cur';'ico'];
out = any(sum(ismember(formats,ext)') == 3);


function out = imparts(img,nx,ny),
x = size(img,2);
y = size(img,1);
w = round(linspace(1,x,nx+1));
h = round(linspace(1,y,ny+1));
k=1;
for i=1:length(h)-1,
    for j=1:length(w)-1,
        out{k} = img(h(i):h(i+1),w(j):w(j+1),:);
        k = k+1;
    end
end


function d = clrdist(a,b),
d = sqrt(sum((a-b).^2));


function [base,dx,dy] = basegrid(baseimg,tilex,tiley),
basex = size(baseimg,2);
basey = size(baseimg,1);

dx = round(basex/tilex);
dy = round(basey/tiley);
remx = mod(basex,tilex);
remy = mod(basey,tiley);



% w = round(linspace(1,basex,dx));
% h = round(linspace(1,basey,dy));
grid = imparts(baseimg,dx,dy);
for i=1:length(grid),
    base(i).avg = imavg(grid{i});
    subpart = imparts(grid{i},3,3);
    for j=1:9,
        base(i).parts{j} = imavg(subpart{j});
    end
    workbar(i/length(grid),'Partitioning Base Image','Progress');
end

% avgx = mean(diff(dx));
% avgy = mean(diff(dy));


function imdiff(img,base),



function img = imtweek(img,rgb);
n = round(rgb*255);
for i=1:3,
    img(:,:,i) = imadd(img(:,:,i),n(i));
end


function imgtotal = imassem(img,tiles,base,nx,ny,cc),
x = size(img,2);
y = size(img,1);
w = round(linspace(1,x,nx+1));
h = round(linspace(1,y,ny+1));
k=1;
imgtotal = [];
imgy = length(h)-1;
imgx = length(w)-1;
for i=1:imgy,
    hline = [];
    for j=1:imgx,
        ratio = cc;
        colordiff = base(k).avg - imavg(tiles{k});
        temp = imtweek(tiles{k},colordiff*ratio);
%         out(h(i):h(i+1),w(j):w(j+1),:) = tiles{k};
        hline = cat(2,hline,temp);
        k = k+1;
    end
    imgtotal = cat(1,imgtotal,hline);
    workbar(i/imgy,'Postprocessing','Progress')
end



function out = isdb(tiledir),
a = what(tiledir);
try
    db = char(a.mat);
    if strcmp(db,'db.mat'),
        out = 1;
    else
        out = 0;
    end
catch
    out = 0;
end


function c = colorad(a,b),
c = sqrt(sum(sum(sum(a-b,1)).^2));


function c = colormag(a),
c = sqrt(sum(sum(sum(a,1)).^2));


function out = rgbsort(rgblist),

for i=1:length(rgblist),
    m = 1; n = 1; o = 1; p = 1;
    [xx,ind] = max(rgblist(i,:));
    nunique = length(unique(rgblist(i,:)));
    
    if nunique == 3;
        % If r g b all have unique values
        switch ind,
            case 1, % Red Dominent
                r(m,:) = [rgblist(i,:) colormag(rgblist(i,:))];
                m = m+1;
            case 2, % Green Dominent
                g(n,:) = [rgblist(i,:) colormag(rgblist(i,:))];
                n = n+1;
            case 3, % Blue Dominent
                b(o,:) = [rgblist(i,:) colormag(rgblist(i,:))];
                o = o+1;
        end
    else
        % If two or more rgb values are not unique
        x(p,:) = [rgblist(i,:) colormag(rgblist(i,:))];
        p = p+1;
    end
end

% Sort all colors
[rx,ri] = sort(r(:,4));
[gx,gi] = sort(g(:,4));
[bx,bi] = sort(b(:,4));
[xx,xi] = sort(x(:,4));

r = r(ri,1:3);
g = g(gi,1:3);
b = b(bi,1:3);
x = x(xi,1:3);

out = [r; g; b; x];





function match = imatch(baseimg,nx,ny,base,data,r,handles),
aa = {data.parts};
bb = {base.parts};
x = size(baseimg,2);
y = size(baseimg,1);
w = round(linspace(1,x,nx+1));
h = round(linspace(1,y,ny+1));
imgy = length(h)-1;
imgx = length(w)-1;
match = ones(imgy,imgx)*nan;
for i=1:length(base),
    b = formatcell(bb{i});
    for j=1:length(data),
        a = formatcell(aa{j});
        poss(i,j) = colorad(a,b);
    end
%     [xx,ind] = min(poss(i,:));
%     match(i) = ind;
    [xx,ind] = sort(poss(i,:));
    [ii,jj] = findind(match,i);
    k = 1;
    temp = ind(k);
    while isnear(match,ind(k),[ii,jj],r) ,  
        k = k+1;
        if k > length(ind)-1,
            %  If no matter what, we're near another like tile, randomly chose
            %  one of the top 5 best choices
            rp = randperm(5);
            temp = ind(rp(1));
            break
        end
        temp = ind(k);          
    end
    match(i) = temp;
    % Test if current image is in close proximity to other images
    workbar(i/length(base),'Building Mosaic','Progress');
    if get(handles.cancel_pushbutton,'userdata');
        match = reshape(match,length(base),1);
        set(handles.cancel_pushbutton,'Userdata',0);
        workbar(1,'Cancelled','Progress')
        return
    end
    
end
match = reshape(match,length(base),1);


function [i,j] = findind(a,n),
b = zeros(size(a));
b(n) = 1;
[i,j] = find(b);


function out = isnear(a,val,pos,n),
y = pos(1);
x = pos(2);

if n >= x,
    n3 = x-1;
else
    n3 = n;
end
if n >= y,
    n1 = y-1;
else
    n1 = n;
end
if n + x > size(a,2),
    n4 = size(a,2)-x;
else
    n4 = n;
end
if n + y > size(a,1),
    n2 = size(a,1)-y;
else
    n2 = n;
end
b = a(y-n1:y+n2,x-n3:x+n4);
out = sum(sum(b == val));



function rgb = formatcell(a),
bb = cell2mat(a);
bb = reshape(bb,3,3,3);
r = [bb(1,:,1); bb(1,:,2); bb(1,:,3)];
g = [bb(2,:,1); bb(2,:,2); bb(2,:,3)];
b = [bb(3,:,1); bb(3,:,2); bb(3,:,3)];
rgb(:,:,1) = r;
rgb(:,:,2) = g;
rgb(:,:,3) = b;




% --- Executes during object creation, after setting all properties.
function radius_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to radius_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function radius_edit_Callback(hObject, eventdata, handles)
% hObject    handle to radius_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of radius_edit as text
%        str2double(get(hObject,'String')) returns contents of radius_edit as a double


% --- Executes on button press in cancel_pushbutton.
function cancel_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to cancel_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cancel_pushbutton
 click = get(hObject,'Userdata');
 click = abs(click - 1);
 set(hObject,'Userdata',click);
 guidata(hObject,handles);


% --- Executes on button press in color_check.
function color_check_Callback(hObject, eventdata, handles)
% hObject    handle to color_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of color_check




function si  = saveIcon,

si(:,:,1) = [NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN;
NaN	0	0	0	0	0	0	0	0	0	0	0	0	0	0	NaN;
NaN	0	0	0	0.90588	0.90588	0.90588	0.90588	0.90588	0.90588	0.90588	0.90588	0	0.48235	0	NaN;
NaN	0	0	0	0.90588	0.90588	0.90588	0.90588	0.90588	0.90588	0.90588	0.90588	0	0	0	NaN;
NaN	0	0	0	0.90588	0.90588	0.90588	0.90588	0.90588	0.90588	0.90588	0.90588	0	0	0	NaN;
NaN	0	0	0	0.90588	0.90588	0.90588	0.90588	0.90588	0.90588	0.90588	0.90588	0	0	0	NaN;
NaN	0	0	0	0.90588	0.90588	0.90588	0.90588	0.90588	0.90588	0.90588	0.90588	0	0	0	NaN;
NaN	0	0	0	0.90588	0.90588	0.90588	0.90588	0.90588	0.90588	0.90588	0.90588	0	0	0	NaN;
NaN	0	0	0	0	0	0	0	0	0	0	0	0	0	0	NaN;
NaN	0	0	0	0	0	0	0	0	0	0	0	0	0	0	NaN;
NaN	0	0	0	0	0	0	0	0	0	0	0	0	0	0	NaN;
NaN	0	0	0	0	0	0	0	0	0	0.90588	0.90588	0	0	0	NaN;
NaN	0	0	0	0	0	0	0	0	0	0.90588	0.90588	0	0	0	NaN;
NaN	0	0	0	0	0	0	0	0	0	0.90588	0.90588	0	0	0	NaN;
NaN	NaN	0	0	0	0	0	0	0	0	0	0	0	0	0	NaN;
NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN];

si(:,:,2) = [NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN;
NaN	0	0	0	0	0	0	0	0	0	0	0	0	0	0	NaN;
NaN	0	0.60392	0	0.87451	0.87451	0.87451	0.87451	0.87451	0.87451	0.87451	0.87451	0	0.4902	0	NaN;
NaN	0	0.60392	0	0.87451	0.87451	0.87451	0.87451	0.87451	0.87451	0.87451	0.87451	0	0	0	NaN;
NaN	0	0.60392	0	0.87451	0.87451	0.87451	0.87451	0.87451	0.87451	0.87451	0.87451	0	0.60392	0	NaN;
NaN	0	0.60392	0	0.87451	0.87451	0.87451	0.87451	0.87451	0.87451	0.87451	0.87451	0	0.60392	0	NaN;
NaN	0	0.60392	0	0.87451	0.87451	0.87451	0.87451	0.87451	0.87451	0.87451	0.87451	0	0.60392	0	NaN;
NaN	0	0.60392	0	0.87451	0.87451	0.87451	0.87451	0.87451	0.87451	0.87451	0.87451	0	0.60392	0	NaN;
NaN	0	0.60392	0.60392	0	0	0	0	0	0	0	0	0.60392	0.60392	0	NaN;
NaN	0	0.60392	0.60392	0.60392	0.60392	0.60392	0.60392	0.60392	0.60392	0.60392	0.60392	0.60392	0.60392	0	NaN;
NaN	0	0.60392	0.60392	0	0	0	0	0	0	0	0	0	0.60392	0	NaN;
NaN	0	0.60392	0.60392	0	0	0	0	0	0	0.87451	0.87451	0	0.60392	0	NaN;
NaN	0	0.60392	0.60392	0	0	0	0	0	0	0.87451	0.87451	0	0.60392	0	NaN;
NaN	0	0.60392	0.60392	0	0	0	0	0	0	0.87451	0.87451	0	0.60392	0	NaN;
NaN	NaN	0	0	0	0	0	0	0	0	0	0	0	0	0	NaN;
NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN];

si(:,:,3) = [NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN;
NaN	0	0	0	0	0	0	0	0	0	0	0	0	0	0	NaN;
NaN	0	1	0	0.87059	0.87059	0.87059	0.87059	0.87059	0.87059	0.87059	0.87059	0	0.48235	0	NaN;
NaN	0	1	0	0.87059	0.87059	0.87059	0.87059	0.87059	0.87059	0.87059	0.87059	0	0	0	NaN;
NaN	0	1	0	0.87059	0.87059	0.87059	0.87059	0.87059	0.87059	0.87059	0.87059	0	1	0	NaN;
NaN	0	1	0	0.87059	0.87059	0.87059	0.87059	0.87059	0.87059	0.87059	0.87059	0	1	0	NaN;
NaN	0	1	0	0.87059	0.87059	0.87059	0.87059	0.87059	0.87059	0.87059	0.87059	0	1	0	NaN;
NaN	0	1	0	0.87059	0.87059	0.87059	0.87059	0.87059	0.87059	0.87059	0.87059	0	1	0	NaN;
NaN	0	1	1	0	0	0	0	0	0	0	0	1	1	0	NaN;
NaN	0	1	1	1	1	1	1	1	1	1	1	1	1	0	NaN;
NaN	0	1	1	0	0	0	0	0	0	0	0	0	1	0	NaN;
NaN	0	1	1	0	0	0	0	0	0	0.87059	0.87059	0	1	0	NaN;
NaN	0	1	1	0	0	0	0	0	0	0.87059	0.87059	0	1	0	NaN;
NaN	0	1	1	0	0	0	0	0	0	0.87059	0.87059	0	1	0	NaN;
NaN	NaN	0	0	0	0	0	0	0	0	0	0	0	0	0	NaN;
NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN];


function ci = clearIcon,
ci(:,:,1) = [NaN	NaN	NaN	NaN	NaN	NaN	NaN	0	0	NaN	NaN	NaN	NaN	NaN	NaN	NaN;
NaN	NaN	NaN	0	0	NaN	0	0.86275	0.86275	0	NaN	0	0	NaN	NaN	NaN;
NaN	NaN	0	0.86275	0.62745	0	0.62745	0.76471	0.76471	0.62745	0	0.62745	0.86275	0	NaN	NaN;
NaN	NaN	0	0.62745	0.86275	0.50196	0.62745	1	1	0.62745	0.50196	0.86275	0.62745	0	NaN	NaN;
NaN	NaN	NaN	0	0.50196	1	1	1	1	1	1	0.50196	0	NaN	NaN	NaN;
NaN	0	0	0.86275	0.62745	1	1	0.50196	0.50196	1	1	0.62745	0.86275	0	0	NaN;
0	0.86275	0.76471	0.62745	1	1	1	0.62745	0.62745	1	1	1	0.62745	0.76471	0.86275	0;
0	0.50196	0.62745	0.86275	0.50196	1	1	1	1	1	1	0.50196	0.86275	0.62745	0.50196	0;
NaN	0	0.3451	0.3451	0.86275	0.50196	1	1	1	1	0.50196	0.86275	0.3451	0.3451	0	NaN;
NaN	NaN	0	0.50196	0.76471	0.86275	0.86275	0.50196	0.50196	0.86275	0.86275	0.76471	0.50196	0	NaN	NaN;
NaN	0	0.62745	1	0.50196	0.3451	0.50196	0.86275	0.86275	0.50196	0.3451	0.50196	1	0.62745	0	NaN;
NaN	0	0.86275	0.62745	0.3451	0	0	0.62745	0.62745	0	0	0.3451	0.62745	0.86275	0	NaN;
NaN	NaN	0	0	0	NaN	0	0.86275	1	0	NaN	0	0	0	NaN	NaN;
NaN	NaN	NaN	NaN	NaN	NaN	0	0.3451	0.50196	0	NaN	NaN	NaN	NaN	NaN	NaN;
NaN	NaN	NaN	NaN	NaN	NaN	NaN	0	0	NaN	NaN	NaN	NaN	NaN	NaN	NaN];

ci(:,:,2) = [NaN	NaN	NaN	NaN	NaN	NaN	NaN	0	0	NaN	NaN	NaN	NaN	NaN	NaN	NaN;
NaN	NaN	NaN	0	0	NaN	0	0.86275	0.86275	0	NaN	0	0	NaN	NaN	NaN;
NaN	NaN	0	0.86275	0.62745	0	0.62745	0.76471	0.76471	0.62745	0	0.62745	0.86275	0	NaN	NaN;
NaN	NaN	0	0.62745	0.86275	0.50196	0.62745	0.65882	0.65882	0.62745	0.50196	0.86275	0.62745	0	NaN	NaN;
NaN	NaN	NaN	0	0.50196	0.65882	0.65882	0.86275	0.65882	0.86275	0.65882	0.50196	0	NaN	NaN	NaN;
NaN	0	0	0.86275	0.62745	0.65882	0.86275	0.50196	0.50196	0.65882	0.86275	0.62745	0.86275	0	0	NaN;
0	0.86275	0.76471	0.62745	0.65882	0.86275	0.65882	0.62745	0.62745	0.86275	1	0.65882	0.62745	0.76471	0.86275	0;
0	0.50196	0.62745	0.86275	0.50196	0.86275	1	0.86275	0.86275	1	1	0.50196	0.86275	0.62745	0.50196	0;
NaN	0	0.3451	0.3451	0.86275	0.50196	0.86275	1	1	0.86275	0.50196	0.86275	0.3451	0.3451	0	NaN;
NaN	NaN	0	0.50196	0.76471	0.86275	0.86275	0.50196	0.50196	0.86275	0.86275	0.76471	0.50196	0	NaN	NaN;
NaN	0	0.62745	1	0.50196	0.3451	0.50196	0.86275	0.86275	0.50196	0.3451	0.50196	1	0.62745	0	NaN;
NaN	0	0.86275	0.62745	0.3451	0	0	0.62745	0.62745	0	0	0.3451	0.62745	0.86275	0	NaN;
NaN	NaN	0	0	0	NaN	0	0.86275	1	0	NaN	0	0	0	NaN	NaN;
NaN	NaN	NaN	NaN	NaN	NaN	0	0.3451	0.50196	0	NaN	NaN	NaN	NaN	NaN	NaN;
NaN	NaN	NaN	NaN	NaN	NaN	NaN	0	0	NaN	NaN	NaN	NaN	NaN	NaN	NaN];

ci(:,:,3) = [NaN	NaN	NaN	NaN	NaN	NaN	NaN	0	0	NaN	NaN	NaN	NaN	NaN	NaN	NaN;
NaN	NaN	NaN	0	0	NaN	0	0.86275	0.86275	0	NaN	0	0	NaN	NaN	NaN;
NaN	NaN	0	0.86275	0.62745	0	0.62745	0.76471	0.76471	0.62745	0	0.62745	0.86275	0	NaN	NaN;
NaN	NaN	0	0.62745	0.86275	0.50196	0.62745	0.3451	0.3451	0.62745	0.50196	0.86275	0.62745	0	NaN	NaN;
NaN	NaN	NaN	0	0.50196	0.3451	0.3451	0.65882	0.3451	0.65882	0.3451	0.50196	0	NaN	NaN	NaN;
NaN	0	0	0.86275	0.62745	0.3451	0.65882	0.50196	0.50196	0.3451	0.65882	0.62745	0.86275	0	0	NaN;
0	0.86275	0.76471	0.62745	0.3451	0.65882	0.3451	0.62745	0.62745	0.65882	0.75294	0.3451	0.62745	0.76471	0.86275	0;
0	0.50196	0.62745	0.86275	0.50196	0.65882	0.75294	0.65882	0.65882	1	0.75294	0.50196	0.86275	0.62745	0.50196	0;
NaN	0	0.3451	0.3451	0.86275	0.50196	0.65882	0.75294	1	0.65882	0.50196	0.86275	0.3451	0.3451	0	NaN;
NaN	NaN	0	0.50196	0.76471	0.86275	0.86275	0.50196	0.50196	0.86275	0.86275	0.76471	0.50196	0	NaN	NaN;
NaN	0	0.62745	1	0.50196	0.3451	0.50196	0.86275	0.86275	0.50196	0.3451	0.50196	1	0.62745	0	NaN;
NaN	0	0.86275	0.62745	0.3451	0	0	0.62745	0.62745	0	0	0.3451	0.62745	0.86275	0	NaN;
NaN	NaN	0	0	0	NaN	0	0.86275	1	0	NaN	0	0	0	NaN	NaN;
NaN	NaN	NaN	NaN	NaN	NaN	0	0.3451	0.50196	0	NaN	NaN	NaN	NaN	NaN	NaN;
NaN	NaN	NaN	NaN	NaN	NaN	NaN	0	0	NaN	NaN	NaN	NaN	NaN	NaN	NaN];





function workbar(fractiondone, message, progtitle)
% WORKBAR Graphically monitors progress of calculations
%   WORKBAR(X) creates and displays the workbar with the fractional length
%   "X". It is an alternative to the built-in matlab function WAITBAR,
%   Featuring:
%       - Doesn't slow down calculations
%       - Stylish progress look
%       - Requires only a single line of code
%       - Displays time remaining
%       - Display time complete
%       - Capable of title and description
%       - Only one workbar can exist (avoids clutter)
%
%   WORKBAR(X, MESSAGE) sets the fractional length of the workbar as well as
%   setting a message in the workbar window.
%
%   WORKBAR(X, MESSAGE, TITLE) sets the fractional length of the workbar,
%   message and title of the workbar window.
%
%   WORKBAR is typically used inside a FOR loop that performs a lengthy 
%   computation.  A sample usage is shown below:
% 
%   for i = 1:10000
%       % Calculation
%       workbar(i/10000,'Performing Calclations...','Progress') 
%   end
%
%   Another example:
%
%   for i = 1:10000
%         % Calculation
%         if i < 2000,
%              workbar(i/10000,'Performing Calclations (Step 1)...','Step 1') 
%         elseif i < 4000
%              workbar(i/10000,'Performing Calclations (Step 2)...','Step 2')
% 	    elseif i < 6000
%              workbar(i/10000,'Performing Calclations (Step 3)...','Step 3')
%         elseif i < 8000
%              workbar(i/10000,'Performing Calclations (Step 4)...','Step 4')
%         else
%              workbar(i/10000,'Performing Calclations (Step 5)...','Step 5')
%         end
%     end
%
% See also: WAITBAR, TIMEBAR, PROGRESSBAR

% Adapted from: 
% Chad English's TIMEBAR
% and Steve Hoelzer's PROGRESSBAR
%
% Created by:
% Daniel Claxton
%
% Last Modified: 3-17-05


persistent progfig progpatch starttime lastupdate text 

% Set defaults for variables not passed in
if nargin < 1,
    fractiondone = 0;
end

try
    % Access progfig to see if it exists ('try' will fail if it doesn't)
    dummy = get(progfig,'UserData');
    
    % If progress bar needs to be reset, close figure and set handle to empty
    if fractiondone == 0
        delete(progfig) % Close progress bar
        progfig = []; % Set to empty so a new progress bar is created
    end
catch
    progfig = []; % Set to empty so a new progress bar is created
end

if nargin < 2 & isempty(progfig),
    message = '';
end
if nargin < 3 & isempty(progfig),
    progtitle = '';
end

% If task completed, close figure and clear vars, then exit
percentdone = floor(100*fractiondone);
if percentdone == 100 % Task completed
    delete(progfig) % Close progress bar
    clear progfig progpatch starttime lastupdate % Clear persistent vars
    return
end

% Create new progress bar if needed
if isempty(progfig)
    
    
    %%%%%%%%%% SET WINDOW SIZE AND POSITION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    winwidth = 300;                                         % Width of timebar window
    winheight = 75;                                         % Height of timebar window
    screensize = get(0,'screensize');                       % User's screen size [1 1 width height]
    screenwidth = screensize(3);                            % User's screen width
    screenheight = screensize(4);                           % User's screen height
    winpos = [0.5*(screenwidth-winwidth), ...
            0.5*(screenheight-winheight),...
            winwidth, winheight];                           % Position of timebar window origin
    wincolor = [ 0.9254901960784314,...
            0.9137254901960784,...
            0.8470588235294118 ];                           % Define window color
    est_text = 'Estimated time remaining: ';                % Set static estimated time text
    pgx = [0 0];
    pgy = [41 43];
    pgw = [57 57];
    pgh = [0 -3];
    m = 1;
    %%%%%%%% END SET WINDOW SIZE AND POSITION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     
     % Initialize progress bar
    progfig = figure('menubar','none',...                   % Turn figure menu display off
         'numbertitle','off',...                            % Turn figure numbering off
         'position',winpos,...                              % Set the position of the figure as above
         'color',wincolor,...                               % Set the figure color
         'resize','off',...                                 % Turn of figure resizing
         'tag','timebar');                                  % Tag the figure for later checking
    
    work.progtitle = progtitle;                             % Store initial values for title
    work.message = message;                                 % Store initial value for message
    set(progfig,'userdata',work);                           % Save text in figure's userdata

     
    axes('parent',progfig,...                               % Set the progress bar parent to the figure
        'units','pixels',...                                % Provide axes units in pixels
        'pos',[10 winheight-45 winwidth-50 15],...          % Set the progress bar position and size
        'xlim',[0 1],...                                    % Set the range from 0 to 1
        'visible','off',...                                 % Turn off axes
        'drawmode','fast');                                 % Draw faster (I dunno if this matters)
    
    imshow(progimage(m));                                   % Set Progress Bar Image
    
    progaxes = axes('parent',progfig,...                    % Set the progress bar parent to the figure
        'units','pixels',...                                % Provide axes units in pixels
        'pos',[14-pgx(m) winheight-pgy(m) winwidth-pgw(m) 7-pgh(m)],...   % Set the progress bar position and size
        'xlim',[0 1],...                                    % Set the range from 0 to 1
        'visible','off');                                   % Turn off axes

    progpatch = patch(...
        'XData',            [1 0 0 1],...                   % Initialize X-coordinates for patch
        'YData',            [0 0 1 1],...                   % Initialize Y-coordinates for patch
        'Facecolor',        'w',...                         % Set Color of patch
        'EraseMode',        'normal',...                    % Set Erase mode, so we can see progress image
        'edgecolor',        'none');                        % Set the edge color of the patch to none
    
    text(1) = uicontrol(progfig,'style','text',...          % Prepare message text (set the style to text)
        'pos',[10 winheight-30 winwidth-20 20],...          % Set the textbox position and size
        'hor','left',...                                    % Center the text in the textbox
        'backgroundcolor',wincolor,...                      % Set the textbox background color
        'foregroundcolor',0*[1 1 1],...                     % Set the text color
        'string',message);                                  % Set the text to the input message
    
    text(2) = uicontrol(progfig,'style','text',...          % Prepare static estimated time text
        'pos',[10 5 winwidth-20 20],...                     % Set the textbox position and size
        'hor','left',...                                    % Left align the text in the textbox
        'backgroundcolor',wincolor,...                      % Set the textbox background color
        'foregroundcolor',0*[1 1 1],...                     % Set the text color
        'string',est_text);                                 % Set the static text for estimated time
    
    text(3) = uicontrol(progfig,'style','text',...          % Prepare estimated time
        'pos',[135 5 winwidth-145 20],...                   % Set the textbox position and size
        'hor','left',...                                    % Left align the text in the textbox
        'backgroundcolor',wincolor,...                      % Set the textbox background color
        'foregroundcolor',0*[1 1 1],...                     % Set the text color
        'string','');                                       % Initialize the estimated time as blank
    
    text(4) = uicontrol(progfig,'style','text',...          % Prepare the percentage progress
        'pos',[winwidth-35 winheight-50 25 20],...          % Set the textbox position and size
        'hor','right',...                                   % Left align the text in the textbox
        'backgroundcolor',wincolor,...                      % Set the textbox background color
        'foregroundcolor',0*[1 1 1],...                     % Set the textbox foreground color
        'string','');                                       % Initialize the progress text as blank
        
    % Set time of last update to ensure a redraw
    lastupdate = clock - 1;
    
    % Task starting time reference
    if isempty(starttime) | (fractiondone == 0)
        starttime = clock;
    end
    
end

set(progfig,'HandleVisibility','off');                      % Modification (thanks ben mitch)

% Enforce a minimum time interval between updates
if etime(clock,lastupdate) < 0.01
    return
end

% Update progress patch
n = [.02857 ];
set(progpatch,'XData',[1 n(1)*round(fractiondone/n(1)) n(1)*round(fractiondone/n(1)) 1])

% Set all dynamic text
runtime = etime(clock,starttime);
if ~fractiondone,
    fractiondone = 0.001;
end
work = get(progfig,'userdata');
try progtitle;
catch
    progtitle = work.progtitle;
end
try message;
catch
    message = work.message;
end
timeleft = runtime/fractiondone - runtime;
timeleftstr = sec2timestr(timeleft);
titlebarstr = sprintf('%2d%%  %s',percentdone,progtitle);
set(progfig,'Name',titlebarstr)
set(text(1),'string',message);
set(text(3),'string',timeleftstr);
set(text(4),'string',[num2str(percentdone) ' %']);

% Force redraw to show changes
drawnow

% Record time of this update
lastupdate = clock;






% ------------------------------------------------------------------------------
function timestr = sec2timestr(sec)

% Convert seconds to hh:mm:ss
h = floor(sec/3600); % Hours
sec = sec - h*3600;
m = floor(sec/60); % Minutes
sec = sec - m*60;
s = floor(sec); % Seconds

if isnan(sec),
    h = 0;
    m = 0;
    s = 0;
end

if h < 10; h0 = '0'; else h0 = '';end     % Put leading zero on hours if < 10
if m < 10; m0 = '0'; else m0 = '';end     % Put leading zero on minutes if < 10
if s < 10; s0 = '0'; else s0 = '';end     % Put leading zero on seconds if < 10
timestr = strcat(h0,num2str(h),':',m0,...
          num2str(m),':',s0,num2str(s));



function a=progimage(m),

if m == 1,
    
    a(:,:,1) = [... 
            157	163	126	102	115	105	106	100	102	105	102	110	104	108	104	106	101	103	107	106	105	101	102	101	101	103	107	106	105	101	102	101	101	103	107	106	105	101	102	101	101	103	107	106	105	101	102	101	101	103	107	106	105	101	102	101	101	103	107	106	105	101	102	101	101	103	107	106	105	101	102	101	101	103	107	106	105	101	102	101	101	103	107	106	105	101	102	101	101	103	107	106	105	101	102	101	101	103	107	106	105	101	102	101	101	103	107	106	105	101	102	101	101	103	107	106	105	101	102	101	101	103	107	106	104	101	102	102	104	105	108	108	107	102	104	102	101	103	107	106	105	101	102	101	101	103	107	106	105	101	102	101	101	103	107	106	105	101	102	101	101	103	107	106	105	101	102	101	101	103	107	106	105	101	102	101	101	103	107	106	105	101	102	101	109	105	109	109	106	102	104	102	102	103	106	105	105	102	104	101	102	103	106	105	105	102	104	101	102	103	106	105	105	102	104	101	102	103	106	105	105	102	104	101	102	103	106	105	105	102	104	101	102	103	106	105	105	102	104	101	102	103	106	105	105	102	104	101	102	103	106	105	105	102	104	101	102	103	106	105	105	102	104	101	102	103	106	105	105	102	104	101	101	98	103	105	100	101	110	105	103	105	105	82	126;...
            147	125	187	187	191	197	202	188	194	206	191	194	199	202	190	200	194	201	193	190	203	199	193	200	194	201	193	190	203	199	193	200	194	201	193	190	203	199	193	200	194	201	193	190	203	199	193	200	194	201	193	190	203	199	193	200	194	201	193	190	203	199	193	200	194	201	193	190	203	199	193	200	194	201	193	190	203	199	193	200	194	201	193	190	203	199	193	200	194	201	193	190	203	199	193	200	194	201	193	190	203	199	193	200	194	201	193	190	203	199	193	200	194	201	193	190	203	199	193	200	194	202	193	190	202	199	193	201	197	205	197	193	205	201	195	202	194	201	193	190	203	199	193	200	194	201	193	190	203	199	193	200	194	201	193	190	203	199	193	200	194	201	193	190	203	199	193	200	194	201	193	190	203	199	193	200	194	201	193	190	203	199	193	200	196	197	194	190	195	195	193	193	192	200	191	187	199	196	191	197	192	200	191	187	199	196	191	197	192	200	191	187	199	196	191	197	192	200	191	187	199	196	191	197	192	200	191	187	199	196	191	197	192	200	191	187	199	196	191	197	192	200	191	187	199	196	191	197	192	200	191	187	199	196	191	197	192	200	191	187	199	196	191	197	192	200	191	187	199	196	191	197	196	195	192	191	193	193	193	193	194	193	191	86	115;...
            119	181	193	227	225	219	223	213	223	235	240	241	228	229	213	227	221	232	242	237	232	228	219	231	221	232	242	237	232	228	219	231	221	232	242	237	232	228	219	231	221	232	242	237	232	228	219	231	221	232	242	237	232	228	219	231	221	232	242	237	232	228	219	231	221	232	242	237	232	228	219	231	221	232	242	237	232	228	219	231	221	232	242	237	232	228	219	231	221	232	242	237	232	228	219	231	221	232	242	237	232	228	219	231	221	232	242	237	232	228	219	231	221	232	242	237	232	228	219	231	221	232	242	237	232	228	219	231	221	232	242	237	233	227	219	229	221	232	242	237	232	228	219	231	221	232	242	237	232	228	219	231	221	232	242	237	232	228	219	231	221	232	242	237	232	228	219	231	221	232	242	237	232	228	219	231	221	232	242	237	232	228	219	231	222	227	235	227	220	222	220	224	223	233	241	236	231	229	220	231	223	233	241	236	231	229	220	231	223	233	241	236	231	229	220	231	223	233	241	236	231	229	220	231	223	233	241	236	231	229	220	231	223	233	241	236	231	229	220	231	223	233	241	236	231	229	220	231	223	233	241	236	231	229	220	231	223	233	241	236	231	229	220	231	223	233	241	236	231	229	220	231	230	231	245	240	227	219	212	215	221	235	247	162	106;...
            111	182	240	223	182	163	163	163	174	181	251	254	176	176	169	175	175	181	255	250	181	176	174	177	175	181	255	250	181	176	174	177	175	181	255	250	181	176	174	177	175	181	255	250	181	176	174	177	175	181	255	250	181	176	174	177	175	181	255	250	181	176	174	177	175	181	255	250	181	176	174	177	175	181	255	250	181	176	174	177	175	181	255	250	181	176	174	177	175	181	255	250	181	176	174	177	175	181	255	250	181	176	174	177	175	181	255	250	181	176	174	177	175	181	255	250	181	176	174	177	175	181	255	251	182	176	174	176	175	181	255	251	181	176	173	176	175	181	255	250	181	176	174	177	175	181	255	250	181	176	174	177	175	181	255	250	181	176	174	177	175	181	255	250	181	176	174	177	175	181	255	250	181	176	174	177	175	181	255	250	181	176	174	177	170	174	237	235	176	178	177	181	178	182	254	251	184	180	179	181	178	182	254	251	184	180	179	181	178	182	254	251	184	180	179	181	178	182	254	251	184	180	179	181	178	182	254	251	184	180	179	181	178	182	254	251	184	180	179	181	178	182	254	251	184	180	179	181	178	182	254	251	184	180	179	181	178	182	254	251	184	180	179	181	178	182	254	251	184	180	179	181	181	185	255	250	181	167	156	159	184	217	236	227	96;...
            100	182	245	236	133	102	95	99	102	105	252	255	106	106	105	104	108	107	255	255	112	103	108	103	108	107	255	255	112	103	108	103	108	107	255	255	112	103	108	103	108	107	255	255	112	103	108	103	108	107	255	255	112	103	108	103	108	107	255	255	112	103	108	103	108	107	255	255	112	103	108	103	108	107	255	255	112	103	108	103	108	107	255	255	112	103	108	103	108	107	255	255	112	103	108	103	108	107	255	255	112	103	108	103	108	107	255	255	112	103	108	103	108	107	255	255	112	103	108	103	107	107	255	255	113	103	107	102	109	108	255	255	114	104	108	104	108	107	255	255	112	103	108	103	108	107	255	255	112	103	108	103	108	107	255	255	112	103	108	103	108	107	255	255	112	103	108	103	108	107	255	255	112	103	108	103	108	107	255	255	112	103	108	103	108	108	245	250	116	107	108	102	107	106	255	254	112	105	110	103	107	106	255	254	112	105	110	103	107	106	255	254	112	105	110	103	107	106	255	254	112	105	110	103	107	106	255	254	112	105	110	103	107	106	255	254	112	105	110	103	107	106	255	254	112	105	110	103	107	106	255	254	112	105	110	103	107	106	255	254	112	105	110	103	107	106	255	254	112	105	110	103	106	108	255	247	110	95	90	90	115	158	238	226	100;...
            101	181	233	230	103	58	59	57	55	57	252	255	62	63	59	58	62	59	255	254	66	58	61	57	62	59	255	254	66	58	61	57	62	59	255	254	66	58	61	57	62	59	255	254	66	58	61	57	62	59	255	254	66	58	61	57	62	59	255	254	66	58	61	57	62	59	255	254	66	58	61	57	62	59	255	254	66	58	61	57	62	59	255	254	66	58	61	57	62	59	255	254	66	58	61	57	62	59	255	254	66	58	61	57	62	59	255	254	66	58	61	57	62	59	255	254	66	58	61	57	61	59	255	254	66	58	61	57	61	58	255	253	65	58	59	54	62	59	255	254	66	58	61	57	62	59	255	254	66	58	61	57	62	59	255	254	66	58	61	57	62	59	255	254	66	58	61	57	62	59	255	254	66	58	61	57	62	59	255	254	66	58	61	57	63	59	246	254	71	61	61	58	61	57	255	252	65	58	59	54	61	57	255	252	65	58	59	54	61	57	255	252	65	58	59	54	61	57	255	252	65	58	59	54	61	57	255	252	65	58	59	54	61	57	255	252	65	58	59	54	61	57	255	252	65	58	59	54	61	57	255	252	65	58	59	54	61	57	255	252	65	58	59	54	61	57	255	252	65	58	59	54	59	55	255	243	63	54	54	54	72	154	236	219	109;...
            99	184	236	222	94	55	49	58	46	44	253	253	46	49	45	45	47	43	255	250	50	46	45	44	47	43	255	250	50	46	45	44	47	43	255	250	50	46	45	44	47	43	255	250	50	46	45	44	47	43	255	250	50	46	45	44	47	43	255	250	50	46	45	44	47	43	255	250	50	46	45	44	47	43	255	250	50	46	45	44	47	43	255	250	50	46	45	44	47	43	255	250	50	46	45	44	47	43	255	250	50	46	45	44	47	43	255	250	50	46	45	44	47	43	255	250	50	46	45	44	48	43	255	250	50	46	46	44	48	43	255	250	51	45	46	44	47	43	255	250	50	46	45	44	47	43	255	250	50	46	45	44	47	43	255	250	50	46	45	44	47	43	255	250	50	46	45	44	47	43	255	250	50	46	45	44	47	43	255	250	50	46	45	44	47	44	242	249	54	44	46	46	49	45	255	252	51	46	48	44	49	45	255	252	51	46	48	44	49	45	255	252	51	46	48	44	49	45	255	252	51	46	48	44	49	45	255	252	51	46	48	44	49	45	255	252	51	46	48	44	49	45	255	252	51	46	48	44	49	45	255	252	51	46	48	44	49	45	255	252	51	46	48	44	49	45	255	252	51	46	48	44	50	43	255	237	49	47	49	55	69	166	238	221	108;...
            115	181	229	230	92	63	58	57	55	50	254	254	47	50	45	46	50	44	255	249	51	49	51	49	50	44	255	249	51	49	51	49	50	44	255	249	51	49	51	49	50	44	255	249	51	49	51	49	50	44	255	249	51	49	51	49	50	44	255	249	51	49	51	49	50	44	255	249	51	49	51	49	50	44	255	249	51	49	51	49	50	44	255	249	51	49	51	49	50	44	255	249	51	49	51	49	50	44	255	249	51	49	51	49	50	44	255	249	51	49	51	49	50	44	255	249	51	49	51	49	51	44	255	249	51	49	51	49	50	43	255	248	50	49	50	48	50	44	255	249	51	49	51	49	50	44	255	249	51	49	51	49	50	44	255	249	51	49	51	49	50	44	255	249	51	49	51	49	50	44	255	249	51	49	51	49	50	44	255	249	51	49	51	49	45	47	238	244	57	51	47	50	52	46	255	251	51	50	51	49	52	46	255	251	51	50	51	49	52	46	255	251	51	50	51	49	52	46	255	251	51	50	51	49	52	46	255	251	51	50	51	49	52	46	255	251	51	50	51	49	52	46	255	251	51	50	51	49	52	46	255	251	51	50	51	49	52	46	255	251	51	50	51	49	52	46	255	251	51	50	51	49	55	51	255	232	49	50	50	65	79	175	243	215	115;...
            107	175	243	239	123	81	71	67	59	62	255	252	70	60	63	58	61	62	255	252	70	60	61	55	61	62	255	252	70	60	61	55	61	62	255	252	70	60	61	55	61	62	255	252	70	60	61	55	61	62	255	252	70	60	61	55	61	62	255	252	70	60	61	55	61	62	255	252	70	60	61	55	61	62	255	252	70	60	61	55	61	62	255	252	70	60	61	55	61	62	255	252	70	60	61	55	61	62	255	252	70	60	61	55	61	62	255	252	70	60	61	55	61	62	255	252	70	60	61	55	60	61	255	252	70	60	61	56	62	63	255	252	71	61	61	56	61	62	255	252	70	60	61	55	61	62	255	252	70	60	61	55	61	62	255	252	70	60	61	55	61	62	255	252	70	60	61	55	61	62	255	252	70	60	61	55	61	62	255	252	70	60	61	55	57	68	240	248	78	60	56	62	61	62	255	252	71	61	61	56	61	62	255	252	71	61	61	56	61	62	255	252	71	61	61	56	61	62	255	252	71	61	61	56	61	62	255	252	71	61	61	56	61	62	255	252	71	61	61	56	61	62	255	252	71	61	61	56	61	62	255	252	71	61	61	56	61	62	255	252	71	61	61	56	61	62	255	252	71	61	61	56	59	65	254	242	65	54	60	69	85	166	243	220	110;...
            104	183	236	247	164	125	112	104	116	110	255	255	118	116	121	113	118	110	255	254	118	116	119	113	118	110	255	254	118	116	119	113	118	110	255	254	118	116	119	113	118	110	255	254	118	116	119	113	118	110	255	254	118	116	119	113	118	110	255	254	118	116	119	113	118	110	255	254	118	116	119	113	118	110	255	254	118	116	119	113	118	110	255	254	118	116	119	113	118	110	255	254	118	116	119	113	118	110	255	254	118	116	119	113	118	110	255	254	118	116	119	113	118	110	255	254	118	116	119	113	119	111	255	255	118	116	119	113	118	110	255	254	118	116	119	112	118	110	255	254	118	116	119	113	118	110	255	254	118	116	119	113	118	110	255	254	118	116	119	113	118	110	255	254	118	116	119	113	118	110	255	254	118	116	119	113	118	110	255	254	118	116	119	113	117	116	236	254	118	116	121	114	118	109	255	254	118	116	119	112	118	109	255	254	118	116	119	112	118	109	255	254	118	116	119	112	118	109	255	254	118	116	119	112	118	109	255	254	118	116	119	112	118	109	255	254	118	116	119	112	118	109	255	254	118	116	119	112	118	109	255	254	118	116	119	112	118	109	255	254	118	116	119	112	118	109	255	254	118	116	119	112	111	118	255	247	122	111	107	116	150	166	253	228	106;...
            128	187	242	237	246	242	255	255	255	254	253	254	248	252	254	250	255	254	253	254	248	252	254	248	255	254	253	254	248	252	254	248	255	254	253	254	248	252	254	248	255	254	253	254	248	252	254	248	255	254	253	254	248	252	254	248	255	254	253	254	248	252	254	248	255	254	253	254	248	252	254	248	255	254	253	254	248	252	254	248	255	254	253	254	248	252	254	248	255	254	253	254	248	252	254	248	255	254	253	254	248	252	254	248	255	254	253	254	248	252	254	248	255	254	253	254	248	252	254	248	255	254	254	254	248	252	253	248	255	254	254	254	249	252	254	249	255	254	253	254	248	252	254	248	255	254	253	254	248	252	254	248	255	254	253	254	248	252	254	248	255	254	253	254	248	252	254	248	255	254	253	254	248	252	254	248	255	254	253	254	248	252	254	248	255	255	239	238	252	249	249	252	255	254	253	254	248	252	254	248	255	254	253	254	248	252	254	248	255	254	253	254	248	252	254	248	255	254	253	254	248	252	254	248	255	254	253	254	248	252	254	248	255	254	253	254	248	252	254	248	255	254	253	254	248	252	254	248	255	254	253	254	248	252	254	248	255	254	253	254	248	252	254	248	255	254	253	254	248	252	254	248	255	251	255	255	249	244	239	232	228	240	233	236	113;...
            169	125	235	236	237	246	240	232	235	242	235	242	240	237	247	241	237	242	234	242	241	237	247	241	237	242	234	242	241	237	247	241	237	242	234	242	241	237	247	241	237	242	234	242	241	237	247	241	237	242	234	242	241	237	247	241	237	242	234	242	241	237	247	241	237	242	234	242	241	237	247	241	237	242	234	242	241	237	247	241	237	242	234	242	241	237	247	241	237	242	234	242	241	237	247	241	237	242	234	242	241	237	247	241	237	242	234	242	241	237	247	241	237	242	234	242	241	237	247	241	236	241	234	242	240	237	247	241	236	241	234	241	240	236	246	239	237	242	234	242	241	237	247	241	237	242	234	242	241	237	247	241	237	242	234	242	241	237	247	241	237	242	234	242	241	237	247	241	237	242	234	242	241	237	247	241	237	242	234	242	241	237	247	241	232	239	231	236	243	242	242	242	237	242	235	242	241	237	247	241	237	242	235	242	241	237	247	241	237	242	235	242	241	237	247	241	237	242	235	242	241	237	247	241	237	242	235	242	241	237	247	241	237	242	235	242	241	237	247	241	237	242	235	242	241	237	247	241	237	242	235	242	241	237	247	241	237	242	235	242	241	237	247	241	237	242	235	242	241	237	247	241	235	247	236	238	244	231	238	241	235	239	242	112	175;...
            76	121	113	110	107	110	110	114	110	117	111	118	116	112	123	117	113	117	110	118	116	113	123	116	113	117	110	118	116	113	123	116	113	117	110	118	116	113	123	116	113	117	110	118	116	113	123	116	113	117	110	118	116	113	123	116	113	117	110	118	116	113	123	116	113	117	110	118	116	113	123	116	113	117	110	118	116	113	123	116	113	117	110	118	116	113	123	116	113	117	110	118	116	113	123	116	113	117	110	118	116	113	123	116	113	117	110	118	116	113	123	116	113	117	110	118	116	113	123	116	112	117	110	118	116	113	123	117	115	119	112	119	118	114	124	117	113	117	110	118	116	113	123	116	113	117	110	118	116	113	123	116	113	117	110	118	116	113	123	116	113	117	110	118	116	113	123	116	113	117	110	118	116	113	123	116	113	117	110	118	116	113	123	116	118	123	112	113	118	116	117	117	112	116	109	117	115	112	122	115	112	116	109	117	115	112	122	115	112	116	109	117	115	112	122	115	112	116	109	117	115	112	122	115	112	116	109	117	115	112	122	115	112	116	109	117	115	112	122	115	112	116	109	117	115	112	122	115	112	116	109	117	115	112	122	115	112	116	109	117	115	112	122	115	112	116	109	117	115	112	122	115	110	122	111	112	119	106	113	116	116	102	115	164	124];
    
    a(:,:,2) = [...
            241	210	130	106	105	105	104	111	112	104	112	106	106	104	109	104	110	103	110	107	105	108	109	108	110	103	110	107	105	108	109	108	110	103	110	107	105	108	109	108	110	103	110	107	105	108	109	108	110	103	110	107	105	108	109	108	110	103	110	107	105	108	109	108	110	103	110	107	105	108	109	108	110	103	110	107	105	108	109	108	110	103	110	107	105	108	109	108	110	103	110	107	105	108	109	108	110	103	110	107	105	108	109	108	110	103	110	107	105	108	109	108	110	103	110	107	105	108	109	108	109	103	109	108	104	107	110	109	110	103	111	109	105	107	108	107	110	103	110	107	105	108	109	108	110	103	110	107	105	108	109	108	110	103	110	107	105	108	109	108	110	103	110	107	105	108	109	108	110	103	110	107	105	108	109	108	110	103	110	107	105	108	109	108	108	104	108	104	106	106	105	108	108	102	108	107	105	108	110	105	108	102	108	107	105	108	110	105	108	102	108	107	105	108	110	105	108	102	108	107	105	108	110	105	108	102	108	107	105	108	110	105	108	102	108	107	105	108	110	105	108	102	108	107	105	108	110	105	108	102	108	107	105	108	110	105	108	102	108	107	105	108	110	105	108	102	108	107	105	108	110	105	107	105	108	105	106	107	103	104	108	106	105	143	222;...
            196	154	189	195	187	198	197	197	197	196	195	192	199	193	197	195	197	196	195	194	197	196	195	195	197	196	195	194	197	196	195	195	197	196	195	194	197	196	195	195	197	196	195	194	197	196	195	195	197	196	195	194	197	196	195	195	197	196	195	194	197	196	195	195	197	196	195	194	197	196	195	195	197	196	195	194	197	196	195	195	197	196	195	194	197	196	195	195	197	196	195	194	197	196	195	195	197	196	195	194	197	196	195	195	197	196	195	194	197	196	195	195	197	196	195	194	197	196	195	195	196	198	194	194	196	195	196	196	200	199	198	197	199	198	197	197	197	196	195	194	197	196	195	195	197	196	195	194	197	196	195	195	197	196	195	194	197	196	195	195	197	196	195	194	197	196	195	195	197	196	195	194	197	196	195	195	197	196	195	194	197	196	195	195	195	197	194	193	195	194	194	193	194	194	191	192	193	192	193	191	194	194	191	192	193	192	193	191	194	194	191	192	193	192	193	191	194	194	191	192	193	192	193	191	194	194	191	192	193	192	193	191	194	194	191	192	193	192	193	191	194	194	191	192	193	192	193	191	194	194	191	192	193	192	193	191	194	194	191	192	193	192	193	191	194	194	191	192	193	192	193	191	193	192	193	193	194	194	194	194	194	189	184	134	192;...
            132	191	192	237	238	236	233	236	234	237	241	241	240	232	238	235	236	240	240	243	238	233	235	232	236	240	240	243	238	233	235	232	236	240	240	243	238	233	235	232	236	240	240	243	238	233	235	232	236	240	240	243	238	233	235	232	236	240	240	243	238	233	235	232	236	240	240	243	238	233	235	232	236	240	240	243	238	233	235	232	236	240	240	243	238	233	235	232	236	240	240	243	238	233	235	232	236	240	240	243	238	233	235	232	236	240	240	243	238	233	235	232	236	240	240	243	238	233	235	232	235	240	240	243	238	233	235	232	234	238	240	243	236	232	233	230	236	240	240	243	238	233	235	232	236	240	240	243	238	233	235	232	236	240	240	243	238	233	235	232	236	240	240	243	238	233	235	232	236	240	240	243	238	233	235	232	236	240	240	243	238	233	235	232	235	241	237	237	234	235	238	232	235	241	241	242	236	232	235	233	235	241	241	242	236	232	235	233	235	241	241	242	236	232	235	233	235	241	241	242	236	232	235	233	235	241	241	242	236	232	235	233	235	241	241	242	236	232	235	233	235	241	241	242	236	232	235	233	235	241	241	242	236	232	235	233	235	241	241	242	236	232	235	233	235	241	241	242	236	232	235	233	235	236	241	245	238	234	238	236	233	238	237	191	154;...
            110	184	237	236	229	225	220	227	227	231	252	254	231	224	231	228	227	232	251	255	228	225	228	225	227	232	251	255	228	225	228	225	227	232	251	255	228	225	228	225	227	232	251	255	228	225	228	225	227	232	251	255	228	225	228	225	227	232	251	255	228	225	228	225	227	232	251	255	228	225	228	225	227	232	251	255	228	225	228	225	227	232	251	255	228	225	228	225	227	232	251	255	228	225	228	225	227	232	251	255	228	225	228	225	227	232	251	255	228	225	228	225	227	232	251	255	228	225	228	225	227	232	251	255	229	225	228	224	227	232	251	255	228	225	227	224	227	232	251	255	228	225	228	225	227	232	251	255	228	225	228	225	227	232	251	255	228	225	228	225	227	232	251	255	228	225	228	225	227	232	251	255	228	225	228	225	227	232	251	255	228	225	228	225	226	232	237	245	230	233	236	232	231	235	252	255	232	229	234	231	231	235	252	255	232	229	234	231	231	235	252	255	232	229	234	231	231	235	252	255	232	229	234	231	231	235	252	255	232	229	234	231	231	235	252	255	232	229	234	231	231	235	252	255	232	229	234	231	231	235	252	255	232	229	234	231	231	235	252	255	232	229	234	231	231	235	252	255	232	229	234	231	231	235	252	255	233	228	228	230	237	247	234	244	118;...
            106	187	241	254	218	218	210	217	217	220	255	254	218	215	216	218	216	220	254	255	216	216	217	218	216	220	254	255	216	216	217	218	216	220	254	255	216	216	217	218	216	220	254	255	216	216	217	218	216	220	254	255	216	216	217	218	216	220	254	255	216	216	217	218	216	220	254	255	216	216	217	218	216	220	254	255	216	216	217	218	216	220	254	255	216	216	217	218	216	220	254	255	216	216	217	218	216	220	254	255	216	216	217	218	216	220	254	255	216	216	217	218	216	220	254	255	216	216	217	218	215	220	254	255	217	217	215	217	217	221	254	255	218	217	217	219	216	220	254	255	216	216	217	218	216	220	254	255	216	216	217	218	216	220	254	255	216	216	217	218	216	220	254	255	216	216	217	218	216	220	254	255	216	216	217	218	216	220	254	255	216	216	217	218	219	220	242	253	218	220	218	216	217	221	253	255	219	219	218	220	217	221	253	255	219	219	218	220	217	221	253	255	219	219	218	220	217	221	253	255	219	219	218	220	217	221	253	255	219	219	218	220	217	221	253	255	219	219	218	220	217	221	253	255	219	219	218	220	217	221	253	255	219	219	218	220	217	221	253	255	219	219	218	220	217	221	253	255	219	219	218	220	219	220	254	252	218	215	212	216	221	220	250	238	106;...
            114	193	234	249	214	211	216	211	213	219	255	253	215	214	210	218	212	218	253	254	213	216	209	218	212	218	253	254	213	216	209	218	212	218	253	254	213	216	209	218	212	218	253	254	213	216	209	218	212	218	253	254	213	216	209	218	212	218	253	254	213	216	209	218	212	218	253	254	213	216	209	218	212	218	253	254	213	216	209	218	212	218	253	254	213	216	209	218	212	218	253	254	213	216	209	218	212	218	253	254	213	216	209	218	212	218	253	254	213	216	209	218	212	218	253	254	213	216	209	218	211	217	254	254	213	216	208	218	210	218	254	255	213	216	210	218	212	218	253	254	213	216	209	218	212	218	253	254	213	216	209	218	212	218	253	254	213	216	209	218	212	218	253	254	213	216	209	218	212	218	253	254	213	216	209	218	212	218	253	254	213	216	209	218	214	211	241	255	211	214	214	216	212	217	253	254	215	218	210	217	212	217	253	254	215	218	210	217	212	217	253	254	215	218	210	217	212	217	253	254	215	218	210	217	212	217	253	254	215	218	210	217	212	217	253	254	215	218	210	217	212	217	253	254	215	218	210	217	212	217	253	254	215	218	210	217	212	217	253	254	215	218	210	217	212	217	253	254	215	218	210	217	216	214	254	253	212	215	211	214	214	231	255	236	106;...
            104	196	242	245	214	215	212	217	210	215	253	253	213	213	210	215	209	217	249	254	210	213	209	216	209	217	249	254	210	213	209	216	209	217	249	254	210	213	209	216	209	217	249	254	210	213	209	216	209	217	249	254	210	213	209	216	209	217	249	254	210	213	209	216	209	217	249	254	210	213	209	216	209	217	249	254	210	213	209	216	209	217	249	254	210	213	209	216	209	217	249	254	210	213	209	216	209	217	249	254	210	213	209	216	209	217	249	254	210	213	209	216	209	217	249	254	210	213	209	216	210	216	251	254	210	214	209	216	210	217	251	255	211	215	210	215	209	217	249	254	210	213	209	216	209	217	249	254	210	213	209	216	209	217	249	254	210	213	209	216	209	217	249	254	210	213	209	216	209	217	249	254	210	213	209	216	209	217	249	254	210	213	209	216	214	212	237	255	207	210	212	213	209	216	253	255	211	215	208	215	209	216	253	255	211	215	208	215	209	216	253	255	211	215	208	215	209	216	253	255	211	215	208	215	209	216	253	255	211	215	208	215	209	216	253	255	211	215	208	215	209	216	253	255	211	215	208	215	209	216	253	255	211	215	208	215	209	216	253	255	211	215	208	215	209	216	253	255	211	215	208	215	212	212	254	255	211	215	213	214	215	236	252	241	101;...
            105	191	239	252	211	214	212	208	209	211	251	255	209	211	213	210	209	214	248	255	206	210	212	209	209	214	248	255	206	210	212	209	209	214	248	255	206	210	212	209	209	214	248	255	206	210	212	209	209	214	248	255	206	210	212	209	209	214	248	255	206	210	212	209	209	214	248	255	206	210	212	209	209	214	248	255	206	210	212	209	209	214	248	255	206	210	212	209	209	214	248	255	206	210	212	209	209	214	248	255	206	210	212	209	209	214	248	255	206	210	212	209	209	214	248	255	206	210	212	209	211	213	249	255	206	211	210	209	209	214	249	255	208	210	212	210	209	214	248	255	206	210	212	209	209	214	248	255	206	210	212	209	209	214	248	255	206	210	212	209	209	214	248	255	206	210	212	209	209	214	248	255	206	210	212	209	209	214	248	255	206	210	212	209	209	212	235	255	211	211	212	208	208	212	251	255	205	209	210	210	208	212	251	255	205	209	210	210	208	212	251	255	205	209	210	210	208	212	251	255	205	209	210	210	208	212	251	255	205	209	210	210	208	212	251	255	205	209	210	210	208	212	251	255	205	209	210	210	208	212	251	255	205	209	210	210	208	212	251	255	205	209	210	210	208	212	251	255	205	209	210	210	206	211	254	255	207	210	212	209	215	230	251	238	104;...
            108	192	238	250	215	220	210	212	213	214	255	255	209	213	213	213	213	214	255	255	208	213	214	212	213	214	255	255	208	213	214	212	213	214	255	255	208	213	214	212	213	214	255	255	208	213	214	212	213	214	255	255	208	213	214	212	213	214	255	255	208	213	214	212	213	214	255	255	208	213	214	212	213	214	255	255	208	213	214	212	213	214	255	255	208	213	214	212	213	214	255	255	208	213	214	212	213	214	255	255	208	213	214	212	213	214	255	255	208	213	214	212	213	214	255	255	208	213	214	212	212	213	255	255	208	213	214	213	214	216	255	255	210	215	213	213	213	214	255	255	208	213	214	212	213	214	255	255	208	213	214	212	213	214	255	255	208	213	214	212	213	214	255	255	208	213	214	212	213	214	255	255	208	213	214	212	213	214	255	255	208	213	214	212	214	214	239	255	212	213	214	216	213	214	255	255	209	214	214	213	213	214	255	255	209	214	214	213	213	214	255	255	209	214	214	213	213	214	255	255	209	214	214	213	213	214	255	255	209	214	214	213	213	214	255	255	209	214	214	213	213	214	255	255	209	214	214	213	213	214	255	255	209	214	214	213	213	214	255	255	209	214	214	213	213	214	255	255	209	214	214	213	211	213	255	255	212	213	212	213	222	226	247	240	105;...
            104	193	234	255	229	224	217	222	219	222	255	253	219	224	214	225	217	222	254	251	220	224	213	225	217	222	254	251	220	224	213	225	217	222	254	251	220	224	213	225	217	222	254	251	220	224	213	225	217	222	254	251	220	224	213	225	217	222	254	251	220	224	213	225	217	222	254	251	220	224	213	225	217	222	254	251	220	224	213	225	217	222	254	251	220	224	213	225	217	222	254	251	220	224	213	225	217	222	254	251	220	224	213	225	217	222	254	251	220	224	213	225	217	222	254	251	220	224	213	225	218	223	254	252	220	224	213	225	216	223	255	251	220	224	213	225	217	222	254	251	220	224	213	225	217	222	254	251	220	224	213	225	217	222	254	251	220	224	213	225	217	222	254	251	220	224	213	225	217	222	254	251	220	224	213	225	217	222	254	251	220	224	213	225	221	222	235	255	216	224	219	224	217	221	254	252	220	224	213	224	217	221	254	252	220	224	213	224	217	221	254	252	220	224	213	224	217	221	254	252	220	224	213	224	217	221	254	252	220	224	213	224	217	221	254	252	220	224	213	224	217	221	254	252	220	224	213	224	217	221	254	252	220	224	213	224	217	221	254	252	220	224	213	224	217	221	254	252	220	224	213	224	226	221	255	253	217	222	217	223	222	228	253	239	106;...
            132	188	234	237	255	252	253	251	252	255	253	254	255	255	255	255	252	255	252	255	255	255	255	255	252	255	252	255	255	255	255	255	252	255	252	255	255	255	255	255	252	255	252	255	255	255	255	255	252	255	252	255	255	255	255	255	252	255	252	255	255	255	255	255	252	255	252	255	255	255	255	255	252	255	252	255	255	255	255	255	252	255	252	255	255	255	255	255	252	255	252	255	255	255	255	255	252	255	252	255	255	255	255	255	252	255	252	255	255	255	255	255	252	255	252	255	255	255	255	255	252	255	253	255	255	255	255	255	251	255	253	255	255	255	255	255	252	255	252	255	255	255	255	255	252	255	252	255	255	255	255	255	252	255	252	255	255	255	255	255	252	255	252	255	255	255	255	255	252	255	252	255	255	255	255	255	252	255	252	255	255	255	255	255	252	253	239	244	255	254	255	255	252	255	252	255	255	255	255	255	252	255	252	255	255	255	255	255	252	255	252	255	255	255	255	255	252	255	252	255	255	255	255	255	252	255	252	255	255	255	255	255	252	255	252	255	255	255	255	255	252	255	252	255	255	255	255	255	252	255	252	255	255	255	255	255	252	255	252	255	255	255	255	255	252	255	252	255	255	255	255	255	255	255	251	252	255	254	249	250	246	251	235	238	131;...
            170	120	234	242	239	239	238	241	240	241	242	238	239	239	235	239	239	241	241	238	240	239	234	240	239	241	241	238	240	239	234	240	239	241	241	238	240	239	234	240	239	241	241	238	240	239	234	240	239	241	241	238	240	239	234	240	239	241	241	238	240	239	234	240	239	241	241	238	240	239	234	240	239	241	241	238	240	239	234	240	239	241	241	238	240	239	234	240	239	241	241	238	240	239	234	240	239	241	241	238	240	239	234	240	239	241	241	238	240	239	234	240	239	241	241	238	240	239	234	240	238	240	241	238	239	239	234	240	239	239	240	237	238	238	234	236	239	241	241	238	240	239	234	240	239	241	241	238	240	239	234	240	239	241	241	238	240	239	234	240	239	241	241	238	240	239	234	240	239	241	241	238	240	239	234	240	239	241	241	238	240	239	234	240	238	231	241	239	238	244	235	237	239	241	242	238	240	239	234	240	239	241	242	238	240	239	234	240	239	241	242	238	240	239	234	240	239	241	242	238	240	239	234	240	239	241	242	238	240	239	234	240	239	241	242	238	240	239	234	240	239	241	242	238	240	239	234	240	239	241	242	238	240	239	234	240	239	241	242	238	240	239	234	240	239	241	242	238	240	239	234	240	240	234	241	240	240	240	240	237	238	242	233	124	178;...
            206	193	127	106	109	115	115	120	115	116	118	114	115	114	111	115	115	116	117	114	115	115	110	115	115	116	117	114	115	115	110	115	115	116	117	114	115	115	110	115	115	116	117	114	115	115	110	115	115	116	117	114	115	115	110	115	115	116	117	114	115	115	110	115	115	116	117	114	115	115	110	115	115	116	117	114	115	115	110	115	115	116	117	114	115	115	110	115	115	116	117	114	115	115	110	115	115	116	117	114	115	115	110	115	115	116	117	114	115	115	110	115	115	116	117	114	115	115	110	115	114	116	117	114	115	115	110	116	118	117	118	115	116	116	112	114	115	116	117	114	115	115	110	115	115	116	117	114	115	115	110	115	115	116	117	114	115	115	110	115	115	116	117	114	115	115	110	115	115	116	117	114	115	115	110	115	115	116	117	114	115	115	110	115	124	115	122	116	113	118	110	112	114	115	116	113	114	114	109	114	114	115	116	113	114	114	109	114	114	115	116	113	114	114	109	114	114	115	116	113	114	114	109	114	114	115	116	113	114	114	109	114	114	115	116	113	114	114	109	114	114	115	116	113	114	114	109	114	114	115	116	113	114	114	109	114	114	115	116	113	114	114	109	114	114	115	116	113	114	114	109	114	115	109	116	114	115	115	115	112	109	109	133	178	214];
    
    a(:,:,3) = [...
            156	158	116	107	113	107	107	113	113	100	104	107	101	105	113	105	109	105	101	109	105	101	117	101	109	105	101	109	105	101	117	101	109	105	101	109	105	101	117	101	109	105	101	109	105	101	117	101	109	105	101	109	105	101	117	101	109	105	101	109	105	101	117	101	109	105	101	109	105	101	117	101	109	105	101	109	105	101	117	101	109	105	101	109	105	101	117	101	109	105	101	109	105	101	117	101	109	105	101	109	105	101	117	101	109	105	101	109	105	101	117	101	109	105	101	109	105	101	117	101	112	101	106	107	102	105	112	102	108	104	100	111	106	100	117	101	109	105	101	109	105	101	117	101	109	105	101	109	105	101	117	101	109	105	101	109	105	101	117	101	109	105	101	109	105	101	117	101	109	105	101	109	105	101	117	101	109	105	101	109	105	101	117	101	103	109	104	101	116	109	99	106	104	97	105	104	95	98	110	104	104	97	105	104	95	98	110	104	104	97	105	104	95	98	110	104	104	97	105	104	95	98	110	104	104	97	105	104	95	98	110	104	104	97	105	104	95	98	110	104	104	97	105	104	95	98	110	104	104	97	105	104	95	98	110	104	104	97	105	104	95	98	110	104	104	97	105	104	95	98	110	104	103	113	101	103	102	95	111	110	102	101	107	83	124;...
            141	123	186	197	188	192	193	192	190	197	194	193	199	194	190	192	190	200	190	195	199	189	194	191	190	200	190	195	199	189	194	191	190	200	190	195	199	189	194	191	190	200	190	195	199	189	194	191	190	200	190	195	199	189	194	191	190	200	190	195	199	189	194	191	190	200	190	195	199	189	194	191	190	200	190	195	199	189	194	191	190	200	190	195	199	189	194	191	190	200	190	195	199	189	194	191	190	200	190	195	199	189	194	191	190	200	190	195	199	189	194	191	190	200	190	195	199	189	194	191	191	199	196	193	196	192	189	193	191	203	193	198	201	191	196	193	190	200	190	195	199	189	194	191	190	200	190	195	199	189	194	191	190	200	190	195	199	189	194	191	190	200	190	195	199	189	194	191	190	200	190	195	199	189	194	191	190	200	190	195	199	189	194	191	191	199	192	186	195	190	186	195	191	194	191	188	193	191	190	191	191	194	191	188	193	191	190	191	191	194	191	188	193	191	190	191	191	194	191	188	193	191	190	191	191	194	191	188	193	191	190	191	191	194	191	188	193	191	190	191	191	194	191	188	193	191	190	191	191	194	191	188	193	191	190	191	191	194	191	188	193	191	190	191	191	194	191	188	193	191	190	191	188	203	187	188	198	188	188	189	192	188	191	86	112;...
            112	180	198	236	218	204	206	207	204	223	245	243	228	215	206	214	207	227	241	241	226	210	209	214	207	227	241	241	226	210	209	214	207	227	241	241	226	210	209	214	207	227	241	241	226	210	209	214	207	227	241	241	226	210	209	214	207	227	241	241	226	210	209	214	207	227	241	241	226	210	209	214	207	227	241	241	226	210	209	214	207	227	241	241	226	210	209	214	207	227	241	241	226	210	209	214	207	227	241	241	226	210	209	214	207	227	241	241	226	210	209	214	207	227	241	241	226	210	209	214	210	225	245	241	224	213	206	216	206	226	241	241	225	209	208	212	207	227	241	241	226	210	209	214	207	227	241	241	226	210	209	214	207	227	241	241	226	210	209	214	207	227	241	241	226	210	209	214	207	227	241	241	226	210	209	214	207	227	241	241	226	210	209	214	217	226	236	226	209	209	214	221	221	230	241	238	229	223	214	219	221	230	241	238	229	223	214	219	221	230	241	238	229	223	214	219	221	230	241	238	229	223	214	219	221	230	241	238	229	223	214	219	221	230	241	238	229	223	214	219	221	230	241	238	229	223	214	219	221	230	241	238	229	223	214	219	221	230	241	238	229	223	214	219	221	230	241	238	229	223	214	219	213	230	238	239	232	213	203	205	219	229	245	161	104;...
            106	181	244	226	174	150	149	153	157	170	254	255	176	162	164	160	161	175	250	251	173	160	166	163	161	175	250	251	173	160	166	163	161	175	250	251	173	160	166	163	161	175	250	251	173	160	166	163	161	175	250	251	173	160	166	163	161	175	250	251	173	160	166	163	161	175	250	251	173	160	166	163	161	175	250	251	173	160	166	163	161	175	250	251	173	160	166	163	161	175	250	251	173	160	166	163	161	175	250	251	173	160	166	163	161	175	250	251	173	160	166	163	161	175	250	251	173	160	166	163	161	173	252	252	174	160	166	162	161	173	250	252	173	160	165	162	161	175	250	251	173	160	166	163	161	175	250	251	173	160	166	163	161	175	250	251	173	160	166	163	161	175	250	251	173	160	166	163	161	175	250	251	173	160	166	163	161	175	250	251	173	160	166	163	165	174	235	234	170	166	172	176	175	179	253	253	180	173	176	172	175	179	253	253	180	173	176	172	175	179	253	253	180	173	176	172	175	179	253	253	180	173	176	172	175	179	253	253	180	173	176	172	175	179	253	253	180	173	176	172	175	179	253	253	180	173	176	172	175	179	253	253	180	173	176	172	175	179	253	253	180	173	176	172	175	179	253	253	180	173	176	172	168	184	252	249	184	161	152	154	181	211	235	228	97;...
            102	181	242	228	125	95	91	94	100	99	251	255	108	98	111	96	105	102	251	251	105	98	112	99	105	102	251	251	105	98	112	99	105	102	251	251	105	98	112	99	105	102	251	251	105	98	112	99	105	102	251	251	105	98	112	99	105	102	251	251	105	98	112	99	105	102	251	251	105	98	112	99	105	102	251	251	105	98	112	99	105	102	251	251	105	98	112	99	105	102	251	251	105	98	112	99	105	102	251	251	105	98	112	99	105	102	251	251	105	98	112	99	105	102	251	251	105	98	112	99	103	102	250	253	106	96	113	98	106	103	251	253	107	99	112	100	105	102	251	251	105	98	112	99	105	102	251	251	105	98	112	99	105	102	251	251	105	98	112	99	105	102	251	251	105	98	112	99	105	102	251	251	105	98	112	99	105	102	251	251	105	98	112	99	101	110	237	246	118	104	105	102	104	104	252	253	105	95	116	105	104	104	252	253	105	95	116	105	104	104	252	253	105	95	116	105	104	104	252	253	105	95	116	105	104	104	252	253	105	95	116	105	104	104	252	253	105	95	116	105	104	104	252	253	105	95	116	105	104	104	252	253	105	95	116	105	104	104	252	253	105	95	116	105	104	104	252	253	105	95	116	105	103	110	255	246	109	91	93	93	113	153	238	228	104;...
            105	179	229	217	96	58	67	55	64	58	251	254	63	57	73	58	65	56	253	252	62	59	71	60	65	56	253	252	62	59	71	60	65	56	253	252	62	59	71	60	65	56	253	252	62	59	71	60	65	56	253	252	62	59	71	60	65	56	253	252	62	59	71	60	65	56	253	252	62	59	71	60	65	56	253	252	62	59	71	60	65	56	253	252	62	59	71	60	65	56	253	252	62	59	71	60	65	56	253	252	62	59	71	60	65	56	253	252	62	59	71	60	65	56	253	252	62	59	71	60	62	58	250	254	63	57	75	60	66	56	255	252	63	59	71	59	65	56	253	252	62	59	71	60	65	56	253	252	62	59	71	60	65	56	253	252	62	59	71	60	65	56	253	252	62	59	71	60	65	56	253	252	62	59	71	60	65	56	253	252	62	59	71	60	57	64	238	251	80	61	64	61	59	57	252	253	58	48	71	62	59	57	252	253	58	48	71	62	59	57	252	253	58	48	71	62	59	57	252	253	58	48	71	62	59	57	252	253	58	48	71	62	59	57	252	253	58	48	71	62	59	57	252	253	58	48	71	62	59	57	252	253	58	48	71	62	59	57	252	253	58	48	71	62	59	57	252	253	58	48	71	62	63	60	255	245	60	51	62	64	70	151	236	220	113;...
            98	182	240	216	91	55	57	55	51	49	255	253	48	39	58	48	48	44	255	255	50	45	52	46	48	44	255	255	50	45	52	46	48	44	255	255	50	45	52	46	48	44	255	255	50	45	52	46	48	44	255	255	50	45	52	46	48	44	255	255	50	45	52	46	48	44	255	255	50	45	52	46	48	44	255	255	50	45	52	46	48	44	255	255	50	45	52	46	48	44	255	255	50	45	52	46	48	44	255	255	50	45	52	46	48	44	255	255	50	45	52	46	48	44	255	255	50	45	52	46	46	46	255	255	52	41	58	46	49	44	255	255	51	46	53	48	48	44	255	255	50	45	52	46	48	44	255	255	50	45	52	46	48	44	255	255	50	45	52	46	48	44	255	255	50	45	52	46	48	44	255	255	50	45	52	46	48	44	255	255	50	45	52	46	48	54	243	255	57	40	54	48	47	49	255	255	49	38	56	48	47	49	255	255	49	38	56	48	47	49	255	255	49	38	56	48	47	49	255	255	49	38	56	48	47	49	255	255	49	38	56	48	47	49	255	255	49	38	56	48	47	49	255	255	49	38	56	48	47	49	255	255	49	38	56	48	47	49	255	255	49	38	56	48	47	49	255	255	49	38	56	48	51	47	255	241	48	44	54	60	68	164	235	216	109;...
            106	180	240	229	93	61	64	51	51	55	255	255	48	37	55	51	46	47	255	255	52	44	48	47	46	47	255	255	52	44	48	47	46	47	255	255	52	44	48	47	46	47	255	255	52	44	48	47	46	47	255	255	52	44	48	47	46	47	255	255	52	44	48	47	46	47	255	255	52	44	48	47	46	47	255	255	52	44	48	47	46	47	255	255	52	44	48	47	46	47	255	255	52	44	48	47	46	47	255	255	52	44	48	47	46	47	255	255	52	44	48	47	46	47	255	255	52	44	48	47	43	50	255	255	53	40	55	47	46	47	255	255	53	46	49	47	46	47	255	255	52	44	48	47	46	47	255	255	52	44	48	47	46	47	255	255	52	44	48	47	46	47	255	255	52	44	48	47	46	47	255	255	52	44	48	47	46	47	255	255	52	44	48	47	50	56	246	255	53	39	56	53	49	52	255	255	55	44	56	44	49	52	255	255	55	44	56	44	49	52	255	255	55	44	56	44	49	52	255	255	55	44	56	44	49	52	255	255	55	44	56	44	49	52	255	255	55	44	56	44	49	52	255	255	55	44	56	44	49	52	255	255	55	44	56	44	49	52	255	255	55	44	56	44	49	52	255	255	55	44	56	44	51	51	255	237	52	48	49	62	79	173	240	209	112;...
            110	176	242	233	106	65	69	75	65	67	247	243	68	60	64	59	66	70	247	241	69	60	62	59	66	70	247	241	69	60	62	59	66	70	247	241	69	60	62	59	66	70	247	241	69	60	62	59	66	70	247	241	69	60	62	59	66	70	247	241	69	60	62	59	66	70	247	241	69	60	62	59	66	70	247	241	69	60	62	59	66	70	247	241	69	60	62	59	66	70	247	241	69	60	62	59	66	70	247	241	69	60	62	59	66	70	247	241	69	60	62	59	66	70	247	241	69	60	62	59	65	69	247	241	69	60	62	60	67	66	253	248	65	57	66	60	66	70	247	241	69	60	62	59	66	70	247	241	69	60	62	59	66	70	247	241	69	60	62	59	66	70	247	241	69	60	62	59	66	70	247	241	69	60	62	59	66	70	247	241	69	60	62	59	61	69	234	243	79	61	59	60	66	69	247	241	70	61	62	60	66	69	247	241	70	61	62	60	66	69	247	241	70	61	62	60	66	69	247	241	70	61	62	60	66	69	247	241	70	61	62	60	66	69	247	241	70	61	62	60	66	69	247	241	70	61	62	60	66	69	247	241	70	61	62	60	66	69	247	241	70	61	62	60	66	69	247	241	70	61	62	60	64	67	249	243	72	61	65	64	80	164	246	215	109;...
            104	182	237	254	173	133	114	99	104	114	255	254	123	113	110	117	109	110	255	255	120	112	116	113	109	110	255	255	120	112	116	113	109	110	255	255	120	112	116	113	109	110	255	255	120	112	116	113	109	110	255	255	120	112	116	113	109	110	255	255	120	112	116	113	109	110	255	255	120	112	116	113	109	110	255	255	120	112	116	113	109	110	255	255	120	112	116	113	109	110	255	255	120	112	116	113	109	110	255	255	120	112	116	113	109	110	255	255	120	112	116	113	109	110	255	255	120	112	116	113	110	111	255	255	120	112	116	113	113	109	255	255	120	115	119	109	109	110	255	255	120	112	116	113	109	110	255	255	120	112	116	113	109	110	255	255	120	112	116	113	109	110	255	255	120	112	116	113	109	110	255	255	120	112	116	113	109	110	255	255	120	112	116	113	110	112	240	255	117	112	118	111	108	109	255	255	118	112	116	112	108	109	255	255	118	112	116	112	108	109	255	255	118	112	116	112	108	109	255	255	118	112	116	112	108	109	255	255	118	112	116	112	108	109	255	255	118	112	116	112	108	109	255	255	118	112	116	112	108	109	255	255	118	112	116	112	108	109	255	255	118	112	116	112	108	109	255	255	118	112	116	112	109	116	253	241	113	102	105	117	136	161	255	225	106;...
            117	183	247	247	250	241	250	245	255	250	255	255	249	253	255	250	255	255	255	255	252	255	250	252	255	255	255	255	252	255	250	252	255	255	255	255	252	255	250	252	255	255	255	255	252	255	250	252	255	255	255	255	252	255	250	252	255	255	255	255	252	255	250	252	255	255	255	255	252	255	250	252	255	255	255	255	252	255	250	252	255	255	255	255	252	255	250	252	255	255	255	255	252	255	250	252	255	255	255	255	252	255	250	252	255	255	255	255	252	255	250	252	255	255	255	255	252	255	250	252	255	255	255	255	252	255	249	252	255	255	255	255	255	255	248	251	255	255	255	255	252	255	250	252	255	255	255	255	252	255	250	252	255	255	255	255	252	255	250	252	255	255	255	255	252	255	250	252	255	255	255	255	252	255	250	252	255	255	255	255	252	255	250	252	255	254	247	244	251	250	250	255	255	255	255	255	252	255	250	252	255	255	255	255	252	255	250	252	255	255	255	255	252	255	250	252	255	255	255	255	252	255	250	252	255	255	255	255	252	255	250	252	255	255	255	255	252	255	250	252	255	255	255	255	252	255	250	252	255	255	255	255	252	255	250	252	255	255	255	255	252	255	250	252	255	255	255	255	252	255	250	252	253	245	255	255	248	245	238	228	232	243	230	237	117;...
            162	126	240	240	238	247	243	236	233	236	234	235	237	238	239	240	236	236	234	237	238	238	241	238	236	236	234	237	238	238	241	238	236	236	234	237	238	238	241	238	236	236	234	237	238	238	241	238	236	236	234	237	238	238	241	238	236	236	234	237	238	238	241	238	236	236	234	237	238	238	241	238	236	236	234	237	238	238	241	238	236	236	234	237	238	238	241	238	236	236	234	237	238	238	241	238	236	236	234	237	238	238	241	238	236	236	234	237	238	238	241	238	236	236	234	237	238	238	241	238	235	235	234	237	237	238	241	238	228	240	236	234	239	233	234	243	236	236	234	237	238	238	241	238	236	236	234	237	238	238	241	238	236	236	234	237	238	238	241	238	236	236	234	237	238	238	241	238	236	236	234	237	238	238	241	238	236	236	234	237	238	238	241	238	236	228	232	232	232	241	242	241	234	236	234	237	236	238	241	238	234	236	234	237	236	238	241	238	234	236	234	237	236	238	241	238	234	236	234	237	236	238	241	238	234	236	234	237	236	238	241	238	234	236	234	237	236	238	241	238	234	236	234	237	236	238	241	238	234	236	234	237	236	238	241	238	234	236	234	237	236	238	241	238	234	236	234	237	236	238	241	238	243	241	237	235	239	237	239	238	231	231	236	110	147;...
            74	119	110	105	104	108	108	110	108	111	110	111	113	113	115	116	112	111	110	113	113	114	117	113	112	111	110	113	113	114	117	113	112	111	110	113	113	114	117	113	112	111	110	113	113	114	117	113	112	111	110	113	113	114	117	113	112	111	110	113	113	114	117	113	112	111	110	113	113	114	117	113	112	111	110	113	113	114	117	113	112	111	110	113	113	114	117	113	112	111	110	113	113	114	117	113	112	111	110	113	113	114	117	113	112	111	110	113	113	114	117	113	112	111	110	113	113	114	117	113	111	111	110	113	113	114	117	114	107	118	114	112	117	111	112	121	112	111	110	113	113	114	117	113	112	111	110	113	113	114	117	113	112	111	110	113	113	114	117	113	112	111	110	113	113	114	117	113	112	111	110	113	113	114	117	113	112	111	110	113	113	114	117	113	122	112	113	109	107	115	117	116	109	110	108	112	110	113	116	112	109	110	108	112	110	113	116	112	109	110	108	112	110	113	116	112	109	110	108	112	110	113	116	112	109	110	108	112	110	113	116	112	109	110	108	112	110	113	116	112	109	110	108	112	110	113	116	112	109	110	108	112	110	113	116	112	109	110	108	112	110	113	116	112	109	110	108	112	110	113	116	112	118	116	112	109	114	112	114	113	117	101	121	152	142];
    
    
else
    
    a(:,:,1) = [... 
            255	255	132	104	110	102	109	101	109	110	108	109	103	103	110	110	103	106	107	110	108	110	105	109	109	109	109	109	109	109	109	109	108	105	111	109	110	107	105	103	110	110	103	103	109	108	110	109	109	110	108	109	103	103	110	110	103	106	107	110	108	110	105	109	109	109	109	109	109	109	109	109	108	105	111	109	110	107	105	103	110	110	103	103	109	108	110	109	109	110	108	109	103	103	110	110	103	106	107	110	108	110	105	109	109	109	109	109	109	109	109	109	108	105	111	109	110	107	105	103	110	110	103	103	109	108	110	109	109	110	108	109	103	103	110	110	103	106	107	110	108	110	105	109	109	109	109	109	109	109	109	109	108	105	111	109	110	107	105	103	110	110	103	103	109	108	110	109	109	110	108	109	103	103	110	110	103	106	107	110	108	110	105	109	109	109	109	109	109	109	109	109	108	105	111	109	110	107	105	103	110	110	103	103	109	108	110	109	109	110	108	109	103	103	110	110	103	106	107	110	108	110	105	109	109	109	109	109	109	109	109	109	111	107	114	111	112	110	109	106	109	115	101	108	107	113	108	114	110	107	110	103	106	100	111	107	107	107	107	109	109	112	103	104	109	108	108	110	110	108	108	109	104	103	111	110	108	109	108	108	110	113	108	108	172;...
            255	117	191	197	194	195	192	193	192	190	190	193	193	194	193	189	195	194	192	191	189	189	190	189	192	192	192	192	192	192	192	192	190	190	189	188	191	191	194	196	189	193	194	193	193	190	190	192	192	190	190	193	193	194	193	189	195	194	192	191	189	189	190	189	192	192	192	192	192	192	192	192	190	190	189	188	191	191	194	196	189	193	194	193	193	190	190	192	192	190	190	193	193	194	193	189	195	194	192	191	189	189	190	189	192	192	192	192	192	192	192	192	190	190	189	188	191	191	194	196	189	193	194	193	193	190	190	192	192	190	190	193	193	194	193	189	195	194	192	191	189	189	190	189	192	192	192	192	192	192	192	192	190	190	189	188	191	191	194	196	189	193	194	193	193	190	190	192	192	190	190	193	193	194	193	189	195	194	192	191	189	189	190	189	192	192	192	192	192	192	192	192	190	190	189	188	191	191	194	196	189	193	194	193	193	190	190	192	192	190	190	193	193	194	193	189	195	194	192	191	189	189	190	189	192	192	192	192	192	192	192	192	191	192	191	193	195	195	196	196	188	197	187	191	190	194	182	192	192	188	196	190	194	187	192	186	190	191	192	193	190	191	193	195	191	190	191	190	190	191	190	191	195	194	190	191	192	193	190	190	194	187	181	104	150;...
            125	192	195	243	235	238	241	244	240	240	236	234	253	255	236	241	239	241	242	242	239	233	252	247	239	239	239	239	239	239	239	239	249	252	232	238	242	243	241	239	241	236	255	253	234	236	240	240	240	240	236	234	253	255	236	241	239	241	242	242	239	233	252	247	239	239	239	239	239	239	239	239	249	252	232	238	242	243	241	239	241	236	255	253	234	236	240	240	240	240	236	234	253	255	236	241	239	241	242	242	239	233	252	247	239	239	239	239	239	239	239	239	249	252	232	238	242	243	241	239	241	236	255	253	234	236	240	240	240	240	236	234	253	255	236	241	239	241	242	242	239	233	252	247	239	239	239	239	239	239	239	239	249	252	232	238	242	243	241	239	241	236	255	253	234	236	240	240	240	240	236	234	253	255	236	241	239	241	242	242	239	233	252	247	239	239	239	239	239	239	239	239	249	252	232	238	242	243	241	239	241	236	255	253	234	236	240	240	240	240	236	234	253	255	236	241	239	241	242	242	239	233	252	247	239	239	239	239	239	239	239	239	244	249	229	233	237	238	236	236	233	241	251	253	233	238	230	242	242	237	238	230	255	254	238	238	240	239	237	239	239	236	255	252	234	235	241	239	239	241	235	234	251	255	235	240	238	237	238	239	236	235	244	199	137;...
            109	193	236	238	177	171	175	169	169	175	168	176	243	242	174	172	170	169	171	169	170	178	242	249	172	172	172	172	172	172	172	172	249	241	177	170	170	171	169	170	172	174	242	243	176	168	175	169	169	175	168	176	243	242	174	172	170	169	171	169	170	178	242	249	172	172	172	172	172	172	172	172	249	241	177	170	170	171	169	170	172	174	242	243	176	168	175	169	169	175	168	176	243	242	174	172	170	169	171	169	170	178	242	249	172	172	172	172	172	172	172	172	249	241	177	170	170	171	169	170	172	174	242	243	176	168	175	169	169	175	168	176	243	242	174	172	170	169	171	169	170	178	242	249	172	172	172	172	172	172	172	172	249	241	177	170	170	171	169	170	172	174	242	243	176	168	175	169	169	175	168	176	243	242	174	172	170	169	171	169	170	178	242	249	172	172	172	172	172	172	172	172	249	241	177	170	170	171	169	170	172	174	242	243	176	168	175	169	169	175	168	176	243	242	174	172	170	169	171	169	170	178	242	249	172	172	172	172	172	172	172	172	253	247	186	180	178	179	179	180	178	188	242	244	179	177	173	178	172	175	173	174	245	237	174	170	170	174	172	175	174	174	241	243	173	169	174	169	169	174	169	173	243	241	173	175	174	173	173	170	172	179	231	224	102;...
            109	195	243	252	154	152	153	149	149	155	141	149	249	252	149	148	143	143	150	147	149	152	248	255	148	148	148	148	148	148	148	148	255	248	152	150	147	150	143	143	148	149	252	249	149	141	155	149	149	155	141	149	249	252	149	148	143	143	150	147	149	152	248	255	148	148	148	148	148	148	148	148	255	248	152	150	147	150	143	143	148	149	252	249	149	141	155	149	149	155	141	149	249	252	149	148	143	143	150	147	149	152	248	255	148	148	148	148	148	148	148	148	255	248	152	150	147	150	143	143	148	149	252	249	149	141	155	149	149	155	141	149	249	252	149	148	143	143	150	147	149	152	248	255	148	148	148	148	148	148	148	148	255	248	152	150	147	150	143	143	148	149	252	249	149	141	155	149	149	155	141	149	249	252	149	148	143	143	150	147	149	152	248	255	148	148	148	148	148	148	148	148	255	248	152	150	147	150	143	143	148	149	252	249	149	141	155	149	149	155	141	149	249	252	149	148	143	143	150	147	149	152	248	255	148	148	148	148	148	148	148	148	255	251	157	153	152	154	148	148	147	155	250	255	151	148	150	150	148	151	146	145	253	248	151	148	146	151	146	149	148	147	251	251	148	143	153	151	151	153	143	148	252	252	146	149	147	147	151	147	149	154	242	231	113;...
            110	188	241	254	117	114	120	113	121	128	121	129	250	251	126	127	128	128	130	126	125	124	245	249	126	126	126	126	126	126	126	126	249	246	125	125	125	129	128	130	127	126	251	250	129	121	128	121	121	128	121	129	250	251	126	127	128	128	130	126	125	124	245	249	126	126	126	126	126	126	126	126	249	246	125	125	125	129	128	130	127	126	251	250	129	121	128	121	121	128	121	129	250	251	126	127	128	128	130	126	125	124	245	249	126	126	126	126	126	126	126	126	249	246	125	125	125	129	128	130	127	126	251	250	129	121	128	121	121	128	121	129	250	251	126	127	128	128	130	126	125	124	245	249	126	126	126	126	126	126	126	126	249	246	125	125	125	129	128	130	127	126	251	250	129	121	128	121	121	128	121	129	250	251	126	127	128	128	130	126	125	124	245	249	126	126	126	126	126	126	126	126	249	246	125	125	125	129	128	130	127	126	251	250	129	121	128	121	121	128	121	129	250	251	126	127	128	128	130	126	125	124	245	249	126	126	126	126	126	126	126	126	248	243	119	117	118	124	123	126	123	130	248	250	123	122	123	126	125	127	123	125	255	250	127	123	123	127	121	126	131	124	254	245	129	119	130	122	122	130	119	129	246	255	123	131	124	121	128	126	127	131	235	232	107;...
            111	185	241	255	105	98	114	107	103	107	93	103	250	254	99	98	106	103	107	101	101	101	244	245	101	101	101	101	101	101	101	101	246	244	100	100	100	107	103	107	98	99	254	250	103	93	107	103	103	107	93	103	250	254	99	98	106	103	107	101	101	101	244	245	101	101	101	101	101	101	101	101	246	244	100	100	100	107	103	107	98	99	254	250	103	93	107	103	103	107	93	103	250	254	99	98	106	103	107	101	101	101	244	245	101	101	101	101	101	101	101	101	246	244	100	100	100	107	103	107	98	99	254	250	103	93	107	103	103	107	93	103	250	254	99	98	106	103	107	101	101	101	244	245	101	101	101	101	101	101	101	101	246	244	100	100	100	107	103	107	98	99	254	250	103	93	107	103	103	107	93	103	250	254	99	98	106	103	107	101	101	101	244	245	101	101	101	101	101	101	101	101	246	244	100	100	100	107	103	107	98	99	254	250	103	93	107	103	103	107	93	103	250	254	99	98	106	103	107	101	101	101	244	245	101	101	101	101	101	101	101	101	246	244	101	102	102	108	103	106	94	103	246	249	102	96	97	98	100	105	97	100	253	248	103	100	100	108	100	103	102	93	254	250	102	92	109	101	101	109	92	102	250	255	93	102	101	101	108	102	101	107	230	224	105;...
            108	191	239	254	75	75	79	74	73	87	70	78	245	245	75	80	75	73	79	74	78	81	242	249	77	77	77	77	77	77	77	77	249	242	81	78	75	80	73	74	80	75	245	245	78	70	87	73	73	87	70	78	245	245	75	80	75	73	79	74	78	81	242	249	77	77	77	77	77	77	77	77	249	242	81	78	75	80	73	74	80	75	245	245	78	70	87	73	73	87	70	78	245	245	75	80	75	73	79	74	78	81	242	249	77	77	77	77	77	77	77	77	249	242	81	78	75	80	73	74	80	75	245	245	78	70	87	73	73	87	70	78	245	245	75	80	75	73	79	74	78	81	242	249	77	77	77	77	77	77	77	77	249	242	81	78	75	80	73	74	80	75	245	245	78	70	87	73	73	87	70	78	245	245	75	80	75	73	79	74	78	81	242	249	77	77	77	77	77	77	77	77	249	242	81	78	75	80	73	74	80	75	245	245	78	70	87	73	73	87	70	78	245	245	75	80	75	73	79	74	78	81	242	249	77	77	77	77	77	77	77	77	247	243	81	77	74	80	73	77	77	85	245	245	80	75	80	82	76	85	72	73	249	243	76	78	74	83	75	80	81	74	248	243	78	70	85	74	74	85	70	78	243	249	73	82	78	74	82	74	74	83	229	226	111;...
            110	187	240	253	51	54	56	51	54	49	57	53	239	243	54	56	51	57	50	59	54	51	244	242	53	53	53	53	53	53	53	53	241	242	51	53	57	50	56	52	57	53	244	238	53	57	48	54	54	49	57	53	239	243	54	56	51	57	50	59	54	51	244	242	53	53	53	53	53	53	53	53	241	242	51	53	57	50	56	52	57	53	244	238	53	57	48	54	54	49	57	53	239	243	54	56	51	57	50	59	54	51	244	242	53	53	53	53	53	53	53	53	241	242	51	53	57	50	56	52	57	53	244	238	53	57	48	54	54	49	57	53	239	243	54	56	51	57	50	59	54	51	244	242	53	53	53	53	53	53	53	53	241	242	51	53	57	50	56	52	57	53	244	238	53	57	48	54	54	49	57	53	239	243	54	56	51	57	50	59	54	51	244	242	53	53	53	53	53	53	53	53	241	242	51	53	57	50	56	52	57	53	244	238	53	57	48	54	54	49	57	53	239	243	54	56	51	57	50	59	54	51	244	242	53	53	53	53	53	53	53	53	240	244	52	50	57	51	57	57	55	51	248	243	53	55	47	54	49	49	59	54	244	241	50	54	61	49	53	52	56	49	252	231	53	54	52	55	55	52	54	53	231	251	48	54	51	54	49	62	53	55	229	222	110;...
            105	197	234	252	51	47	48	47	46	48	48	48	245	244	46	48	41	48	42	50	45	49	245	246	48	48	48	48	48	48	48	48	247	245	50	45	49	43	47	42	50	45	245	244	47	49	47	47	46	48	48	48	245	244	46	48	41	48	42	50	45	49	245	246	48	48	48	48	48	48	48	48	247	245	50	45	49	43	47	42	50	45	245	244	47	49	47	47	46	48	48	48	245	244	46	48	41	48	42	50	45	49	245	246	48	48	48	48	48	48	48	48	247	245	50	45	49	43	47	42	50	45	245	244	47	49	47	47	46	48	48	48	245	244	46	48	41	48	42	50	45	49	245	246	48	48	48	48	48	48	48	48	247	245	50	45	49	43	47	42	50	45	245	244	47	49	47	47	46	48	48	48	245	244	46	48	41	48	42	50	45	49	245	246	48	48	48	48	48	48	48	48	247	245	50	45	49	43	47	42	50	45	245	244	47	49	47	47	46	48	48	48	245	244	46	48	41	48	42	50	45	49	245	246	48	48	48	48	48	48	48	48	248	245	50	45	50	45	47	45	47	48	245	243	49	49	45	49	40	43	47	44	247	245	47	53	52	45	46	48	47	45	251	239	49	48	45	46	46	45	48	49	238	249	46	47	48	47	44	51	48	57	229	227	107;...
            107	193	240	254	64	64	63	72	60	63	67	68	246	244	64	64	69	68	62	67	63	67	247	244	63	63	63	63	63	63	63	63	244	245	67	63	67	64	69	72	65	64	245	245	67	67	62	61	60	63	67	68	246	244	64	64	69	68	62	67	63	67	247	244	63	63	63	63	63	63	63	63	244	245	67	63	67	64	69	72	65	64	245	245	67	67	62	61	60	63	67	68	246	244	64	64	69	68	62	67	63	67	247	244	63	63	63	63	63	63	63	63	244	245	67	63	67	64	69	72	65	64	245	245	67	67	62	61	60	63	67	68	246	244	64	64	69	68	62	67	63	67	247	244	63	63	63	63	63	63	63	63	244	245	67	63	67	64	69	72	65	64	245	245	67	67	62	61	60	63	67	68	246	244	64	64	69	68	62	67	63	67	247	244	63	63	63	63	63	63	63	63	244	245	67	63	67	64	69	72	65	64	245	245	67	67	62	61	60	63	67	68	246	244	64	64	69	68	62	67	63	67	247	244	63	63	63	63	63	63	63	63	245	246	68	64	66	63	64	64	60	61	247	247	62	62	67	71	67	66	69	65	244	242	61	62	63	63	64	68	64	65	251	242	69	65	63	60	60	63	65	69	243	251	65	63	67	64	62	63	60	69	226	222	105;...
            104	198	244	252	92	87	89	88	83	86	87	93	252	249	90	83	100	93	85	85	83	89	244	243	94	94	94	94	94	94	94	94	245	244	90	83	84	86	91	98	84	89	250	251	92	87	85	84	83	86	87	93	252	249	90	83	100	93	85	85	83	89	244	243	94	94	94	94	94	94	94	94	245	244	90	83	84	86	91	98	84	89	250	251	92	87	85	84	83	86	87	93	252	249	90	83	100	93	85	85	83	89	244	243	94	94	94	94	94	94	94	94	245	244	90	83	84	86	91	98	84	89	250	251	92	87	85	84	83	86	87	93	252	249	90	83	100	93	85	85	83	89	244	243	94	94	94	94	94	94	94	94	245	244	90	83	84	86	91	98	84	89	250	251	92	87	85	84	83	86	87	93	252	249	90	83	100	93	85	85	83	89	244	243	94	94	94	94	94	94	94	94	245	244	90	83	84	86	91	98	84	89	250	251	92	87	85	84	83	86	87	93	252	249	90	83	100	93	85	85	83	89	244	243	94	94	94	94	94	94	94	94	246	246	95	90	89	88	91	94	89	86	245	249	88	89	93	88	95	88	92	92	245	244	86	79	82	88	85	92	85	91	251	253	93	87	87	83	83	87	87	93	255	251	91	83	90	85	87	83	81	90	231	227	103;...
            107	195	239	250	125	117	115	124	116	127	117	119	255	247	118	117	117	114	115	119	114	126	251	255	115	115	115	115	115	115	115	115	255	248	125	113	118	116	114	118	117	117	248	255	119	118	126	116	116	127	117	119	255	247	118	117	117	114	115	119	114	126	251	255	115	115	115	115	115	115	115	115	255	248	125	113	118	116	114	118	117	117	248	255	119	118	126	116	116	127	117	119	255	247	118	117	117	114	115	119	114	126	251	255	115	115	115	115	115	115	115	115	255	248	125	113	118	116	114	118	117	117	248	255	119	118	126	116	116	127	117	119	255	247	118	117	117	114	115	119	114	126	251	255	115	115	115	115	115	115	115	115	255	248	125	113	118	116	114	118	117	117	248	255	119	118	126	116	116	127	117	119	255	247	118	117	117	114	115	119	114	126	251	255	115	115	115	115	115	115	115	115	255	248	125	113	118	116	114	118	117	117	248	255	119	118	126	116	116	127	117	119	255	247	118	117	117	114	115	119	114	126	251	255	115	115	115	115	115	115	115	115	252	249	130	121	122	120	114	116	122	129	249	250	118	114	123	122	114	115	115	118	249	247	125	123	113	123	119	124	113	123	246	255	123	119	119	114	114	119	119	123	255	246	125	113	125	120	121	113	121	130	239	227	122;...
            108	198	237	244	147	140	139	135	147	148	144	148	243	236	156	143	149	145	146	148	145	158	239	245	140	140	140	140	140	140	140	140	248	240	159	144	148	146	143	148	142	154	237	244	149	145	148	147	147	148	144	148	243	236	156	143	149	145	146	148	145	158	239	245	140	140	140	140	140	140	140	140	248	240	159	144	148	146	143	148	142	154	237	244	149	145	148	147	147	148	144	148	243	236	156	143	149	145	146	148	145	158	239	245	140	140	140	140	140	140	140	140	248	240	159	144	148	146	143	148	142	154	237	244	149	145	148	147	147	148	144	148	243	236	156	143	149	145	146	148	145	158	239	245	140	140	140	140	140	140	140	140	248	240	159	144	148	146	143	148	142	154	237	244	149	145	148	147	147	148	144	148	243	236	156	143	149	145	146	148	145	158	239	245	140	140	140	140	140	140	140	140	248	240	159	144	148	146	143	148	142	154	237	244	149	145	148	147	147	148	144	148	243	236	156	143	149	145	146	148	145	158	239	245	140	140	140	140	140	140	140	140	242	237	163	152	155	153	153	157	154	163	233	238	152	146	146	143	146	142	142	151	240	238	162	147	145	150	144	148	141	158	233	246	151	148	148	148	148	148	148	151	247	233	159	141	148	145	149	146	151	161	227	231	103;...
            125	197	241	245	252	255	252	255	252	247	251	243	255	255	251	249	250	249	251	255	245	242	255	254	255	255	255	255	255	255	255	255	255	255	243	245	254	252	249	252	249	250	255	255	244	251	247	253	252	247	251	243	255	255	251	249	250	249	251	255	245	242	255	254	255	255	255	255	255	255	255	255	255	255	243	245	254	252	249	252	249	250	255	255	244	251	247	253	252	247	251	243	255	255	251	249	250	249	251	255	245	242	255	254	255	255	255	255	255	255	255	255	255	255	243	245	254	252	249	252	249	250	255	255	244	251	247	253	252	247	251	243	255	255	251	249	250	249	251	255	245	242	255	254	255	255	255	255	255	255	255	255	255	255	243	245	254	252	249	252	249	250	255	255	244	251	247	253	252	247	251	243	255	255	251	249	250	249	251	255	245	242	255	254	255	255	255	255	255	255	255	255	255	255	243	245	254	252	249	252	249	250	255	255	244	251	247	253	252	247	251	243	255	255	251	249	250	249	251	255	245	242	255	254	255	255	255	255	255	255	255	255	255	255	245	247	255	254	250	254	254	249	255	255	242	254	249	247	254	254	254	246	255	255	246	244	251	252	247	252	244	250	255	255	246	248	248	252	252	248	248	246	255	255	250	243	251	247	252	253	243	242	255	240	135;...
            254	121	236	240	232	246	238	239	245	237	242	234	239	234	247	239	240	241	243	248	237	239	238	235	236	236	236	236	236	236	236	236	236	238	241	237	247	243	239	240	239	245	235	239	234	243	236	246	245	237	242	234	239	234	247	239	240	241	243	248	237	239	238	235	236	236	236	236	236	236	236	236	236	238	241	237	247	243	239	240	239	245	235	239	234	243	236	246	245	237	242	234	239	234	247	239	240	241	243	248	237	239	238	235	236	236	236	236	236	236	236	236	236	238	241	237	247	243	239	240	239	245	235	239	234	243	236	246	245	237	242	234	239	234	247	239	240	241	243	248	237	239	238	235	236	236	236	236	236	236	236	236	236	238	241	237	247	243	239	240	239	245	235	239	234	243	236	246	245	237	242	234	239	234	247	239	240	241	243	248	237	239	238	235	236	236	236	236	236	236	236	236	236	238	241	237	247	243	239	240	239	245	235	239	234	243	236	246	245	237	242	234	239	234	247	239	240	241	243	248	237	239	238	235	236	236	236	236	236	236	236	236	241	243	240	235	247	242	237	239	236	243	231	240	239	246	241	241	239	241	234	232	245	234	240	233	246	243	235	237	233	245	233	238	236	240	239	245	245	239	240	236	238	232	247	234	237	237	243	247	236	240	228	125	202;...
            255	255	130	108	109	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	106	106	105	106	107	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	119	201	176];
    
    a(:,:,2) = [...
            251	254	132	106	108	104	113	107	107	110	107	109	110	110	109	108	108	110	109	109	106	108	107	112	107	107	107	107	107	107	107	107	111	107	109	107	109	109	109	108	108	109	110	110	109	107	110	107	107	110	107	109	110	110	109	108	108	110	109	109	106	108	107	112	107	107	107	107	107	107	107	107	111	107	109	107	109	109	109	108	108	109	110	110	109	107	110	107	107	110	107	109	110	110	109	108	108	110	109	109	106	108	107	112	107	107	107	107	107	107	107	107	111	107	109	107	109	109	109	108	108	109	110	110	109	107	110	107	107	110	107	109	110	110	109	108	108	110	109	109	106	108	107	112	107	107	107	107	107	107	107	107	111	107	109	107	109	109	109	108	108	109	110	110	109	107	110	107	107	110	107	109	110	110	109	108	108	110	109	109	106	108	107	112	107	107	107	107	107	107	107	107	111	107	109	107	109	109	109	108	108	109	110	110	109	107	110	107	107	110	107	109	110	110	109	108	108	110	109	109	106	108	107	112	107	107	107	107	107	107	107	107	110	106	107	105	108	109	109	107	107	100	111	110	105	102	112	104	106	108	103	108	108	112	107	107	108	107	105	107	107	111	108	109	110	108	108	108	108	108	108	110	109	108	110	109	106	107	108	108	103	106	107	107	171;...
            255	117	191	195	194	194	189	190	194	192	194	197	193	194	195	191	195	194	193	193	193	195	194	195	194	194	194	194	194	194	194	194	196	194	195	192	193	192	194	196	191	195	194	193	197	194	192	194	194	192	194	197	193	194	195	191	195	194	193	193	193	195	194	195	194	194	194	194	194	194	194	194	196	194	195	192	193	192	194	196	191	195	194	193	197	194	192	194	194	192	194	197	193	194	195	191	195	194	193	193	193	195	194	195	194	194	194	194	194	194	194	194	196	194	195	192	193	192	194	196	191	195	194	193	197	194	192	194	194	192	194	197	193	194	195	191	195	194	193	193	193	195	194	195	194	194	194	194	194	194	194	194	196	194	195	192	193	192	194	196	191	195	194	193	197	194	192	194	194	192	194	197	193	194	195	191	195	194	193	193	193	195	194	195	194	194	194	194	194	194	194	194	196	194	195	192	193	192	194	196	191	195	194	193	197	194	192	194	194	192	194	197	193	194	195	191	195	194	193	193	193	195	194	195	194	194	194	194	194	194	194	194	193	193	195	193	194	191	192	191	198	195	196	192	199	195	197	193	192	192	196	200	189	193	192	191	195	196	193	194	192	193	191	193	195	194	193	192	192	193	194	195	193	192	192	193	194	195	194	195	194	191	187	115	161;...
            127	194	191	234	243	239	236	239	241	239	241	236	230	232	237	242	235	238	239	243	241	238	235	230	238	238	238	238	238	238	238	238	232	235	237	240	243	240	238	235	242	237	232	230	236	241	239	241	241	239	241	236	230	232	237	242	235	238	239	243	241	238	235	230	238	238	238	238	238	238	238	238	232	235	237	240	243	240	238	235	242	237	232	230	236	241	239	241	241	239	241	236	230	232	237	242	235	238	239	243	241	238	235	230	238	238	238	238	238	238	238	238	232	235	237	240	243	240	238	235	242	237	232	230	236	241	239	241	241	239	241	236	230	232	237	242	235	238	239	243	241	238	235	230	238	238	238	238	238	238	238	238	232	235	237	240	243	240	238	235	242	237	232	230	236	241	239	241	241	239	241	236	230	232	237	242	235	238	239	243	241	238	235	230	238	238	238	238	238	238	238	238	232	235	237	240	243	240	238	235	242	237	232	230	236	241	239	241	241	239	241	236	230	232	237	242	235	238	239	243	241	238	235	230	238	238	238	238	238	238	238	238	233	238	240	243	244	241	241	241	239	235	237	232	238	239	241	243	241	237	237	236	230	236	237	240	243	240	237	238	238	239	233	229	236	240	240	240	240	240	240	236	228	234	238	239	237	237	239	241	239	240	234	192	130;...
            107	194	236	243	236	235	236	238	233	234	237	239	255	254	238	236	238	239	235	235	234	238	254	255	237	237	237	237	237	237	237	237	255	253	237	234	236	235	239	238	236	238	254	255	239	237	234	233	233	234	237	239	255	254	238	236	238	239	235	235	234	238	254	255	237	237	237	237	237	237	237	237	255	253	237	234	236	235	239	238	236	238	254	255	239	237	234	233	233	234	237	239	255	254	238	236	238	239	235	235	234	238	254	255	237	237	237	237	237	237	237	237	255	253	237	234	236	235	239	238	236	238	254	255	239	237	234	233	233	234	237	239	255	254	238	236	238	239	235	235	234	238	254	255	237	237	237	237	237	237	237	237	255	253	237	234	236	235	239	238	236	238	254	255	239	237	234	233	233	234	237	239	255	254	238	236	238	239	235	235	234	238	254	255	237	237	237	237	237	237	237	237	255	253	237	234	236	235	239	238	236	238	254	255	239	237	234	233	233	234	237	239	255	254	238	236	238	239	235	235	234	238	254	255	237	237	237	237	237	237	237	237	254	252	239	238	238	237	240	241	242	239	255	251	238	235	237	233	233	236	237	242	253	255	235	236	236	235	236	236	235	240	251	255	237	239	233	233	233	233	239	237	255	251	239	236	235	237	234	236	238	240	248	236	114;...
            105	196	239	251	236	236	231	233	236	233	233	231	254	253	234	233	232	235	233	234	232	233	252	254	233	233	233	233	233	233	233	233	253	252	233	233	234	233	235	232	233	234	253	254	231	233	233	236	236	233	233	231	254	253	234	233	232	235	233	234	232	233	252	254	233	233	233	233	233	233	233	233	253	252	233	233	234	233	235	232	233	234	253	254	231	233	233	236	236	233	233	231	254	253	234	233	232	235	233	234	232	233	252	254	233	233	233	233	233	233	233	233	253	252	233	233	234	233	235	232	233	234	253	254	231	233	233	236	236	233	233	231	254	253	234	233	232	235	233	234	232	233	252	254	233	233	233	233	233	233	233	233	253	252	233	233	234	233	235	232	233	234	253	254	231	233	233	236	236	233	233	231	254	253	234	233	232	235	233	234	232	233	252	254	233	233	233	233	233	233	233	233	253	252	233	233	234	233	235	232	233	234	253	254	231	233	233	236	236	233	233	231	254	253	234	233	232	235	233	234	232	233	252	254	233	233	233	233	233	233	233	233	249	249	231	231	233	230	233	231	231	227	254	253	232	229	233	229	233	232	231	233	252	255	234	235	233	233	233	232	229	234	251	255	232	234	231	235	235	231	234	232	255	252	233	230	230	234	233	234	233	230	251	231	113;...
            109	194	239	255	229	230	228	229	227	223	234	230	245	245	229	230	225	227	225	229	228	228	250	248	226	226	226	226	226	226	226	226	248	251	229	228	228	224	227	227	230	229	245	245	230	234	223	227	227	223	234	230	245	245	229	230	225	227	225	229	228	228	250	248	226	226	226	226	226	226	226	226	248	251	229	228	228	224	227	227	230	229	245	245	230	234	223	227	227	223	234	230	245	245	229	230	225	227	225	229	228	228	250	248	226	226	226	226	226	226	226	226	248	251	229	228	228	224	227	227	230	229	245	245	230	234	223	227	227	223	234	230	245	245	229	230	225	227	225	229	228	228	250	248	226	226	226	226	226	226	226	226	248	251	229	228	228	224	227	227	230	229	245	245	230	234	223	227	227	223	234	230	245	245	229	230	225	227	225	229	228	228	250	248	226	226	226	226	226	226	226	226	248	251	229	228	228	224	227	227	230	229	245	245	230	234	223	227	227	223	234	230	245	245	229	230	225	227	225	229	228	228	250	248	226	226	226	226	226	226	226	226	255	255	231	229	230	226	231	232	233	227	250	247	228	230	229	229	228	224	229	230	244	249	229	229	228	225	227	228	230	232	244	242	230	231	223	228	228	223	231	230	243	245	231	229	226	227	226	231	228	227	247	239	114;...
            111	191	235	249	224	219	221	221	228	219	226	221	244	244	222	219	220	222	219	225	224	223	247	242	223	223	223	223	223	223	223	223	243	247	222	223	224	219	222	221	219	222	244	244	221	226	219	228	228	219	226	221	244	244	222	219	220	222	219	225	224	223	247	242	223	223	223	223	223	223	223	223	243	247	222	223	224	219	222	221	219	222	244	244	221	226	219	228	228	219	226	221	244	244	222	219	220	222	219	225	224	223	247	242	223	223	223	223	223	223	223	223	243	247	222	223	224	219	222	221	219	222	244	244	221	226	219	228	228	219	226	221	244	244	222	219	220	222	219	225	224	223	247	242	223	223	223	223	223	223	223	223	243	247	222	223	224	219	222	221	219	222	244	244	221	226	219	228	228	219	226	221	244	244	222	219	220	222	219	225	224	223	247	242	223	223	223	223	223	223	223	223	243	247	222	223	224	219	222	221	219	222	244	244	221	226	219	228	228	219	226	221	244	244	222	219	220	222	219	225	224	223	247	242	223	223	223	223	223	223	223	223	241	247	223	223	223	217	221	219	222	220	245	243	225	226	220	221	224	219	226	225	240	245	222	224	222	221	225	223	219	221	242	245	221	226	219	226	226	219	226	221	245	243	221	219	220	226	222	225	224	224	245	233	114;...
            106	196	235	255	218	222	215	220	218	217	222	216	246	245	217	221	220	221	216	219	219	218	246	243	218	218	218	218	218	218	218	218	243	246	218	219	220	217	221	219	221	217	245	246	216	222	217	218	218	217	222	216	246	245	217	221	220	221	216	219	219	218	246	243	218	218	218	218	218	218	218	218	243	246	218	219	220	217	221	219	221	217	245	246	216	222	217	218	218	217	222	216	246	245	217	221	220	221	216	219	219	218	246	243	218	218	218	218	218	218	218	218	243	246	218	219	220	217	221	219	221	217	245	246	216	222	217	218	218	217	222	216	246	245	217	221	220	221	216	219	219	218	246	243	218	218	218	218	218	218	218	218	243	246	218	219	220	217	221	219	221	217	245	246	216	222	217	218	218	217	222	216	246	245	217	221	220	221	216	219	219	218	246	243	218	218	218	218	218	218	218	218	243	246	218	219	220	217	221	219	221	217	245	246	216	222	217	218	218	217	222	216	246	245	217	221	220	221	216	219	219	218	246	243	218	218	218	218	218	218	218	218	241	244	216	218	219	215	220	219	218	215	245	241	216	218	216	218	219	217	220	218	244	247	217	221	218	215	220	219	217	221	243	245	216	223	215	219	219	215	223	216	246	244	220	218	217	219	215	218	221	220	247	232	117;...
            108	191	241	252	212	212	212	215	213	216	210	211	242	238	214	211	213	215	214	213	214	216	237	242	215	215	215	215	215	215	215	215	241	235	216	213	211	214	214	214	212	213	239	241	211	210	215	213	213	216	210	211	242	238	214	211	213	215	214	213	214	216	237	242	215	215	215	215	215	215	215	215	241	235	216	213	211	214	214	214	212	213	239	241	211	210	215	213	213	216	210	211	242	238	214	211	213	215	214	213	214	216	237	242	215	215	215	215	215	215	215	215	241	235	216	213	211	214	214	214	212	213	239	241	211	210	215	213	213	216	210	211	242	238	214	211	213	215	214	213	214	216	237	242	215	215	215	215	215	215	215	215	241	235	216	213	211	214	214	214	212	213	239	241	211	210	215	213	213	216	210	211	242	238	214	211	213	215	214	213	214	216	237	242	215	215	215	215	215	215	215	215	241	235	216	213	211	214	214	214	212	213	239	241	211	210	215	213	213	216	210	211	242	238	214	211	213	215	214	213	214	216	237	242	215	215	215	215	215	215	215	215	241	239	219	214	212	212	210	212	213	211	236	242	214	215	218	215	218	213	214	215	239	235	220	209	207	216	214	212	213	216	235	245	213	213	212	214	214	212	213	213	245	235	214	212	210	216	215	208	214	215	239	230	118;...
            105	198	236	255	213	210	209	212	210	215	206	209	248	244	211	208	210	212	213	210	210	210	239	244	210	210	210	210	210	210	210	210	245	239	211	210	209	214	211	211	210	210	245	247	208	207	214	211	210	215	206	209	248	244	211	208	210	212	213	210	210	210	239	244	210	210	210	210	210	210	210	210	245	239	211	210	209	214	211	211	210	210	245	247	208	207	214	211	210	215	206	209	248	244	211	208	210	212	213	210	210	210	239	244	210	210	210	210	210	210	210	210	245	239	211	210	209	214	211	211	210	210	245	247	208	207	214	211	210	215	206	209	248	244	211	208	210	212	213	210	210	210	239	244	210	210	210	210	210	210	210	210	245	239	211	210	209	214	211	211	210	210	245	247	208	207	214	211	210	215	206	209	248	244	211	208	210	212	213	210	210	210	239	244	210	210	210	210	210	210	210	210	245	239	211	210	209	214	211	211	210	210	245	247	208	207	214	211	210	215	206	209	248	244	211	208	210	212	213	210	210	210	239	244	210	210	210	210	210	210	210	210	244	239	210	209	210	215	213	214	214	214	243	246	212	210	208	206	212	213	209	207	248	243	212	208	207	215	210	209	208	213	241	251	209	209	210	212	212	210	209	209	250	240	213	209	207	212	214	206	208	213	241	233	113;...
            109	193	236	255	211	214	212	216	217	215	215	215	240	241	217	217	211	211	217	217	220	217	248	245	215	215	215	215	215	215	215	215	245	246	217	220	217	219	212	214	218	217	242	239	214	215	214	218	217	215	215	215	240	241	217	217	211	211	217	217	220	217	248	245	215	215	215	215	215	215	215	215	245	246	217	220	217	219	212	214	218	217	242	239	214	215	214	218	217	215	215	215	240	241	217	217	211	211	217	217	220	217	248	245	215	215	215	215	215	215	215	215	245	246	217	220	217	219	212	214	218	217	242	239	214	215	214	218	217	215	215	215	240	241	217	217	211	211	217	217	220	217	248	245	215	215	215	215	215	215	215	215	245	246	217	220	217	219	212	214	218	217	242	239	214	215	214	218	217	215	215	215	240	241	217	217	211	211	217	217	220	217	248	245	215	215	215	215	215	215	215	215	245	246	217	220	217	219	212	214	218	217	242	239	214	215	214	218	217	215	215	215	240	241	217	217	211	211	217	217	220	217	248	245	215	215	215	215	215	215	215	215	244	244	214	216	214	217	213	214	217	215	246	246	213	212	214	214	212	213	215	211	244	245	214	220	215	221	213	216	216	216	241	240	215	215	217	217	217	217	215	215	241	241	216	216	214	213	220	216	219	216	246	231	114;...
            109	194	238	255	220	222	224	215	223	219	222	224	246	250	226	223	221	219	223	223	224	219	253	247	220	220	220	220	220	220	220	220	249	253	220	224	222	224	217	219	224	225	251	245	223	222	218	224	223	219	222	224	246	250	226	223	221	219	223	223	224	219	253	247	220	220	220	220	220	220	220	220	249	253	220	224	222	224	217	219	224	225	251	245	223	222	218	224	223	219	222	224	246	250	226	223	221	219	223	223	224	219	253	247	220	220	220	220	220	220	220	220	249	253	220	224	222	224	217	219	224	225	251	245	223	222	218	224	223	219	222	224	246	250	226	223	221	219	223	223	224	219	253	247	220	220	220	220	220	220	220	220	249	253	220	224	222	224	217	219	224	225	251	245	223	222	218	224	223	219	222	224	246	250	226	223	221	219	223	223	224	219	253	247	220	220	220	220	220	220	220	220	249	253	220	224	222	224	217	219	224	225	251	245	223	222	218	224	223	219	222	224	246	250	226	223	221	219	223	223	224	219	253	247	220	220	220	220	220	220	220	220	252	252	221	225	220	224	221	223	228	222	249	248	224	225	222	218	221	219	223	220	250	253	221	225	224	229	218	223	225	223	250	243	222	222	224	225	225	224	222	222	246	250	223	223	221	218	228	226	226	220	255	240	116;...
            109	189	235	255	227	227	228	228	225	229	223	221	250	251	221	228	224	226	232	228	225	217	250	248	227	227	227	227	227	227	227	227	247	247	216	224	227	233	226	225	228	220	252	250	221	224	228	225	225	229	223	221	250	251	221	228	224	226	232	228	225	217	250	248	227	227	227	227	227	227	227	227	247	247	216	224	227	233	226	225	228	220	252	250	221	224	228	225	225	229	223	221	250	251	221	228	224	226	232	228	225	217	250	248	227	227	227	227	227	227	227	227	247	247	216	224	227	233	226	225	228	220	252	250	221	224	228	225	225	229	223	221	250	251	221	228	224	226	232	228	225	217	250	248	227	227	227	227	227	227	227	227	247	247	216	224	227	233	226	225	228	220	252	250	221	224	228	225	225	229	223	221	250	251	221	228	224	226	232	228	225	217	250	248	227	227	227	227	227	227	227	227	247	247	216	224	227	233	226	225	228	220	252	250	221	224	228	225	225	229	223	221	250	251	221	228	224	226	232	228	225	217	250	248	227	227	227	227	227	227	227	227	251	250	219	226	225	229	226	224	223	226	254	251	226	223	226	228	225	231	227	223	252	251	215	226	225	231	223	225	224	222	251	250	223	222	225	226	226	225	222	223	250	251	224	224	226	224	229	225	222	219	251	228	123;...
            108	192	242	255	229	230	240	230	229	227	223	230	254	255	231	226	233	232	230	227	230	229	254	255	233	233	233	233	233	233	233	233	255	255	230	229	227	230	230	232	225	229	255	255	231	224	227	229	229	227	223	230	254	255	231	226	233	232	230	227	230	229	254	255	233	233	233	233	233	233	233	233	255	255	230	229	227	230	230	232	225	229	255	255	231	224	227	229	229	227	223	230	254	255	231	226	233	232	230	227	230	229	254	255	233	233	233	233	233	233	233	233	255	255	230	229	227	230	230	232	225	229	255	255	231	224	227	229	229	227	223	230	254	255	231	226	233	232	230	227	230	229	254	255	233	233	233	233	233	233	233	233	255	255	230	229	227	230	230	232	225	229	255	255	231	224	227	229	229	227	223	230	254	255	231	226	233	232	230	227	230	229	254	255	233	233	233	233	233	233	233	233	255	255	230	229	227	230	230	232	225	229	255	255	231	224	227	229	229	227	223	230	254	255	231	226	233	232	230	227	230	229	254	255	233	233	233	233	233	233	233	233	255	255	234	233	230	233	236	236	225	233	255	253	236	229	230	229	231	230	226	235	255	255	231	227	228	230	226	225	229	232	255	255	228	227	229	230	230	229	227	228	255	255	233	228	226	226	229	230	230	229	251	246	118;...
            127	191	238	230	255	251	250	249	254	254	255	254	244	246	252	255	251	255	252	255	255	251	249	246	255	255	255	255	255	255	255	255	247	249	252	255	254	253	255	253	255	251	247	244	255	255	254	255	254	254	255	254	244	246	252	255	251	255	252	255	255	251	249	246	255	255	255	255	255	255	255	255	247	249	252	255	254	253	255	253	255	251	247	244	255	255	254	255	254	254	255	254	244	246	252	255	251	255	252	255	255	251	249	246	255	255	255	255	255	255	255	255	247	249	252	255	254	253	255	253	255	251	247	244	255	255	254	255	254	254	255	254	244	246	252	255	251	255	252	255	255	251	249	246	255	255	255	255	255	255	255	255	247	249	252	255	254	253	255	253	255	251	247	244	255	255	254	255	254	254	255	254	244	246	252	255	251	255	252	255	255	251	249	246	255	255	255	255	255	255	255	255	247	249	252	255	254	253	255	253	255	251	247	244	255	255	254	255	254	254	255	254	244	246	252	255	251	255	252	255	255	251	249	246	255	255	255	255	255	255	255	255	244	249	252	255	254	254	254	253	255	251	249	247	252	255	255	255	255	255	255	255	243	247	255	255	252	253	255	255	255	251	248	240	255	254	253	254	254	253	254	255	242	248	252	255	255	255	253	254	255	252	249	228	123;...
            255	119	244	236	238	241	242	240	239	240	240	243	240	243	242	241	242	245	238	239	241	241	239	241	240	240	240	240	240	240	240	240	242	239	243	241	238	238	243	242	241	240	244	240	243	241	239	240	239	240	240	243	240	243	242	241	242	245	238	239	241	241	239	241	240	240	240	240	240	240	240	240	242	239	243	241	238	238	243	242	241	240	244	240	243	241	239	240	239	240	240	243	240	243	242	241	242	245	238	239	241	241	239	241	240	240	240	240	240	240	240	240	242	239	243	241	238	238	243	242	241	240	244	240	243	241	239	240	239	240	240	243	240	243	242	241	242	245	238	239	241	241	239	241	240	240	240	240	240	240	240	240	242	239	243	241	238	238	243	242	241	240	244	240	243	241	239	240	239	240	240	243	240	243	242	241	242	245	238	239	241	241	239	241	240	240	240	240	240	240	240	240	242	239	243	241	238	238	243	242	241	240	244	240	243	241	239	240	239	240	240	243	240	243	242	241	242	245	238	239	241	241	239	241	240	240	240	240	240	240	240	240	240	238	241	239	238	239	242	241	237	243	243	240	242	236	241	239	240	240	231	242	236	239	243	236	236	235	245	238	241	240	240	242	241	241	238	239	239	238	241	241	243	239	243	241	238	246	236	237	237	241	229	124	201;...
            255	255	130	108	109	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	107	106	107	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	119	201	176];
    
    a(:,:,3) = [...
            252	255	132	103	109	103	112	105	108	112	112	111	103	102	107	109	111	109	106	107	107	111	102	105	108	108	108	108	108	108	108	108	104	102	112	108	107	106	108	111	109	107	102	103	111	112	112	108	108	112	112	111	103	102	107	109	111	109	106	107	107	111	102	105	108	108	108	108	108	108	108	108	104	102	112	108	107	106	108	111	109	107	102	103	111	112	112	108	108	112	112	111	103	102	107	109	111	109	106	107	107	111	102	105	108	108	108	108	108	108	108	108	104	102	112	108	107	106	108	111	109	107	102	103	111	112	112	108	108	112	112	111	103	102	107	109	111	109	106	107	107	111	102	105	108	108	108	108	108	108	108	108	104	102	112	108	107	106	108	111	109	107	102	103	111	112	112	108	108	112	112	111	103	102	107	109	111	109	106	107	107	111	102	105	108	108	108	108	108	108	108	108	104	102	112	108	107	106	108	111	109	107	102	103	111	112	112	108	108	112	112	111	103	102	107	109	111	109	106	107	107	111	102	105	108	108	108	108	108	108	108	108	105	102	114	109	107	107	111	111	112	107	103	107	110	110	111	105	107	110	110	111	103	102	108	107	103	107	110	112	108	109	101	103	112	110	110	111	111	110	110	112	105	101	108	107	107	110	110	108	110	113	105	105	169;...
            251	115	191	198	196	199	196	199	191	191	195	196	193	194	190	188	197	192	188	188	192	193	195	193	191	191	191	191	191	191	191	191	194	195	193	191	188	187	192	198	188	190	194	193	196	195	191	191	191	191	195	196	193	194	190	188	197	192	188	188	192	193	195	193	191	191	191	191	191	191	191	191	194	195	193	191	188	187	192	198	188	190	194	193	196	195	191	191	191	191	195	196	193	194	190	188	197	192	188	188	192	193	195	193	191	191	191	191	191	191	191	191	194	195	193	191	188	187	192	198	188	190	194	193	196	195	191	191	191	191	195	196	193	194	190	188	197	192	188	188	192	193	195	193	191	191	191	191	191	191	191	191	194	195	193	191	188	187	192	198	188	190	194	193	196	195	191	191	191	191	195	196	193	194	190	188	197	192	188	188	192	193	195	193	191	191	191	191	191	191	191	191	194	195	193	191	188	187	192	198	188	190	194	193	196	195	191	191	191	191	195	196	193	194	190	188	197	192	188	188	192	193	195	193	191	191	191	191	191	191	191	191	192	195	196	193	192	190	193	195	197	196	195	194	198	197	192	188	190	191	198	199	193	191	190	187	189	192	195	196	191	190	192	194	194	193	192	191	191	192	193	194	198	195	187	190	193	194	193	191	194	190	185	111	157;...
            122	191	192	239	230	231	230	235	235	235	235	233	248	250	231	236	234	233	234	237	236	232	253	246	243	243	243	243	243	243	243	243	248	253	231	235	237	235	233	234	236	231	250	248	233	235	235	235	235	235	235	233	248	250	231	236	234	233	234	237	236	232	253	246	243	243	243	243	243	243	243	243	248	253	231	235	237	235	233	234	236	231	250	248	233	235	235	235	235	235	235	233	248	250	231	236	234	233	234	237	236	232	253	246	243	243	243	243	243	243	243	243	248	253	231	235	237	235	233	234	236	231	250	248	233	235	235	235	235	235	235	233	248	250	231	236	234	233	234	237	236	232	253	246	243	243	243	243	243	243	243	243	248	253	231	235	237	235	233	234	236	231	250	248	233	235	235	235	235	235	235	233	248	250	231	236	234	233	234	237	236	232	253	246	243	243	243	243	243	243	243	243	248	253	231	235	237	235	233	234	236	231	250	248	233	235	235	235	235	235	235	233	248	250	231	236	234	233	234	237	236	232	253	246	243	243	243	243	243	243	243	243	247	254	234	235	236	234	235	237	235	235	254	251	234	234	233	237	237	235	235	232	249	252	232	235	236	234	235	234	234	232	252	247	231	234	236	235	235	236	234	231	248	255	231	234	233	235	234	236	232	233	243	200	138;...
            108	196	236	239	180	175	176	175	172	176	174	182	243	244	177	175	177	176	175	173	174	178	244	246	171	171	171	171	171	171	171	171	246	243	177	174	174	175	176	177	175	177	244	243	182	174	176	172	172	176	174	182	243	244	177	175	177	176	175	173	174	178	244	246	171	171	171	171	171	171	171	171	246	243	177	174	174	175	176	177	175	177	244	243	182	174	176	172	172	176	174	182	243	244	177	175	177	176	175	173	174	178	244	246	171	171	171	171	171	171	171	171	246	243	177	174	174	175	176	177	175	177	244	243	182	174	176	172	172	176	174	182	243	244	177	175	177	176	175	173	174	178	244	246	171	171	171	171	171	171	171	171	246	243	177	174	174	175	176	177	175	177	244	243	182	174	176	172	172	176	174	182	243	244	177	175	177	176	175	173	174	178	244	246	171	171	171	171	171	171	171	171	246	243	177	174	174	175	176	177	175	177	244	243	182	174	176	172	172	176	174	182	243	244	177	175	177	176	175	173	174	178	244	246	171	171	171	171	171	171	171	171	248	246	183	180	178	179	180	184	182	183	246	243	182	176	177	175	173	177	176	183	242	243	175	174	175	175	176	176	176	178	242	243	177	177	175	173	173	175	177	177	245	242	177	176	175	177	174	175	176	180	232	222	100;...
            106	198	240	247	154	150	145	147	155	157	148	155	250	255	153	152	152	150	155	153	154	154	253	255	148	148	148	148	148	148	148	148	254	253	154	155	153	155	150	152	152	153	255	250	155	148	157	155	155	157	148	155	250	255	153	152	152	150	155	153	154	154	253	255	148	148	148	148	148	148	148	148	254	253	154	155	153	155	150	152	152	153	255	250	155	148	157	155	155	157	148	155	250	255	153	152	152	150	155	153	154	154	253	255	148	148	148	148	148	148	148	148	254	253	154	155	153	155	150	152	152	153	255	250	155	148	157	155	155	157	148	155	250	255	153	152	152	150	155	153	154	154	253	255	148	148	148	148	148	148	148	148	254	253	154	155	153	155	150	152	152	153	255	250	155	148	157	155	155	157	148	155	250	255	153	152	152	150	155	153	154	154	253	255	148	148	148	148	148	148	148	148	254	253	154	155	153	155	150	152	152	153	255	250	155	148	157	155	155	157	148	155	250	255	153	152	152	150	155	153	154	154	253	255	148	148	148	148	148	148	148	148	252	252	154	155	154	156	152	153	153	153	255	254	156	150	155	150	152	155	148	155	250	255	154	154	155	151	154	150	152	153	253	254	154	154	155	157	157	155	154	154	255	254	152	153	148	155	151	155	156	156	246	229	111;...
            107	192	240	255	127	129	127	130	117	119	120	126	241	245	120	121	120	118	123	120	121	117	246	244	127	127	127	127	127	127	127	127	244	247	118	121	119	122	118	122	121	120	245	241	126	120	119	117	117	119	120	126	241	245	120	121	120	118	123	120	121	117	246	244	127	127	127	127	127	127	127	127	244	247	118	121	119	122	118	122	121	120	245	241	126	120	119	117	117	119	120	126	241	245	120	121	120	118	123	120	121	117	246	244	127	127	127	127	127	127	127	127	244	247	118	121	119	122	118	122	121	120	245	241	126	120	119	117	117	119	120	126	241	245	120	121	120	118	123	120	121	117	246	244	127	127	127	127	127	127	127	127	244	247	118	121	119	122	118	122	121	120	245	241	126	120	119	117	117	119	120	126	241	245	120	121	120	118	123	120	121	117	246	244	127	127	127	127	127	127	127	127	244	247	118	121	119	122	118	122	121	120	245	241	126	120	119	117	117	119	120	126	241	245	120	121	120	118	123	120	121	117	246	244	127	127	127	127	127	127	127	127	248	249	119	119	118	124	119	124	121	120	247	242	123	118	121	122	119	119	118	125	240	247	120	119	125	116	119	116	124	121	245	237	124	121	119	120	120	119	121	124	238	246	122	126	116	119	117	126	126	127	237	231	106;...
            109	191	237	251	108	103	107	108	110	107	101	107	248	255	105	103	106	102	109	105	107	102	254	249	104	104	104	104	104	104	104	104	250	254	101	106	104	109	102	107	103	105	255	248	107	101	107	110	110	107	101	107	248	255	105	103	106	102	109	105	107	102	254	249	104	104	104	104	104	104	104	104	250	254	101	106	104	109	102	107	103	105	255	248	107	101	107	110	110	107	101	107	248	255	105	103	106	102	109	105	107	102	254	249	104	104	104	104	104	104	104	104	250	254	101	106	104	109	102	107	103	105	255	248	107	101	107	110	110	107	101	107	248	255	105	103	106	102	109	105	107	102	254	249	104	104	104	104	104	104	104	104	250	254	101	106	104	109	102	107	103	105	255	248	107	101	107	110	110	107	101	107	248	255	105	103	106	102	109	105	107	102	254	249	104	104	104	104	104	104	104	104	250	254	101	106	104	109	102	107	103	105	255	248	107	101	107	110	110	107	101	107	248	255	105	103	106	102	109	105	107	102	254	249	104	104	104	104	104	104	104	104	248	254	104	107	107	110	101	105	101	103	253	247	109	102	104	104	104	105	100	108	247	254	104	104	111	103	107	100	104	102	255	251	105	105	106	108	108	106	105	105	249	255	102	105	100	108	101	109	108	110	242	232	113;...
            109	199	234	250	77	79	69	73	79	83	75	81	241	247	79	81	79	75	84	78	81	78	245	243	78	78	78	78	78	78	78	78	243	245	78	81	79	85	75	78	81	79	247	241	81	75	83	79	79	83	75	81	241	247	79	81	79	75	84	78	81	78	245	243	78	78	78	78	78	78	78	78	243	245	78	81	79	85	75	78	81	79	247	241	81	75	83	79	79	83	75	81	241	247	79	81	79	75	84	78	81	78	245	243	78	78	78	78	78	78	78	78	243	245	78	81	79	85	75	78	81	79	247	241	81	75	83	79	79	83	75	81	241	247	79	81	79	75	84	78	81	78	245	243	78	78	78	78	78	78	78	78	243	245	78	81	79	85	75	78	81	79	247	241	81	75	83	79	79	83	75	81	241	247	79	81	79	75	84	78	81	78	245	243	78	78	78	78	78	78	78	78	243	245	78	81	79	85	75	78	81	79	247	241	81	75	83	79	79	83	75	81	241	247	79	81	79	75	84	78	81	78	245	243	78	78	78	78	78	78	78	78	243	246	77	80	80	86	77	81	78	79	245	238	82	74	82	82	78	82	74	81	240	246	77	80	86	77	79	76	81	81	247	242	79	81	81	80	80	81	81	79	239	248	80	84	76	80	74	84	79	81	231	220	105;...
            109	194	243	255	48	53	51	56	58	51	57	62	233	244	56	55	52	60	57	57	56	51	244	244	54	54	54	54	54	54	54	54	243	242	51	55	55	57	59	53	56	55	245	232	62	57	50	58	58	51	57	62	233	244	56	55	52	60	57	57	56	51	244	244	54	54	54	54	54	54	54	54	243	242	51	55	55	57	59	53	56	55	245	232	62	57	50	58	58	51	57	62	233	244	56	55	52	60	57	57	56	51	244	244	54	54	54	54	54	54	54	54	243	242	51	55	55	57	59	53	56	55	245	232	62	57	50	58	58	51	57	62	233	244	56	55	52	60	57	57	56	51	244	244	54	54	54	54	54	54	54	54	243	242	51	55	55	57	59	53	56	55	245	232	62	57	50	58	58	51	57	62	233	244	56	55	52	60	57	57	56	51	244	244	54	54	54	54	54	54	54	54	243	242	51	55	55	57	59	53	56	55	245	232	62	57	50	58	58	51	57	62	233	244	56	55	52	60	57	57	56	51	244	244	54	54	54	54	54	54	54	54	245	246	54	57	58	57	58	56	66	53	250	240	59	55	52	49	55	54	58	59	235	239	51	53	64	50	58	50	60	48	251	228	55	61	50	60	60	50	61	55	228	246	52	55	56	55	53	63	58	57	230	219	107;...
            105	200	235	255	52	55	51	56	51	50	47	54	237	246	47	46	45	53	49	50	48	46	241	245	49	49	49	49	49	49	49	49	246	241	47	48	49	50	52	46	48	46	247	236	53	48	49	52	51	50	47	54	237	246	47	46	45	53	49	50	48	46	241	245	49	49	49	49	49	49	49	49	246	241	47	48	49	50	52	46	48	46	247	236	53	48	49	52	51	50	47	54	237	246	47	46	45	53	49	50	48	46	241	245	49	49	49	49	49	49	49	49	246	241	47	48	49	50	52	46	48	46	247	236	53	48	49	52	51	50	47	54	237	246	47	46	45	53	49	50	48	46	241	245	49	49	49	49	49	49	49	49	246	241	47	48	49	50	52	46	48	46	247	236	53	48	49	52	51	50	47	54	237	246	47	46	45	53	49	50	48	46	241	245	49	49	49	49	49	49	49	49	246	241	47	48	49	50	52	46	48	46	247	236	53	48	49	52	51	50	47	54	237	246	47	46	45	53	49	50	48	46	241	245	49	49	49	49	49	49	49	49	245	241	48	50	50	54	55	51	48	44	244	237	57	54	53	53	50	52	48	52	242	246	48	52	54	46	53	45	50	42	250	237	49	51	46	52	52	46	51	49	236	245	47	46	52	50	47	52	48	54	227	221	101;...
            106	193	233	253	61	65	60	67	68	68	65	72	240	248	65	67	65	69	64	66	71	70	250	249	70	70	70	70	70	70	70	70	249	248	70	71	66	66	70	68	68	65	249	239	71	65	67	69	68	68	65	72	240	248	65	67	65	69	64	66	71	70	250	249	70	70	70	70	70	70	70	70	249	248	70	71	66	66	70	68	68	65	249	239	71	65	67	69	68	68	65	72	240	248	65	67	65	69	64	66	71	70	250	249	70	70	70	70	70	70	70	70	249	248	70	71	66	66	70	68	68	65	249	239	71	65	67	69	68	68	65	72	240	248	65	67	65	69	64	66	71	70	250	249	70	70	70	70	70	70	70	70	249	248	70	71	66	66	70	68	68	65	249	239	71	65	67	69	68	68	65	72	240	248	65	67	65	69	64	66	71	70	250	249	70	70	70	70	70	70	70	70	249	248	70	71	66	66	70	68	68	65	249	239	71	65	67	69	68	68	65	72	240	248	65	67	65	69	64	66	71	70	250	249	70	70	70	70	70	70	70	70	249	247	69	71	66	67	70	67	68	69	254	244	72	61	64	70	71	70	70	74	244	254	70	71	68	64	70	66	69	61	252	243	70	66	71	66	66	71	66	70	242	250	63	66	71	69	65	66	67	73	234	226	109;...
            105	195	238	255	99	102	104	100	90	91	84	94	248	255	90	88	94	93	84	86	93	93	248	248	94	94	94	94	94	94	94	94	250	248	94	93	85	85	91	92	89	89	255	247	93	84	90	91	90	91	84	94	248	255	90	88	94	93	84	86	93	93	248	248	94	94	94	94	94	94	94	94	250	248	94	93	85	85	91	92	89	89	255	247	93	84	90	91	90	91	84	94	248	255	90	88	94	93	84	86	93	93	248	248	94	94	94	94	94	94	94	94	250	248	94	93	85	85	91	92	89	89	255	247	93	84	90	91	90	91	84	94	248	255	90	88	94	93	84	86	93	93	248	248	94	94	94	94	94	94	94	94	250	248	94	93	85	85	91	92	89	89	255	247	93	84	90	91	90	91	84	94	248	255	90	88	94	93	84	86	93	93	248	248	94	94	94	94	94	94	94	94	250	248	94	93	85	85	91	92	89	89	255	247	93	84	90	91	90	91	84	94	248	255	90	88	94	93	84	86	93	93	248	248	94	94	94	94	94	94	94	94	250	248	96	96	88	88	95	96	87	90	252	244	98	91	93	94	96	87	91	99	246	255	93	88	86	88	91	91	90	85	255	251	95	84	95	89	89	95	84	95	251	255	86	88	91	91	87	85	89	94	239	233	109;...
            108	191	232	248	118	115	112	115	120	129	115	119	252	254	114	123	120	124	118	121	122	122	246	249	119	119	119	119	119	119	119	119	248	243	121	121	120	119	124	121	123	113	255	252	119	116	128	120	120	129	115	119	252	254	114	123	120	124	118	121	122	122	246	249	119	119	119	119	119	119	119	119	248	243	121	121	120	119	124	121	123	113	255	252	119	116	128	120	120	129	115	119	252	254	114	123	120	124	118	121	122	122	246	249	119	119	119	119	119	119	119	119	248	243	121	121	120	119	124	121	123	113	255	252	119	116	128	120	120	129	115	119	252	254	114	123	120	124	118	121	122	122	246	249	119	119	119	119	119	119	119	119	248	243	121	121	120	119	124	121	123	113	255	252	119	116	128	120	120	129	115	119	252	254	114	123	120	124	118	121	122	122	246	249	119	119	119	119	119	119	119	119	248	243	121	121	120	119	124	121	123	113	255	252	119	116	128	120	120	129	115	119	252	254	114	123	120	124	118	121	122	122	246	249	119	119	119	119	119	119	119	119	249	245	125	125	120	120	124	122	119	129	255	246	125	114	119	127	122	120	117	122	245	252	119	119	115	120	124	123	119	114	254	253	124	115	127	118	118	127	115	124	251	254	116	121	124	127	118	113	120	125	239	223	118;...
            108	194	236	248	145	143	146	138	147	146	140	146	237	241	148	144	148	153	142	144	149	153	233	237	144	144	144	144	144	144	144	144	240	234	154	148	144	142	151	147	143	146	242	238	147	141	146	147	147	146	140	146	237	241	148	144	148	153	142	144	149	153	233	237	144	144	144	144	144	144	144	144	240	234	154	148	144	142	151	147	143	146	242	238	147	141	146	147	147	146	140	146	237	241	148	144	148	153	142	144	149	153	233	237	144	144	144	144	144	144	144	144	240	234	154	148	144	142	151	147	143	146	242	238	147	141	146	147	147	146	140	146	237	241	148	144	148	153	142	144	149	153	233	237	144	144	144	144	144	144	144	144	240	234	154	148	144	142	151	147	143	146	242	238	147	141	146	147	147	146	140	146	237	241	148	144	148	153	142	144	149	153	233	237	144	144	144	144	144	144	144	144	240	234	154	148	144	142	151	147	143	146	242	238	147	141	146	147	147	146	140	146	237	241	148	144	148	153	142	144	149	153	233	237	144	144	144	144	144	144	144	144	238	234	158	154	148	146	158	155	157	163	243	234	151	139	136	138	148	143	140	150	230	240	150	142	146	143	144	143	145	147	240	236	148	144	150	146	146	150	144	148	235	240	146	150	142	149	140	145	149	152	225	225	97;...
            124	195	245	253	244	253	255	255	253	247	255	248	255	255	246	253	246	255	244	255	253	246	255	255	253	253	253	253	253	253	253	253	255	255	247	253	254	245	255	248	253	245	255	255	249	255	247	254	253	247	255	248	255	255	246	253	246	255	244	255	253	246	255	255	253	253	253	253	253	253	253	253	255	255	247	253	254	245	255	248	253	245	255	255	249	255	247	254	253	247	255	248	255	255	246	253	246	255	244	255	253	246	255	255	253	253	253	253	253	253	253	253	255	255	247	253	254	245	255	248	253	245	255	255	249	255	247	254	253	247	255	248	255	255	246	253	246	255	244	255	253	246	255	255	253	253	253	253	253	253	253	253	255	255	247	253	254	245	255	248	253	245	255	255	249	255	247	254	253	247	255	248	255	255	246	253	246	255	244	255	253	246	255	255	253	253	253	253	253	253	253	253	255	255	247	253	254	245	255	248	253	245	255	255	249	255	247	254	253	247	255	248	255	255	246	253	246	255	244	255	253	246	255	255	253	253	253	253	253	253	253	253	255	255	245	254	255	246	255	249	253	240	255	255	244	255	255	255	255	253	255	249	255	255	245	254	255	247	251	251	255	243	255	248	250	252	247	253	253	247	252	250	248	255	241	255	249	255	245	255	253	244	255	242	137;...
            253	120	246	250	224	238	241	242	243	233	245	238	234	242	239	240	237	248	234	244	242	236	241	237	241	241	241	241	241	241	241	241	238	241	238	242	243	234	246	237	240	237	243	234	238	246	232	244	243	233	245	238	234	242	239	240	237	248	234	244	242	236	241	237	241	241	241	241	241	241	241	241	238	241	238	242	243	234	246	237	240	237	243	234	238	246	232	244	243	233	245	238	234	242	239	240	237	248	234	244	242	236	241	237	241	241	241	241	241	241	241	241	238	241	238	242	243	234	246	237	240	237	243	234	238	246	232	244	243	233	245	238	234	242	239	240	237	248	234	244	242	236	241	237	241	241	241	241	241	241	241	241	238	241	238	242	243	234	246	237	240	237	243	234	238	246	232	244	243	233	245	238	234	242	239	240	237	248	234	244	242	236	241	237	241	241	241	241	241	241	241	241	238	241	238	242	243	234	246	237	240	237	243	234	238	246	232	244	243	233	245	238	234	242	239	240	237	248	234	244	242	236	241	237	241	241	241	241	241	241	241	241	236	242	236	238	241	234	245	236	241	233	241	240	235	244	243	240	242	245	238	234	241	243	236	241	247	233	236	233	243	236	246	225	235	245	233	243	243	233	245	235	221	247	234	251	230	243	230	248	239	236	231	120	197;...
            255	255	130	108	109	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	107	107	106	106	107	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	108	119	201	176];

end


a=a/255;


% --- Executes during object creation, after setting all properties.
function blend_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to blend_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function blend_slider_Callback(hObject, eventdata, handles)
% hObject    handle to blend_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
blend = num2str(round(100*get(hObject,'value')));
set(handles.blend_text,'string',blend);

function img = imfade(img1,img2,s),

s1 = s; 
s2 = 1-s1;
img = (imadd(immultiply(img2,s1),immultiply(img1,s2)));



% --- Executes during object creation, after setting all properties.
function color_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to color_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function color_slider_Callback(hObject, eventdata, handles)
% hObject    handle to color_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
blend = num2str(round(100*get(hObject,'value')));
set(handles.color_text,'string',blend);

