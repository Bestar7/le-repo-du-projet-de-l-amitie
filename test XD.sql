-- BLOC
INSERT INTO projet.blocs VALUES (DEFAULT, 'bloc1');
INSERT INTO projet.blocs VALUES (DEFAULT, 'bloc2');
INSERT INTO projet.blocs VALUES (DEFAULT, 'bloc3');

-- UE
INSERT INTO projet.unites_enseignement VALUES ('BINV1234', 'cours de l amitie 1',   6, DEFAULT, 1);
INSERT INTO projet.unites_enseignement VALUES ('BINV2234', 'cours de l amitie 2',   6, DEFAULT, 2);
INSERT INTO projet.unites_enseignement VALUES ('BINV3334', 'cours de l amitie 3',   6, DEFAULT, 3);
INSERT INTO projet.unites_enseignement VALUES ('BINV1010', 'cours de binaire 1',    7, DEFAULT, 1);
INSERT INTO projet.unites_enseignement VALUES ('BINV2020', 'cours de deux R 2',     7, DEFAULT, 2);
INSERT INTO projet.unites_enseignement VALUES ('BINV3030', 'cours de troisaire 3',  7, DEFAULT, 3);
INSERT INTO projet.unites_enseignement VALUES ('BINV1666', 'cours del diablo 1',    9, DEFAULT, 1);
INSERT INTO projet.unites_enseignement VALUES ('BINV2666', 'cours del diablo 2',    9, DEFAULT, 2);
INSERT INTO projet.unites_enseignement VALUES ('BINV3666', 'cours del diablo 3',    9, DEFAULT, 3);
INSERT INTO projet.unites_enseignement VALUES ('BINV1420', 'cours de herbe 1',      10, DEFAULT, 1);
INSERT INTO projet.unites_enseignement VALUES ('BINV2420', 'cours de pipe 2',       10, DEFAULT, 2);
INSERT INTO projet.unites_enseignement VALUES ('BINV3420', 'cours de velours 3',    10, DEFAULT, 3);
INSERT INTO projet.unites_enseignement VALUES ('BINV1560', 'cours 1',               7, DEFAULT, 1);
INSERT INTO projet.unites_enseignement VALUES ('BINV2400', 'cours copain copain 1v1 rust', 7, DEFAULT, 2);
INSERT INTO projet.unites_enseignement VALUES ('BINV3333', '3',                     7, DEFAULT, 3);
INSERT INTO projet.unites_enseignement VALUES ('BINV1670', 'cours de premiere',     12, DEFAULT, 1);
INSERT INTO projet.unites_enseignement VALUES ('BINV2450', 'cours challenge week',  12, DEFAULT, 2);
INSERT INTO projet.unites_enseignement VALUES ('BINV3400', 'cours langues vivantes',12, DEFAULT, 3);
INSERT INTO projet.unites_enseignement VALUES ('BINV1700', 'How to scramble',       9, DEFAULT, 1);
INSERT INTO projet.unites_enseignement VALUES ('BINV2725', 'Crypto nite',           9, DEFAULT, 2);
INSERT INTO projet.unites_enseignement VALUES ('BINV3710', 'cours de Jean',         9, DEFAULT, 3);

-- ETUDIANT BLOC1
INSERT INTO projet.etudiants VALUES (DEFAULT, 'jeanBINV3420', 'Mercéééé', 'jB@Jmail.com', '21', DEFAULT, 1);
INSERT INTO projet.etudiants VALUES (DEFAULT, 'Mr Atchoum', 'Jean', 'jm@jm.com', 'jm', DEFAULT, 1);
INSERT INTO projet.etudiants VALUES (DEFAULT, 'Mich', 'Jean', 'jean@mich.com', 'mdp', DEFAULT, 1);
INSERT INTO projet.etudiants VALUES (DEFAULT, 'Malin', 'Sebastien', 'Sebastien@gmail.com', 'mdp', DEFAULT, 1);

-- ETUDIANT BLOC2
INSERT INTO projet.etudiants VALUES (DEFAULT, 'Leblanc', 'Juste', 'juste.leblanc@gmail.com', 'mdp', DEFAULT, 2);
INSERT INTO projet.etudiants VALUES (DEFAULT, 'Doux', 'Adrien', 'adrien.doux@gmail.com', 'mdp', DEFAULT, 2);
INSERT INTO projet.etudiants VALUES (DEFAULT, 'Disant', 'François', 'françois.disant@gmail.com', 'mdp', DEFAULT, 2);
INSERT INTO projet.etudiants VALUES (DEFAULT, 'Deuxtrois', 'Adrien', 'adrien.deuxtrois@gmail.com', 'mdp', DEFAULT, 2);

-- ETUDIANT BLOC3
INSERT INTO projet.etudiants VALUES (DEFAULT, 'Ban', 'Arthur', 'arthur.ban@gmail.com', 'mdp', DEFAULT, 3);
INSERT INTO projet.etudiants VALUES (DEFAULT, 'Rophone', 'Mike', 'mike.rophone@gmail.com', 'mdp', DEFAULT, 3);
INSERT INTO projet.etudiants VALUES (DEFAULT, 'Binet', 'Ro', 'ro.binet@gmail.com', 'mdp', DEFAULT, 3);
INSERT INTO projet.etudiants VALUES (DEFAULT, 'Pellais Stewball', 'Isha', 'isha.pellais_stewball@gmail.com', 'mdp', DEFAULT, 3);

-- PREREQUIS
INSERT INTO projet.prerequis VALUES ('BINV2234','BINV1234');
INSERT INTO projet.prerequis VALUES ('BINV3334','BINV2234');

INSERT INTO projet.prerequis VALUES ('BINV2020','BINV1010');
INSERT INTO projet.prerequis VALUES ('BINV3030','BINV2020');

INSERT INTO projet.prerequis VALUES ('BINV2666','BINV1666');
INSERT INTO projet.prerequis VALUES ('BINV3666','BINV2666');


