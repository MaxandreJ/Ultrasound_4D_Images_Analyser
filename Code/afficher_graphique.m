% --- Executes on button press in afficher_graphique.
function afficher_graphique(hObject, eventdata, handles)
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