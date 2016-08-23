classdef Pics < handle
    %PICS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        abscisses
        ordonnees
        largeurs_a_mi_hauteur
        nombre
        graphique
        liste
        combinaisons_indices_de_deux_pics
        liste_combinaisons_de_deux_pics
    end
    
    methods (Access = ?Graphique)  %Only Graphique is allowed to construct a child
        function this = Pics(graphique)
           this.graphique = graphique;
        end
     end
    
    methods
        
        function detecter(soi,taille_fenetre_lissage,nombre_de_pics)
            try
                if mod(taille_fenetre_lissage,2) == 0
                    erreurImpaire.message = 'Fenêtre de taille paire.';
                    erreurImpaire.identifier = 'detection_pics_Callback:taille_fenetre_paire';
                    error(erreurImpaire);
                end

                if ~soi.graphique.une_seule_courbe
                    erreurPlusieursCourbes.message = 'Plusieurs courbes affichées.';
                    erreurPlusieursCourbes.identifier = 'detection_pics_Callback:plusieurs_courbes_affichees';
                    error(erreurPlusieursCourbes);
                end
                

                courbe_ROI = double(soi.graphique.ordonnees);
                abscisse_courbe_ROI=double(soi.graphique.abscisses);

                if taille_fenetre_lissage~=1
                    filtre_lissage = (1/taille_fenetre_lissage)*ones(1,taille_fenetre_lissage);
                    coefficient_filtre = 1;
                    courbe_ROI = filter(filtre_lissage,coefficient_filtre,courbe_ROI);
                end

                hold on
                switch soi.graphique.axe_abscisses_choisi
                    case 1
                        [y_maxs,abscisses_intensites_maximales,soi.largeurs_a_mi_hauteur,~] = findpeaks(courbe_ROI,abscisse_courbe_ROI,'SortStr','descend','NPeaks',nombre_de_pics);
                        findpeaks(courbe_ROI,abscisse_courbe_ROI,'Annotate','extents','SortStr','descend','NPeaks',nombre_de_pics);
                    case 2
                        [y_maxs,abscisses_intensites_maximales,soi.largeurs_a_mi_hauteur,~] = findpeaks(courbe_ROI,abscisse_courbe_ROI,'SortStr','descend','NPeaks',nombre_de_pics);
                        findpeaks(courbe_ROI,abscisse_courbe_ROI,'Annotate','extents','SortStr','descend','NPeaks',nombre_de_pics);
                    case 3
                        [y_maxs,abscisses_intensites_maximales,soi.largeurs_a_mi_hauteur,~] = findpeaks(courbe_ROI,abscisse_courbe_ROI,'SortStr','descend','NPeaks',nombre_de_pics);
                        findpeaks(courbe_ROI,abscisse_courbe_ROI,'Annotate','extents','SortStr','descend','NPeaks',nombre_de_pics);
                    case 4
                        [y_maxs,abscisses_intensites_maximales,soi.largeurs_a_mi_hauteur,~] = findpeaks(courbe_ROI,abscisse_courbe_ROI,'SortStr','descend','NPeaks',nombre_de_pics);
                        findpeaks(courbe_ROI,abscisse_courbe_ROI,'Annotate','extents','SortStr','descend','NPeaks',nombre_de_pics);
                end
                legend('off');
                hold off
                nombre_de_pics_trouves = size(abscisses_intensites_maximales,2);
                
                if nombre_de_pics~=nombre_de_pics_trouves
                    erreur_nombre_de_pics_different.message = 'Il y a moins de pics dans le graphique que vous souhaitez en détecter.';
                    erreur_nombre_de_pics_different.identifier = 'detection_pics_Callback:nombre_de_pics_different';
                    error(erreur_nombre_de_pics_different);
                end
                
                %Passage de graphique.abscisses_intensites_maximales en vecteur colonne pour affichage
                soi.abscisses=abscisses_intensites_maximales';
                soi.ordonnees=y_maxs;
                
                soi.nombre = nombre_de_pics;
                
                %% Calcul largeur(s) à mi-hauteur
                
                crochet_ouvrant = repmat('[', soi.nombre , 1);
                virgule = repmat(', ',soi.nombre,1);
                crochet_fermant = repmat(']',soi.nombre,1);
                soi.liste = [crochet_ouvrant num2str(soi.abscisses) virgule ...
                num2str(soi.ordonnees) crochet_fermant];
                
                pic_choisi_par_defaut = 1;
                
                soi.graphique.modele.largeur_a_mi_hauteur_pic_choisi = soi.largeurs_a_mi_hauteur(pic_choisi_par_defaut);
                
                %% Calcul distance(s) pic à pic
                if soi.nombre>1
                    soi.combinaisons_indices_de_deux_pics = combnk(1:soi.nombre,2);
                    
                    
                    [~,nb_colonnes]=size(soi.liste);
                    liste_de_pics_cellules=mat2cell(soi.liste,ones(1,soi.nombre),nb_colonnes);
                    soi.combinaisons_indices_de_deux_pics = combnk(1:soi.nombre,2);
                    [nb_combinaisons,~] = size(soi.combinaisons_indices_de_deux_pics);
                    soi.liste_combinaisons_de_deux_pics=cell(nb_combinaisons,1);
                    for ligne=1:nb_combinaisons
                        soi.liste_combinaisons_de_deux_pics{ligne} = [liste_de_pics_cellules{soi.combinaisons_indices_de_deux_pics(ligne,1),1} ...
                            ' & ' liste_de_pics_cellules{soi.combinaisons_indices_de_deux_pics(ligne,2),1}];
                    end
                    
                    numero_combinaison_de_deux_pics_choisie_par_defaut =  1;

                    combinaison_pics_choisie = soi.combinaisons_indices_de_deux_pics(numero_combinaison_de_deux_pics_choisie_par_defaut,:);

                    abscisse_plus_grand_des_deux_pics = soi.abscisses(combinaison_pics_choisie(2));
                    abscisse_plus_petit_des_deux_pics = soi.abscisses(combinaison_pics_choisie(1));
                
                    soi.graphique.modele.distance_pic_a_pic_choisie = abs(abscisse_plus_grand_des_deux_pics-...
                    abscisse_plus_petit_des_deux_pics);
                    
                end
                             
            catch erreurs
                if (strcmp(erreurs.identifier,'detection_pics_Callback:taille_fenetre_paire'))
                    warndlg('Merci d''entrer une taille de fenêtre de lissage impaire.');
                    causeException = MException(erreurImpaire.identifier,erreurImpaire.message);
                    erreurs = addCause(erreurs,causeException);
                    throw(causeException);
                elseif (strcmp(erreurs.identifier,'detection_pics_Callback:plusieurs_courbes_affichees'))
                    warndlg('Merci de n''afficher qu''une seule courbe dans la partie ''affichage du graphique''.');
                    causeException = MException(erreurPlusieursCourbes.identifier,erreurPlusieursCourbes.message);
                    erreurs = addCause(erreurs,causeException);
                    throw(causeException);
                elseif (strcmp(erreurs.identifier,'detection_pics_Callback:nombre_de_pics_different'))
                    warndlg('Merci de demander de détecter moins de pics : le graphique en contient moins que vous en demandez.');
                    causeException = MException(erreur_nombre_de_pics_different.identifier,erreur_nombre_de_pics_different.message);
                    erreurs = addCause(erreurs,causeException);
                    throw(causeException);
                end
                rethrow(erreurs);
            end
        end
        
        function mettre_a_jour_largeur_a_mi_hauteur_pic_choisi(soi,pic_choisi)
            soi.graphique.modele.largeur_a_mi_hauteur_pic_choisi = soi.largeurs_a_mi_hauteur(pic_choisi);
        end
        
        function mettre_a_jour_distance_pic_a_pic_choisie(soi,numero_combinaison_de_deux_pics_choisie)
            combinaison_pics_choisie = soi.combinaisons_indices_de_deux_pics(numero_combinaison_de_deux_pics_choisie,:);

            abscisse_plus_grand_des_deux_pics = soi.abscisses(combinaison_pics_choisie(2));
            abscisse_plus_petit_des_deux_pics = soi.abscisses(combinaison_pics_choisie(1));

            soi.graphique.modele.distance_pic_a_pic_choisie = abs(abscisse_plus_grand_des_deux_pics-...
            abscisse_plus_petit_des_deux_pics);
        end
        
    end
    
end

