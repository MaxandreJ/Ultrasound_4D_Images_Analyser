% --- Executes on button press in selection_region_interet.
function selectionner_region_interet(hObject, eventdata, handles)
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

    %Conversion des indices de matrice (lignes/colonnes) en coordonnées
    %cartésiennes par transposition de la matrice

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
        volumes_ROI=volumes(int16(valeur_axe1Debut_graphique):int16(valeur_axe1Fin_graphique),int16(valeur_axe2Debut_graphique):int16(valeur_axe2Fin_graphique),:,:);
        handles.volumes_ROI=volumes_ROI;
    elseif choix_ROI_polygone
        volumes_ROI=handles.volumes_ROI;
    end

    image_ROI = volumes_ROI(:,:,coordonnee_axe3,coordonnee_axe4);
    handles.image_ROI = image_ROI;
    
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
