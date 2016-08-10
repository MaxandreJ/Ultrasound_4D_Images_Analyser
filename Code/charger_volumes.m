% --- Executes on button press in chargement.
function charger_volumes(hObject, eventdata, handles)
% hObject    handle to chargement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cla(handles.affichage_graphique);

choix_chargement = get(handles.choix_chargement,'Value');

format_bin = 1;
format_mat = 2;

if choix_chargement==format_bin
    volumes = Volumes_RawData_bin;
elseif choix_chargement==format_mat
    volumes = Volumes_mat;
end

volumes.charger;

volumes.afficher_chemin(handles);
handles=guidata(handles.figure1);

volumes.afficher_image(handles);
handles=guidata(handles.figure1);
handles.volumes = volumes;

set(handles.choix_du_pic,'String',' ');
set(handles.lmh_affichage,'String',[]);
set(handles.lmh_affichage,'String',[]);
set(handles.choix_de_deux_pics,'String',' ');
set(handles.dpap_affichage,'String',[]);
set(handles.valeur_axe1Debut_graphique,'String',[]);
set(handles.valeur_axe2Debut_graphique,'String',[]);
set(handles.valeur_axe1Fin_graphique,'String',[]);
set(handles.valeur_axe2Fin_graphique,'String',[]);

set(handles.valeur_axe3_image,'enable','on','BackgroundColor','white','String','1');
set(handles.valeur_axe4_image,'enable','on','BackgroundColor','white','String','1');



guidata(handles.figure1, handles);
%afficher_image(hObject, eventdata, handles);

