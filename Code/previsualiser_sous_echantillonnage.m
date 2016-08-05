% --- Executes on button press in previsualisation_sous_echantillonnage.
function previsualiser_sous_echantillonnage(hObject, eventdata, handles)
% hObject    handle to previsualisation_sous_echantillonnage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.sauvegarde_sous_echantillonnage = false;
sous_echantillonner_volumes(hObject, eventdata, handles);
handles = guidata(hObject);
handles.sauvegarde_sous_echantillonnage = true;
guidata(handles.figure1,handles);