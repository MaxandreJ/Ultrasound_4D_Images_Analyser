classdef (Abstract) Volumes < handle
    % Classe abstraite contenant les propriétés et méthodes communes aux
    % différentes format de fichiers à charger contenant des volumes
    
    
    properties
        modele
        donnees % L'ensemble des données, soit les données 4D
        ordre_axes = [1,2,3,4] % 1 représente X, 2 -> Y, 3 -> Z, 4 -> Temps
                                % L'ordre des axes est signifié par l'ordre
                                % dans la liste.
                                % Par exemple, [1,2,3,4] correspond à une
                                % image affichée avec en abscisses X, en
                                % ordonnées Y, en 3ème dimension Z
                                % et en 4ème dimension le temps
        taille_axes_enregistree % Pour ne pas avoir à calculer toujours la
                                % taille des axes, on l'enregistre dans
                                % cette propriété
        coordonnee_axe3_selectionnee = 1
        coordonnee_axe4_selectionnee = 1
        chemin_a_afficher
        vue_choisie = 0
    end
    
    properties (Dependent)
        taille_axes
    end
    
    methods (Abstract)
        charger(soi) % La manière de charger est propre à chacun des formats
                    % cette méthode est donc abstraite et implémentée dans
                    % les classes concrètes qui héritent de cette classe
    end
    
    methods
        
        function valeur = get.taille_axes(soi)
            % Pour obtenir la taille des axes actuelle à chaque appel de
            % soi.taille_axes (propriété calculée au moment où on veut
            % savoir sa valeur)
           valeur=[size(soi.donnees,1),...
               size(soi.donnees,2),...
               size(soi.donnees,3),...
               size(soi.donnees,4)];
           % Pour éviter des calculs permanents, on l'enregistre dans une
           % propriété
           soi.taille_axes_enregistree=valeur;
        end
        
        
        
        function mettre_a_jour_image_clavier(soi,eventdata)
            % Réagit à une pression d'un bouton sur le clavier et met à
            % jour l'image en conséquence
            
            donnees_4D = soi.donnees;
            
            orientation_plan_affichage_actuel = soi.vue_choisie;

            % On ajoute la possibilité à l'utilisateur de choisir l'orientation de son plan et
            % naviguer entre les images au moyen des flèches multidirectionnelles
            if soi.coordonnee_axe3_selectionnee>=1 && soi.coordonnee_axe3_selectionnee<=soi.taille_axes(3) && soi.coordonnee_axe4_selectionnee>=1 && soi.coordonnee_axe4_selectionnee<=soi.taille_axes(4)
                switch eventdata.Key
                    %% Naviguer entre les images à l'aide des flèches multidirectionnelles
                    case  'rightarrow'
                        soi.coordonnee_axe3_selectionnee=soi.coordonnee_axe3_selectionnee+1;
                        if soi.coordonnee_axe3_selectionnee>soi.taille_axes(3)
                            soi.coordonnee_axe3_selectionnee=soi.taille_axes(3);
                        end
                    case 'leftarrow'
                        soi.coordonnee_axe3_selectionnee=soi.coordonnee_axe3_selectionnee-1;
                        if soi.coordonnee_axe3_selectionnee<1
                            soi.coordonnee_axe3_selectionnee=1;
                        end
                    case 'downarrow'
                        soi.coordonnee_axe4_selectionnee=soi.coordonnee_axe4_selectionnee-1;
                        if soi.coordonnee_axe4_selectionnee<1
                            soi.coordonnee_axe4_selectionnee=1;
                        end
                    case 'uparrow'
                        soi.coordonnee_axe4_selectionnee=soi.coordonnee_axe4_selectionnee+1;
                        if soi.coordonnee_axe4_selectionnee>soi.taille_axes(4)
                            soi.coordonnee_axe4_selectionnee=soi.taille_axes(4);
                        end
                    %% Naviguer entre les orientation de plans à l'aide des chiffres du clavier
                    % J'ai pris cette fonction quelque part, et j'ai eu
                    % beau renommer tous les noms de variables en des
                    % choses compréhensibles, la logique du type qui l'a
                    % écrit m'échappe. Recodez la fonction si vous en avez
                    % l'envie...
                    case {'0','numpad0'}
                        %% Si l'orientation du plan d'affichage n'est pas 0 (plan axial)
                        if orientation_plan_affichage_actuel ~= 0;
                            %% Ligne incompréhensible due à un codage catastrophique de celui qui a
                            % originalement écrit la fonction de changement
                            % d'image... j'ai abandonné la compréhension et
                            % n'ai pas eu le courage de réécrire le code
                            donnees_4D = Volumes.permuter(donnees_4D,orientation_plan_affichage_actuel);
                        end;
                        %% après modification, le plan d'affichage est 0
                        % (plan axial)
                        orientation_plan_affichage_actuel = 0;
                        %% L'ordre des axes a changé, on le met à jour
                        soi.ordre_axes = [1,2,3,4]; % plan axial (x-y)
                    case {'1','numpad1'}
                        %% Si l'utilisateur a tapé 1 (plan latéral), 
                        % on choisit 1  comme plan d'affichage
                        orientation_plan_affichage_choisi = 1;
                        %% Si le plan d'affichage 1 n'a pas déjà été choisi...
                        if orientation_plan_affichage_choisi ~= orientation_plan_affichage_actuel
                            % On réordonne les axes des données en
                            % [1,2,3,4]
                            donnees_4D = Volumes.revenir_ordre_axes_original(donnees_4D,orientation_plan_affichage_actuel);
                            % Puis on applique la permutation vers l'axe
                            % choisi
                            donnees_4D = Volumes.permuter(donnees_4D,orientation_plan_affichage_choisi);
                        end;
                        % L'orientation du plan de l'affichage est
                        % maintenant 1 (plan latéral)
                        orientation_plan_affichage_actuel = 1;
                        % L'ordre des axes a changé, on le met à jour
                        soi.ordre_axes = [1,3,2,4]; % plan latéral (x-z)
                    case {'2','numpad2'}
                        %% Voir cas 1
                        orientation_plan_affichage_choisi = 2;
                        if orientation_plan_affichage_choisi ~= orientation_plan_affichage_actuel
                            donnees_4D = Volumes.revenir_ordre_axes_original(donnees_4D,orientation_plan_affichage_actuel);
                            donnees_4D = Volumes.permuter(donnees_4D,orientation_plan_affichage_choisi);
                        end;
                        orientation_plan_affichage_actuel = 2;
                        soi.ordre_axes = [2,3,1,4]; % plan transverse (y-z)
                    case {'3','numpad3'}
                        %% Voir cas 1
                        orientation_plan_affichage_choisi = 3;
                        if orientation_plan_affichage_choisi ~= orientation_plan_affichage_actuel
                            donnees_4D = Volumes.revenir_ordre_axes_original(donnees_4D,orientation_plan_affichage_actuel);
                            donnees_4D = Volumes.permuter(donnees_4D,orientation_plan_affichage_choisi);
                        end;
                        orientation_plan_affichage_actuel = 3;
                        soi.ordre_axes = [4,1,3,2]; % plan temps-x
                    case {'4','numpad4'}
                        %% Voir cas 1
                        orientation_plan_affichage_choisi = 4;
                        if orientation_plan_affichage_choisi ~= orientation_plan_affichage_actuel
                            donnees_4D = Volumes.revenir_ordre_axes_original(donnees_4D,orientation_plan_affichage_actuel);
                            donnees_4D = Volumes.permuter(donnees_4D,orientation_plan_affichage_choisi);
                        end;
                        orientation_plan_affichage_actuel = 4;
                        soi.ordre_axes = [4,2,3,1]; % plan temps-y
                    case {'5','numpad5'}
                        %% Voir cas 1
                        orientation_plan_affichage_choisi = 5;
                        if orientation_plan_affichage_choisi ~= orientation_plan_affichage_actuel
                            donnees_4D = Volumes.revenir_ordre_axes_original(donnees_4D,orientation_plan_affichage_actuel);
                            donnees_4D = Volumes.permuter(donnees_4D,orientation_plan_affichage_choisi);
                        end;
                        orientation_plan_affichage_actuel = 5;
                        soi.ordre_axes = [4,3,2,1]; % plan temps-z
                end
            end
            
            %% On donne à la propriété donnees le fruit de nos changements
            % d'axes
            soi.donnees = donnees_4D;
            
            %% Si après le changement de vue on dépasse la taille des
            % nouveaux axes avec les coordonnées sélectionnées, alors on
            % rédéfinit les coordonnées sélectionnées comme étant les
            % maximums de la taille des nouveaux axes
            if soi.coordonnee_axe3_selectionnee>soi.taille_axes(3)
                soi.coordonnee_axe3_selectionnee=soi.taille_axes(3);
            end
            
            if soi.coordonnee_axe4_selectionnee>soi.taille_axes(4)
                soi.coordonnee_axe4_selectionnee=soi.taille_axes(4);
            end
            
            %% On enregistre le résultat des changements
            soi.vue_choisie = orientation_plan_affichage_actuel;
            soi.modele.image = donnees_4D(:,:,soi.coordonnee_axe3_selectionnee,soi.coordonnee_axe4_selectionnee);
        end
         
        function mettre_a_jour_image_bouton(soi,coordonnee_axe3_selectionnee,coordonnee_axe4_selectionnee)
            % Met à jour l'image si on a entré les coordonnées dans l'interface
            % graphique
            soi.coordonnee_axe3_selectionnee=coordonnee_axe3_selectionnee;
            soi.coordonnee_axe4_selectionnee=coordonnee_axe4_selectionnee;
            soi.modele.image = soi.donnees(:,:,soi.coordonnee_axe3_selectionnee,soi.coordonnee_axe4_selectionnee);
         end
        
    end
    
    methods (Static)
        
        function volumes_permutes = permuter(volumes_originaux,orientation_plan_affichage_choisi)
            % Permet de permuter les axes des volumes_originaux de sorte
            % qu'ils changent l'ordre de leurs axes de sorte que l'orientation du plan
            % affiché soit orientation_plan_affichage_choisi 
            % Les volumes ainsi permutés seront retournés par la fonction.
            
            %% En fonction de l'orientation de plan choisie pour l'affichage,
            % on définit l'ordre des axes voulu par l'utilisateur
            switch orientation_plan_affichage_choisi
                case 0
                    ordre_axes_desire = [1,2,3,4]; % plan axial (x-y)
                case 1
                    ordre_axes_desire = [1,3,2,4]; % plan latéral (x-z)
                case 2
                    ordre_axes_desire = [2,3,1,4]; % plan transverse (y-z)
                case 3
                    ordre_axes_desire = [4,1,3,2]; % plan temps-x
                case 4
                    ordre_axes_desire = [4,2,3,1]; % plan temps-y
                case 5
                    ordre_axes_desire = [4,3,2,1]; % plan temps-z
            end;
            
            %% Opération qui permute les axes des volumes de sorte 
            % qu'ils correspondent à l'ordre des axes désiré
            volumes_permutes = ipermute(volumes_originaux,ordre_axes_desire);
            
        end
        
        function volumes_originaux = revenir_ordre_axes_original(volumes_permutes,orientation_plan_affichage_actuel)
            % Permet de restaurer les volumes_originaux à partir des
            % volumes_permutes et de l'orientation du plan affiché
            % actuellement. Les volumes originaux sont retournés par 
            % la fonction.
            
            %% En fonction de l'orientation de plan de l'affichage actuel,
            % on définit l'ordre des axes auquel il correspond
            switch orientation_plan_affichage_actuel
                case 0
                    ordre_axes_actuel = [1,2,3,4]; % plan axial (x-y)
                case 1
                    ordre_axes_actuel = [1,3,2,4]; % plan latéral (x-z)
                case 2
                    ordre_axes_actuel = [2,3,1,4]; % plan transverse (y-z)
                case 3
                    ordre_axes_actuel = [4,1,3,2]; % plan temps-x
                case 4
                    ordre_axes_actuel = [4,2,3,1]; % plan temps-y
                case 5
                    ordre_axes_actuel = [4,3,2,1]; % plan temps-z
            end;
            
            %% Opération qui permute les axes des volumes de sorte 
            % que les volumes_permutes selon l'ordre des axes actuel
            % reviennent à leur ordre des axes original
            volumes_originaux = permute(volumes_permutes,ordre_axes_actuel);
        end        
        
    end
    
end


