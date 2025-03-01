-- Creating PERSONNE table
CREATE TABLE PERSONNE (
    numpers NUMBER PRIMARY KEY,
    nom VARCHAR2(30) NOT NULL,
    prenom VARCHAR2(30),
    pere NUMBER REFERENCES PERSONNE(numpers),
    mere NUMBER REFERENCES PERSONNE(numpers)
);

-- Inserting data into PERSONNE table
INSERT INTO PERSONNE VALUES (1, 'NOM1', 'Prenom1', NULL, NULL);
INSERT INTO PERSONNE VALUES (16, 'NOM16', NULL, NULL, NULL);
INSERT INTO PERSONNE VALUES (2, 'NOM2', 'Prenom2', 1, 16);
INSERT INTO PERSONNE VALUES (3, 'NOM3', 'Prenom3', 1, 16);
INSERT INTO PERSONNE VALUES (4, 'NOM4', 'Prenom4', NULL, NULL);
INSERT INTO PERSONNE VALUES (13, 'NOM13', 'Prenom13', NULL, NULL);
INSERT INTO PERSONNE VALUES (5, 'NOM5', 'Prenom5', 3, 4);
INSERT INTO PERSONNE VALUES (12, 'NOM12', 'Prenom12', NULL, NULL);
INSERT INTO PERSONNE VALUES (6, 'NOM6', 'Prenom6', NULL, NULL);
INSERT INTO PERSONNE VALUES (7, 'NOM7', 'Prenom7', 6, 4);
INSERT INTO PERSONNE VALUES (8, 'NOM8', 'Prenom8', 2, 13);
INSERT INTO PERSONNE VALUES (9, 'NOM9', 'Prenom9', 8, 12);
INSERT INTO PERSONNE VALUES (10, 'NOM10', 'Prenom10', 5, 12);
INSERT INTO PERSONNE VALUES (17, 'NOM17', 'Prenom17', NULL, NULL);
INSERT INTO PERSONNE VALUES (11, 'NOM11', 'Prenom11', 10, 17);
INSERT INTO PERSONNE VALUES (15, 'NOM15', NULL, 3, 13);
INSERT INTO PERSONNE VALUES (19, 'NOM19', 'Prenom19', NULL, NULL);
INSERT INTO PERSONNE VALUES (20, 'NOM20', 'Prenom20', 9, 19);
INSERT INTO PERSONNE VALUES (21, 'NOM21', 'Prenom21', 10, 17);
INSERT INTO PERSONNE VALUES (14, 'NOM14', 'Prenom14', 15, 20);
INSERT INTO PERSONNE VALUES (18, 'NOM18', 'Prenom18', 7, 13);

-- Creating CLIENT table
CREATE TABLE CLIENT (
    numcli NUMBER PRIMARY KEY,
    nomcli VARCHAR2(30),
    prenomcli VARCHAR2(30),
    adresse VARCHAR2(60),
    tel VARCHAR2(10)
);

-- Creating PERSONNEL table
CREATE TABLE PERSONNEL (
    numpers NUMBER PRIMARY KEY,
    nompers VARCHAR2(30),
    prenompers VARCHAR2(30),
    manager NUMBER,
    salaire NUMBER
);

-- select * from PERSONNE;
DECLARE
nomC PERSONNE.nom%type ;
prenomC PERSONNE.prenom%type ;
nbr integer;

BEGIN
  select nom ,prenom,count(*)as nbr  INTO nomC,prenomC,nbr from PERSONNE;
  --INSERT INTO CLIENT VALUES(nomcli=nomC ,prenomcli=prenomC);
  -- for i in nbr Loop
  --   INSERT INTO CLIENT VALUES(nomcli=nomC ,prenomcli=prenomC);
  -- end Loop;
  
EXCEPTION
  WHEN no_data_found  THEN
    dbms_output.put_line('le numero nest existe pas');
  WHEN others THEN
    dbms_output.put_line('eror');
END;
/