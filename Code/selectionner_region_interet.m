% --- Executes on button press in selection_region_interet.
function selectionner_region_interet(hObject, eventdata, handles)
% hObject    handle to selection_region_interet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%handles.ss_echantillonnage_effectue = false;
handles.volumes.methode_trace_ROI = 'coordonnees';

tracer_rectangle(hObject, eventdata, handles)

guidata(hObject, handles);
