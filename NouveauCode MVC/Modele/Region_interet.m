classdef (Abstract) Region_interet < handle
    %REGION_INTERET Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        donnees_4D
        donnees_2D
        entropie
    end
    
    methods (Abstract)
        tracer(soi,handles)
        enregistrer(soi,handles)
%         afficher_coordonnees(soi,handles)
%         afficher_region(soi,handles)
%         mettre_a_jour_IHM(~,handles)
    end
    
    methods
        function selectionner_manuellement(soi,coordonnee_axe1_debut,...
        coordonnee_axe1_fin,coordonnee_axe2_debut,coordonnee_axe2_fin)
    
            soi.coordonnee_axe1_debut=coordonnee_axe1_debut;
            soi.coordonnee_axe1_fin=coordonnee_axe1_fin;
            soi.coordonnee_axe2_debut=coordonnee_axe2_debut;
            soi.coordonnee_axe2_fin=coordonnee_axe2_fin;
            
            soi.largeur_axe1 = soi.coordonnee_axe1_fin - soi.coordonnee_axe1_debut;
            soi.hauteur_axe2 = soi.coordonnee_axe2_fin - soi.coordonnee_axe1_fin;
           
            soi.enregistrer;
        end
        
        function selectionner_visuellement(soi)
            
            soi.tracer;

            soi.enregistrer;

        end
        function calculer_entropie(soi)
            image_ROI=soi.donnees_2D;
            image_ROI=image_ROI(~isnan(image_ROI));
            image_ROI_8bits=uint8(image_ROI);
            soi.entropie=entropy(image_ROI_8bits);
            soi.modele.entropie_region_interet = soi.entropie;
%             set(handles.affichage_entropie,'String',num2str(entropie_region_interet));
        end
        
    end

end

