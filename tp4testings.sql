-- BADIS OUBEY G2  

--        TP4


-- table definitions
create table etudiant (
    numetud number,
    nom varchar2(40),
    prenom varchar2(40),
    datenaiss date,
    moyenne number default null
);

create table module (
    codmod number,
    nommod varchar2(15),
    effecmax number default 30,
    effec number default 0
);

create table examen (
    codmod number,
    codexam number,
    dateexam date
);

create table inscription (
    numetud number,
    codmod number,
    dateinsc date default sysdate
);

create table prerequis (
    codmod number,
    codmodprereq number,
    notemin number(4, 2) not null
);

create table resultat (
    codmod number,
    codexam number,
    numetud number,
    note number(4, 2)
);

-- primary keys
alter table etudiant add constraint pk_etudiant
primary key (numetud);

alter table module add constraint pk_module
primary key (codmod);

alter table examen add constraint pk_examen
primary key (codmod, codexam);

alter table prerequis add constraint pk_prerequis
primary key (codmod, codmodprereq);

alter table inscription add constraint pk_inscription
primary key (codmod, numetud);

alter table resultat add constraint pk_resultat
primary key (codmod, numetud, codexam);

-- foreign keys
alter table inscription add (
    constraint fk_inscription_etudiant foreign key (numetud)
        references etudiant (numetud),
    constraint fk_inscription_module foreign key (codmod)
        references module (codmod)
);

alter table prerequis add (
    constraint fk_prerequis_codmod foreign key (codmod)
        references module (codmod),
    constraint fk_prerequis_codmodprereq foreign key (codmodprereq)
        references module (codmod)
);

alter table examen add constraint fk_examen
foreign key (codmod) references module (codmod);

alter table resultat add (
    constraint fk_resultat_examen foreign key (codmod, codexam)
        references examen (codmod, codexam),
    constraint fk_resultat_inscription foreign key (codmod, numetud)
        references inscription (codmod, numetud)
);


-------------------------------------


-------------------------------------
CREATE OR REPLACE TRIGGER trg_maj_effec
AFTER INSERT OR DELETE OR UPDATE OF codMod ON INSCRIPTION
FOR EACH ROW
BEGIN
    -- On INSERT: increment effec of the new module
    IF INSERTING THEN
        UPDATE MODULE
        SET effec = effec + 1
        WHERE codMod = :NEW.codMod;

    -- On DELETE: decrement effec of the old module
    ELSIF DELETING THEN
        UPDATE MODULE
        SET effec = effec - 1
        WHERE codMod = :OLD.codMod;

    -- On UPDATE: adjust effec if module changed
    ELSIF UPDATING THEN
        IF :OLD.codMod != :NEW.codMod THEN
            -- Decrease old
            UPDATE MODULE
            SET effec = effec - 1
            WHERE codMod = :OLD.codMod;

            -- Increase new
            UPDATE MODULE
            SET effec = effec + 1
            WHERE codMod = :NEW.codMod;
        END IF;
    END IF;
END;
/


----------------------------------------






CREATE OR REPLACE TRIGGER trg_verif_effec_max
BEFORE INSERT OR UPDATE OF codMod ON INSCRIPTION
FOR EACH ROW
DECLARE
    v_effec NUMBER;
    v_effec_max NUMBER;
    e_trop_etudiants EXCEPTION;
BEGIN
    -- Récupère l'effectif actuel et l'effectif maximum du module
    SELECT effec, effecMax
    INTO v_effec, v_effec_max
    FROM MODULE
    WHERE codMod = :NEW.codMod;
    
    -- Pour les mises à jour, si c'est le même module, pas de vérification nécessaire
    IF INSERTING OR (UPDATING AND :NEW.codMod != :OLD.codMod) THEN
        -- Vérifie si l'ajout d'un étudiant dépasserait l'effectif maximum
        IF v_effec >= v_effec_max THEN
            -- Lève une exception personnalisée
            RAISE_APPLICATION_ERROR(-20002, 'Plus de places disponibles.');
        END IF;
    END IF;
END;
/






---------------------



CREATE OR REPLACE TRIGGER trg_verif_inscription_examen
BEFORE INSERT ON EXAMEN
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    -- Vérifie s'il existe des étudiants inscrits au module
    SELECT COUNT(*)
    INTO v_count
    FROM INSCRIPTION
    WHERE codMod = :NEW.codMod;
    
    -- Si aucun étudiant n'est inscrit, empêche la création de l'examen
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Impossible de créer un examen pour un module sans étudiant inscrit.');
    END IF;
END;
/




----------





CREATE OR REPLACE TRIGGER trg_verif_date_resultat
BEFORE INSERT ON RESULTAT
FOR EACH ROW
DECLARE
    v_date_insc DATE;
    v_date_exam DATE;
BEGIN
    -- Récupère la date d'inscription de l'étudiant au module
    SELECT dateInsc
    INTO v_date_insc
    FROM INSCRIPTION
    WHERE numEtud = :NEW.numEtud AND codMod = :NEW.codMod;
    
    -- Récupère la date de l'examen
    SELECT dateExam
    INTO v_date_exam
    FROM EXAMEN
    WHERE codMod = :NEW.codMod AND codExam = :NEW.codExam;
    
    -- Vérifie si la date d'inscription est antérieure à la date d'examen
    IF v_date_insc >= v_date_exam THEN
        RAISE_APPLICATION_ERROR(-20004, 'L''étudiant ne peut pas passer un examen car sa date d''inscription est postérieure ou égale à la date de l''examen.');
    END IF;
END;
/





------------------------




-- Test contrainte 1: Empêcher la modification de note_min
-- D'abord, insérer des données de test
INSERT INTO MODULE VALUES (1, 'Module1', 30, 0);
INSERT INTO MODULE VALUES (2, 'Module2', 30, 0);
INSERT INTO PREREQUIS VALUES (1, 2, 10);

-- Tentative de modification qui devrait échouer
UPDATE PREREQUIS SET note_min = 12 WHERE codMod = 1 AND codModPrereq = 2;

-- Test contrainte 2: Mise à jour automatique de l'effectif
INSERT INTO ETUDIANT VALUES (1, 'Dupont', 'Jean', TO_DATE('01-01-2000', 'DD-MM-YYYY'), NULL);
INSERT INTO INSCRIPTION VALUES (1, 1, SYSDATE);
-- Vérification
SELECT effec FROM MODULE WHERE codMod = 1;

-- Test contrainte 3: Vérification de l'effectif maximum
-- Modifier l'effectif max à une valeur faible pour tester
UPDATE MODULE SET effecMax = 1 WHERE codMod = 1;
INSERT INTO ETUDIANT VALUES (2, 'Martin', 'Lucie', TO_DATE('02-02-2000', 'DD-MM-YYYY'), NULL);
-- Cette insertion devrait échouer car l'effectif max est atteint
INSERT INTO INSCRIPTION VALUES (2, 1, SYSDATE);

-- Test contrainte 4: Examen sans étudiant inscrit
-- Tenter de créer un examen pour un module sans inscription
INSERT INTO MODULE VALUES (3, 'Module3', 30, 0);
-- Cette insertion devrait échouer
INSERT INTO EXAMEN VALUES (3, 1, SYSDATE);

-- Test contrainte 5: Date d'inscription antérieure à l'examen
-- Insérer un examen
INSERT INTO EXAMEN VALUES (1, 1, SYSDATE + 10);
-- Modifier la date d'inscription de l'étudiant pour qu'elle soit postérieure à l'examen
UPDATE INSCRIPTION SET dateInsc = SYSDATE + 20 WHERE numEtud = 1 AND codMod = 1;
-- Cette insertion devrait échouer
INSERT INTO RESULTAT VALUES (1, 1, 1, 15);