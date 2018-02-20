function tester_programme
% Lancer cette fonction pour effectuer les tests du programmes que l'on a
% programmé

%% On importe les tests de Test_Controleur.m
batterie_de_test = matlab.unittest.TestSuite.fromFile('Tests/Test_Controleur.m');

%% On importe une bibliothèque de Matlab qui permet de paramétrer les tests
import matlab.unittest.selectors.HasParameter

%% Formule logique qui permet de ne tester que les valeurs de propriétés qui
% sont valides pour un choix de région d'intérêt polygonale
parametrage = HasParameter('Property','axe_moyenne_choisi', 'Name','un_et_deux') & ...
    (HasParameter('Property','axe_abscisses_choisi', 'Name','trois') | ...
    HasParameter('Name','quatre'));

%% On donne les paramètres à la batterie de test
batterie_de_test_parametree = batterie_de_test.selectIf(parametrage);

%% On lance les tests
batterie_de_test_parametree.run;
end

