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

% Last Modified by GUIDE v2.5 05-Aug-2016 12:18:51

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

developpement_altmany = fullfile(pwd,'altmany-export_fig');
chemin_altmany = genpath(developpement_altmany);
addpath(chemin_altmany);

handles.sauvegarde_sous_echantillonnage = true;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Ultrasound_4D_Images_Analyser_for_Aplio500_ToshibaMS wait for user response (see UIRESUME)
% uiwait(handles.figure1);


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



choix_chargement = get(handles.choix_chargement,'Value');
cla(handles.graphique);
set(handles.choix_du_pic,'String',' ');
set(handles.lmh_affichage,'String',[]);
set(handles.lmh_affichage,'String',[]);
set(handles.choix_de_deux_pics,'String',' ');
set(handles.dpap_affichage,'String',[]);
set(handles.valeur_axe1Debut_graphique,'String',[]);
set(handles.valeur_axe2Debut_graphique,'String',[]);
set(handles.valeur_axe1Fin_graphique,'String',[]);
set(handles.valeur_axe2Fin_graphique,'String',[]);

format_bin = 1;
format_mat = 2;

if choix_chargement==format_bin
    chemin = uigetdir('C:\Users\m_jacqueline\Downloads\4D_Aplio500_Analyser\Raw','Dossier contenant les volumes en .bin');
elseif choix_chargement==format_mat
    [nom_du_fichier, chemin] = uigetfile({'*.mat'},'Choix des volumes 4D en format .mat');
end
set(handles.chemin_dossier,'String',chemin);

if choix_chargement==format_bin
    d = dir(chemin);
    if ispc
        patient_info_id = fopen([chemin,'\',d(3).name]);
    elseif ismac
        patient_info_id = fopen([chemin,'/',d(3).name]);
    else
        disp('Tu utilises Linux, il va falloir des petites modifications dans ma fonction chargement pour que ça marche');
    end
    patient_info = textscan(patient_info_id,'%s',11);
    patient_info = patient_info{1,1};
    range = str2num(patient_info{5});
    azimuth = str2num(patient_info{8});
    elevation = str2num(patient_info{11});
    assignin('base', 'patient_info', patient_info);
    nb_fichiers = size(d);
    nb_fichiers = nb_fichiers(1);
    %Les fichiers saufs patientInfo.txt
    identifiants_fichiers = cell((nb_fichiers-3),1);
    fichiers = cell((nb_fichiers-3),1);

    %Pour éviter les fichiers . .. et PatientInfo.txt on commence au fichier
    %numéro 4

    barre_attente = waitbar(0,'Merci de patienter pendant le chargement des fichiers...');

    for ifichier = 1:nb_fichiers-3
        %disp(['1706 exports matlab Virginie\Données exportées\1648550067\RawData_Vol', num2str(i), '.bin']);
        %disp([chemin_dossier,d(ifichier+3).name]);
        %identifiants_fichiers{i}=fopen(['1706 exports matlab Virginie\Données exportées\1648550067\RawData_Vol', num2str(i),'.bin']);
        if ispc
            identifiants_fichiers{ifichier}=fopen([chemin,'\',d(ifichier+3).name]);
        elseif ismac
            identifiants_fichiers{ifichier}=fopen([chemin,'/',d(ifichier+3).name]);
        end
        fichiers{ifichier}=fread(identifiants_fichiers{ifichier});
        fichiers{ifichier} =reshape(fichiers{ifichier},range,azimuth,elevation);
        waitbar(ifichier/(nb_fichiers-3));
    end
    assignin('base', 'fichiers', fichiers);
    volumes = cat(4,fichiers{:});
    volumes = permute(volumes,[2,1,3,4]);
    close(barre_attente);
elseif choix_chargement==format_mat
    %identifiant_volumes=fopen([chemin, nom_du_fichier]);
    %volumes=fread(identifiant_volumes);
    cellules_volumes = struct2cell(load([chemin, nom_du_fichier], '-mat'));
    volumes = cellules_volumes{1}; 
end

    
handles.volumes = volumes;

set(handles.valeur_axe3_image,'enable','on','BackgroundColor','white','String','1');
set(handles.valeur_axe4_image,'enable','on','BackgroundColor','white','String','1');
handles.vue_choisie = 0;

guidata(hObject, handles);
afficherImage_Callback(hObject, eventdata, handles);

% --- Executes on button press in afficherImage.
function afficherImage_Callback(hObject, eventdata, handles)
%Affiche l'image dans handles.image 
%correspondant à la coordonnée dans l'axe 3 et l'axe 4
%choisie dans les champs correspondants.
% hObject    handle to afficherImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Récupère les coordonnées de l'axe 3 et l'axe 4 choisis par l'utilisateur
%et les convertit en entier signés codés sur 16 bits
coordonnee_axe3 = int16(str2double(get(handles.valeur_axe3_image,'String')));
coordonnee_axe4 = int16(str2double(get(handles.valeur_axe4_image,'String')));

%On affiche l'image dans handles.image
axes(handles.image); %choix de l'endroit où on affiche l'image
imshow4(handles.volumes,hObject,handles,coordonnee_axe3,coordonnee_axe4); %Appel de la fonction d'affichage d'image 4D
%On ajoute la possibilité de faire un clic droit sur l'image pour afficher
%un menu contextuel qui permet de sélectionner une région d'intérêt
uicontextmenu = get(handles.image,'UIContextMenu'); %le menu contextuel est créé sur l'axe grâce à GUIDE...
set(handles.image.Children,'UIContextMenu',uicontextmenu); %mais doit être récupéré puis reparamétré pour fonctionner sur l'image qui s'affiche sur l'axe.

%Une fois l'image sélectionnée, on peut permettre à l'utilisateur de
%choisir une région d'intérêt, ce qu'on lui indique visuellement en passant
%du gris au blanc les éléments graphiques correspondants. On utilise pour
%cela des mutateurs d'objets enregistrés dans handles.
set(handles.valeur_axe1Debut_graphique,'enable','on','BackgroundColor','white');
set(handles.valeur_axe2Debut_graphique,'enable','on','BackgroundColor','white');
set(handles.valeur_axe1Fin_graphique,'enable','on','BackgroundColor','white');
set(handles.valeur_axe2Fin_graphique,'enable','on','BackgroundColor','white');
%set(handles.coupeSelonX,'enable','on','BackgroundColor','white');
%set(handles.coupeSelonY,'enable','on','BackgroundColor','white');
%set(handles.sommeX,'enable','on','BackgroundColor','white');
%set(handles.sommeY,'enable','on','BackgroundColor','white');

%On sauvegarde les modifications que l'on a fait dans handles dans la
%figure handles.figure1
guidata(handles.figure1,handles);


% --- Executes on selection change in choix_du_pic.
function choix_du_pic_Callback(hObject, eventdata, handles)
% hObject    handle to choix_du_pic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns choix_du_pic contents as cell array
%        contents{get(hObject,'Value')} returns selected item from choix_du_pic
pic_choisi = get(handles.choix_du_pic,'Value');
set(handles.lmh_affichage,'String',handles.lmhs(pic_choisi));
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
x_plus_grand_des_deux_pics = handles.x_maxs(combinaison_pics_choisis(2));
x_plus_petit_des_deux_pics = handles.x_maxs(combinaison_pics_choisis(1));
set(handles.dpap_affichage,'String',num2str(abs(x_plus_grand_des_deux_pics-x_plus_petit_des_deux_pics)));
guidata(hObject, handles);

% --- Executes on button press in selection_region_interet.
function selection_region_interet_Callback(hObject, eventdata, handles)
% hObject    handle to selection_region_interet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
choix_ROI_rectangle=strcmp(handles.choix_forme_ROI,'rectangle');
choix_ROI_polygone=strcmp(handles.choix_forme_ROI,'polygone');

coordonnee_axe3 = int16(str2double(get(handles.valeur_axe3_image,'String')));
coordonnee_axe4 = int16(str2double(get(handles.valeur_axe4_image,'String')));

handles.choix_ROI_polygone = choix_ROI_polygone;
handles.ss_echantillonnage_effectue = false;

try
    cla(handles.graphique,'reset'); %Efface le graphique précédent
    cla(handles.image.Children);
%     if isfield(handles,'rectangle')
%         delete(handles.rectangle); %Efface la région d'intérêt tracée précédente
%     end
% 
%     if isfield(handles,'rectangle_trace')
%         delete(handles.rectangle_trace);
%     end
%     
%     if isfield(handles,'polygone_trace')
%     delete(handles.polygone_trace);
%     end
%   
   
    


    %image = getimage(handles.image);

    %Conversion des indices de matrice (lignes/colonnes) en coordonnées
    %cartésiennes par transposition de la matrice
    %image = image';

    if choix_ROI_rectangle
        
        %On accède aux valeurs de coordonnées par des accesseurs
        valeur_axe1Debut_graphique = get(handles.valeur_axe1Debut_graphique,'Value');
        valeur_axe2Debut_graphique = get(handles.valeur_axe2Debut_graphique,'Value');
        valeur_axe1Fin_graphique = get(handles.valeur_axe1Fin_graphique,'Value');
        valeur_axe2Fin_graphique = get(handles.valeur_axe2Fin_graphique,'Value');


        %On enregistre ces données dans le champ 'UserData' des boites
        %correspondantes aux coordonnées des axes
        set(handles.valeur_axe1Debut_graphique,'UserData',valeur_axe1Debut_graphique);
        set(handles.valeur_axe2Debut_graphique,'UserData',valeur_axe2Debut_graphique);
        set(handles.valeur_axe1Fin_graphique,'UserData',valeur_axe1Fin_graphique);
        set(handles.valeur_axe2Fin_graphique,'UserData',valeur_axe2Fin_graphique);
        
        volumes = handles.volumes;

        %Les Y sont en abscisse et les X en ordonnées parce que Matlab voie les Y
        %comme des noms de colonne de matrice
        %ce qui n'est pas l'intuition cartésienne
        %image_ROI = image(int16(valeur_axe2Debut_graphique):int16(valeur_axe2Fin_graphique),int16(valeur_axe1Debut_graphique):int16(valeur_axe1Fin_graphique));
        %image_ROI = image(int16(valeur_axe1Debut_graphique):int16(valeur_axe1Fin_graphique),int16(valeur_axe2Debut_graphique):int16(valeur_axe2Fin_graphique));
        taille_volumes=size(volumes);
        volumes_ROI=volumes(int16(valeur_axe1Debut_graphique):int16(valeur_axe1Fin_graphique),int16(valeur_axe2Debut_graphique):int16(valeur_axe2Fin_graphique),:,:);
        handles.volumes_ROI=volumes_ROI;
    elseif choix_ROI_polygone
        volumes_ROI=handles.volumes_ROI;
    end
    
    taille_volumes=size(volumes_ROI);

    image_ROI = volumes_ROI(:,:,coordonnee_axe3,coordonnee_axe4);
    handles.image_ROI = image_ROI;
    
    



    %if xor(valeurs_axe1_DebutFin_distinctes,valeurs_axe2_DebutFin_distinctes)
    %    handles.ligne = line([valeur_axe1Debut_graphique,valeur_axe1Fin_graphique],[valeur_axe2Debut_graphique,valeur_axe2Fin_graphique],'Color',[1 0 0]);
    %elseif (valeurs_axe1_DebutFin_distinctes && valeurs_axe2_DebutFin_distinctes)
    %end

    %handles.volumes_ROI_rectangle = volumes_ROI_rectangle;
    
    if choix_ROI_rectangle
        axes(handles.image);
        valeurs_axe1_DebutFin_distinctes = valeur_axe1Debut_graphique~=valeur_axe1Fin_graphique;
        valeurs_axe2_DebutFin_distinctes = valeur_axe2Debut_graphique~=valeur_axe2Fin_graphique;
        handles.valeurs_axe1_DebutFin_distinctes = valeurs_axe1_DebutFin_distinctes;
        handles.valeurs_axe2_DebutFin_distinctes = valeurs_axe2_DebutFin_distinctes;
        
        set(handles.moyenne_axe1,'Visible','on');
        set(handles.moyenne_axe2,'Visible','on');
        set(handles.pas_de_moyenne,'Visible','on');
        set(handles.graphique_selon_axe1,'Visible','on');
        set(handles.graphique_selon_axe2,'Visible','on');
    elseif choix_ROI_polygone
        set(handles.moyenne_axe1et2,'Value',1);
        set(handles.moyenne_axe1,'Visible','off');
        set(handles.moyenne_axe2,'Visible','off');
        set(handles.pas_de_moyenne,'Visible','off');

        set(handles.graphique_selon_axe4,'Value',1);
        set(handles.graphique_selon_axe1,'Visible','off');
        set(handles.graphique_selon_axe2,'Visible','off');
    end
    
        set(handles.affichage_entropie,'BackgroundColor','white');

    guidata(hObject, handles);
catch erreurs
    if (strcmp(erreurs.identifier,'MATLAB:badsubscript'))
        warndlg('Merci d''entrer une région d''intérêt incluse dans l''image.');
        messsage_erreur = 'La région d''intérêt dépasse de l''image.';
        cause_erreur = MException('MATLAB:badsubscript',messsage_erreur);
        erreurs = addCause(erreurs,cause_erreur);
    end
    rethrow(erreurs);
end





% --- Executes during object creation, after setting all properties.
function graphique_CreateFcn(hObject, eventdata, handles)
% hObject    handle to graphique (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% Hint: place code in OpeningFcn to populate graphique



function valeur_axe1Debut_graphique_Callback(hObject, eventdata, handles)
% hObject    handle to valeur_axe1Debut_graphique (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'Value',int16(str2double(get(hObject,'String'))));
guidata(hObject,handles);
    

% Hints: get(hObject,'String') returns contents of valeur_axe1Debut_graphique as text
%        str2double(get(hObject,'String')) returns contents of valeur_axe1Debut_graphique as a double


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

%Pour utilisation de l'entropie l'image doit avoir 256 niveaux
image_ROI=handles.image_ROI;
image_ROI=image_ROI(~isnan(image_ROI));
image_ROI_8bits=uint8(image_ROI);
entropie_region_interet=entropy(image_ROI_8bits);
set(handles.affichage_entropie,'String',num2str(entropie_region_interet));

guidata(handles.figure1,handles);






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

%On enlève l'éventuel résultat d'une exécution précédente
%[nombre_de_lignes_affichees_graphique ~] = size(handles.graphique.Children);
% if nombre_de_lignes_affichees_graphique>2
%     delete(handles.graphique.Children(2:5));
% end

cla(handles.graphique);
afficher_graphique_Callback(hObject, eventdata, handles);
handles=guidata(hObject);

guidata(hObject, handles);

graphique_selon_axe1_choisi = get(handles.graphique_selon_axe1,'value');
graphique_selon_axe2_choisi = get(handles.graphique_selon_axe2,'value');
graphique_selon_axe3_choisi = get(handles.graphique_selon_axe3,'value');
graphique_selon_axe4_choisi = get(handles.graphique_selon_axe4,'value');

valeur_nombre_de_pics = str2double(get(handles.valeur_nombre_de_pics,'String'));

try
    taille_fenetre_lissage = str2double(get(handles.valeur_taille_fenetre_lissage,'String'));
    if mod(taille_fenetre_lissage,2) == 0
        erreurImpaire.message = 'Fenêtre de taille paire.';
        erreurImpaire.identifier = 'detection_pics_Callback:taille_fenetre_paire';
        error(erreurImpaire);
    end
    
    if ~handles.une_seule_courbe
        erreurPlusieursCourbes.message = 'Plusieurs courbes affichées.';
        erreurPlusieursCourbes.identifier = 'detection_pics_Callback:plusieurs_courbes_affichees';
        error(erreurPlusieursCourbes);
    end

    %On accède aux valeurs des coordonnées
    %valeur_axe1Debut_graphique = get(handles.valeur_axe1Debut_graphique,'UserData');
    %valeur_axe2Debut_graphique = get(handles.valeur_axe2Debut_graphique,'UserData');
    %valeur_axe1Fin_graphique = get(handles.valeur_axe1Fin_graphique,'UserData');
    %valeur_axe2Fin_graphique = get(handles.valeur_axe2Fin_graphique,'UserData');

    %%Lissage de la courbe
    %On accède la taille de fenêtre de lissage choisie (si ==1 pas de lissage)

    taille_fenetre_lissage = str2double(get(handles.valeur_taille_fenetre_lissage,'String'));

    %image_ROI = double(handles.image_ROI);
    
    courbe_ROI = double(handles.courbe_ROI);
    abscisse_courbe_ROI=double(handles.abscisse_courbe_ROI);
    
    if taille_fenetre_lissage~=1
        filtre_lissage = (1/taille_fenetre_lissage)*ones(1,taille_fenetre_lissage);
        coefficient_filtre = 1;
        courbe_ROI = filter(filtre_lissage,coefficient_filtre,courbe_ROI);
    end

    axes(handles.graphique);
    hold on
    if graphique_selon_axe1_choisi
        [y_maxs,x_maxs,lmhs,~] = findpeaks(courbe_ROI,abscisse_courbe_ROI,'SortStr','descend','NPeaks',valeur_nombre_de_pics);
        findpeaks(courbe_ROI,abscisse_courbe_ROI,'Annotate','extents','SortStr','descend','NPeaks',valeur_nombre_de_pics);
        y_maxs=y_maxs';
    elseif graphique_selon_axe2_choisi
        [y_maxs,x_maxs,lmhs,~] = findpeaks(courbe_ROI,abscisse_courbe_ROI,'SortStr','descend','NPeaks',valeur_nombre_de_pics);
        findpeaks(courbe_ROI,abscisse_courbe_ROI,'Annotate','extents','SortStr','descend','NPeaks',valeur_nombre_de_pics);
    elseif graphique_selon_axe3_choisi
        [y_maxs,x_maxs,lmhs,~] = findpeaks(courbe_ROI,abscisse_courbe_ROI,'SortStr','descend','NPeaks',valeur_nombre_de_pics);
        findpeaks(courbe_ROI,abscisse_courbe_ROI,'Annotate','extents','SortStr','descend','NPeaks',valeur_nombre_de_pics);
    elseif graphique_selon_axe4_choisi
        [y_maxs,x_maxs,lmhs,~] = findpeaks(courbe_ROI,abscisse_courbe_ROI,'SortStr','descend','NPeaks',valeur_nombre_de_pics);
        findpeaks(courbe_ROI,abscisse_courbe_ROI,'Annotate','extents','SortStr','descend','NPeaks',valeur_nombre_de_pics);
        y_maxs=y_maxs';
    end
    legend('off');
    hold off


    %Passage de x_maxs en vecteur colonne pour affichage
    x_maxs=x_maxs';
    
    handles.x_maxs=x_maxs;



    %Affichage de la liste de pics dans la première liste déroulante
    [nombre_de_pics ~] = size(y_maxs);
    crochet_ouvrant = repmat('[', nombre_de_pics , 1);
    virgule = repmat(', ',nombre_de_pics,1);
    crochet_fermant = repmat(']',nombre_de_pics,1);
    liste_de_pics = [crochet_ouvrant num2str(x_maxs) virgule ...
        num2str(y_maxs) crochet_fermant];
    set(handles.choix_du_pic,'String',liste_de_pics);
    pic_choisi = get(handles.choix_du_pic,'Value');
    set(handles.lmh_affichage,'String',lmhs(pic_choisi));
    handles.lmhs=lmhs;

    %Affichage des combinaisons de deux pics dans la deuxième liste déroulante
    if valeur_nombre_de_pics>1
        set(handles.choix_de_deux_pics,'Visible','on');
        set(handles.texte_choix_de_deux_pics,'Visible','on');
        set(handles.dpap_affichage,'Visible','on');
        set(handles.texte_dpap,'Visible','on');
        set(handles.unite_dpap,'Visible','on');
        [~,nb_colonnes]=size(liste_de_pics);
        liste_de_pics_cellules=mat2cell(liste_de_pics,ones(1,nombre_de_pics),nb_colonnes);
        combinaisons_indices_de_deux_pics = combnk(1:nombre_de_pics,2);
        [nb_combinaisons,~] = size(combinaisons_indices_de_deux_pics);
        combinaisons_de_deux_pics=cell(nb_combinaisons,1);
        for ligne=1:nb_combinaisons
            combinaisons_de_deux_pics{ligne} = [liste_de_pics_cellules{combinaisons_indices_de_deux_pics(ligne,1),1} ...
                ' & ' liste_de_pics_cellules{combinaisons_indices_de_deux_pics(ligne,2),1}];
        end
        
        set(handles.choix_de_deux_pics,'String',combinaisons_de_deux_pics);
        handles.combinaisons_indices_de_deux_pics = combinaisons_indices_de_deux_pics;
        numero_combinaison_de_deux_pics_choisie = get(handles.choix_de_deux_pics,'Value');
        combinaison_pics_choisis = combinaisons_indices_de_deux_pics(numero_combinaison_de_deux_pics_choisie,:);
        x_plus_grand_des_deux_pics = x_maxs(combinaison_pics_choisis(2));
        x_plus_petit_des_deux_pics = x_maxs(combinaison_pics_choisis(1));
        set(handles.dpap_affichage,'String',num2str(abs(x_plus_grand_des_deux_pics-x_plus_petit_des_deux_pics)));
    else
        set(handles.choix_de_deux_pics,'Visible','off');
        set(handles.texte_choix_de_deux_pics,'Visible','off');
        set(handles.dpap_affichage,'Visible','off');
        set(handles.texte_dpap,'Visible','off');
        set(handles.unite_dpap,'Visible','off');
    end
    set(handles.facteur_temps_I_max,'Enable','on','BackgroundColor','white');
    set(handles.facteur_sous_echantillonnage,'Enable','on','BackgroundColor','white');
    
    handles.detection_pics_effectuee = true;
    %handles.ss_echantillonnage_effectue = false;
    guidata(hObject, handles);
catch erreurs
    if (strcmp(erreurs.identifier,'detection_pics_Callback:taille_fenetre_paire'))
        warndlg('Merci d''entrer une taille de fenêtre de lissage impaire.');
        causeException = MException(erreurImpaire.identifier,erreurImpaire.message);
        erreurs = addCause(erreurs,causeException);
        throw(causeException);
    elseif (strcmp(erreurs.identifier,'detection_pics_Callback:plusieurs_courbes_affichees'))
        warndlg('Merci de n''afficher qu''une seule courbe dans la partie ''affichage du graphique''.');
        causeException = MException(erreurPlusieursCourbes.identifier,erreurPlusieursCourbes.message);
        erreurs = addCause(erreurs,causeException);
        throw(causeException);
    end
    
    rethrow(erreurs);
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

if isfield(handles,'rectangle_trace')
    delete(handles.rectangle_trace);
end

if isfield(handles,'polygone_trace')
    delete(handles.polygone_trace);
end

try
    set(handles.figure1,'KeyPressFcn','')
    objet_rectangle = imrect;
    if isempty(objet_rectangle)
        erreur_ROI_pas_choisi.message = 'La région d''intérêt n''a pas été délimitée avant le changement de vue.';
        erreur_ROI_pas_choisi.identifier = 'Rectangle_Callback:ROI_pas_choisi';
        error(erreur_ROI_pas_choisi);
    end
    position_rectangle = getPosition(objet_rectangle);
    valeur_axe1Debut_graphique=position_rectangle(1);
    valeur_axe2Debut_graphique=position_rectangle(2);
    largeur_axe1=position_rectangle(3);
    hauteur_axe2=position_rectangle(4);
    valeur_axe1Fin_graphique = valeur_axe1Debut_graphique + largeur_axe1;
    valeur_axe2Fin_graphique = valeur_axe2Debut_graphique + hauteur_axe2;

    %On arrondit les valeurs des coordonnées sélectionnées
    valeur_axe1Debut_graphique=int16(round(valeur_axe1Debut_graphique));
    valeur_axe2Debut_graphique=int16(round(valeur_axe2Debut_graphique));
    valeur_axe1Fin_graphique=int16(round(valeur_axe1Fin_graphique));
    valeur_axe2Fin_graphique=int16(round(valeur_axe2Fin_graphique));

    set(handles.valeur_axe1Debut_graphique,'Value',valeur_axe1Debut_graphique,'String',num2str(valeur_axe1Debut_graphique));
    set(handles.valeur_axe2Debut_graphique,'Value',valeur_axe2Debut_graphique,'String',num2str(valeur_axe2Debut_graphique));
    set(handles.valeur_axe1Fin_graphique,'Value',valeur_axe1Fin_graphique,'String',num2str(valeur_axe1Fin_graphique));
    set(handles.valeur_axe2Fin_graphique,'Value',valeur_axe2Fin_graphique,'String',num2str(valeur_axe2Fin_graphique));

    handles.rectangle_trace = rectangle('Position',[valeur_axe1Debut_graphique valeur_axe2Debut_graphique largeur_axe1 hauteur_axe2],'EdgeColor','r');

    delete(objet_rectangle);

    handles.choix_forme_ROI = 'rectangle';
    guidata(hObject,handles);
    selection_region_interet_Callback(hObject, eventdata, handles)
catch erreurs
    if (strcmp(erreurs.identifier,'Rectangle_Callback:ROI_pas_choisi'))
        causeException = MException(erreur_ROI_pas_choisi.identifier,erreur_ROI_pas_choisi.message);
        erreurs = addCause(erreurs,causeException);
    else
        rethrow(erreurs);
    end
end
set(handles.figure1,'KeyPressFcn',{@clavier,handles})


% --------------------------------------------------------------------
function ContexteImage_Callback(hObject, eventdata, handles)
% hObject    handle to ContexteImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function VueSagitale_Callback(hObject, eventdata, handles)
% hObject    handle to VueSagitale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ChangementVue_Callback(hObject, eventdata, handles)
% hObject    handle to ChangementVue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ChoixDeLaVue_Callback(hObject, eventdata, handles)
% hObject    handle to ChoixDeLaVue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ChoixDuROI_Callback(hObject, eventdata, handles)
% hObject    handle to ChoixDuROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function VueTransversale_Callback(hObject, eventdata, handles)
% hObject    handle to VueTransversale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imline;


% --------------------------------------------------------------------
function SelectionVue_Callback(hObject, eventdata, handles)
% hObject    handle to SelectionVue (see GCBO)
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




function affichage_somme_des_distances_Callback(hObject, eventdata, handles)
% hObject    handle to affichage_somme_des_distances (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of affichage_somme_des_distances as text
%        str2double(get(hObject,'String')) returns contents of affichage_somme_des_distances as a double


% --- Executes during object creation, after setting all properties.
function affichage_somme_des_distances_CreateFcn(hObject, eventdata, handles)
% hObject    handle to affichage_somme_des_distances (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


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
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



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


% --- Executes on button press in graphique_selon_axe1.
function graphique_selon_axe1_Callback(hObject, eventdata, handles)
% hObject    handle to graphique_selon_axe1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
moyenne_axe1_ou_axe1et2_choisie = logical(get(handles.moyenne_axe1,'value')) || ...
   logical(get(handles.moyenne_axe1et2,'value'));
if moyenne_axe1_ou_axe1et2_choisie
    set(handles.moyenne_axe2,'value',1);
end
guidata(handles.figure1,handles);

% Hint: get(hObject,'Value') returns toggle state of graphique_selon_axe1


% --- Executes on button press in graphique_selon_axe2.
function graphique_selon_axe2_Callback(hObject, eventdata, handles)
% hObject    handle to graphique_selon_axe2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
moyenne_axe2_ou_axe1et2_choisie = logical(get(handles.moyenne_axe2,'value')) || ...
   logical(get(handles.moyenne_axe1et2,'value'));
if moyenne_axe2_ou_axe1et2_choisie
    set(handles.moyenne_axe1,'value',1);
end
guidata(handles.figure1,handles);

% Hint: get(hObject,'Value') returns toggle state of graphique_selon_axe2


% --- Executes on button press in moyenne_axe1.
function moyenne_axe1_Callback(hObject, eventdata, handles)
% hObject    handle to moyenne_axe1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
graphique_selon_axe1ou3ou4_choisi = get(handles.graphique_selon_axe1,'value') || ...
    get(handles.graphique_selon_axe3,'value') || get(handles.graphique_selon_axe4,'value') ;
if graphique_selon_axe1ou3ou4_choisi
    set(handles.graphique_selon_axe2,'value',1);
end
guidata(handles.figure1,handles);

% Hint: get(hObject,'Value') returns toggle state of moyenne_axe1


% --- Executes on button press in moyenne_axe2.
function moyenne_axe2_Callback(hObject, eventdata, handles)
% hObject    handle to moyenne_axe2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
graphique_selon_axe2ou3ou4_choisi = get(handles.graphique_selon_axe2,'value') || ...
    get(handles.graphique_selon_axe3,'value') || get(handles.graphique_selon_axe4,'value') ;
if graphique_selon_axe2ou3ou4_choisi
    set(handles.graphique_selon_axe1,'value',1);
end
guidata(handles.figure1,handles);

% Hint: get(hObject,'Value') returns toggle state of moyenne_axe2


% --- Executes on button press in afficher_graphique.
function afficher_graphique_Callback(hObject, eventdata, handles)
% hObject    handle to afficher_graphique (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cla(handles.graphique);

%choix_ROI_rectangle=isfield(handles,'rectangle_trace');
%choix_ROI_polygone=isfield(handles,'polygone_trace');

coordonnee_axe3 = int16(str2double(get(handles.valeur_axe3_image,'String')));
coordonnee_axe4 = int16(str2double(get(handles.valeur_axe4_image,'String')));
graphique_selon_axe1 = get(handles.graphique_selon_axe1,'Value');
graphique_selon_axe2 = get(handles.graphique_selon_axe2,'Value');
graphique_selon_axe3 = get(handles.graphique_selon_axe3,'Value');
graphique_selon_axe4 = get(handles.graphique_selon_axe4,'Value');

points_de_donnees = get(handles.points_de_donnees,'Value');

volumes_ROI=handles.volumes_ROI;
image_ROI=handles.image_ROI;
ordre_axes=handles.ordre_axes;
taille_axes=handles.taille_axes;

legende_abscisse_graphique={'X (en pixels)','Y (en pixels)','Z (en pixels)','Temps (en pas de temps)'};
noms_axes=['X','Y','Z','Temps'];


valeur_axe1Debut_graphique = get(handles.valeur_axe1Debut_graphique,'UserData');
valeur_axe2Debut_graphique = get(handles.valeur_axe2Debut_graphique,'UserData');
valeur_axe1Fin_graphique = get(handles.valeur_axe1Fin_graphique,'UserData');
valeur_axe2Fin_graphique = get(handles.valeur_axe2Fin_graphique,'UserData');

moyenne_axe1 = get(handles.moyenne_axe1,'Value');
moyenne_axe2 = get(handles.moyenne_axe2,'Value');
moyenne_axe1et2 = get(handles.moyenne_axe1et2,'Value');
pas_de_moyenne = get(handles.pas_de_moyenne,'Value');

taille_volumes=size(volumes_ROI);

axes(handles.graphique);
if moyenne_axe1
    image_ROI = mean(image_ROI,1);
    %Enlever les dimensions inutiles laissées par la moyenne
    image_ROI = squeeze(image_ROI);
    handles.courbes_ROI=image_ROI;
elseif moyenne_axe2
    image_ROI = mean(image_ROI,2);
    %Pour avoir toujours des données en ligne
    image_ROI = image_ROI';
    %Enlever les dimensions inutiles laissées par la moyenne
    image_ROI = squeeze(image_ROI);
    handles.courbes_ROI=image_ROI;
elseif moyenne_axe1et2
    volumes_ROI=nanmean(nanmean(volumes_ROI,1),2);
    %Enlever les dimensions inutiles laissées par les moyennes
    volumes_ROI=squeeze(volumes_ROI);
    %Si l'ordre des axes n'est pas maintenu après moyennage
    %if ordre_axes(3)>ordre_axes(4)
    %    volumes_ROI=permute(volumes_ROI,[2,1]);
    %end
end




%Problème coordonnées cartésiennes/matrice ici
if graphique_selon_axe1
    x = int16(valeur_axe1Debut_graphique):int16(valeur_axe1Fin_graphique);
    y = image_ROI ;
    %plot(x,image_ROI,'b+',x,image_ROI,'b','displayname','Courbe originale','HitTest', 'off');
    xlabel(legende_abscisse_graphique(ordre_axes(1)));
elseif graphique_selon_axe2
    x = int16(valeur_axe2Debut_graphique):int16(valeur_axe2Fin_graphique);
    y = image_ROI';
    %plot(x,image_ROI,'displayname','Courbe originale','HitTest', 'off');
    xlabel(legende_abscisse_graphique(ordre_axes(2)));
    handles.abscisse_courbe_ROI=int16(valeur_axe2Debut_graphique):int16(valeur_axe2Fin_graphique);
elseif graphique_selon_axe3
    y = volumes_ROI(:,coordonnee_axe4);
    x = 1:int16(taille_axes(ordre_axes(3)));
    %plot(x,volumes_ROI,'displayname','Courbe originale','HitTest', 'off');
    xlabel(legende_abscisse_graphique(ordre_axes(3)));
elseif graphique_selon_axe4
    y = volumes_ROI(coordonnee_axe3,:);
    x = 1:int16(taille_axes(ordre_axes(4)));
    %plot(x,volumes_ROI,'displayname','Courbe originale','HitTest', 'off');
    xlabel(legende_abscisse_graphique(ordre_axes(4)));
end

handles.courbe_ROI = y;
handles.abscisse_courbe_ROI=x;

hold on
plot(x,y,'displayname','Courbe originale','HitTest', 'off');

if points_de_donnees && ~handles.ss_echantillonnage_effectue
    plot(x,y,'black+','displayname','Point de données','HitTest', 'off');
end


if handles.ss_echantillonnage_effectue
    vecteur_t_ech_normal = handles.vecteur_t_ech_normal;
    vecteur_t_ssech = handles.vecteur_t_ssech;
    handles.points_ech_normal = plot(vecteur_t_ech_normal,y(vecteur_t_ech_normal),'black+','displayname','Echantillonnage normal','HitTest', 'off');
    handles.points_ssech_normal = plot(vecteur_t_ssech,y(vecteur_t_ssech),'red+','displayname','Sous-échantillonnage','HitTest', 'off');
    legend([handles.points_ech_normal,handles.points_ssech_normal]);
end
hold off


if strcmp(handles.choix_forme_ROI,'rectangle');
    ligne = xor(handles.valeurs_axe1_DebutFin_distinctes,handles.valeurs_axe2_DebutFin_distinctes);
else
    ligne = false;
end

handles.une_seule_courbe = ligne || moyenne_axe1 || moyenne_axe2 || moyenne_axe1et2;

if handles.une_seule_courbe
    title('Courbe d''intensité');
else
    title('Courbes d''intensité');
end

if moyenne_axe1
    ylabel({'Intensité (en niveaux)',...
['moyennée sur ',noms_axes(ordre_axes(1)),' dans la région d''intérêt']});
elseif moyenne_axe2
    ylabel({'Intensité (en niveaux)',...
['moyennée sur ',noms_axes(ordre_axes(2)),' dans la région d''intérêt']});
elseif moyenne_axe1et2
    ylabel({'Intensité (en niveaux)',...
['moyennée sur ',noms_axes(ordre_axes(1)),' et ',noms_axes(ordre_axes(2))],...
' dans la région d''intérêt'});
elseif pas_de_moyenne
    ylabel('Intensité (en niveaux)');
end
 

set(handles.choix_du_pic,'enable','on','BackgroundColor','white');
set(handles.choix_de_deux_pics,'enable','on','BackgroundColor','white');
set(handles.lmh_affichage,'BackgroundColor','white');
set(handles.dpap_affichage,'BackgroundColor','white');
set(handles.valeur_taille_fenetre_lissage,'enable','on','BackgroundColor','white');
set(handles.valeur_nombre_de_pics,'enable','on','BackgroundColor','white');
guidata(handles.figure1,handles);




% --------------------------------------------------------------------
function sauvegarde_graphique_Callback(hObject, eventdata, handles)
% hObject    handle to sauvegarde_graphique (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[nom_du_fichier,chemin] = uiputfile({'*.png';'*.jpeg';'*.bmp';'*.tiff';'*.pdf';'*.eps'});
dossier_principal=pwd;
cd(chemin);
export_fig(handles.graphique, nom_du_fichier);
cd(dossier_principal)

% --------------------------------------------------------------------
function ContexteGraphique_Callback(hObject, eventdata, handles)
% hObject    handle to ContexteGraphique (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function polygone_Callback(hObject, eventdata, handles)
% hObject    handle to polygone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles,'rectangle_trace')
    delete(handles.rectangle_trace);
end

if isfield(handles,'polygone_trace')
    delete(handles.polygone_trace);
end

try
    taille_axes=handles.taille_axes;
    set(handles.figure1,'KeyPressFcn','')
    polygone=impoly;
    if isempty(polygone)
        erreur_ROI_pas_choisi.message = 'La région d''intérêt n''a pas été délimitée avant le changement de vue.';
        erreur_ROI_pas_choisi.identifier = 'polygone_Callback:ROI_pas_choisi';
        error(erreur_ROI_pas_choisi);
    end
    masque_binaire_2D=polygone.createMask();
    %Comme l'image est en coordonnées "indices de matrice"
    masque_binaire_2D=masque_binaire_2D';
    masque_binaire_4D = repmat(masque_binaire_2D,1,1,taille_axes(3),taille_axes(4));
    volumes_ROI=handles.volumes;
    taille_volumes=size(volumes_ROI);
    volumes_ROI(masque_binaire_4D==0) = NaN;
    handles.volumes_ROI = volumes_ROI;


    positions_polygone=getPosition(polygone);
    nb_positions_polygone = size(positions_polygone,1);
    maximum_axe1=handles.taille_axes(handles.ordre_axes(1));
    maximum_axe2=handles.taille_axes(handles.ordre_axes(2));
    for i=1:nb_positions_polygone
        X_pos_i=positions_polygone(i,1);
        Y_pos_i=positions_polygone(i,2);
        if X_pos_i<1 || X_pos_i>maximum_axe1 || Y_pos_i<1 || Y_pos_i>maximum_axe2
            erreur_sortie_de_image.message = 'La région d''intérêt dépasse de l''image.';
            erreur_sortie_de_image.identifier = 'polygone_Callback:sortie_de_image';
            error(erreur_sortie_de_image);
        end
    end
    ordre_des_points=1:nb_positions_polygone;
    polygone_trace=patch('Faces',ordre_des_points,'Vertices',positions_polygone,'FaceColor','none','EdgeColor','red');
    handles.polygone_trace=polygone_trace;
    delete(polygone);

    handles.choix_forme_ROI='polygone';

    guidata(handles.figure1,handles);
    selection_region_interet_Callback(hObject, eventdata, handles)
catch erreurs
    if (strcmp(erreurs.identifier,'polygone_Callback:ROI_pas_choisi'))
        causeException = MException(erreur_ROI_pas_choisi.identifier,erreur_ROI_pas_choisi.message);
        erreurs = addCause(erreurs,causeException);
    elseif (strcmp(erreurs.identifier,'polygone_Callback:sortie_de_image'))
        warndlg('Merci d''entrer une région d''intérêt incluse dans l''image.');
        causeException = MException(erreur_sortie_de_image.identifier,erreur_sortie_de_image.message);
        erreurs = addCause(erreurs,causeException);
        delete(polygone);
    else
        rethrow(erreurs);
    end
end
set(handles.figure1,'KeyPressFcn',{@clavier,handles})

%volumes_filtres=reshape(volume_filtres,taille_axes
%taille_volumes=[size(handles.volumes,1) size(handles.volumes,2) size(handles.volumes,3) size(handles.volumes,4)];
%volumes_filtres=permute(volumes_filtres,[2,1,3,4]);
%volumes_filtres(masque_binaire==0,:,:,:)=[];
%volumes_filtres(:,masque_binaire==0,:,:)=[];
%imshow(volumes_filtres(:,:,3,3));




% --- Executes on button press in moyenne_axe1et2.
function moyenne_axe1et2_Callback(hObject, eventdata, handles)
% hObject    handle to moyenne_axe1et2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
graphique_selon_axe1ou2_choisi = logical(get(handles.graphique_selon_axe1,'value')) || logical(get(handles.graphique_selon_axe2,'value'));
if graphique_selon_axe1ou2_choisi
    set(handles.graphique_selon_axe4,'value',1);
end

% Hint: get(hObject,'Value') returns toggle state of moyenne_axe1et2


% --- Executes on button press in graphique_selon_axe3.
function graphique_selon_axe3_Callback(hObject, eventdata, handles)
% hObject    handle to graphique_selon_axe3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
moyenne_axe1ou2oupas_choisie = logical(get(handles.moyenne_axe1,'value')) || logical(get(handles.moyenne_axe2,'value')) || ...
    logical(get(handles.pas_de_moyenne,'value'));
if moyenne_axe1ou2oupas_choisie
    set(handles.moyenne_axe1et2,'value',1);
end

% Hint: get(hObject,'Value') returns toggle state of graphique_selon_axe3


% --- Executes on button press in graphique_selon_axe4.
function graphique_selon_axe4_Callback(hObject, eventdata, handles)
% hObject    handle to graphique_selon_axe4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
moyenne_axe1ou2oupas_choisie = logical(get(handles.moyenne_axe1,'value')) || logical(get(handles.moyenne_axe2,'value')) || ...
    logical(get(handles.pas_de_moyenne,'value'));
if moyenne_axe1ou2oupas_choisie
    set(handles.moyenne_axe1et2,'value',1);
end

% Hint: get(hObject,'Value') returns toggle state of graphique_selon_axe4


% --- Executes on button press in pas_de_moyenne.
function pas_de_moyenne_Callback(hObject, eventdata, handles)
% hObject    handle to pas_de_moyenne (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

graphique_selon_axe3ou4_choisi = logical(get(handles.graphique_selon_axe3,'value')) || ...
    logical(get(handles.graphique_selon_axe4,'value'));
if graphique_selon_axe3ou4_choisi
    set(handles.graphique_selon_axe1,'value',1);
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


% --- Executes on button press in sous_echantillonnage.
function sous_echantillonnage_Callback(hObject, eventdata, handles)
% hObject    handle to sous_echantillonnage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

nombre_de_pics = str2double(get(handles.valeur_nombre_de_pics,'String'));
choix_ROI_polygone = handles.choix_ROI_polygone ;
graphique_selon_axe4_choisi = get(handles.graphique_selon_axe4,'value');
ordre_axes = handles.ordre_axes;
facteur_temps_I_max=str2double(get(handles.facteur_temps_I_max,'string'));
facteur_sous_echantillonnage=str2double(get(handles.facteur_sous_echantillonnage,'string'));
sauvegarde_sous_echantillonnage = handles.sauvegarde_sous_echantillonnage;

%sous_echantillonnage_possible = (valeur_nombre_de_pics==1) && choix_ROI_polygone && ...
%    graphique_selon_axe4_choisi;
%if sous_echantillonnage_possible
try
    axe_abscisse_pas_temps = ~graphique_selon_axe4_choisi || ordre_axes(4)~=4;
    if nombre_de_pics ~= 1
        erreur_trop_de_pics.message = 'Le nombre de pics détectés est strictement supérieur à 1.';
        erreur_trop_de_pics.identifier = 'sous_echantillonnage_Callback:trop_de_pics';
        error(erreur_trop_de_pics);
    elseif ~choix_ROI_polygone
        erreur_polygone_pas_choisi.message = 'La région d''intérêt n''a pas été choisie avec un polygone.';
        erreur_polygone_pas_choisi.identifier = 'sous_echantillonnage_Callback:polygone_pas_choisi';
        error(erreur_polygone_pas_choisi);
    elseif axe_abscisse_pas_temps
        erreur_axe_abscisse_pas_temps.message = 'L''axe des abscisses du graphique affiché n''est pas le Temps.';
        erreur_axe_abscisse_pas_temps.identifier = 'sous_echantillonnage_Callback:axe_abscisse_pas_temps';
        error(erreur_axe_abscisse_pas_temps);
    end
        
    t_maximum=handles.abscisse_courbe_ROI(end);
    t_du_maximum_global = handles.x_maxs(1);
    if sauvegarde_sous_echantillonnage
        [nom_du_fichier,chemin_sauvegarde] = uiputfile({'*.*'});
        choix_annulation = isequal(nom_du_fichier,0) || isequal(chemin_sauvegarde,0);
        if choix_annulation
            erreur_choix_annulation.message = 'L''utilisateur a annulé son action de sauvegarde.';
            erreur_choix_annulation.identifier = 'sous_echantillonnage_Callback:choix_annulation';
            error(erreur_choix_annulation);
        end
        dossier_principal=pwd;
        cd(chemin_sauvegarde);
        barre_attente = waitbar(0,'Merci de patienter pendant l''enregistrement des fichiers...');
        volumes = cell(t_maximum,1);
    end

    compteur_sous_echantillonnage = 0;
    
    
    vecteur_t_ech_normal = NaN(1,t_maximum);
    vecteur_t_ssech=NaN(1,t_maximum);
    
    for t=1:t_maximum
        condition_echantillonnage_normal = t<facteur_temps_I_max*t_du_maximum_global;
        if condition_echantillonnage_normal
            if sauvegarde_sous_echantillonnage
                volume_a_enregistrer=handles.volumes(:,:,:,t);
                volume_a_enregistrer=squeeze(volume_a_enregistrer);
                volumes{t}=volume_a_enregistrer;
            end
            vecteur_t_ech_normal(t)=t;
        elseif mod(compteur_sous_echantillonnage,facteur_sous_echantillonnage)==0
            if sauvegarde_sous_echantillonnage
                volume_a_enregistrer=handles.volumes(:,:,:,t);
                volume_a_enregistrer=squeeze(volume_a_enregistrer);
                volumes{t}=volume_a_enregistrer;
            end
            vecteur_t_ssech(t) = t;
            compteur_sous_echantillonnage = compteur_sous_echantillonnage + 1;
        else
            compteur_sous_echantillonnage = compteur_sous_echantillonnage + 1;
        end
        if sauvegarde_sous_echantillonnage
            waitbar(t/t_maximum);
        end
    end
    
    vecteur_t_ech_normal(isnan(vecteur_t_ech_normal)) = [];
    vecteur_t_ssech(isnan(vecteur_t_ssech)) = [];
    handles.vecteur_t_ech_normal = vecteur_t_ech_normal;
    handles.vecteur_t_ssech = vecteur_t_ssech;
    handles.ss_echantillonnage_effectue = true;
    if sauvegarde_sous_echantillonnage
        volumes_a_enregistrer = cat(4,volumes{:});
        save([nom_du_fichier,'.mat'],'volumes_a_enregistrer','-mat');
        cd(dossier_principal);
        close(barre_attente);
    end
    afficher_graphique_Callback(hObject, eventdata, handles);
catch erreurs
    if (strcmp(erreurs.identifier,'sous_echantillonnage_Callback:trop_de_pics'))
        warndlg('Merci de choisir de détecter un seul pic à l''étape précédente.');
        causeException = MException(erreur_trop_de_pics.identifier,erreur_trop_de_pics.message);
        erreurs = addCause(erreurs,causeException);
        throw(causeException);
    elseif (strcmp(erreurs.identifier,'sous_echantillonnage_Callback:polygone_pas_choisi'))
        warndlg('Merci de choisir une région d''intérêt de forme polygonale et de recommencer les étapes jusqu''ici.');
        causeException = MException(erreur_polygone_pas_choisi.identifier,erreur_polygone_pas_choisi.message);
        erreurs = addCause(erreurs,causeException);
        throw(causeException);
    elseif (strcmp(erreurs.identifier,'sous_echantillonnage_Callback:axe_abscisse_pas_temps'))
        warndlg('Merci de choisir comme axe des abscisse le temps à l''étape ''affichage du graphique''.');
        causeException = MException(erreur_axe_abscisse_pas_temps.identifier,erreur_axe_abscisse_pas_temps.message);
        erreurs = addCause(erreurs,causeException);
        throw(causeException);
    elseif (strcmp(erreurs.identifier, 'sous_echantillonnage_Callback:choix_annulation'))
        causeException = MException(erreur_choix_annulation.identifier,erreur_choix_annulation.message);
        erreurs = addCause(erreurs,causeException);
    end   
    rethrow(erreurs);
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


% --- Executes on button press in affichage_sous_echantillonnage.
function affichage_sous_echantillonnage_Callback(hObject, eventdata, handles)
% hObject    handle to affichage_sous_echantillonnage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.sauvegarde_sous_echantillonnage = false;
sous_echantillonnage_Callback(hObject, eventdata, handles);
handles.sauvegarde_sous_echantillonnage = true;
guidata(handles.figure1,handles);


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
