function selectionner_visuellement_region(hObject, eventdata, handles)
Region_interet.suppression_precedent(handles);
handles = guidata(handles.figure1);

region_interet = handles.region_interet;
region_interet.tracer(handles);

region_interet.enregistrer(handles);

region_interet.afficher_coordonnees(handles);
handles = guidata(handles.figure1);
region_interet.afficher_region(handles);
handles = guidata(handles.figure1);
region_interet.mettre_a_jour_IHM(handles);
handles = guidata(handles.figure1);

handles.region_interet = region_interet;
guidata(handles.figure1,handles);

end

