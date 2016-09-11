# Ultrasound_4D_Images_Analyser

## Summary - Résumé

### English
Application allowing for analysis of 4D ultrasound images, written as part of an internship at Europe's leading cancer hospital 
Gustave Roussy near Paris in France. Written under the supervision of Stéphanie Pitre-Champagnat, PhD, CNRS, unit UMR 8081 "IR4M", 
team 3 Multimodal Imagery in Oncology headed by Natalie Lassau, MD, PhD. 
More information on unit UMR 8081 of CNRS can be found here : http://www.ir4m.u-psud.fr/ .

Currently it can only open files extracted from Toshiba Medical System's Aplio 500 ultrasound machine that have first been processed 
by their proprietary software called "RawDataExport" (not available on this repository).

The interface, variable names, comments and documentation are written in French. Please don't hesitate to translate 
these into English if you feel like it (just fork my repository or send me an email so we can collaborate). 
Or you can also use a dictionary and learn 50 words of French.

### Français

Application permettant d'analyser des séquences 4D d'images ultrasonores, réalisée pendant mon stage à l'hôpital Gustave Roussy à Villejuif
près de Paris. Programme écrit sous la supervision du Dr. Stéphanie Pitre-Champagnat, CNRS, UMR 8081 Imagerie par Résonance Magnétique
Médicale et Multi-Modalités ("IR4M"), équipe 3 Imagerie multimodale en cancérologie dirigée par le Dr. Natalie Lassau.
Plus d'informations sont disponibles sur l'unité UMR 8081 du CNRS à cette adresse : http://www.ir4m.u-psud.fr/ .

Actuellement l'application ne peut ouvrir que des images réalisées avec l'échographe Aplio 500 de Toshiba Medical Systems, qui doivent
préablement êtres converties par leur logiciel propriétaire appelé "RawDataExport" (pas disponible sur ce dépôt).

L'ensemble du programme est écrit en français.

## How to launch the application - Comment lancer l'application

### English
Run lancer_programme on Matlab R2014b or more recent.

The application works on PC, Mac and maybe Linux as well. 

The reason why it wouldn't work on an older version of Matlab than R2014b is because it introduced 
the dot notation for accessing properties of objects, which I use in my programme.

### Français

Lancer lancer_programme.m sur Matlab R2014b ou une version plus récente.

L'application fonctionne sur PC, sur Mac et peut-être sur Linux aussi.

La raison pour laquelle elle ne fonctionnerait pas sur une version plus ancienne de Matlab est parce que la R2014b a introduit
la possibilité d'utiliser la notation point (.) pour accéder aux propriétés d'objets, dont je me sers dans mon programme.

## How to use the application on sample data - Comment utiliser l'application sur des données de test

### English

The sample data is located in the directory Donnees de test. 

Both Raw and Voxel Data are available in this directory. To open the one you like, choose its name in the pop-up menu in the "chargement
des données (1ère étape)" part of the interface, select the directory that contains the files (PatientInfo.txt and the other .bin files),
and click "Charger".

These data have been extracted from Toshiba Medical Systems's 
Aplio 500 ultrasound machine and exported through their proprietary software RawDataExport.

The explanation on how to export data with RawDataExport and the actual software RawDataExport is not available to the public, but you
may be able to get it from Toshiba Medical Systems.

### Français

Les données de test sont dans le dossier Donnes de test.

Des données au format RawData et VoxelData sont disponibles dans ce dossier. Pour ouvrir les données au format que vous souhaitez,
choisissez son nom (RawData ou VoxelData) dans la liste du menu déroulant dans la partie "chargement des données (1ère étape)" de l'interface,
puis sélectionnez le dossier qui contient les fichiers (dont PatientInfo.txt et les autres fichiers .bin des données), et cliquez sur le
bouton "Charger".

Ces données ont été extraites de l'échographe Aplio 500 fabriqué par Toshiba Medical Systems, puis converties par leur logiciel 
propriétaire RawDataExport.

L'explication sur comment exporter des données avec RawDataExport et le logiciel RawDataExport ne sont pas disponibles pour le public,
mais vous pourriez les obtenir en contactant Toshiba Medical Systems.

## How to access the documentation - Comment accéder à la documentation

### English

Open the folder Documentation. All the pdfs that are in the main folder serve as documentation.

The most important file, that you should read first, is the one called Rapport de stage (in French).

### Français

Ouvrir le dossier Documentation. Tous les Pdfs qui sont dans le dossier principal sont la documentation de mon programme.

Le document le plus important, par lequel vous devriez commencer, est mon rapport de stage (en Français).

## How to run the unit tests of the programme - Comment lancer les tests unitaires de mon programme

### English

Open the Tests directory and run lancer_tests.m in Matlab R2014b or newer.

If the command line says that tests are done, it means that all tests are passed. 
I only coded one test because I lacked time to code more.

### Français

Ouvrir le répertoire Tests et lancer lancer_tests.m sur Matlab R2014b ou plus récent.

Si la ligne de commande dit "Tests are done", cela veut dire que tous les tests ont réussis.
J'ai seulement codé un test par manque de temps.
