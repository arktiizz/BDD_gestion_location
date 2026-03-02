CREATE OR REPLACE TRIGGER triggerUpdateLocation
BEFORE UPDATE OF DateRetour, KmLoc ON Location
REFERENCING NEW AS n AND OLD AS o
FOR EACH ROW
DECLARE
    ForfaitKmActuel NUMBER;
    PrixKmActuel NUMBER;
    KmActuel NUMBER;
    montantDepassement NUMBER;
    dureeLocation NUMBER
BEGIN
    IF :n.KmLoc <= 0 THEN
        RAISE_APPLICATION_ERROR(-20001, "Le kilométrage doit être supérieur ou égal à 0"); --car on peut louer un véhicule sans l'utiliser ?
    END IF;

    IF :n.DateRetour < :o.DateRetour THEN
        DBMS_OUTPUT.PUT_LINE("Attention : la date de retour a été dépassée pour le véhicule " || n.NumVeh);
    END IF;

    SELECT f.ForfaitKm
    INTO FormuleKmActuel
    FROM Formules f
    WHERE f.Formule = :o.Formule;

    SELECT c.PrixKm, v.Km
    INTO PrixKmActuel, KmActuel
    FROM Categories c
    JOIN Modeles m ON c.NumCat = m.NumCat
    JOIN Vehicule v ON v.Modele = m.Modele
    WHERE v.NumVeh = :o.NumVeh;

    IF (:n.KmLoc - v_ForfaitKm) > 0 THEN
        montantDepassement := (:n.KmLoc - v_ForfaitKm) * v_PrixKm;
    ELSE
        montantDepassement := 0;
    END IF;

    :n.Montant := :o.Montant + MontantDepassement;
    dureeLocation := :n.DateRetour - :n.DateDepart + 1;

    IF KmActuel + :n.KmLoc > 50000 THEN
        UPDATE Vehicule
        SET Km = v_KmActuel + :n.KmLoc,
            NbJoursLoc = NbJoursLoc + v_DureeLocation,
            CAV = CAV + :n.Montant
        WHERE NumVeh = :n.NumVeh;

        INSERT INTO VehiculeRetraite(NumVeh, DateRetraite)
        VALUES(:n.NumVeh, TRUNC(SYSDATE));

        DBMS_OUTPUT.PUT_LINE('Le véhicule ' || :n.NumVeh || ' a pris sa retraite');

    ELSE
        UPDATE Vehicule
        SET Situation = 'disponible',
            Km = v_KmActuel + :n.KmLoc,
            NbJoursLoc = NbJoursLoc + DureeLocation,
            CAV = CAV + :n.Montant
        WHERE NumVeh = :n.NumVeh;
    END IF;


EXCEPTION
    WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20003, 'Erreur technique : Données introuvables pour ce véhicule.');
    END;
