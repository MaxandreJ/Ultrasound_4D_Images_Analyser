% --- Executes on button press in heterogeneite.
function calculer_heterogeneite(hObject, eventdata, handles)
% hObject    handle to heterogeneite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Pour utilisation de l'entropie l'image doit avoir 256 niveaux
image_ROI=handles.volumes.image_ROI;
image_ROI=image_ROI(~isnan(image_ROI));
image_ROI_8bits=uint8(image_ROI);
entropie_region_interet=entropy(image_ROI_8bits);
set(handles.affichage_entropie,'String',num2str(entropie_region_interet));

guidata(handles.figure1,handles);
