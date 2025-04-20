-- 1. Joueur
CREATE OR REPLACE TYPE Joueur AS OBJECT (
    nom VARCHAR2(20),
    age NUMBER(2)
);
/

-- 2. JoueursTable
CREATE OR REPLACE TYPE JoueursTable AS VARRAY(3) OF Joueur;
/

-- 3. Equipe
CREATE OR REPLACE TYPE Equipe AS OBJECT (
    nom VARCHAR2(50),
    sport VARCHAR2(30),
    joueurs JoueursTable
);
/

-- 4. EquipesTable
CREATE OR REPLACE TYPE EquipesTable AS TABLE OF Equipe;
/

-- 5. Entrainement
CREATE OR REPLACE TYPE Entrainement AS OBJECT (
    jour VARCHAR2(15),
    heure_debut VARCHAR2(10)
);
/

-- 6. EntrainementsTable
CREATE OR REPLACE TYPE EntrainementsTable AS TABLE OF Entrainement;
/

-- 7. Ecole
CREATE OR REPLACE TYPE Ecole AS OBJECT (
    nom VARCHAR2(100),
    equipes EquipesTable,
    entrainements EntrainementsTable
);
/


CREATE TABLE EcolesSportives OF Ecole
NESTED TABLE equipes STORE AS Equipes_Store
NESTED TABLE entrainements STORE AS Entrainements_Store;







BEGIN
  INSERT INTO EcolesSportives VALUES (
    Ecole(
      'Lycee Mahi Mohamed',
      EquipesTable(
        Equipe('Team A', 'Football',
          JoueursTable(
            Joueur('Ahmed', 17),
            Joueur('Yacine', 18),
            Joueur('Sami', 17)
          )
        ),
        Equipe('Team B', 'Basketball',
          JoueursTable(
            Joueur('Nabil', 16),
            Joueur('Karim', 17),
            Joueur('Mehdi', 18)
          )
        )
      ),
      EntrainementsTable(
        Entrainement('Lundi', '14:00'),
        Entrainement('Mercredi', '10:30')
      )
    )
  );

END;
/
SET SERVEROUTPUT ON;
DECLARE
  -- Curseur pour parcourir les écoles avec les équipes et entraînements
  CURSOR cur_ecoles IS
    SELECT nom, equipes, entrainements
    FROM EcolesSportives;

  -- Variables pour les écoles
  v_equipes       EquipesTable;
  v_entrainements EntrainementsTable;
  v_equipe        Equipe;
  i               PLS_INTEGER;

BEGIN
  FOR ecole_rec IN cur_ecoles LOOP
    DBMS_OUTPUT.PUT_LINE('===============================');
    DBMS_OUTPUT.PUT_LINE('ECOLE : ' || ecole_rec.nom);
    DBMS_OUTPUT.PUT_LINE('-------------------------------');

    -- Récupérer les équipes et entraînements de l'école
    v_equipes := ecole_rec.equipes;
    v_entrainements := ecole_rec.entrainements;

    -- Afficher les équipes
    FOR i IN 1 .. v_equipes.COUNT LOOP
      v_equipe := v_equipes(i);

      DBMS_OUTPUT.PUT_LINE('  Equipe : ' || v_equipe.nom);
      DBMS_OUTPUT.PUT_LINE('  Sport  : ' || v_equipe.sport);
      DBMS_OUTPUT.PUT_LINE('  Joueurs :');

      FOR j IN 1 .. v_equipe.joueurs.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('    - ' || v_equipe.joueurs(j).nom || ' (Age: ' || v_equipe.joueurs(j).age || ')');
      END LOOP;

      DBMS_OUTPUT.PUT_LINE(''); -- ligne vide
    END LOOP;

    -- Afficher les entraînements
    DBMS_OUTPUT.PUT_LINE('Entrainements :');
    FOR j IN 1 .. v_entrainements.COUNT LOOP
      DBMS_OUTPUT.PUT_LINE('  - Jour : ' || v_entrainements(j).jour || ', Heure : ' || v_entrainements(j).heure_debut);
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('===============================');
  END LOOP;
END;
/





