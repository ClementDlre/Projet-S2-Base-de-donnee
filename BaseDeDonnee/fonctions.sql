-- 1/Ecrire la fonction plusDeCinqAns qui retourne le nombre de non permanents qui sont au laboratoire de puis plus de 5 ans
CREATE OR REPLACE FUNCTION plusDeCinqAns(OUT NbNonPermanent INT)
RETURN INTEGER AS 
$$
    SELECT count(*)
    FROM PERSONNE NATURAL JOIN CATEGORIE 
    WHERE CATEGORIE.nomCategorie='NON PERMANENT' AND (current_date - PERSONNE.dateArriveLabo) < 1825;
$$
LANGUAGE SQL;
-- Test Fonction plusDeCinqAns
SELECT plusDeCinqAns();



-- 2/Ecrire la fonction maxDoctorant qui retourne le nom du pays qui compte le plus de doctorants au laboratoire
CREATE OR REPLACE FUNCTION maxDoctorant()
RETURN VARCHAR AS 
$$
    SELECT PAYS.nomPays,
    FROM PERSONNE NATURAL JOIN PAYS NATURAL JOIN GRADE
    WHERE GRADE.statut='Doctorant'
    GROUP BY PAYS.nomPays;
$$
LANGUAGE SQL;
-- Test Fonction maxDoctorant
SELECT maxDoctorant();



-- 3/Ecrire la fonction encoreAuLabo qui retourne la liste des personnes qui sont encore au laboratoire
CREATE OR REPLACE FUNCTION encoreAuLabo()
RETURN TABLE(
    PERSONNE.idPersonne VARCHAR(100), personne.nom VARCHAR(100),PERSONNE.prenom VARCHAR(100)) AS 
$$
    SELECT PERSONNE.idPersonne,PERSONNE.nom,PERSONNE.prenom
    FROM PERSONNE NATURAL JOIN SUPPORT 
    WHERE SUPPORT.dateFinSupport is null;
$$
LANGUAGE SQL;
-- Test Fonction encoreAuLabo
SELECT encoreAuLabo();



-- 4/Ecrire la fonction listeStatut qui retourne les noms des personnes dont le statut est passé en argument à la fonction. 
CREATE OR REPLACE FUNCTION listeStatut(IN statutParametre VARCHAR)
RETURN TABLE(
    PERSONNE.nom VARCHAR(100),
    PERSONNE.prenom VARCHAR(100)
) AS 
$$
    SELECT PERSONNE.nom,PERSONNE.prenom
    FROM PERSONNE NATURAL JOIN GRADE 
    WHERE GRADE.statut=statutParametre;
$$
LANGUAGE SQL;
-- Test Fonction listeStatut qui permet, ici, d'afficher les stagiaires au laboratoires
SELECT listeStatut('Stagiaire');



-- 5/Ecrire la fonction tailleEquipe qui accepte en argument le nom d’une équipe et qui retourne le nombre de personne appartenant à cette équipe.
CREATE OR REPLACE FUNCTION tailleEquipe(IN nomEquipeParametre VARCHAR)
RETURN INTEGER AS 
$$
    SELECT count(*)
    FROM PERSONNE NATURAL JOIN AFFECTATION NATURAL JOIN EQUIPE 
    WHERE EQUIPE.nomEquipe=nomEquipeParametre;
$$
LANGUAGE SQL;
-- Test Fonction tailleEquipe qui permet d'afficher son nom et le nombre de personnes qu'elle compte
SELECT EQUIPE.nomEquipe,tailleEquipe(EQUIPE.nomEquipe)
FROM PERSONNE NATURAL JOIN AFFECTATION NATURAL JOIN EQUIPE;
GROUP BY EQUIPE.nomEquipe;



-- 6/Ecrire la fonction listeDoctorants qui accepte en argument le nom d’un directeur de thèse et qui retourne la liste des doctorants encadrés par ce directeur
CREATE OR REPLACE FUNCTION listeDoctorants(IN directeurTheseParametre VARCHAR)
RETURN TABLE(
    PERSONNE.nom VARCHAR(100),
    PERSONNE.prenom VARCHAR(100)
) AS 
$$
    SELECT PERSONNE.nom,PERSONNE.prenom
    FROM SUPPORT NATURAL JOIN DIRECTEURTHESE NATURAL JOIN PERSONNE NATURAL JOIN GRADE
    WHERE GRADE.statut='Doctorant' AND DIRECTEURTHESE.idDirecteurThese=(SELECT directeurThese FROM DIRECTEURTHESE WHERE directeurThese=directeurTheseParametre);
$$
LANGUAGE SQL;
-- Test Focntion listeDoctorants qui permet d'écrire une requête qui affiche les doctorantsencadrés par « Blot Denis »
SELECT listeDoctorants('Blot Denis');



-- 7/Ecrire la fonction nonPermanentsEmployeurEquipe qui accepte en argument le nom d’un employeur et le nom d’une équipe et qui retourne le nombre de non permanents appartenant à l’équipe et employés par l’employeur passé en argument
CREATE OR REPLACE FUNCTION nonPermanentsEmployeurEquipe(IN nomEmployeurParametre VARCHAR, IN nomEquipeParametre VARCHAR)
RETURN INTEGER AS 
$$
    SELECT count(*)
    FROM PERSONNE NATURAL JOIN CATEGORIE NATURAL JOIN EMPLOYEUR NATURAL JOIN AFFECTATION NATURAL JOIN EQUIPE
    WHERE CATEGORIE.nomCategorie='NON PERMANENT' AND EMPLOYEUR.nomEmployeur=nomEmployeurParametre AND EQUIPE.nomEquipe=nomEquipeParametre;
$$
LANGUAGE SQL;
-- Test FOnction nonPermanentsEmployeurEquipe qui permet  d'écrire le nombre de non permanents employés par « Inria Lille » et qui font partie de l’équipe « Loki »
SELECT nonPermanentsEmployeurEquipe('Inria Lille','Loki');



-- 8/Ecrire la fonction effectifEquipe qui accepte en argument le nom d’un employeur et qui retourne pour chaque équipe affectées à cet employeur son nom et sa taille (le nombre de ses membres)
CREATE OR REPLACE FUNCTION effectifEquipe(IN nomEmployeurParametre VARCHAR)
RETURN TABLE(
    EQUIPE.nomEquipe VARCHAR(50),
    taille int
) AS 
$$
    SELECT EQUIPE.nomEquipe, count(PERSONNE.idPersonne)
    FROM PERSONNE NATURAL JOIN AFFECTATION NATURAL JOIN EMPLOYEUR natural JOIN EQUIPE NATURAL JOIN SUPPORT
    WHERE EMPLOYEUR.nomEmployeur=nomEmployeurParametre 
    GROUP BY EQUIPE.nomEquipe;
$$
LANGUAGE SQL;
-- Test Fonction effectofEquipe qui permet d'obtenir le nom et la taille des équipes qui travaillent pour l'employeur rentré en parametre
SELECT effectifEquipe('CNRS');



-- 9/Ecrire la fonction listeEmployeurs qui accepte en argument le nom d’une équipe et qui retournela liste des employeurs associés à cette équipe.
CREATE OR REPLACE FUNCTION listeEmployeurs(IN nomEquipeParametre VARCHAR)
RETURN VARCHAR AS 
$$
    SELECT EMPLOYEUR.nomEmployeur
    FROM EQUIPE NATURAL JOIN AFFECTATION NATURAL JOIN EMPLOYEUR NATURAL JOIN SUPPORT
    WHERE EQUIPE.nomEquipe=nomEquipeParametre 
    
$$
LANGUAGE SQL;
-- Test Fonction listeEmployeurs qui permert d'afficher les employeurs associés à l’équipe « Bonsai »
SELECT listeEmployeurs('Bonsai');



-- 10/Ecrire la fonction centPour100 qui retourne le nombre de personne qui travaille à temps plein dans l’équipe passé en argument à la fonction.
CREATE OR REPLACE FUNCTION centPour100(IN nomEquipeParametre VARCHAR)
RETURN INTEGER AS 
$$
    SELECT count(*)
    FROM EQUIPE NATURAL JOIN AFFECTATION NATURAL JOIN PERSONNE
    WHERE EQUIPE.nomEquipe=nomEquipeParametre AND AFFECTATION.quotite=100
    
$$
LANGUAGE SQL;
-- Test Fonction centPour100 qui retourne le nombre de personne qui travaille à temps plein dans l’équipe passé en argument à la fonction
SELECT centPour100('Bonsai');