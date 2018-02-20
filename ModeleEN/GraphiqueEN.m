classdef Graphique < handle
    %Classe contenant les propriétés et méthodes d'un graphique
    
    % Class which contains the properties and the methods of a graph
    
    properties
        modele
        abscisses
        ordonnees
        axe_abscisses_choisi
        axe_moyenne_choisi
        pics
        largeurs_a_mi_hauteur
        une_seule_courbe
        noms_axes_legende_abscisses
        noms_axes
        chemin_enregistrement_export
    end
    
    properties (Dependent)
        titre
    end
    
    methods (Access = ?Modele)  % Seul un modèle (instance d'une classe parente) 
                                    % peut construire une instance du Graphique
                                
                                % Only a model (instance of a parent / higher-order
                                % class) can build an instance of the
                                % Graphique (= graph)
        function soi = Graphique(modele,axe_abscisses_choisi,axe_moyenne_choisi)
            % Constructeur d'un graphique, il ne peut n'y en avoir qu'un
            
            % Builder of a graph; they can only be one of it
            
            %% On récupère les arguments et on les passe en propriétés de l'instance
            
            % Retrieves the arguments and passes them into properties of
            % the instance
            soi.modele = modele;
            soi.axe_abscisses_choisi= axe_abscisses_choisi;
            soi.axe_moyenne_choisi= axe_moyenne_choisi;

            %% Définition de propriétés utiles pour l'affichage
            
            % Defines the properties useful for the display
            soi.noms_axes_legende_abscisses={'X (en pixels)','Y (en pixels)','Z (en pixels)','Temps (en pas de temps)'};
            soi.noms_axes=['X','Y','Z','Temps'];
            
            %% On détermine si une seule courbe est affichée ou non
            
            % Figures out if only one curve is diplayed or not
            if isa(soi.modele.region_interet,'Region_interet_rectangle')
                ROI_en_ligne = xor(soi.modele.region_interet.coordonnees_axe1_distinctes,soi.modele.region_interet.coordonnees_axe2_distinctes);
            else
                ROI_en_ligne = false;
            end

            %On a une seule courbe si la region d'interêt est une ligne ou
            %si on a moyenné les valeurs dans les région d'intérêt
            
            % There is only one curve if the region of interest is a line
            % or if the values have been averaged in the region of interest
            soi.une_seule_courbe = ROI_en_ligne || ~strcmp(soi.axe_moyenne_choisi,'pas de moyenne');
        
        end
    end

    methods
        
        function creer_pics(soi)
            % Instanciation des pics
            
            % Instantiates the peaks
            soi.pics = Pics(soi); %On indique à l'enfant son parent
            
                                  % Shows the child its parent (shows to
                                  % the low-level which one is high-level)
        end
        
        function definir(soi)
            % Chargement des valeurs d'ordonnées et d'abscisses du graphique
            
            % Loads the X-axis and Y-axis values of the graph
            
            %% Importation des paramètres nécessaires
            
            % Imports the parameters which are necessary
            volumes = soi.modele.volumes;
            region_interet = soi.modele.region_interet;
            donnees_ROI=region_interet.donnees_4D;
            image_ROI=region_interet.donnees_2D;
            taille_axes=volumes.taille_axes_enregistree;
            coordonnee_axe3_selectionnee=volumes.coordonnee_axe3_selectionnee;
            coordonnee_axe4_selectionnee=volumes.coordonnee_axe4_selectionnee;
            
            if isa(region_interet,'Region_interet_rectangle')
                coordonnee_axe1_debut_ROI = region_interet.coordonnee_axe1_debut;
                coordonnee_axe2_debut_ROI = region_interet.coordonnee_axe2_debut;
                coordonnee_axe1_fin_ROI = region_interet.coordonnee_axe1_fin;
                coordonnee_axe2_fin_ROI = region_interet.coordonnee_axe2_fin;
            end
            
            %% Moyennage des données selon l'axe ou les axes choisis
            
            % Averages the data on the chosen axis ou axes
            switch soi.axe_moyenne_choisi
                case '1'
                    image_ROI = mean(image_ROI,1);
                    %Enlever les dimensions inutiles laissées par la moyenne
                    
                    % Removes the irrelevant dimensions left by the mean
                    image_ROI = squeeze(image_ROI);
                case '2'
                    image_ROI = mean(image_ROI,2);
                    %Pour avoir toujours des données en ligne
                    
                    % in order to keep the date in line format
                    image_ROI = image_ROI';
                    %Enlever les dimensions inutiles laissées par la moyenne
                    
                    % Removes the irrelevant dimensions left by the mean
                    image_ROI = squeeze(image_ROI);
                case '1 et 2'
                    donnees_ROI=nanmean(nanmean(donnees_ROI,1),2);
                    %Enlever les dimensions inutiles laissées par les moyennes
                    
                    % Removes the irrelevant dimensions left by the means
                    donnees_ROI=squeeze(donnees_ROI);
                case 'pas de moyenne'
            end
            
            %% Selection des données en fonction de l'axe des abscisses
            % choisi pour l'affichage du graphique
            
            % Selects the data depending on the X-axis chosen for the
            % display of the graph
            switch soi.axe_abscisses_choisi
                case 1
                    % Passage en vecteur colonne
                    
                    % Converting to a column vector
                    soi.abscisses = (int16(coordonnee_axe1_debut_ROI):int16(coordonnee_axe1_fin_ROI))';
                    % Passage en vecteur colonne
                    
                    % Converting to a column vector
                    soi.ordonnees = image_ROI';
                case 2
                    % Passage en vecteur colonne
                    
                    % Converting to a column vector
                    soi.abscisses = (int16(coordonnee_axe2_debut_ROI):int16(coordonnee_axe2_fin_ROI))';
                    % Passage en vecteur colonne
                    
                    % Converting to a column vector
                    soi.ordonnees = image_ROI';
                case 3
                    % Passage en vecteur colonne
                    
                    % Converting to a column vector
                    soi.abscisses = (1:int16(taille_axes(3)))';
                    % Déjà en vecteur colonne
                    
                    % Converting to a column vector
                    soi.ordonnees = donnees_ROI(:,coordonnee_axe4_selectionnee);
                case 4
                    % Passage en vecteur colonne
                    
                    % Converting to a column vector
                    soi.abscisses = (1:int16(taille_axes(4)))';
                    % Passage en vecteur colonne
                    
                    % Converting to a column vector
                    soi.ordonnees = donnees_ROI(coordonnee_axe3_selectionnee,:)';
            end
            
            %% Passage des propriétés locales aux propriétés du modèle
            % pour observation par la vue
            
            % Passing from the local properties to the model properties in
            % odrer to view / observe them using the view
            soi.modele.ordonnees_graphique = soi.ordonnees;
            soi.modele.abscisses_graphique = soi.abscisses;
        end
        
        function exporter(soi)
            % Enregistrement d'une image du graphique dans un dossier choisi
            
            % Saving an image file of the graph in a chosen folder
            %% Choix du chemin d'enregistrement
            
            % Selecting the saving pathway
            [nom_du_fichier,chemin] = uiputfile({'*.png';'*.jpeg';'*.bmp';'*.tiff';'*.pdf';'*.eps'});
            %% Enregistreement du chemin en propriétés locales, et du modèle
            % pour observation par la vue
            
            % Saving of the pathway in local properties, and  of the model
            % in order to observe using the view
            soi.chemin_enregistrement_export = fullfile(chemin,nom_du_fichier);
            soi.modele.chemin_enregistrement_export_graphique = soi.chemin_enregistrement_export;
        end
    
    end
end

