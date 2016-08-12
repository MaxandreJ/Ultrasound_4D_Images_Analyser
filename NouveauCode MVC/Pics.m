classdef Pics < handle
    %PICS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        abscisses
        ordonnees
        largeurs_a_mi_hauteur
        nombre
        graphique
%         liste
        combinaisons_indices_de_deux_pics
    end
    
    methods (Access = ?Graphique)  %Only Graphique is allowed to construct a child
        function this = Pics(graphique)
           this.graphique = graphique;
        end
     end
    
    methods
        
        function provisoire(soi)
%             graphique = handles.graphique;
% 
%             graphique.afficher(handles);
% 
%             handles=guidata(hObject);
% 
%             guidata(hObject, handles);
% 
%             graphique.creer_pics;
% 
%             pics = graphique.pics;

%             pics.detecter(handles);

            pics.afficher_largeurs_a_mi_hauteur(handles);
            handles = guidata(handles.figure1);

            pics.afficher_distances_pic_a_pic(handles);
            handles = guidata(handles.figure1);

            pics.mettre_a_jour_IHM(handles);
            handles = guidata(handles.figure1);

        end
        
        function detecter(soi,taille_fenetre_lissage,nombre_de_pics)
            try
%                 taille_fenetre_lissage = str2double(get(handles.valeur_taille_fenetre_lissage,'String'));
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
                
                soi.nombre = nombre_de_pics;
                
%                 soi.nombre_de_pics = str2double(get(handles.valeur_nombre_de_pics,'String'));



                courbe_ROI = double(soi.graphique.ordonnees);
                abscisse_courbe_ROI=double(soi.graphique.abscisses);

                if taille_fenetre_lissage~=1
                    filtre_lissage = (1/taille_fenetre_lissage)*ones(1,taille_fenetre_lissage);
                    coefficient_filtre = 1;
                    courbe_ROI = filter(filtre_lissage,coefficient_filtre,courbe_ROI);
                end

%                 axes(handles.affichage_graphique);
                hold on
                switch soi.graphique.axe_abscisses_choisi
                    case 1
                        [y_maxs,abscisses_intensites_maximales,soi.largeurs_a_mi_hauteur,~] = findpeaks(courbe_ROI,abscisse_courbe_ROI,'SortStr','descend','NPeaks',soi.nombre);
                        findpeaks(courbe_ROI,abscisse_courbe_ROI,'Annotate','extents','SortStr','descend','NPeaks',soi.nombre);
                        y_maxs=y_maxs';
                    case 2
                        [y_maxs,abscisses_intensites_maximales,soi.largeurs_a_mi_hauteur,~] = findpeaks(courbe_ROI,abscisse_courbe_ROI,'SortStr','descend','NPeaks',soi.nombre);
                        findpeaks(courbe_ROI,abscisse_courbe_ROI,'Annotate','extents','SortStr','descend','NPeaks',soi.nombre);
                    case 3
                        [y_maxs,abscisses_intensites_maximales,soi.largeurs_a_mi_hauteur,~] = findpeaks(courbe_ROI,abscisse_courbe_ROI,'SortStr','descend','NPeaks',soi.nombre);
                        findpeaks(courbe_ROI,abscisse_courbe_ROI,'Annotate','extents','SortStr','descend','NPeaks',soi.nombre);
                    case 4
                        [y_maxs,abscisses_intensites_maximales,soi.largeurs_a_mi_hauteur,~] = findpeaks(courbe_ROI,abscisse_courbe_ROI,'SortStr','descend','NPeaks',soi.nombre);
                        findpeaks(courbe_ROI,abscisse_courbe_ROI,'Annotate','extents','SortStr','descend','NPeaks',soi.nombre);
                        y_maxs=y_maxs';
                end
                legend('off');
                hold off
                
                soi.graphique.modele.largeurs_a_mi_hauteur_pics = soi.largeurs_a_mi_hauteur;
                
                %Passage de graphique.abscisses_intensites_maximales en vecteur colonne pour affichage
                soi.abscisses=abscisses_intensites_maximales';
                soi.ordonnees=y_maxs;
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
                end
                rethrow(erreurs);
            end
        end
        
%         function afficher_largeurs_a_mi_hauteur(soi,handles)
%             crochet_ouvrant = repmat('[', soi.nombre_de_pics , 1);
%             virgule = repmat(', ',soi.nombre_de_pics,1);
%             crochet_fermant = repmat(']',soi.nombre_de_pics,1);
%             soi.liste_de_pics = [crochet_ouvrant num2str(soi.abscisses) virgule ...
%                 num2str(soi.ordonnees) crochet_fermant];
%             set(handles.choix_du_pic,'String',soi.liste_de_pics);
%             pic_choisi = get(handles.choix_du_pic,'Value');
%             set(handles.lmh_affichage,'String',soi.largeurs_a_mi_hauteur(pic_choisi));
%             
%             guidata(handles.figure1,handles);
%         end
        
        function afficher_distances_pic_a_pic(soi,handles)
            if soi.nombre_de_pics>1
                set(handles.choix_de_deux_pics,'Visible','on');
                set(handles.texte_choix_de_deux_pics,'Visible','on');
                set(handles.dpap_affichage,'Visible','on');
                set(handles.texte_dpap,'Visible','on');
                set(handles.unite_dpap,'Visible','on');
                [~,nb_colonnes]=size(soi.liste_de_pics);
                liste_de_pics_cellules=mat2cell(soi.liste_de_pics,ones(1,soi.nombre_de_pics),nb_colonnes);
                soi.combinaisons_indices_de_deux_pics = combnk(1:soi.nombre_de_pics,2);
                [nb_combinaisons,~] = size(soi.combinaisons_indices_de_deux_pics);
                combinaisons_de_deux_pics=cell(nb_combinaisons,1);
                for ligne=1:nb_combinaisons
                    combinaisons_de_deux_pics{ligne} = [liste_de_pics_cellules{soi.combinaisons_indices_de_deux_pics(ligne,1),1} ...
                        ' & ' liste_de_pics_cellules{soi.combinaisons_indices_de_deux_pics(ligne,2),1}];
                end

                set(handles.choix_de_deux_pics,'String',combinaisons_de_deux_pics);
                numero_combinaison_de_deux_pics_choisie = get(handles.choix_de_deux_pics,'Value');
                combinaison_pics_choisis = soi.combinaisons_indices_de_deux_pics(numero_combinaison_de_deux_pics_choisie,:);
                x_plus_grand_des_deux_pics = soi.abscisses(combinaison_pics_choisis(2));
                x_plus_petit_des_deux_pics = soi.abscisses(combinaison_pics_choisis(1));
                set(handles.dpap_affichage,'String',num2str(abs(x_plus_grand_des_deux_pics-x_plus_petit_des_deux_pics)));
            else
                set(handles.choix_de_deux_pics,'Visible','off');
                set(handles.texte_choix_de_deux_pics,'Visible','off');
                set(handles.dpap_affichage,'Visible','off');
                set(handles.texte_dpap,'Visible','off');
                set(handles.unite_dpap,'Visible','off');
            end
            
            guidata(handles.figure1,handles);
        end
        
        function mettre_a_jour_IHM(~,handles)
            set(handles.facteur_temps_I_max,'Enable','on','BackgroundColor','white');
            set(handles.facteur_sous_echantillonnage,'Enable','on','BackgroundColor','white');
            guidata(handles.figure1,handles);
        end
    end
    
end

