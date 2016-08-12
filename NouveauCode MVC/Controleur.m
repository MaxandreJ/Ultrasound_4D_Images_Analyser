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
        
        function selectionner_manuellement_region_interet(soi,coordonnee_axe1_debut,...
    coordonnee_axe1_fin,coordonnee_axe2_debut,coordonnee_axe2_fin)
            soi.modele.creer_region_interet_rectangle;
            soi.modele.region_interet.selectionner_manuellement(coordonnee_axe1_debut,...
        coordonnee_axe1_fin,coordonnee_axe2_debut,coordonnee_axe2_fin);
        end
        
        function selectionner_visuellement_region_interet_rectangulaire(soi)
            soi.modele.creer_region_interet_rectangle;
            soi.vue.choisir_axe_image;
            soi.modele.region_interet.selectionner_visuellement;
        end
        
        function selectionner_visuellement_region_interet_polygonale(soi)
            soi.modele.creer_region_interet_polygone;
            soi.vue.choisir_axe_image;
            soi.modele.region_interet.selectionner_visuellement;
        end
        
        function calculer_entropie(soi)
            soi.modele.region_interet.calculer_entropie;
        end
        
        function definir_graphique(soi,axe_abscisses_choisi,axe_moyenne_choisi)
            soi.modele.creer_graphique(axe_abscisses_choisi,axe_moyenne_choisi);
            soi.modele.graphique.definir;
        end
        
        function detecter_pics(soi,taille_fenetre_lissage,nombre_de_pics)
            soi.modele.graphique.definir;
            soi.modele.graphique.creer_pics;
            soi.vue.choisir_axe_affichage_graphique;
            soi.modele.graphique.pics.detecter(taille_fenetre_lissage,nombre_de_pics);
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

