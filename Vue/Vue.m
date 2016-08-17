classdef Vue < handle
    properties
        ihm
        modele
        controleur
    end
    
    methods
        function soi = Vue(controleur)
            soi.controleur = controleur;
            soi.modele = controleur.modele;
            soi.ihm = Ultrasound_4D_Images_Analyser_for_Aplio500_ToshibaMS('controleur',soi.controleur);
           
            
            addlistener(soi.modele,'image','PostSet', ...
                @(src,evnt)Vue.handlePropEvents(soi,src,evnt));
            addlistener(soi.modele,'chemin_donnees','PostSet', ...
                @(src,evnt)Vue.handlePropEvents(soi,src,evnt));
            addlistener(soi.modele,'donnees_region_interet','PostSet', ...
                @(src,evnt)Vue.handlePropEvents(soi,src,evnt));
            addlistener(soi.modele,'entropie_region_interet','PostSet', ...
                @(src,evnt)Vue.handlePropEvents(soi,src,evnt));
            addlistener(soi.modele,'ordonnees_graphique','PostSet', ...
                @(src,evnt)Vue.handlePropEvents(soi,src,evnt));
            addlistener(soi.modele,'largeur_a_mi_hauteur_pic_choisi','PostSet', ...
                @(src,evnt)Vue.handlePropEvents(soi,src,evnt));
            addlistener(soi.modele,'distance_pic_a_pic_choisie','PostSet', ...
                @(src,evnt)Vue.handlePropEvents(soi,src,evnt));
            addlistener(soi.modele,'vecteur_temps_sous_echantillonnage','PostSet', ...
                @(src,evnt)Vue.handlePropEvents(soi,src,evnt));
            addlistener(soi.modele,'chemin_enregistrement_export_graphique','PostSet', ...
                @(src,evnt)Vue.handlePropEvents(soi,src,evnt));
            addlistener(soi.modele,'chemin_enregistrement_export_image','PostSet', ...
                @(src,evnt)Vue.handlePropEvents(soi,src,evnt));
            
        end
    end
    
    methods (Static)
        function handlePropEvents(obj,src,evnt)
            evntobj = evnt.AffectedObject;
            handles = guidata(obj.ihm);
            switch src.Name
                case 'image'
                    axes(handles.image);
                    imzobr=evntobj.image';
                    iptsetpref('ImshowAxesVisible','on');
                    imshow(imzobr);
                    set(handles.image.Children,'CDataMapping','direct');
                    uicontextmenu = get(handles.image,'UIContextMenu');
                    set(handles.image.Children,'UIContextMenu',uicontextmenu);
                    
                    switch evntobj.volumes.vue_choisie
                        case 0
                            axe1='X';
                            axe2='Y';
                            axe3='Z';
                            axe4='Temps';
                            title({'Plan axial', [axe3 '=' num2str(evntobj.volumes.coordonnee_axe3_selectionnee) '/' num2str(evntobj.volumes.taille_axes(3)) ', ' axe4 '=' num2str(evntobj.volumes.coordonnee_axe4_selectionnee) '/' num2str(evntobj.volumes.taille_axes(4))]});
                        case 1
                            axe1='X';
                            axe2='Z';
                            axe3='Y';
                            axe4='Temps';
                            title({'Plan latéral',[axe3 '=' num2str(evntobj.volumes.coordonnee_axe3_selectionnee) '/' num2str(evntobj.volumes.taille_axes(3)) ', ' axe4 '=' num2str(evntobj.volumes.coordonnee_axe4_selectionnee) '/' num2str(evntobj.volumes.taille_axes(4))]});
                        case 2
                            axe1='Y';
                            axe2='Z';
                            axe3='X';
                            axe4='Temps';
                            title({'Plan transverse', [axe3 '=' num2str(evntobj.volumes.coordonnee_axe3_selectionnee) '/' num2str(evntobj.volumes.taille_axes(3)) ', ' axe4 '=' num2str(evntobj.volumes.coordonnee_axe4_selectionnee) '/' num2str(evntobj.volumes.taille_axes(4))]});
                        case 3
                            axe1='Temps';
                            axe2='X';
                            axe3='Z';
                            axe4='Y';
                            title({'Plan X-Temps', [axe3 '=' num2str(evntobj.volumes.coordonnee_axe3_selectionnee) '/' num2str(evntobj.volumes.taille_axes(3)) ', ' axe4 '=' num2str(evntobj.volumes.coordonnee_axe4_selectionnee) '/' num2str(evntobj.volumes.taille_axes(4))]});
                        case 4
                            axe1='Temps';
                            axe2='Y';
                            axe3='Z';
                            axe4='X';
                            title({'Plan Y-Temps', [axe3 '=' num2str(evntobj.volumes.coordonnee_axe3_selectionnee) '/' num2str(evntobj.volumes.taille_axes(3)) ', ' axe4 '=' num2str(evntobj.volumes.coordonnee_axe4_selectionnee) '/' num2str(evntobj.volumes.taille_axes(4))]});
                        case 5
                            axe1='Temps';
                            axe2='Z';
                            axe3='Y';
                            axe4='X';
                            title({'Plan Z-Temps', [axe3 '=' num2str(evntobj.volumes.coordonnee_axe3_selectionnee) '/' num2str(evntobj.volumes.taille_axes(3)) ', ' axe4 '=' num2str(evntobj.volumes.coordonnee_axe4_selectionnee) '/' num2str(evntobj.volumes.taille_axes(4))]});
                    end;
                    if strcmp(axe1,'Temps')
                        xlabel([axe1,' (en pas de temps)']);
                    else
                        xlabel([axe1,' (en pixels)']);
                    end
                    ylabel([axe2, ' (en pixels)']);
                    
                    set(handles.choix_du_pic,'String',' ');
                    set(handles.lmh_affichage,'String',[]);
                    set(handles.choix_de_deux_pics,'String',' ');
                    set(handles.dpap_affichage,'String',[]);
                    set(handles.valeur_axe1Debut_graphique,'String',[],'enable','on','BackgroundColor','white');
                    set(handles.valeur_axe2Debut_graphique,'String',[],'enable','on','BackgroundColor','white');
                    set(handles.valeur_axe1Fin_graphique,'String',[],'enable','on','BackgroundColor','white');
                    set(handles.valeur_axe2Fin_graphique,'String',[],'enable','on','BackgroundColor','white');
                    set(handles.valeur_axe3_image,'String',evntobj.volumes.coordonnee_axe3_selectionnee,'enable','on','BackgroundColor','white');
                    set(handles.valeur_axe4_image,'String',evntobj.volumes.coordonnee_axe4_selectionnee,'enable','on','BackgroundColor','white');
                    set(handles.axe1_graphique,'String',axe1);
                    set(handles.axe2_graphique,'String',axe2);
                    set(handles.abscisses_axe1,'String',axe1);
                    set(handles.abscisses_axe2,'String',axe2);
                    set(handles.abscisses_axe3,'String',axe3);
                    set(handles.abscisses_axe4,'String',axe4);
                    set(handles.moyenne_axe1,'String',axe1);
                    set(handles.moyenne_axe2,'String',axe2);
                    set(handles.moyenne_axe1et2,'String',[axe1, ' et ', axe2]);
                    set(handles.texte_axe3_image,'String',axe3);
                    set(handles.texte_axe4_image,'String',axe4);
                    set(handles.maximum_axe1_1,'String',['/',num2str(evntobj.volumes.taille_axes(1))]);
                    set(handles.maximum_axe1_2,'String',['/',num2str(evntobj.volumes.taille_axes(1))]);
                    set(handles.maximum_axe2_1,'String',['/',num2str(evntobj.volumes.taille_axes(2))]);
                    set(handles.maximum_axe2_2,'String',['/',num2str(evntobj.volumes.taille_axes(2))]);
                    set(handles.total_axe3_image,'String',['sur ', num2str(evntobj.volumes.taille_axes(3))]);
                    set(handles.total_axe4_image,'String',['sur ', num2str(evntobj.volumes.taille_axes(4))]);
                    set(handles.valeur_axe1Debut_graphique,'enable','on','BackgroundColor','white');
                    set(handles.valeur_axe2Debut_graphique,'enable','on','BackgroundColor','white');
                    set(handles.valeur_axe1Fin_graphique,'enable','on','BackgroundColor','white');
                    set(handles.valeur_axe2Fin_graphique,'enable','on','BackgroundColor','white');
                case 'chemin_donnees'
                    set(handles.chemin_dossier,'String',evntobj.chemin_donnees);
                case 'donnees_region_interet'
                    cla(handles.affichage_graphique,'reset'); %Efface le graphique précédent
                    cla(handles.image.Children);

                    if isfield(handles,'rectangle_trace')
                        delete(handles.rectangle_trace);
                    end

                    if isfield(handles,'polygone_trace')
                        delete(handles.polygone_trace);
                    end
                    
                    axes(handles.image);
                    
                    if isa(evntobj.region_interet,'Region_interet_rectangle')
                        set(handles.valeur_axe1Debut_graphique,'String',...
                            num2str(evntobj.region_interet.coordonnee_axe1_debut));
                        set(handles.valeur_axe2Debut_graphique,'String',...
                            num2str(evntobj.region_interet.coordonnee_axe2_debut));
                        set(handles.valeur_axe1Fin_graphique,'String',...
                            num2str(evntobj.region_interet.coordonnee_axe1_fin));
                        set(handles.valeur_axe2Fin_graphique,'String',...
                            num2str(evntobj.region_interet.coordonnee_axe2_fin)); 
                        
                        handles.rectangle_trace = rectangle('Position',...
                            [evntobj.region_interet.coordonnee_axe1_debut...
                            evntobj.region_interet.coordonnee_axe2_debut...
                            evntobj.region_interet.largeur_axe1...
                            evntobj.region_interet.hauteur_axe2],'EdgeColor','r');
                        
                        set(handles.moyenne_axe1,'Visible','on');
                        set(handles.moyenne_axe2,'Visible','on');
                        set(handles.pas_de_moyenne,'Visible','on');
                        set(handles.abscisses_axe1,'Visible','on');
                        set(handles.abscisses_axe2,'Visible','on');
                    elseif isa(evntobj.region_interet,'Region_interet_polygone')
                        try
                            taille_axes = evntobj.volumes.taille_axes;
                            positions_polygone=getPosition(evntobj.region_interet.polygone);
                            nb_positions_polygone = size(positions_polygone,1);
                            maximum_axe1=taille_axes(1);
                            maximum_axe2=taille_axes(2);
                            for i=1:nb_positions_polygone
                                X_pos_i=positions_polygone(i,1);
                                Y_pos_i=positions_polygone(i,2);
                                if X_pos_i<1 || X_pos_i>maximum_axe1 || Y_pos_i<1 || Y_pos_i>maximum_axe2
                                    erreur_sortie_de_image.message = 'La région d''intérêt dépasse de l''image.';
                                    erreur_sortie_de_image.identifier = 'polygone_Callback:sortie_de_image';
                                    error(erreur_sortie_de_image);
                                end
                            end
                            ordre_des_points=1:nb_positions_polygone;
                            polygone_trace=patch('Faces',ordre_des_points,'Vertices',positions_polygone,'FaceColor','none','EdgeColor','red');
                            handles.polygone_trace=polygone_trace;
                            delete(evntobj.region_interet.polygone);
                         catch erreurs
                            if (strcmp(erreurs.identifier,'polygone_Callback:sortie_de_image'))
                                warndlg('Merci d''entrer une région d''intérêt incluse dans l''image.');
                                causeException = MException(erreur_sortie_de_image.identifier,erreur_sortie_de_image.message);
                                erreurs = addCause(erreurs,causeException);
                                delete(evntobj.region_interet.polygone);
                            end
                            rethrow(erreurs);
                        end
                         
                        set(handles.moyenne_axe1et2,'Value',1);
                        set(handles.moyenne_axe1,'Visible','off');
                        set(handles.moyenne_axe2,'Visible','off');
                        set(handles.pas_de_moyenne,'Visible','off');

                        set(handles.abscisses_axe4,'Value',1);
                        set(handles.abscisses_axe1,'Visible','off');
                        set(handles.abscisses_axe2,'Visible','off');  
                    end
                    
                        set(handles.affichage_entropie,'BackgroundColor','white','String',[]);
                case 'entropie_region_interet'
                    set(handles.affichage_entropie,'String',num2str(evntobj.entropie_region_interet));
                case 'ordonnees_graphique'
                    %%Afficher les courbes
                    cla(handles.affichage_graphique);
                    axes(handles.affichage_graphique);
                    hold on
                    plot(evntobj.graphique.abscisses,evntobj.graphique.ordonnees,'displayname','Courbe originale','HitTest', 'off');
                    if get(handles.points_de_donnees,'Value')
                        plot(evntobj.graphique.abscisses,evntobj.graphique.ordonnees,'black+','displayname','Point de données','HitTest', 'off');
                    end
                    hold off
                    
                    %%Afficher le titre
                   
                    %Selon le nombre de courbes, on affiche le titre
                    if evntobj.graphique.une_seule_courbe
                        titre='Courbe d''intensité';
                    else
                        titre='Courbes d''intensité';
                    end
                    
                    title(titre);
                    
                    %%On affiche la légende des abscisses
                    
                    ordre_axes=evntobj.volumes.ordre_axes;
                    
                    switch evntobj.graphique.axe_abscisses_choisi
                          case 1
                              legende_abscisses = evntobj.graphique.noms_axes_legende_abscisses(ordre_axes(1));
                          case 2
                              legende_abscisses = evntobj.graphique.noms_axes_legende_abscisses(ordre_axes(2));
                          case 3
                              legende_abscisses = evntobj.graphique.noms_axes_legende_abscisses(ordre_axes(3));
                          case 4
                              legende_abscisses = evntobj.graphique.noms_axes_legende_abscisses(ordre_axes(4));
                    end
                    
                    xlabel(legende_abscisses);
                    
                    %%On affiche la légende des ordonnees
                    
                    switch evntobj.graphique.axe_moyenne_choisi
                        case '1'
                            legende_ordonnees={'Intensité (en niveaux)',...
                        ['moyennée sur ',evntobj.graphique.noms_axes(ordre_axes(1)),' dans la région d''intérêt']};
                        case '2'
                            legende_ordonnees={'Intensité (en niveaux)',...
                        ['moyennée sur ',evntobj.graphique.noms_axes(ordre_axes(2)),' dans la région d''intérêt']};
                        case '1 et 2'
                            legende_ordonnees={'Intensité (en niveaux)',...
                        ['moyennée sur ',evntobj.graphique.noms_axes(ordre_axes(1)),' et ',evntobj.graphique.noms_axes(ordre_axes(2))],...
                        ' dans la région d''intérêt'};
                        case 'pas de moyenne'
                            legende_ordonnees='Intensité (en niveaux)';
                    end
                     
                    ylabel(legende_ordonnees);
                    
                    %%On indique les nouvelles fonctionnalités disponibles dans l'IHM
                    
                    set(handles.choix_du_pic,'enable','on','BackgroundColor','white');
                    set(handles.choix_de_deux_pics,'enable','on','BackgroundColor','white');
                    set(handles.lmh_affichage,'BackgroundColor','white');
                    set(handles.dpap_affichage,'BackgroundColor','white');
                    set(handles.valeur_taille_fenetre_lissage,'enable','on','BackgroundColor','white');
                    set(handles.valeur_nombre_de_pics,'enable','on','BackgroundColor','white');
                case 'largeur_a_mi_hauteur_pic_choisi'
                    set(handles.choix_du_pic,'String',evntobj.graphique.pics.liste);
                    set(handles.lmh_affichage,'String', evntobj.largeur_a_mi_hauteur_pic_choisi);
                    
                    %% Montrer que l'on peut sous-échantillonner les données
                    set(handles.facteur_temps_I_max,'Enable','on','BackgroundColor','white');
                    set(handles.facteur_sous_echantillonnage,'Enable','on','BackgroundColor','white');
                case 'distance_pic_a_pic_choisie'
                    set(handles.choix_de_deux_pics,'String',evntobj.graphique.pics.liste_combinaisons_de_deux_pics);
                    set(handles.dpap_affichage,'String',evntobj.distance_pic_a_pic_choisie);
                case 'vecteur_temps_sous_echantillonnage'
                    cla(handles.affichage_graphique);
                    axes(handles.affichage_graphique);
                    hold on
                    plot(evntobj.graphique.abscisses,evntobj.graphique.ordonnees,'displayname','Courbe originale','HitTest', 'off');
                    vecteur_t_ech_normal = evntobj.vecteur_temps_echantillonnage_normal;
                    vecteur_t_ssech = evntobj.vecteur_temps_sous_echantillonnage;
                    points_ech_normal = plot(vecteur_t_ech_normal,evntobj.graphique.ordonnees(vecteur_t_ech_normal),'black+','displayname','Echantillonnage normal','HitTest', 'off');
                    points_ssech_normal = plot(vecteur_t_ssech,evntobj.graphique.ordonnees(vecteur_t_ssech),'red+','displayname','Sous-échantillonnage','HitTest', 'off');
                    legend([points_ech_normal,points_ssech_normal]);
                    hold off
                case 'chemin_enregistrement_export_graphique'
                    export_fig(handles.affichage_graphique, evntobj.chemin_enregistrement_export_graphique);
                case 'chemin_enregistrement_export_image'
                    export_fig(handles.image, evntobj.chemin_enregistrement_export_image);
            end
        guidata(handles.figure1,handles);
        end
        
    end
    
    methods
        function choisir_axe_image(soi)
            handles = guidata(soi.ihm);
            axes(handles.image);
        end
        
        function choisir_axe_affichage_graphique(soi)
            handles = guidata(soi.ihm);
            axes(handles.affichage_graphique);
        end
    end
end