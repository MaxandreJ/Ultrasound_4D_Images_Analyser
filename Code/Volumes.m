classdef Volumes < handle
    %VOLUMES Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        donnees
        ordre_axes
        donnees_ROI
        coordonnee_axe1_debut_ROI
        coordonnee_axe2_debut_ROI
        coordonnee_axe1_fin_ROI
        coordonnee_axe2_fin_ROI
        coordonnee_axe3_selectionnee
        coordonnee_axe4_selectionnee
        choix_forme_ROI
        methode_trace_ROI
        taille_axes_enregistree
        image_ROI_enregistree
    end
    
    properties (Dependent)
        taille_axes
        image_ROI
        coordonnees_axe1_distinctes
        coordonnees_axe2_distinctes
    end
    
    methods
        function soi = Volumes(donnees,ordre_axes)
         soi.donnees = donnees;
         soi.ordre_axes = ordre_axes;
        end
    
        function valeur = get.taille_axes(soi)
           valeur=[size(soi.donnees,1),...
               size(soi.donnees,2),...
               size(soi.donnees,3),...
               size(soi.donnees,4)];
           soi.taille_axes_enregistree=valeur;
        end
        
        function im_ROI = get.image_ROI(soi)
            im_ROI = soi.donnees_ROI(:,:,...
                soi.coordonnee_axe3_selectionnee,...
                soi.coordonnee_axe4_selectionnee);
            soi.image_ROI_enregistree=im_ROI;
        end
        
        function valeur = get.coordonnees_axe1_distinctes(soi)
            valeur = (soi.coordonnee_axe1_debut_ROI~=soi.coordonnee_axe1_fin_ROI);
        end
        
        function valeur = get.coordonnees_axe2_distinctes(soi)
            valeur = (soi.coordonnee_axe2_debut_ROI~=soi.coordonnee_axe2_fin_ROI);
        end
        
    end
    
end


