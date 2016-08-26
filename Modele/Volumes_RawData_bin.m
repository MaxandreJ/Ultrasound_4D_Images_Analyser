classdef Volumes_RawData_bin < Volumes
    % Classe concrète contenant les propriétés et méthodes particulières à
    % une volumes importé d'un dossier contenant des fichiers au format
    % .bin formatés en RawData (chaque fichier représentant un pas de temps)
    % et héritant des propriétés et méthodes de la classe abstraite Volumes
    
    properties
        dossier_chargement_par_defaut = 'C:\Users\m_jacqueline\Downloads\4D_Aplio500_Analyser\Raw'
    end
    
    methods (Access = ?Modele)  % Seul un modèle (instance d'une classe parente) 
                                    % peut construire une instance de Volumes_RawData_bin
        function soi = Volumes_RawData_bin(modele)
            % Constructeur d'une instance de Volumes_RawData_bin, il ne peut n'y en avoir
            % qu'une
           soi.modele = modele;
        end
    end
    
    methods
        function charger(soi)
            % Chargement des volumes à partir d'un dossier de fichiers au
            % fichiers au format .bin formatés en RawData 
            % (chaque fichier représentant un pas de temps)
            
            %% On récupère le chemin du dossier à charger
            chemin = uigetdir(soi.dossier_chargement_par_defaut,'Dossier contenant les volumes en .bin');
            
            
            soi.chemin_a_afficher=chemin;
            %% On le passe au modèle pour affichage
            soi.modele.chemin_donnees=soi.chemin_a_afficher;
            
            %% On prépare le terrain pour l'import
            % La fonction dir récupère les données du dossier sélectionné
            d = dir(chemin);
            
            % On charge Patient_info.txt
            patient_info_id = fopen(fullfile(chemin,d(3).name));
            
            % On lit Patient_info.txt
            patient_info = textscan(patient_info_id,'%s',11);
            patient_info = patient_info{1,1};
            range = str2double(patient_info{5});
            azimuth = str2double(patient_info{8});
            elevation = str2double(patient_info{11});
            
            % On calcule le nombre de fichiers dans le dossier
            nb_fichiers = size(d);
            nb_fichiers = nb_fichiers(1);
            
            % Préallocations
            identifiants_fichiers = cell((nb_fichiers-3),1);
            fichiers = cell((nb_fichiers-3),1);

            barre_attente = waitbar(0,'Merci de patienter pendant le chargement des fichiers...');
            
            %% Import
            for ifichier = 1:nb_fichiers-3
                % On charge le fichier en cours de traitement
                % Note : pour éviter les fichiers . .. et PatientInfo.txt 
                % on commence au fichier numéro 4 (cf. code ci-dessous "d(ifichier+3).name")
                
                % Ouverture du fichier
                identifiants_fichiers{ifichier} = fopen(fullfile(chemin,d(ifichier+3).name));
                
                % Lecture
                fichiers{ifichier} = fread(identifiants_fichiers{ifichier});
                
                % Redimensionnement du fichier au format range x azimuth x
                % elevation conformément à la documentation de Toshiba pour
                % les fichiers RawData.
                % Les valeurs de range, azimuth et elevation ont été trouvées
                % dans le fichier PatientInfo.txt
                fichiers{ifichier} =reshape(fichiers{ifichier},range,azimuth,elevation);
                
                waitbar(ifichier/(nb_fichiers-3));
            end
            
            %% On concatène les différents fichiers importés selon le 4ème axe
            % qui est l'axe du temps. En effet les fichiers correspondent
            % chacun à un pas de temps particulier.
            donnees_4D = cat(4,fichiers{:});
            
            % On permute les données qui ne sont pas enregistrées au bon
            % format
            donnees_4D = permute(donnees_4D,[2,1,3,4]);
            
            %% On enregistre les données dans les propriétés du volumes et du modèle
            soi.donnees = donnees_4D;
            soi.modele.image = soi.donnees(:,:,soi.coordonnee_axe3_selectionnee,soi.coordonnee_axe4_selectionnee);
            
            close(barre_attente);
        end
    end
    
end

