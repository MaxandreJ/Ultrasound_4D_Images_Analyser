classdef Graphique < handle
    %GRAPHIQUE Classe contenant les propriétés et méthodes liées au
    %graphique
    
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
    
    methods (Access = ?Modele)  %Only Modele is allowed to construct a child
        function soi = Graphique(modele,axe_abscisses_choisi,axe_moyenne_choisi)
            soi.modele = modele;
            soi.axe_abscisses_choisi= axe_abscisses_choisi;
            soi.axe_moyenne_choisi=axe_moyenne_choisi;
            %Constructeur

            %Définition de propriétés utiles pour l'affichage
            soi.noms_axes_legende_abscisses={'X (en pixels)','Y (en pixels)','Z (en pixels)','Temps (en pas de temps)'};
            soi.noms_axes=['X','Y','Z','Temps'];
            
            %On détermine si une seule courbe est affichée ou non
            if isa(soi.modele.region_interet,'Region_interet_rectangle')
                ROI_en_ligne = xor(soi.modele.region_interet.coordonnees_axe1_distinctes,soi.modele.region_interet.coordonnees_axe2_distinctes);
            else
                ROI_en_ligne = false;
            end

            %On a une seule courbe si la region d'interêt est une ligne ou
            %si on a moyenné les valeurs dans les région d'intérêt
            soi.une_seule_courbe = ROI_en_ligne || ~strcmp(soi.axe_moyenne_choisi,'pas de moyenne');
        
        end
    end

    methods
        
        function creer_pics(soi)
            soi.pics = Pics(soi); %The child is now informed of his parent
        end
        
        function definir(soi)
            %Chargement des valeurs d'ordonnées et d'abscisses du graphique
            
            %Importation des paramètres nécessaires
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
            
            %Moyennage des données selon l'axe ou les axes choisis
            switch soi.axe_moyenne_choisi
                case '1'
                    image_ROI = mean(image_ROI,1);
                    %Enlever les dimensions inutiles laissées par la moyenne
                    image_ROI = squeeze(image_ROI);
                case '2'
                    image_ROI = mean(image_ROI,2);
                    %Pour avoir toujours des données en ligne
                    image_ROI = image_ROI';
                    %Enlever les dimensions inutiles laissées par la moyenne
                    image_ROI = squeeze(image_ROI);
                case '1 et 2'
                    donnees_ROI=nanmean(nanmean(donnees_ROI,1),2);
                    %Enlever les dimensions inutiles laissées par les moyennes
                    donnees_ROI=squeeze(donnees_ROI);
                case 'pas de moyenne'
            end
            
            %Selection des données en fonctions de l'axe des abscisses
            %choisi pour l'affichage du graphique
            switch soi.axe_abscisses_choisi
                case 1
                    soi.abscisses = int16(coordonnee_axe1_debut_ROI):int16(coordonnee_axe1_fin_ROI);
                    soi.ordonnees = image_ROI ;
                case 2
                    soi.abscisses = int16(coordonnee_axe2_debut_ROI):int16(coordonnee_axe2_fin_ROI);
                    soi.ordonnees = image_ROI';
                case 3
                    soi.ordonnees = donnees_ROI(:,coordonnee_axe4_selectionnee);
                    soi.abscisses = 1:int16(taille_axes(3));
                case 4
                    soi.ordonnees = donnees_ROI(coordonnee_axe3_selectionnee,:);
                    soi.abscisses = 1:int16(taille_axes(4));
            end
            
            soi.modele.ordonnees_graphique = soi.ordonnees;
            soi.modele.abscisses_graphique = soi.abscisses;
        end
        
        function exporter(soi)
            [nom_du_fichier,chemin] = uiputfile({'*.png';'*.jpeg';'*.bmp';'*.tiff';'*.pdf';'*.eps'});
            soi.chemin_enregistrement_export = fullfile(chemin,nom_du_fichier);
            soi.modele.chemin_enregistrement_export_graphique = soi.chemin_enregistrement_export;
        end
    
    end
end

