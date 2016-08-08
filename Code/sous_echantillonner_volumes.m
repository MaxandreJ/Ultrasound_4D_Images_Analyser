% --- Executes on button press in sous_echantillonnage.
function sous_echantillonner_volumes(hObject, eventdata, handles)
% hObject    handle to sous_echantillonnage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
graphique = handles.graphique;

sous_echantillonnage = Sous_echantillonnage;

sous_echantillonnage.sous_echantillonner(handles);

handles.sous_echantillonnage = sous_echantillonnage;

guidata(handles.figure1,handles);

sous_echantillonnage.sauvegarder(handles);

graphique.afficher_resultat_sous_echantillonnage(handles);