classdef Volumes_VoxelData_bin < Volumes
    % Classe concrète contenant les propriétés et méthodes particulières à
    % une volumes importé d'un dossier contenant des fichiers au format
    % .bin formatés en VoxelData (chaque fichier représentant un pas de temps)
    % et héritant des propriétés et méthodes de la classe abstraite Volumes
    
    % Concrete class which contains the properties and the methods that are
    % specific to a volume loaded from a folder containing the .bin format
    % files formatted in VoxelData(each file representing a time-step) and inheriting the
    % properties and the methods of the abstract class Volumes

    properties
        dossier_chargement_par_defaut = 'C:\Users\m_jacqueline\Downloads\4D_Aplio500_Analyser\Dragonskin02_VoxelData'
    end
    
    methods (Access = ?Modele)  % Seul un modèle (instance d'une classe parente) 
                                    % peut construire une instance de Volumes_VoxelData_bin
                                    
                                % Only a model (instance of a parent /
                                % higher-level class can build an instance
                                % of Volumes_VoxelData_bin  
        function soi = Volumes_VoxelData_bin(modele)
            % Constructeur d'une instance de Volumes_VoxelData_bin, il ne peut n'y en avoir
            % qu'une
            
            % Builder of an instance of Volumes_RawData_bin; there can
            % only be one of it
           soi.modele = modele;
        end
    end
    
    methods
        function charger(soi)
            % Chargement des volumes à partir d'un dossier de fichiers au
            % fichiers au format .bin formatés en VoxelData 
            % (chaque fichier représentant un pas de temps)
            
            % Loads the volumes form a folder of .bin format files formatted in VoxelData (each
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
            
            % On calcule le nombre de fichiers dans le dossier
            
            % Computes the number of files in the folder
            nb_fichiers = size(d);
            nb_fichiers = nb_fichiers(1);
            
            % Préallocations
            
            % Pre-allocates
            identifiants_fichiers = cell((nb_fichiers-3),1);
            fichiers = cell((nb_fichiers-3),1);
            donnees_4D = zeros(256,256,256,nb_fichiers-3);

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
                identifiants_fichiers{ifichier}=fopen(fullfile(chemin,d(ifichier+3).name));
                
                % Lecture
                
                % Reads the file
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
                
                % Here we use a method to load the data that is simpler
                % than with the charger() methods of the other classes (mat
                % and RawData).
                % We do not use a big concatenation (function cat())
                % because it crashes Matlab if there are more than 45
                % files.
                % By using this method, Matlab does not crash anymore,
                % though it is very slow. Maybe using a more powerful
                % computer could enable to read files  of more thant 45
                % time-steps without speeding down ?
                % The data are also reshaped in order to be in a 256 x 256
                % x 256 format as indicated by Toshiba Medical Systems.
                donnees_4D(:,:,:,ifichier)= reshape(fichiers{ifichier},256,256,256);
                
                waitbar(ifichier/(nb_fichiers-3));
            end
            
            %% On enregistre les données dans les propriétés du volumes et du modèle
            
            % Saves the data in the properties of the volumes and of the
            % model
            soi.donnees = donnees_4D;
            soi.modele.image = soi.donnees(:,:,soi.coordonnee_axe3_selectionnee,soi.coordonnee_axe4_selectionnee);
            
            close(barre_attente);
        end
    end  
end

