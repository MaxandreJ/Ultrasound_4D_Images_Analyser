% --- Executes on button press in afficher_graphique.
function afficher_graphique(hObject, eventdata, handles)
% hObject    handle to afficher_graphique (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

graphique = Graphique(handles);

graphique.afficher(handles);
handles = guidata(handles.figure1);
handles.graphique=graphique;

guidata(handles.figure1,handles);