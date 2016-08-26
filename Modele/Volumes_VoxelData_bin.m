classdef Volumes_VoxelData_bin < Volumes
    % Classe concrète contenant les propriétés et méthodes particulières à
    % une volumes importé d'un dossier contenant des fichiers au format
    % .bin formatés en VoxelData (chaque fichier représentant un pas de temps)
    % et héritant des propriétés et méthodes de la classe abstraite Volumes
    
    properties
        dossier_chargement_par_defaut = 'C:\Users\m_jacqueline\Downloads\4D_Aplio500_Analyser\Dragonskin02_VoxelData'
    end
    
    methods (Access = ?Modele)  % Seul un modèle (instance d'une classe parente) 
                                    % peut construire une instance de Volumes_VoxelData_bin
        function soi = Volumes_VoxelData_bin(modele)
            % Constructeur d'une instance de Volumes_VoxelData_bin, il ne peut n'y en avoir
            % qu'une
           soi.modele = modele;
        end
    end
    
    methods
        function charger(soi)
            % Chargement des volumes à partir d'un dossier de fichiers au
            % fichiers au format .bin formatés en VoxelData 
            % (chaque fichier représentant un pas de temps)
            
            %% On récupère le chemin du dossier à charger
            chemin = uigetdir(soi.dossier_chargement_par_defaut,'Dossier contenant les volumes en .bin');
            
            soi.chemin_a_afficher=chemin;
            %% On le passe au modèle pour affichage
            soi.modele.chemin_donnees=soi.chemin_a_afficher;
            
            %% On prépare le terrain pour l'import
            % La fonction dir récupère les données du dossier sélectionné
            d = dir(chemin);
            
            % On calcule le nombre de fichiers dans le dossier
            nb_fichiers = size(d);
            nb_fichiers = nb_fichiers(1);
            
            % Préallocations
            identifiants_fichiers = cell((nb_fichiers-3),1);
            fichiers = cell((nb_fichiers-3),1);
            donnees_4D = zeros(256,256,256,nb_fichiers-3);

            barre_attente = waitbar(0,'Merci de patienter pendant le chargement des fichiers...');
            
            %% Import
            for ifichier = 1:nb_fichiers-3
                % On charge le fichier en cours de traitement
                % Note : pour éviter les fichiers . .. et PatientInfo.txt 
                % on commence au fichier numéro 4 (cf. code ci-dessous "d(ifichier+3).name")
                
                % Ouverture du fichier
                identifiants_fichiers{ifichier}=fopen(fullfile(chemin,d(ifichier+3).name));
                
                % Lecture
                fichiers{ifichier} = fread(identifiants_fichiers{ifichier});
                
                % On utilise pour les Voxel Data une méthode apparemment
                % plus basique pour importer les données que dans les
                % méthodes charger() des autres classes.
                % On n'utilise ici pas de grande concaténation (fonction cat()) 
                % car on a remarqué que cela faisait planter MATLAB
                % si le nombre de fichiers était supérieur à 45.
                % En passant par cette méthode, MATLAB ne plante plus (il
                % est juste très lent). Peut-être qu'augmenter la mémoire
                % virtuelle ou à défaut changer d'ordinateur (aller sur la station
                % de Stéphanie Pitre, très puissante ?) permettrait de
                % lire des fichiers de plus de 45 pas de temps sans énorme 
                % ralentissement, comme actuellement.
                % On redimensionne également les données pour être au
                % format 256 x 256 x 256 comme indiqué par Toshiba Medical
                % Systems.
                donnees_4D(:,:,:,ifichier)= reshape(fichiers{ifichier},256,256,256);
                
                waitbar(ifichier/(nb_fichiers-3));
            end
            
            %% On enregistre les données dans les propriétés du volumes et du modèle
            soi.donnees = donnees_4D;
            soi.modele.image = soi.donnees(:,:,soi.coordonnee_axe3_selectionnee,soi.coordonnee_axe4_selectionnee);
            
            close(barre_attente);
        end
    end  
end

