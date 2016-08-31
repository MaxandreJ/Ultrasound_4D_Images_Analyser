classdef (Abstract) Region_interet < handle
    % Classe abstraite contenant les propriétés et méthodes communes aux
    % différentes formes de région d'intérêt
    
    properties
        donnees_4D
        donnees_2D % les données de la région d'intérêt de l'image sur laquelle
                   % elle a été sélectionnée
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
        tracer(soi)
        enregistrer(soi)
    end
    
    methods
        function selectionner_manuellement(soi,coordonnee_axe1_debut,...
        coordonnee_axe1_fin,coordonnee_axe2_debut,coordonnee_axe2_fin)
            % Sélectionner la région d'intérêt dans le cas où l'utilisateur
            % a entré les coordonnées manuellement
    
            soi.coordonnee_axe1_debut=coordonnee_axe1_debut;
            soi.coordonnee_axe1_fin=coordonnee_axe1_fin;
            soi.coordonnee_axe2_debut=coordonnee_axe2_debut;
            soi.coordonnee_axe2_fin=coordonnee_axe2_fin;
            
            soi.largeur_axe1 = soi.coordonnee_axe1_fin - soi.coordonnee_axe1_debut;
            soi.hauteur_axe2 = soi.coordonnee_axe2_fin - soi.coordonnee_axe1_fin;
            
            % On appelle la méthode abstraite
            soi.enregistrer;
        end
        
        function selectionner_visuellement(soi)
            % Sélectionner la région d'intérêt dans le cas où l'utilisateur
            % a dessiné la région d'intérêt sur l'image
            
            soi.tracer;

            soi.enregistrer;

        end
        function calculer_entropie(soi)
            % On calcule l'entropie sur l'image de la région d'intérêt
            
            image_ROI=soi.donnees_2D;
            % On enlève les valeurs NaN de l'image par un filtre booléen
            image_ROI=image_ROI(~isnan(image_ROI));
            % La fonction entropie de matlab ne fonctionne que sur des
            % entiers non-signés codés sur 8 bits (de 0 à 255)
            image_ROI_8bits=uint8(image_ROI);
            
            soi.entropie=entropy(image_ROI_8bits);
            % On met à jour la propriété du modèle pour affichage
            soi.modele.entropie_region_interet = soi.entropie;
        end
        
        function calculer_coefficient_variation(soi)
            % calcule le coefficient de variation qui défini par écart-type
            % / moyenne
            
            image_ROI=soi.donnees_2D;
            % On enlève les valeurs NaN de l'image par un filtre booléen
            image_ROI=image_ROI(~isnan(image_ROI));
            
            soi.coefficient_variation = std(image_ROI)/mean(image_ROI);
            % On passe au modèle notre résultat (pour affichage)
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
            try
                
                %% On importe l'image de la région d'intérêt
                image_ROI=soi.donnees_2D;
                
                %% Si on n'a pas mis de valeurs de décalages, on renvoie une erreur 
                assert((~isnan(decalage_ligne) && ~isnan(decalage_colonne)),...
                    'calculer_indices_matrice_cooccurence:valeurs_decalage_vides',...
                'Les valeurs de décalages n''ont pas été entrées.');
            
                %% On calcule la matrice de cooccurrence des niveaux de gris
                % On enlève les avertissements qui indiquent que certaines
                % valeurs sont nulles (dans le cas du polygone, c'est
                % normal, puisque la forme de la région d'intérêt n'est
                % alors pas rectangulaire, et les valeurs non prises sont
                % représentées par des NaN)
                warning('off','all');
                matrice_cooccurrence_region_interet = graycomatrix(image_ROI,...
                    'Offset',[decalage_ligne,decalage_colonne],'GrayLimits',[]);
                warning('on','all');
                
                %% On calcule les statistiques de la matrice de cooccurrence
                statistiques_matrice_cooccurrence = graycoprops(matrice_cooccurrence_region_interet);
                
                %% On enregistre les paramètres
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
                soi.modele.energie_matrice_cooccurrence_region_interet = statistiques_matrice_cooccurrence.Energy;
            catch erreurs
                %% On gère les erreurs levées
                    if (strcmp(erreurs.identifier,'calculer_indices_matrice_cooccurence:valeurs_decalage_vides'))
                        warndlg(['Merci d''entrer les valeurs de décalage, qui spécifient la relation logique ', ...
                        'de la matrice de co-occurrence.']);
                        throw(erreurs);
                    end
                % On affiche les erreurs qui n'auraient pas été gérées
                rethrow(erreurs);
            end
        end
        
    end

end

