classdef Region_interet_rectangle < Region_interet
    % Classe concrète contenant les propriétés et méthodes particulières à
    % une région d'intérêt de forme rectangulaire et héritant des propriétés
    % et méthodes de la classe abstraite Region_interet
    
    properties
       %% Coordonnées de début et de fin pour chacun des axes de la région d'intérêt.
       % La région d'intérêt est délimitée de 1 (coord_axe1_debut) 
       % à 10 (coord_axe1_fin) sur l'axe 1 et de 15 (coord_axe2_debut) 
       % à 30 (coord_axe2_fin) sur l'axe 2
        coordonnee_axe1_debut
        coordonnee_axe2_debut
        coordonnee_axe1_fin
        coordonnee_axe2_fin
        %% Largeur et hauteur de la région d'intérêt
        largeur_axe1
        hauteur_axe2
    end
    
    properties (Dependent)
        %% Propriétés logiques, vraies si les coordonnées de la région d'intérêt
        % sont distinctes pour la région d'intérêt. 
        coordonnees_axe1_distinctes
        coordonnees_axe2_distinctes
    end
    
    methods (Access = ?Modele)  %% Seul un modèle (instance d'une classe parente) 
                                    % peut construire une instance de
                                    % Region_interet_rectangle
        function soi = Region_interet_rectangle(modele)
            % Constructeur d'une instance de Region_interet_rectangle, il ne peut n'y en avoir
            % qu'une
           soi.modele = modele;
        end
    end
    
    
    methods
        
        function tracer(soi)
            % Pour tracer une région d'intérêt visuellement
            
            % On utilise un bloc try...catch pour gérer les erreurs
                try
                    %% On commence à tracer le rectangle
                    objet_rectangle = imrect;
                    
                    %% Si jamais l'utilisateur change de vue en plein milieu de sa
                    % séance de traçage de rectangle, on renvoie une erreur
                    if isempty(objet_rectangle)
                        erreur_ROI_pas_choisi.message = 'La région d''intérêt n''a pas été délimitée avant le changement de vue.';
                        erreur_ROI_pas_choisi.identifier = 'Rectangle_Callback:ROI_pas_choisi';
                        error(erreur_ROI_pas_choisi);
                    end
                    
                    %% On obtient et calcule les coordonnées de la région d'intérêt
                    position_rectangle = getPosition(objet_rectangle);
                    
                    valeur_axe1Debut_graphique=position_rectangle(1);
                    valeur_axe2Debut_graphique=position_rectangle(2);
                    soi.largeur_axe1=position_rectangle(3);
                    soi.hauteur_axe2=position_rectangle(4);
                    valeur_axe1Fin_graphique = valeur_axe1Debut_graphique + soi.largeur_axe1;
                    valeur_axe2Fin_graphique = valeur_axe2Debut_graphique + soi.hauteur_axe2;

                    %% On arrondit les valeurs des coordonnées sélectionnées
                    soi.coordonnee_axe1_debut=int16(round(valeur_axe1Debut_graphique));
                    soi.coordonnee_axe2_debut=int16(round(valeur_axe2Debut_graphique));
                    soi.coordonnee_axe1_fin=int16(round(valeur_axe1Fin_graphique));
                    soi.coordonnee_axe2_fin=int16(round(valeur_axe2Fin_graphique));
                    
                    %% On supprime le rectangle de sélection
                    delete(objet_rectangle);
                catch erreurs
                    %% On gère les erreurs levées
                    if (strcmp(erreurs.identifier,'Rectangle_Callback:ROI_pas_choisi'))
                        causeException = MException(erreur_ROI_pas_choisi.identifier,erreur_ROI_pas_choisi.message);
                        erreurs = addCause(erreurs,causeException);
                        % On supprime le rectangle de sélection
                        delete(objet_rectangle);
                    end
                    % On affiche les erreurs qui n'auraient pas été gérées
                    rethrow(erreurs);
                end

        end
                    
         function enregistrer(soi)
              % On enregistre le volume correspondant à la région d'intérêt 
             % tracée en utilisant les coordonnées de début et de fin
             % préalablement définies
             
             % On utilise un bloc try...catch pour gérer les erreurs
             try
                %% On importe les données utiles
                volumes = soi.modele.volumes;
                
                assert(~isnan(soi.coordonnee_axe1_debut) && ~isnan(soi.coordonnee_axe1_fin) ...
                && ~isnan(soi.coordonnee_axe2_debut) && ~isnan(soi.coordonnee_axe2_fin),...
                'Region_interet_rectangle_enregistrer:coordonnees_vides',...
                'Aucune coordonnée n''a été entrée.');   
                
                %% On sélectionne les volumes à l'intérieur de la zone d'intérêt
                volumes_ROI=volumes.donnees(int16(soi.coordonnee_axe1_debut):...
                    int16(soi.coordonnee_axe1_fin),...
                    int16(soi.coordonnee_axe2_debut):int16(soi.coordonnee_axe2_fin),:,:);
                
                %% On enregistre les données qui nous intéressent en les mettant
                % dans les propriétés de nos objets
                soi.donnees_4D = volumes_ROI;
                soi.modele.donnees_region_interet = soi.donnees_4D;
                % On enregistre les donnnées situées dans la zone d'intérêt
                % et sur l'image courante
                soi.donnees_2D = soi.donnees_4D(:,:,volumes.coordonnee_axe3_selectionnee,...
                volumes.coordonnee_axe4_selectionnee);
             catch erreurs
                 %% On gère les erreurs levées
                if (strcmp(erreurs.identifier,'MATLAB:badsubscript'))
                    warndlg('Merci d''entrer une région d''intérêt incluse dans l''image.');
                    messsage_erreur = 'La région d''intérêt dépasse de l''image.';
                    cause_erreur = MException('MATLAB:badsubscript',messsage_erreur);
                    erreurs = addCause(erreurs,cause_erreur);
                elseif (strcmp(erreurs.identifier,'Region_interet_rectangle_enregistrer:coordonnees_vides'))
                    warndlg(['Merci d''entrer des coordonnées de début et de fin ', ...
                    'de la région d''intérêt pour chacun des deux axes.']);
                    throw(erreurs);
                end
                % On affiche les erreurs qui n'auraient pas été gérées
                rethrow(erreurs);
             end
         end
         
         
        function valeur = get.coordonnees_axe1_distinctes(soi)
            % Les coordonnées sur l'axe 1 sont distinctes si la coordonnée
            % de début est différente de la coordonnée de fin
            valeur = (soi.coordonnee_axe1_debut~=soi.coordonnee_axe1_fin);
        end

        function valeur = get.coordonnees_axe2_distinctes(soi)
            % Les coordonnées sur l'axe 2 sont distinctes si la coordonnée
            % de début est différente de la coordonnée de fin
            valeur = (soi.coordonnee_axe2_debut~=soi.coordonnee_axe2_fin);
        end
    end
    
   

end

