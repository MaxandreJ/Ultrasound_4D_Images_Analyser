classdef (Abstract) Region_interet < handle
    % Classe abstraite contenant les propriétés et méthodes communes aux
    % différentes formes de région d'intérêt
    
    properties
        donnees_4D
        donnees_2D % les données de la région d'intérêt de l'image sur laquelle
                   % elle a été sélectionnée
        entropie
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
        
    end

end

