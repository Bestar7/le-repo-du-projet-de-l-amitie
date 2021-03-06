DROP SCHEMA IF EXISTS projet CASCADE;
CREATE SCHEMA projet;

CREATE TABLE projet.blocs (
    numero_bloc int PRIMARY KEY CHECK (numero_bloc>=1 AND numero_bloc <=3)
);

CREATE SEQUENCE projet.seq_etudiant;
CREATE TABLE projet.etudiants (
    numero_etudiant INT NOT NULL DEFAULT nextval('projet.seq_etudiant') PRIMARY KEY,
    nom             varchar(100) NOT NULL CHECK (nom<>''),
    prenom          varchar(100) NOT NULL CHECK (prenom<>''),
    email           varchar(100) NOT NULL CHECK (email SIMILAR TO '%@%.%') unique,
    mdp             varchar(100) NOT NULL CHECK (mdp<>''),
    nbr_credit_valide int NOT NULL DEFAULT 0 CHECK (nbr_credit_valide>=0),
    numero_bloc     int NULL,

    CONSTRAINT bloc_etudiant_fkey FOREIGN KEY(numero_bloc)
        REFERENCES projet.blocs(numero_bloc)
);
ALTER SEQUENCE projet.seq_etudiant OWNED BY projet.etudiants.numero_etudiant;

CREATE TABLE projet.unites_enseignement (
    id_ue       SERIAL PRIMARY KEY,
    code        varchar(20) NOT NULL UNIQUE CHECK (code<>''),
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
    ue          int NOT NULL,

    CONSTRAINT etudiant_acquis_fkey FOREIGN KEY(etudiant)
        REFERENCES projet.etudiants(numero_etudiant),
    CONSTRAINT ue_acquis_fkey FOREIGN KEY(ue)
        REFERENCES projet.unites_enseignement(id_ue),
    PRIMARY KEY (etudiant, ue)
);

CREATE TABLE projet.prerequis (
    ue_qui_requiert   int NOT NULL CHECK (ue_qui_requiert<>ue_requise),
    ue_requise        int NOT NULL CHECK (ue_qui_requiert<>ue_requise),

    CONSTRAINT requiert_fkey FOREIGN KEY(ue_qui_requiert)
        REFERENCES projet.unites_enseignement(id_ue),
    CONSTRAINT est_requis_fkey FOREIGN KEY(ue_requise)
        REFERENCES projet.unites_enseignement(id_ue),
    PRIMARY KEY (ue_qui_requiert, ue_requise)
);

CREATE TABLE projet.pae_ue (
    ue  int NOT NULL,
    etudiant int NOT NULL,

    CONSTRAINT ue_fkey FOREIGN KEY(ue)
        REFERENCES projet.unites_enseignement(id_ue),
    CONSTRAINT pae_fkey FOREIGN KEY(etudiant)
        REFERENCES projet.paes(etudiant),
    PRIMARY KEY (ue, etudiant)
);


----------------------------------USAGE

--GRANT USAGE ON SCHEMA projet TO tanguyraskin;GRANT SELECT ON projet.prerequis, projet.acquis,projet.paes, projet.unites_enseignement, projet.pae_ue,projet.etudiants, projet.blocs, projet.pae_ue TO tanguyraskin;





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


--nbr_credit_total
CREATE OR REPLACE FUNCTION projet.update_nbr_credit_total() RETURNS TRIGGER AS $$
DECLARE
    ue_record RECORD;
BEGIN
	SELECT *
	FROM projet.unites_enseignement ue
	WHERE ue.id_ue = NEW.ue
	INTO ue_record;
	
	UPDATE projet.paes
	SET nbr_credit_total = nbr_credit_total + ue_record.nbr_credit
	WHERE etudiant = NEW.etudiant;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- TODO pas de creation automatique de PAE pour l'??tudiant lors de son insert
CREATE TRIGGER trigger_count_nbr_credit_total AFTER INSERT ON projet.pae_ue
    FOR EACH ROW EXECUTE PROCEDURE projet.update_nbr_credit_total();

--validation du pae
CREATE OR REPLACE FUNCTION projet.update_validation() RETURNS TRIGGER AS $$
DECLARE
    credit_total_valide int;
    credit_total_pae int;
    bloc int;
BEGIN
    --pas deja valide
    IF(SELECT p.est_valide FROM projet.paes p WHERE p.etudiant = NEW.etudiant) THEN
        RAISE 'PAE deja valide';
    END IF;

    --nombre credit deja valide
    SELECT e.nbr_credit_valide FROM projet.etudiants e
    WHERE NEW.etudiant = e.numero_etudiant
    INTO credit_total_valide;

    --nombre credit dans le pae
    SELECT p.nbr_credit_total FROM projet.paes p
    WHERE NEW.etudiant = p.etudiant
    INTO credit_total_pae;

    --verification des conditions pour le nombre de credit total du pae
    IF (credit_total_valide > 45) THEN
        IF (credit_total_pae > 60) THEN
            RAISE 'Votre PAE ne peut pas d??passer 60 credits';
        END IF;

    ELSIF (credit_total_valide + credit_total_valide >= 180) THEN
        IF (credit_total_pae > 74) THEN
            RAISE 'Votre PAE ne peut pas avoir plus de 74 credits';
        END IF;
    END IF;
    IF (credit_total_pae < 55 OR credit_total_pae > 74) THEN
        RAISE 'Votre PAE doit contenir entre 55 et 74 credits';
    END IF;

    --determination du bloc
    IF (credit_total_valide <= 45)THEN
        bloc=1;
    ELSE
        IF(credit_total_valide + credit_total_pae >= 180)THEN
            bloc=3;
        ELSE
            bloc=2;
        END IF;
    END IF;

    --affectation du bloc a l'etudiant
    UPDATE projet.etudiants
    SET numero_bloc = bloc
    WHERE numero_etudiant = NEW.etudiant;

    --validation du pae
    UPDATE projet.paes
    SET est_valide = TRUE
    WHERE etudiant = NEW.etudiant;

END;
$$ LANGUAGE plpgsql;




--nbr_credit_valide
CREATE OR REPLACE FUNCTION projet.update_nbr_credit_valide() RETURNS TRIGGER AS $$
BEGIN
    --ajoute les credit si acqui
	UPDATE projet.etudiants
	SET nbr_credit_valide = nbr_credit_valide + 
		(SELECT ue.nbr_credit
		FROM projet.unites_enseignement ue
		WHERE ue.id_ue = NEW.ue)
	WHERE numero_etudiant = NEW.etudiant;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_nbr_credit_valide AFTER INSERT ON projet.acquis
FOR EACH ROW EXECUTE PROCEDURE projet.update_nbr_credit_valide();


--ajoute d'un prerequis
CREATE OR REPLACE FUNCTION projet.verifie_ajouter_prerequis() RETURNS TRIGGER AS $$
DECLARE
        ue_requise1 RECORD;
        ue_qui_requiert1 RECORD;
    BEGIN
        SELECT ue1.* FROM projet.unites_enseignement ue1 WHERE ue1.id_ue = NEW.ue_requise INTO ue_requise1;
        SELECT ue2.* FROM projet.unites_enseignement ue2 WHERE ue2.id_ue = NEW.ue_qui_requiert INTO ue_qui_requiert1;--
        IF(ue_requise1.numero_bloc >= ue_qui_requiert1.numero_bloc) THEN
            RAISE 'Le bloc de l unite d enseignement doit etre inferieurs a celle requise';
        END IF;
        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION projet.verifie_ajouter_pae_ue() RETURNS TRIGGER AS $$
    DECLARE
        ue_ajout record;
        etud record;
    BEGIN
        SELECT ue.* FROM projet.unites_enseignement ue WHERE ue.id_ue = NEW.ue INTO ue_ajout;
        SELECT p.* FROM projet.paes p  WHERE p.etudiant = NEW.etudiant INTO etud;

	IF(etud.est_valide)then
		RAISE 'PAE d??j?? valide';
	ELSIF EXISTS
		(SELECT a1.*
		FROM projet.acquis a1
		WHERE a1.etudiant = etud.etudiant 
		AND ue_ajout.id_ue = a1.ue)--IN 
	THEN
		RAISE 'UE d??j?? acquise';
	ELSIF
		ue_ajout.numero_bloc <> 1
		AND
		(SELECT e.nbr_credit_valide 
		FROM projet.etudiants e 
		WHERE e.numero_etudiant = etud.etudiant) < 30
	THEN
		RAISE 'Vous ne pouvez avoir que des cours du bloc 1';
	ELSIF EXISTS 
		(SELECT p.ue_qui_requiert
		FROM projet.prerequis p
		WHERE p.ue_qui_requiert = ue_ajout.id_ue)
	THEN
		IF EXISTS -- change this
			(SELECT p.ue_requise 
			FROM projet.prerequis p
			WHERE p.ue_qui_requiert = ue_ajout.id_ue
			AND p.ue_requise NOT IN
				(SELECT a.ue 
				FROM projet.acquis a 
				WHERE a.etudiant = etud.etudiant))
		THEN
			RAISE'Toutes les prerequis ne sont pas acquis'; -- pas ok mtn
		END IF;
	END IF;
	RETURN NEW;
    END;
$$LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION projet.verifie_retirer_pae_ue() RETURNS TRIGGER AS $$
    DECLARE

    BEGIN
        IF(SELECT p.est_valide FROM projet.paes p WHERE etudiant = OLD.etudiant)THEN
            RAISE'PAE d??j?? valid??';
        END IF;
        RETURN OLD;
    END;
$$LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION projet.verifie_reinitialiser_pae_ue() RETURNS TRIGGER AS $$
    BEGIN
        IF(SELECT p.est_valide FROM projet.paes p WHERE OLD.etudiant = p.etudiant)THEN
            RAISE'PAE d??j?? valid??';
        END IF;
        RETURN OLD;
    END;
$$LANGUAGE plpgsql;




-------------------Application centrale

--Ajouter une UE
CREATE OR REPLACE FUNCTION projet.ajouter_ue(code_ue varchar,nom_ue varchar,nbr_credit int,num_bloc int) RETURNS VOID AS $$
    DECLARE
        ue_code ALIAS FOR $1;
        ue_nom ALIAS FOR $2;
        ue_nbr_credit ALIAS FOR $3;
        num_bloc ALIAS FOR $4;
    BEGIN
        IF (ue_code NOT LIKE 'BINV'||num_bloc||'%') THEN
            RAISE 'mauvaise correspondance code - bloc';
        END IF;
        INSERT INTO projet.unites_enseignement VALUES
        (DEFAULT, ue_code, ue_nom, ue_nbr_credit, 0, num_bloc);
    END;
$$ LANGUAGE plpgsql;

-- Ajouter un prerequis
CREATE OR REPLACE FUNCTION projet.ajouter_prerequis(ue_qui_requiert varchar,ue_requise varchar) RETURNS VOID AS $$
    DECLARE
        code_qui_requiert ALIAS FOR $1;
        code_requise ALIAS FOR $2;
    BEGIN
        INSERT INTO projet.prerequis (ue_qui_requiert, ue_requise)
        SELECT ue_requiert.id_ue, ue_requise.id_ue
        FROM projet.unites_enseignement ue_requise, projet.unites_enseignement ue_requiert
        WHERE ue_requise.code = code_requise
        AND ue_requiert.code = code_qui_requiert;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_verifier_prerequis BEFORE INSERT ON projet.prerequis
    FOR EACH ROW EXECUTE PROCEDURE projet.verifie_ajouter_prerequis();

--Ajouter un etudiant
CREATE OR REPLACE FUNCTION projet.ajouter_etudiant(varchar,varchar,varchar,varchar) RETURNS VOID AS $$
    DECLARE
        et_nom ALIAS FOR $1;
        et_prenom ALIAS FOR $2;
        et_email ALIAS FOR $3;
        et_mdp ALIAS FOR $4;
    BEGIN
        INSERT INTO projet.etudiants VALUES
            (DEFAULT, et_nom, et_prenom, et_email, et_mdp, 0, NULL);
    END;
$$LANGUAGE plpgsql;

-- creer un pae apr??s avoir ajout?? l'etudiant
CREATE OR REPLACE FUNCTION projet.create_pae() RETURNS TRIGGER AS $$
DECLARE
    ue RECORD;
BEGIN
	INSERT INTO projet.paes (etudiant)
			SELECT seq.last_value
			FROM projet.seq_etudiant seq;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER trigger_count_nbr_inscrit AFTER INSERT ON projet.etudiants
    FOR EACH ROW EXECUTE PROCEDURE projet.create_pae();

--Ajouter une UE validee pour un etudiant
CREATE OR REPLACE FUNCTION projet.ajouter_acquis(varchar,varchar) RETURNS VOID AS $$
    DECLARE
        email_etudiant ALIAS FOR $1;
        code_ue ALIAS FOR $2;
    BEGIN
        INSERT INTO projet.acquis
		SELECT e.numero_etudiant, ue.id_ue
		FROM projet.etudiants e, projet.unites_enseignement ue
		WHERE e.email = email_etudiant
		AND ue.code = code_ue;
    END;
$$LANGUAGE plpgsql;

--Afficher tout les etudiant d'un bloc
CREATE VIEW projet.afficher_etudiant_bloc AS
    SELECT e.nom, e.prenom, p.nbr_credit_total, e.numero_bloc AS "Numero Bloc"
    FROM projet.etudiants e, projet.paes p
    WHERE p.etudiant = e.numero_etudiant
    ORDER BY e.nom;

--SELECT nom,prenom,nbr_credit_total FROM projet.afficher_etudiant_bloc WHERE "Numero Bloc" = ?;

--Afficher le nombre de credit du PAE pour un etudiant
CREATE VIEW projet.afficher_tout_etudiant AS
    SELECT e.nom, e.prenom, e.numero_bloc, p.nbr_credit_total
    FROM projet.etudiants e, projet.paes p
    WHERE e.numero_etudiant = p.etudiant
    ORDER BY p.nbr_credit_total;

--SELECT * FROM projet.afficher_tout_etudiant;

--Afficher tout les etudiant dont le PEA n'est pas valider
CREATE VIEW projet.afficher_etudiant_pae_non_valide AS
    SELECT e.nom, e.prenom, e.nbr_credit_valide
    FROM projet.etudiants e, projet.paes p
    WHERE e.numero_etudiant = p.etudiant AND
          p.est_valide = FALSE;

--SELECT * FROM projet.afficher_etudiant_pae_non_valide;

--Afficher toutes les UE d'un bloc
CREATE VIEW projet.afficher_ue_bloc AS
    SELECT ue.code, ue.nom, ue.nbr_inscrit, ue.numero_bloc AS "Numero Bloc"
    FROM projet.unites_enseignement ue
    ORDER BY ue.nbr_inscrit;

--SELECT * FROM projet.afficher_ue_bloc WHERE "Numero Bloc" = ?;


-------------------Application etudiant

--Ajouter une UE a son PAE
CREATE OR REPLACE FUNCTION projet.ajouter_ue_pae(code_ue_ajouter varchar,id_etud int) RETURNS VOID AS $$
    DECLARE
        code_ue_ajouter ALIAS FOR $1;
        id_etud ALIAS FOR $2;
    BEGIN
        INSERT INTO projet.pae_ue
        SELECT ue.id_ue, id_etud
        FROM projet.unites_enseignement ue
        WHERE ue.code = code_ue_ajouter;
    END;
$$LANGUAGE plpgsql;

CREATE TRIGGER trigger_verifier_ajouter_ue_pae BEFORE INSERT ON projet.pae_ue
    FOR EACH ROW EXECUTE PROCEDURE projet.verifie_ajouter_pae_ue();

--Enlever une UE a son PAE
CREATE OR REPLACE FUNCTION projet.retirer_ue_pae(code_ue_retirer varchar, id_etud int) RETURNS VOID AS $$
    DECLARE
        code_ue_retirer ALIAS FOR $1;
        id_etud ALIAS FOR $2;
    BEGIN
        DELETE FROM projet.pae_ue pu
        WHERE pu.etudiant = id_etud
        AND pu.ue = (
            SELECT ue.id_ue
            FROM projet.unites_enseignement ue
            WHERE ue.code = code_ue_retirer);
    END;
$$LANGUAGE plpgsql;

CREATE TRIGGER trigger_verifie_retirer_ue_pae BEFORE DELETE ON projet.pae_ue
    FOR EACH ROW EXECUTE PROCEDURE projet.verifie_retirer_pae_ue();

--Valider son PAE
CREATE OR REPLACE FUNCTION projet.valider_pae(num_etudiant int) RETURNS VOID AS $$
    DECLARE
        num_etud ALIAS FOR $1;
    BEGIN
        UPDATE projet.paes p
        SET est_valide = TRUE
        WHERE p.etudiant = num_etud;
    END;
$$LANGUAGE plpgsql;

CREATE TRIGGER trigger_valider_pae BEFORE UPDATE OF est_valide ON projet.paes
    FOR EACH ROW EXECUTE PROCEDURE projet.update_validation();

CREATE TRIGGER trigger_count_nbr_inscrit AFTER UPDATE OF est_valide ON projet.paes
    FOR EACH ROW EXECUTE PROCEDURE projet.update_nbr_inscrit();


--Afficher les UE auxquelles un etudiant peut s'inscrire
CREATE VIEW projet.afficher_ue_inscrivable AS
    SELECT UE.code, UE.nom, UE.nbr_credit, UE.numero_bloc, e.numero_etudiant AS "Numero Etudiant"
    FROM projet.unites_enseignement UE, projet.etudiants e
    WHERE UE.id_ue NOT IN (--ue dans pae
            SELECT p.ue
            FROM projet.pae_ue p
            WHERE p.etudiant = e.numero_etudiant) AND
          UE.id_ue NOT IN (--ue dans acquis
                SELECT a.ue
                FROM projet.acquis a
                WHERE a.etudiant = e.numero_etudiant) AND
          UE.id_ue NOT IN (--ue prerequis
                SELECT pr.ue_qui_requiert
                FROM projet.prerequis pr
                WHERE pr.ue_requise NOT IN (
                    SELECT a.ue
                    FROM projet.acquis a
                    WHERE a.etudiant = e.numero_etudiant)) AND
          UE.id_ue NOT IN(--retirer ue bloc 2 et 3 si pas 30 credit valide
                SELECT ue2.id_ue
                FROM projet.unites_enseignement ue2
                WHERE ue2.numero_bloc > 1 AND
                      e.nbr_credit_valide <= 30
          );
-- SELECT code, nom, nbr_credit, numero_bloc FROM projet.afficher_ue_inscrivable WHERE "Numero Etudiant" = ?;

--Afficher son PAE
CREATE VIEW projet.afficher_pae AS
    SELECT ue.code, ue.nom, ue.nbr_credit, ue.numero_bloc, pu.etudiant AS "Numero Etudiant"
    FROM projet.unites_enseignement ue, projet.pae_ue pu
    WHERE ue.id_ue = pu.ue;

-- SELECT code, nom, nbr_credit, numero_bloc FROM projet.afficher_pae WHERE "Numero Etudiant" = ?;

--Reinitialiser son PAE
CREATE OR REPLACE FUNCTION projet.reinitialiser_pae(id_etudiant int) RETURNS VOID AS $$
    DECLARE
        etud ALIAS FOR $1;
        pae record;
    BEGIN
        SELECT p.* FROM projet.paes p WHERE etudiant = etud INTO pae;
        IF(pae.est_valide) THEN
            RAISE 'PAE d??j?? valid??! Vous ne pouvez pas le r??initialiser';
        END IF;
        DELETE FROM projet.pae_ue pu
        WHERE pu.etudiant = etud;
    END;
$$LANGUAGE  plpgsql;

CREATE TRIGGER trigger_verifie_reinitialiser_pae BEFORE DELETE ON projet.pae_ue
    FOR EACH ROW EXECUTE PROCEDURE projet.verifie_reinitialiser_pae_ue();

