classdef Volumes < handle
    %VOLUMES Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        donnees
        ordre_axes
        taille_axes
        donnees_ROI
        image_ROI
        coordonnee_axe3_selectionnee
        coordonnee_axe4_selectionnee
    end
    
    methods (Access = public)
        function objet = Volumes(donnees,ordre_axes)
         objet.donnees = donnees;
         objet.ordre_axes = ordre_axes;
         objet.taille_axes = objet.Taille_axes();
        end
    end
    
    methods (Access = private)
        function taille_axes = Taille_axes(objet)
           taille_axes=[size(objet.donnees,1),size(objet.donnees,2),size(objet.donnees,3),size(objet.donnees,4)]; 
        end
    end
    
end


