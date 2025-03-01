DECLARE
    v_num_pers PERSONNE.num_pers%TYPE;
    v_nom PERSONNE.nom%TYPE;
    v_prenom PERSONNE.prenom%TYPE;
BEGIN
    FOR i IN 1..21 LOOP
        BEGIN
            SELECT nom, prenom INTO v_nom, v_prenom
            FROM PERSONNE
            WHERE num_pers = i;

            INSERT INTO CLIENT (numcli, nomcli, prenomcli)
            VALUES (i, v_nom, v_prenom);
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                CONTINUE; -- Ignore les numéros qui n'existent pas
        END;
    END LOOP;
END;
/


DECLARE
    v_num_pers PERSONNE.num_pers%TYPE;
    v_nom PERSONNE.nom%TYPE;
    v_prenom PERSONNE.prenom%TYPE;
BEGIN
    FOR i IN 1..21 LOOP
        BEGIN
            SELECT nom, prenom INTO v_nom, v_prenom
            FROM PERSONNE
            WHERE num_pers = i;

            INSERT INTO CLIENT (numcli, nomcli, prenomcli)
            VALUES (i, v_nom, v_prenom);

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('Le numéro ' || i || ' n''existe pas');
            WHEN TOO_MANY_ROWS THEN
                DBMS_OUTPUT.PUT_LINE('Ceci ne devrait pas exister avec la clé unique');
            WHEN DUP_VAL_ON_INDEX THEN
                DBMS_OUTPUT.PUT_LINE('Contrainte de clé non respectée : duplication de clé, Message SQL est : ' || SQLERRM);
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Problème : Code erreur SQL = ' || SQLCODE);
                RAISE; -- Annule le programme
        END;
    END LOOP;
END;
/




DECLARE
    CURSOR c_personne IS
        SELECT num_pers, nom, prenom
        FROM PERSONNE;

    v_num_pers PERSONNE.num_pers%TYPE;
    v_nom PERSONNE.nom%TYPE;
    v_prenom PERSONNE.prenom%TYPE;
BEGIN
    OPEN c_personne;
    LOOP
        FETCH c_personne INTO v_num_pers, v_nom, v_prenom;
        EXIT WHEN c_personne%NOTFOUND;

        BEGIN
            INSERT INTO CLIENT (numcli, nomcli, prenomcli)
            VALUES (v_num_pers, v_nom, v_prenom);
        EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
                DBMS_OUTPUT.PUT_LINE('Contrainte de clé non respectée : duplication de clé, Message SQL est : ' || SQLERRM);
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Problème : Code erreur SQL = ' || SQLCODE);
                RAISE;
        END;
    END LOOP;
    CLOSE c_personne;
END;
/




BEGIN
    FOR rec IN (SELECT num_pers, nom, prenom FROM PERSONNE) LOOP
        BEGIN
            INSERT INTO CLIENT (numcli, nomcli, prenomcli)
            VALUES (rec.num_pers, rec.nom, rec.prenom);
        EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
                DBMS_OUTPUT.PUT_LINE('Contrainte de clé non respectée : duplication de clé, Message SQL est : ' || SQLERRM);
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Problème : Code erreur SQL = ' || SQLCODE);
                RAISE;
        END;
    END LOOP;
END;
/







DECLARE
    v_max_num_pers PERSONNE.num_pers%TYPE;
    v_nom PERSONNE.nom%TYPE;
    v_prenom PERSONNE.prenom%TYPE;
BEGIN
    -- Récupérer le client avec la clé primaire la plus élevée
    BEGIN
        SELECT num_pers, nom, prenom INTO v_max_num_pers, v_nom, v_prenom
        FROM PERSONNE
        WHERE num_pers = (SELECT MAX(num_pers) FROM PERSONNE);

        -- Insérer ce client dans la table PERSONNEL
        INSERT INTO PERSONNEL (num_pers, nompers, prenompers)
        VALUES (v_max_num_pers, v_nom, v_prenom);

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Aucun client trouvé');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Problème : Code erreur SQL = ' || SQLCODE);
            RAISE;
    END;
END;
/