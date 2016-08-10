classdef (Abstract) Volumes < handle
    %VOLUMES Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
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
        charger(soi,handles)
    end
    
    methods
        function valeur = get.taille_axes(soi)
           valeur=[size(soi.donnees,1),...
               size(soi.donnees,2),...
               size(soi.donnees,3),...
               size(soi.donnees,4)];
           soi.taille_axes_enregistree=valeur;
        end
        
        function afficher_chemin(soi,handles)
            set(handles.chemin_dossier,'String',soi.chemin_a_afficher);
            guidata(handles.figure1,handles);
        end
        
        function afficher_image(soi,handles)
            set(handles.maximum_axe1_1,'String',['/',num2str(soi.taille_axes(1))]);
            set(handles.maximum_axe1_2,'String',['/',num2str(soi.taille_axes(1))]);
            set(handles.maximum_axe2_1,'String',['/',num2str(soi.taille_axes(2))]);
            set(handles.maximum_axe2_2,'String',['/',num2str(soi.taille_axes(2))]);
            set(handles.total_axe3_image,'String',['sur ', num2str(soi.taille_axes(3))]);
            set(handles.total_axe4_image,'String',['sur ', num2str(soi.taille_axes(4))]);

            %Ajout ci-dessous
            imzobr = soi.donnees(:,:,soi.coordonnee_axe3_selectionnee,soi.coordonnee_axe4_selectionnee);


            %Ajout
            axes(handles.image);
            %pour bon affichage dans l'IHM
            imzobr=imzobr';
            iptsetpref('ImshowAxesVisible','on');
            imshow(imzobr);
            set(handles.image.Children,'CDataMapping','direct');
            uicontextmenu = get(handles.image,'UIContextMenu');
            set(handles.image.Children,'UIContextMenu',uicontextmenu);

            if soi.vue_choisie == 0
                xlabel('X (en pixels)')
                ylabel('Y (en pixels)')
                title({'Coupe frontale', ['Z=' num2str(soi.coordonnee_axe3_selectionnee) ...
                    '/' num2str(soi.taille_axes(3)) ', Temps=' num2str(soi.coordonnee_axe4_selectionnee) ...
                    '/' num2str(soi.taille_axes(4))]});
            end

            if soi.taille_axes(3)>1 || soi.taille_axes(4)>1
                set(handles.figure1,'KeyPressFcn',{@clavier,handles})
            end;

            guidata(handles.figure1,handles);
        end
        
    end
    
end


