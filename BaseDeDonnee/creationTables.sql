DROP SCHEMA IF EXISTS labo_bidule CASCADE;
CREATE SCHEMA labo_bidule;
SET SEARCH_PATH TO labo_bidule;

CREATE TABLE PAYS(
idPays SERIAL PRIMARY KEY,
nomPays VARCHAR(100)
);

CREATE TABLE TYPESUPPORT(
idTypeSupport SERIAL PRIMARY KEY,
natureSupport VARCHAR(200)
);

CREATE TABLE CATEGORIE(
idCategorie SERIAL PRIMARY KEY,
nomCategorie VARCHAR(200) NOT NULL
);

CREATE TABLE GRADE(
idStatut SERIAL PRIMARY KEY,
statut VARCHAR(200) NOT NULL
);

CREATE TABLE SECTION(
idSection SERIAL PRIMARY KEY,
CoNRS DECIMAL(4,2) NOT NULL
);

CREATE TABLE CNU(
idCNU SERIAL PRIMARY KEY,
CNU DECIMAL(4,2) NOT NULL
);

CREATE TABLE EQUIPE(
idEquipe SERIAL PRIMARY KEY,
nomEquipe VARCHAR(100) NOT NULL
);

CREATE TABLE EMPLOYEUR(
idEmployeur SERIAL PRIMARY KEY,
nomEmployeur TEXT
);

CREATE TABLE CIVILITE(
idCivilite SERIAL PRIMARY KEY,
genre VARCHAR(4) NOT NULL,
CHECK(genre='M' or genre='Mme')
);

CREATE TABLE DIRECTEURTHESE(
idDirecteurThese SERIAL PRIMARY KEY,
directeurThese VARCHAR(100)
);

CREATE TABLE PERSONNE(
idPersonne SERIAL PRIMARY KEY,
nom VARCHAR(100) NOT NULL,
prenom VARCHAR(100) NOT NULL,
dateNaissance DATE NOT NULL,
dateArriveLabo DATE NOT NULL,
idCivilite INT,
idPays INT,
idStatut INT,
idCNU INT,
idSection INT,
FOREIGN KEY (idCivilite) REFERENCES CIVILITE(idCivilite) ON DELETE RESTRICT ON UPDATE CASCADE,
FOREIGN KEY (idPays) REFERENCES PAYS(idPays) ON DELETE RESTRICT ON UPDATE CASCADE,
FOREIGN KEY (idStatut) REFERENCES GRADE(idStatut) ON DELETE RESTRICT ON UPDATE CASCADE,
FOREIGN KEY (idCNU) REFERENCES CNU(idCNU) ON DELETE RESTRICT ON UPDATE CASCADE,
FOREIGN KEY (idSection) REFERENCES SECTION(idSection) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE SUPPORT(
idPersonne INT,
dateDebutSupport DATE NOT NULL,
dateFinSupport DATE NOT NULL,
idTypeSupport INT,
idEmployeur INT,
idCategorie INT,
idDirecteurThese INT,
PRIMARY KEY(idPersonne),
FOREIGN KEY (idPersonne) REFERENCES PERSONNE(idPersonne) ON DELETE RESTRICT ON UPDATE CASCADE,
FOREIGN KEY (idTypeSupport) REFERENCES TYPESUPPORT(idTypeSupport) ON DELETE RESTRICT ON UPDATE CASCADE,
FOREIGN KEY (idEmployeur) REFERENCES EMPLOYEUR(idEmployeur) ON DELETE RESTRICT ON UPDATE CASCADE,
FOREIGN KEY (idCategorie) REFERENCES CATEGORIE(idCategorie) ON DELETE RESTRICT ON UPDATE CASCADE,
FOREIGN KEY (idDirecteurThese) REFERENCES DIRECTEURTHESE(idDirecteurThese) ON DELETE RESTRICT ON UPDATE CASCADE,
CHECK(dateDebutSupport<dateFinSupport)
);

CREATE TABLE AFFECTATION(
idEquipe INT,
idPersonne INT,
dateDebut DATE NOT NULL,
dateFin DATE NOT NULL,
quotite INT NOT NULL,
PRIMARY KEY(idEquipe,idPersonne),
FOREIGN KEY (idEquipe) REFERENCES EQUIPE(idEquipe) ON DELETE RESTRICT ON UPDATE CASCADE,
FOREIGN KEY (idPersonne) REFERENCES PERSONNE(idPersonne) ON DELETE RESTRICT ON UPDATE CASCADE,
CHECK(dateDebut<dateFin),
CHECK(quotite>=0 and quotite<=100)
);