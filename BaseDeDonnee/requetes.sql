-- 1/Les membres de l’équipe «FOX»

SELECT idPersonne, nom, prenom
FROM PERSONNE NATURAL JOIN AFFECTATION NATURAL JOIN EQUIPE
WHERE EQUIPE.nomEquipe='FOX';

-- 2/La liste des doctorants qui ont commencé leur thèse cette année (après le 01/09/2021)

SELECT idPersonne, nom, prenom
FROM PERSONNE NATURAL JOIN GRADE NATURAL JOIN SUPPORT
WHERE GRADE.statut='Doctorant' and PERSONNE.dateArriveLabo>'01-09-2021' and PERSONNE.dateArriveLabo=SUPPORT.dateDebutSupport;

-- 3/La liste des doctorants encadrés par «Rossi Antoine»

SELECT idPersonne, nom, prenom
FROM SUPPORT NATURAL JOIN DIRECTEURTHESE NATURAL JOIN PERSONNE NATURAL JOIN GRADE
WHERE GRADE.statut='Doctorant' and idDirecteurThese=(SELECT directeurThese from DIRECTEURTHESE where directeurThese='Rossi Antoine');

-- 4/Les noms des employeurs avec le nombre de personnes employés par chacun

SELECT EMPLOYEUR.nomEmployeur, count(SUPPORT.idPersonne)
FROM SUPPORT NATURAL JOIN employeurs
GROUP BY EMPLOYEUR.nomEmployeur

-- 5/La liste des fonctionnaires appartenant à la section 27 et qui sont arrivés au laboratoire depuis moins d’un an

SELECT PERSONNE.idPersonne, PERSONNE.nom, PERSONNE.prenom, PERSONNE.dateArriveLabo, CNU.CNU
FROM PERSONNE NATURAL JOIN SUPPORT NATURAL JOIN TYPESUPPORT NATURAL JOIN CNU
WHERE TYPESUPPORT.SUPPORT='Fonctionnaire' and CNU.CNU=27 and (current_date-dateArriveLAbo)<365;

-- 6/La liste des personnes qui ont été affectés à plusieurs équipes 

SELECT PERSONNE.idPersonne, PERSONNE.nom, PERSONNE.prenom
FROM PERSONNE NATURAL JOIN AFFECTATION
GROUP BY PERSONNE.idPersonne
HAVING count(*)>1;

-- 7/La liste des personnes qui sont encore au laboratoire

SELECT PERSONNE.idPersonne, PERSONNE.nom, PERSONNE.prenom
FROM PERSONNE NATURAL JOIN SUPPORT
WHERE SUPPORT.dateDebutSupport is null;


-- 8/ La liste des non permanents appartenant à l’équipe «NOCE» et qui  ne sont pas doctorants

SELECT PERSONNE.idPersonne, PERSONNE.nom, PERSONNE.prenom
FROM PERSONNE NATURAL JOIN CATEGORIE NATURAL JOIN AFFECTATION NATURAL JOIN EQUIPE NATURAL JOIN GRADE
WHERE CATEGORIE.nomCategorie='NON PERMANENT' and EQUIPE.nomEquipe='NOCE' and GRADE.statut<>'Doctorant';

-- 9/La liste des personnes de nationalité «chinoise» qui sont doctorant ou en CDD

SELECT PERSONNE.idPersonne, PERSONNE.nom, PERSONNE.prenom
FROM PERSONNE NATURAL JOIN PAYS NATURAL JOIN SUPPORT NATURAL JOIN TYPESUPPORT NATURAL JOIN GRADE
WHERE (PAYS.idPays=(SELECT idPays FROM PAYS WHERE nomPays='Chine')) and (TYPESUPPORT.natureSupport like 'CDD%' or GRADE.statut='Doctorant');

-- 10/La liste des non permanents employés par le CNRS qui ont plus de 50 ans et qui sont arrivés au laboratoire en 2021

SELECT PERSONNE.idPersonne, PERSONNE.nom, PERSONNE.prenom
FROM PERSONNE NATURAL JOIN CATEGORIE NATURAL JOIN SUPPORT NATURAL JOIN EMPLOYEUR
WHERE CATEGORIE.nomCategorie='NON PERMANENT' and EMPLOYEUR.nomEmployeur='CNRS' and (current_date-PERSONNE.dateNaissance)>18249 and PERSONNE.dateArriveLabo>'31-12-2020';


-- 11/Le pays qui compte le plus grand nombre de doctorants

SELECT PAYS.nomPays, count(PERSONNE.idPersonne)
FROM PERSONNE NATURAL JOIN PAYS NATURAL JOIN GRADE
WHERE GRADE.statut='Doctorant'
GROUP BY PAYS.nomPays;