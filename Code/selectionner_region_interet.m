% --- Executes on button press in selection_region_interet.
function selectionner_region_interet(hObject, eventdata, handles)
% hObject    handle to selection_region_interet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
choix_ROI_rectangle=strcmp(handles.volumes.choix_forme_ROI,'rectangle');
choix_ROI_polygone=strcmp(handles.volumes.choix_forme_ROI,'polygone');

coordonnee_axe3 = int16(str2double(get(handles.valeur_axe3_image,'String')));
coordonnee_axe4 = int16(str2double(get(handles.valeur_axe4_image,'String')));

handles.choix_ROI_polygone = choix_ROI_polygone;
handles.ss_echantillonnage_effectue = false;

try
    cla(handles.affichage_graphique,'reset'); %Efface le graphique précédent
    cla(handles.image.Children);
    
    handles.volumes.coordonnee_axe3_selectionnee=coordonnee_axe3;
    handles.volumes.coordonnee_axe4_selectionnee=coordonnee_axe4;
    
    if choix_ROI_rectangle
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
    rethrow(erreurs);
end
