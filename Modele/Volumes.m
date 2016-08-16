classdef (Abstract) Volumes < handle
    %VOLUMES Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        modele
        donnees
        ordre_axes = [1,2,3,4]
        taille_axes_enregistree
        coordonnee_axe3_selectionnee = 1
        coordonnee_axe4_selectionnee = 1
        chemin_a_afficher
        vue_choisie = 0
    end
    
    properties (Dependent)
        taille_axes
    end
    
    methods (Abstract)
        charger(soi)
    end
    
    methods
        
        function valeur = get.taille_axes(soi)
           valeur=[size(soi.donnees,1),...
               size(soi.donnees,2),...
               size(soi.donnees,3),...
               size(soi.donnees,4)];
           soi.taille_axes_enregistree=valeur;
        end
        
        
        
        function mettre_a_jour_image_clavier(soi,eventdata)
            im = soi.donnees;
            
            mode_out = soi.vue_choisie;

            %On ajoute la possibilité à l'utilisateur de choisir son plan de coupe et
            %naviguer entre les images au moyen des flèches multidirectionnelles
            if soi.coordonnee_axe3_selectionnee>=1 && soi.coordonnee_axe3_selectionnee<=soi.taille_axes(3) && soi.coordonnee_axe4_selectionnee>=1 && soi.coordonnee_axe4_selectionnee<=soi.taille_axes(4)
                switch eventdata.Key
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
                    case {'0','numpad0'}
                        if mode_out ~= 0;
                            im = Volumes.ipermutation(im,mode_out);
                        end;
                        mode_out = 0;
                        soi.ordre_axes = [1,2,3,4]; % frontal
                    case {'1','numpad1'}
                        mode_in = 1;
                        if mode_in ~= mode_out
                            im = Volumes.permutation(im,mode_out);
                            im = Volumes.ipermutation(im,mode_in);
                        end;
                        mode_out = 1;
                        soi.ordre_axes = [1,3,2,4]; % transversal
                    case {'2','numpad2'}
                        mode_in = 2;
                        if mode_in ~= mode_out
                            im = Volumes.permutation(im,mode_out);
                            im = Volumes.ipermutation(im,mode_in);
                        end;
                        mode_out = 2;
                        soi.ordre_axes = [2,3,1,4]; % sagittal
                    case {'3','numpad3'}
                        mode_in = 3;
                        if mode_in ~= mode_out
                            im = Volumes.permutation(im,mode_out);
                            im = Volumes.ipermutation(im,mode_in);
                        end;
                        mode_out = 3;
                        soi.ordre_axes = [4,1,3,2]; % x-temps
                    case {'4','numpad4'}
                        mode_in = 4;
                        if mode_in ~= mode_out
                            im = Volumes.permutation(im,mode_out);
                            im = Volumes.ipermutation(im,mode_in);
                        end;
                        mode_out = 4;
                        soi.ordre_axes = [4,2,3,1]; % y-temps
                    case {'5','numpad5'}
                        mode_in = 5;
                        if mode_in ~= mode_out
                            im = Volumes.permutation(im,mode_out);
                            im = Volumes.ipermutation(im,mode_in);
                        end;
                        mode_out = 5;
                        soi.ordre_axes = [4,3,2,1]; % z-temps
                end
            end
         
            soi.donnees = im;
            
             %% Si après le changement de vue on dépasse la taille des
            %%nouveaux axes avec les coordonnées sélectionnées, alors on
            %%rédéfinit les coordonnées sélectionnées comme étant les
            %%maximums de la taille des nouveaux axes
            if soi.coordonnee_axe3_selectionnee>soi.taille_axes(3)
                soi.coordonnee_axe3_selectionnee=soi.taille_axes(3);
            end
            
            if soi.coordonnee_axe4_selectionnee>soi.taille_axes(4)
                soi.coordonnee_axe4_selectionnee=soi.taille_axes(4);
            end
            
            soi.vue_choisie = mode_out;
            
            taille_image=size(im);

            soi.modele.image = im(:,:,soi.coordonnee_axe3_selectionnee,soi.coordonnee_axe4_selectionnee);
        end
         
        function mettre_a_jour_image_bouton(soi,coordonnee_axe3_selectionnee,coordonnee_axe4_selectionnee)
            soi.coordonnee_axe3_selectionnee=coordonnee_axe3_selectionnee;
            soi.coordonnee_axe4_selectionnee=coordonnee_axe4_selectionnee;
            soi.modele.image = soi.donnees(:,:,soi.coordonnee_axe3_selectionnee,soi.coordonnee_axe4_selectionnee);
         end
        
    end
    
    methods (Static)
        
        function [im_out] = permutation(im_in,mode_in)
            switch mode_in
                case 0
                    mode_in = [1,2,3,4]; % frontal
                case 1
                    mode_in = [1,3,2,4]; % transversal
                case 2
                    mode_in = [2,3,1,4]; % sagittal
                case 3
                    mode_in = [4,1,3,2]; % x-temps
                case 4
                    mode_in = [4,2,3,1]; % y-temps
                case 5
                    mode_in = [4,3,2,1]; % z-temps
            end;
            im_out = permute(im_in,mode_in);
        end
        
        function [im_out] = ipermutation(im_in,mode_in)
            switch mode_in
                case 0
                    mode_in = [1,2,3,4]; % frontal
                case 1
                    mode_in = [1,3,2,4]; % transversal
                case 2
                    mode_in = [2,3,1,4]; % sagittal
                case 3
                    mode_in = [4,1,3,2]; % x-temps
                case 4
                    mode_in = [4,2,3,1]; % y-temps
                case 5
                    mode_in = [4,3,2,1]; % z-temps
            end;
            im_out = ipermute(im_in,mode_in);
        end        
        
    end
    
end


