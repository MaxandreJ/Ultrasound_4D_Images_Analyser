classdef Controleur < handle
    properties
        modele
        vue
    end
    
    methods
        function soi = Controleur(modele)
            soi.modele = modele;
            soi.vue = Vue(soi);
        end
        
        function charger_volumes_mat(soi)
            soi.modele.creer_volumes_mat;
            soi.modele.volumes.charger;
        end
        
        function charger_volumes_RawData_bin(soi)
            soi.modele.creer_volumes_RawData_bin;
            soi.modele.volumes.charger;
        end
        
        function mettre_a_jour_image_clavier(soi,eventdata)
            soi.modele.volumes.mettre_a_jour_image_clavier(eventdata);
        end
        
        function mettre_a_jour_image_bouton(soi,coordonnee_axe3_selectionnee,coordonnee_axe4_selectionnee)
            soi.modele.volumes.mettre_a_jour_image_bouton(coordonnee_axe3_selectionnee,coordonnee_axe4_selectionnee);
        end
        
%         function setDensity(obj,density)
%             obj.model.setDensity(density)
%         end
%         
%         function setVolume(obj,volume)
%             obj.model.setVolume(volume)
%         end
%         
%         function setUnits(obj,units)
%             obj.model.setUnits(units)
%         end
%         
%         function calculate(obj)
%             obj.model.calculate()
%         end
%         
%         function reset(obj)
%             obj.model.reset()
%         end
    end
end

