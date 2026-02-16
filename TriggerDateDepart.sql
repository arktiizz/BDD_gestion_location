CREATE OR REPLACE TRIGGER trigger_date_depart
BEFORE INSERT OR UPDATE ON Location 
FOR EACH ROW
BEGIN
        IF :NEW.DateDepart < SYSDATE THEN
            RAISE_APPLICATION_ERROR(-20001,'La dateDepart ne peut etre dans le passé.');
        END IF;

END;