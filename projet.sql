DROP SCHEMA IF EXISTS projet CASCADE;
CREATE SCHEMA projet;

CREATE TYPE numero_bloc AS ENUM (1,2,3);
CREATE TABLE projet.blocs (
    numero_bloc numero_bloc PRIMARY KEY
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
    id_ue       SERIAL PRIMARY KEY,
    code        varchar(20) CHECK (code<>''),
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
    est_valide          bool NOT NULL DEFAULT false,

    CONSTRAINT pae_etudiant_fkey FOREIGN KEY(etudiant)
        REFERENCES projet.etudiants(numero_etudiant)
);

CREATE TABLE projet.acquis (
    etudiant    int NOT NULL,
    ue          char(8) NOT NULL,

    CONSTRAINT etudiant_acquis_fkey FOREIGN KEY(etudiant)
        REFERENCES projet.etudiants(numero_etudiant),
    CONSTRAINT ue_acquis_fkey FOREIGN KEY(ue)
        REFERENCES projet.unites_enseignement(id_ue),
    PRIMARY KEY (etudiant, ue)
);

CREATE TABLE projet.prerequis (
    ue_qui_requiert   char(8) NOT NULL CHECK (ue_qui_requiert<>ue_requise),
    ue_requise        char(8) NOT NULL CHECK (ue_qui_requiert<>ue_requise),

    CONSTRAINT requiert_fkey FOREIGN KEY(ue_qui_requiert)
        REFERENCES projet.unites_enseignement(id_ue),
    CONSTRAINT est_requis_fkey FOREIGN KEY(ue_requise)
        REFERENCES projet.unites_enseignement(id_ue),
    PRIMARY KEY (ue_qui_requiert, ue_requise)
);

CREATE TABLE projet.pae_ue (
    ue  char(8) NOT NULL,
    etudiant int NOT NULL,

    CONSTRAINT ue_fkey FOREIGN KEY(ue)
        REFERENCES projet.unites_enseignement(id_ue),
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
        WHERE id_ue=ue;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_count_nbr_inscrit AFTER UPDATE OF est_valide ON projet.paes
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

--validation
CREATE OR REPLACE FUNCTION projet.update_validation(etudiant_num INTEGER) RETURNS VOID AS $$
DECLARE
    ue_valide RECORD;
    credit_total_valide int;
    credit_total_pae int;
    bloc int;
BEGIN
    --pas deja valide
    IF(SELECT p.est_valide FROM projet.paes p WHERE p.etudiant = etudiant_num) THEN
        RAISE 'PAE deja valide';
    end if;


    --ues valide par eleve
    SELECT a.* FROM projet.acquis a, projet.paes p
    WHERE p.etudiant = a.etudiant AND etudiant_num = p.etudiant
    INTO ue_valide;

    --nombre credit deja valide
    SELECT e.nbr_credit_valide FROM projet.etudiants e
    WHERE etudiant_num = e.numero_etudiant
    INTO credit_total_valide;

    --nombre credit dans le pae
    SELECT p.nbr_credit_total FROM projet.paes p
    WHERE etudiant_num = p.etudiant
    INTO credit_total_pae;

    --verification du nombre de credit total du pae
    IF(credit_total_valide <= 30) THEN
        IF(credit_total_pae > 60) THEN
            RAISE 'Vous ne pouvez pas avoir plus de 60 credits quand vous avez valide moins de 30 credit';
        END IF;
    END IF;
    IF(credit_total_valide + credit_total_pae < 180) THEN
        IF(credit_total_valide < 45 AND credit_total_pae > 60) THEN
            RAISE 'Vous ne pouvez pas avoir plus de 60 credit a votre pae quand vous avez valide moins de 45 credit';
        END IF;
        IF(credit_total_pae > 75 OR credit_total_pae < 55) THEN
            RAISE 'Vous devez avoir entre 55 et 74 credit a votre pae';
        END IF;
    END IF;
    IF(credit_total_pae + credit_total_valide > 180) THEN
        RAISE 'Vous ne pouvez pas avoir plus de 180 a pouvoir valide au total';
    END IF;

    --determination du bloc
    IF (credit_total_valide <= 30)THEN
        bloc=1;
    ELSE
        IF(credit_total_valide + credit_total_pae == 180)THEN
            bloc=3;
        ELSE
            bloc=2;
        END IF;
    END IF;

    --affectation du bloc a l'etudiant
    UPDATE projet.etudiants
    SET numero_bloc = bloc
    WHERE numero_etudiant = etudiant_num;

    --validation du pae
    UPDATE projet.paes
    SET est_valide = TRUE
    WHERE etudiant = etudiant_num;

END;
$$ LANGUAGE plpgsql;

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

CREATE OR REPLACE FUNCTION projet.update_nbr_credit_valide() RETURNS TRIGGER AS $$
DECLARE
BEGIN
    --ajoute les credit si acqui
    UPDATE projet.etudiants
    SET nbr_credit_valide = nbr_credit_valide +
                            (SELECT ue.nbr_credit
                            FROM projet.unites_enseignement ue
                            WHERE ue.code = NEW.ue)
    WHERE etudiants.numero_etudiant = NEW.etudiant;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

--trigger pour  future virements
CREATE TRIGGER trigger_nbr_credit_valide
AFTER INSERT ON projet.acquis
FOR EACH ROW EXECUTE PROCEDURE projet.update_nbr_credit_valide();