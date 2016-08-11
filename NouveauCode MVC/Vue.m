classdef Vue < handle
    properties
        ihm
        modele
        controleur
    end
    
    methods
        function soi = Vue(controleur)
            soi.controleur = controleur;
            soi.modele = controleur.modele;
            soi.ihm = Ultrasound_4D_Images_Analyser_for_Aplio500_ToshibaMS('controleur',soi.controleur);
            
            %set(soi.ihm,'KeyPressFcn',{@soi.modele.volumes.mettre_a_jour_image,handles})
            
            addlistener(soi.modele,'image','PostSet', ...
                @(src,evnt)Vue.handlePropEvents(soi,src,evnt));
            addlistener(soi.modele,'chemin_donnees','PostSet', ...
                @(src,evnt)Vue.handlePropEvents(soi,src,evnt));
%             addlistener(soi.modele,'donnees_2D','PostSet', ...
%                 @(src,evnt)Vue.handlePropEvents(soi,src,evnt));
            %addlistener(soi.ihm,
%             addlistener(obj.modele,'volume','PostSet', ...
%                 @(src,evnt)view.handlePropEvents(obj,src,evnt));
%             addlistener(obj.modele,'units','PostSet', ...
%                 @(src,evnt)view.handlePropEvents(obj,src,evnt));
%             addlistener(obj.modele,'mass','PostSet', ...
%                 @(src,evnt)view.handlePropEvents(obj,src,evnt));
        end
    end
    
    methods (Static)
        function handlePropEvents(obj,src,evnt)
            evntobj = evnt.AffectedObject;
            handles = guidata(obj.ihm);
            switch src.Name
                case 'image'
                    axes(handles.image);
                    imzobr=evntobj.image';
                    iptsetpref('ImshowAxesVisible','on');
                    imshow(imzobr);
                    set(handles.image.Children,'CDataMapping','direct');
                    uicontextmenu = get(handles.image,'UIContextMenu');
                    set(handles.image.Children,'UIContextMenu',uicontextmenu);
                    
                    switch evntobj.volumes.vue_choisie
                        case 0
                            axe1='X';
                            axe2='Y';
                            axe3='Z';
                            axe4='Temps';
                            title({'Coupe frontale', [axe3 '=' num2str(evntobj.volumes.coordonnee_axe3_selectionnee) '/' num2str(evntobj.volumes.taille_axes(3)) ', ' axe4 '=' num2str(evntobj.volumes.coordonnee_axe4_selectionnee) '/' num2str(evntobj.volumes.taille_axes(4))]});
                        case 1
                            axe1='X';
                            axe2='Z';
                            axe3='Y';
                            axe4='Temps';
                            title({'Coupe transverse',[axe3 '=' num2str(evntobj.volumes.coordonnee_axe3_selectionnee) '/' num2str(evntobj.volumes.taille_axes(3)) ', ' axe4 '=' num2str(evntobj.volumes.coordonnee_axe4_selectionnee) '/' num2str(evntobj.volumes.taille_axes(4))]});
                        case 2
                            axe1='Y';
                            axe2='Z';
                            axe3='X';
                            axe4='Temps';
                            title({'Coupe sagittale', [axe3 '=' num2str(evntobj.volumes.coordonnee_axe3_selectionnee) '/' num2str(evntobj.volumes.taille_axes(3)) ', ' axe4 '=' num2str(evntobj.volumes.coordonnee_axe4_selectionnee) '/' num2str(evntobj.volumes.taille_axes(4))]});
                        case 3
                            axe1='Temps';
                            axe2='X';
                            axe3='Z';
                            axe4='Y';
                            title({'Coupe de X selon le temps', [axe3 '=' num2str(evntobj.volumes.coordonnee_axe3_selectionnee) '/' num2str(evntobj.volumes.taille_axes(3)) ', ' axe4 '=' num2str(evntobj.volumes.coordonnee_axe4_selectionnee) '/' num2str(evntobj.volumes.taille_axes(4))]});
                        case 4
                            axe1='Temps';
                            axe2='Y';
                            axe3='Z';
                            axe4='X';
                            title({'Coupe de Y selon le temps', [axe3 '=' num2str(evntobj.volumes.coordonnee_axe3_selectionnee) '/' num2str(evntobj.volumes.taille_axes(3)) ', ' axe4 '=' num2str(evntobj.volumes.coordonnee_axe4_selectionnee) '/' num2str(evntobj.volumes.taille_axes(4))]});
                        case 5
                            axe1='Temps';
                            axe2='Z';
                            axe3='Y';
                            axe4='X';
                            title({'Vue de Z selon le temps', [axe3 '=' num2str(evntobj.volumes.coordonnee_axe3_selectionnee) '/' num2str(evntobj.volumes.taille_axes(3)) ', ' axe4 '=' num2str(evntobj.volumes.coordonnee_axe4_selectionnee) '/' num2str(evntobj.volumes.taille_axes(4))]});
                    end;
                    if strcmp(axe1,'Temps')
                        xlabel([axe1,' (en pas de temps)']);
                    else
                        xlabel([axe1,' (en pixels)']);
                    end
                    ylabel([axe2, ' (en pixels)']);
                    
                    set(handles.choix_du_pic,'String',' ');
                    set(handles.lmh_affichage,'String',[]);
                    set(handles.lmh_affichage,'String',[]);
                    set(handles.choix_de_deux_pics,'String',' ');
                    set(handles.dpap_affichage,'String',[]);
                    set(handles.valeur_axe1Debut_graphique,'String',[],'enable','on','BackgroundColor','white');
                    set(handles.valeur_axe2Debut_graphique,'String',[],'enable','on','BackgroundColor','white');
                    set(handles.valeur_axe1Fin_graphique,'String',[],'enable','on','BackgroundColor','white');
                    set(handles.valeur_axe2Fin_graphique,'String',[],'enable','on','BackgroundColor','white');
                    set(handles.valeur_axe3_image,'String',evntobj.volumes.coordonnee_axe3_selectionnee,'enable','on','BackgroundColor','white');
                    set(handles.valeur_axe4_image,'String',evntobj.volumes.coordonnee_axe4_selectionnee,'enable','on','BackgroundColor','white');
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
                    set(handles.maximum_axe1_1,'String',['/',num2str(evntobj.volumes.taille_axes(1))]);
                    set(handles.maximum_axe1_2,'String',['/',num2str(evntobj.volumes.taille_axes(1))]);
                    set(handles.maximum_axe2_1,'String',['/',num2str(evntobj.volumes.taille_axes(2))]);
                    set(handles.maximum_axe2_2,'String',['/',num2str(evntobj.volumes.taille_axes(2))]);
                    set(handles.total_axe3_image,'String',['sur ', num2str(evntobj.volumes.taille_axes(3))]);
                    set(handles.total_axe4_image,'String',['sur ', num2str(evntobj.volumes.taille_axes(4))]);
                    set(handles.valeur_axe1Debut_graphique,'enable','on','BackgroundColor','white');
                    set(handles.valeur_axe2Debut_graphique,'enable','on','BackgroundColor','white');
                    set(handles.valeur_axe1Fin_graphique,'enable','on','BackgroundColor','white');
                    set(handles.valeur_axe2Fin_graphique,'enable','on','BackgroundColor','white');
                case 'chemin_donnees'
                    set(handles.chemin_dossier,'String',evntobj.chemin_donnees);
            end
%                 case 'density'
%                     set(handles.density, 'String', evntobj.density);
%                 case 'volume'
%                     set(handles.volume, 'String', evntobj.volume);
%                 case 'units'
%                     switch evntobj.units
%                         case 'english'
%                             set(handles.text4, 'String', 'lb/cu.in');
%                             set(handles.text5, 'String', 'cu.in');
%                             set(handles.text6, 'String', 'lb');
%                         case 'si'
%                             set(handles.text4, 'String', 'kg/cu.m');
%                             set(handles.text5, 'String', 'cu.m');
%                             set(handles.text6, 'String', 'kg');
%                         otherwise
%                             error('unknown units')
%                     end
%                 case 'mass'
%                     set(handles.mass,'String',evntobj.mass);
%             end
        end
    end
end