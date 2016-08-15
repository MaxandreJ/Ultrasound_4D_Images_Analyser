% --- Executes on button press in selection_region_interet.
function selectionner_manuellement_region_interet(hObject, eventdata, handles)
% hObject    handle to selection_region_interet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%handles.ss_echantillonnage_effectue = false;
%handles.volumes.methode_trace_ROI = 'coordonnees';

%tracer_rectangle(hObject, eventdata, handles)

%guidata(hObject, handles);
Region_interet.suppression_precedent(handles);
handles = guidata(handles.figure1);

region_interet = Region_interet_rectangle;

region_interet.obtenir_coordonnees(handles);

region_interet.enregistrer(handles);

region_interet.afficher_region(handles);
handles = guidata(handles.figure1);
region_interet.mettre_a_jour_IHM(handles);
handles = guidata(handles.figure1);

handles.region_interet = region_interet;
guidata(handles.figure1,handles);
