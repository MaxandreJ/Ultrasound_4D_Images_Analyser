% --- Executes on button press in chargement.
function charger_volumes(hObject, eventdata, handles)
% hObject    handle to chargement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



choix_chargement = get(handles.choix_chargement,'Value');
cla(handles.affichage_graphique);
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
    donnees_4D = cat(4,fichiers{:});
    donnees_4D = permute(donnees_4D,[2,1,3,4]);
    close(barre_attente);
elseif choix_chargement==format_mat
    %identifiant_volumes=fopen([chemin, nom_du_fichier]);
    %volumes=fread(identifiant_volumes);
    cellules_donnees_4D = struct2cell(load([chemin, nom_du_fichier], '-mat'));
    donnees_4D = cellules_donnees_4D{1}; 
end

ordre_axes = [1,2,3,4];    
handles.volumes = Volumes(donnees_4D,ordre_axes);

set(handles.valeur_axe3_image,'enable','on','BackgroundColor','white','String','1');
set(handles.valeur_axe4_image,'enable','on','BackgroundColor','white','String','1');
handles.vue_choisie = 0;

guidata(hObject, handles);
afficher_image(hObject, eventdata, handles);
