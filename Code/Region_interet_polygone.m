classdef Region_interet_polygone < Region_interet
    %REGION_INTERET_POLYGONE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        masque_binaire_4D
    end
    
    methods
       function tracer(soi,handles)
        try
            volumes = handles.volumes;
            taille_axes = volumes.taille_axes_enregistree;
            set(handles.figure1,'KeyPressFcn','')
            axes(handles.image);
            polygone=impoly;
            if isempty(polygone)
                erreur_ROI_pas_choisi.message = 'La région d''intérêt n''a pas été délimitée avant le changement de vue.';
                erreur_ROI_pas_choisi.identifier = 'polygone_Callback:ROI_pas_choisi';
                error(erreur_ROI_pas_choisi);
            end
            masque_binaire_2D=polygone.createMask();
            %Comme l'image est en coordonnées "indices de matrice"
            masque_binaire_2D=masque_binaire_2D';
            soi.masque_binaire_4D = repmat(masque_binaire_2D,1,1,taille_axes(3),taille_axes(4));
            set(handles.figure1,'KeyPressFcn',{@clavier,handles})
        catch erreurs
            if (strcmp(erreurs.identifier,'polygone_Callback:ROI_pas_choisi'))
                causeException = MException(erreur_ROI_pas_choisi.identifier,erreur_ROI_pas_choisi.message);
                erreurs = addCause(erreurs,causeException);
            elseif (strcmp(erreurs.identifier,'polygone_Callback:sortie_de_image'))
                warndlg('Merci d''entrer une région d''intérêt incluse dans l''image.');
                causeException = MException(erreur_sortie_de_image.identifier,erreur_sortie_de_image.message);
                erreurs = addCause(erreurs,causeException);
                delete(polygone);
            else
                rethrow(erreurs);
            end
        end

        end
                    
         function enregistrer(soi,handles)
             try
                volumes_ROI=handles.volumes.donnees(int16(soi.coordonnee_axe1_debut):...
                    int16(soi.coordonnee_axe1_fin),...
                    int16(soi.coordonnee_axe2_debut):int16(soi.coordonnee_axe2_fin),:,:);
                soi.donnees_4D = volumes_ROI;
                soi.donnees_2D = soi.donnees_4D(:,:,handles.volumes.coordonnee_axe3_selectionnee,...
                handles.volumes.coordonnee_axe4_selectionnee);
             catch erreurs
                if (strcmp(erreurs.identifier,'MATLAB:badsubscript'))
                    warndlg('Merci d''entrer une région d''intérêt incluse dans l''image.');
                    messsage_erreur = 'La région d''intérêt dépasse de l''image.';
                    cause_erreur = MException('MATLAB:badsubscript',messsage_erreur);
                    erreurs = addCause(erreurs,cause_erreur);
                end
                rethrow(erreurs);
             end
         end
         
         function afficher_coordonnees(soi,handles)
            set(handles.valeur_axe1Debut_graphique,'String',num2str(soi.coordonnee_axe1_debut));
            set(handles.valeur_axe2Debut_graphique,'String',num2str(soi.coordonnee_axe2_debut));
            set(handles.valeur_axe1Fin_graphique,'String',num2str(soi.coordonnee_axe1_fin));
            set(handles.valeur_axe2Fin_graphique,'String',num2str(soi.coordonnee_axe2_fin));
            guidata(handles.figure1,handles);
         end
         
         function afficher_region(soi,handles)
             axes(handles.image);
             handles.rectangle_trace = rectangle('Position',[soi.coordonnee_axe1_debut soi.coordonnee_axe2_debut soi.largeur_axe1 soi.hauteur_axe2],'EdgeColor','r');
             guidata(handles.figure1,handles);
         end
         
         function mettre_a_jour_IHM(~,handles)
            set(handles.moyenne_axe1,'Visible','on');
            set(handles.moyenne_axe2,'Visible','on');
            set(handles.pas_de_moyenne,'Visible','on');
            set(handles.abscisses_axe1,'Visible','on');
            set(handles.abscisses_axe2,'Visible','on');
            set(handles.affichage_entropie,'BackgroundColor','white');
            guidata(handles.figure1,handles);
         end
    end
    
end

