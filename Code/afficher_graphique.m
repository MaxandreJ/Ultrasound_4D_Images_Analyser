% --- Executes on button press in afficher_graphique.
function afficher_graphique(hObject, eventdata, handles)
% hObject    handle to afficher_graphique (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cla(handles.affichage_graphique);

texte_legende_abscisses_graphique={'X (en pixels)','Y (en pixels)','Z (en pixels)','Temps (en pas de temps)'};
noms_axes=['X','Y','Z','Temps'];

coordonnee_axe3 = int16(str2double(get(handles.valeur_axe3_image,'String')));
coordonnee_axe4 = int16(str2double(get(handles.valeur_axe4_image,'String')));
graphique_selon_axe1 = get(handles.graphique_selon_axe1,'Value');
graphique_selon_axe2 = get(handles.graphique_selon_axe2,'Value');
graphique_selon_axe3 = get(handles.graphique_selon_axe3,'Value');
graphique_selon_axe4 = get(handles.graphique_selon_axe4,'Value');

points_de_donnees = get(handles.points_de_donnees,'Value');

volumes = handles.volumes;

volumes_ROI=volumes.donnees_ROI;
image_ROI=volumes.image_ROI;
taille_axes=volumes.taille_axes_enregistree;
ordre_axes=volumes.ordre_axes;

coordonnee_axe1_debut_ROI = volumes.coordonnee_axe1_debut_ROI;
coordonnee_axe2_debut_ROI = volumes.coordonnee_axe2_debut_ROI;
coordonnee_axe1_fin_ROI = volumes.coordonnee_axe1_fin_ROI;
coordonnee_axe2_fin_ROI = volumes.coordonnee_axe2_fin_ROI;

coordonnees_axe1_distinctes = volumes.coordonnees_axe1_distinctes;
coordonnees_axe2_distinctes = volumes.coordonnees_axe2_distinctes;

moyenne_axe1 = get(handles.moyenne_axe1,'Value');
moyenne_axe2 = get(handles.moyenne_axe2,'Value');
moyenne_axe1et2 = get(handles.moyenne_axe1et2,'Value');
pas_de_moyenne = get(handles.pas_de_moyenne,'Value');

axes(handles.affichage_graphique);
if moyenne_axe1
    image_ROI = mean(image_ROI,1);
    %Enlever les dimensions inutiles laissées par la moyenne
    image_ROI = squeeze(image_ROI);
    axe_moyenne_choisi='1';
elseif moyenne_axe2
    image_ROI = mean(image_ROI,2);
    %Pour avoir toujours des données en ligne
    image_ROI = image_ROI';
    %Enlever les dimensions inutiles laissées par la moyenne
    image_ROI = squeeze(image_ROI);
    %handles.courbes_ROI=image_ROI;
    axe_moyenne_choisi='2';
elseif moyenne_axe1et2
    volumes_ROI=nanmean(nanmean(volumes_ROI,1),2);
    %Enlever les dimensions inutiles laissées par les moyennes
    volumes_ROI=squeeze(volumes_ROI);
    axe_moyenne_choisi='1 et 2';
elseif pas_de_moyenne
    axe_moyenne_choisi='pas de moyenne';
end

%Problème coordonnées cartésiennes/matrice ici
if graphique_selon_axe1
    abscisses = int16(coordonnee_axe1_debut_ROI):int16(coordonnee_axe1_fin_ROI);
    ordonnees = image_ROI ;
    axe_abscisses_choisi=1;
    xlabel(texte_legende_abscisses_graphique(ordre_axes(1)));
elseif graphique_selon_axe2
    abscisses = int16(coordonnee_axe2_debut_ROI):int16(coordonnee_axe2_fin_ROI);
    ordonnees = image_ROI';
    axe_abscisses_choisi=2;
    xlabel(texte_legende_abscisses_graphique(ordre_axes(2)));
elseif graphique_selon_axe3
    ordonnees = volumes_ROI(:,coordonnee_axe4);
    abscisses = 1:int16(taille_axes(3));
    axe_abscisses_choisi=3;
    xlabel(texte_legende_abscisses_graphique(ordre_axes(3)));
elseif graphique_selon_axe4
    ordonnees = volumes_ROI(coordonnee_axe3,:);
    abscisses = 1:int16(taille_axes(4));
    axe_abscisses_choisi=4;
    xlabel(texte_legende_abscisses_graphique(ordre_axes(4)));
end

handles.graphique = Graphique(abscisses,ordonnees,axe_abscisses_choisi,axe_moyenne_choisi);

hold on
plot(abscisses,ordonnees,'displayname','Courbe originale','HitTest', 'off');

if points_de_donnees && ~handles.ss_echantillonnage_effectue
    plot(abscisses,ordonnees,'black+','displayname','Point de données','HitTest', 'off');
end


if handles.ss_echantillonnage_effectue
    vecteur_t_ech_normal = handles.vecteur_t_ech_normal;
    vecteur_t_ssech = handles.vecteur_t_ssech;
    handles.points_ech_normal = plot(vecteur_t_ech_normal,ordonnees(vecteur_t_ech_normal),'black+','displayname','Echantillonnage normal','HitTest', 'off');
    handles.points_ssech_normal = plot(vecteur_t_ssech,ordonnees(vecteur_t_ssech),'red+','displayname','Sous-échantillonnage','HitTest', 'off');
    legend([handles.points_ech_normal,handles.points_ssech_normal]);
end
hold off


if strcmp(handles.volumes.choix_forme_ROI,'rectangle');
    ligne = xor(coordonnees_axe1_distinctes,coordonnees_axe2_distinctes);
else
    ligne = false;
end

handles.une_seule_courbe = ligne || moyenne_axe1 || moyenne_axe2 || moyenne_axe1et2;

if handles.une_seule_courbe
    title('Courbe d''intensité');
else
    title('Courbes d''intensité');
end

switch axe_moyenne_choisi
    case '1'
        ylabel({'Intensité (en niveaux)',...
    ['moyennée sur ',noms_axes(ordre_axes(1)),' dans la région d''intérêt']});
    case '2'
        ylabel({'Intensité (en niveaux)',...
    ['moyennée sur ',noms_axes(ordre_axes(2)),' dans la région d''intérêt']});
    case '1 et 2'
        ylabel({'Intensité (en niveaux)',...
    ['moyennée sur ',noms_axes(ordre_axes(1)),' et ',noms_axes(ordre_axes(2))],...
    ' dans la région d''intérêt'});
    case 'pas de moyenne'
        ylabel('Intensité (en niveaux)');
end
 

set(handles.choix_du_pic,'enable','on','BackgroundColor','white');
set(handles.choix_de_deux_pics,'enable','on','BackgroundColor','white');
set(handles.lmh_affichage,'BackgroundColor','white');
set(handles.dpap_affichage,'BackgroundColor','white');
set(handles.valeur_taille_fenetre_lissage,'enable','on','BackgroundColor','white');
set(handles.valeur_nombre_de_pics,'enable','on','BackgroundColor','white');
guidata(handles.figure1,handles);