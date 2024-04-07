# SAE Mobile


## Origine du projet


Ce projet a été réalisé dans le cadre de la SAE 4.04 du module `Développement pour applications mobiles` lors de notre seconde année de BUT Informatique à l'IUT d'Orléans.
Il nous a été demandé de réaliser une application mobile en flutter qui permet de prêter ou de demander du matérial à nos collègues étudiants ou apprentis.
Nous devions avoir un système d'authentification de la personne.


## Membres de l'équipe


- BOURREAU Quentin
- DEBRAY Antoine
- SOTTIER Liam


## Fonctionnalités implémentées


Lorsque vous arrivez sur l'application, celle-ci vous demande de vous connecter.
Si vous n'avez pas encore de compte, vous pouvez vous inscrire avec un formulaire d'inscription.
Bien évidemment, si vous étiez connecté au dernier lancement de l'application sur votre smartphone, celui-ci garde sa mémoire et vous n'avez pas besoin de vous réauthentifier.
Une fois connecté, vous arrivez sur la page d'accueil où vous retrouvez l'ensemble des prêts et demandes des utilisateurs n'ayant pas eu encore de réponses, séparés par deux onglets distincts.
En bas de notre application (que vous retrouverez sur l'ensemble de notre application), vous pouvez retrouver un menu contenant le bouton 'Home' pour revenir à l'accueil, mais également le bouton 'Profil' pour aller sur votre profil.
Sur votre profil, vous pouvez retrouver vos informations personnelles (Mail, Nom, Prénom), un bouton de déconnexion, les boutons associées à votre compte (base de données locale), puis le menu inférieur toujours :
- 'Mes produits' : la page où vous retrouvez vos produits et où vous pouvez en ajouter un nouveau. La page d'ajout comporte les informations d'un produit et l'association du produit à une catégorie obligatoirement (dont vous pouvez en créer une nouvelle).
- 'Mes prêts' : l'ensemble de vos prêts (pas encore publiés) et la possibilité d'en ajouter un également (bien évidemment des contraintes ont été mises en place comme les dates de début et de fin supérieures à aujourd'hui par exemple). Puis, lorsque vous cliquez sur un prêt cela vous propose de le publier en ligne pour les autres utilisateurs (celui-ci ne sera plus visible dans cette page, mais apparaîtra dans la page 'Mes publications').
- 'Mes prêts' : l'ensemble de vos demandes (pas encore publiées) et la possibilité d'en ajouter un également (bien évidemment des contraintes ont été mises en place comme les dates de début et de fin supérieures à aujourd'hui par exemple). Puis, lorsque vous cliquez sur une demande, cela vous propose de la publier en ligne pour les autres utilisateurs (celle-ci ne sera plus visible dans cette page, mais apparaîtra dans la page 'Mes publications').
- 'Mes publications' : l'ensemble de vos publications (demandes et prêts) en 2 onglets qui ont été publiés. Vous pouvez cliquer sur l'une ou l'un pour voir plus en détail ses informations.


Sur la page d'accueil triée par date la plus proche, notre application offre une organisation claire et efficace des demandes et des prêts :


#### Demandes :
Cette section affiche les demandes publiées par les utilisateurs et qui ne nous appartiennent pas. Lorsque vous cliquez sur une demande, vous avez la possibilité d'ajouter un produit correspondant à la demande, à condition qu'il soit disponible et appartienne à la catégorie de la demande. Une fois que vous avez ajouté un produit à une demande et que vous cliquez sur "Réserver", la demande est retirée de la liste principale et son statut est mis à "Réservé", ce qui simplifie la gestion des transactions en cours.


#### Prêts :
Dans cette section, vous trouverez tous les prêts disponibles que les utilisateurs peuvent emprunter. En cliquant sur un prêt spécifique, vous accédez aux détails complets de cet emprunt. Si vous choisissez de "Confirmer le prêt", l'application affichera une liste des demandes correspondant à la catégorie de l'objet prêté et dont la date de disponibilité ne gêne pas avec l'objet du prêt. Cette fonctionnalité garantit une coordination optimale entre les prêts et les demandes, facilitant ainsi les échanges entre les utilisateurs.


Ces fonctionnalités sont conçues pour offrir une expérience utilisateur fluide et intuitive, en mettant en avant les éléments disponibles et en simplifiant la gestion des transactions et des échanges d'objets au sein de notre plateforme.




## Instructions d'Installation


Pour installer et exécuter l'application, suivez les étapes suivantes :


1. Clonez ce dépôt GitHub sur votre machine locale.
2. Assurez-vous d'avoir Flutter et toutes ses dépendances installées.
3. Exécutez `flutter pub get` pour installer les dépendances.
4. Connectez votre appareil mobile ou utilisez un émulateur.
5. Exécutez l'application en utilisant la commande `flutter run`.


#


BOURREAU Quentin / DEBRAY Antoine / SOTTIER Liam - BUT Informatique
