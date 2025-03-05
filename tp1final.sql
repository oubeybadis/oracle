-- Badis Oubey  g2
--                     Permutation de deux variables a et b




DECLARE
    a NUMBER := 5;
    b NUMBER := 10;
    temp NUMBER;
BEGIN
    -- Affichage des valeurs avant permutation
    DBMS_OUTPUT.PUT_LINE('Avant permutation : a = ' || a || ', b = ' || b);

    -- Permutation avec une variable temporaire
    temp := a;
    a := b;
    b := temp;

    -- Affichage des valeurs après permutation
    DBMS_OUTPUT.PUT_LINE('Après permutation : a = ' || a || ', b = ' || b);
END;





--                   Calcul de la factorielle d’un nombre a



DECLARE
    a NUMBER := 5; -- Nombre dont on veut calculer la factorielle
    fact NUMBER := 1; -- Variable pour stocker le résultat
    i NUMBER; -- Compteur de boucle
BEGIN
    -- Vérification que a est positif ou nul
    IF a < 0 THEN
        DBMS_OUTPUT.PUT_LINE('Erreur : La factorielle n''existe pas pour un nombre négatif.');
    ELSE
        -- Calcul de la factorielle avec une boucle
        FOR i IN 1..a LOOP
            fact := fact * i;
        END LOOP;

        -- Affichage du résultat
        DBMS_OUTPUT.PUT_LINE('Factorielle de ' || a || ' = ' || fact);
    END IF;
END;




--                  Permutation circulaire vers la droite d’un tableau de 10 valeurs



DECLARE
    TYPE tab_type IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
    t tab_type;
    i NUMBER;
BEGIN
    -- Initialisation du tableau avec les valeurs 1 à 10
    FOR i IN 1..10 LOOP
        t(i) := i;
    END LOOP;

    -- Affichage avant permutation
    DBMS_OUTPUT.PUT('Avant permutation : ');
    FOR i IN 1..10 LOOP
        DBMS_OUTPUT.PUT(t(i) || ' ');
    END LOOP;
    DBMS_OUTPUT.NEW_LINE;

    -- Permutation circulaire vers la droite (inverse l'ordre)
    FOR i IN 1..10 LOOP
        t(i) := 11 - i;
    END LOOP;

    -- Affichage après permutation
    DBMS_OUTPUT.PUT('Après permutation : ');
    FOR i IN 1..10 LOOP
        DBMS_OUTPUT.PUT(t(i) || ' ');
    END LOOP;
    DBMS_OUTPUT.NEW_LINE;
END;




--                      Tableau contenant les 20 premiers carrés parfaits + inversion + recherche dichotomique



DECLARE
    TYPE tab_type IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
    t tab_type;
    i NUMBER;
    temp NUMBER;
    debut NUMBER := 1;
    fin NUMBER := 20;
    milieu NUMBER;
    element NUMBER := 225; -- Élément à rechercher
    trouve BOOLEAN := FALSE;
BEGIN
    -- Remplissage du tableau avec les 20 premiers carrés parfaits
    FOR i IN 1..20 LOOP
        t(i) := i * i;
    END LOOP;

    -- Affichage du tableau avant inversion
    DBMS_OUTPUT.PUT('Tableau original : ');
    FOR i IN 1..20 LOOP
        DBMS_OUTPUT.PUT(t(i) || ' ');
    END LOOP;
    DBMS_OUTPUT.NEW_LINE;

    -- Inversion du tableau
    FOR i IN 1..10 LOOP
        temp := t(i);
        t(i) := t(21 - i);
        t(21 - i) := temp;
    END LOOP;

    -- Affichage du tableau après inversion
    DBMS_OUTPUT.PUT('Tableau inversé : ');
    FOR i IN 1..20 LOOP
        DBMS_OUTPUT.PUT(t(i) || ' ');
    END LOOP;
    DBMS_OUTPUT.NEW_LINE;

    -- Recherche dichotomique de l'élément 225
    WHILE debut <= fin LOOP
        milieu := TRUNC((debut + fin) / 2);
        IF t(milieu) = element THEN
            trouve := TRUE;
            EXIT;
        ELSIF t(milieu) > element THEN
            debut := milieu + 1;
        ELSE
            fin := milieu - 1;
        END IF;
    END LOOP;

    -- Affichage du résultat de la recherche
    IF trouve THEN
        DBMS_OUTPUT.PUT_LINE('L''élément ' || element || ' est trouvé.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('L''élément ' || element || ' n''est pas dans le tableau.');
    END IF;
END;
