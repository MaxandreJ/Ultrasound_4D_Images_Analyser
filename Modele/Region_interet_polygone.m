classdef Region_interet_polygone < Region_interet
    %REGION_INTERET_POLYGONE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        masque_binaire_4D
        polygone
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
         
    end
    
end

