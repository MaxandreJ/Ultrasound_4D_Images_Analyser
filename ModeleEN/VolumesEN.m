classdef (Abstract) Volumes < handle
    % Classe abstraite contenant les propriétés et méthodes communes aux
    % différentes format de fichiers à charger contenant des volumes
    
    % Abstract class which contains the properties and the methods that the
    % various file formats that have to be loaded have in common
    properties
        modele
        donnees % L'ensemble des données, soit les données 4D
        
                % The whole data, that is to say the 4D data
        ordre_axes = [1,2,3,4] % 1 représente X, 2 -> Y, 3 -> Z, 4 -> Temps
                                % L'ordre des axes est signifié par l'ordre
                                % dans la liste.
                                % Par exemple, [1,2,3,4] correspond à une
                                % image affichée avec en abscisses X, en
                                % ordonnées Y, en 3ème dimension Z
                                % et en 4ème dimension le temps
                                
                                % 1 represents X, 2->Y, 3->Z, 4->time
                                % the order of the axes is given by the
                                % order in the list
                                % For instance, [1,2,3,4] corresponds to an
                                % image displayed with X as X-axis, Y as
                                % Y-axis, Z as 3rd dimensio and time as 4th
                                % dimension
        taille_axes_enregistree % Pour ne pas avoir à calculer toujours la
                                % taille des axes, on l'enregistre dans
                                % cette propriété
                                
                                % In order not to have to compute the size
                                % of the axes all the time, we save it in
                                % this property
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
                    
                    % The way that the data is loaded is specific to each
                    % file format. This method is therefore abstract and is
                    % implemented in the concrete classes which inherit
                    % this class
    end
    
    methods
        
        function valeur = get.taille_axes(soi)
            % Pour obtenir la taille des axes actuelle à chaque appel de
            % soi.taille_axes (propriété calculée au moment où on veut
            % savoir sa valeur)
            
            % In order to get the actual size of the axes at each call of
            % soi.taille_axes (property computed at the moment when one
            % wants to know its value)
           valeur=[size(soi.donnees,1),...
               size(soi.donnees,2),...
               size(soi.donnees,3),...
               size(soi.donnees,4)];
           % Pour éviter des calculs permanents, on l'enregistre dans une
           % propriété
           
           % Saves in a property in order to avoid perpetual computings
           soi.taille_axes_enregistree=valeur;
        end
        
        
        
        function mettre_a_jour_image_clavier(soi,eventdata)
            % Réagit à une pression d'un bouton sur le clavier et met à
            % jour l'image en conséquence
            
            % Reacts to the strike of a keyboard key and updates the image
            % accordingly
            
            donnees_4D = soi.donnees;
            
            orientation_plan_affichage_actuel = soi.vue_choisie;

            % On ajoute la possibilité à l'utilisateur de choisir l'orientation de son plan et
            % naviguer entre les images au moyen des flèches multidirectionnelles
            
            % Adds the user the option to choose the orientation of the
            % plane and to scroll between the images using the arrow keys
            if soi.coordonnee_axe3_selectionnee>=1 && soi.coordonnee_axe3_selectionnee<=soi.taille_axes(3) && soi.coordonnee_axe4_selectionnee>=1 && soi.coordonnee_axe4_selectionnee<=soi.taille_axes(4)
                switch eventdata.Key
                    %% Naviguer entre les images à l'aide des flèches multidirectionnelles
                    
                    % Scroll between images using the arrow keys
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
                    
                    % Scroll through the orientation of the planes using
                    % the digit keys
                    case {'0','numpad0'}
                        %% Si l'orientation du plan d'affichage n'est pas 0 (plan axial)
                        
                        % If the orientation of the displaying plane is not
                        % 0 (axial plane)
                        if orientation_plan_affichage_actuel ~= 0;
                            %% On revient à l'orientation 0
                            
                            % Comes back to the 0 orientation
                            donnees_4D = Volumes.revenir_ordre_axes_original(donnees_4D,orientation_plan_affichage_actuel);
                        end;
                        %% après modification, le plan d'affichage est 0
                        % (plan axial)
                        
                        % After modificatin, the diplaying plane is 0
                        % (axial plane)
                        orientation_plan_affichage_actuel = 0;
                        %% L'ordre des axes a changé, on le met à jour
                        
                        % Updates the changes order of the axes
                        soi.ordre_axes = [1,2,3,4]; % plan axial (x-y)
                                                    % axial plane (x-y)
                    case {'1','numpad1'}
                        %% Si l'utilisateur a tapé 1 (plan latéral), 
                        % on choisit 1  comme plan d'affichage
                        
                        % If the used has typed 1 (lateral plane), we
                        % choose 1 as the displaying plane
                        orientation_plan_affichage_choisi = 1;
                        %% Si le plan d'affichage 1 n'a pas déjà été choisi...
                        
                        % If the displaying plane has not yet been
                        % chosen...
                        if orientation_plan_affichage_choisi ~= orientation_plan_affichage_actuel
                            % On réordonne les axes des données en
                            % [1,2,3,4]
                            
                            % We re-order the data axes in [1,2,3,4]
                            donnees_4D = Volumes.revenir_ordre_axes_original(donnees_4D,orientation_plan_affichage_actuel);
                            % Puis on applique la permutation vers l'axe
                            % choisi
                            
                            % Then we apply the permutation towards the
                            % chosen axis
                            donnees_4D = Volumes.permuter(donnees_4D,orientation_plan_affichage_choisi);
                        end;
                        % L'orientation du plan de l'affichage est
                        % maintenant 1 (plan latéral)
                        
                        % The orientation of the displaying plane is now 1
                        % (lateral plane)
                        orientation_plan_affichage_actuel = 1;
                        % L'ordre des axes a changé, on le met à jour
                        
                        % Updates the order of the axes, which has changed
                        soi.ordre_axes = [1,3,2,4]; % plan latéral (x-z)
                                                    % lateral plane (x-z)
                    case {'2','numpad2'}
                        %% Voir cas 1
                        
                        % See case 1
                        orientation_plan_affichage_choisi = 2;
                        if orientation_plan_affichage_choisi ~= orientation_plan_affichage_actuel
                            donnees_4D = Volumes.revenir_ordre_axes_original(donnees_4D,orientation_plan_affichage_actuel);
                            donnees_4D = Volumes.permuter(donnees_4D,orientation_plan_affichage_choisi);
                        end;
                        orientation_plan_affichage_actuel = 2;
                        soi.ordre_axes = [2,3,1,4]; % plan transverse (y-z)
                                                    % transverse plane
                                                    % (y-z)
                    case {'3','numpad3'}
                        %% Voir cas 1
                        
                        % See case 1
                        orientation_plan_affichage_choisi = 3;
                        if orientation_plan_affichage_choisi ~= orientation_plan_affichage_actuel
                            donnees_4D = Volumes.revenir_ordre_axes_original(donnees_4D,orientation_plan_affichage_actuel);
                            donnees_4D = Volumes.permuter(donnees_4D,orientation_plan_affichage_choisi);
                        end;
                        orientation_plan_affichage_actuel = 3;
                        soi.ordre_axes = [4,1,3,2]; % plan temps-x
                                                    % plane time-x
                    case {'4','numpad4'}
                        %% Voir cas 1
                        
                        % See case 1
                        orientation_plan_affichage_choisi = 4;
                        if orientation_plan_affichage_choisi ~= orientation_plan_affichage_actuel
                            donnees_4D = Volumes.revenir_ordre_axes_original(donnees_4D,orientation_plan_affichage_actuel);
                            donnees_4D = Volumes.permuter(donnees_4D,orientation_plan_affichage_choisi);
                        end;
                        orientation_plan_affichage_actuel = 4;
                        soi.ordre_axes = [4,2,3,1]; % plan temps-y
                                                    % plane time-y
                    case {'5','numpad5'}
                        %% Voir cas 1
                        
                        % See case 1
                        orientation_plan_affichage_choisi = 5;
                        if orientation_plan_affichage_choisi ~= orientation_plan_affichage_actuel
                            donnees_4D = Volumes.revenir_ordre_axes_original(donnees_4D,orientation_plan_affichage_actuel);
                            donnees_4D = Volumes.permuter(donnees_4D,orientation_plan_affichage_choisi);
                        end;
                        orientation_plan_affichage_actuel = 5;
                        soi.ordre_axes = [4,3,2,1]; % plan temps-z
                                                    % plane time-z
                end
            end
            
            %% On donne à la propriété donnees le fruit de nos changements
            % d'axes
            
            % The property "donneesé is given the result of the axes
            % changes
            soi.donnees = donnees_4D;
            
            %% Si après le changement de vue on dépasse la taille des
            % nouveaux axes avec les coordonnées sélectionnées, alors on
            % rédéfinit les coordonnées sélectionnées comme étant les
            % maximums de la taille des nouveaux axes
            
            % If after changing the view the new coordinates exceed the size of
            % the new axes, then the selected coordinates are re-defined as
            % the maximum size of the new axes
            if soi.coordonnee_axe3_selectionnee>soi.taille_axes(3)
                soi.coordonnee_axe3_selectionnee=soi.taille_axes(3);
            end
            
            if soi.coordonnee_axe4_selectionnee>soi.taille_axes(4)
                soi.coordonnee_axe4_selectionnee=soi.taille_axes(4);
            end
            
            %% On enregistre le résultat des changements
            
            % Saves the results of the changes
            soi.vue_choisie = orientation_plan_affichage_actuel;
            soi.modele.image = donnees_4D(:,:,soi.coordonnee_axe3_selectionnee,soi.coordonnee_axe4_selectionnee);
        end
         
        function mettre_a_jour_image_bouton(soi,coordonnee_axe3_selectionnee,coordonnee_axe4_selectionnee)
            % Met à jour l'image si on a entré les coordonnées dans l'interface
            % graphique
            
            % Upgrades the image if the user has entered the coordinates in
            % the graphic interface
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
            
            % Enables to swap the axes of the "volumes_originaux" (original
            % volumes) so that they change the order of their axes so that
            % the orientation of the diplayed plane is
            % orientation_plan_affichage_choisi
            % The function returns the volumes that have been thus swapped
            %% En fonction de l'orientation de plan choisie pour l'affichage,
            % on définit l'ordre des axes voulu par l'utilisateur
            
            % Defines the order of the axes required by the user, depending
            % on the orientation of the plane chosen for display
            switch orientation_plan_affichage_choisi
                case 0
                    ordre_axes_desire = [1,2,3,4]; % plan axial (x-y)
                    
                                                   % axial plane (x-y)
                case 1
                    ordre_axes_desire = [1,3,2,4]; % plan latéral (x-z)
                                                    
                                                   % lateral plane (x-z)
                case 2
                    ordre_axes_desire = [2,3,1,4]; % plan transverse (y-z)
                                                   
                                                   % transverse plane (y-z)
                case 3
                    ordre_axes_desire = [4,1,3,2]; % plan temps-x
                    
                                                   % time-x plane
                case 4
                    ordre_axes_desire = [4,2,3,1]; % plan temps-y
                    
                                                   % time-y plane
                case 5
                    ordre_axes_desire = [4,3,2,1]; % plan temps-z
                               
                                                   % time-z plane
            end;
            
            %% Opération qui permute les axes des volumes de sorte 
            % qu'ils correspondent à l'ordre des axes désiré
            
            % This operation swaps the volume axes to that they correspond
            % the the desired axes order
            volumes_permutes = ipermute(volumes_originaux,ordre_axes_desire);
            
        end
        
        function volumes_originaux = revenir_ordre_axes_original(volumes_permutes,orientation_plan_affichage_actuel)
            % Permet de restaurer les volumes_originaux à partir des
            % volumes_permutes et de l'orientation du plan affiché
            % actuellement. Les volumes originaux sont retournés par 
            % la fonction.
            
            % Enables to restore the "volumes_originaux" (original volumes)
            % from the "volumes_permutes" (swapped volumes) and the
            % orientation of the plane that is currently displayed. The
            % original volumes are returned by the function
            
            %% En fonction de l'orientation de plan de l'affichage actuel,
            % on définit l'ordre des axes auquel il correspond
            
            % Depending on the orientation of the currently displayed
            % plane, defines the order of the axes to which it corresponds
            switch orientation_plan_affichage_actuel
                case 0
                    ordre_axes_actuel = [1,2,3,4]; % plan axial (x-y)
                    
                                                   % axial plane (x-y)
                case 1
                    ordre_axes_actuel = [1,3,2,4]; % plan latéral (x-z)
                    
                                                   % lateral plane (x-z)
                case 2
                    ordre_axes_actuel = [2,3,1,4]; % plan transverse (y-z)
                       
                                                   % transverse plane (y-z)
                case 3
                    ordre_axes_actuel = [4,1,3,2]; % plan temps-x
                    
                                                   % time-x plane
                case 4
                    ordre_axes_actuel = [4,2,3,1]; % plan temps-y
                    
                                                   % time-y plane
                case 5
                    ordre_axes_actuel = [4,3,2,1]; % plan temps-z
                    
                                                   % time-z plane
            end;
            
            %% Opération qui permute les axes des volumes de sorte 
            % que les volumes_permutes selon l'ordre des axes actuel
            % reviennent à leur ordre des axes original
            
            % This operation swaps the volume axes so that the
            % "volumes_permutes" (swapped volumes) given the current axes
            % order come back to their original axes order
            volumes_originaux = permute(volumes_permutes,ordre_axes_actuel);
        end        
        
    end
    
end


