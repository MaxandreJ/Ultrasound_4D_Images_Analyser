function programme_a_lancer()
%Merci de lancer ce script pour lancer le programme.

%% Ajout du répertoire Modèle au chemin de Matlab
code = fullfile(pwd,'Modele');
chemin_code = genpath(code);
addpath(chemin_code);

%% Ajout du répertoire Vue au chemin de Matlab
code = fullfile(pwd,'Vue');
chemin_code = genpath(code);
addpath(chemin_code);

%% Ajout du répertoire Controleur au chemin de Matlab
code = fullfile(pwd,'Controleur');
chemin_code = genpath(code);
addpath(chemin_code);

%% Ajout du répertoire Interface Homme Machine au chemin de Matlab
code = fullfile(pwd,'Interface Homme Machine');
chemin_code = genpath(code);
addpath(chemin_code);

%% Ajout du répertoire altmany-export_fig au chemin de Matlab
code = fullfile(pwd,'altmany-export_fig');
chemin_code = genpath(code);
addpath(chemin_code);

%% Lancement du programme
modele = Modele;
controleur = Controleur(modele);