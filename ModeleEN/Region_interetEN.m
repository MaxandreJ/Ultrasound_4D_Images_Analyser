classdef (Abstract) Region_interet < handle
    % Classe abstraite contenant les propriétés et méthodes communes aux
    % différentes formes de région d'intérêt
    
    % Abstract class which contains the properties and the methods that the
    % various shapes of ROI have in common
    properties
        donnees_4D
        donnees_2D % les données de la région d'intérêt de l'image sur laquelle
                   % elle a été sélectionnée
                   
                   % the data of the ROI of the image where this ROI was
                   % selected
        entropie
        coefficient_variation
        contraste_matrice_cooccurrence
        energie_matrice_cooccurrence
        homogeneite_matrice_cooccurrence
        correlation_matrice_cooccurrence
        modele
    end
    
    methods (Abstract)
        %% Méthodes abstraites qui sont effectivement implémentées dans les
        % classes concrètes héritant de Region_interet
        
        % Abstract methods that are actually implemented in the concrete
        % classes inheriting "Region_interet" (ROI)
        tracer(soi)
        enregistrer(soi)
    end
    
    methods
        function selectionner_manuellement(soi,coordonnee_axe1_debut,...
        coordonnee_axe1_fin,coordonnee_axe2_debut,coordonnee_axe2_fin)
            % Sélectionner la région d'intérêt dans le cas où l'utilisateur
            % a entré les coordonnées manuellement
            
            % Selects the ROI in case the used has manually entered the
            % coordinates
    
            soi.coordonnee_axe1_debut=coordonnee_axe1_debut;
            soi.coordonnee_axe1_fin=coordonnee_axe1_fin;
            soi.coordonnee_axe2_debut=coordonnee_axe2_debut;
            soi.coordonnee_axe2_fin=coordonnee_axe2_fin;
            
            soi.largeur_axe1 = soi.coordonnee_axe1_fin - soi.coordonnee_axe1_debut;
            soi.hauteur_axe2 = soi.coordonnee_axe2_fin - soi.coordonnee_axe1_fin;
            
            % On appelle la méthode abstraite
            % Calls the absract method
            soi.enregistrer;
        end
        
        function selectionner_visuellement(soi)
            % Sélectionner la région d'intérêt dans le cas où l'utilisateur
            % a dessiné la région d'intérêt sur l'image
            
            % Selects the ROI in cas the used has drawn the ROI on the
            % image
            
            soi.tracer;

            soi.enregistrer;

        end
        function calculer_entropie(soi)
            % On calcule l'entropie sur l'image de la région d'intérêt
            
            % Computes the entropy on the image of the ROI (image where the
            % ROI has been defined)
            
            image_ROI=soi.donnees_2D;
            % On enlève les valeurs NaN de l'image par un filtre booléen
            
            % Removes the NaN values of the image by a boolean filter
            image_ROI=image_ROI(~isnan(image_ROI));
            % La fonction entropie de matlab ne fonctionne que sur des
            % entiers non-signés codés sur 8 bits (de 0 à 255)
            
            % The entropy function of Matlab works only on unsigned
            % integers coded on 8 bits (from 0 to 255)            
            image_ROI_8bits=uint8(image_ROI);
            
            soi.entropie=entropy(image_ROI_8bits);
            % On met à jour la propriété du modèle pour affichage
            
            % Updates the property of the model in order to display if /
            % for display (A/N : unsure of the real meaning ??)
            soi.modele.entropie_region_interet = soi.entropie;
        end
        
        function calculer_coefficient_variation(soi)
            % calcule le coefficient de variation qui défini par écart-type
            % / moyenne
            
            % Computes the coefficient of variation (standard deviation /
            % mean)
            image_ROI=soi.donnees_2D;
            % On enlève les valeurs NaN de l'image par un filtre booléen
            
            % Removes the NaN values of the image by a boolean filter
            image_ROI=image_ROI(~isnan(image_ROI));
            
            soi.coefficient_variation = std(image_ROI)/mean(image_ROI);
            % On passe au modèle notre résultat (pour affichage)
            
            % The result is passed to the model (for displaying)
            soi.modele.coefficient_variation_region_interet = soi.coefficient_variation;
        end
        
        function calculer_statistiques_matrice_cooccurrence(soi,decalage_ligne,...
                decalage_colonne)
            % calcule les statistiques d'énergie, contraste, homogénéité et
            % corrélation de la matrice de cooccurrence des niveaux de gris
            % qui est définie par une relation logique de lien spatial
            % entre pixels, paramétrée par decalage_ligne, decalage_colonne
            %
            % Par exemple, si on choisit decalage_ligne = 0 et
            % decalage_colonne = 1, alors la matrice de cooccurrence
            % reflètera le nombre de pixels adjacents horizontalement (qui
            % sont l'un à côté de l'autre dans l'orientation de l'axe (cartésien) des
            % abscisses de l'image affichée) qui ont respectivement i et j
            % ordre de niveaux d'intensité, i étant le numéro de la ligne de la
            % matrice, et j de la colonne.
            % Note : le décalage_colonne correspond au décalage sur l'axe
            % 1 dans l'image, et le décalage_ligne correspond au
            % décalage su l'axe 2
            
            % Computes the statistics of energy / power, contrast,
            % homogeneity and correlation of the gray-level co-occurence
            % matrix which is defined by a logical relationship of spatial
            % link between pixels, configured by decalage_ligne,
            % decalage_colonne
            %
            % For instance, if we choose decalage_ligne = 0 and
            % decalage_colonne = 1, then the co-occurence matrix will
            % reflect the number of horizontally adjacent pixels (which are
            % next to each other in the orientation of the cartesian X-axis
            % of the displayed image) which have respectively i and j
            % orders of levels of intensity, i being the matrix line number
            % and j the column.
            % Note : the decalage_colonne corresponds to the offset on the
            % axis 1 on the image, and decalage_ligne corresponds to the
            % offet on the axis 2
            
          
            
            try
                
                %% On importe l'image de la région d'intérêt
                
                % Loads the image on which the ROI was selected
                image_ROI=soi.donnees_2D;
                
                %% Si on n'a pas mis de valeurs de décalages, on renvoie une erreur 
                
                % If the offset values have not been indicated, sends an
                % error
                assert((~isnan(decalage_ligne) && ~isnan(decalage_colonne)),...
                    'calculer_indices_matrice_cooccurence:valeurs_decalage_vides',...
                'Les valeurs de décalages n''ont pas été entrées.');
            
                %% On calcule la matrice de cooccurrence des niveaux de gris
                % On enlève les avertissements qui indiquent que certaines
                % valeurs sont nulles (dans le cas du polygone, c'est
                % normal, puisque la forme de la région d'intérêt n'est
                % alors pas rectangulaire, et les valeurs non prises sont
                % représentées par des NaN)
                
                % Computes the gray-level co-occurence matrix
                % Removes the warnings which indicate that some of the
                % values are equal to zero (in the case of the polygon,
                % this is normal, since the shape of the region of interest
                % is not a rectangle, and the values that are not included
                % are represented by NaNs)
                warning('off','all');
                matrice_cooccurrence_region_interet = graycomatrix(image_ROI,...
                    'Offset',[decalage_ligne,decalage_colonne],'GrayLimits',[]);
                warning('on','all');
                
                %% On calcule les statistiques de la matrice de cooccurrence
                
                % Computes the statstics of the co-occurence matrix
                statistiques_matrice_cooccurrence = graycoprops(matrice_cooccurrence_region_interet);
                
                %% On enregistre les paramètres
                
                % Saves parameters
                soi.contraste_matrice_cooccurrence = statistiques_matrice_cooccurrence.Contrast;
                soi.energie_matrice_cooccurrence = statistiques_matrice_cooccurrence.Energy;
                soi.homogeneite_matrice_cooccurrence = statistiques_matrice_cooccurrence.Homogeneity;
                soi.correlation_matrice_cooccurrence = statistiques_matrice_cooccurrence.Correlation;

                soi.modele.contraste_matrice_cooccurrence_region_interet = statistiques_matrice_cooccurrence.Contrast;
                soi.modele.homogeneite_matrice_cooccurrence_region_interet = statistiques_matrice_cooccurrence.Homogeneity;
                soi.modele.correlation_matrice_cooccurrence_region_interet = statistiques_matrice_cooccurrence.Correlation;
                % Il est important de mettre la valeur de l'énergie
                % à jour à la fin, car c'est elle qui déclenche l'affichage
                % de toutes les valeurs
                
                % It is important to update the value of the energy / power
                % in the end, because it is this value that triggers the
                % display of all the values
                soi.modele.energie_matrice_cooccurrence_region_interet = statistiques_matrice_cooccurrence.Energy;
            catch erreurs
                %% On gère les erreurs levées
                
                % Manages the errors
                    if (strcmp(erreurs.identifier,'calculer_indices_matrice_cooccurence:valeurs_decalage_vides'))
                        warndlg(['Merci d''entrer les valeurs de décalage, qui spécifient la relation logique ', ...
                        'de la matrice de co-occurrence.']);
                        throw(erreurs);
                    end
                % On affiche les erreurs qui n'auraient pas été gérées
                
                % Displays the errors that have not been manages / sorted
                % out
                rethrow(erreurs);
            end
        end
        
    end

end

