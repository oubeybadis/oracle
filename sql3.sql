create type adress_type as (
    numRue int ,
    nomRue varchar(255) ,
    numVille varchar(255) ,
)
create type personne_type as (
    nom varchar(50) ,
    prenom varchar(50) ,
    dateN date ,
    dateD date ,
    pays varchar(50) ,
)
create type movie_type as (
    nom varchar(50) ,
    prenom varchar(50) ,
    dateN date ,
    dateD date ,
    pays varchar(50) ,
)

create table person (
    info personne_type;
    isWorking boolean ;
)

insert into person VALUES(row('oubey','badis')::personne_type);

select info.nom from personne where isWorking=true;