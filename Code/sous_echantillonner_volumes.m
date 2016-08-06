% --- Executes on button press in sous_echantillonnage.
function sous_echantillonner_volumes(hObject, eventdata, handles)
% hObject    handle to sous_echantillonnage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

volumes = handles.volumes;

nombre_de_pics = str2double(get(handles.valeur_nombre_de_pics,'String'));
choix_ROI_polygone = handles.choix_ROI_polygone ;
graphique_selon_axe4_choisi = get(handles.graphique_selon_axe4,'value');
ordre_axes = volumes.ordre_axes;
facteur_temps_I_max=str2double(get(handles.facteur_temps_I_max,'string'));
facteur_sous_echantillonnage=str2double(get(handles.facteur_sous_echantillonnage,'string'));
sauvegarde_sous_echantillonnage = handles.sauvegarde_sous_echantillonnage;

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
        
    t_maximum=handles.graphique.abscisses(end);
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
                volume_a_enregistrer=handles.volumes.donnees(:,:,:,t);
                volume_a_enregistrer=squeeze(volume_a_enregistrer);
                volumes{t}=volume_a_enregistrer;
            end
            vecteur_t_ech_normal(t)=t;
        elseif mod(compteur_sous_echantillonnage,facteur_sous_echantillonnage)==0
            if sauvegarde_sous_echantillonnage
                volume_a_enregistrer=handles.volumes.donnees(:,:,:,t);
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
    afficher_graphique(hObject, eventdata, handles);
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