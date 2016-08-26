classdef Volumes_dossier_mat < Volumes
    % Classe concrète contenant les propriétés et méthodes particulières à
    % une volumes importé d'un dossier contenant des fichiers au format
    % .mat (chaque fichier représentant un pas de temps)
    % et héritant des propriétés et méthodes de la classe abstraite Volumes
    
    properties
    end
    
    methods (Access = ?Modele)  % Seul un modèle (instance d'une classe parente) 
                                    % peut construire une instance de Volumes_dossier_mat
        function soi = Volumes_dossier_mat(modele)
            % Constructeur d'une instance de Volumes_dossier_mat, il ne peut n'y en avoir
            % qu'une
           soi.modele = modele;
        end
    end
    
    methods
        
        function charger(soi)
            % Chargement des volumes à partir d'un dossier de fichiers au
            % format .mat (chaque fichier représentant un pas de temps)
            
            %% On récupère le chemin du dossier à charger
            chemin_du_dossier = uigetdir;
            
            %% On le passe au modèle pour affichage
            soi.modele.chemin_donnees=chemin_du_dossier;
            
            %% On prépare le terrain pour l'import
            % La fonction dir récupère les données du dossier sélectionné
            d = dir(chemin_du_dossier);
            
            % On calcule le nombre de fichiers dans le dossier
            nb_fichiers = size(d);
            nb_fichiers = nb_fichiers(1);
            
            % Préallocations
            structure_fichiers = cell((nb_fichiers-2),1);
            fichiers = cell((nb_fichiers-2),1);

            barre_attente = waitbar(0,'Merci de patienter pendant le chargement des fichiers...');
            
            %% Import
            for ifichier = 1:nb_fichiers-2
                % On charge le fichier qui est une structure
                % Note : pour éviter les fichiers . .. (présent dans tout dossier)
                % on commence au fichier numéro 3 (cf. code ci-dessous "d(ifichier+2).name")
                structure_fichiers{ifichier} = struct2cell(load(fullfile(chemin_du_dossier,d(ifichier+2).name)));
                
                %On extrait les données de la structure
                structure_fichier_traite = structure_fichiers{ifichier}; 
                fichiers{ifichier} = structure_fichier_traite{1}; 
                
                waitbar(ifichier/(nb_fichiers-2));
            end
            
            %% On concatène les différents fichiers importés selon le 4ème axe
            % qui est l'axe du temps. En effet les fichiers correspondent
            % chacun à un pas de temps particulier.
            donnees_4D = cat(4,fichiers{:});
            
            %% On enregistre les données dans les propriétés du volumes et du modèle
            soi.donnees = donnees_4D;
            soi.modele.image = soi.donnees(:,:,soi.coordonnee_axe3_selectionnee,soi.coordonnee_axe4_selectionnee);
            
            close(barre_attente);
        end
    end
    
end
