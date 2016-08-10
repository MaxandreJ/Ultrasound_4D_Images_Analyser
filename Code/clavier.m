function clavier(~,eventdata,handles)
handles = guidata(handles.figure1);

cla(handles.affichage_graphique,'reset'); %Efface le graphique précédent

volumes = handles.volumes;
im = volumes.donnees;
taille_axes=volumes.taille_axes;

mode_out = volumes.vue_choisie;
coordonnee_axe3_selectionnee = volumes.coordonnee_axe3_selectionnee;
coordonnee_axe4_selectionnee = volumes.coordonnee_axe4_selectionnee;

%On ajoute la possibilité à l'utilisateur de choisir son plan de coupe et
%naviguer entre les images au moyen des flèches multidirectionnelles
if coordonnee_axe3_selectionnee>=1 && coordonnee_axe3_selectionnee<=taille_axes(3) && coordonnee_axe4_selectionnee>=1 && coordonnee_axe4_selectionnee<=taille_axes(4)
    switch eventdata.Key
        case  'rightarrow'
            coordonnee_axe3_selectionnee=coordonnee_axe3_selectionnee+1;
            if coordonnee_axe3_selectionnee>taille_axes(3)
                coordonnee_axe3_selectionnee=taille_axes(3);
            end
        case 'leftarrow'
            coordonnee_axe3_selectionnee=coordonnee_axe3_selectionnee-1;
            if coordonnee_axe3_selectionnee<1
                coordonnee_axe3_selectionnee=1;
            end
        case 'downarrow'
            coordonnee_axe4_selectionnee=coordonnee_axe4_selectionnee-1;
            if coordonnee_axe4_selectionnee<1
                coordonnee_axe4_selectionnee=1;
            end
        case 'uparrow'
            coordonnee_axe4_selectionnee=coordonnee_axe4_selectionnee+1;
            if coordonnee_axe4_selectionnee>taille_axes(4)
                coordonnee_axe4_selectionnee=taille_axes(4);
            end
        case {'0','numpad0'}
            if mode_out ~= 0;
                im = ipermutation(im,mode_out);
            end;
            mode_out = 0;
        case {'1','numpad1'}
            mode_in = 1;
            if mode_in ~= mode_out
                im = ipermutation(im,mode_out);
                im = permutation(im,mode_in);
            end;
            mode_out = 1;
        case {'2','numpad2'}
            mode_in = 2;
            if mode_in ~= mode_out
                im = ipermutation(im,mode_out);
                im = permutation(im,mode_in);
            end;
            mode_out = 2;
        case {'3','numpad3'}
            mode_in = 3;
            if mode_in ~= mode_out
                im = ipermutation(im,mode_out);
                im = permutation(im,mode_in);
            end;
            mode_out = 3;
        case {'4','numpad4'}
            mode_in = 4;
            if mode_in ~= mode_out
                im = ipermutation(im,mode_out);
                im = permutation(im,mode_in);
            end;
            mode_out = 4;
        case {'5','numpad5'}
            mode_in = 5;
            if mode_in ~= mode_out
                im = ipermutation(im,mode_out);
                im = permutation(im,mode_in);
            end;
            mode_out = 5;
    end
end

volumes.coordonnee_axe3_selectionnee = coordonnee_axe3_selectionnee;
volumes.coordonnee_axe4_selectionnee = coordonnee_axe4_selectionnee;
volumes.donnees = im;
volumes.vue_choisie = mode_out;

imzobr = im(:,:,coordonnee_axe3_selectionnee,coordonnee_axe4_selectionnee);



axes(handles.image);
imzobr=imzobr';
imshow(imzobr);
set(handles.image.Children,'CDataMapping','direct');
uicontextmenu = get(handles.image,'UIContextMenu');
set(handles.image.Children,'UIContextMenu',uicontextmenu);


switch mode_out
    case 0
        axe1='X';
        axe2='Y';
        axe3='Z';
        axe4='Temps';
        title({'Coupe frontale', [axe3 '=' num2str(coordonnee_axe3_selectionnee) '/' num2str(taille_axes(3)) ', ' axe4 '=' num2str(coordonnee_axe4_selectionnee) '/' num2str(taille_axes(4))]});
        ordre_axes = [1,2,3,4]; % frontal
    case 1
        axe1='X';
        axe2='Z';
        axe3='Y';
        axe4='Temps';
        title({'Coupe transverse',[axe3 '=' num2str(coordonnee_axe3_selectionnee) '/' num2str(taille_axes(3)) ', ' axe4 '=' num2str(coordonnee_axe4_selectionnee) '/' num2str(taille_axes(4))]});
        ordre_axes = [1,3,2,4]; % transversal
    case 2
        axe1='Y';
        axe2='Z';
        axe3='X';
        axe4='Temps';
        title({'Coupe sagittale', [axe3 '=' num2str(coordonnee_axe3_selectionnee) '/' num2str(taille_axes(3)) ', ' axe4 '=' num2str(coordonnee_axe4_selectionnee) '/' num2str(taille_axes(4))]});
        ordre_axes = [2,3,1,4]; % sagittal
    case 3
        axe1='Temps';
        axe2='X';
        axe3='Z';
        axe4='Y';
        title({'Coupe de X selon le temps', [axe3 '=' num2str(coordonnee_axe3_selectionnee) '/' num2str(taille_axes(3)) ', ' axe4 '=' num2str(coordonnee_axe4_selectionnee) '/' num2str(taille_axes(4))]});
        ordre_axes = [4,1,3,2]; % x-temps
    case 4
        axe1='Temps';
        axe2='Y';
        axe3='Z';
        axe4='X';
        title({'Coupe de Y selon le temps', [axe3 '=' num2str(coordonnee_axe3_selectionnee) '/' num2str(taille_axes(3)) ', ' axe4 '=' num2str(coordonnee_axe4_selectionnee) '/' num2str(taille_axes(4))]});
        ordre_axes = [4,2,3,1]; % y-temps
    case 5
        axe1='Temps';
        axe2='Z';
        axe3='Y';
        axe4='X';
        title({'Vue de Z selon le temps', [axe3 '=' num2str(coordonnee_axe3_selectionnee) '/' num2str(taille_axes(3)) ', ' axe4 '=' num2str(coordonnee_axe4_selectionnee) '/' num2str(taille_axes(4))]});
        ordre_axes = [4,3,2,1]; % z-temps
end;
        if strcmp(axe1,'Temps')
            xlabel([axe1,' (en pas de temps)']);
        else
            xlabel([axe1,' (en pixels)']);
        end
        ylabel([axe2, ' (en pixels)']);
        
        volumes.ordre_axes=ordre_axes;
        
        set(handles.valeur_axe3_image,'String',coordonnee_axe3_selectionnee);
        set(handles.valeur_axe4_image,'String',coordonnee_axe4_selectionnee);
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
        set(handles.maximum_axe1_1,'String',['/',num2str(taille_axes(1))]);
        set(handles.maximum_axe1_2,'String',['/',num2str(taille_axes(1))]);
        set(handles.maximum_axe2_1,'String',['/',num2str(taille_axes(2))]);
        set(handles.maximum_axe2_2,'String',['/',num2str(taille_axes(2))]);
        set(handles.total_axe3_image,'String',['sur ', num2str(taille_axes(3))]);
        set(handles.total_axe4_image,'String',['sur ', num2str(taille_axes(4))]);
        
        handles.volumes = volumes;
        guidata(handles.figure1,handles);
end

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