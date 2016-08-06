classdef Volumes < handle
    %VOLUMES Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        donnees
        ordre_axes
        donnees_ROI
        coordonnee_axe3_selectionnee
        coordonnee_axe4_selectionnee
        choix_forme_ROI
    end
    
    properties (Dependent)
        taille_axes
        image_ROI
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
        end
        
        function im_ROI = get.image_ROI(soi)
            im_ROI = soi.donnees_ROI(:,:,...
                soi.coordonnee_axe3_selectionnee,...
                soi.coordonnee_axe4_selectionnee);
        end
        
    end
    
end


