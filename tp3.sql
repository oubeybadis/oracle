-- Badis Oubey  g2

--              exo 1 

-- Q1
create or replace function puiss(b integer, n integer)
return integer is
begin
  if n > 0 then
    return b * puiss(b, n - 1);
  else
    return 1; 
  end if;
end puiss;
/

declare
  nbr integer;
begin
  nbr := puiss(5, 2);
  dbms_output.put_line(nbr);
exception
  when others then 
    dbms_output.put_line('error');
end;
/








-- Q2
create or replace procedure calculer_puissances(n number) is
begin
    
    
    -- boucle pour calculer la puissance n de chaque nombre de 0 à 9
    for i in 0..9 loop
        dbms_output.put_line(i || ' => ' || puissance(i, n));
    end loop;
    
exception
    when others then
        dbms_output.put_line('erreur dans la procédure calculer_puissances: ' || sqlerrm);
end calculer_puissances;
/

-- exemple d'utilisation avec n = 3
declare
    n number := 3; -- exposant (à modifier selon besoin)
begin
    calculer_puissances(n);
end;
/

















--              EXO 2

--Q1
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
INSERT INTO PERSONNE VALUES (18, 'NOM18', 'Prenom18', 7, 13);\


-- corrected function
create or replace function isDemiFrere(num1 personne.numpers%type, num2 personne.numpers%type)
return number is
  mere1 personne.mere%type;
  pere1 personne.pere%type;
  mere2 personne.mere%type;
  pere2 personne.pere%type;
begin
  -- fetch parents for num1
  select mere, pere into mere1, pere1 
  from personne where numpers = num1;

  -- fetch parents for num2
  select mere, pere into mere2, pere2 
  from personne where numpers = num2;

  if (mere1 is not null and mere1 = mere2) or 
     (pere1 is not null and pere1 = pere2) then
    return 1; 
  else
    return 0; 
  end if;
exception
  when no_data_found then
    return 0; 
end isDemiFrere;
/

-- test the function
declare  
  a number;
begin 
  a := isDemiFrere(5, 6);
  if a = 1 then
    dbms_output.put_line('Oui');
  else 
    dbms_output.put_line('non');
  end if;
end;
/









--Q2

-- Fonction pour vérifier si deux personnes sont frères
create or replace function freres(num1 personne.numpers%type, num2 personne.numpers%type)
return number is
  mere1 personne.mere%type;
  pere1 personne.pere%type;
  mere2 personne.mere%type;
  pere2 personne.pere%type;
begin
  -- Vérifier qu'il s'agit de deux personnes différentes
  if num1 = num2 then
    return 0;
  end if;
  
  -- Récupérer les parents de la première personne
  select mere, pere into mere1, pere1 
  from personne where numpers = num1;
  
  -- Récupérer les parents de la deuxième personne
  select mere, pere into mere2, pere2 
  from personne where numpers = num2;
  
  -- Deux personnes sont frères si elles ont les mêmes parents
  if (mere1 is not null and mere1 = mere2) and 
     (pere1 is not null and pere1 = pere2) then
    return 1; -- vrai
  else
    return 0; -- faux
  end if;
exception
  when no_data_found then
    return 0; 
end freres;
/

-- Procédure pour déterminer si deux personnes sont des cousins directs
-- et retourner leur parent commun
create or replace procedure cousins_direct(
  num1 IN personne.numpers%type, 
  num2 IN personne.numpers%type,
  parent_commun OUT personne.numpers%type
) is
  pere1 personne.pere%type;
  pere2 personne.pere%type;
  gpere1 personne.pere%type;
begin
  -- Initialisation du paramètre de sortie
  parent_commun := null;
  
  -- Récupérer les pères des deux personnes
  select pere into pere1 from PERSONNE where numpers = num1;
  select pere into pere2 from PERSONNE where numpers = num2;
  
  -- Vérifier si les pères existent
  if pere1 is null or pere2 is null then
    return;
  end if;
  
  -- Vérifier si leurs pères sont frères
  if freres(pere1, pere2) = 1 then
    -- Si les pères sont frères, trouver leur père commun (grand-père des cousins)
    select pere into gpere1 from PERSONNE where numpers = pere1;
    
    -- Retourner le grand-père comme parent commun
    parent_commun := gpere1;
  else
    -- Ils ne sont pas des cousins directs
    -- parent_commun := null;
    return ;
  end if;
exception
  when no_data_found then
    parent_commun := null;
end cousins_direct;
/

-- Test de la procédure
declare  
  v_parent_commun personne.numpers%type;
begin 
  cousins_direct(6, 6, v_parent_commun);
  
  if v_parent_commun is not null then
    dbms_output.put_line('Numéro du parent commun: ' || v_parent_commun);
  else 
    dbms_output.put_line('Ils ne sont pas des cousins directs');
  end if;
end;
/