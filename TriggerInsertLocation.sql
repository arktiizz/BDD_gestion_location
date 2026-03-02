CREATE OR REPLACE TRIGGER triggerInsertSituation
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
        RAISE_APPLICATION_ERROR(-20001, 'Le véhicule ' || :n.NumVeh || 'n''est pas disponible');
    END IF;

    if :n.DateDepart < TRUNC(SYSDATE) THEN
        RAISE_APPLICATION_ERROR(-20002, 'La date de départ ne peut pas être antérieur à la date d''aujourd''hui');
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
            RAISE_APPLICATION_ERROR(-20003, 'Erreur : Impossible de trouver le tarif ou la formule correspondant au véhicule.');
    END;