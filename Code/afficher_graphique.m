% --- Executes on button press in afficher_graphique.
function afficher_graphique(hObject, eventdata, handles)
% hObject    handle to afficher_graphique (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

graphique = Graphique(handles);

graphique.charger_donnees(handles);

graphique.afficher_courbe(handles);

% graphique.a_une_seule_courbe(handles);

% title(graphique.titre);

graphique.afficher_titre(handles);

graphique.afficher_legende_abscisses(handles);

graphique.afficher_legende_ordonnees(handles);

% graphique.donner_legende_ordonnees(handles);
% 
% ylabel(graphique.legende_ordonnees);

%graphique.donner_legende_abscisses(handles);

%xlabel(graphique.legende_abscisses);

handles.graphique=graphique;

set(handles.choix_du_pic,'enable','on','BackgroundColor','white');
set(handles.choix_de_deux_pics,'enable','on','BackgroundColor','white');
set(handles.lmh_affichage,'BackgroundColor','white');
set(handles.dpap_affichage,'BackgroundColor','white');
set(handles.valeur_taille_fenetre_lissage,'enable','on','BackgroundColor','white');
set(handles.valeur_nombre_de_pics,'enable','on','BackgroundColor','white');

guidata(handles.figure1,handles);