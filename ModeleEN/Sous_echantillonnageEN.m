classdef Sous_echantillonnage < handle
    % Classe contenant les propriétés et méthodes d'un sous_echantillonnage
    
    % Class which contains the properties and methos of a
    % "sous_echantillonage" (sub-sampling)
    properties
        vecteur_temps_echantillonnage_normal % Les pas de temps pour lesquels
                                                % l'échantillonnage est normal
                                                % c'est-à-dire pour lesquels 
                                                % on les prend tous
                                                
                                             % Time-steps for which the
                                             % sampling is normal, that is
                                             % to say when we take all of
                                             % them
        vecteur_temps_sous_echantillonnage % Les pas de temps pour lesquels
                                                % on sous-échantillonne
                                                % c'est-à-dire pour lesquels 
                                                % on ne les prend pas tous
                                                
                                           % Time-steps for which we do
                                           % sub-sampling, that is to say
                                           % when we do not take all of
                                           % them
                                         
        modele
    end
    
    methods (Access = ?Modele)  %% Seul un modèle (instance d'une classe parente) 
                                    % peut construire une instance de Sous_echantillonnage
                                    
                                % Only a model (instance of a parent /
                                % higher-level class) can build a instance
                                % of "Sous_echantillonage" (sub-sampling)
        function soi = Sous_echantillonnage(modele)
            % Constructeur d'une instance de Sous_echantillonnage, il ne peut n'y en avoir
            % qu'une
            
            % Builder of an instance of Sous_echantillonage; there can
            % only be one of it
           soi.modele = modele;
        end
    end
    
    methods
        function definir(soi,facteur_temps_intensite_maximale,facteur_sous_echantillonnage)
            % Calcul des vecteurs de temps normaux et sous-echantillonnes
            % pour futur enregistrement
            
            % Computes the normal and sub-sampled time vectors for saving
            % in the future
            
            %% On importe les données utiles
            
            % Loads the data that is useful
            volumes = soi.modele.volumes;
            region_interet = soi.modele.region_interet;
            graphique = soi.modele.graphique;
            
            nombre_de_pics = soi.modele.graphique.pics.nombre;
            ordre_axes = volumes.ordre_axes;
            
            % On gère les erreurs en utilisant un bloc try...catch
            
            % Uses a try...catch bloc to manage the errors
            try
                % L'axe des abscisses du graphique n'est pas le temps si
                % - soit le quatrième axe n'est pas choisi (le temps est
                % toujours soit au 1er, soit au 2ème, soit au 4ème axe -- 
                % mais dans le cas d'une région d'intérêt polygonale, les 1er
                % et 2ème axes des abscisses ne sont pas sélectionnables) ;
                % - soit le quatrième axe n'est pas le temps.
                
                % The X-axis of the graph is not the time if
                % - the fourth axis is not chosen (the time is always
                % either on the 1st, 2nd or 4th axis -- but in the case of
                % a polygonal region of interest, the 1st and 2nd axes of
                % X-axis can not be selected);
                % - or the 4th axis is not the time
                axe_abscisse_pas_temps = ~(soi.modele.graphique.axe_abscisses_choisi == 4)...
                    || ordre_axes(4)~=4;
                
                %% On engendre des erreurs si...
                % on a détecté plusieurs pics à l'étape de détection :
                    % Il est nécessaire d'avoir détecté un seul pic pour procéder au sous-echantillonnage
                    % qui commence à partir d'un temps déterminé par une
                    % relation avec le temps à l'intensité maximale
                    
                % Generats errors if...
                % several peaks have been detected at the detection step :
                    % It is necessary to have detected only one peak in
                    % order to proceed to the sub-sampling which starts
                    % from a time determined by a relation between time and
                    % maximum intensity
                if nombre_de_pics ~= 1
                    erreur_trop_de_pics.message = 'Le nombre de pics détectés est strictement supérieur à 1.';
                    erreur_trop_de_pics.identifier = 'sous_echantillonnage_Callback:trop_de_pics';
                    error(erreur_trop_de_pics);
                % la région d'intérêt n'est pas de forme polygonale :
                    % Pour plus de précision, on demande que le sous-échantillonnage
                    % soit effectué uniquement si la région d'intérêt a été
                    % délimitée par un polygone et non par un rectangle
                    
                % the ROI is not a polygon :
                    % for more precision, we ask for the sub-sampling to be
                    % done only if the ROI is a polygon and not a rectangle
                elseif ~isa(region_interet,'Region_interet_polygone')
                    erreur_polygone_pas_choisi.message = 'La région d''intérêt n''a pas été choisie avec un polygone.';
                    erreur_polygone_pas_choisi.identifier = 'sous_echantillonnage_Callback:polygone_pas_choisi';
                    error(erreur_polygone_pas_choisi);
                % l'axe des abscisses du graphique choisi n'est pas le temps :
                    % L'echantillonnage doit se fonder sur une échographie de constraste
                    % dont on extrait une courbe de réhaussement du signal 
                    % avec l'arrivée de l'agent de contraste qui est par définition fonction du temps
                    
                % The X-axis of the chosen graph is not the time :
                    % the sampling must be based on a contrast ultrasound
                    % imaging from which we extract a time intensity curve
                    % with the arrival of the contrast agent which is by
                    % definition a function of time
                elseif axe_abscisse_pas_temps
                    erreur_axe_abscisse_pas_temps.message = 'L''axe des abscisses du graphique affiché n''est pas le Temps.';
                    erreur_axe_abscisse_pas_temps.identifier = 'sous_echantillonnage_Callback:axe_abscisse_pas_temps';
                    error(erreur_axe_abscisse_pas_temps);
                end
                %% On initialise des paramètres importants
                % le t_maximum correspond au dernier pas de temps pris
                
                % Initializes the important parameters
                % the t_maximum corresponds to the last time-step that was
                % used
                 t_maximum=graphique.abscisses(end);
                 
                 t_du_maximum_global = graphique.pics.abscisses;
                 compteur_sous_echantillonnage = 0;
                 % On préalloue les vecteurs pour optimiser les
                 % performances de la boucle suivante
                 
                 % Pre-allocates the vectors in order to optimize the
                 % performances of the next loop
                 soi.vecteur_temps_echantillonnage_normal = NaN(1,t_maximum);
                 soi.vecteur_temps_sous_echantillonnage = NaN(1,t_maximum);
                 
                 %% Pour chacun des pas de temps, on procède à l'échantillonnage
                 
                 % Proceeds to the sampling for each one of the time-steps
                 for t=1:t_maximum
                        % Si le pas de temps est inférieur au temps à l'intensité maximale
                        % par le facteur choisi par l'utilisateur, alors
                        % l'echantillonnage est normal (on prend tous les
                        % pas de temps)
                        
                        % If the time-step is lower than the time at
                        % mamimum intensity by a factor chosen by the user
                        % (A/N : ie 2 times lower, xx times lower ??), then
                        % the sampling is normal (we take all the
                        % time-steps)
                        condition_echantillonnage_normal = t<facteur_temps_intensite_maximale*t_du_maximum_global;
                        if condition_echantillonnage_normal
                            soi.vecteur_temps_echantillonnage_normal(t)=t;
                        % sinon, on enregistre un sur
                        % $facteur_sous_echantillonnage images
                        
                        % otherwise, we save an image every
                        % "facteur_sous_echantillonage" image (for
                        % instance, every other image or one image every 3
                        % images)
                        elseif mod(compteur_sous_echantillonnage,facteur_sous_echantillonnage)==0
                            soi.vecteur_temps_sous_echantillonnage(t) = t;
                            compteur_sous_echantillonnage = compteur_sous_echantillonnage + 1;
                        else
                            compteur_sous_echantillonnage = compteur_sous_echantillonnage + 1;
                        end
                 end
                 
                 %% On enlève les valeurs NaN en effectuant un filtrage booléen
                 
                 % Removes the NaN values by using a boolean filter
                 soi.vecteur_temps_echantillonnage_normal(...
                     isnan(soi.vecteur_temps_echantillonnage_normal)) = [];
                 soi.vecteur_temps_sous_echantillonnage(...
                     isnan(soi.vecteur_temps_sous_echantillonnage)) = [];
                 
                 %% On enregistre nos vecteurs d'échantillonnage dans les paramètres du modèle
                 % pour déclencher l'action d'affichage sur le graphique
                 
                 % Saves the sampling vectors in the parameters of the
                 % model to trigger the displaying action on the graph
                 soi.modele.vecteur_temps_echantillonnage_normal = ...
                     soi.vecteur_temps_echantillonnage_normal;
                 soi.modele.vecteur_temps_sous_echantillonnage = ...
                     soi.vecteur_temps_sous_echantillonnage;
             catch erreurs
                 %% On gère les erreurs levées
                 
                 % Manages the errors that were found
                 
                 %% Il est nécessaire d'avoir détecté un seul pic pour procéder au sous-echantillonnage
                 % qui commence à partir d'un temps déterminé par une
                 % relation avec le temps à l'intensité maximale
                 
                 % It is necessary to have detected only one peak in
                 % order to proceed to the sub-sampling which starts
                 % from a time determined by a relation between time and
                 % maximum intensity
                if (strcmp(erreurs.identifier,'sous_echantillonnage_Callback:trop_de_pics'))
                    warndlg('Merci de choisir de détecter un seul pic à l''étape précédente.');
                    causeException = MException(erreur_trop_de_pics.identifier,erreur_trop_de_pics.message);
                    erreurs = addCause(erreurs,causeException);
                    throw(causeException);
                    
                %% Pour plus de précision, on demande que le sous-échantillonnage
                % soit effectué uniquement si la région d'intérêt a été
                % délimitée par un polygone et non par un rectangle
                
                % for more precision, we ask for the sub-sampling to be
                % done only if the ROI is a polygon and not a rectangle
                elseif (strcmp(erreurs.identifier,'sous_echantillonnage_Callback:polygone_pas_choisi'))
                    warndlg('Merci de choisir une région d''intérêt de forme polygonale et de recommencer les étapes jusqu''ici.');
                    causeException = MException(erreur_polygone_pas_choisi.identifier,erreur_polygone_pas_choisi.message);
                    erreurs = addCause(erreurs,causeException);
                    throw(causeException);
                    
                %% L'echantillonnage doit se fonder sur une échographie de constraste
                % dont on extrait une courbe de réhaussement du signal 
                % avec l'arrivée de l'agent de contraste qui est par définition fonction du temps
                
                % the sampling must be based on a contrast ultrasound
                % imaging from which we extract a time intensity curve
                % with the arrival of the contrast agent which is by
                % definition a function of time
                elseif (strcmp(erreurs.identifier,'sous_echantillonnage_Callback:axe_abscisse_pas_temps'))
                    warndlg('Merci de choisir comme axe des abscisse le temps à l''étape ''affichage du graphique''.');
                    causeException = MException(erreur_axe_abscisse_pas_temps.identifier,erreur_axe_abscisse_pas_temps.message);
                    erreurs = addCause(erreurs,causeException);
                    throw(causeException);
                end
                %% On affiche les erreurs qui n'auraient pas été gérées
                
                % Displays the errors that have not been managed / sorted out
                rethrow(erreurs);
            end
        end
        
        function sauvegarder(soi)
            % Enregistre les images sous-echantillonnees
            
            % Saves the sub-sampled images
            
            
            % On transforme l'avertissement de taille de fichier .mat trop grand
            % en erreur
            
            % Transforms the ".mat file is too big" warning into an error
            etat_erreur_premodification=warning('error', 'MATLAB:save:sizeTooBigForMATFile');
            
            % On gère les erreurs en utilisant un bloc try...catch
            
            % Uses a try...catch bloc to manage the errors
            try
                %% On demande à l'utilisateur le chemin de sauvegarde
                
                % Asks the user for the saving pathway
                [nom_du_fichier,chemin_sauvegarde] = uiputfile({'*.*'});
                %% Si l'utilisateur a annulé son action de sauvegarde, on renvoie une erreur
                
                % If the user has canceled the saving action, sends an
                % error
                choix_annulation = isequal(nom_du_fichier,0) || isequal(chemin_sauvegarde,0);
                if choix_annulation
                    erreur_choix_annulation.message = 'L''utilisateur a annulé son action de sauvegarde.';
                    erreur_choix_annulation.identifier = 'sous_echantillonnage_Callback:choix_annulation';
                    error(erreur_choix_annulation);
                end
                
                %% On se place dans le bon dossier pour enregistrement
                
                % Goes into the right directory for saving
                dossier_principal=pwd;
                cd(chemin_sauvegarde);
                
                %% On sélectionne les volumes que l'on echantillonne normalement
                
                % Selects the volumes that are sampled in a normal way
                volumes_ech_normal=soi.modele.volumes.donnees(:,:,:,soi.vecteur_temps_echantillonnage_normal);
                volumes_ech_normal=squeeze(volumes_ech_normal);
                
                %% On sélectionne les volumes que l'on sous-echantillone
                
                % Selects the volumes that are sub-sampled
                volumes_ssech=soi.modele.volumes.donnees(:,:,:,soi.vecteur_temps_sous_echantillonnage);
                volumes_ssech=squeeze(volumes_ssech);
                
                %% On concatène les volumes echantillonnés normalement et sous-échantillonnés
                
                % Concatenates the normally-sampled columes and the
                % sub-sampled volumes
                volumes_a_enregistrer = cat(4,volumes_ech_normal,volumes_ssech);
                
                %% On enregistre le fichier sans compression grâce à l'argument -v6
                % pour éviter ses problèmes (cf. Contrast ultrasonography: necessity
                % of linear data processing for the quantification of tumor vascularization
                % Peronneau et al. http://www.ncbi.nlm.nih.gov/pubmed/20577941)
                
                % Saves the file without compression thanks to the argument
                % -v6 in order to avoid problems (cf. Contrast
                % ultrasonography : necessity of linear data processing for
                % the quantification of tumor vascularization. Peronneau et
                % al. http://www.ncbi.nlm.nih.gov/pubmed/20577941)
                save([nom_du_fichier,'.mat'],'volumes_a_enregistrer','-mat','-v6');
                cd(dossier_principal);
            catch erreurs
                %% On gère les erreurs levées
                
                % Manages the errors that were found
                if (strcmp(erreurs.identifier, 'sous_echantillonnage_Callback:choix_annulation'))
                    causeException = MException(erreur_choix_annulation.identifier,erreur_choix_annulation.message);
                    erreurs = addCause(erreurs,causeException);
                elseif (strcmp(erreurs.identifier, 'MATLAB:save:sizeTooBigForMATFile'))
                    % Si la taille du fichier est trop grande etre enregistree sous un seul fichier.mat
                    % on enregistre chacun des volumes correspondant à
                    % chaque pas de temps séparément dans un dossier
                    % portant le nom du fichier initial
                    
                    % If the file size is too big to be saved in a single
                    % .mat file, then each volume corresponding to a
                    % time-step are saved separately in a folder named
                    % after the initial file
                    %% On gère l'erreur
                    
                    % Manages the error
                    message_erreur = ['Les données sont trop grosses pour être enregistrées dans un seul fichier.',...
                        'Les données seront enregistrées dans un dossier à la place.'];
                    causeException = MException('MATLAB:save:sizeTooBigForMATFile',message_erreur);
                    erreurs = addCause(erreurs,causeException);
                    
                    %% On importe les données utiles
                    
                    % Loads the data that is useful
                    graphique = soi.modele.graphique;
                    t_maximum= graphique.abscisses(end);
                    %% Si le répertoire existe déjà comme nom de fichier, on
                    % l'écrase.
                    % Le fichier à supprimer peut ne pas exister, on
                    % supprime les avertissements à ce sujet.
                    
                    % If the directory already exists as a file name, it is
                    % overwritten.
                    % The file that has to be overwritten can be
                    % inexistant, we suppress the warnings about it
                    warning('off','all');

                    delete(nom_du_fichier);
                    
                    %% On remet les avertissements
                    
                    % Resets the warnings
                    warning('on','all');
                    
                    %% On crée le dossier et on s'y met
                    
                    % Creates the folder and goes into it
                    mkdir(nom_du_fichier);
                    cd(nom_du_fichier);
                    
                    %% On enregistre les volumes dans le dossier créé
                    
                    % Saves the volume in the folder that was created
                    barre_attente = waitbar(0,{'Le fichier à enregistrer fait plus de deux Go :', ...
                        'fractionnement en fichiers individuels pour chacun des pas de temps',...
                        'et enregistrement dans un dossier séparé.'});
                    for t=1:t_maximum
                        volume_a_enregistrer = volumes_a_enregistrer(:,:,:,t);
                        save([nom_du_fichier,num2str(t),'.mat'],'volume_a_enregistrer',...
                            '-mat','-v6');
                        waitbar(t/t_maximum);
                    end
                    %% On revient dans le dossier parent et on supprime le fichier .mat
                    % probablement créé dans la partie try...
                    
                    % Comes back into the parent / higher-lever folder and
                    % deletes the .mat file which has probably been creatd
                    % in the try... part
                    cd('..');
                    delete([nom_du_fichier,'.mat']);
                    
                    %% On revient dans le dossier principal et on ferme la barre d'attente
                    
                    % Comes back into the principal folder and closes the
                    % waiting bar
                    cd(dossier_principal);

                    close(barre_attente);
                else
                    % On affiche les erreurs qui n'auraient pas été gérées
                    
                    % Displays the errors that have not been managed / sorted out
                    rethrow(erreurs);
                end
            end
            % On retransforme l'erreur de taille de fichier .mat trop grand
            % en avertissement, comme par défaut
            
            % Changes the ".mat file too big" error back into a warning (as
            % it is by default)
            warning(etat_erreur_premodification);
        end
    end
    
end

