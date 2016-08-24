classdef Volumes_fichier_mat < Volumes
    %VOLUMES_MAT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods (Access = ?Modele)  %Only Modele is allowed to construct a child
        function soi = Volumes_fichier_mat(modele)
           soi.modele = modele;
        end
    end
    
    methods
        
        function charger(soi)
            [nom_du_fichier, chemin_du_dossier] = uigetfile({'*.mat'},'Choix des volumes 4D en format .mat');
            soi.chemin_a_afficher=[chemin_du_dossier, nom_du_fichier];
            soi.modele.chemin_donnees=soi.chemin_a_afficher;
            
            cellules_donnees_4D = struct2cell(load([chemin_du_dossier, nom_du_fichier], '-mat'));
            soi.donnees = cellules_donnees_4D{1}; 
            soi.modele.image = soi.donnees(:,:,soi.coordonnee_axe3_selectionnee,soi.coordonnee_axe4_selectionnee);
        end
    end
    
end

