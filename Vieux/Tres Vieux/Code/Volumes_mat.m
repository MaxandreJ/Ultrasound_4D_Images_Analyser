classdef Volumes_mat < Volumes
    %VOLUMES_MAT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function charger(soi)
            [nom_du_fichier, chemin_du_dossier] = uigetfile({'*.mat'},'Choix des volumes 4D en format .mat');
            soi.chemin_a_afficher=[chemin_du_dossier, nom_du_fichier];
            
            cellules_donnees_4D = struct2cell(load([chemin_du_dossier, nom_du_fichier], '-mat'));
            soi.donnees = cellules_donnees_4D{1}; 
        end
    end
    
end

