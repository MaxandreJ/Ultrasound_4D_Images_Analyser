classdef Region_interet_polygone < Region_interet
    % Classe concrète contenant les propriétés et méthodes particulières à
    % une région d'intérêt de forme polygonale et héritant des propriétés
    % et méthodes de la classe abstraite Region_interet
    
    properties
        masque_binaire_4D % Masque contenant vrai pour les valeurs à l'intérieur
                            % de la région d'intérêt, et faux pour les
                            % autres
        polygone
    end
    
    methods (Access = ?Modele)  %% Seul un modèle (instance d'une classe parente) 
                                    % peut construire une instance de Region_interet_polygone
        function soi = Region_interet_polygone(modele)
            % Constructeur d'une instance de Region_interet_polygone, il ne peut n'y en avoir
            % qu'une
           soi.modele = modele;
        end
    end
    
    methods
        
       function tracer(soi)
           % Pour tracer une région d'intérêt visuellement
           
       % On utilise un bloc try...catch pour gérer les erreurs
        try
            %% On importe la donnée utile
            taille_axes = soi.modele.volumes.taille_axes_enregistree;
            
            %% On commence à tracer le polygone
            soi.polygone=impoly;
            
            %% Si jamais l'utilisateur change de vue en plein milieu de sa
            % séance de traçage de polygone, on renvoie une erreur
            if isempty(soi.polygone)
                erreur_ROI_pas_choisi.message = 'La région d''intérêt n''a pas été délimitée avant le changement de vue.';
                erreur_ROI_pas_choisi.identifier = 'polygone_Callback:ROI_pas_choisi';
                error(erreur_ROI_pas_choisi);
            end
            
            %% On crée un masque booléen (.==1 dans la zone d'intérêt choisie,
            % .==0 en dehors) à partir de la région d'intérêt 
            masque_binaire_2D=soi.polygone.createMask();
            
            %% On convertit le masque qui a été dessiné sur l'image affichée en
            % coordonnées cartésiennes, en un masque adapté à nos données en coordonnées
            % "indices de matrice" (voir schéma dans la documentation)
            masque_binaire_2D=masque_binaire_2D';
            
            %% On élargit le masque à toute la matrice 4D, en répétant notre sélection
            % sur les différentes tranches et aux différents temps
            % Etape qui prend beaucoup de temps (environ 3 secondes),
            % une optimisation est peut-être possible.
            soi.masque_binaire_4D = repmat(masque_binaire_2D,1,1,taille_axes(3),taille_axes(4));
        catch erreurs
            %% On gère les erreurs levées
         if (strcmp(erreurs.identifier,'polygone_Callback:ROI_pas_choisi'))
            causeException = MException(erreur_ROI_pas_choisi.identifier,erreur_ROI_pas_choisi.message);
            erreurs = addCause(erreurs,causeException);
            delete(soi.polygone);
         end
         % On affiche les erreurs qui n'auraient pas été gérées
         rethrow(erreurs);
        end

        end
                    
         function enregistrer(soi)
             % On enregistre le volume correspondant à la région d'intérêt 
             % tracée en utilisant le masque binaire précédemment défini
             
            %% On importe les données nécessaires
            volumes = soi.modele.volumes;
            donnees_4D=volumes.donnees;
            
            %% On sélectionne les données sélectionnées par la région d'intérêt
            % en utilisant en filtrage booléen
            donnees_4D(soi.masque_binaire_4D==0) = NaN;
            
            %% On enregistre les données qui nous intéressent en les mettant
            % dans les propriétés de nos objets
            soi.donnees_4D = donnees_4D;
            soi.modele.donnees_region_interet = donnees_4D;
            soi.donnees_2D = donnees_4D(:,:,volumes.coordonnee_axe3_selectionnee,...
            volumes.coordonnee_axe4_selectionnee);
         end
         
    end
    
end

