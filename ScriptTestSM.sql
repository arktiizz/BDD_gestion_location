-- Données de la table Categories
INSERT INTO Categories(NumCat, Categorie, PrixKm) VALUES(1,'Citadine',0.3);
INSERT INTO Categories(NumCat, Categorie, PrixKm) VALUES(2,'Berline',0.4);
INSERT INTO Categories(NumCat, Categorie, PrixKm) VALUES(3,'Monospace',0.4);
INSERT INTO Categories(NumCat, Categorie, PrixKm) VALUES(4,'SUV',0.5);
INSERT INTO Categories(NumCat, Categorie, PrixKm) VALUES(5,'Utilitaire-3m3',0.3);
INSERT INTO Categories(NumCat, Categorie, PrixKm) VALUES(6,'Utilitaire-9m3',0.4);
INSERT INTO Categories(NumCat, Categorie, PrixKm) VALUES(7,'Utilitaire-14m3',0.5);
INSERT INTO Categories(NumCat, Categorie, PrixKm) VALUES(8,'Utilitaire-14m3',0);
INSERT INTO Categories(NumCat, Categorie, PrixKm) VALUES(9,'SUV',0.5);

-- Données de la table Modeles
INSERT INTO Modeles(Modele, Marque, NumCat) VALUES('Captur','Renault',0); --dans Categories numcat 0 existe pas ?
INSERT INTO Modeles(Modele, Marque, NumCat) VALUES('Clio','Renault',1);
INSERT INTO Modeles(Modele, Marque, NumCat) VALUES('208','Peugeot',1);
INSERT INTO Modeles(Modele, Marque, NumCat) VALUES('C3','Citroen',1);
INSERT INTO Modeles(Modele, Marque, NumCat) VALUES('508','Peugeot',2);
INSERT INTO Modeles(Modele, Marque, NumCat) VALUES('Scenic','Renault',3);
INSERT INTO Modeles(Modele, Marque, NumCat) VALUES('3008','Peugeot',4);
INSERT INTO Modeles(Modele, Marque, NumCat) VALUES('Jumpy','Citroen',6);
INSERT INTO Modeles(Modele, Marque, NumCat) VALUES('Master','Renault',7);

-- Données de la table Vehicule
INSERT INTO Vehicule(NumVeh, Modele, Km) VALUES(1,'Clio',1000);
INSERT INTO Vehicule(NumVeh, Modele, Km) VALUES(2,'208',1000);
INSERT INTO Vehicule(NumVeh, Modele, Km) VALUES(3,'C3',1000);
INSERT INTO Vehicule(NumVeh, Modele, Km) VALUES(4,'508',1000);
INSERT INTO Vehicule(NumVeh, Modele, Km) VALUES(5,'Scenic',1000);
INSERT INTO Vehicule(NumVeh, Modele, Km) VALUES(6,'3008',1000);
INSERT INTO Vehicule(NumVeh, Modele, Km) VALUES(7,'Jumpy',1000);
INSERT INTO Vehicule(NumVeh, Modele, Km) VALUES(8,'Master',1000);
INSERT INTO Vehicule(NumVeh, Modele, Km) VALUES(9,'C5',1000); --dans Modeles, modele 'C5' existe pas ?
INSERT INTO Vehicule(NumVeh, Modele, Km) VALUES(10,'508',50001);

-- Données de la table Formules
INSERT INTO Formules(Formule, NbJours, ForfaitKm) VALUES('jour',1,100);
INSERT INTO Formules(Formule, NbJours, ForfaitKm) VALUES('jour',0,1000); --violation contrainte unique, 2x 'jour' ?
INSERT INTO Formules(Formule, NbJours, ForfaitKm) VALUES('fin-semaine',2,200);
INSERT INTO Formules(Formule, NbJours, ForfaitKm) VALUES('fin-semaine',1,0); --violation contrainte unique aussi
INSERT INTO Formules(Formule, NbJours, ForfaitKm) VALUES('semaine',7,500);
INSERT INTO Formules(Formule, NbJours, ForfaitKm) VALUES('mois',30,1000);

-- Données de la table Tarifs
INSERT INTO Tarifs(NumCat, Formule, Tarif) VALUES(0,'jour',29); --dans Categories, numcat 0 existe pas
INSERT INTO Tarifs(NumCat, Formule, Tarif) VALUES(1,'jour',39);
INSERT INTO Tarifs(NumCat, Formule, Tarif) VALUES(1,'fin-semaine',69);
INSERT INTO Tarifs(NumCat, Formule, Tarif) VALUES(1,'semaine',199);
INSERT INTO Tarifs(NumCat, Formule, Tarif) VALUES(1,'mois',499);
INSERT INTO Tarifs(NumCat, Formule, Tarif) VALUES(2,'jour',59);
INSERT INTO Tarifs(NumCat, Formule, Tarif) VALUES(2,'fin-semaine',99);
INSERT INTO Tarifs(NumCat, Formule, Tarif) VALUES(2,'semaine',299);
INSERT INTO Tarifs(NumCat, Formule, Tarif) VALUES(2,'mois',799);
INSERT INTO Tarifs(NumCat, Formule, Tarif) VALUES(3,'jour',69);
INSERT INTO Tarifs(NumCat, Formule, Tarif) VALUES(3,'fin-semaine',129);
INSERT INTO Tarifs(NumCat, Formule, Tarif) VALUES(3,'semaine',499);
INSERT INTO Tarifs(NumCat, Formule, Tarif) VALUES(3,'mois',1099);
INSERT INTO Tarifs(NumCat, Formule, Tarif) VALUES(4,'jour',69);
INSERT INTO Tarifs(NumCat, Formule, Tarif) VALUES(4,'fin-semaine',129);
INSERT INTO Tarifs(NumCat, Formule, Tarif) VALUES(4,'semaine',499);
INSERT INTO Tarifs(NumCat, Formule, Tarif) VALUES(4,'mois',1099);
INSERT INTO Tarifs(NumCat, Formule, Tarif) VALUES(5,'jour',39);
INSERT INTO Tarifs(NumCat, Formule, Tarif) VALUES(5,'fin-semaine',79);
INSERT INTO Tarifs(NumCat, Formule, Tarif) VALUES(5,'semaine',199);
INSERT INTO Tarifs(NumCat, Formule, Tarif) VALUES(5,'mois',599);
INSERT INTO Tarifs(NumCat, Formule, Tarif) VALUES(6,'jour', 49);
INSERT INTO Tarifs(NumCat, Formule, Tarif) VALUES(6,'fin-semaine',99);
INSERT INTO Tarifs(NumCat, Formule, Tarif) VALUES(6,'semaine',259);
INSERT INTO Tarifs(NumCat, Formule, Tarif) VALUES(6,'mois',899);
INSERT INTO Tarifs(NumCat, Formule, Tarif) VALUES(7,'jour',79);
INSERT INTO Tarifs(NumCat, Formule, Tarif) VALUES(7,'mois',0);
INSERT INTO Tarifs(NumCat, Formule, Tarif) VALUES(7,'fin-semaine',159);
INSERT INTO Tarifs(NumCat, Formule, Tarif) VALUES(7,'vacances',159); --Formule 'vacances existe pas
INSERT INTO Tarifs(NumCat, Formule, Tarif) VALUES(7,'semaine',359);
INSERT INTO Tarifs(NumCat, Formule, Tarif) VALUES(7,'mois',1199);