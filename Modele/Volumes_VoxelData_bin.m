classdef Volumes_VoxelData_bin < Volumes
    %VOLUMES_VOXELDATA_BIN Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        dossier_chargement_par_defaut = 'C:\Users\m_jacqueline\Downloads\4D_Aplio500_Analyser\Dragonskin02_VoxelData'
    end
    
    methods (Access = ?Modele)  %Only Modele is allowed to construct a child
        function soi = Volumes_VoxelData_bin(modele)
           soi.modele = modele;
        end
    end
    
    methods
        function charger(soi)
            chemin = uigetdir(soi.dossier_chargement_par_defaut,'Dossier contenant les volumes en .bin');
            d = dir(chemin);
            soi.chemin_a_afficher=chemin;
            soi.modele.chemin_donnees=soi.chemin_a_afficher;
            
            nb_fichiers = size(d);
            nb_fichiers = nb_fichiers(1);
            identifiants_fichiers = cell((nb_fichiers-3),1);
            fichiers = cell((nb_fichiers-3),1);

            barre_attente = waitbar(0,'Merci de patienter pendant le chargement des fichiers...');

            for ifichier = 1:nb_fichiers-3
                %Pour éviter les fichiers . .. et PatientInfo.txt on commence au fichier
                %numéro 4
                identifiants_fichiers{ifichier}=fopen(fullfile(chemin,d(ifichier+3).name));
                fichiers{ifichier}=fread(identifiants_fichiers{ifichier});
                fichiers{ifichier} = reshape(fichiers{ifichier},256,256,256);
                waitbar(ifichier/(nb_fichiers-3));
            end
            donnees_4D = cat(4,fichiers{:});
            soi.donnees = donnees_4D;
            soi.modele.image = soi.donnees(:,:,soi.coordonnee_axe3_selectionnee,soi.coordonnee_axe4_selectionnee);
            close(barre_attente);
        end
    end  
end

