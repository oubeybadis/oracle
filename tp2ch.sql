INSERT INTO CLIENT (numcli, nomcli, prenomcli)
SELECT numpers, nom, prenom FROM PERSONNE;


DECLARE
    v_numpers PERSONNE.numpers%TYPE;
    v_nom PERSONNE.nom%TYPE;
    v_prenom PERSONNE.prenom%TYPE;
BEGIN
    FOR rec IN (SELECT numpers, nom, prenom FROM PERSONNE) LOOP
        BEGIN
            INSERT INTO CLIENT (numcli, nomcli, prenomcli)
            VALUES (rec.numpers, rec.nom, rec.prenom);
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('Le numéro n''existe pas');
            WHEN TOO_MANY_ROWS THEN
                DBMS_OUTPUT.PUT_LINE('Ceci ne devrait pas exister avec la clé unique');
            WHEN DUP_VAL_ON_INDEX THEN
                DBMS_OUTPUT.PUT_LINE('Contrainte de clé non respectée : duplication de clé, ' || SQLERRM);
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Problème SQL: ' || SQLCODE || ' - ' || SQLERRM);
                ROLLBACK;
                RETURN;
        END;
    END LOOP;
    COMMIT;
END;
/



DECLARE
    CURSOR c_personnes IS
        SELECT numpers, nom, prenom FROM PERSONNE;
    v_numpers PERSONNE.numpers%TYPE;
    v_nom PERSONNE.nom%TYPE;
    v_prenom PERSONNE.prenom%TYPE;
BEGIN
    OPEN c_personnes;
    LOOP
        FETCH c_personnes INTO v_numpers, v_nom, v_prenom;
        EXIT WHEN c_personnes%NOTFOUND;
        BEGIN
            INSERT INTO CLIENT (numcli, nomcli, prenomcli)
            VALUES (v_numpers, v_nom, v_prenom);
        EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
                DBMS_OUTPUT.PUT_LINE('Duplication de clé : ' || SQLERRM);
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Erreur SQL: ' || SQLCODE || ' - ' || SQLERRM);
        END;
    END LOOP;
    CLOSE c_personnes;
    COMMIT;
END;
/



--exo 2

DECLARE
    v_numcli CLIENT.numcli%TYPE;
    v_nomcli CLIENT.nomcli%TYPE;
    v_prenomcli CLIENT.prenomcli%TYPE;
BEGIN
    SELECT numcli, nomcli, prenomcli
    INTO v_numcli, v_nomcli, v_prenomcli
    FROM CLIENT
    WHERE numcli = (SELECT MAX(numcli) FROM CLIENT);

    INSERT INTO PERSONNEL (numpers, nompers, prenompers)
    VALUES (v_numcli, v_nomcli, v_prenomcli);

    COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Aucun client trouvé.');
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Duplication de clé détectée.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erreur SQL: ' || SQLCODE || ' - ' || SQLERRM);
END;
/
