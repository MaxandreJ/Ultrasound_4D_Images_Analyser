classdef Test_Controleur < matlab.unittest.TestCase
    %CONTROLEURTEST Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        modele
        controleur
    end
    
    properties (TestParameter)
        axe_abscisses_choisi = struct('un', 1,'deux', 2, 'trois', 3, 'quatre',4);
        axe_moyenne_choisi = {'1','2','1 et 2','pas de moyenne'};
    end
    
    methods (TestClassSetup)
        function ajouter_classe_controleur_au_chemin(testCase)
            p = path;
            testCase.addTeardown(@path,p);
            addpath(fullfile('..','Controleur'));
        end
    end
    
    methods (Test)
        function test_definir_graphique(testCase,axe_abscisses_choisi,axe_moyenne_choisi)
            tenseur_ordre3_temps1 = cat(3, [0 0; 0 0], [0 0; 0 0]);
            tenseur_ordre3_temps2 = cat(3, [0 0; 0 0], [0 0; 0 0]);
            soi.modele = Modele;
            soi.modele.region_interet = Region_interet_polygone(soi.modele);
            soi.modele.volumes = Volumes_mat(soi.modele);
            soi.modele.region_interet.donnees_4D=cat(4,tenseur_ordre3_temps1...
                ,tenseur_ordre3_temps2);
            soi.modele.region_interet.donnees_2D=tenseur_ordre3_temps1;
            soi.modele.volumes.taille_axes_enregistree = [2,2,2,2];
            soi.modele.volumes.coordonnee_axe3_selectionnee = 1;
            soi.modele.volumes.coordonnee_axe4_selectionnee = 1;
            soi.controleur = Controleur(soi.modele);
            soi.controleur.definir_graphique(axe_abscisses_choisi,axe_moyenne_choisi);
            
            ordonnees_graphique_attendues = [0,0];
            
            testCase.verifyEqual(soi.modele.ordonnees_graphique,...
                ordonnees_graphique_attendues);
            
        end
    end
    
end