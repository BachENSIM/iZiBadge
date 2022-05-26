# iZiBadge - Projet 4A ENSIM

Conçu et réalisé par Thomas Desgranges, Duc Bach Nguyen, Abdelmonaim Chekroun.

Encadré par M. May.

## Description de l'application

iZiBadge permet de sécuriser les entrées (et sorties) de personnes pour vos événements.

L'application envoie un QR Code unique à chaque invité qu'il présentera à l'organisateur 
ou autre personne en charge de vérifier les entrées. Cette dernière scanne le QR Code 
grâce à la même application.

## Côté Invité

### Comment utiliser l'application

Une fois connecté, l'application vous présente la liste de tous les événements auxquels 
vous êtes invité (ou organisateur/scanneur). En tapant sur un événement, vous aurez accès 
à toutes les informations liées à celui-ci. Cela fait aussi apparaître 2 icônes.

Le premier permet d'afficher le QR Code qui vous sera demandé à l'entrée.

Le deuxième permet de sauvegarder en local dans votre téléphone toutes les informations 
relatives à cet événement, et le QR Code. Ainsi, la prochaine fois que vous lancerez 
iZiBadge, si vous n'avez pas d'accès à Internet, vous aurez tout de même accès à ces données.

C'est tout ce que vous devez savoir !

## Côté Organisateur

En tant qu'organisateur, vous pouvez créer des événements et inviter des personnes. 
Pour cela, rien de plus simple.

### Comment utiliser l'application

Tout d'abord, une fois connecté, l'application vous présente la liste de tous les événements 
auxquels vous êtes soit invité, soit organisateur, soit scanneur. Vous pouvez filtrer 
les événements en fonction de votre rôle.

Pour créer un événement, tapez sur le bouton Plus orange.

Indiquez le nom de l'événement, une adresse, une date et une description avec des 
informations complémentaires.

Ensuite, si votre événement se déroule sur plusieurs jours ou que vous ne voulez pas 
que tous les invités soient autorisés à entrer en même temps, vous pouvez créer des groupes 
et leur attribuer séparément des horaires/dates de validité d'entrée différents.

Finalement, vous pouvez inviter vos convives en renseignant leur adresse e-mail. 
N'oubliez pas de les assigner à un groupe si vous en avez créé.

### Pour aller plus loin

Pour déléguer la tâche de scanner les QR Codes à d'autres personnes, il faut inviter 
cette personne et lui indiquer le rôle de "Scanneur" au lieu d'"Invité".

## Documentation technique

Le projet a été développé en Flutter v.2.10 (Dart v2.16).

La base de données utilisée est Firestore Database.

Pour contribuer au projet, il suffit de cloner le repository. Vous pourrez ensuite 
ouvrir le projet dans n'importe quel IDE (de préférence Android Studio, mais Visual Studio 
Code fonctionne aussi avec les extensions).

Les principaux fichiers source se trouvent dans [`/lib`](/lib). Vous y trouverez le [`main.dart`](/lib/main.dart), 
ainsi que les autres fichier sources rangés dans 4 dossiers.

La gestion de l'authentification de la page de connexion se trouve dans [`/services`](/lib/services).

La gestion des appels à la base de données se trove dans [`/model`](/lib/model).

Les différents écrans se trouvent dans [`/screens`](/lib/screens).

Les différents composants constituant les écrans se trouvent dans [`/components`](/lib/components).
