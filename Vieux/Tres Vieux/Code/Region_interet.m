classdef (Abstract) Region_interet < handle
    %REGION_INTERET Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        donnees_4D
        donnees_2D
        coordonnee_axe3_selectionnee
        coordonnee_axe4_selectionnee
    end
    
    methods (Abstract)
        tracer(soi,handles)
        enregistrer(soi,handles)
        afficher_coordonnees(soi,handles)
        afficher_region(soi,handles)
        mettre_a_jour_IHM(~,handles)
    end
    
    methods (Static)
        function suppression_precedent(handles)
            cla(handles.affichage_graphique,'reset'); %Efface le graphique précédent
            cla(handles.image.Children);

            if isfield(handles,'rectangle_trace')
                delete(handles.rectangle_trace);
            end

            if isfield(handles,'polygone_trace')
                delete(handles.polygone_trace);
            end
            
            guidata(handles.figure1,handles);
        end
    end
    
end

