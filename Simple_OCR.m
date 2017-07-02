function varargout = Simple_OCR(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Simple_OCR_OpeningFcn, ...
                   'gui_OutputFcn',  @Simple_OCR_OutputFcn, ...
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


function Simple_OCR_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


function varargout = Simple_OCR_OutputFcn(hObject, eventdata, handles) 


% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in btnloadimage.
function btnloadimage_Callback(hObject, eventdata, handles)


%%%% Image Acquisition 

clc;  
[filename, pathname] = uigetfile({'*.jpg';'*.bmp';'*.gif';'*.png';'*.*'}, 'Pick an Image File');
Output_File = imread([pathname,filename]);

axes(handles.axes1);
imshow(Output_File);

save('Output_File','Output_File');
clear all;


% --- Executes on button press in btnpreprocess.
function btnpreprocess_Callback(hObject, eventdata, handles)



%%%% Preprocessing
load Output_File

%Convert to gray scale
if size(Output_File,3)==3 %RGB image
    Output_File = rgb2gray(Output_File);
end
%Convert to binary image
threshold = graythresh(Output_File);
Output_File =~im2bw(Output_File,threshold);

Output_File = medfilt2(Output_File);

axes(handles.axes2);
imshow(Output_File)

save('Output_File','Output_File');
clc; clear all;

%%
% --- Executes on button press in btnsegmentation.
function btnsegmentation_Callback(hObject, eventdata, handles)




%%%% Segmentation
load Output_File

%Label and Count Connected components
[L M] = bwlabel(Output_File);
glyphs = []  %%%Initilize glyphs matrix

   for n=1:M
    [r c] =find(L==n);
    
    glyph = Output_File(min(r):max(r),min(c):max(c));
   
    glyph = imresize(glyph,[35 35]); 
   
    % Again convert to binaray image
    glyph = double(glyph);
    thresh = graythresh(glyph);
    glyph = im2bw(glyph,thresh); 
    
    glyphs = [glyphs glyph]
  
    
    axes(handles.axes3);
    imshow(glyph)
    
   end
   [m n] = size(glyphs)
   set(handles.text6,'string',n/35)
   save('glyphs','glyphs');
   clear all;
%%
% --- Executes on button press in btnclassification.
function btnclassification_Callback(hObject, eventdata, handles)



%%%% Classification

load glyphs;
load net;
[r c] = size(glyphs);

    glyphsclass = [];performance = [];%%initilize matrix
    for n = 0:35:(c-35)
        glyph = glyphs(1:35,1+n:(n+35));
        glyph = mat2vect(glyph);
        [glyphclass,PF,AF,E,Perf] = sim(net,glyph);
        
        performance = [performance Perf]

       plot(performance,'-.b*','LineWidth',2,'MarkerSize',10)
        glyphsclass = [glyphsclass glyphclass]
        
    end

save('glyphsclass','glyphsclass');
clear all;

%
% --- Executes on button press in btnoutput.
function btnoutput_Callback(hObject, eventdata, handles)



%%%%% Output

load glyphsclass

[r c] = size(glyphsclass);
alphabets = [];space = ' ';Alphabet = [] %%%initilize matrix

for n=1:c
    
    glyphclass = glyphsclass(1:r,n) %%% individiual alphabet
    
    [i j] = max(glyphclass); %%% alphabet


if j==1 | j==2
    


if j==1
    alphabet = '0644';
    alephba = 'laam       ';
end 
if j==2
    alphabet ='0645';
    alephba = 'mim       ';
end

alphabets = [alphabets space alphabet]
Alphabet = [Alphabet space alephba]
end

end
[m n] = size(alphabets)
set(handles.text5,'string',n/5)
set(handles.text4,'string',Alphabet)



save('alphabets','alphabets')


%%
%--- Executes on button press in btnexport.
function btnexport_Callback(hObject, eventdata, handles)


%%%% Export Alphabets
load alphabets

fid = fopen('text.RTF','w');

fprintf(fid,alphabets);
fclose(fid)


    winopen('text.RTF')
    
function edit3_Callback(hObject, eventdata, handles)

%%
% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)


% Hint: edit controls usually have a White background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','White');
end

function edit4_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a White background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','White');
end

function edit5_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)



if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','White');
end

% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)


% Hint: listbox controls usually have a White background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','White');
end


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
