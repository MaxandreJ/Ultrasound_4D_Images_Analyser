classdef Volumes_dossier_mat < Volumes
    %VOLUMES_DOSSIER_MAT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods (Access = ?Modele)  %Only Modele is allowed to construct a child
        function soi = Volumes_dossier_mat(modele)
           soi.modele = modele;
        end
    end
    
    methods
        
        function charger(soi)
            chemin_du_dossier = uigetdir;
            soi.modele.chemin_donnees=chemin_du_dossier;
            
            d = dir(chemin_du_dossier);
            
            nb_fichiers = size(d);
            nb_fichiers = nb_fichiers(1);
            structure_fichiers = cell((nb_fichiers-2),1);
            fichiers = cell((nb_fichiers-2),1);

            barre_attente = waitbar(0,'Merci de patienter pendant le chargement des fichiers...');

            for ifichier = 1:nb_fichiers-2
                %Pour éviter les fichiers . .. on commence au fichier
                %numéro 3
                structure_fichiers{ifichier} = struct2cell(load(fullfile(chemin_du_dossier,d(ifichier+2).name)));
                structure_fichier_traite = structure_fichiers{ifichier}; 
                fichiers{ifichier} = structure_fichier_traite{1}; 
                waitbar(ifichier/(nb_fichiers-2));
            end
            donnees_4D = cat(4,fichiers{:});
            soi.donnees = donnees_4D;
            soi.modele.image = soi.donnees(:,:,soi.coordonnee_axe3_selectionnee,soi.coordonnee_axe4_selectionnee);
            close(barre_attente);
        end
    end
    
end
