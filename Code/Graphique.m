classdef Graphique < handle
    %GRAPHIQUE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        abscisses
        ordonnees
        axe_abscisses_choisi
        axe_moyenne_choisi
    end
    
    properties (Hidden)
        noms_axes
    end
    
    properties (Dependent)
        legende_abscisses
        legende_ordonnees
    end
    
    methods
        function soi = Graphique(abscisses,ordonnees)
         soi.abscisses=abscisses;
         soi.ordonnees=ordonnees;
        end
    end
    
end

