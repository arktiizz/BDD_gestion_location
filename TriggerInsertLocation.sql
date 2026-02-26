CREATE OR REPLACE TRIGGER triggerInsertLocation 
BEFORE INSERT ON Location
FOR EACH ROW
BEGIN
    --verif vehicule.situation == 'disponible'
    --sinon afficher "Le véhicule vehicule.numveh n'est pas dispo"
    

END;