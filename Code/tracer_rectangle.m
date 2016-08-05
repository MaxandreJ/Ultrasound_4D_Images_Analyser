% --------------------------------------------------------------------
function tracer_rectangle(hObject, eventdata, handles)
% hObject    handle to Rectangle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles,'rectangle_trace')
    delete(handles.rectangle_trace);
end

if isfield(handles,'polygone_trace')
    delete(handles.polygone_trace);
end

try
    set(handles.figure1,'KeyPressFcn','')
    objet_rectangle = imrect;
    if isempty(objet_rectangle)
        erreur_ROI_pas_choisi.message = 'La région d''intérêt n''a pas été délimitée avant le changement de vue.';
        erreur_ROI_pas_choisi.identifier = 'Rectangle_Callback:ROI_pas_choisi';
        error(erreur_ROI_pas_choisi);
    end
    position_rectangle = getPosition(objet_rectangle);
    valeur_axe1Debut_graphique=position_rectangle(1);
    valeur_axe2Debut_graphique=position_rectangle(2);
    largeur_axe1=position_rectangle(3);
    hauteur_axe2=position_rectangle(4);
    valeur_axe1Fin_graphique = valeur_axe1Debut_graphique + largeur_axe1;
    valeur_axe2Fin_graphique = valeur_axe2Debut_graphique + hauteur_axe2;

    %On arrondit les valeurs des coordonnées sélectionnées
    valeur_axe1Debut_graphique=int16(round(valeur_axe1Debut_graphique));
    valeur_axe2Debut_graphique=int16(round(valeur_axe2Debut_graphique));
    valeur_axe1Fin_graphique=int16(round(valeur_axe1Fin_graphique));
    valeur_axe2Fin_graphique=int16(round(valeur_axe2Fin_graphique));

    set(handles.valeur_axe1Debut_graphique,'Value',valeur_axe1Debut_graphique,'String',num2str(valeur_axe1Debut_graphique));
    set(handles.valeur_axe2Debut_graphique,'Value',valeur_axe2Debut_graphique,'String',num2str(valeur_axe2Debut_graphique));
    set(handles.valeur_axe1Fin_graphique,'Value',valeur_axe1Fin_graphique,'String',num2str(valeur_axe1Fin_graphique));
    set(handles.valeur_axe2Fin_graphique,'Value',valeur_axe2Fin_graphique,'String',num2str(valeur_axe2Fin_graphique));

    handles.rectangle_trace = rectangle('Position',[valeur_axe1Debut_graphique valeur_axe2Debut_graphique largeur_axe1 hauteur_axe2],'EdgeColor','r');

    delete(objet_rectangle);

    handles.choix_forme_ROI = 'rectangle';
    guidata(hObject,handles);
    selectionner_region_interet(hObject, eventdata, handles)
catch erreurs
    if (strcmp(erreurs.identifier,'Rectangle_Callback:ROI_pas_choisi'))
        causeException = MException(erreur_ROI_pas_choisi.identifier,erreur_ROI_pas_choisi.message);
        erreurs = addCause(erreurs,causeException);
    else
        rethrow(erreurs);
    end
end
set(handles.figure1,'KeyPressFcn',{@clavier,handles})