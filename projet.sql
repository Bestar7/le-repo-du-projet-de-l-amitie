DROP SCHEMA IF EXISTS projet CASCADE;
CREATE SCHEMA projet;

CREATE TABLE projet.blocs (
    numero_bloc SERIAL PRIMARY KEY,
    libelle     char(5) NOT NULL CHECK (libelle SIMILAR TO 'bloc[123]') unique
);

CREATE TABLE projet.etudiants (
    numero_etudiant SERIAL PRIMARY KEY,
    nom             varchar(100) NOT NULL CHECK (nom<>''),
    prenom          varchar(100) NOT NULL CHECK (prenom<>''),
    email           varchar(100) NOT NULL CHECK (email SIMILAR TO '*@*.*') unique,
    mdp             varchar(100) NOT NULL CHECK (mdp<>''),
    nbr_credit_valide int NOT NULL DEFAULT 0 CHECK (nbr_credit_valide>=0),
    numero_bloc     int NULL,

    CONSTRAINT bloc_etudiant_fkey FOREIGN KEY(numero_bloc)
        REFERENCES projet.blocs(numero_bloc)
);

CREATE TABLE projet.unites_enseignement (
    code        char(8) PRIMARY KEY CHECK (nom SIMILAR TO 'BINV[123]*'),
    nom         varchar(100) NOT NULL CHECK (nom<>''),
    nbr_credit  int NOT NULL CHECK (nbr_credit>0),
    nbr_inscrit int NOT NULL DEFAULT 0 CHECK (nbr_inscrit>=0),
    numero_bloc int NOT NULL,

    CONSTRAINT bloc_cours_fkey FOREIGN KEY(numero_bloc)
        REFERENCES projet.blocs(numero_bloc)
);

CREATE TABLE projet.paes (
    numero_pae          SERIAL PRIMARY KEY,
    etudiant            int NOT NULL,
    nbr_credit_total    int NOT NULL DEFAULT 0 CHECK (nbr_credit_total<=74 AND nbr_credit_total>=0),
    validation          bool NOT NULL DEFAULT false,

    CONSTRAINT pae_etudiant_fkey FOREIGN KEY(etudiant)
        REFERENCES projet.etudiants(numero_etudiant)
);

CREATE TABLE projet.acquis (
    etudiant    int NOT NULL,
    ue          char(8) NOT NULL,

    CONSTRAINT etudiant_acquis_fkey FOREIGN KEY(etudiant)
        REFERENCES projet.etudiants(numero_etudiant),
    CONSTRAINT ue_acquis_fkey FOREIGN KEY(ue)
        REFERENCES projet.unites_enseignement(code),
    PRIMARY KEY (etudiant, ue)
);

CREATE TABLE projet.prerequis (
    ue_qui_requiert   char(8) NOT NULL CHECK (ue_qui_requiert<>ue_requise),
    ue_requise        char(8) NOT NULL CHECK (ue_qui_requiert<>ue_requise),

    CONSTRAINT requiert_fkey FOREIGN KEY(ue_qui_requiert)
        REFERENCES projet.unites_enseignement(code),
    CONSTRAINT est_requis_fkey FOREIGN KEY(ue_requise)
        REFERENCES projet.unites_enseignement(code),
    PRIMARY KEY (ue_qui_requiert, ue_requise)
);

CREATE TABLE projet.pae_ue (
    ue  char(8) NOT NULL,
    pae int NOT NULL,

    CONSTRAINT ue_fkey FOREIGN KEY(ue)
        REFERENCES projet.unites_enseignement(code),
    CONSTRAINT pae_fkey FOREIGN KEY(pae)
        REFERENCES projet.paes(numero_pae),
    PRIMARY KEY (ue, pae)
);