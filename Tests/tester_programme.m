function tester_programme

batterie_de_test = matlab.unittest.TestSuite.fromFile('Tests/Test_Controleur.m');

import matlab.unittest.selectors.HasParameter
parametrage = HasParameter('Property','axe_moyenne_choisi', 'Name','un_et_deux') & ...
    (HasParameter('Property','axe_abscisses_choisi', 'Name','trois') | ...
    HasParameter('Name','quatre'));

batterie_de_test_parametree = batterie_de_test.selectIf(parametrage);

batterie_de_test_parametree.run;
end

