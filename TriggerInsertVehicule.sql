CREATE OR REPLACE TRIGGER triggerInsertVehicule
BEFORE INSERT ON Vehicule
REFERENCING NEW AS n
FOR EACH ROW
BEGIN
    IF :n.Km > 50000 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Le km du vehicule ne peut pas dépasser 50 000km.');
    END IF;
END;