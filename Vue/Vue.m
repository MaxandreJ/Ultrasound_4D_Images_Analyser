classdef Vue < handle
    % La Vue est la classe qui s'occupe de l'affichage des données mises à
    % jour dans le modèle
    properties
        interface_homme_machine % aussi appelée interface graphique
        modele
        controleur
    end
    
    properties (Access = private)
        gris = [0.83,0.82,0.78] % définition de la couleur grise en encodage
                                % rouge-vert-bleu (RVB)
    end
    
    methods
        function soi = Vue(controleur)
            %Constructeur de la vue
            
            soi.controleur = controleur;
            soi.modele = controleur.modele;
            
            
            %% On instancie l'interface homme machine et on lui passe comme
            % argument le controleur
            soi.interface_homme_machine = Ultrasound_4D_Images_Analyser('controleur',soi.controleur);
            
            
            %% On pirate MATLAB en changeant ses variables Java pour que les
            % bulles d'aide ne disparaissent plus au bout de 10 secondes
            
            % On appelle une méthode statique pour obtenir un objet ToolTipManager
            tm = javax.swing.ToolTipManager.sharedInstance; 
            
            % On prend le plus grand entier signé codé sur 32 bits soit
            % 2^31 (le 32ème bit correspond au signe)
            long_temps_de_disparition = intmax('int32');
            
            % On paramètre le temps de désapparation (qui est lui-même
            % un entier signé codé sur 32-bit) pour qu'il vale
            % long_temps_de_disparation
            javaMethodEDT('setDismissDelay',tm,long_temps_de_disparition);
           
            
            %% On observe les changements de paramètres de modèle, et le cas
            % échéant, on appelle la méthode statique
            % reagir_aux_observations (elle appartient à cette classe)
            addlistener(soi.modele,'image','PostSet', ...
                @(information_propriete_modifiee,evenement)Vue.reagir_aux_observations(soi,information_propriete_modifiee,evenement));
            addlistener(soi.modele,'chemin_donnees','PostSet', ...
                @(information_propriete_modifiee,evenement)Vue.reagir_aux_observations(soi,information_propriete_modifiee,evenement));
            addlistener(soi.modele,'donnees_region_interet','PostSet', ...
                @(information_propriete_modifiee,evenement)Vue.reagir_aux_observations(soi,information_propriete_modifiee,evenement));
            addlistener(soi.modele,'entropie_region_interet','PostSet', ...
                @(information_propriete_modifiee,evenement)Vue.reagir_aux_observations(soi,information_propriete_modifiee,evenement));
            addlistener(soi.modele,'coefficient_variation_region_interet','PostSet', ...
                @(information_propriete_modifiee,evenement)Vue.reagir_aux_observations(soi,information_propriete_modifiee,evenement));
            addlistener(soi.modele,'energie_matrice_cooccurrence_region_interet','PostSet', ...
                @(information_propriete_modifiee,evenement)Vue.reagir_aux_observations(soi,information_propriete_modifiee,evenement));
            addlistener(soi.modele,'ordonnees_graphique','PostSet', ...
                @(information_propriete_modifiee,evenement)Vue.reagir_aux_observations(soi,information_propriete_modifiee,evenement));
            addlistener(soi.modele,'largeur_a_mi_hauteur_pic_choisi','PostSet', ...
                @(information_propriete_modifiee,evenement)Vue.reagir_aux_observations(soi,information_propriete_modifiee,evenement));
            addlistener(soi.modele,'distance_pic_a_pic_choisie','PostSet', ...
                @(information_propriete_modifiee,evenement)Vue.reagir_aux_observations(soi,information_propriete_modifiee,evenement));
            addlistener(soi.modele,'vecteur_temps_sous_echantillonnage','PostSet', ...
                @(information_propriete_modifiee,evenement)Vue.reagir_aux_observations(soi,information_propriete_modifiee,evenement));
            addlistener(soi.modele,'chemin_enregistrement_export_graphique','PostSet', ...
                @(information_propriete_modifiee,evenement)Vue.reagir_aux_observations(soi,information_propriete_modifiee,evenement));
            addlistener(soi.modele,'chemin_enregistrement_export_image','PostSet', ...
                @(information_propriete_modifiee,evenement)Vue.reagir_aux_observations(soi,information_propriete_modifiee,evenement));
            addlistener(soi.modele,'chemin_enregistrement_export_interface','PostSet', ...
                @(information_propriete_modifiee,evenement)Vue.reagir_aux_observations(soi,information_propriete_modifiee,evenement));
            
        end
    end
    
    methods (Static)
        function reagir_aux_observations(soi,information_propriete_modifiee,evenement)
            % Selon la propriété du modèle qui est modifiée, on affiche ce
            % qui est nécessaire dans l'interface homme machine
            
            % On récupère l'objet dont la propriété a été modifiée
            % (dans notre cas il sera toujours le modèle)
            objet_concerne = evenement.AffectedObject;
            
            % On récupère l'objet dont les propriétés définissent
            % l'interface graphique : handles (voir le site de Matlab,
            % partie GUI pour plus d'informations)
            handles = guidata(soi.interface_homme_machine);
            
            % Selon le nom de la propriété du modèle qui est modifiée, 
            % on affiche ce qui est nécessaire dans l'interface homme machine
            switch information_propriete_modifiee.Name
                
                case 'image'
                    % on se positionne dans l'axe de l'affichage de l'image
                    axes(handles.image);
                    
                    %% On opère une translation sur l'image récupérée du
                    % modèle pour passer du systèmes de coordonnées
                    % "indices de matrice" à "cartésiennes"
                    image_a_afficher=objet_concerne.image';
                    
                    %% On force l'affichage des axes de l'image
                    iptsetpref('ImshowAxesVisible','on');
                    
                    %% On affiche l'image 
                    imshow(image_a_afficher);
                    
                    %% On lie les l'échelle des données à l'échelle de
                    % couleur d'affichage par une fonction linéaire
                    set(handles.image.Children,'CDataMapping','direct');
                    
                    %% On récupère le menu contextuel créé via l'outil GUIDE
                    % et on le place de l'enfant de l'affichage de l'image
                    % Cela permet d'avoir le menu contextuel qui apparait
                    % au-dessus de l'image, et non en-dessous comme par
                    % défaut
                    menu_contextuel = get(handles.image,'UIContextMenu');
                    set(handles.image.Children,'UIContextMenu',menu_contextuel);
                    
                    %% Selon l'orientation du plan choisi (vue_choisie)
                    % on change le titre de l'image, et le nom des axes
                    switch objet_concerne.volumes.vue_choisie
                        case 0 % plan axial
                            axe1='X';
                            axe2='Y';
                            axe3='Z';
                            axe4='Temps';
                            title({'Plan axial', [axe3 '=' num2str(objet_concerne.volumes.coordonnee_axe3_selectionnee) '/' num2str(objet_concerne.volumes.taille_axes(3)) ', ' axe4 '=' num2str(objet_concerne.volumes.coordonnee_axe4_selectionnee) '/' num2str(objet_concerne.volumes.taille_axes(4))]});
                        case 1 % plan latéral
                            axe1='X';
                            axe2='Z';
                            axe3='Y';
                            axe4='Temps';
                            title({'Plan latéral',[axe3 '=' num2str(objet_concerne.volumes.coordonnee_axe3_selectionnee) '/' num2str(objet_concerne.volumes.taille_axes(3)) ', ' axe4 '=' num2str(objet_concerne.volumes.coordonnee_axe4_selectionnee) '/' num2str(objet_concerne.volumes.taille_axes(4))]});
                        case 2 % plan transverse
                            axe1='Y';
                            axe2='Z';
                            axe3='X';
                            axe4='Temps';
                            title({'Plan transverse', [axe3 '=' num2str(objet_concerne.volumes.coordonnee_axe3_selectionnee) '/' num2str(objet_concerne.volumes.taille_axes(3)) ', ' axe4 '=' num2str(objet_concerne.volumes.coordonnee_axe4_selectionnee) '/' num2str(objet_concerne.volumes.taille_axes(4))]});
                        case 3 % plan x-temps
                            axe1='Temps';
                            axe2='X';
                            axe3='Z';
                            axe4='Y';
                            title({'Plan x-temps', [axe3 '=' num2str(objet_concerne.volumes.coordonnee_axe3_selectionnee) '/' num2str(objet_concerne.volumes.taille_axes(3)) ', ' axe4 '=' num2str(objet_concerne.volumes.coordonnee_axe4_selectionnee) '/' num2str(objet_concerne.volumes.taille_axes(4))]});
                        case 4 % plan y-temps
                            axe1='Temps';
                            axe2='Y';
                            axe3='Z';
                            axe4='X';
                            title({'Plan y-temps', [axe3 '=' num2str(objet_concerne.volumes.coordonnee_axe3_selectionnee) '/' num2str(objet_concerne.volumes.taille_axes(3)) ', ' axe4 '=' num2str(objet_concerne.volumes.coordonnee_axe4_selectionnee) '/' num2str(objet_concerne.volumes.taille_axes(4))]});
                        case 5 % plan z-temps
                            axe1='Temps';
                            axe2='Z';
                            axe3='Y';
                            axe4='X';
                            title({'Plan z-temps', [axe3 '=' num2str(objet_concerne.volumes.coordonnee_axe3_selectionnee) '/' num2str(objet_concerne.volumes.taille_axes(3)) ', ' axe4 '=' num2str(objet_concerne.volumes.coordonnee_axe4_selectionnee) '/' num2str(objet_concerne.volumes.taille_axes(4))]});
                    end;
                    
                    %% On affiche la légende de l'axe des abscisses de l'image
                    if strcmp(axe1,'Temps')
                        % Si le temps est en abscisses, l'unité est le pas de temps
                        xlabel([axe1,' (en pas de temps)']);
                    else
                        % Sinon, ce sont des pixels
                        xlabel([axe1,' (en pixels)']);
                    end
                    
                    %% On affiche la légende des ordonnées de l'image
                    ylabel([axe2, ' (en pixels)']);
                    
                    %% On remet à zéro l'affichage
                    % Cela est utile si on a déjà affiché une image et fait
                    % des calculs dessus, et que l'on veut afficher une
                    % autre image
                    % Note : remettre à zéro l'affichage n'est pas une
                    % bonne méthode, j'aurais dû plutôt remettre à zéro les
                    % propriétés du modèle et laisser l'affichage se mettre
                    % à jour par les observateurs inclus dans la vue. Mais
                    % j'ai fait le mauvais choix au début, et je manque de
                    % temps maintenant pour tout changer.
                    gris = soi.gris;
                    set(handles.affichage_entropie,'String',[],'BackgroundColor',gris);
                    set(handles.affichage_coefficient_variation,'String',[],'BackgroundColor',gris);
                    set(handles.affichage_contraste,'String',[],'BackgroundColor',gris);
                    set(handles.affichage_correlation,'String',[],'BackgroundColor',gris);
                    set(handles.affichage_energie,'String',[],'BackgroundColor',gris);
                    set(handles.affichage_homogeneite,'String',[],'BackgroundColor',gris);
                    set(handles.decalage_ligne,'Enable','inactive','BackgroundColor',gris);
                    set(handles.decalage_colonne,'Enable','inactive','BackgroundColor',gris);
                    set(handles.choix_du_pic,'String',' ');
                    set(handles.valeur_taille_fenetre_lissage,'String','1','Enable','inactive','BackgroundColor',gris);
                    set(handles.valeur_nombre_de_pics,'String','1','Enable','inactive','BackgroundColor',gris);
                    set(handles.lmh_affichage,'String',[],'Enable','inactive','BackgroundColor',gris);
                    set(handles.choix_de_deux_pics,'String',' ');
                    set(handles.dpap_affichage,'String',[],'Enable','inactive','BackgroundColor',gris);
                    set(handles.facteur_temps_I_max,'Enable','inactive','BackgroundColor',gris);
                    set(handles.facteur_sous_echantillonnage,'Enable','inactive','BackgroundColor',gris);
                    set(handles.valeur_axe1Debut_graphique,'String',[],'enable','on','BackgroundColor','white');
                    set(handles.valeur_axe2Debut_graphique,'String',[],'enable','on','BackgroundColor','white');
                    set(handles.valeur_axe1Fin_graphique,'String',[],'enable','on','BackgroundColor','white');
                    set(handles.valeur_axe2Fin_graphique,'String',[],'enable','on','BackgroundColor','white');
                    
                    %% Quand on fait des modifications de l'orientation du plan,
                    % ou quand on glisse entre les plans, on doit mettre à
                    % jour l'affichage. C'est ce qu'on fait ici.
                    set(handles.valeur_axe3_image,'String',objet_concerne.volumes.coordonnee_axe3_selectionnee,'enable','on','BackgroundColor','white');
                    set(handles.valeur_axe4_image,'String',objet_concerne.volumes.coordonnee_axe4_selectionnee,'enable','on','BackgroundColor','white');
                    set(handles.axe1_graphique,'String',axe1);
                    set(handles.axe2_graphique,'String',axe2);
                    set(handles.abscisses_axe1,'String',axe1);
                    set(handles.abscisses_axe2,'String',axe2);
                    set(handles.abscisses_axe3,'String',axe3);
                    set(handles.abscisses_axe4,'String',axe4);
                    set(handles.moyenne_axe1,'String',axe1);
                    set(handles.moyenne_axe2,'String',axe2);
                    set(handles.moyenne_axe1et2,'String',[axe1, ' et ', axe2]);
                    set(handles.texte_axe3_image,'String',axe3);
                    set(handles.texte_axe4_image,'String',axe4);
                    set(handles.texte_decalage_axe1,'String',['en ', axe1]);
                    set(handles.texte_decalage_axe2,'String',['en ', axe2]);
                    set(handles.maximum_axe1_1,'String',['/',num2str(objet_concerne.volumes.taille_axes(1))]);
                    set(handles.maximum_axe1_2,'String',['/',num2str(objet_concerne.volumes.taille_axes(1))]);
                    set(handles.maximum_axe2_1,'String',['/',num2str(objet_concerne.volumes.taille_axes(2))]);
                    set(handles.maximum_axe2_2,'String',['/',num2str(objet_concerne.volumes.taille_axes(2))]);
                    set(handles.total_axe3_image,'String',['sur ', num2str(objet_concerne.volumes.taille_axes(3))]);
                    set(handles.total_axe4_image,'String',['sur ', num2str(objet_concerne.volumes.taille_axes(4))]);
                    set(handles.valeur_axe1Debut_graphique,'enable','on','BackgroundColor','white');
                    set(handles.valeur_axe2Debut_graphique,'enable','on','BackgroundColor','white');
                    set(handles.valeur_axe1Fin_graphique,'enable','on','BackgroundColor','white');
                    set(handles.valeur_axe2Fin_graphique,'enable','on','BackgroundColor','white');
                case 'chemin_donnees'
                    % On affiche le chemin des données à charger
                    % sélectionné
                    set(handles.chemin_dossier,'String',objet_concerne.chemin_donnees);
                    
                case 'donnees_region_interet'
                    %% On efface le graphique précédent
                    cla(handles.affichage_graphique,'reset');
                    
                    %% On efface la region d'intérêt tracée précédemment
                    cla(handles.image.Children);

                    if isfield(handles,'rectangle_trace')
                        delete(handles.rectangle_trace);
                    end

                    if isfield(handles,'polygone_trace')
                        delete(handles.polygone_trace);
                    end
                    
                    %% On choisit les axes de l'image
                    axes(handles.image);
                    
                    %% Si on a choisi une région d'intérêt rectangulaire
                    if isa(objet_concerne.region_interet,'Region_interet_rectangle')
                        %% On affiche les coordonnées de début et de fin 
                        % du rectangle, sur ses deux axes
                        set(handles.valeur_axe1Debut_graphique,'String',...
                            num2str(objet_concerne.region_interet.coordonnee_axe1_debut));
                        set(handles.valeur_axe2Debut_graphique,'String',...
                            num2str(objet_concerne.region_interet.coordonnee_axe2_debut));
                        set(handles.valeur_axe1Fin_graphique,'String',...
                            num2str(objet_concerne.region_interet.coordonnee_axe1_fin));
                        set(handles.valeur_axe2Fin_graphique,'String',...
                            num2str(objet_concerne.region_interet.coordonnee_axe2_fin)); 
                        
                        %% On affiche un rectangle rouge sur l'image correspondant
                        % à la région d'intérêt précédemment définie
                        handles.rectangle_trace = rectangle('Position',...
                            [objet_concerne.region_interet.coordonnee_axe1_debut...
                            objet_concerne.region_interet.coordonnee_axe2_debut...
                            objet_concerne.region_interet.largeur_axe1...
                            objet_concerne.region_interet.hauteur_axe2],'EdgeColor','r');
                        
                        %% Si on a choisit une région d'intérêt rectangulaire
                        % on permet tous les choix d'axes de moyennes et
                        % d'abscisses
                        set(handles.moyenne_axe1,'Visible','on');
                        set(handles.moyenne_axe2,'Visible','on');
                        set(handles.pas_de_moyenne,'Visible','on');
                        set(handles.abscisses_axe1,'Visible','on');
                        set(handles.abscisses_axe2,'Visible','on');
                        
                    %% Si on a choisi une région d'intérêt polygonale
                    elseif isa(objet_concerne.region_interet,'Region_interet_polygone')
                        % On utilise un bloc try... catch pour gérer les
                        % erreurs
                        try
                            % On récupère la taille courante des axes
                            taille_axes = objet_concerne.volumes.taille_axes;
                            
                            % On obtient les positions du polygone
                            positions_polygone=getPosition(objet_concerne.region_interet.polygone);
                            
                            %% On détecte si le polygone sort de l'espace de l'image
                            % et on renvoie une erreur le cas échéant
                            nb_positions_polygone = size(positions_polygone,1);
                            maximum_axe1=taille_axes(1);
                            maximum_axe2=taille_axes(2);
                            for i=1:nb_positions_polygone
                                X_pos_i=positions_polygone(i,1);
                                Y_pos_i=positions_polygone(i,2);
                                if X_pos_i<1 || X_pos_i>maximum_axe1 || Y_pos_i<1 || Y_pos_i>maximum_axe2
                                    erreur_sortie_de_image.message = 'La région d''intérêt dépasse de l''image.';
                                    erreur_sortie_de_image.identifier = 'polygone_Callback:sortie_de_image';
                                    error(erreur_sortie_de_image);
                                end
                            end
                            
                            %% On trace le polygone sur l'image
                            ordre_des_points=1:nb_positions_polygone;
                            polygone_trace=patch('Faces',ordre_des_points,'Vertices',positions_polygone,'FaceColor','none','EdgeColor','red');
                            handles.polygone_trace=polygone_trace;
                            
                            %% On efface l'objet de sélection de la région d'intérêt
                            delete(objet_concerne.region_interet.polygone);
                         catch erreurs
                            if (strcmp(erreurs.identifier,'polygone_Callback:sortie_de_image'))
                                %% Si on est sorti de l'image pendant la sélection,
                                % on envoie un avertissement et on
                                % supprimer l'objet de sélection de la
                                % région d'intérêt
                                warndlg('Merci d''entrer une région d''intérêt incluse dans l''image.');
                                causeException = MException(erreur_sortie_de_image.identifier,erreur_sortie_de_image.message);
                                erreurs = addCause(erreurs,causeException);
                                delete(objet_concerne.region_interet.polygone);
                            end
                            % On envoie les erreurs qui n'auraient pas été
                            % traitées
                            rethrow(erreurs);
                        end
                        
                        %% Si on a choisit une région d'intérêt polygonale,
                        % on ne peut pas choisir tous les axes d'abscisses
                        % et d'affichage de l'image
                        set(handles.moyenne_axe1et2,'Value',1);
                        set(handles.moyenne_axe1,'Visible','off');
                        set(handles.moyenne_axe2,'Visible','off');
                        set(handles.pas_de_moyenne,'Visible','off');

                        set(handles.abscisses_axe4,'Value',1);
                        set(handles.abscisses_axe1,'Visible','off');
                        set(handles.abscisses_axe2,'Visible','off');  
                    end
                    
                    %% Une fois la région d'intérêt choisie, on peut calculer les indices de texture
                    set(handles.affichage_entropie,'BackgroundColor','white','String',[]);
                    set(handles.affichage_coefficient_variation,'String',[],'BackgroundColor','white');
                    set(handles.affichage_contraste,'String',[],'BackgroundColor','white');
                    set(handles.affichage_correlation,'String',[],'BackgroundColor','white');
                    set(handles.affichage_energie,'String',[],'BackgroundColor','white');
                    set(handles.affichage_homogeneite,'String',[],'BackgroundColor','white');
                    set(handles.decalage_ligne,'Enable','on','BackgroundColor','white');
                    set(handles.decalage_colonne,'Enable','on','BackgroundColor','white');
                    
                    %% On remet à zéro l'affichage des paramètres futurs dans le cas
                    % où on n'est pas à la première image affichée
                    % Note : remettre à zéro l'affichage n'est pas une
                    % bonne méthode, j'aurais dû plutôt remettre à zéro les
                    % propriétés du modèle et laisser l'affichage se mettre
                    % à jour par les observateurs inclus dans la vue. Mais
                    % j'ai fait le mauvais choix au début, et je manque de
                    % temps maintenant pour tout changer.
                    gris = soi.gris;
                    set(handles.facteur_temps_I_max,'Enable','inactive','BackgroundColor',gris);
                    set(handles.facteur_sous_echantillonnage,'Enable','inactive','BackgroundColor',gris);
                    set(handles.valeur_taille_fenetre_lissage,'String','1','Enable','inactive','BackgroundColor',gris);
                    set(handles.valeur_nombre_de_pics,'String','1','Enable','inactive','BackgroundColor',gris);
                    set(handles.choix_du_pic,'String',' ');
                    set(handles.lmh_affichage,'String',[],'Enable','inactive','BackgroundColor',gris);
                    set(handles.choix_de_deux_pics,'String',' ');
                    set(handles.dpap_affichage,'String',[],'Enable','inactive','BackgroundColor',gris);
                    
                case 'entropie_region_interet'
                    % On affiche l'entropie calculée
                    set(handles.affichage_entropie,'String',num2str(objet_concerne.entropie_region_interet));
                case 'coefficient_variation_region_interet'
                    % On affiche le coefficient de variation dans la région
                    % d'intérêt
                    set(handles.affichage_coefficient_variation,'String',num2str(objet_concerne.coefficient_variation_region_interet));
                case 'energie_matrice_cooccurrence_region_interet'
                    % On affiche les indices calculés sur la matrice de cooccurrences
                    set(handles.affichage_energie,'String',num2str(objet_concerne.energie_matrice_cooccurrence_region_interet));
                    set(handles.affichage_contraste,'String',num2str(objet_concerne.contraste_matrice_cooccurrence_region_interet));
                    set(handles.affichage_correlation,'String',num2str(objet_concerne.correlation_matrice_cooccurrence_region_interet));
                    set(handles.affichage_homogeneite,'String',num2str(objet_concerne.homogeneite_matrice_cooccurrence_region_interet));
                case 'ordonnees_graphique'
                    
                    
                    %% On efface la/les courbe(s) précédentes
                    cla(handles.affichage_graphique);
                    
                    %% On affiche la/les courbes
                    axes(handles.affichage_graphique);
                    hold on
                    plot(objet_concerne.graphique.abscisses,objet_concerne.graphique.ordonnees,'displayname','Courbe originale','HitTest', 'off');
                    if get(handles.points_de_donnees,'Value')
                        plot(objet_concerne.graphique.abscisses,objet_concerne.graphique.ordonnees,'black+','displayname','Point de données','HitTest', 'off');
                    end
                    hold off
                    
                    %% On affiche le titre
                   
                    % Selon le nombre de courbes, on affiche un titre
                    % différent (au singulier ou au pluriel)
                    if objet_concerne.graphique.une_seule_courbe
                        titre='Courbe d''intensité';
                    else
                        titre='Courbes d''intensité';
                    end
                    
                    title(titre);
                    
                    %% On affiche la légende des abscisses
                    
                    % Explication sur la variable ordre_axes :
                    % 1 représente X, 2 -> Y, 3 -> Z, 4 -> Temps
                    % L'ordre des axes est signifié par l'ordre
                    % dans la liste qu'est la variable ordre_axes.
                    % Par exemple, ordre_axes = [1,2,3,4] correspond à une
                    % image affichée avec en abscisses X, en
                    % ordonnées Y, en 3ème dimension Z
                    % et en 4ème dimension le temps
                    ordre_axes=objet_concerne.volumes.ordre_axes;
                    
                    axe_abscisses_choisi = objet_concerne.graphique.axe_abscisses_choisi;
                    
                    legende_abscisses = ...
                                  objet_concerne...
                                  .graphique...
                                  .noms_axes_legende_abscisses(...
                                  ordre_axes(axe_abscisses_choisi));
                    
                    xlabel(legende_abscisses);
                    
                    %% On affiche la légende des ordonnees
                    
                    switch objet_concerne.graphique.axe_moyenne_choisi
                        case '1'
                            legende_ordonnees={'Intensité (en niveaux)',...
                        ['moyennée sur ',objet_concerne.graphique.noms_axes(ordre_axes(1)),' dans la région d''intérêt']};
                        case '2'
                            legende_ordonnees={'Intensité (en niveaux)',...
                        ['moyennée sur ',objet_concerne.graphique.noms_axes(ordre_axes(2)),' dans la région d''intérêt']};
                        case '1 et 2'
                            legende_ordonnees={'Intensité (en niveaux)',...
                        ['moyennée sur ',objet_concerne.graphique.noms_axes(ordre_axes(1)),' et ',objet_concerne.graphique.noms_axes(ordre_axes(2))],...
                        ' dans la région d''intérêt'};
                        case 'pas de moyenne'
                            legende_ordonnees='Intensité (en niveaux)';
                    end
                     
                    ylabel(legende_ordonnees);
                    
                    %% On indique les nouvelles fonctionnalités disponibles dans l'interface_homme_machine
                    
                    set(handles.choix_du_pic,'enable','on','BackgroundColor','white');
                    set(handles.choix_de_deux_pics,'enable','on','BackgroundColor','white');
                    set(handles.lmh_affichage,'BackgroundColor','white');
                    set(handles.dpap_affichage,'BackgroundColor','white');
                    set(handles.valeur_taille_fenetre_lissage,'enable','on','BackgroundColor','white');
                    set(handles.valeur_nombre_de_pics,'enable','on','BackgroundColor','white');
                    
                    %% On enlève les fonctionnalités pas encore disponibles
                    % Note : remettre à zéro l'affichage n'est pas une
                    % bonne méthode, j'aurais dû plutôt remettre à zéro les
                    % propriétés du modèle et laisser l'affichage se mettre
                    % à jour par les observateurs inclus dans la vue. Mais
                    % j'ai fait le mauvais choix au début, et je manque de
                    % temps maintenant pour tout changer.
                    
                    gris = soi.gris;
                    set(handles.facteur_temps_I_max,'Enable','inactive','BackgroundColor',gris);
                    set(handles.facteur_sous_echantillonnage,'Enable','inactive','BackgroundColor',gris);
                    
                case 'largeur_a_mi_hauteur_pic_choisi'
                    
                    %% On affiche la liste des pics et la largeur à mi hauteur du pic choisi
                    set(handles.choix_du_pic,'String',objet_concerne.graphique.pics.liste);
                    set(handles.lmh_affichage,'String', objet_concerne.largeur_a_mi_hauteur_pic_choisi);
                    
                    %% on montre que l'on peut maintenant sous-échantillonner les données
                    set(handles.facteur_temps_I_max,'Enable','on','BackgroundColor','white');
                    set(handles.facteur_sous_echantillonnage,'Enable','on','BackgroundColor','white');
                    
                case 'distance_pic_a_pic_choisie'
                    
                    %% On affiche la liste des combinaisons de pics 
                    %et la distance pics à pics de la combinaison choisie
                    set(handles.choix_de_deux_pics,'String',objet_concerne.graphique.pics.liste_combinaisons_de_deux_pics);
                    set(handles.dpap_affichage,'String',objet_concerne.distance_pic_a_pic_choisie);
                    
                case 'vecteur_temps_sous_echantillonnage'
                    %% On efface le graphique précédent
                    cla(handles.affichage_graphique);
                    
                    %% On affiche le sous-échantillonnage par des points
                    % de données sur le graphique
                    % Quand il y a un point, cela veut dire que ce pas de
                    % temps est sauvegardé.
                    % Qu'il n'y en a pas, le pas de temps n'est pas
                    % sauvegardé.

                    axes(handles.affichage_graphique);
                    hold on
                    %% On réaffiche la courbe originale
                    plot(objet_concerne.graphique.abscisses,objet_concerne.graphique.ordonnees,'displayname','Courbe originale','HitTest', 'off');
                    
                    %% On récupère les paramètres du sous-échantillonnage
                    vecteur_t_ech_normal = objet_concerne.vecteur_temps_echantillonnage_normal;
                    vecteur_t_ssech = objet_concerne.vecteur_temps_sous_echantillonnage;
                    
                    %% Si le point est noir, il correspond à la partie de
                    % l'enregistrement non sous-échantilloné
                    points_ech_normal = plot(vecteur_t_ech_normal,objet_concerne.graphique.ordonnees(vecteur_t_ech_normal),'black+','displayname','Pas sous-échantillonné','HitTest', 'off');
                    
                    %% Si il est rouge, il appartient à la partie de
                    % l'enregistrement sous-échantillonné
                    points_ssech = plot(vecteur_t_ssech,objet_concerne.graphique.ordonnees(vecteur_t_ssech),'red+','displayname','Sous-échantillonné','HitTest', 'off');
                    legend([points_ech_normal,points_ssech]);
                    hold off
                    
                case 'chemin_enregistrement_export_graphique'
                    %% On enregistre le graphique
                    export_fig(handles.affichage_graphique, objet_concerne.chemin_enregistrement_export_graphique);
                case 'chemin_enregistrement_export_image'
                    %% On enregistre l'image
                    export_fig(handles.image, objet_concerne.chemin_enregistrement_export_image);
                case 'chemin_enregistrement_export_interface'
                    %% On enregistre l'interface entière
                    export_fig(handles.figure1, objet_concerne.chemin_enregistrement_export_interface);
                    
            end
        %% On enregistre les modifications faites à l'interface
        guidata(handles.figure1,handles);
        end
        
        function aide
            % On affiche un message d'aide
            
            msgbox({'Les plans sont définis par rapport à la sonde et non par rapport à l''objet étudié (voir schémas sur le README de mon répertoire Github).',... 
                'Le passage entre les orientations de plans est permise par les touches du clavier suivantes :', ...
            '0 : plan axial (Y en ordonnées et X en abscisses) ;', ...
            '1 : plan latéral (Z en ordonnées et X en abscisses) ;', ...
            '2 : plan transverse (Z en ordonnées et Y en abscisses);', ...
            '3 : plan x-temps (X en ordonnées et le temps en abscisses);', ...
            '4 : plan y-temps (Y en ordonnées et le temps en abscisses);', ...
            '5 : plan z-temps (Z en ordonnées et le temps en abscisses).', ...
            '',...
            'Pour une même orientation de plan, on peut glisser entre les plans par les flèches multidirectionnelles du clavier :',...
            'flèches gauche et droite pour glisser selon le premier axe mentionné dans le titre de l''image ;',...
            'flèches bas et haut pour glisser selon le deuxième axe mentionné dans le titre de l''image.'})
        end
        
    end
    
    methods
        function choisir_axe_image(soi)
            % On sélectionne les axes de l'image (pour affichage)
            
            handles = guidata(soi.interface_homme_machine);
            axes(handles.image);
        end
        
        function choisir_axe_affichage_graphique(soi)
            % On sélectionne les axes du graphique (pour affichage)
            
            handles = guidata(soi.interface_homme_machine);
            axes(handles.affichage_graphique);
        end
        
        function mise_a_un_liste_de_pics(soi)
            % On sélectionne le premier pic de la liste des choix de pics
            % Pour éviter l'erreur suivante : je choisis le deuxième pic
            % détecté, puis je veux détecter un seul pic : mon choix du
            % deuxième pic n'est plus valide
            % Note : il aurait mieux fallu faire une remise à zéro au sein
            % du modèle
            
            handles = guidata(soi.interface_homme_machine);
            set(handles.choix_du_pic,'Value',1);
        end
        
        function mise_a_un_liste_de_combinaisons_de_deux_pics(soi)
            % On sélectionne la première combinaison de pics
            % de la liste des combinaisons de pics
            % Note : il aurait mieux fallu faire une remise à zéro au sein
            % du modèle
            handles = guidata(soi.interface_homme_machine);
            set(handles.choix_de_deux_pics,'Value',1);
        end
        
    end
    
end