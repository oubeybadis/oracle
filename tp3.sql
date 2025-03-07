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



--Q2
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
  v_mere1 personne.mere%type;
  v_pere1 personne.pere%type;
  v_mere2 personne.mere%type;
  v_pere2 personne.pere%type;
begin
  -- fetch parents for num1
  select mere, pere into v_mere1, v_pere1 
  from personne where numpers = num1;

  -- fetch parents for num2
  select mere, pere into v_mere2, v_pere2 
  from personne where numpers = num2;

  if (v_mere1 is not null and v_mere1 = v_mere2) or 
     (v_pere1 is not null and v_pere1 = v_pere2) then
    return 1; -- true
  else
    return 0; -- false
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
