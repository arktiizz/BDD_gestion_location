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
    DateRetour DATE NOT NULL,
    KmLoc NUMBER DEFAULT 0 NOT NULL,
    Montant NUMBER NOT NULL,

    CONSTRAINT check_DateRetour CHECK (DateRetour > DateDepart)
);

DROP SEQUENCE seqLoc;

CREATE SEQUENCE seqLoc
START WITH 1
INCREMENT BY 1;

/

CREATE OR REPLACE TRIGGER triggerInsertVehicule
BEFORE INSERT ON Vehicule
REFERENCING NEW AS n
FOR EACH ROW
BEGIN
    IF :n.Km > 50000 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Le km du vehicule ne peut pas dépasser 50 000km.');
    END IF;
END;

/

CREATE OR REPLACE TRIGGER triggerInsertLocation
BEFORE INSERT ON Location
REFERENCING NEW AS n
FOR EACH ROW
DECLARE
    situationVehicule VARCHAR2(100);
    nbJoursFormule NUMBER;
    tarifTarif NUMBER;

BEGIN

    SELECT Situation
    INTO situationVehicule
    FROM Vehicule
    WHERE NumVeh = :n.NumVeh;

    if situationVehicule != 'disponible' THEN
        RAISE_APPLICATION_ERROR(-20002, 'Le véhicule ' || :n.NumVeh || 'n''est pas disponible');
    END IF;

    if :n.DateDepart < TRUNC(SYSDATE) THEN
        RAISE_APPLICATION_ERROR(-20003, 'La date de départ ne peut pas être antérieur à la date d''aujourd''hui');
    END IF;

    :n.NumLoc := 'L' || seqLoc.NEXTVAL;
    :n.KmLoc := 0;

    SELECT f.NbJours, t.Tarif
    INTO nbJoursFormule, tarifTarif
    FROM Formules f
    JOIN Tarifs t ON t.Formule = f.Formule
    JOIN Vehicule v ON v.NumVeh = :n.NumVeh
    JOIN Modeles m ON m.Modele = v.Modele
    WHERE f.Formule = :n.Formule
    AND t.NumCat = m.NumCat
    AND v.NumVeh = :n.NumVeh;

    :n.DateRetour := :n.DateDepart + nbJoursFormule;
    :n.Montant := tarifTarif;

    UPDATE Vehicule
    SET Situation = 'location'
    WHERE NumVeh = :n.NumVeh;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20004, 'Erreur : Impossible de trouver le tarif ou la formule correspondant au véhicule.');
END;

/

CREATE OR REPLACE TRIGGER triggerUpdateLocation
BEFORE UPDATE OF DateRetour, KmLoc ON Location
REFERENCING NEW AS n OLD AS o
FOR EACH ROW
DECLARE
    ForfaitKmActuel NUMBER;
    PrixKmActuel NUMBER;
    KmActuel NUMBER;
    MontantDepassement NUMBER;
    DureeLocation NUMBER;
BEGIN
    IF :o.KmLoc != 0 THEN
        RAISE_APPLICATION_ERROR(-20005, 'Cette location est terminé, impossible de le modifier.');
    END IF;

    IF :n.KmLoc < 0 THEN
        RAISE_APPLICATION_ERROR(-20006, 'Le kilométrage doit être supérieur ou égal à 0');
    END IF;

    IF :n.DateRetour > :o.DateRetour THEN
        DBMS_OUTPUT.PUT_LINE('Attention : la date de retour a été dépassée pour le véhicule ' || :n.NumVeh);
    END IF;

    SELECT f.ForfaitKm
    INTO ForfaitKmActuel
    FROM Formules f
    WHERE f.Formule = :o.Formule;

    SELECT c.PrixKm, v.Km
    INTO PrixKmActuel, KmActuel
    FROM Categories c
    JOIN Modeles m ON c.NumCat = m.NumCat
    JOIN Vehicule v ON v.Modele = m.Modele
    WHERE v.NumVeh = :o.NumVeh;

    IF (:n.KmLoc - ForfaitKmActuel) > 0 THEN
        montantDepassement := (:n.KmLoc - ForfaitKmActuel) * PrixKmActuel;
    ELSE
        montantDepassement := 0;
    END IF;

    :n.Montant := :o.Montant + MontantDepassement;
    dureeLocation := :n.DateRetour - :n.DateDepart + 1;

    IF KmActuel + :n.KmLoc > 50000 THEN
        UPDATE Vehicule
        SET Situation = 'retraite',
            Km = KmActuel + :n.KmLoc,
            NbJoursLoc = NbJoursLoc + DureeLocation,
            CAV = CAV + :n.Montant
        WHERE NumVeh = :n.NumVeh;

        INSERT INTO VehiculeRetraite(NumVeh, DateRetraite)
        VALUES(:n.NumVeh, :n.DateRetour);

        DBMS_OUTPUT.PUT_LINE('Le véhicule ' || :n.NumVeh || ' a pris sa retraite');

    ELSE
        UPDATE Vehicule
        SET Situation = 'disponible',
            Km = KmActuel + :n.KmLoc,
            NbJoursLoc = NbJoursLoc + DureeLocation,
            CAV = CAV + :n.Montant
        WHERE NumVeh = :n.NumVeh;
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20007, 'Erreur technique : Données introuvables pour ce véhicule.');
END;

/

CREATE OR REPLACE TRIGGER trigger_delete_location
BEFORE DELETE ON Location
FOR EACH ROW 
BEGIN
    IF :OLD.Kmloc > 0 THEN
        RAISE_APPLICATION_ERROR(-20008,'Impossible d annuler si le nombre de Kilometres de la location n est pas nul.');
    END IF;

    UPDATE Vehicule
    SET Situation = 'disponible'
    WHERE NumVeh = :OLD.NumVeh;

END;

/

commit;