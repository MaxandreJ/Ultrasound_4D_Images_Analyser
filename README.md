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

The application was developped by Maxandre Jacqueline, student at Ecole Centrale Paris, for his final internship. It uses object oriented programming (OOP) and the model-view-controller design pattern.

If you want to collaborate on this programme, don't hesitate to fork me or to send me an email on the address written below so I can add you as a collaborator on this repository.

### Français

Application permettant d'analyser des séquences 4D d'images ultrasonores, réalisée pendant mon stage à l'hôpital Gustave Roussy à Villejuif
près de Paris. Programme écrit sous la supervision du Dr. Stéphanie Pitre-Champagnat, CNRS, UMR 8081 Imagerie par Résonance Magnétique
Médicale et Multi-Modalités ("IR4M"), équipe 3 Imagerie multimodale en cancérologie dirigée par le Dr. Natalie Lassau.
Plus d'informations sont disponibles sur l'unité UMR 8081 du CNRS à cette adresse : http://www.ir4m.u-psud.fr/ .

Actuellement l'application ne peut ouvrir que des images réalisées avec l'échographe Aplio 500 de Toshiba Medical Systems, qui doivent
préablement êtres converties par leur logiciel propriétaire appelé "RawDataExport" (pas disponible sur ce dépôt).

L'ensemble du programme est écrit en français.

L'application a été développé par Maxandre Jacqueline, étudiant à l'Ecole Centrale Paris, pour son stage de fin d'études. Elle utilise
la programmation orientée objet et le patron de conception modèle-vue-contrôleur.

Si vous voulez collaborer sur ce programme, n'hésitez pas à créer une nouvelle branche ou à m'envoyer un courriel à l'adresse écrite ci-dessous, pour que je puisse vous ajouter en tant que collaborateur sur ce dépôt.

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

## Warning note on data consistency - Avertissemment sur la cohérence des données

### English

Although what's shown in the user interface is always consistent with what the user wants to do, the state of properties of objects is not always consistent. This is due to programming errors on my behalf: I sometimes reset the display, when I should have instead reset the properties of objects themselves.

As a consequence, don't analyse first an image, then another one, and try to extract the data from objects which properties are updated at later analysis steps than the one you are currently at with the new image. For example, don't create a chart with a first image, then load a second image and immediately try to extract data from the "graphique" object (before you have created the chart on the new image) : you would get the data from the previous image.

### Français

Bien que ce qui est affiché sur l'interface utilisateur est toujours cohérent avec l'intuition de l'utilisateur, les valeurs des propriétés des objets ne sont pas toujours cohérentes. Cela est dûe à des erreurs de programmation de ma part : parfois je remet à zéro l'affichage, quand j'aurais plutôt dû remettre à zéro les propriétés des objets.

Par conséquent, n'analysez pas une image, puis une autre, en voulant extraire les données d'objets dont les propriétés sont mises à jours à des étapes plus tardives d'analyse que celle à laquelle vous vous trouver avec la nouvelle image. Par exemple, ne créez pas un graphique avec une première image, puis chargez une seconde image en voulant extraire immédiatement des données de l'objet "graphique" (avant d'avoir créé le graphique sur la nouvelle image): vous obtiendriez les données de l'ancienne image analysée.

## Contacting the developer behind the software - Comment contacter le développeur qui a écrit le logiciel

### English

If it is necessary you can reach me at the following address (please remove spaces) : 
maxandre    .    jacqueline    @   me     .    com

### Français
Si cela est nécessaire vous pouvez me contacter à l'adresse suivante (enlevez les espaces) : 
maxandre    .    jacqueline    @   me     .    com
