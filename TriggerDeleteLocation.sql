CREATE OR REPLACE TRIGGER trigger_delete_location
BEFORE DELETE ON Location
FOR EACH ROW 
BEGIN
    IF :OLD.Kmloc > 0 THEN
        RAISE_APPLICATION_ERROR(-20001,'Impossible d annuler si le nombre de Kilometres de la location n est pas nul.');
    END IF;

    UPDATE Vehicule
    SET Situation = 'disponible'
    WHERE NumVeh = :OLD.NumVeh;

END;