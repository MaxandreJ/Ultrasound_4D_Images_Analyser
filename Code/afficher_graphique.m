% --- Executes on button press in afficher_graphique.
function afficher_graphique(hObject, eventdata, handles)
% hObject    handle to afficher_graphique (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cla(handles.affichage_graphique);

coordonnee_axe3 = int16(str2double(get(handles.valeur_axe3_image,'String')));
coordonnee_axe4 = int16(str2double(get(handles.valeur_axe4_image,'String')));
graphique_selon_axe1 = get(handles.graphique_selon_axe1,'Value');
graphique_selon_axe2 = get(handles.graphique_selon_axe2,'Value');
graphique_selon_axe3 = get(handles.graphique_selon_axe3,'Value');
graphique_selon_axe4 = get(handles.graphique_selon_axe4,'Value');

points_de_donnees = get(handles.points_de_donnees,'Value');

volumes_ROI=handles.volumes.donnees_ROI;
image_ROI=handles.volumes.image_ROI;
taille_axes=handles.volumes.taille_axes;
ordre_axes=handles.volumes.ordre_axes;
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

axes(handles.affichage_graphique);
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
end




%Problème coordonnées cartésiennes/matrice ici
if graphique_selon_axe1
    abscisses = int16(valeur_axe1Debut_graphique):int16(valeur_axe1Fin_graphique);
    ordonnees = image_ROI ;
    xlabel(legende_abscisse_graphique(ordre_axes(1)));
elseif graphique_selon_axe2
    abscisses = int16(valeur_axe2Debut_graphique):int16(valeur_axe2Fin_graphique);
    ordonnees = image_ROI';
    xlabel(legende_abscisse_graphique(ordre_axes(2)));
    handles.abscisse_courbe_ROI=int16(valeur_axe2Debut_graphique):int16(valeur_axe2Fin_graphique);
elseif graphique_selon_axe3
    ordonnees = volumes_ROI(:,coordonnee_axe4);
    abscisses = 1:int16(taille_axes(3));
    xlabel(legende_abscisse_graphique(ordre_axes(3)));
elseif graphique_selon_axe4
    ordonnees = volumes_ROI(coordonnee_axe3,:);
    abscisses = 1:int16(taille_axes(4));
    xlabel(legende_abscisse_graphique(ordre_axes(4)));
end

handles.graphique = Graphique(abscisses,ordonnees);

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