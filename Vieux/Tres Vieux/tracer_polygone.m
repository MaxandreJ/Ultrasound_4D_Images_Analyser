% --------------------------------------------------------------------
function tracer_polygone(hObject, eventdata, handles)
% hObject    handle to polygone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Region_interet.suppression_precedent(handles);
handles = guidata(handles.figure1);
region_interet = Region_interet_polygone;
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

% cla(handles.affichage_graphique,'reset'); %Efface le graphique précédent
% cla(handles.image.Children);
% 
% if isfield(handles,'rectangle_trace')
%     delete(handles.rectangle_trace);
% end
% 
% if isfield(handles,'polygone_trace')
%     delete(handles.polygone_trace);
% end
% 
% try
%     volumes = handles.volumes;
%     volumes_ROI= volumes.donnees;
%     taille_axes = volumes.taille_axes_enregistree;
%     
%     set(handles.figure1,'KeyPressFcn','')
%     axes(handles.image);
%     polygone=impoly;
%     if isempty(polygone)
%         erreur_ROI_pas_choisi.message = 'La région d''intérêt n''a pas été délimitée avant le changement de vue.';
%         erreur_ROI_pas_choisi.identifier = 'polygone_Callback:ROI_pas_choisi';
%         error(erreur_ROI_pas_choisi);
%     end
%     masque_binaire_2D=polygone.createMask();
%     %Comme l'image est en coordonnées "indices de matrice"
%     masque_binaire_2D=masque_binaire_2D';
%     masque_binaire_4D = repmat(masque_binaire_2D,1,1,taille_axes(3),taille_axes(4));
%     volumes_ROI(masque_binaire_4D==0) = NaN;
%     handles.volumes.donnees_ROI = volumes_ROI; 
%     
% 
% 
%     positions_polygone=getPosition(polygone);
%     nb_positions_polygone = size(positions_polygone,1);
%     maximum_axe1=taille_axes(1);
%     maximum_axe2=taille_axes(2);
%     for i=1:nb_positions_polygone
%         X_pos_i=positions_polygone(i,1);
%         Y_pos_i=positions_polygone(i,2);
%         if X_pos_i<1 || X_pos_i>maximum_axe1 || Y_pos_i<1 || Y_pos_i>maximum_axe2
%             erreur_sortie_de_image.message = 'La région d''intérêt dépasse de l''image.';
%             erreur_sortie_de_image.identifier = 'polygone_Callback:sortie_de_image';
%             error(erreur_sortie_de_image);
%         end
%     end
%     ordre_des_points=1:nb_positions_polygone;
%     polygone_trace=patch('Faces',ordre_des_points,'Vertices',positions_polygone,'FaceColor','none','EdgeColor','red');
%     handles.polygone_trace=polygone_trace;
%     delete(polygone);
%     handles.volumes.choix_forme_ROI='polygone';
%     
%     set(handles.moyenne_axe1et2,'Value',1);
%     set(handles.moyenne_axe1,'Visible','off');
%     set(handles.moyenne_axe2,'Visible','off');
%     set(handles.pas_de_moyenne,'Visible','off');
% 
%     set(handles.abscisses_axe4,'Value',1);
%     set(handles.abscisses_axe1,'Visible','off');
%     set(handles.abscisses_axe2,'Visible','off');
%     
%     set(handles.affichage_entropie,'BackgroundColor','white');
% 
%     guidata(handles.figure1,handles);
% catch erreurs
%     if (strcmp(erreurs.identifier,'polygone_Callback:ROI_pas_choisi'))
%         causeException = MException(erreur_ROI_pas_choisi.identifier,erreur_ROI_pas_choisi.message);
%         erreurs = addCause(erreurs,causeException);
%     elseif (strcmp(erreurs.identifier,'polygone_Callback:sortie_de_image'))
%         warndlg('Merci d''entrer une région d''intérêt incluse dans l''image.');
%         causeException = MException(erreur_sortie_de_image.identifier,erreur_sortie_de_image.message);
%         erreurs = addCause(erreurs,causeException);
%         delete(polygone);
%     else
%         rethrow(erreurs);
%     end
% end
% set(handles.figure1,'KeyPressFcn',{@clavier,handles})