DROP SEQUENCE seqVehicule;
DROP PROCEDURE AjouterVehicule;

CREATE SEQUENCE seqVehicule
START WITH 1
INCREMENT BY 1;

CREATE OR REPLACE PROCEDURE AjouterVehicule(Model in varchar2, K in NUMBER)
IS
    modeleExiste NUMBER;
    
    parametreNull EXCEPTION;
    PRAGMA EXCEPTION_INIT(parametreNull, -1400); --ORA -01400: cannot insert NULL into...
    
    modeleInexistant EXCEPTION;
    PRAGMA EXCEPTION_INIT(modeleInexistant, -2291);--ORA -02291: integrity constraint violated - parent key not found
    
    kilometrageNegatif EXCEPTION;
    PRAGMA EXCEPTION_INIT(kilometrageNegatif, -2290);--ORA-02290: CHECK constraint violation
    
BEGIN

    INSERT INTO Vehicule(NumVeh, Modele, Km, Situation)
    VALUES(seqVehicule.NEXTVAL, Model, K, 'disponible');
    
    DBMS_OUTPUT.PUT_LINE('Vehicule Ajouté');

    COMMIT;
EXCEPTION
    WHEN modeleInexistant THEN
        DBMS_OUTPUT.PUT_LINE('Erreur : Le Modele ' || Model || ' n existe pas.');
        ROLLBACK;
    WHEN parametreNull THEN
        DBMS_OUTPUT.PUT_LINE('Erreur : Un ou plusieurs paramètre null.');
        ROLLBACK;
    WHEN kilometrageNegatif THEN
        DBMS_OUTPUT.PUT_LINE('Erreur : Le Kilometrage est négatif (' || K || ' en vrai c chaud la)');
        ROLLBACK;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erreur inattendue : ' || SQLERRM);
        ROLLBACK;
END;

-- Test de AjouterVehicule
EXECUTE AjouterVehicule('CLIO',1400);
EXECUTE AjouterVehicule('208',1500);
EXECUTE AjouterVehicule('C3',1000);
EXECUTE AjouterVehicule('A4',500);
EXECUTE AjouterVehicule('508',900);
EXECUTE AjouterVehicule('PICASSO',300);
EXECUTE AjouterVehicule('SCENIC',400);
EXECUTE AjouterVehicule('5008',1000);
EXECUTE AjouterVehicule('KANGOO',2000);
EXECUTE AjouterVehicule('TRANSIT',2500);
-- La ligne suivante doit lever une erreur car le Kilométrage est négatif
EXECUTE AjouterVehicule('DUCATO',-1000);
--  La ligne suivante doit lever une erreur car le modèle est inexistant
EXECUTE AjouterVehicule('PASSAT',1200);
-- La ligne suivante doit lever une erreur car une des valeurs est NULL (ou absente)
EXECUTE AjouterVehicule('208',NULL);


