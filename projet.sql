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
    email           varchar(100) NOT NULL CHECK (email SIMILAR TO '%@%.%') unique,
    mdp             varchar(100) NOT NULL CHECK (mdp<>''),
    nbr_credit_valide int NOT NULL DEFAULT 0 CHECK (nbr_credit_valide>=0),
    numero_bloc     int NULL,

    CONSTRAINT bloc_etudiant_fkey FOREIGN KEY(numero_bloc)
        REFERENCES projet.blocs(numero_bloc)
);

CREATE TABLE projet.unites_enseignement (
    code        char(8) PRIMARY KEY CHECK (code SIMILAR TO 'BINV(1|2|3)___'),
    nom         varchar(100) NOT NULL CHECK (nom<>''),
    nbr_credit  int NOT NULL CHECK (nbr_credit>0),
    nbr_inscrit int NOT NULL DEFAULT 0 CHECK (nbr_inscrit>=0),
    numero_bloc int NOT NULL,

    CONSTRAINT bloc_cours_fkey FOREIGN KEY(numero_bloc)
        REFERENCES projet.blocs(numero_bloc)
);

CREATE TABLE projet.paes (
    etudiant            int PRIMARY KEY,
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
    etudiant int NOT NULL,

    CONSTRAINT ue_fkey FOREIGN KEY(ue)
        REFERENCES projet.unites_enseignement(code),
    CONSTRAINT pae_fkey FOREIGN KEY(etudiant)
        REFERENCES projet.paes(etudiant),
    PRIMARY KEY (ue, etudiant)
);

-------------------Trigger

----------UE
--nbr_inscrit
CREATE OR REPLACE FUNCTION projet.update_nbr_inscrit() RETURNS TRIGGER AS $$
DECLARE
    ue RECORD;
BEGIN
    FOR ue IN SELECT pu.ue FROM projet.pae_ue pu, projet.paes p
    WHERE pu.etudiant = p.etudiant LOOP
        UPDATE projet.unites_enseignement
        SET nbr_credit=nbr_credit+1
        WHERE code=ue;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_count_nbr_inscrit AFTER UPDATE OF validation ON projet.paes
    FOR EACH ROW EXECUTE PROCEDURE projet.update_nbr_inscrit();

----------PAES
--nbr_credit_total
CREATE OR REPLACE FUNCTION projet.update_nbr_credit_total() RETURNS TRIGGER AS $$
DECLARE
    ue RECORD;
BEGIN
    FOR ue IN SELECT ue.* FROM projet.pae_ue pu, projet.paes p, projet.unites_enseignement ue
    WHERE pu.etudiant = p.etudiant AND pu.ue = ue.code LOOP
        UPDATE projet.paes
        SET nbr_credit_total = nbr_credit_total + ue.nbr_credit;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_count_nbr_credit_total AFTER INSERT ON projet.paes
    FOR EACH ROW EXECUTE PROCEDURE projet.update_nbr_credit_total();


-------------------Application centrale

--Ajouter une UE
--Ajouter un prerequis
--Ajouter un etudiant
--Ajouter une UE validee pour un etudiant
--Afficher tout les etudiant d'un bloc
--Afficher le nombre de credit du PAE pour un etudiant
--Afficher tout les etudiant dont le PEA n'est pas valider
--Afficher toutes les UE d'un bloc

-------------------Application etudiant

--Ajouter une UE a son PAE
--Enlever une UE a son PAE
--Valider son PAE
--Afficher les UE auxquelles un etudiant peut s'inscrire
--Afficher son PAE
--Reinitialiser son PAE