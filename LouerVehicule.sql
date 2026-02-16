
-- Le véhicule doit être en situation ‘disponible’ sinon on affiche le message « Le
--véhicule NumVeh n’est pas disponible » ;
-- TODO TRIGGER --


-- NumLoc est attribué automatiquement, composé de la lettre L suivie d’un nombre
--entier attribué par une séquence commençant à 1 ;
-- Montant est initialisé automatiquement avec le Tarif ;
-- Situation du véhicule devient égale à ‘location’.

-- Création de la séquence pour les locations
DROP SEQUENCE seqLocation;
CREATE SEQUENCE seqLocation START WITH 1 INCREMENT BY 1;


-- Procédure : LouerVehicule --

CREATE OR REPLACE PROCEDURE LouerVehicule(
    NUMVEH IN NUMBER,
    FORMUL IN VARCHAR2,
    DEPART IN DATE
) AS
    v_situation VARCHAR2(100);
    v_existe_vehicule NUMBER;
    v_existe_formule NUMBER;
    v_nb_jours NUMBER;
    v_date_retour DATE;
    v_num_location NUMBER;

    VehInexistant EXCEPTION;
    PRAGMA EXCEPTION_INIT(VehInexistant,-2291);

    FormInexistant EXCEPTION;

    VehIndisponible EXCEPTION;

    DateInexistante EXCEPTION;
    PRAGMA EXCEPTION_INIT(DateInexistante, -2290);
BEGIN
    -- Vérification de l'existence du véhicule
    SELECT COUNT(*) INTO v_existe_vehicule
    FROM Vehicule
    WHERE NumVeh = NUMVEH;
    
    IF v_existe_vehicule = 0 THEN
        RAISE VehInexistant;
    END IF;
    
    -- Vérification de l'existence de la formule
    SELECT COUNT(*) INTO v_existe_formule
    FROM Formules
    WHERE Formule = FORMUL;
    
    IF v_existe_formule = 0 THEN
        RAISE FormInexistant;
    END IF;
    
    -- Récupération de la situation du véhicule
    SELECT Situation INTO v_situation
    FROM Vehicule
    WHERE NumVeh = NUMVEH;
    
    -- Vérification que le véhicule est disponible
    IF v_situation != 'disponible' THEN
        RAISE VehIndisponible;
    END IF;
    
    
    -- Récupération du nombre de jours de la formule pour calculer DateRetour
    SELECT NbJours INTO v_nb_jours
    FROM Formules
    WHERE Formule = FORMUL;
    
    -- Calcul de la date de retour prévisionnelle
    v_date_retour := DEPART + v_nb_jours;
    
    -- Génération du numéro de location
    SELECT 'L' || seqLocation.NEXTVAL INTO v_num_location FROM DUAL;
    
    -- Insertion de la nouvelle location (NbKm et Montant à 0 car seront saisis au retour)
    INSERT INTO Location (NumLoc, NumVeh, Formule, DateDepart, DateRetour,KmLoc, Montant)
    VALUES (v_num_location, NUMVEH, FORMUL, DEPART, v_date_retour, 0, 0);
    
    -- Mise à jour de la situation du véhicule
    UPDATE Vehicule
    SET Situation = 'location'
    WHERE NumVeh = NUMVEH;
    
    DBMS_OUTPUT.PUT_LINE('Location creee avec succes !');
    DBMS_OUTPUT.PUT_LINE('Numero de location : ' || v_num_location);
    DBMS_OUTPUT.PUT_LINE('Vehicule n°' || NUMVEH || ' loue du ' || TO_CHAR(DEPART, 'DD/MM/YYYY') || ' au ' || TO_CHAR(v_date_retour, 'DD/MM/YYYY') || ' (previsionnel).');
    COMMIT;
EXCEPTION
    WHEN VehInexistant THEN
        DBMS_OUTPUT.PUT_LINE('Erreur : Le véhicule n°' || NUMVEH || ' n''existe pas.');
        ROLLBACK;
    
    WHEN FormInexistant THEN
        DBMS_OUTPUT.PUT_LINE('Erreur : La formule "' || FORMUL || '" n''existe pas.');
        ROLLBACK;
    
    WHEN VehIndisponible THEN 
        DBMS_OUTPUT.PUT_LINE('Erreur : Le véhicule n°' || NUMVEH || ' n''est pas disponible (Situation actuelle : ' || v_situation || ').');
        ROLLBACK;
    
    WHEN DateInexistante THEN
        DBMS_OUTPUT.PUT_LINE('Erreur : La date de départ (' || TO_CHAR(DEPART, 'DD/MM/YYYY') || ') doit être >= à la date du jour (' || TO_CHAR(TRUNC(SYSDATE), 'DD/MM/YYYY') || ').');
        ROLLBACK;
    
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erreur inattendue');
        ROLLBACK;
END LouerVehicule;