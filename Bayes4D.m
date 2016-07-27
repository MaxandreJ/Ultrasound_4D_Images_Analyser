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

% Last Modified by GUIDE v2.5 26-Jul-2016 18:26:17

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

% --- Executes on button press in selection_region_interet.
function selection_region_interet_Callback(hObject, eventdata, handles)
% hObject    handle to selection_region_interet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
choix_ROI_rectangle=strcmp(handles.choix_forme_ROI,'rectangle');
choix_ROI_polygone=strcmp(handles.choix_forme_ROI,'polygone');

coordonnee_axe3 = int16(str2double(get(handles.valeur_axe3_image,'String')));
coordonnee_axe4 = int16(str2double(get(handles.valeur_axe4_image,'String')));


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
        volumes_ROI=volumes(int16(valeur_axe1Debut_graphique):int16(valeur_axe1Fin_graphique),int16(valeur_axe2Debut_graphique):int16(valeur_axe2Fin_graphique),:,:);
        handles.volumes_ROI=volumes_ROI;
    elseif choix_ROI_polygone
        volumes_ROI=handles.volumes_ROI;
    end

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

%On accède aux choix de coupes par des accesseurs
%coupeSelonX = get(handles.coupeSelonX,'Value');
%coupeSelonY = get(handles.coupeSelonY,'Value');

% moyenne_axe1_choisie = logical(get(handles.moyenne_axe1,'value'));
% moyenne_axe2_choisie = logical(get(handles.moyenne_axe2,'value'));
% 
% if moyenne_axe1_choisie || moyenne_axe2_choisie
%     set(handles.pas_de_moyenne,'value',1);
%     afficherGraphique_Callback(hObject, eventdata, handles);
% end
% 
% courbes = get(handles.graphique,'Children');
% [nombre_de_courbes ~]=size(courbes);
% somme_des_distances=0;
% for i=1:nombre_de_courbes
%     for j=i+1:nombre_de_courbes
%         Y=abs(courbes(i).YData-courbes(j).YData);
%         somme_des_distances=sum(Y)+somme_des_distances;
%     end
% end
% somme_des_distances_normalises_nombre_de_courbes=somme_des_distances/(2^nombre_de_courbes);
% 
% set(handles.affichage_somme_des_distances,'String',num2str(somme_des_distances_normalises_nombre_de_courbes));

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
[nombre_de_lignes_affichees_graphique ~] = size(handles.graphique.Children);
if nombre_de_lignes_affichees_graphique>1
    delete(handles.graphique.Children(1:4));
end

guidata(hObject, handles);

graphique_selon_axe1_choisi = get(handles.graphique_selon_axe1,'value');
graphique_selon_axe2_choisi = get(handles.graphique_selon_axe2,'value');
graphique_selon_axe3_choisi = get(handles.graphique_selon_axe3,'value');
graphique_selon_axe4_choisi = get(handles.graphique_selon_axe4,'value');

try
    taille_fenetre_lissage = str2double(get(handles.valeur_taille_fenetre_lissage,'String'));
    if mod(taille_fenetre_lissage,2) == 0
        erreurImpaire.message = 'Fenêtre de taille paire.';
        erreurImpaire.identifier = 'detection_pics_Callback:taille_fenetre_paire';
        error(erreurImpaire);
    end

    %On accède aux valeurs des coordonnées
    valeur_axe1Debut_graphique = get(handles.valeur_axe1Debut_graphique,'UserData');
    valeur_axe2Debut_graphique = get(handles.valeur_axe2Debut_graphique,'UserData');
    valeur_axe1Fin_graphique = get(handles.valeur_axe1Fin_graphique,'UserData');
    valeur_axe2Fin_graphique = get(handles.valeur_axe2Fin_graphique,'UserData');

    %%Lissage de la courbe
    %On accède la taille de fenêtre de lissage choisie (si ==1 pas de lissage)

    taille_fenetre_lissage = str2double(get(handles.valeur_taille_fenetre_lissage,'String'));

    image_ROI = double(handles.image_ROI);

    if taille_fenetre_lissage~=1
        filtre_lissage = (1/taille_fenetre_lissage)*ones(1,taille_fenetre_lissage);
        coefficient_filtre = 1;
        image_ROI_lissees = filter(filtre_lissage,coefficient_filtre,image_ROI);
    else
        image_ROI_lissees = image_ROI;
    end

    axes(handles.graphique);
    hold on
    if graphique_selon_axe1_choisi
        [y_maxs,x_maxs,lmhs,~] = findpeaks(image_ROI_lissees,double(valeur_axe1Debut_graphique):double(valeur_axe1Fin_graphique));
        findpeaks(image_ROI_lissees,double(valeur_axe1Debut_graphique):double(valeur_axe1Fin_graphique),'Annotate','extents');
        y_maxs=y_maxs';
    elseif graphique_selon_axe2_choisi
        [y_maxs,x_maxs,lmhs,~] = findpeaks(image_ROI_lissees,double(valeur_axe2Debut_graphique):double(valeur_axe2Fin_graphique));
        findpeaks(image_ROI_lissees,double(valeur_axe2Debut_graphique):double(valeur_axe2Fin_graphique),'Annotate','extents');
    end
    legend(gca,'off');
    hold off


    %Passage de x_maxs en vecteur colonne pour affichage
    x_maxs=x_maxs';



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
    combinaisons_de_deux_pics = combnk(1:nombre_de_pics,2);
    set(handles.choix_de_deux_pics,'String',num2str(combinaisons_de_deux_pics));
    handles.combinaisons_de_deux_pics = combinaisons_de_deux_pics;
    numero_combinaison_de_deux_pics_choisie = get(handles.choix_de_deux_pics,'Value');
    combinaison_pics_choisis = combinaisons_de_deux_pics(numero_combinaison_de_deux_pics_choisie,:);
    x_plus_grand_des_deux_pics = x_maxs(combinaison_pics_choisis(2));
    x_plus_petit_des_deux_pics = x_maxs(combinaison_pics_choisis(1));
    set(handles.dpap_affichage,'String',num2str(x_plus_grand_des_deux_pics-x_plus_petit_des_deux_pics));

    handles.x_maxs=x_maxs;
    guidata(hObject, handles);
catch ME
    if (strcmp(ME.identifier,'detection_pics_Callback:taille_fenetre_paire'))
        warndlg('Merci d''entrer une taille de fenêtre de lissage impaire.');
        causeException = MException(erreurImpaire.identifier,erreurImpaire.message);
        ME = addCause(ME,causeException);
        throw(causeException);
    end
    rethrow(ME)
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
volumes = permute(volumes,[2,1,3,4]);
handles.volumes = volumes;


handles.nb_fichiers = nb_fichiers-3;

set(handles.valeur_axe3_image,'enable','on','BackgroundColor','white','String','1');
set(handles.valeur_axe4_image,'enable','on','BackgroundColor','white','String','1');
handles.vue_choisie = 0;

guidata(hObject, handles);
afficherImage_Callback(hObject, eventdata, handles);

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

objet_rectangle = imrect;

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
graphique_selon_axe1_choisi = logical(get(handles.graphique_selon_axe1,'value'));
if graphique_selon_axe1_choisi
    set(handles.graphique_selon_axe2,'value',1);
end
guidata(handles.figure1,handles);

% Hint: get(hObject,'Value') returns toggle state of moyenne_axe1


% --- Executes on button press in moyenne_axe2.
function moyenne_axe2_Callback(hObject, eventdata, handles)
% hObject    handle to moyenne_axe2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
graphique_selon_axe2_choisi = logical(get(handles.graphique_selon_axe2,'value'));
if graphique_selon_axe2_choisi
    set(handles.graphique_selon_axe1,'value',1);
end
guidata(handles.figure1,handles);

% Hint: get(hObject,'Value') returns toggle state of moyenne_axe2


% --- Executes on button press in afficher_graphique.
function afficher_graphique_Callback(hObject, eventdata, handles)
% hObject    handle to afficher_graphique (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

choix_ROI_rectangle=isfield(handles,'rectangle_trace');
choix_ROI_polygone=isfield(handles,'polygone_trace');


coordonnee_axe3 = int16(str2double(get(handles.valeur_axe3_image,'String')));
coordonnee_axe4 = int16(str2double(get(handles.valeur_axe4_image,'String')));
graphique_selon_axe1 = get(handles.graphique_selon_axe1,'Value');
graphique_selon_axe2 = get(handles.graphique_selon_axe2,'Value');
graphique_selon_axe3 = get(handles.graphique_selon_axe3,'Value');
graphique_selon_axe4 = get(handles.graphique_selon_axe4,'Value');

volumes_ROI=handles.volumes_ROI;
image_ROI=handles.image_ROI;
ordre_axes=handles.ordre_axes;
taille_axes=handles.taille_axes;

legende_abscisse_graphique={'X (en pixels)','Y (en pixels)','Z (en pixels)','Temps (en numéro de volume)'};
noms_axes=['X','Y','Z','Temps'];


valeur_axe1Debut_graphique = get(handles.valeur_axe1Debut_graphique,'UserData');
valeur_axe2Debut_graphique = get(handles.valeur_axe2Debut_graphique,'UserData');
valeur_axe1Fin_graphique = get(handles.valeur_axe1Fin_graphique,'UserData');
valeur_axe2Fin_graphique = get(handles.valeur_axe2Fin_graphique,'UserData');

moyenne_axe1 = get(handles.moyenne_axe1,'Value');
moyenne_axe2 = get(handles.moyenne_axe2,'Value');
moyenne_axe1et2 = get(handles.moyenne_axe1et2,'Value');
pas_de_moyenne = get(handles.pas_de_moyenne,'Value');

axes(handles.graphique);
if moyenne_axe1
    image_ROI = mean(image_ROI,ordre_axes(1));
    %Enlever les dimensions inutiles laissées par la moyenne
    image_ROI = squeeze(image_ROI);
elseif moyenne_axe2
    image_ROI = mean(image_ROI,ordre_axes(2));
    %Pour avoir toujours des données en ligne
    image_ROI = image_ROI';
    %Enlever les dimensions inutiles laissées par la moyenne
    image_ROI = squeeze(image_ROI);
elseif moyenne_axe1et2
    volumes_ROI=nanmean(nanmean(volumes_ROI,ordre_axes(1)),ordre_axes(2));
    %Enlever les dimensions inutiles laissées par les moyennes
    volumes_ROI=squeeze(volumes_ROI);
end




%Problème coordonnées cartésiennes/matrice ici
if graphique_selon_axe1
    plot(int16(valeur_axe1Debut_graphique):int16(valeur_axe1Fin_graphique),image_ROI,'displayname','Courbe originale','HitTest', 'off');
    xlabel(legende_abscisse_graphique(ordre_axes(1)));
elseif graphique_selon_axe2
    image_ROI = image_ROI';
    plot(int16(valeur_axe2Debut_graphique):int16(valeur_axe2Fin_graphique),image_ROI,'displayname','Courbe originale','HitTest', 'off');
    xlabel(legende_abscisse_graphique(ordre_axes(2)));
elseif graphique_selon_axe3
    volumes_ROI = volumes_ROI(:,coordonnee_axe4);
    plot(1:int16(taille_axes(ordre_axes(3))),volumes_ROI,'displayname','Courbe originale','HitTest', 'off');
    xlabel(legende_abscisse_graphique(ordre_axes(3)));
elseif graphique_selon_axe4
    volumes_ROI = volumes_ROI(coordonnee_axe3,:);
    plot(1:int16(taille_axes(ordre_axes(4))),volumes_ROI,'displayname','Courbe originale','HitTest', 'off');
    xlabel(legende_abscisse_graphique(ordre_axes(4)));
end



if strcmp(handles.choix_forme_ROI,'rectangle');
    ligne = xor(handles.valeurs_axe1_DebutFin_distinctes,handles.valeurs_axe2_DebutFin_distinctes);
else
    ligne = false;
end

une_seule_courbe = ligne || moyenne_axe1 || moyenne_axe2 || moyenne_axe1et2;

if une_seule_courbe
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


%Détermination du nom de l'axe des abscisses du graphique
% coupe_frontale = 0;
% coupe_transverse = 1;
% coupe_sagittale = 2;
% coupe_X_temps = 3;
% coupe_Y_temps = 4;
% coupe_Z_temps = 5;
% 
% switch handles.vue_choisie
%     case coupe_frontale
%         if graphique_selon_axe1
%             xlabel('X (en pixels)');
%         elseif graphique_selon_axe2
%             xlabel('Y (en pixels)');
%         end
%     case coupe_transverse
%         if graphique_selon_axe1
%             xlabel('X (en pixels)');
%         elseif graphique_selon_axe2
%             xlabel('Z (en pixels)');
%         end
%     case coupe_sagittale
%         if graphique_selon_axe1
%             xlabel('Y (en pixels)');
%         elseif graphique_selon_axe2
%             xlabel('Z (en pixels)');
%         end
%     case coupe_X_temps
%         if graphique_selon_axe1
%             xlabel('Temps (en numéro de volume)');
%         elseif graphique_selon_axe2
%             xlabel('X (en pixels)');
%         end
%     case coupe_Y_temps
%         if graphique_selon_axe1
%             xlabel('Temps (en numéro de volume)');
%         elseif graphique_selon_axe2
%             xlabel('Y (en pixels)');
%         end
%     case coupe_Z_temps
%         if graphique_selon_axe1
%             xlabel('Temps (en numéro de volume)');
%         elseif graphique_selon_axe2
%             xlabel('X (en pixels)');
%         end
% end
 
% elseif choix_ROI_polygone
%     volumes_ROI_moyenne_sur_2_1ers_axes=nanmean(nanmean(volumes_ROI,ordre_axes(1)),ordre_axes(2));
%     volumes_ROI_moyenne_sur_2_1ers_axes=squeeze(volumes_ROI_moyenne_sur_2_1ers_axes);
%     if graphique_selon_axe3
%         volumes_ROI_moyenne_sur_2_1ers_axes_selonZ = volumes_ROI_moyenne_sur_2_1ers_axes(:,coordonnee_axe4);
%         plot(1:int16(taille_axes(3)),volumes_ROI_moyenne_sur_2_1ers_axes_selonZ,'displayname','Courbe originale','HitTest', 'off');
%     elseif graphique_selon_axe4
%         volumes_ROI_moyenne_sur_2_1ers_axes_selonT = volumes_ROI_moyenne_sur_2_1ers_axes(coordonnee_axe3,:);
%         plot(1:int16(taille_axes(4)),volumes_ROI_moyenne_sur_2_1ers_axes_selonT,'displayname','Courbe originale','HitTest', 'off');    
%     end
% end
    
    

set(handles.choix_du_pic,'enable','on','BackgroundColor','white');
set(handles.choix_de_deux_pics,'enable','on','BackgroundColor','white');
set(handles.lmh_affichage,'BackgroundColor','white');
set(handles.dpap_affichage,'BackgroundColor','white');
set(handles.valeur_taille_fenetre_lissage,'enable','on','BackgroundColor','white');
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

taille_axes=handles.taille_axes;
polygone=impoly;
masque_binaire_2D=polygone.createMask();
%Comme l'image est en coordonnées "indices de matrice"
masque_binaire_2D=masque_binaire_2D';
masque_binaire_4D = repmat(masque_binaire_2D,1,1,taille_axes(3),taille_axes(4));
volumes_ROI=handles.volumes;
volumes_ROI(masque_binaire_4D==0) = NaN;
handles.volumes_ROI = volumes_ROI;


position_polygone=getPosition(polygone);
ordre_des_points=1:size(position_polygone,1);
polygone_trace=patch('Faces',ordre_des_points,'Vertices',position_polygone,'FaceColor','none','EdgeColor','red');
handles.polygone_trace=polygone_trace;
delete(polygone);

handles.choix_forme_ROI='polygone';

guidata(handles.figure1,handles);
selection_region_interet_Callback(hObject, eventdata, handles)

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
