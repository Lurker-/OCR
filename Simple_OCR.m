% OCR using MLP NN and Image Processign Filters
% I have used original codes and functions from *** https://www.mathworks.com/matlabcentral/fileexchange/32674-urdu-optical-character-recognition-system ***
% and Handwritten character Recognition: Training a Simple NN for classification using MATLAB Seminar from Mentor: prof. Primo Potonik - Student: إiga Zadnik




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
% End initialization code - 

%%
% --- Executes just before Simple_OCR is made visible.
function Simple_OCR_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Simple_OCR (see VARARGIN)

% Choose default command line output for Simple_OCR
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes Simple_OCR wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%%
% --- Outputs from this function are returned to the command line.
function varargout = Simple_OCR_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%%
% --- Executes on button press in btnloadimage.
function btnloadimage_Callback(hObject, eventdata, handles)
% hObject    handle to btnloadimage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



%%%% Image Acquisition 

clc;  
[filename, pathname] = uigetfile({'*.jpg';'*.bmp';'*.gif';'*.png';'*.*'}, 'Pick an Image File');
Output_File = imread([pathname,filename]);

axes(handles.axes1);
imshow(Output_File);

save('Output_File','Output_File');
clear all;


%%
% --- Executes on button press in btnpreprocess.
function btnpreprocess_Callback(hObject, eventdata, handles)
% hObject    handle to btnpreprocess (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



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
% hObject    handle to btnsegmentation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



%%%% Segmentation
load Output_File

%Label and Count Connected components
[L M] = bwlabeln(Output_File);
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
% hObject    handle to btnclassification (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


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
% hObject    handle to btnoutput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%%%%% Output


load glyphsclass

[r c] = size(glyphsclass);
alphabets = [];space = ' ';Alphabet = [] %%%initilize matrix

for n=1:c
    
    glyphclass = glyphsclass(1:r,n) %%% individiual alphabet
    
    [i j] = max(glyphclass); %%% alphabet


if j==5 | j==6 | j== 7 | j== 8 | j==9 | j==10 | j==11 | j==12 | j==13 | j==14 | j==15 | j==16 |...
        j==17 | j==18 | j==19 |j==20 | j==21 | j==22 | j==23 | j==24 | j==25 
    
    
    
if j==5
    alphabet = '0627'
    alephba='alef      '
end
if j==6
    alphabet = '0628'
    alephba = 'beh       ';
end

if j==7
    alphabet = '062D'
    alephba = 'Heh jimi  ';
end 

if j==8
    alphabet = '062F'
    alephba = 'daal       ';
end 

if j==9
    alphabet = '0631'
    alephba = 're        ';
end 

if j==10
    alphabet = '0633'
    alephba = 'sin       ';
end 

if j==11
    alphabet = '0635'
    alephba = 'saad      ';
end

if j==12
    alphabet = '0637';
    alephba = 'taa       ';
end

if j==13
    alphabet = '0639';
    alephba = 'ein       ';
end  

if j==14
    alphabet = '0641';
    alephba = 'fe        ';
end
if j==15
    alphabet = '0642';
    alephba = 'ghaf       ';
end
if j==16
    alphabet = '06A9';
    alephba = 'kaaf       ';
end

if j==17
    alphabet = '0644';
    alephba = 'laam       ';
end 
if j==18
    alphabet ='0645';
    alephba = 'mim       ';
end
if j==19
    alphabet = '0646';
    alephba = 'noun       ';
end

if j==20
    alphabet = '0648';
    alephba = 'vaav       ';
end
if j==21
    alphabet = '06C1';
    alephba = 'heh  ';
end
if j==22
    alphabet = '06BE';
    alephba = 'heh ';
end
if j==23
    alphabet = '0621';
    alephba = 'hamzeh    ';
end
if j==24
    alphabet = '06CC';
    alephba = 'yeh  ';
end
if j==25
    alphabet = '06D2';
    alephba = 'yeh   ';
end




alphabets = [alphabets space alphabet]
Alphabet = [Alphabet space alephba]
end


%%%If glyph is Diacritics then...
[x y] = size(alphabets);
[m n] = size(Alphabet);
 
    if j==1 & alphabet=='0628' %%%% beh
        alphabets(1,(y-3):y) ='0628'%%% each alphabet is of length 4
        Alphabet(1,(n-9):n) = 'beh       '%%% each alephba is of length 10
    end
    if j==2 & alphabet=='0628'
        alphabets(1,(y-3):y) = '062A'%%teh
        Alphabet(1,(n-9):n) = 'te        '
    end
    if j==1 & alphabet== '062A'%%teh
        alphabets(1,(y-3):y) = '062B'%%se
        Alphabet(1,(n-9):n) = 'se        '
    end
    if j==3 & alphabet =='0628'%%beh
        alphabets(1,(y-3):y) = '0679'%%te
        Alphabet(1,(n-9):n) = 'te        '
        
    end
    if j==1 & alphabet == '062D' %%%%heh jimi
        alphabets(1,(y-3):y) = '062C'%%jim
        Alphabet(1,(n-9):n) = 'jim       '
    end
    if j==2 & alphabet =='062D'
        alphabets(1,(y-3):y) = '0686'%%cheh
        Alphabet(1,(n-9):n) = 'cheh      '
    end
    if j==1 & alphabet =='062F'  %%%daal
        alphabets(1,(y-3):y) = '0630'%%zaal
        Alphabet(1,(n-9):n) = 'zaal       '
     end
    if j==3 & alphabet=='062F'
        alphabets(1,(y-3):y) = '0688'%%daal
        Alphabet(1,(n-9):n) = 'daal      '
     end
    if j == 1 & alphabet =='0631' %%%reh
        alphabets(1,(y-3):y) = '0632'%%zeh
        Alphabet(1,(n-9):n) = 'zeh      '
     end
    if j==2 & alphabet =='0631' 
        alphabets(1,(y-3):y) = '0698'%%zheh
        Alphabet(1,(n-9):n) = 'zheh       '
    end
    if j== 3 & alphabet =='0631'
        alphabets(1,(y-3):y) ='0691'%%%reh
        Alphabet(1,(n-9):n) = 'reh       '
     end
    if j==1 & alphabet == '0635'%%%saad
        alphabets(1,(y-3):y) = '0636'%%%zaad
        Alphabet(1,(n-9):n) = 'zaad      '
     end
    if j==2 & alphabet== '0633'%%%seen
        alphabets(1,(y-3):y) = '0634'%%%shin
        Alphabet(1,(n-9):n) = 'shin      '
     end
    if j==1 & alphabet== '0637'%%%taa
        alphabets(1,(y-3):y)='0638'%%%zaa
        Alphabet(1,(n-9):n) = 'Zaa       '
    
    end
     if j ==1 & alphabet== '0639'%%%aaen
        alphabets(1,(y-3):y) = '063A'%%ghein
        Alphabet(1,(n-9):n) = 'ghein     '
     end
     if j ==4 & alphabet== '06A9'%%%kaaf
        alphabets(1,(y-3):y) = '06AF'%%gaaf
        Alphabet(1,(n-9):n) = 'gaaf       '
     end
     


 
end
[m n] = size(alphabets)
set(handles.text5,'string',n/5)
set(handles.text4,'string',Alphabet)



save('alphabets','alphabets')


%%
%--- Executes on button press in btnexport.
function btnexport_Callback(hObject, eventdata, handles)
% hObject    handle to btnexport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%%%% Export Alphabets
load alphabets

fid = fopen('text.RTF','w');

fprintf(fid,alphabets);
fclose(fid)


    winopen('text.RTF')
    
function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double

%%
% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a White background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','White');
end

function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double

%%
% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a White background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','White');
end

function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double

%%
% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a White background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','White');
end

%%
% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1

%%
% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a White background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','White');
end


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
