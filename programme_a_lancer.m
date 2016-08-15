function programme_a_lancer()
%Merci de lancer ce script pour lancer le programme.

%% Ajout du répertoire Modèle au chemin de Matlab
chemin = fullfile(pwd,'Modele');
chemin_matlab = genpath(chemin);
addpath(chemin_matlab);

%% Ajout du répertoire Vue au chemin de Matlab
chemin = fullfile(pwd,'Vue');
chemin_matlab = genpath(chemin);
addpath(chemin_matlab);

%% Ajout du répertoire Controleur au chemin de Matlab
chemin = fullfile(pwd,'Controleur');
chemin_matlab = genpath(chemin);
addpath(chemin_matlab);

%% Ajout du répertoire Interface Homme Machine au chemin de Matlab
chemin = fullfile(pwd,'Interface Homme Machine');
chemin_matlab = genpath(chemin);
addpath(chemin_matlab);

%% Ajout du répertoire altmany-export_fig au chemin de Matlab
chemin = fullfile(pwd,'altmany-export_fig');
chemin_matlab = genpath(chemin);
addpath(chemin_matlab);

%% Lancement du programme
modele = Modele;
controleur = Controleur(modele);