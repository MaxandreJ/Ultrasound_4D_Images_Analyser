function varargout = Bayes4D(varargin)
% BAYES4D M-file for Bayes4D.fig
%      BAYES4D, by itself, creates a new BAYES4D or raises the existing
%      singleton*.
%      H = BAYES4D returns the handle to a new BAYES4D or the handle to
%      the existing singleton*.
%
%      BAYES4D('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BAYES4D.M with the given input arguments.
%
%      BAYES4D('Property','Value',...) creates a new BAYES4D or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Bayes4D_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Bayes4D_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Bayes4D

% Last Modified by GUIDE v2.5 09-Jul-2016 20:07:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Bayes4D_OpeningFcn, ...
                   'gui_OutputFcn',  @Bayes4D_OutputFcn, ...
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


% --- Executes just before Bayes4D is made visible.
function Bayes4D_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Bayes4D (see VARARGIN)

%Ancien aplio
%DecodeDicomInfo('C:\Documents and Settings\Administrateur\Mes documents\Downloads\AplioXV\DICOM XV\DICOM XV\20160509\S0000004\US000001');
%DecodeDicomInfo('DICOM XV\20160509\S0000004\US000001');

%Adaptation automatique de l'interface à la résolution de l'écran

%handles.donnees2 = GetRAWframes_B;
%Choose default command line output for Bayes4D
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Bayes4D wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Bayes4D_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in afficherGraphique.
function afficherGraphique_Callback(hObject, eventdata, handles)
% hObject    handle to afficherGraphique (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


cla(handles.graphique); %Efface le graphique précédent

%On accède aux valeurs de coordonnées par des accesseurs
XDebut = get(handles.XDebut,'Value');
YDebut = get(handles.YDebut,'Value');
XFin = get(handles.XFin,'Value');
YFin = get(handles.YFin,'Value');

sommeX = get(handles.sommeX,'Value');
sommeY = get(handles.sommeY,'Value');

coupeSelonX = get(handles.coupeSelonX,'Value');
coupeSelonY = get(handles.coupeSelonY,'Value');

handles.graph = handles.image3(YDebut:YFin,XDebut:XFin);

if (sommeX==1 && sommeY==0)
    handles.graph = sum(handles.graph,2);
elseif (sommeX==0 && sommeY==1)
    handles.graph = sum(handles.graph,1);
end
handles.graph = squeeze(handles.graph);

axes(handles.graphique);
if (coupeSelonX==1 && coupeSelonY==0)
    plot(XDebut:XFin,handles.graph','displayname','Courbe originale');
elseif (coupeSelonY==1 && coupeSelonX==0)
    plot(YDebut:YFin,handles.graph,'displayname','Courbe originale');
end

xlabel('Y (en pixels)')%A adapter selon Y, X...
ylabel('Intensité (en niveaux)')

axes(handles.image);
%afficherImage_Callback(hObject, eventdata, guidata(hObject));

if xor(XDebut~=XFin,YDebut~=YFin)
    line([XDebut,XFin],[YDebut,YFin],'Color',[1 0 0]);
elseif (XDebut~=XFin && YDebut~=YFin)
    largeur = XFin-XDebut;
    hauteur = YFin-YDebut;
    rectangle('Position',[XDebut YDebut largeur hauteur],'EdgeColor','r');
end

blanc = [1 1 1];

set(handles.choix_du_pic,'enable','on','BackgroundColor',blanc);
set(handles.choix_de_deux_pics,'enable','on','BackgroundColor',blanc);
set(handles.lmh_affichage,'BackgroundColor',blanc);
set(handles.dpap_affichage,'BackgroundColor',blanc);

guidata(hObject, handles);





% --- Executes during object creation, after setting all properties.
function graphique_CreateFcn(hObject, eventdata, handles)
% hObject    handle to graphique (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% Hint: place code in OpeningFcn to populate graphique



function XDebut_Callback(hObject, eventdata, handles)
% hObject    handle to XDebut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'Value',int16(str2double(get(hObject,'String'))));
guidata(hObject,handles);
    

% Hints: get(hObject,'String') returns contents of XDebut as text
%        str2double(get(hObject,'String')) returns contents of XDebut as a double


% --- Executes during object creation, after setting all properties.
function XDebut_CreateFcn(hObject, eventdata, handles)
% hObject    handle to XDebut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
%set(hObject,'String','32');
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function YDebut_Callback(hObject, eventdata, handles)
% hObject    handle to YDebut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'Value',int16(str2double(get(hObject,'String'))));
guidata(hObject,handles);


% Hints: get(hObject,'String') returns contents of YDebut as text
%        str2double(get(hObject,'String')) returns contents of YDebut as a double


% --- Executes during object creation, after setting all properties.
function YDebut_CreateFcn(hObject, eventdata, handles)
% hObject    handle to YDebut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
%set(hObject,'String','32');
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ZDebut_Callback(hObject, eventdata, handles)
% hObject    handle to ZDebut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'Value',int16(str2double(get(hObject,'String'))));
guidata(hObject,handles);

% Hints: get(hObject,'String') returns contents of ZDebut as text
%        str2double(get(hObject,'String')) returns contents of ZDebut as a double


% --- Executes during object creation, after setting all properties.
function ZDebut_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ZDebut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function XFin_Callback(hObject, eventdata, handles)
% hObject    handle to XFin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'Value',int16(str2double(get(hObject,'String'))));
guidata(hObject,handles);

% Hints: get(hObject,'String') returns contents of XFin as text
%        str2double(get(hObject,'String')) returns contents of XFin as a double


% --- Executes during object creation, after setting all properties.
function XFin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to XFin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
%set(hObject,'String','72');
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function YFin_Callback(hObject, eventdata, handles)
% hObject    handle to YFin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'Value',int16(str2double(get(hObject,'String'))));
guidata(hObject,handles);

% Hints: get(hObject,'String') returns contents of YFin as text
%        str2double(get(hObject,'String')) returns contents of YFin as a double


% --- Executes during object creation, after setting all properties.
function YFin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to YFin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
%set(hObject,'String','72');
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ZFin_Callback(hObject, eventdata, handles)
% hObject    handle to ZFin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'Value',int16(str2double(get(hObject,'String'))));
guidata(hObject,handles);

% Hints: get(hObject,'String') returns contents of ZFin as text
%        str2double(get(hObject,'String')) returns contents of ZFin as a double


% --- Executes during object creation, after setting all properties.
function ZFin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ZFin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function image_CreateFcn(hObject, eventdata, handles)
% hObject    handle to image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate image


% --- Executes on button press in afficherImage.
function afficherImage_Callback(hObject, eventdata, handles)
% hObject    handle to afficherImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%donnees3 = GetRAWframe_B(handles.imageC);

%image3 = ConvertRAWframe_B(donnees3,0);
%handles.image3 = uint8(image3);

axes(handles.image);
imshow4(handles.volumes,hObject,handles);
%handles = imshow4(handles.volumes,hObject,handles);
%[x y z t] = size(handles.volumes);
%imshow(handles.image3);
set(handles.figure1,'KeyPressFcn',handles.figure1.KeyPressFcn);


uicontextmenu = get(handles.image,'UIContextMenu');
set(handles.image.Children,'UIContextMenu',uicontextmenu);

%set(handles.image,'UIContextMenu',uicontextmenu);

blanc = [1 1 1];

set(handles.XDebut,'enable','on','BackgroundColor',blanc);
set(handles.YDebut,'enable','on','BackgroundColor',blanc);
set(handles.XFin,'enable','on','BackgroundColor',blanc);
set(handles.YFin,'enable','on','BackgroundColor',blanc);
set(handles.coupeSelonX,'enable','on','BackgroundColor',blanc);
set(handles.coupeSelonY,'enable','on','BackgroundColor',blanc);
set(handles.sommeX,'enable','on','BackgroundColor',blanc);
set(handles.sommeY,'enable','on','BackgroundColor',blanc);

guidata(handles.figure1,handles);




function imageChoisie_Callback(hObject, eventdata, handles)
% hObject    handle to imageChoisie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.imageC = int16(str2double(get(hObject,'String')));
guidata(hObject,handles);

% Hints: get(hObject,'String') returns contents of imageChoisie as text
%        str2double(get(hObject,'String')) returns contents of imageChoisie as a double


% --- Executes during object creation, after setting all properties.
function imageChoisie_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imageChoisie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in sommeX.
function sommeX_Callback(hObject, eventdata, handles)
% hObject    handle to sommeX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%handles.sommeX = get(hObject,'Value');
guidata(hObject,handles);

% Hint: get(hObject,'Value') returns toggle state of sommeX


% --- Executes on button press in sommeY.
function sommeY_Callback(hObject, eventdata, handles)
% hObject    handle to sommeY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%handles.sommeY = get(hObject,'Value');
guidata(hObject,handles);

% Hint: get(hObject,'Value') returns toggle state of sommeY


% --- Executes on button press in heterogeneite.
function heterogeneite_Callback(hObject, eventdata, handles)
% hObject    handle to heterogeneite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%On accède aux choix de coupes par des accesseurs
coupeSelonX = get(handles.coupeSelonX,'Value');
coupeSelonY = get(handles.coupeSelonY,'Value');


if (coupeSelonX==0 && coupeSelonY==1)
    heterogeneite = handles.graph;
elseif (coupeSelonX==1 && coupeSelonY==0)
    heterogeneite = transpose(handles.graph);
end

%Enlever les lignes qui ne contiennent que des 0 (signaux nuls pour chacune
%des tranches
heterogeneite(all(heterogeneite==0,2),:)=[];

seuil_de_risque = 0.05;

[nLig nCol]=size(heterogeneite);
[es,esCi,khi2,p]=cramerV(heterogeneite,nLig,nCol,0.95);
r=min(nLig,nCol);
w=es*sqrt(r-1);
wCi=esCi*sqrt(r-1);

set(handles.khi2,'String',khi2);
set(handles.p,'String',p);
set(handles.w,'String',w);
set(handles.wb,'String',wCi(1));
set(handles.wh,'String',wCi(2));

if p<=seuil_de_risque
    if w<0.1
        resultatHetero=['Le résultat est significatif au seuil de risque ',num2str(seuil_de_risque),' i.e. les coupes '...
       'utilisées permettent d''induire que la tumeur est hétérogène. L''hétérogénéité est cependant quasi nulle (w<0,1).'];
        set(handles.resultatCouleur,'BackgroundColor','red');
    elseif w<0.3
        resultatHetero=['Le résultat est significatif au seuil de risque ',num2str(seuil_de_risque),' i.e. les coupes '...
       'utilisées permettent d''induire que la tumeur est hétérogène. L''hétérogénéité est faible (0,1<=w<0,3).'];
        set(handles.resultatCouleur,'BackgroundColor','yellow');
   elseif w<0.5
        resultatHetero=['Le résultat est significatif au seuil de risque ',num2str(seuil_de_risque),' i.e. les coupes '...
       'utilisées permettent d''induire que la tumeur est hétérogène. L''hétérogénéité est moyenne (0,3<=w<0,5).'];
        set(handles.resultatCouleur,'BackgroundColor','blue');
    elseif w>=0.5
        resultatHetero=['Le résultat est significatif au seuil de risque ',num2str(seuil_de_risque),' i.e. les coupes '...
       'utilisées permettent d''induire que la tumeur est hétérogène. L''hétérogénéité est forte (0,5<=w).'];
        set(handles.resultatCouleur,'BackgroundColor','green');
    end
else
   resultatHetero = ['Le résultat n''est pas significatif au seuil de risque ',num2str(seuil_de_risque),' i.e. les coupes '...
       'utilisées ne permettent pas d''induire que la tumeur est hétérogène.'];
   set(handles.resultatCouleur,'BackgroundColor','black');
end

set(handles.resultatHetero,'String',resultatHetero);

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function khi2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to khi2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in coupeSelonX.
function coupeSelonX_Callback(hObject, eventdata, handles)
% hObject    handle to coupeSelonX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%handles.coupeSelonX = get(hObject,'Value');
guidata(hObject,handles);

% Hint: get(hObject,'Value') returns toggle state of coupeSelonX


% --- Executes on button press in coupeSelonY.
function coupeSelonY_Callback(hObject, eventdata, handles)
% hObject    handle to coupeSelonY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%handles.coupeSelonY = get(hObject,'Value');
guidata(hObject,handles);

% Hint: get(hObject,'Value') returns toggle state of coupeSelonY


% --- Executes on button press in detection_pics.
function detection_pics_Callback(hObject, eventdata, handles)
% hObject    handle to detection_pics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%On accède aux choix de coupes
coupeSelonX = get(handles.coupeSelonX,'Value');
coupeSelonY = get(handles.coupeSelonY,'Value');

%On accède aux valeurs des coordonnées
XDebut = get(handles.XDebut,'Value');
YDebut = get(handles.YDebut,'Value');
XFin = get(handles.XFin,'Value');
YFin = get(handles.YFin,'Value');

%Affichage des pics
graph_pic = double(handles.graph);
%graph_pic_lisse = mslowess([1:length(graph_pic)]',graph_pic,'Span',10);
windowSize = 5;
filtre_lissage = (1/windowSize)*ones(1,windowSize);
coefficient_filtre = 1;
graph_pic_lisse = filter(filtre_lissage,coefficient_filtre,graph_pic);


axes(handles.graphique);
hold on
if (coupeSelonX==1 && coupeSelonY==0)
    %plot(handles.XDebut:handles.XFin,graph_pic_lisse,'g','displayname','Courbe débruitée');
    [y_maxs,x_maxs,lmhs,proms] = findpeaks(graph_pic_lisse,double(XDebut):double(XFin));
    findpeaks(graph_pic_lisse,double(XDebut):double(XFin),'Annotate','extents');
    %[Peaklist, PFWHH, PExt] = mspeaks(double(handles.XDebut:handles.XFin),graph_pic,'Style','fwhhline','ShowPlot', false);
elseif (coupeSelonX==0 && coupeSelonY==1)
    %plot(handles.YDebut:handles.YFin,graph_pic_lisse,'g','displayname','Courbe débruitée');
    [y_maxs,x_maxs,lmhs,proms] = findpeaks(graph_pic_lisse,double(YDebut):double(YFin));
    findpeaks(graph_pic_lisse,double(YDebut):double(YFin),'Annotate','extents');
    %[Peaklist, PFWHH, PExt] = mspeaks(double(handles.YDebut:handles.YFin),graph_pic_lisse','Style','fwhhline','HeightFilter',0.7*max(graph_pic_lisse'),'ShowPlot', false);
end
legend(gca,'off');

axes(handles.graphique);
%legend('show','Location','northwest');
%findpeaks(graph_pic_lisse,'Annotate','extents');
%plot(handles.XDebut+locs(1),pks(1),'xr','linewidth',2,'displayname','Maximums');
axes(handles.graphique);
%plot(PFWHH{1},[Peaklist(2)/2 Peaklist(2)/2] ,'r','linewidth',2,'displayname','DETECTION_PICS');
hold off

%set(handles.dpap_affichage,'String',x_maxs(2)-x_maxs(1));
%{
handles.y_maxs = y_maxs;
handles.x_maxs = x_maxs;
handles.lmhs = lmhs;
handles.proms = proms;
handles=guidata(hObject);
%}

handles.x_maxs = x_maxs;

%Affichage de la liste de pics dans la première liste déroulante
[nombre_de_pics ~] = size(y_maxs);
crochet_ouvrant = repmat('[', nombre_de_pics , 1);
virgule = repmat(', ',nombre_de_pics,1);
crochet_fermant = repmat(']',nombre_de_pics,1);
liste_de_pics = [crochet_ouvrant num2str(x_maxs') virgule ...
    num2str(y_maxs) crochet_fermant];
set(handles.choix_du_pic,'String',liste_de_pics);
pic_choisi = get(handles.choix_du_pic,'Value');
set(handles.lmh_affichage,'String',lmhs(pic_choisi));
handles.lmhs=lmhs;

%Affichage des combinaisons de deux pics dans la deuxième liste déroulante
combinaisons_de_deux_pics = combnk(1:nombre_de_pics,2);
set(handles.choix_de_deux_pics,'String',num2str(combinaisons_de_deux_pics));
handles.combinaisons_de_deux_pics = combinaisons_de_deux_pics;
numero_combinaison_de_deux_pics_choisie = get(handles.choix_de_deux_pics,'Value');
combinaison_pics_choisis = combinaisons_de_deux_pics(numero_combinaison_de_deux_pics_choisie,:);
x_plus_grand_des_deux_pics = x_maxs(combinaison_pics_choisis(2));
x_plus_petit_des_deux_pics = x_maxs(combinaison_pics_choisis(1));
set(handles.dpap_affichage,'String',num2str(x_plus_grand_des_deux_pics-x_plus_petit_des_deux_pics));

guidata(hObject, handles);

%disp('Peaklist');
%disp(Peaklist);
%disp('PFWHH');
%celldisp(PFWHH);
%disp('PExt');
%disp(PExt);



function lmh_affichage_Callback(hObject, eventdata, handles)
% hObject    handle to lmh_affichage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Hints: get(hObject,'String') returns contents of lmh_affichage as text
%        str2double(get(hObject,'String')) returns contents of lmh_affichage as a double


% --- Executes during object creation, after setting all properties.
function lmh_affichage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lmh_affichage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function chemin_dossier_Callback(hObject, eventdata, handles)
% hObject    handle to chemin_dossier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of chemin_dossier as text
%        str2double(get(hObject,'String')) returns contents of chemin_dossier as a double


% --- Executes during object creation, after setting all properties.
function chemin_dossier_CreateFcn(hObject, eventdata, handles)
% hObject    handle to chemin_dossier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in chargement.
function chargement_Callback(hObject, eventdata, handles)
% hObject    handle to chargement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
chemin_dossier = uigetdir('C:\Users\m_jacqueline\Downloads\4D_Aplio500_Analyser\Raw','Dossier contenant les volumes en .bin');
set(handles.chemin_dossier,'String',chemin_dossier);

d = dir(chemin_dossier);
disp(d(3).name);
if ispc
    patient_info_id = fopen([chemin_dossier,'\',d(3).name]);
elseif ismac
    patient_info_id = fopen([chemin_dossier,'/',d(3).name]);
else
    disp('Tu utilises Linux, il va falloir des petites modifications dans ma fonction chargement pour que ça marche');
end
patient_info = textscan(patient_info_id,'%s',11);
patient_info = patient_info{1,1};
range = str2num(patient_info{5});
azimuth = str2num(patient_info{8});
elevation = str2num(patient_info{11});
assignin('base', 'patient_info', patient_info);
disp(patient_info);
nb_fichiers = size(d);
nb_fichiers = nb_fichiers(1);
%Les fichiers saufs patientInfo.txt
identifiants_fichiers = cell((nb_fichiers-3),1);
fichiers = cell((nb_fichiers-3),1);

%Pour éviter les fichiers . .. et PatientInfo.txt on commence au fichier
%numéro 4
for ifichier = 1:nb_fichiers-3
    %disp(['1706 exports matlab Virginie\Données exportées\1648550067\RawData_Vol', num2str(i), '.bin']);
    disp([chemin_dossier,d(ifichier+3).name]);
    %identifiants_fichiers{i}=fopen(['1706 exports matlab Virginie\Données exportées\1648550067\RawData_Vol', num2str(i),'.bin']);
    if ispc
        identifiants_fichiers{ifichier}=fopen([chemin_dossier,'\',d(ifichier+3).name]);
    elseif ismac
        identifiants_fichiers{ifichier}=fopen([chemin_dossier,'/',d(ifichier+3).name]);
    end
    fichiers{ifichier}=fread(identifiants_fichiers{ifichier});
    fichiers{ifichier} =reshape(fichiers{ifichier},range,azimuth,elevation);
end
assignin('base', 'fichiers', fichiers);
volumes = cat(4,fichiers{:});
handles.volumes = volumes;

handles.nb_fichiers = nb_fichiers-3;

guidata(hObject, handles);

% --- Executes on selection change in choix_du_pic.
function choix_du_pic_Callback(hObject, eventdata, handles)
% hObject    handle to choix_du_pic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pic_choisi = get(handles.choix_du_pic,'Value');
set(handles.lmh_affichage,'String',handles.lmhs(pic_choisi));
guidata(hObject, handles);

% Hints: contents = cellstr(get(hObject,'String')) returns choix_du_pic contents as cell array
%        contents{get(hObject,'Value')} returns selected item from choix_du_pic


% --- Executes during object creation, after setting all properties.
function choix_du_pic_CreateFcn(hObject, eventdata, handles)
% hObject    handle to choix_du_pic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in choix_de_deux_pics.
function choix_de_deux_pics_Callback(hObject, eventdata, handles)
% hObject    handle to choix_de_deux_pics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns choix_de_deux_pics contents as cell array
%        contents{get(hObject,'Value')} returns selected item from choix_de_deux_pics

numero_combinaison_de_deux_pics_choisie = get(handles.choix_de_deux_pics,'Value');
combinaison_pics_choisis = handles.combinaisons_de_deux_pics(numero_combinaison_de_deux_pics_choisie,:);
x_plus_grand_des_deux_pics = handles.x_maxs(combinaison_pics_choisis(2));
x_plus_petit_des_deux_pics = handles.x_maxs(combinaison_pics_choisis(1));
set(handles.dpap_affichage,'String',num2str(x_plus_grand_des_deux_pics-x_plus_petit_des_deux_pics));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function choix_de_deux_pics_CreateFcn(hObject, eventdata, handles)
% hObject    handle to choix_de_deux_pics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dpap_affichage_Callback(hObject, eventdata, handles)
% hObject    handle to dpap_affichage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dpap_affichage as text
%        str2double(get(hObject,'String')) returns contents of dpap_affichage as a double


% --- Executes during object creation, after setting all properties.
function dpap_affichage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dpap_affichage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit19_Callback(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit19 as text
%        str2double(get(hObject,'String')) returns contents of edit19 as a double


% --- Executes during object creation, after setting all properties.
function edit19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function Ligne_Callback(hObject, eventdata, handles)
% hObject    handle to Ligne (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imline;


% --------------------------------------------------------------------
function Rectangle_Callback(hObject, eventdata, handles)
% hObject    handle to Rectangle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imrect;



% --------------------------------------------------------------------
function SelectionROI_Callback(hObject, eventdata, handles)
% hObject    handle to SelectionROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
