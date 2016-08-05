classdef volumes < handle
    %VOLUMES Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        donnees
        ordre_axes
        taille_axes
    end
    
    methods
        function objet = volumes(donnees,ordre_axes,taille_axes)
         objet.donnees = donnees;
         objet.ordre_axes = ordre_axes;
         objet.taille_axes = taille_axes;
        end
    end
    
end

