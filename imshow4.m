function [] = imshow4(varargin)
% Function for 2D, 3D or 4D image display. Required Matlab version 2012a
% or newer. Recomended Matlab 2013a or newer.
% -------------------------------------------------------------------------
% imshow4(im) - show 2D, 3D or 4D image with default settings
% imshow4(im,valeur_axe3) - show 3D or 4D image with default settings with
% started at valeur_axe3 number
% imshow4(im,valeur_axe3,ref_valeur_axe4) - show 3D or 4D image with default settings
% with started at valeur_axe3 number and reference valeur_axe4 sample
% imshow4(im,valeur_axe3,ref_valeur_axe4,range) - show 4D image with default settings
% with started at valeur_axe3 number and reference valeur_axe4 sample with specified
% intensity range settings
% imshow4(im,valeur_axe3,ref_valeur_axe4,range,colormaps) - show 4D image with default
% settings with started at valeur_axe3 number and reference valeur_axe4 sample with
% specified intensity range and colormap settings
% imshow4(im,valeur_axe3,ref_valeur_axe4,range,colormaps,valeur_axe4) - show 4D image valeur_axe4
% fusion, where valeur_axe4 is second image inital valeur_axe4 sample
% imshow4(im,valeur_axe3,ref_valeur_axe4,range,colormaps,valeur_axe4,method) - show 4D image
% valeur_axe4 fusion, method is same as method in imfuse function
% -------------------------------------------------------------------------
% im - input image 2D/3D/4D
% valeur_axe3 - number of valeur_axe3 (default = 1)
% ref_valeur_axe4 - number of reference valeur_axe4 sample (default = 1)
% range - intensity range - 'all'/0/[x,y]/'norm'
% (default = 'all' - same as imshow(im,[]))
% colormaps - same as colormap function parameters - 'jet',...0 - def.
% (default = 'gray')
% valeur_axe4 - number of valeur_axe4 sample (default = 1)
% method - method from imfuse function -
% 'falsecolor'/'blend'/'diff'/'montage' (default = 'falsecolor')
global valeur_axe3 valeur_axe4 im mode_out inter colormaps isfused contexte_image taille_axes

im = varargin{1};
N = nargin;
valeur_axe3 = 1;
valeur_axe4 = 1;
ref_valeur_axe4 = 1;
range = 'all';
mode_out = 0;
method = 'falsecolor';
inter = 0;
%h = figure('Position',get(0,'ScreenSize'),'WindowStyle','docked','Interruptible','off');
colormaps = colormap('gray');
isfused = 0;

%Interversion des dimensions 1 et 2 pour passer de la taille de matrice à
%un repère cartésien
taille_axes=[size(im,1),size(im,2),size(im,3),size(im,4)];

N = nargin;
if N==3
    contexte_image = varargin{2};
    handles = varargin{3};
elseif N==5
    contexte_image = varargin{2};
    handles = varargin{3};
    valeur_axe3 = varargin{4};
    valeur_axe4 = varargin{5};
end

handles.taille_axes=taille_axes;
handles.ordre_axes=[1,2,3,4];

set(handles.maximum_axe1_1,'String',['/',num2str(taille_axes(1))]);
set(handles.maximum_axe1_2,'String',['/',num2str(taille_axes(1))]);
set(handles.maximum_axe2_1,'String',['/',num2str(taille_axes(2))]);
set(handles.maximum_axe2_2,'String',['/',num2str(taille_axes(2))]);
set(handles.total_axe3_image,'String',['sur ', num2str(taille_axes(3))]);
set(handles.total_axe4_image,'String',['sur ', num2str(taille_axes(4))]);

%Ajout ci-dessous
imzobr = im(:,:,valeur_axe3,valeur_axe4);


%set(handles.image,'UserData',imzobr);
%set(handles.image.Children,'CData',imzobr);
%set(handles.image.Children,'CDataMapping','direct');

%{
delete(get(handles.image, 'Children'));

hIm = image(flipud(imzobr));

copyobj(hIm,handles.image);

uicontextmenu = get(handles.image,'UIContextMenu');
set(handles.image.Children,'UIContextMenu',uicontextmenu);
%}

%Ajout
axes(handles.image);
%pour bon affichage dans l'IHM
imzobr=imzobr';
imshow(imzobr);
%set(handles.image.Children,'CData',imzobr);
set(handles.image.Children,'CDataMapping','direct');
uicontextmenu = get(handles.image,'UIContextMenu');
set(handles.image.Children,'UIContextMenu',uicontextmenu);

%figure(h)
%set(h,'Name',['Z=' num2str(valeur_axe3) '/' num2str(size(im,3)) ', t=' num2str(valeur_axe4) '/' num2str(size(im,4))])

xlabel('X')
ylabel('Y')
title({'Coupe frontale', ['Z=' num2str(valeur_axe3) '/' num2str(taille_axes(3)) ', t=' num2str(valeur_axe4) '/' num2str(taille_axes(4))]});
%title('Coupe frontale : \leftarrow\rightarrow = Z-axis, \uparrow\downarrow = t-axis, 0-5 = view')
%set(h,'Colormap',colormaps);
if size(im,3)>1 || size(im,4)>1
    %set(h,'KeyPressFcn',{@kresli,h,range,N,ref_valeur_axe4,method})
    set(handles.figure1,'KeyPressFcn',{@clavier,handles})
end;

guidata(handles.figure1,handles);
end

% function kresli(~,eventdata,handles)
% global valeur_axe3 valeur_axe4 im mode_out inter colormaps isfused taille_axes
% cla(handles.graphique,'reset'); %Efface le graphique précédent
% rng=size(im,3);
% rng=[1 rng];
% rng_t=size(im,4);
% rng_t=[1 rng_t];
% 
% %On ajoute la possibilité à l'utilisateur de choisir son plan de coupe et
% %naviguer entre les images au moyen des flèches multidirectionnelles
% if valeur_axe3>=min(rng) && valeur_axe3<=max(rng) && valeur_axe4>=min(rng_t) && valeur_axe4<=max(rng_t)
%     switch eventdata.Key
%         case  'rightarrow'
%             valeur_axe3=valeur_axe3+1;
%             if valeur_axe3>max(rng)
%                 valeur_axe3=max(rng);
%             end
%         case 'leftarrow'
%             valeur_axe3=valeur_axe3-1;
%             if valeur_axe3<min(rng)
%                 valeur_axe3=min(rng);
%             end
%         case 'downarrow'
%             valeur_axe4=valeur_axe4-1;
%             if valeur_axe4<min(rng_t)
%                 valeur_axe4=min(rng_t);
%             end
%         case 'uparrow'
%             valeur_axe4=valeur_axe4+1;
%             if valeur_axe4>max(rng_t)
%                 valeur_axe4=max(rng_t);
%             end
%         case {'0','numpad0'}
%             if mode_out ~= 0;
%                 im = ipermutation(im,mode_out);
%                 handles.volumes = ipermutation(handles.volumes,mode_out);
%             end;
%             mode_out = 0;
%             inter = 0;
%         case {'1','numpad1'}
%             mode_in = 1;
%             if mode_in ~= mode_out
%                 handles.volumes = ipermutation(handles.volumes,mode_out);
%                 handles.volumes = permutation(handles.volumes,mode_in);
%                 im = ipermutation(im,mode_out);
%                 im = permutation(im,mode_in);
%             end;
%             mode_out = 1;
%             inter = 0;
%         case {'2','numpad2'}
%             mode_in = 2;
%             if mode_in ~= mode_out
%                 handles.volumes = ipermutation(handles.volumes,mode_out);
%                 handles.volumes = permutation(handles.volumes,mode_in);
%                 im = ipermutation(im,mode_out);
%                 im = permutation(im,mode_in);
%             end;
%             mode_out = 2;
%             inter = 0;
%         case {'3','numpad3'}
%             mode_in = 3;
%             if mode_in ~= mode_out
%                 handles.volumes = ipermutation(handles.volumes,mode_out);
%                 handles.volumes = permutation(handles.volumes,mode_in);
%                 im = ipermutation(im,mode_out);
%                 im = permutation(im,mode_in);
%             end;
%             mode_out = 3;
%             inter = 1;
%         case {'4','numpad4'}
%             mode_in = 4;
%             if mode_in ~= mode_out
%                 handles.volumes = ipermutation(handles.volumes,mode_out);
%                 handles.volumes = permutation(handles.volumes,mode_in);
%                 im = ipermutation(im,mode_out);
%                 im = permutation(im,mode_in);
%             end;
%             mode_out = 4;
%             inter = 1;
%         case {'5','numpad5'}
%             mode_in = 5;
%             if mode_in ~= mode_out
%                 handles.volumes = ipermutation(handles.volumes,mode_out);
%                 handles.volumes = permutation(handles.volumes,mode_in);
%                 im = ipermutation(im,mode_out);
%                 im = permutation(im,mode_in);
%             end;
%             mode_out = 5;
%             inter = 1;
%     end
% end
% 
% if rng(end)~=size(im,3) || rng_t(end)~=size(im,4)
%     rng=size(im,3);
%     rng=[1 rng];
%     rng_t=size(im,4);
%     rng_t=[1 rng_t];
%     if valeur_axe3>max(rng)
%         valeur_axe3=max(rng);
%     end
%     if valeur_axe3<min(rng)
%         valeur_axe3=min(rng);
%     end
%     if valeur_axe4<min(rng_t)
%         valeur_axe4=min(rng_t);
%     end
%     if valeur_axe4>max(rng_t)
%         valeur_axe4=max(rng_t);
%     end
% end;
% %figure(h)
% 
% imzobr = im(:,:,valeur_axe3,valeur_axe4);
% 
% 
% axes(handles.image);
% imzobr=imzobr';
% imshow(imzobr);
% set(handles.image.Children,'CDataMapping','direct');
% uicontextmenu = get(handles.image,'UIContextMenu');
% set(handles.image.Children,'UIContextMenu',uicontextmenu);
% 
% 
% if size(imzobr,2)<200 && inter==1
%     imzobr = imresize(imzobr,[size(imzobr,1),200]);
% end;
% 
% handles.vue_choisie = mode_out;
% 
% %Ajout ci-dessous
% guidata(handles.figure1,handles);
% 
% switch mode_out
%     case 0
%         axe1='X';
%         axe2='Y';
%         axe3='Z';
%         axe4='Temps';
%         title({'Coupe frontale', [axe3 '=' num2str(valeur_axe3) '/' num2str(rng(2)) ', ' axe4 '=' num2str(valeur_axe4) '/' num2str(rng_t(2))]});
%         ordre_axes = [1,2,3,4]; % frontal
%     case 1
%         axe1='X';
%         axe2='Z';
%         axe3='Y';
%         axe4='Temps';
%         title({'Coupe transverse',[axe3 '=' num2str(valeur_axe3) '/' num2str(rng(2)) ', ' axe4 '=' num2str(valeur_axe4) '/' num2str(rng_t(2))]});
%         ordre_axes = [1,3,2,4]; % transversal
%     case 2
%         axe1='Y';
%         axe2='Z';
%         axe3='X';
%         axe4='Temps';
%         title({'Coupe sagittale', [axe3 '=' num2str(valeur_axe3) '/' num2str(rng(2)) ', ' axe4 '=' num2str(valeur_axe4) '/' num2str(rng_t(2))]});
%         ordre_axes = [2,3,1,4]; % sagittal
%     case 3
%         axe1='Temps';
%         axe2='X';
%         axe3='Z';
%         axe4='Y';
%         title({'Coupe de X selon le temps', [axe3 '=' num2str(valeur_axe3) '/' num2str(rng(2)) ', ' axe4 '=' num2str(valeur_axe4) '/' num2str(rng_t(2))]});
%         ordre_axes = [4,1,3,2]; % x-temps
%     case 4
%         axe1='Temps';
%         axe2='Y';
%         axe3='Z';
%         axe4='X';
%         title({'Coupe de Y selon le temps', [axe3 '=' num2str(valeur_axe3) '/' num2str(rng(2)) ', ' axe4 '=' num2str(valeur_axe4) '/' num2str(rng_t(2))]});
%         ordre_axes = [4,2,3,1]; % y-temps
%     case 5
%         axe1='Temps';
%         axe2='Z';
%         axe3='Y';
%         axe4='X';
%         title({'Vue de Z selon le temps', [axe3 '=' num2str(valeur_axe3) '/' num2str(rng(2)) ', ' axe4 '=' num2str(valeur_axe4) '/' num2str(rng_t(2))]});
%         ordre_axes = [4,3,2,1]; % z-temps
% end;
%         xlabel(axe1);
%         ylabel(axe2);
%         set(handles.valeur_axe3_image,'String',valeur_axe3);
%         set(handles.valeur_axe4_image,'String',valeur_axe4);
%         set(handles.axe1_graphique,'String',axe1);
%         set(handles.axe2_graphique,'String',axe2);
%         set(handles.graphique_selon_axe1,'String',axe1);
%         set(handles.graphique_selon_axe2,'String',axe2);
%         set(handles.graphique_selon_axe3,'String',axe3);
%         set(handles.graphique_selon_axe4,'String',axe4);
%         set(handles.moyenne_axe1,'String',axe1);
%         set(handles.moyenne_axe2,'String',axe2);
%         set(handles.moyenne_axe1et2,'String',[axe1, ' et ', axe2]);
%         set(handles.texte_axe3_image,'String',axe3);
%         set(handles.texte_axe4_image,'String',axe4);
%         set(handles.maximum_axe1_1,'String',['/',num2str(taille_axes(ordre_axes(1)))]);
%         set(handles.maximum_axe1_2,'String',['/',num2str(taille_axes(ordre_axes(1)))]);
%         set(handles.maximum_axe2_1,'String',['/',num2str(taille_axes(ordre_axes(2)))]);
%         set(handles.maximum_axe2_2,'String',['/',num2str(taille_axes(ordre_axes(2)))]);
%         set(handles.total_axe3_image,'String',['sur ', num2str(taille_axes(ordre_axes(3)))]);
%         set(handles.total_axe4_image,'String',['sur ', num2str(taille_axes(ordre_axes(4)))]);
%         
%         handles.ordre_axes=ordre_axes;
%         guidata(handles.figure1,handles);
% end
% 
% function [im_out] = permutation(im_in,mode_in)
%     switch mode_in
%         case 0
%             mode_in = [1,2,3,4]; % frontal
%         case 1
%             mode_in = [1,3,2,4]; % transversal
%         case 2
%             mode_in = [2,3,1,4]; % sagittal
%         case 3
%             mode_in = [4,1,3,2]; % x-temps
%         case 4
%             mode_in = [4,2,3,1]; % y-temps
%         case 5
%             mode_in = [4,3,2,1]; % z-temps
%     end;
%     im_out = permute(im_in,mode_in);
% end
% 
% function [im_out] = ipermutation(im_in,mode_in)
%     switch mode_in
%         case 0
%             mode_in = [1,2,3,4]; % frontal
%         case 1
%             mode_in = [1,3,2,4]; % transversal
%         case 2
%             mode_in = [2,3,1,4]; % sagittal
%         case 3
%             mode_in = [4,1,3,2]; % x-temps
%         case 4
%             mode_in = [4,2,3,1]; % y-temps
%         case 5
%             mode_in = [4,3,2,1]; % z-temps
%     end;
%     im_out = ipermute(im_in,mode_in);
% end

