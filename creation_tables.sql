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
    PrixKm NUMBER NOT NULL,

    CONSTRAINT checkPrixKmPositif CHECK (PrixKm >= 0)
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
    Situation VARCHAR2(100) DEFAULT 'disponible' NOT NULL,
    NbJoursLoc NUMBER DEFAULT 0 NOT NULL,
    CAV NUMBER DEFAULT 0 NOT NULL,
    
    CONSTRAINT checkKmPositif CHECK (Km >= 0),
    CONSTRAINT checkKmLimite CHECK (Km <= 50000),
    CONSTRAINT checkSituation CHECK (Situation IN ('location', 'disponible', 'retraite'))

);

CREATE TABLE VehiculeRetraite (
    NumVeh NUMBER PRIMARY KEY REFERENCES Vehicule(NumVeh), 
    DateRetraite DATE NOT NULL
);

CREATE TABLE Formules (
    Formule VARCHAR2(100) PRIMARY KEY,
    NbJours NUMBER NOT NULL,
    ForfaitKm NUMBER NOT NULL,

    CONSTRAINT checkNbJoursPositif CHECK (NbJours >= 0)
);

CREATE TABLE Tarifs (
    NumCat NUMBER,
    Formule VARCHAR2(100),
    Tarif NUMBER NOT NULL,

    CONSTRAINT pk_tarifs PRIMARY KEY (NumCat, Formule),

    CONSTRAINT fk_tarifs_cat FOREIGN KEY (NumCat) REFERENCES Categories(NumCat),
    CONSTRAINT fk_tarifs_formule FOREIGN KEY (Formule) REFERENCES Formules(Formule),

    CONSTRAINT chk_tarif_positif CHECK (Tarif >= 0)
);

CREATE TABLE Location (
    NumLoc VARCHAR2(50) PRIMARY KEY,
    NumVeh NUMBER REFERENCES Vehicule(NumVeh),
    Formule VARCHAR2(100) REFERENCES Formules(Formule),
    DateDepart DATE NOT NULL,
    DateRetour DATE,
    KmLoc NUMBER DEFAULT 0 NOT NULL,
    Montant NUMBER,

    CONSTRAINT check_DateRetour CHECK (DateRetour > DateDepart)
);

commit;