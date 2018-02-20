classdef Volumes_RawData_bin < Volumes
    % Classe concrète contenant les propriétés et méthodes particulières à
    % une volumes importé d'un dossier contenant des fichiers au format
    % .bin formatés en RawData (chaque fichier représentant un pas de temps)
    % et héritant des propriétés et méthodes de la classe abstraite Volumes
    
    % Concrete class which contains the properties and the methods that are
    % specific to a volume loaded from a folder containing the .bin format
    % files formatted in RawData(each file representing a time-step) and inheriting the
    % properties and the methods of the abstract class Volumes
    
    properties
        dossier_chargement_par_defaut = 'C:\Users\m_jacqueline\Downloads\4D_Aplio500_Analyser\Raw'
    end
    
    methods (Access = ?Modele)  % Seul un modèle (instance d'une classe parente) 
                                    % peut construire une instance de Volumes_RawData_bin
                                    
                                % Only a model (instance of a parent /
                                % higher-level class can build an instance
                                % of Volumes_RawData_bin   
        function soi = Volumes_RawData_bin(modele)
            % Constructeur d'une instance de Volumes_RawData_bin, il ne peut n'y en avoir
            % qu'une
            
            % Builder of an instance of Volumes_RawData_bin; there can
            % only be one of it
           soi.modele = modele;
        end
    end
    
    methods
        function charger(soi)
            % Chargement des volumes à partir d'un dossier de fichiers au
            % fichiers au format .bin formatés en RawData 
            % (chaque fichier représentant un pas de temps)
            
            % Loads the volumes form a folder of .bin format files formatted in RawData (each
            % file represents a time-step)
            
            %% On récupère le chemin du dossier à charger
            
            % Gets the pathway of the folder that has to be loaded
            chemin = uigetdir(soi.dossier_chargement_par_defaut,'Dossier contenant les volumes en .bin');
            
            
            soi.chemin_a_afficher=chemin;
            %% On le passe au modèle pour affichage
            
            % The pathway is given to the model in order to display it
            soi.modele.chemin_donnees=soi.chemin_a_afficher;
            
            %% On prépare le terrain pour l'import
            % La fonction dir récupère les données du dossier sélectionné
            
            % Preparing for the loading / importantion. The function dir
            % gets the data of the selected folder
            d = dir(chemin);
            
            % On charge Patient_info.txt
            
            %Loads Patient_info.txt
            patient_info_id = fopen(fullfile(chemin,d(3).name));
            
            % On lit Patient_info.txt
            
            % Reads Patient_info.txt
            patient_info = textscan(patient_info_id,'%s',11);
            patient_info = patient_info{1,1};
            range = str2double(patient_info{5});
            azimuth = str2double(patient_info{8});
            elevation = str2double(patient_info{11});
            
            % On calcule le nombre de fichiers dans le dossier
            
            % Computes the number of files in the folder
            nb_fichiers = size(d);
            nb_fichiers = nb_fichiers(1);
            
            % Préallocations
            
            % Pre-allocates
            identifiants_fichiers = cell((nb_fichiers-3),1);
            fichiers = cell((nb_fichiers-3),1);

            barre_attente = waitbar(0,'Merci de patienter pendant le chargement des fichiers...');
            
            %% Import
            
            % Loading
            for ifichier = 1:nb_fichiers-3
                % On charge le fichier en cours de traitement
                % Note : pour éviter les fichiers . .. et PatientInfo.txt 
                % on commence au fichier numéro 4 (cf. code ci-dessous "d(ifichier+3).name")
                
                % Loads the file which is currently under process
                % Note: in order to avoid the . .. files and
                % PatientInfo.txt files, we start with file number 4 (cf.
                % following code "d(ifichier+3).name")
                
                % Ouverture du fichier
                
                % Opens the file
                identifiants_fichiers{ifichier} = fopen(fullfile(chemin,d(ifichier+3).name));
                
                % Lecture
                
                % Reads the file
                fichiers{ifichier} = fread(identifiants_fichiers{ifichier});
                
                % Redimensionnement du fichier au format range x azimuth x
                % elevation conformément à la documentation de Toshiba pour
                % les fichiers RawData.
                % Les valeurs de range, azimuth et elevation ont été trouvées
                % dans le fichier PatientInfo.txt
                
                % Resizes the file in a format range x azimuth x elevation,
                % in accordance with the Toshbia documentation for RawData
                % files.
                % The range, azimuth and elevation values have been found
                % in the PatientInfo.txt file.
                fichiers{ifichier} =reshape(fichiers{ifichier},range,azimuth,elevation);
                
                waitbar(ifichier/(nb_fichiers-3));
            end
            
            %% On concatène les différents fichiers importés selon le 4ème axe
            % qui est l'axe du temps. En effet les fichiers correspondent
            % chacun à un pas de temps particulier.
            
            % Concatenates the various files that have been loaded
            % following the 4th axis which is the time axis. Indeed, each
            % file corresponds to a specific time-step.
            donnees_4D = cat(4,fichiers{:});
            
            % On permute les données qui ne sont pas enregistrées au bon
            % format
            
            % Swaps the data that are not saves in the right format
            donnees_4D = permute(donnees_4D,[2,1,3,4]);
            
            %% On enregistre les données dans les propriétés du volumes et du modèle
            
            % Saves the data in the properties of the volumes and of the
            % model
            soi.donnees = donnees_4D;
            soi.modele.image = soi.donnees(:,:,soi.coordonnee_axe3_selectionnee,soi.coordonnee_axe4_selectionnee);
            
            close(barre_attente);
        end
    end
    
end

