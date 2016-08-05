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
global valeur_axe3 valeur_axe4 im mode_out inter colormaps isfused

%im = varargin{1};

valeur_axe3 = 1;
valeur_axe4 = 1;
mode_out = 0;
inter = 0;
colormaps = colormap('gray');
isfused = 0;

%Interversion des dimensions 1 et 2 pour passer de la taille de matrice à
%un repère cartésien
%taille_axes=[size(im,1),size(im,2),size(im,3),size(im,4)];

N = nargin;
if N==2
    handles = varargin{2};
elseif N==3
    handles = varargin{1};
    valeur_axe3 = varargin{2};
    valeur_axe4 = varargin{3};
end
taille_axes = handles.volumes.taille_axes;
im = handles.volumes.donnees;

set(handles.maximum_axe1_1,'String',['/',num2str(taille_axes(1))]);
set(handles.maximum_axe1_2,'String',['/',num2str(taille_axes(1))]);
set(handles.maximum_axe2_1,'String',['/',num2str(taille_axes(2))]);
set(handles.maximum_axe2_2,'String',['/',num2str(taille_axes(2))]);
set(handles.total_axe3_image,'String',['sur ', num2str(taille_axes(3))]);
set(handles.total_axe4_image,'String',['sur ', num2str(taille_axes(4))]);

%Ajout ci-dessous
imzobr = im(:,:,valeur_axe3,valeur_axe4);


%Ajout
axes(handles.image);
%pour bon affichage dans l'IHM
imzobr=imzobr';
iptsetpref('ImshowAxesVisible','on');
imshow(imzobr);
set(handles.image.Children,'CDataMapping','direct');
uicontextmenu = get(handles.image,'UIContextMenu');
set(handles.image.Children,'UIContextMenu',uicontextmenu);


xlabel('X (en pixels)')
ylabel('Y (en pixels)')
title({'Coupe frontale', ['Z=' num2str(valeur_axe3) '/' num2str(taille_axes(3)) ', t=' num2str(valeur_axe4) '/' num2str(taille_axes(4))]});

if size(im,3)>1 || size(im,4)>1
    set(handles.figure1,'KeyPressFcn',{@clavier,handles})
end;

guidata(handles.figure1,handles);
end