classdef Modele < handle    
    properties (SetObservable)
        image
        chemin_donnees
        donnees_region_interet
        entropie_region_interet
        abscisses_graphique
        ordonnees_graphique
        largeur_a_mi_hauteur_pic_choisi
        distance_pic_a_pic_choisie
        vecteur_temps_echantillonnage_normal
        vecteur_temps_sous_echantillonnage
        chemin_enregistrement_export_graphique
        chemin_enregistrement_export_image
        chemin_enregistrement_export_interface
    end
    
    properties
        volumes
        region_interet
        graphique
        sous_echantillonnage
    end
        
    methods
        function soi = Modele()
            %obj.reset()
        end
        
        function creer_volumes_mat(soi)
            soi.volumes = Volumes_mat(soi); %The child is now informed of his parent
        end
        
        function creer_volumes_RawData_bin(soi)
            soi.volumes = Volumes_RawData_bin(soi); %The child is now informed of his parent
        end
        
        function creer_volumes_VoxelData_bin(soi)
            soi.volumes = Volumes_VoxelData_bin(soi); %The child is now informed of his parent
        end
        
        function creer_volumes_dossier_mat(soi)
            soi.volumes = Volumes_dossier_mat(soi); %The child is now informed of his parent
        end
        
        function creer_region_interet_rectangle(soi)
            soi.region_interet = Region_interet_rectangle(soi); %The child is now informed of his parent
        end
        
        function creer_region_interet_polygone(soi)
            soi.region_interet = Region_interet_polygone(soi); %The child is now informed of his parent
        end
        
        function creer_graphique(soi,axe_abscisses_choisi,axe_moyenne_choisi)
            soi.graphique = Graphique(soi,axe_abscisses_choisi,axe_moyenne_choisi);
        end
        
        function creer_sous_echantillonnage(soi)
            soi.sous_echantillonnage = Sous_echantillonnage(soi);
        end
        
        function exporter_image(soi)
            [nom_du_fichier,chemin] = uiputfile({'*.png';'*.jpeg';'*.bmp';'*.tiff';'*.pdf';'*.eps'});
            soi.chemin_enregistrement_export_image = fullfile(chemin,nom_du_fichier);
        end
        
        function exporter_interface(soi)
            [nom_du_fichier,chemin] = uiputfile({'*.png';'*.jpeg';'*.bmp';'*.tiff';'*.pdf';'*.eps'});
            soi.chemin_enregistrement_export_interface = fullfile(chemin,nom_du_fichier);
        end
    end
end
