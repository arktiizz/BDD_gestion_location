DROP TABLE Categories CASCADE CONSTRAINTS;
DROP TABLE Modeles CASCADE CONSTRAINTS;
DROP TABLE Vehicule CASCADE CONSTRAINTS;
DROP TABLE VehiculeRetraite CASCADE CONSTRAINTS;
DROP TABLE Formules CASCADE CONSTRAINTS;
DROP TABLE Tarifs CASCADE CONSTRAINTS;
DROP TABLE Location CASCADE CONSTRAINTS;

--salut a tous

CREATE TABLE Categories (
    NumCat NUMBER PRIMARY KEY,
    Categorie VARCHAR2(100),
    PrixKm NUMBER NOT NULL
);

CREATE TABLE Modeles ( 
    Modele VARCHAR2(100) PRIMARY KEY,
    Marque VARCHAR2(100) NOT NULL,
    NumCat NUMBER NOT NULL REFERENCES Categories(NumCat)
);

CREATE TABLE Vehicule (
    NumVeh NUMBER PRIMARY KEY,
    Modele VARCHAR2(100) NOT NULL REFERENCES Modeles(Modele),
    Km NUMBER NOT NULL,
    Situation VARCHAR2(100) NOT NULL,
    NbJoursLoc NUMBER DEFAULT 0 NOT NULL,
    CAV NUMBER DEFAULT 0 NOT NULL,
    
    CONSTRAINT checkKmPositif CHECK (Km >= 0)
);

CREATE TABLE VehiculeRetraite (
    NumVeh NUMBER PRIMARY KEY REFERENCES Vehicule(NumVeh), 
    DateRetraite DATE NOT NULL
);

CREATE TABLE Formules (
    Formule VARCHAR2(100) PRIMARY KEY,
    NbJours NUMBER NOT NULL,
    ForfaitKm NUMBER NOT NULL 
);

CREATE TABLE Tarifs (
    NumCat NUMBER REFERENCES Categories(NumCat),
    Formule VARCHAR2(100) REFERENCES Formules(Formule),
    Tarif NUMBER NOT NULL
);

CREATE TABLE Location (
    NumLoc NUMBER PRIMARY KEY,
    NumVeh NUMBER REFERENCES Vehicule(NumVeh),
    Formule VARCHAR2(100) REFERENCES Formules(Formule),
    DateDepart DATE NOT NULL,
    DateRetour DATE NOT NULL,
    KmLoc NUMBER NOT NULL,
    Montant NUMBER NOT NULL,

    CONSTRAINT check_DateRetour CHECK (DateRetour > DateDepart)
);

commit;

INSERT INTO Categories (NumCat, Categorie, PrixKm) VALUES (1, 'Citadine', 0.3);
INSERT INTO Categories (NumCat, Categorie, PrixKm) VALUES (2, 'Berline', 0.4);
INSERT INTO Categories (NumCat, Categorie, PrixKm) VALUES (3, 'Monospace', 0.4);
INSERT INTO Categories (NumCat, Categorie, PrixKm) VALUES (4, 'SUV', 0.4);
INSERT INTO Categories (NumCat, Categorie, PrixKm) VALUES (5, '3m3', 0.3);
INSERT INTO Categories (NumCat, Categorie, PrixKm) VALUES (6, '9m3', 0.4);
INSERT INTO Categories (NumCat, Categorie, PrixKm) VALUES (7, '14m3', 0.45);

INSERT INTO Modeles (Modele, Marque, NumCat) VALUES ('CLIO', 'RENAULT', 1);
INSERT INTO Modeles (Modele, Marque, NumCat) VALUES ('208', 'PEUGEOT', 1);
INSERT INTO Modeles (Modele, Marque, NumCat) VALUES ('C3', 'CITROEN', 1);
INSERT INTO Modeles (Modele, Marque, NumCat) VALUES ('A4', 'AUDI', 2);
INSERT INTO Modeles (Modele, Marque, NumCat) VALUES ('508', 'PEUGEOT', 2);
INSERT INTO Modeles (Modele, Marque, NumCat) VALUES ('PICASSO', 'CITROEN', 3);
INSERT INTO Modeles (Modele, Marque, NumCat) VALUES ('SCENIC', 'RENAULT', 3);
INSERT INTO Modeles (Modele, Marque, NumCat) VALUES ('5008', 'PEUGEOT', 4);
INSERT INTO Modeles (Modele, Marque, NumCat) VALUES ('KANGOO', 'RENAULT', 5);
INSERT INTO Modeles (Modele, Marque, NumCat) VALUES ('TRANSIT', 'FORD', 6);
INSERT INTO Modeles (Modele, Marque, NumCat) VALUES ('MASTER', 'RENAULT', 7);
INSERT INTO Modeles (Modele, Marque, NumCat) VALUES ('TIGUAN', 'VW', 4);
INSERT INTO Modeles (Modele, Marque, NumCat) VALUES ('VITO', 'MERCEDES', 6);
INSERT INTO Modeles (Modele, Marque, NumCat) VALUES ('DUCATO', 'FIAT', 1); 

INSERT INTO Formules (Formule, NbJours, ForfaitKm) VALUES ('jour', 1, 100);
INSERT INTO Formules (Formule, NbJours, ForfaitKm) VALUES ('fin-semaine', 2, 200);
INSERT INTO Formules (Formule, NbJours, ForfaitKm) VALUES ('semaine', 7, 500);
INSERT INTO Formules (Formule, NbJours, ForfaitKm) VALUES ('mois', 30, 1500);

-- Catégorie 1 (Citadine)
INSERT INTO Tarifs (NumCat, Formule, Tarif) VALUES (1, 'jour', 39);
INSERT INTO Tarifs (NumCat, Formule, Tarif) VALUES (1, 'fin-semaine', 69);
INSERT INTO Tarifs (NumCat, Formule, Tarif) VALUES (1, 'semaine', 199);
INSERT INTO Tarifs (NumCat, Formule, Tarif) VALUES (1, 'mois', 499);
-- Catégorie 2 (Berline)
INSERT INTO Tarifs (NumCat, Formule, Tarif) VALUES (2, 'jour', 59);
INSERT INTO Tarifs (NumCat, Formule, Tarif) VALUES (2, 'fin-semaine', 99);
INSERT INTO Tarifs (NumCat, Formule, Tarif) VALUES (2, 'semaine', 299);
INSERT INTO Tarifs (NumCat, Formule, Tarif) VALUES (2, 'mois', 799);
-- Catégorie 3 (Monospace)
INSERT INTO Tarifs (NumCat, Formule, Tarif) VALUES (3, 'jour', 69);
INSERT INTO Tarifs (NumCat, Formule, Tarif) VALUES (3, 'fin-semaine', 129);
INSERT INTO Tarifs (NumCat, Formule, Tarif) VALUES (3, 'semaine', 499);
INSERT INTO Tarifs (NumCat, Formule, Tarif) VALUES (3, 'mois', 1099);
-- Catégorie 4 (SUV)
INSERT INTO Tarifs (NumCat, Formule, Tarif) VALUES (4, 'jour', 69);
INSERT INTO Tarifs (NumCat, Formule, Tarif) VALUES (4, 'fin-semaine', 129);
INSERT INTO Tarifs (NumCat, Formule, Tarif) VALUES (4, 'semaine', 499);
INSERT INTO Tarifs (NumCat, Formule, Tarif) VALUES (4, 'mois', 1099);
-- Catégorie 5 (3m3)
INSERT INTO Tarifs (NumCat, Formule, Tarif) VALUES (5, 'jour', 39);
INSERT INTO Tarifs (NumCat, Formule, Tarif) VALUES (5, 'fin-semaine', 79);
INSERT INTO Tarifs (NumCat, Formule, Tarif) VALUES (5, 'semaine', 199);
INSERT INTO Tarifs (NumCat, Formule, Tarif) VALUES (5, 'mois', 599);
-- Catégorie 6 (9m3)
INSERT INTO Tarifs (NumCat, Formule, Tarif) VALUES (6, 'jour', 49);
INSERT INTO Tarifs (NumCat, Formule, Tarif) VALUES (6, 'fin-semaine', 99);
INSERT INTO Tarifs (NumCat, Formule, Tarif) VALUES (6, 'semaine', 259);
INSERT INTO Tarifs (NumCat, Formule, Tarif) VALUES (6, 'mois', 899);
-- Catégorie 7 (14m3)
INSERT INTO Tarifs (NumCat, Formule, Tarif) VALUES (7, 'jour', 79);
INSERT INTO Tarifs (NumCat, Formule, Tarif) VALUES (7, 'fin-semaine', 159);
INSERT INTO Tarifs (NumCat, Formule, Tarif) VALUES (7, 'semaine', 359);
INSERT INTO Tarifs (NumCat, Formule, Tarif) VALUES (7, 'mois', 1199);

commit;
