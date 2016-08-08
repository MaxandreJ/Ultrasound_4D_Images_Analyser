function varargout = Ultrasound_4D_Images_Analyser_for_Aplio500_ToshibaMS(varargin)
% ULTRASOUND_4D_IMAGES_ANALYSER_FOR_APLIO500_TOSHIBAMS M-file for Ultrasound_4D_Images_Analyser_for_Aplio500_ToshibaMS.fig
%      ULTRASOUND_4D_IMAGES_ANALYSER_FOR_APLIO500_TOSHIBAMS, by itself, creates a new ULTRASOUND_4D_IMAGES_ANALYSER_FOR_APLIO500_TOSHIBAMS or raises the existing
%      singleton*.
%      H = ULTRASOUND_4D_IMAGES_ANALYSER_FOR_APLIO500_TOSHIBAMS returns the handle to a new ULTRASOUND_4D_IMAGES_ANALYSER_FOR_APLIO500_TOSHIBAMS or the handle to
%      the existing singleton*.
%
%      ULTRASOUND_4D_IMAGES_ANALYSER_FOR_APLIO500_TOSHIBAMS('CALLBACK',hObject,eventData,ch,...) calls the local
%      function named CALLBACK in ULTRASOUND_4D_IMAGES_ANALYSER_FOR_APLIO500_TOSHIBAMS.M with the given input arguments.
%
%      ULTRASOUND_4D_IMAGES_ANALYSER_FOR_APLIO500_TOSHIBAMS('Property','Value',...) creates a new ULTRASOUND_4D_IMAGES_ANALYSER_FOR_APLIO500_TOSHIBAMS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Ultrasound_4D_Images_Analyser_for_Aplio500_ToshibaMS_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Ultrasound_4D_Images_Analyser_for_Aplio500_ToshibaMS_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Ultrasound_4D_Images_Analyser_for_Aplio500_ToshibaMS

% Last Modified by GUIDE v2.5 08-Aug-2016 18:23:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Ultrasound_4D_Images_Analyser_for_Aplio500_ToshibaMS_OpeningFcn, ...
                   'gui_OutputFcn',  @Ultrasound_4D_Images_Analyser_for_Aplio500_ToshibaMS_OutputFcn, ...
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


% --- Executes just before Ultrasound_4D_Images_Analyser_for_Aplio500_ToshibaMS is made visible.
function Ultrasound_4D_Images_Analyser_for_Aplio500_ToshibaMS_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Ultrasound_4D_Images_Analyser_for_Aplio500_ToshibaMS (see VARARGIN)

%Ancien aplio
%DecodeDicomInfo('C:\Documents and Settings\Administrateur\Mes documents\Downloads\AplioXV\DICOM XV\DICOM XV\20160509\S0000004\US000001');
%DecodeDicomInfo('DICOM XV\20160509\S0000004\US000001');
%handles.donnees2 = GetRAWframes_B;
%Choose default command line output for Ultrasound_4D_Images_Analyser_for_Aplio500_ToshibaMS
handles.output = hObject;

code = fullfile(pwd,'Code');
chemin_code = genpath(code);
addpath(chemin_code);

handles.ss_echantillonnage_effectue = false;
handles.sauvegarde_sous_echantillonnage = true;

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = Ultrasound_4D_Images_Analyser_for_Aplio500_ToshibaMS_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in chargement.
function chargement_Callback(hObject, eventdata, handles)
% hObject    handle to chargement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
charger_volumes(hObject, eventdata, handles);

% --- Executes on button press in afficher_image.
function afficher_image_Callback(hObject, eventdata, handles)
%Affiche l'image dans handles.image 
%correspondant à la coordonnée dans l'axe 3 et l'axe 4
%choisie dans les champs correspondants.
afficher_image(hObject, eventdata, handles);

% --- Executes on button press in selectionner_region_interet.
function selectionner_region_interet_Callback(hObject, eventdata, handles)
selectionner_region_interet(hObject, eventdata, handles)

% --- Executes on button press in afficher_graphique.
function afficher_graphique_Callback(hObject, eventdata, handles)
afficher_graphique(hObject, eventdata, handles)

% --- Executes on button press in calculer_heterogeneite.
function calculer_heterogeneite_Callback(hObject, eventdata, handles)
calculer_heterogeneite(hObject, eventdata, handles)

% --- Executes on button press in detecter_pics.
function detecter_pics_Callback(hObject, eventdata, handles)
detecter_pics(hObject, eventdata, handles)

% --- Executes on button press in previsualiser_sous_echantillonnage.
function previsualiser_sous_echantillonnage_Callback(hObject, eventdata, handles)
previsualiser_sous_echantillonnage(hObject, eventdata, handles)

% --- Executes on button press in sous_echantillonner_volumes.
function sous_echantillonner_volumes_Callback(hObject, eventdata, handles)
sous_echantillonner_volumes(hObject, eventdata, handles)

% --- Executes on selection change in choix_du_pic.
function choix_du_pic_Callback(hObject, eventdata, handles)
% hObject    handle to choix_du_pic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns choix_du_pic contents as cell array
%        contents{get(hObject,'Value')} returns selected item from choix_du_pic
pic_choisi = get(handles.choix_du_pic,'Value');
set(handles.lmh_affichage,'String',handles.graphique.largeurs_a_mi_hauteur(pic_choisi));
guidata(hObject, handles);

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
combinaison_pics_choisis = handles.combinaisons_indices_de_deux_pics(numero_combinaison_de_deux_pics_choisie,:);
x_plus_grand_des_deux_pics = handles.graphique.abscisses_intensites_maximales(combinaison_pics_choisis(2));
x_plus_petit_des_deux_pics = handles.graphique.abscisses_intensites_maximales(combinaison_pics_choisis(1));
set(handles.dpap_affichage,'String',num2str(abs(x_plus_grand_des_deux_pics-x_plus_petit_des_deux_pics)));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function affichage_graphique_CreateFcn(hObject, eventdata, handles)
% hObject    handle to affichage_graphique (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% Hint: place code in OpeningFcn to populate affichage_graphique

function valeur_axe1Debut_graphique_Callback(hObject, eventdata, handles)
% hObject    handle to valeur_axe1Debut_graphique (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of valeur_axe1Debut_graphique as text
%        str2double(get(hObject,'String')) returns contents of valeur_axe1Debut_graphique as a double
set(hObject,'Value',int16(str2double(get(hObject,'String'))));
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function valeur_axe1Debut_graphique_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valeur_axe1Debut_graphique (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
%set(hObject,'String','32');
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function valeur_axe2Debut_graphique_Callback(hObject, eventdata, handles)
% hObject    handle to valeur_axe2Debut_graphique (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'Value',int16(str2double(get(hObject,'String'))));
guidata(hObject,handles);


% Hints: get(hObject,'String') returns contents of valeur_axe2Debut_graphique as text
%        str2double(get(hObject,'String')) returns contents of valeur_axe2Debut_graphique as a double


% --- Executes during object creation, after setting all properties.
function valeur_axe2Debut_graphique_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valeur_axe2Debut_graphique (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function valeur_axe1Fin_graphique_Callback(hObject, eventdata, handles)
% hObject    handle to valeur_axe1Fin_graphique (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'Value',int16(str2double(get(hObject,'String'))));
guidata(hObject,handles);

% Hints: get(hObject,'String') returns contents of valeur_axe1Fin_graphique as text
%        str2double(get(hObject,'String')) returns contents of valeur_axe1Fin_graphique as a double


% --- Executes during object creation, after setting all properties.
function valeur_axe1Fin_graphique_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valeur_axe1Fin_graphique (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
%set(hObject,'String','72');
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function valeur_axe2Fin_graphique_Callback(hObject, eventdata, handles)
% hObject    handle to valeur_axe2Fin_graphique (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'Value',int16(str2double(get(hObject,'String'))));
guidata(hObject,handles);

% Hints: get(hObject,'String') returns contents of valeur_axe2Fin_graphique as text
%        str2double(get(hObject,'String')) returns contents of valeur_axe2Fin_graphique as a double


% --- Executes during object creation, after setting all properties.
function valeur_axe2Fin_graphique_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valeur_axe2Fin_graphique (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
%set(hObject,'String','72');
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function image_CreateFcn(hObject, eventdata, handles)
% hObject    handle to image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate image



function valeur_axe3_image_Callback(hObject, eventdata, handles)
% hObject    handle to valeur_axe3_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of valeur_axe3_image as text
%        str2double(get(hObject,'String')) returns contents of valeur_axe3_image as a double
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function valeur_axe3_image_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valeur_axe3_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
    



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



function valeur_axe4_image_Callback(hObject, eventdata, handles)
% hObject    handle to valeur_axe4_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of valeur_axe4_image as text
%        str2double(get(hObject,'String')) returns contents of valeur_axe4_image as a double


% --- Executes during object creation, after setting all properties.
function valeur_axe4_image_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valeur_axe4_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function tracer_rectangle_Callback(hObject, eventdata, handles)
% hObject    handle to tracer_rectangle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tracer_rectangle(hObject, eventdata, handles)


% --------------------------------------------------------------------
function ChoixDuROI_Callback(hObject, eventdata, handles)
% hObject    handle to ChoixDuROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Aide_Callback(hObject, eventdata, handles)
% hObject    handle to Aide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msgbox({'Le passage entre les types de coupes est permise par les touches du clavier suivantes :', ...
'0 : coupe frontale (Y en fonction de X) ;', ...
'1 : coupe transversale (Z en fonction de X) ;', ...
'2 : coupe sagittale (Z en fonction de Y);', ...
'3 : coupe de X en fonction du temps ;', ...
'4 : coupe de Y en fonction du temps ;', ...
'5 : coupe de Z en fonction du temps.', ...
'',...
'Pour une même coupe, on peut glisser entre les plans par les flèches multidirectionnelles du clavier :',...
'flèches gauche et droite pour glisser selon le premier axe mentionné dans le titre de l''image ;',...
'flèches bas et haut pour glisser selon le deuxième axe mentionné dans le titre de l''image.'})


% --------------------------------------------------------------------
function uitoggletool6_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = rotate3d(handles.image);



function affichage_entropie_Callback(hObject, eventdata, handles)
% hObject    handle to affichage_entropie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of affichage_entropie as text
%        str2double(get(hObject,'String')) returns contents of affichage_entropie as a double


% --- Executes during object creation, after setting all properties.
function affichage_entropie_CreateFcn(hObject, eventdata, handles)
% hObject    handle to affichage_entropie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function uipushtool3_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4


% --- Executes during object creation, after setting all properties.
function ContexteImage_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function valeur_taille_fenetre_lissage_Callback(hObject, eventdata, handles)
% hObject    handle to valeur_taille_fenetre_lissage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of valeur_taille_fenetre_lissage as text
%        str2double(get(hObject,'String')) returns contents of valeur_taille_fenetre_lissage as a double



% --- Executes during object creation, after setting all properties.
function valeur_taille_fenetre_lissage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valeur_taille_fenetre_lissage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in abscisses_axe1.
function abscisses_axe1_Callback(hObject, eventdata, handles)
% hObject    handle to abscisses_axe1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
moyenne_axe1_ou_axe1et2_choisie = logical(get(handles.moyenne_axe1,'value')) || ...
   logical(get(handles.moyenne_axe1et2,'value'));
if moyenne_axe1_ou_axe1et2_choisie
    set(handles.moyenne_axe2,'value',1);
end
guidata(handles.figure1,handles);

% Hint: get(hObject,'Value') returns toggle state of abscisses_axe1


% --- Executes on button press in abscisses_axe2.
function abscisses_axe2_Callback(hObject, eventdata, handles)
% hObject    handle to abscisses_axe2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
moyenne_axe2_ou_axe1et2_choisie = logical(get(handles.moyenne_axe2,'value')) || ...
   logical(get(handles.moyenne_axe1et2,'value'));
if moyenne_axe2_ou_axe1et2_choisie
    set(handles.moyenne_axe1,'value',1);
end
guidata(handles.figure1,handles);

% Hint: get(hObject,'Value') returns toggle state of abscisses_axe2


% --- Executes on button press in moyenne_axe1.
function moyenne_axe1_Callback(hObject, eventdata, handles)
% hObject    handle to moyenne_axe1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
graphique_selon_axe1ou3ou4_choisi = get(handles.abscisses_axe1,'value') || ...
    get(handles.abscisses_axe3,'value') || get(handles.abscisses_axe4,'value') ;
if graphique_selon_axe1ou3ou4_choisi
    set(handles.abscisses_axe2,'value',1);
end
guidata(handles.figure1,handles);

% Hint: get(hObject,'Value') returns toggle state of moyenne_axe1


% --- Executes on button press in moyenne_axe2.
function moyenne_axe2_Callback(hObject, eventdata, handles)
% hObject    handle to moyenne_axe2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
graphique_selon_axe2ou3ou4_choisi = get(handles.abscisses_axe2,'value') || ...
    get(handles.abscisses_axe3,'value') || get(handles.abscisses_axe4,'value') ;
if graphique_selon_axe2ou3ou4_choisi
    set(handles.abscisses_axe1,'value',1);
end
guidata(handles.figure1,handles);

% Hint: get(hObject,'Value') returns toggle state of moyenne_axe2




% --------------------------------------------------------------------
function sauvegarde_graphique_Callback(hObject, eventdata, handles)
% hObject    handle to sauvegarde_graphique (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[nom_du_fichier,chemin] = uiputfile({'*.png';'*.jpeg';'*.bmp';'*.tiff';'*.pdf';'*.eps'});
dossier_principal=pwd;
cd(chemin);
export_fig(handles.affichage_graphique, nom_du_fichier);
cd(dossier_principal)

% --------------------------------------------------------------------
function ContexteGraphique_Callback(hObject, eventdata, handles)
% hObject    handle to ContexteGraphique (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function tracer_polygone_Callback(hObject, eventdata, handles)
% hObject    handle to tracer_polygone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tracer_polygone(hObject, eventdata, handles)




% --- Executes on button press in moyenne_axe1et2.
function moyenne_axe1et2_Callback(hObject, eventdata, handles)
% hObject    handle to moyenne_axe1et2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
graphique_selon_axe1ou2_choisi = logical(get(handles.abscisses_axe1,'value')) || logical(get(handles.abscisses_axe2,'value'));
if graphique_selon_axe1ou2_choisi
    set(handles.abscisses_axe4,'value',1);
end

% Hint: get(hObject,'Value') returns toggle state of moyenne_axe1et2


% --- Executes on button press in abscisses_axe3.
function abscisses_axe3_Callback(hObject, eventdata, handles)
% hObject    handle to abscisses_axe3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
moyenne_axe1ou2oupas_choisie = logical(get(handles.moyenne_axe1,'value')) || logical(get(handles.moyenne_axe2,'value')) || ...
    logical(get(handles.pas_de_moyenne,'value'));
if moyenne_axe1ou2oupas_choisie
    set(handles.moyenne_axe1et2,'value',1);
end

% Hint: get(hObject,'Value') returns toggle state of abscisses_axe3


% --- Executes on button press in abscisses_axe4.
function abscisses_axe4_Callback(hObject, eventdata, handles)
% hObject    handle to abscisses_axe4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
moyenne_axe1ou2oupas_choisie = logical(get(handles.moyenne_axe1,'value')) || logical(get(handles.moyenne_axe2,'value')) || ...
    logical(get(handles.pas_de_moyenne,'value'));
if moyenne_axe1ou2oupas_choisie
    set(handles.moyenne_axe1et2,'value',1);
end

% Hint: get(hObject,'Value') returns toggle state of abscisses_axe4


% --- Executes on button press in pas_de_moyenne.
function pas_de_moyenne_Callback(hObject, eventdata, handles)
% hObject    handle to pas_de_moyenne (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

graphique_selon_axe3ou4_choisi = logical(get(handles.abscisses_axe3,'value')) || ...
    logical(get(handles.abscisses_axe4,'value'));
if graphique_selon_axe3ou4_choisi
    set(handles.abscisses_axe1,'value',1);
end
guidata(handles.figure1,handles);

% Hint: get(hObject,'Value') returns toggle state of pas_de_moyenne



function valeur_nombre_de_pics_Callback(hObject, eventdata, handles)
% hObject    handle to valeur_nombre_de_pics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of valeur_nombre_de_pics as text
%        str2double(get(hObject,'String')) returns contents of valeur_nombre_de_pics as a double


% --- Executes during object creation, after setting all properties.
function valeur_nombre_de_pics_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valeur_nombre_de_pics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




    
    



function facteur_temps_I_max_Callback(hObject, eventdata, handles)
% hObject    handle to facteur_temps_I_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of facteur_temps_I_max as text
%        str2double(get(hObject,'String')) returns contents of facteur_temps_I_max as a double


% --- Executes during object creation, after setting all properties.
function facteur_temps_I_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to facteur_temps_I_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function facteur_sous_echantillonnage_Callback(hObject, eventdata, handles)
% hObject    handle to facteur_sous_echantillonnage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of facteur_sous_echantillonnage as text
%        str2double(get(hObject,'String')) returns contents of facteur_sous_echantillonnage as a double


% --- Executes during object creation, after setting all properties.
function facteur_sous_echantillonnage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to facteur_sous_echantillonnage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in choix_chargement.
function choix_chargement_Callback(hObject, eventdata, handles)
% hObject    handle to choix_chargement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns choix_chargement contents as cell array
%        contents{get(hObject,'Value')} returns selected item from choix_chargement


% --- Executes during object creation, after setting all properties.
function choix_chargement_CreateFcn(hObject, eventdata, handles)
% hObject    handle to choix_chargement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function sauvegarde_image_Callback(hObject, eventdata, handles)
% hObject    handle to sauvegarde_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[nom_du_fichier,chemin] = uiputfile({'*.png';'*.jpeg';'*.bmp';'*.tiff';'*.pdf';'*.eps'});
dossier_principal=pwd;
cd(chemin);
export_fig(handles.image, nom_du_fichier);
cd(dossier_principal)


% --- Executes on button press in points_de_donnees.
function points_de_donnees_Callback(hObject, eventdata, handles)
% hObject    handle to points_de_donnees (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of points_de_donnees




% --------------------------------------------------------------------
function capture_fenetre_Callback(hObject, eventdata, handles)
% hObject    handle to capture_fenetre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[nom_du_fichier,chemin] = uiputfile({'*.png';'*.jpeg';'*.bmp';'*.tiff';'*.pdf';'*.eps'});
dossier_principal=pwd;
cd(chemin);
export_fig(handles.figure1, nom_du_fichier);
cd(dossier_principal)
