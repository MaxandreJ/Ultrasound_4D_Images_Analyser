classdef Test_Controleur < matlab.unittest.TestCase
    %CONTROLEURTEST Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        modele
        controleur
    end
    
    properties (TestParameter)
        axe_abscisses_choisi = struct('un', 1,'deux', 2, 'trois', 3, 'quatre',4);
        axe_moyenne_choisi = struct('un','1','deux','2','un_et_deux','1 et 2','pas_de_moyenne','pas de moyenne');
    end
    
    methods (TestClassSetup)
        function ajouter_classe_controleur_au_chemin(cas_de_test)
            p = path;
            cas_de_test.addTeardown(@path,p);
            addpath(fullfile('..','Controleur'));
        end
    end
    
    methods (TestMethodTeardown)
        function tout_fermer(cas_de_test)
            delete(cas_de_test.modele);
            close(cas_de_test.controleur.vue.ihm);
            close all;
            delete(cas_de_test.controleur);
        end
    end
    
    methods (Test)
        function test_definir_graphique(cas_de_test,axe_abscisses_choisi,axe_moyenne_choisi)
            %% Mise en place
            cas_de_test.modele = Modele;
            cas_de_test.modele.creer_region_interet_polygone;
            cas_de_test.modele.creer_volumes_mat;
            
            tenseur_ordre3_temps1 = cat(3, [0 0; 0 0], [0 0; 0 0]);
            tenseur_ordre3_temps2 = cat(3, [0 0; 0 0], [0 0; 0 0]);
            
            cas_de_test.modele.region_interet.donnees_4D=cat(4,tenseur_ordre3_temps1...
                ,tenseur_ordre3_temps2);
            cas_de_test.modele.region_interet.donnees_2D=tenseur_ordre3_temps1;
            cas_de_test.modele.volumes.taille_axes_enregistree = [2,2,2,2];
            cas_de_test.modele.volumes.coordonnee_axe3_selectionnee = 1;
            cas_de_test.modele.volumes.coordonnee_axe4_selectionnee = 1;
            
            cas_de_test.controleur = Controleur(cas_de_test.modele);
            
            %% Test
            cas_de_test.controleur.definir_graphique(axe_abscisses_choisi,axe_moyenne_choisi);
            
            ordonnees_graphique_attendues = [0;0];
            
            cas_de_test.verifyEqual(cas_de_test.modele.ordonnees_graphique,...
                ordonnees_graphique_attendues);
            
        end
    end
    
end