classdef Region_interet_polygone < Region_interet
    %REGION_INTERET_POLYGONE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        masque_binaire_4D
        polygone
        modele
    end
    
    methods (Access = ?Modele)  %Only Modele is allowed to construct a child
        function soi = Region_interet_polygone(modele)
           soi.modele = modele;
        end
    end
    
    methods
        
       function tracer(soi)
        try
            volumes = soi.modele.volumes;
            taille_axes = volumes.taille_axes_enregistree;
%             set(handles.figure1,'KeyPressFcn','')
            soi.polygone=impoly;
            if isempty(soi.polygone)
                erreur_ROI_pas_choisi.message = 'La région d''intérêt n''a pas été délimitée avant le changement de vue.';
                erreur_ROI_pas_choisi.identifier = 'polygone_Callback:ROI_pas_choisi';
                error(erreur_ROI_pas_choisi);
            end
            masque_binaire_2D=soi.polygone.createMask();
            %Comme l'image est en coordonnées "indices de matrice"
            masque_binaire_2D=masque_binaire_2D';
            soi.masque_binaire_4D = repmat(masque_binaire_2D,1,1,taille_axes(3),taille_axes(4));
        catch erreur
         if (strcmp(erreurs.identifier,'polygone_Callback:ROI_pas_choisi'))
            causeException = MException(erreur_ROI_pas_choisi.identifier,erreur_ROI_pas_choisi.message);
            erreurs = addCause(erreurs,causeException);
         end
         rethrow(erreurs);
        end

        end
                    
         function enregistrer(soi)
            volumes = soi.modele.volumes;
            donnees_4D=volumes.donnees;
            donnees_4D(soi.masque_binaire_4D==0) = NaN;
            soi.donnees_4D = donnees_4D;
            soi.modele.donnees_region_interet = donnees_4D;
            soi.donnees_2D = donnees_4D(:,:,volumes.coordonnee_axe3_selectionnee,...
            volumes.coordonnee_axe4_selectionnee);
         end
         
%          function afficher_coordonnees(~,~)
%          end
         
%          function afficher_region(soi,handles)
%              try
%                 axes(handles.image);
%                 taille_axes = handles.volumes.taille_axes;
%                 positions_polygone=getPosition(soi.polygone);
%                 nb_positions_polygone = size(positions_polygone,1);
%                 maximum_axe1=taille_axes(1);
%                 maximum_axe2=taille_axes(2);
%                 for i=1:nb_positions_polygone
%                     X_pos_i=positions_polygone(i,1);
%                     Y_pos_i=positions_polygone(i,2);
%                     if X_pos_i<1 || X_pos_i>maximum_axe1 || Y_pos_i<1 || Y_pos_i>maximum_axe2
%                         erreur_sortie_de_image.message = 'La région d''intérêt dépasse de l''image.';
%                         erreur_sortie_de_image.identifier = 'polygone_Callback:sortie_de_image';
%                         error(erreur_sortie_de_image);
%                     end
%                 end
%                 ordre_des_points=1:nb_positions_polygone;
%                 polygone_trace=patch('Faces',ordre_des_points,'Vertices',positions_polygone,'FaceColor','none','EdgeColor','red');
%                 handles.polygone_trace=polygone_trace;
%                 delete(soi.polygone);
%                 guidata(handles.figure1,handles);
%              catch erreurs
%                 if (strcmp(erreurs.identifier,'polygone_Callback:sortie_de_image'))
%                     warndlg('Merci d''entrer une région d''intérêt incluse dans l''image.');
%                     causeException = MException(erreur_sortie_de_image.identifier,erreur_sortie_de_image.message);
%                     erreurs = addCause(erreurs,causeException);
%                     delete(soi.polygone);
%                 end
%                 rethrow(erreurs);
%              end
%          end
         
%          function mettre_a_jour_IHM(~,handles)
%             set(handles.moyenne_axe1et2,'Value',1);
%             set(handles.moyenne_axe1,'Visible','off');
%             set(handles.moyenne_axe2,'Visible','off');
%             set(handles.pas_de_moyenne,'Visible','off');
% 
%             set(handles.abscisses_axe4,'Value',1);
%             set(handles.abscisses_axe1,'Visible','off');
%             set(handles.abscisses_axe2,'Visible','off');
% 
%             set(handles.affichage_entropie,'BackgroundColor','white');
%             
%             guidata(handles.figure1,handles);
%          end
    end
    
end

