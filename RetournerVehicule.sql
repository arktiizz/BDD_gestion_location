CREATE OR REPLACE PROCEDURE RetournerVehicule(NumVehi in number, Retour in date, Km in number)
IS 
    --variables
    v_existe_vehicule NUMBER;
    date_retour Location.DateRetour%TYPE;
    km_veh Vehicule.Km%TYPE; --permet de récupérer nb km avant location
    km_total Vehicule.Km%TYPE; --permet de récuper nb total km
    montant_avant_depassement Vehicule.Montant%TYPE; --permet de récupérer le montant avant dépassement
    montant_total Vehicule.Montant%TYPE; --permet de récupérer le montant total de la location
    ForfaitKm Forfait.ForfaitKm%TYPE; --permet de récupérer le forfait de la location
    prix_au_km Categories.PrixKm%TYPE; --permet de récup le prix au km du véhicule
    jours_loc_init Vehicule.NbJoursLoc%TYPE; --permet de récupérer le nb jours de location avant cette location
    jours_loc_init Vehicule.NbJoursLoc%TYPE; --permet de calculer le nb jours de location après cette location
    date_depart Location.DateDepart%TYPE; --permet de récup la date de départ de la loc
    CAV_initial Vehicule.CAV%TYPE; --permet de recup le CAV initial du vehicule 
    CAV_apres_loc Vehicule.CAV%TYPE; --permet de calculer le CAV du vehicule après la loc


    --exceptions
    VehInexistant EXCEPTION;
    PRAGMA EXCEPTION_INIT(VehInexistant,-2291);

    DateDepassee EXCEPTION;
    PRAGA EXCEPTION_INIT(DateDepassee,-2293); -- nb erreur à changer peut-être

    NbKm EXCEPTION;
    PRAGMA EXCEPTION_INIT(NbKm,-2294); -- nb erreur à changer peut-être

BEGIN
    -- Vérification de l'existence du véhicule
    SELECT COUNT(*) INTO v_existe_vehicule
    FROM Vehicule
    WHERE NumVeh = NumVehi;
    
    IF v_existe_vehicule = 0 THEN
        RAISE VehInexistant;
    END IF;

    --on récupère la date de départ du véhicule
    SELECT DateRetour INTO date_retour FROM Location WHERE NumVeh=NumVehi;
    IF TRUNC(Retour)>TRUNC(date_retour) THEN
        RAISE DateDepassee;
    END IF;

    --on verifie si Km>0
    IF Km<=0 THEN
        RAISE NbKm;
    END IF;

    --si Km devient supérieur à 50 000, on modifie la Situation du véhicule par ‘retraite’, on
    --ajoute le véhicule à la table VehiculeRetraite avec DateRetraite égale à la date
    --courante et on affiche le message « Le véhicule NumVeh a pris sa retraite »

    --on récupère nb km du véhicule avant location
    SELECT Km INTO km_veh FROM Vehicule WHERE NumVeh=NumVehi;

    --on calcule nb km du véhicule après location
    km_total :=km_veh+Km;

    --on change nb km du véhicule
    UPDATE Vehicule SET Km=km_total WHERE NumVeh=NumVehi;

    --on vérifie si km_total>50 000, si oui on met retraite et on ajoute le vehicule à la table Retraite
    IF km_total>50000 THEN
        --on met la situation à 'retraite'
        UPDATE Vehicule SET Situation='retraite' WHERE NumVeh=NumVehi;

        INSERT INTO VehiculeRetraite(NumVeh,DateRetraite) VALUES (NumVehi,SYSDATE);--pas sur du sysdate peut être trunc ?
        DBMS_OUTPUT.PUT_LINE('Le vehicule'||NumVehi||'a pris sa retraite');
    ELSE
        --cas où il faut mettre la situation à disponible car km_total<=50000
        UPDATE Vehicule SET Situation='Disponible' WHERE NumVeh=NumVehi;
    END IF;

    --Montant est augmenté du montant de dépassement kilométrique, égal à la valeur
    --suivante : Max (0, KmLoc - ForfaitKm) * PrixKm ;

    --on récupère le montant de base (tarif)
    SELECT Montant INTO montant_avant_depassement FROM Location WHERE NumVeh=NumVehi;

    --on récupère le forfait du véhicule
    SELECT f.ForfaitKm INTO ForfaitKm FROM Formule f, Location l WHERE f.Formule=l.Formule AND l.NumVeh=NumVehi;

    --on récupère le prix au km
    SELECT c.PrixKm INTO prix_au_km FROM Categories c, Vehicule v, Modeles m WHERE v.Numveh=NumVehi AND v.Modele=m.Modele AND m.NumCat=c.NumCat;
    
    --on calcule le montant total
    montant_total:=montant_avant_depassement+ MAX(0,Km-ForfaitKm)*prix_au_km; 

    --NbJoursLoc du véhicule est augmenté du nombre de jours (durée) de la location,
    --égal à la valeur suivante : DateRetour - DateDépart + 1 ;

    SELECT NbJoursLoc INTO jours_loc_init FROM Vehicule WHERE NumVeh=NumVehi;

    --on récupère la date de départ
    SELECT DateDepart INTO date_depart FROM Location WHERE NumVeh=NumVehi;

    --calcul du jours_loc_apres et changement dans la table
    jours_loc_apres:=jours_loc_init+(date_retour-date_depart+1);

    --changement dans la table Vehicule
    UPDATE Vehicule SET NbJoursLoc=jours_loc_apres;

    --CAV du véhicule est augmenté du nouveau Montant de la location
    --récupérer le CAV initial
    SELECT CAV INTO CAV_initial FROM Vehicule WHERE NumVeh=NumVehi;

    --calcul du nouveau CAV
    CAV_apres_loc:=CAV_initial+montant_total;

    --changement du CAV dans la table Vehicule
    UPDATE Vehicule SET CAV=CAV_apres_loc;

    
EXCEPTION  
    WHEN VehInexistant THEN
        DBMS_OUTPUT.PUT_LINE('Erreur : Le véhicule n°' || NUMVEH || ' n''existe pas.');
        ROLLBACK;   
    WHEN DateDepassee THEN
        DBMS_OUTPUT.PUT_LINE('Attention : la date de retour a été dépassée pour le véhicule ' || NumVehi);
        ROLLBACK;
    WHEN NbKm THEN
        DBMS_OUTPUT.PUT_LINE('Erreur : Le nombre de km de la location ('||Km||') est <=0');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Erreur RetournerVehicule: ' || SQLERRM);

END;
/
