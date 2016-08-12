classdef Region_interet_rectangle < Region_interet
    %REGION_INTERET_RECTANGLE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        coordonnee_axe1_debut
        coordonnee_axe2_debut
        coordonnee_axe1_fin
        coordonnee_axe2_fin
        largeur_axe1
        hauteur_axe2
        modele
    end
    
    properties (Dependent)
        coordonnees_axe1_distinctes
        coordonnees_axe2_distinctes
    end
    
    methods (Access = ?Modele)  %Only Modele is allowed to construct a child
        function soi = Region_interet_rectangle(modele)
           soi.modele = modele;
        end
    end
    
    
    methods
        function tracer(soi)
                try
%                     set(handles.figure1,'KeyPressFcn','');
                    objet_rectangle = imrect;
                    if isempty(objet_rectangle)
                        erreur_ROI_pas_choisi.message = 'La région d''intérêt n''a pas été délimitée avant le changement de vue.';
                        erreur_ROI_pas_choisi.identifier = 'Rectangle_Callback:ROI_pas_choisi';
                        error(erreur_ROI_pas_choisi);
                    end
                    position_rectangle = getPosition(objet_rectangle);
                    valeur_axe1Debut_graphique=position_rectangle(1);
                    valeur_axe2Debut_graphique=position_rectangle(2);
                    soi.largeur_axe1=position_rectangle(3);
                    soi.hauteur_axe2=position_rectangle(4);
                    valeur_axe1Fin_graphique = valeur_axe1Debut_graphique + soi.largeur_axe1;
                    valeur_axe2Fin_graphique = valeur_axe2Debut_graphique + soi.hauteur_axe2;

                    %On arrondit les valeurs des coordonnées sélectionnées
                    soi.coordonnee_axe1_debut=int16(round(valeur_axe1Debut_graphique));
                    soi.coordonnee_axe2_debut=int16(round(valeur_axe2Debut_graphique));
                    soi.coordonnee_axe1_fin=int16(round(valeur_axe1Fin_graphique));
                    soi.coordonnee_axe2_fin=int16(round(valeur_axe2Fin_graphique));
                    
                    delete(objet_rectangle);
%                     set(handles.figure1,'KeyPressFcn',{@volumes.mettre_a_jour_image,handles})
                catch erreurs
                    if (strcmp(erreurs.identifier,'Rectangle_Callback:ROI_pas_choisi'))
                        causeException = MException(erreur_ROI_pas_choisi.identifier,erreur_ROI_pas_choisi.message);
                        erreurs = addCause(erreurs,causeException);
                    end
                    rethrow(erreurs);
                end

        end
                    
         function enregistrer(soi)
             try
                volumes = soi.modele.volumes;
                volumes_ROI=volumes.donnees(int16(soi.coordonnee_axe1_debut):...
                    int16(soi.coordonnee_axe1_fin),...
                    int16(soi.coordonnee_axe2_debut):int16(soi.coordonnee_axe2_fin),:,:);
                soi.donnees_4D = volumes_ROI;
                soi.modele.donnees_region_interet = soi.donnees_4D;
                soi.donnees_2D = soi.donnees_4D(:,:,volumes.coordonnee_axe3_selectionnee,...
                volumes.coordonnee_axe4_selectionnee);
             catch erreurs
                if (strcmp(erreurs.identifier,'MATLAB:badsubscript'))
                    warndlg('Merci d''entrer une région d''intérêt incluse dans l''image.');
                    messsage_erreur = 'La région d''intérêt dépasse de l''image.';
                    cause_erreur = MException('MATLAB:badsubscript',messsage_erreur);
                    erreurs = addCause(erreurs,cause_erreur);
                end
                rethrow(erreurs);
             end
         end
         
%          function obtenir_coordonnees(soi,handles)
%             soi.coordonnee_axe1_debut = str2double(get(handles.valeur_axe1Debut_graphique,'String'));
%             soi.coordonnee_axe2_debut = str2double(get(handles.valeur_axe2Debut_graphique,'String'));
%             soi.coordonnee_axe1_fin = str2double(get(handles.valeur_axe1Fin_graphique,'String'));
%             soi.coordonnee_axe2_fin = str2double(get(handles.valeur_axe2Fin_graphique,'String'));
%             soi.largeur_axe1 = soi.coordonnee_axe1_fin - soi.coordonnee_axe1_debut;
%             soi.hauteur_axe2 = soi.coordonnee_axe2_fin - soi.coordonnee_axe1_fin;
%          end
         
%          function afficher_coordonnees(soi,handles)
%             set(handles.valeur_axe1Debut_graphique,'String',num2str(soi.coordonnee_axe1_debut));
%             set(handles.valeur_axe2Debut_graphique,'String',num2str(soi.coordonnee_axe2_debut));
%             set(handles.valeur_axe1Fin_graphique,'String',num2str(soi.coordonnee_axe1_fin));
%             set(handles.valeur_axe2Fin_graphique,'String',num2str(soi.coordonnee_axe2_fin));
%             guidata(handles.figure1,handles);
%          end
         
%          function afficher_region(soi,handles)
%              axes(handles.image);
%              handles.rectangle_trace = rectangle('Position',[soi.coordonnee_axe1_debut soi.coordonnee_axe2_debut soi.largeur_axe1 soi.hauteur_axe2],'EdgeColor','r');
%              guidata(handles.figure1,handles);
%          end
         
%          function mettre_a_jour_IHM(~,handles)
%             set(handles.moyenne_axe1,'Visible','on');
%             set(handles.moyenne_axe2,'Visible','on');
%             set(handles.pas_de_moyenne,'Visible','on');
%             set(handles.abscisses_axe1,'Visible','on');
%             set(handles.abscisses_axe2,'Visible','on');
%             set(handles.affichage_entropie,'BackgroundColor','white');
%             guidata(handles.figure1,handles);
%          end
         
        function valeur = get.coordonnees_axe1_distinctes(soi)
            valeur = (soi.coordonnee_axe1_debut~=soi.coordonnee_axe1_fin);
        end

        function valeur = get.coordonnees_axe2_distinctes(soi)
            valeur = (soi.coordonnee_axe2_debut~=soi.coordonnee_axe2_fin);
        end
    end
    
   

end

