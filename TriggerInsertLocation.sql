CREATE OR REPLACE TRIGGER triggerInsertSituation
BEFORE INSERT ON Location
REFERENCING NEW AS n
FOR EACH ROW
BEGIN
    --verif vehicule.situation == 'disponible'
    --sinon afficher "Le véhicule vehicule.numveh n'est pas dispo"

    --sequence de fou furieux a faire

    --location.montant = 
    --  SELECT t.tarif
    --  FROM Tarifs t
    --  JOIN Modeles m ON m.numcat = t.numcat
    --  JOIN Vehicule v ON v.modele = m.modele
    --  WHERE t.formule = n.formule
    --  AND v.numveh = n.numveh

EXCEPTION


END;