classdef Graphique < handle
    %GRAPHIQUE Classe contenant les propriétés et méthodes liées au
    %graphique
    
    properties
        abscisses
        ordonnees
        axe_abscisses_choisi
        axe_moyenne_choisi
        pics
        abscisses_intensites_maximales
        largeurs_a_mi_hauteur
        une_seule_courbe
        legende_abscisses
        legende_ordonnees
        noms_axes_legende_abscisses
        noms_axes
    end
    
    properties (Dependent)
        titre
    end

    methods
        function soi = Graphique(handles)
            %Constructeur
            
            %Définition de propriétés utiles pour l'affichage
         soi.noms_axes_legende_abscisses={'X (en pixels)','Y (en pixels)','Z (en pixels)','Temps (en pas de temps)'};
         soi.noms_axes=['X','Y','Z','Temps'];
         
            %Transformation de valeurs booléennes des boutons radios en
            %propriété entière du graphique
            
            %%Pour le choix de l'axe des abscisses
         if handles.abscisses_axe1.Value
            soi.axe_abscisses_choisi=1;
         elseif handles.abscisses_axe2.Value
            soi.axe_abscisses_choisi=2;
         elseif handles.abscisses_axe3.Value
            soi.axe_abscisses_choisi=3;
         elseif handles.abscisses_axe4.Value
            soi.axe_abscisses_choisi=4;
         end

            %%Pour le choix de l'axe ou des axes de moyennage
         if handles.moyenne_axe1.Value
            soi.axe_moyenne_choisi='1';
         elseif handles.moyenne_axe2.Value
            soi.axe_moyenne_choisi='2';
         elseif handles.moyenne_axe1et2.Value
            soi.axe_moyenne_choisi='1 et 2';
         elseif handles.pas_de_moyenne.Value
            soi.axe_moyenne_choisi='pas de moyenne';
         end
        end
        
        function charger_donnees(soi,handles)
            %Chargement des valeurs d'ordonnées et d'abscisses du graphique
            
            %Importation des paramètres nécessaires venant du volume
            volumes = handles.volumes;
            
            donnees_ROI=volumes.donnees_ROI;
            image_ROI=volumes.image_ROI;
            taille_axes=volumes.taille_axes_enregistree;
            coordonnee_axe3_selectionnee=volumes.coordonnee_axe3_selectionnee;
            coordonnee_axe4_selectionnee=volumes.coordonnee_axe4_selectionnee;
            coordonnee_axe1_debut_ROI = volumes.coordonnee_axe1_debut_ROI;
            coordonnee_axe2_debut_ROI = volumes.coordonnee_axe2_debut_ROI;
            coordonnee_axe1_fin_ROI = volumes.coordonnee_axe1_fin_ROI;
            coordonnee_axe2_fin_ROI = volumes.coordonnee_axe2_fin_ROI;
            
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
        end
        
        function a_une_seule_courbe(soi,handles)
            %On détermine si une seule courbe est affichée ou non
            
            %Si on a choisi un rectangle, la region d'interêt est une ligne
            %si les coordonnees soit de l'axe1 soit de l'axe2 de départ et d'arrivée  
            %sont les mêmes
            if strcmp(handles.volumes.choix_forme_ROI,'rectangle');
                ROI_en_ligne = xor(handles.volumes.coordonnees_axe1_distinctes,handles.volumes.coordonnees_axe2_distinctes);
            else
                ROI_en_ligne = false;
            end
            %On a une seule courbe si la region d'interêt est une ligne ou
            %si on a moyenné les valeurs dans les région d'intérêt
         soi.une_seule_courbe = ROI_en_ligne || ~strcmp(soi.axe_moyenne_choisi,'pas de moyenne');
        end
        
        function texte = get.titre(soi)
            %Renvoie le titre du graphique 
            
            %Si on a une seule courbe, le titre est au singulier, sinon il
            %est au pluriel
            if soi.une_seule_courbe
                texte='Courbe d''intensité';
            else
                texte='Courbes d''intensité';
            end
        end
        
        function afficher_titre(soi,handles)
            axes(handles.affichage_graphique);
            soi.a_une_seule_courbe(handles);
            title(soi.titre);
        end
        
        function donner_legende_abscisses(soi,handles)
          ordre_axes=handles.volumes.ordre_axes;
          switch soi.axe_abscisses_choisi
                case 1
                    soi.legende_abscisses = soi.noms_axes_legende_abscisses(ordre_axes(1));
                case 2
                    soi.legende_abscisses = soi.noms_axes_legende_abscisses(ordre_axes(2));
                case 3
                    soi.legende_abscisses = soi.noms_axes_legende_abscisses(ordre_axes(3));
                case 4
                    soi.legende_abscisses = soi.noms_axes_legende_abscisses(ordre_axes(4));
          end
        end
        
        function afficher_legende_abscisses(soi,handles)
            soi.donner_legende_abscisses(handles);
            axes(handles.affichage_graphique);
            xlabel(soi.legende_abscisses);
        end
        
        function donner_legende_ordonnees(soi,handles)
          ordre_axes=handles.volumes.ordre_axes;
          switch soi.axe_moyenne_choisi
                case '1'
                    soi.legende_ordonnees={'Intensité (en niveaux)',...
                ['moyennée sur ',soi.noms_axes(ordre_axes(1)),' dans la région d''intérêt']};
                case '2'
                    soi.legende_ordonnees={'Intensité (en niveaux)',...
                ['moyennée sur ',soi.noms_axes(ordre_axes(2)),' dans la région d''intérêt']};
                case '1 et 2'
                    soi.legende_ordonnees={'Intensité (en niveaux)',...
                ['moyennée sur ',soi.noms_axes(ordre_axes(1)),' et ',soi.noms_axes(ordre_axes(2))],...
                ' dans la région d''intérêt'};
                case 'pas de moyenne'
                    soi.legende_ordonnees='Intensité (en niveaux)';
          end
        end
        
        function afficher_legende_ordonnees(soi,handles)
            soi.donner_legende_ordonnees(handles);
            axes(handles.affichage_graphique);
            ylabel(soi.legende_ordonnees);
        end
        

        
        function afficher_courbe(soi,handles)
            cla(handles.affichage_graphique);
            axes(handles.affichage_graphique);
            hold on
            plot(soi.abscisses,soi.ordonnees,'displayname','Courbe originale','HitTest', 'off');
            if get(handles.points_de_donnees,'Value')
                plot(soi.abscisses,soi.ordonnees,'black+','displayname','Point de données','HitTest', 'off');
            end
            hold off
        end
            
        
        function afficher_resultat_sous_echantillonnage(soi,handles)
            cla(handles.affichage_graphique);
            axes(handles.affichage_graphique);
            hold on
            plot(soi.abscisses,soi.ordonnees,'displayname','Courbe originale','HitTest', 'off');
            vecteur_t_ech_normal = handles.sous_echantillonnage.vecteur_t_ech_normal;
            vecteur_t_ssech = handles.sous_echantillonnage.vecteur_t_ssech;
            points_ech_normal = plot(vecteur_t_ech_normal,soi.ordonnees(vecteur_t_ech_normal),'black+','displayname','Echantillonnage normal','HitTest', 'off');
            points_ssech_normal = plot(vecteur_t_ssech,soi.ordonnees(vecteur_t_ssech),'red+','displayname','Sous-échantillonnage','HitTest', 'off');
            legend([points_ech_normal,points_ssech_normal]);
            hold off
        end
    end
    
end

