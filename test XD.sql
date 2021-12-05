-- BLOC
INSERT INTO projet.blocs VALUES (1);
INSERT INTO projet.blocs VALUES (2);
INSERT INTO projet.blocs VALUES (3);

-- UE
INSERT INTO projet.unites_enseignement VALUES (1, 'BINV1234', 'cours de l amitie 1',   6, DEFAULT, 1);
INSERT INTO projet.unites_enseignement VALUES (2, 'BINV2234', 'cours de l amitie 2',   6, DEFAULT, 2);
INSERT INTO projet.unites_enseignement VALUES (3, 'BINV3334', 'cours de l amitie 3',   6, DEFAULT, 3);
INSERT INTO projet.unites_enseignement VALUES (4, 'BINV1010', 'cours de binaire 1',    7, DEFAULT, 1);
INSERT INTO projet.unites_enseignement VALUES (5, 'BINV2020', 'cours de deux R 2',     7, DEFAULT, 2);
INSERT INTO projet.unites_enseignement VALUES (6, 'BINV3030', 'cours de troisaire 3',  7, DEFAULT, 3);
INSERT INTO projet.unites_enseignement VALUES (7, 'BINV1666', 'cours del diablo 1',    9, DEFAULT, 1);
INSERT INTO projet.unites_enseignement VALUES (8, 'BINV2666', 'cours del diablo 2',    9, DEFAULT, 2);
INSERT INTO projet.unites_enseignement VALUES (9, 'BINV3666', 'cours del diablo 3',    9, DEFAULT, 3);
INSERT INTO projet.unites_enseignement VALUES (10, 'BINV1420', 'cours de herbe 1',      10, DEFAULT, 1);
INSERT INTO projet.unites_enseignement VALUES (11, 'BINV2420', 'cours de pipe 2',       10, DEFAULT, 2);
INSERT INTO projet.unites_enseignement VALUES (12, 'BINV3420', 'cours de velours 3',    10, DEFAULT, 3);
INSERT INTO projet.unites_enseignement VALUES (13, 'BINV1560', 'cours 1',               7, DEFAULT, 1);
INSERT INTO projet.unites_enseignement VALUES (14, 'BINV2400', 'cours copain copain 1v1 rust', 7, DEFAULT, 2);
INSERT INTO projet.unites_enseignement VALUES (15, 'BINV3333', '3',                     7, DEFAULT, 3);
INSERT INTO projet.unites_enseignement VALUES (16, 'BINV1670', 'cours de premiere',     12, DEFAULT, 1);
INSERT INTO projet.unites_enseignement VALUES (17, 'BINV2450', 'cours challenge week',  12, DEFAULT, 2);
INSERT INTO projet.unites_enseignement VALUES (18, 'BINV3400', 'cours langues vivantes',12, DEFAULT, 3);
INSERT INTO projet.unites_enseignement VALUES (19, 'BINV1700', 'How to scramble',       9, DEFAULT, 1);
INSERT INTO projet.unites_enseignement VALUES (20, 'BINV2725', 'Crypto nite',           9, DEFAULT, 2);
INSERT INTO projet.unites_enseignement VALUES (21, 'BINV3710', 'cours de Jean',         9, DEFAULT, 3);

-- ETUDIANT BLOC1
INSERT INTO projet.etudiants VALUES (DEFAULT, 'jeanBINV3420', 'Mercéééé', 'jB@Jmail.com', '21', DEFAULT, NULL);
INSERT INTO projet.etudiants VALUES (DEFAULT, 'Mr Atchoum', 'Jean', 'jm@jm.com', 'jm', DEFAULT, NULL);
INSERT INTO projet.etudiants VALUES (DEFAULT, 'Mich', 'Jean', 'jean@mich.com', 'mdp', DEFAULT, NULL);
INSERT INTO projet.etudiants VALUES (DEFAULT, 'Malin', 'Sebastien', 'Sebastien@gmail.com', 'mdp', DEFAULT, NULL);

-- ETUDIANT BLOC2
INSERT INTO projet.etudiants VALUES (DEFAULT, 'Leblanc', 'Juste', 'juste.leblanc@gmail.com', 'mdp', DEFAULT, NULL);
INSERT INTO projet.etudiants VALUES (DEFAULT, 'Doux', 'Adrien', 'adrien.doux@gmail.com', 'mdp', DEFAULT, NULL);
INSERT INTO projet.etudiants VALUES (DEFAULT, 'Disant', 'François', 'françois.disant@gmail.com', 'mdp', DEFAULT, NULL);
INSERT INTO projet.etudiants VALUES (DEFAULT, 'Deuxtrois', 'Adrien', 'adrien.deuxtrois@gmail.com', 'mdp', DEFAULT, NULL);

-- ETUDIANT BLOC3
INSERT INTO projet.etudiants VALUES (DEFAULT, 'Ban', 'Arthur', 'arthur.ban@gmail.com', 'mdp', DEFAULT, NULL);
INSERT INTO projet.etudiants VALUES (DEFAULT, 'Rophone', 'Mike', 'mike.rophone@gmail.com', 'mdp', DEFAULT, NULL);
INSERT INTO projet.etudiants VALUES (DEFAULT, 'Binet', 'Ro', 'ro.binet@gmail.com', 'mdp', DEFAULT, NULL);
INSERT INTO projet.etudiants VALUES (DEFAULT, 'Pellais Stewball', 'Isha', 'isha.pellais_stewball@gmail.com', 'mdp', DEFAULT, NULL);

-- PREREQUIS
INSERT INTO projet.prerequis VALUES (2,1);
INSERT INTO projet.prerequis VALUES (3,2);

INSERT INTO projet.prerequis VALUES (5,4);
INSERT INTO projet.prerequis VALUES (6,5);

INSERT INTO projet.prerequis VALUES (8,7);
INSERT INTO projet.prerequis VALUES (9,8);

-- ACQUIS étudiants 1e
INSERT INTO projet.acquis VALUES (3, 4);
INSERT INTO projet.acquis VALUES (4, 16);

-- ACQUIS étudiants 2e
INSERT INTO projet.acquis VALUES (5, 4);
INSERT INTO projet.acquis VALUES (5, 1);
INSERT INTO projet.acquis VALUES (5, 7);
INSERT INTO projet.acquis VALUES (5, 10);
INSERT INTO projet.acquis VALUES (5, 13);
INSERT INTO projet.acquis VALUES (5, 16);
INSERT INTO projet.acquis VALUES (5, 19);

INSERT INTO projet.acquis VALUES (6, 4);
INSERT INTO projet.acquis VALUES (6, 1);
INSERT INTO projet.acquis VALUES (6, 10);
INSERT INTO projet.acquis VALUES (6, 13);
INSERT INTO projet.acquis VALUES (6, 16);
INSERT INTO projet.acquis VALUES (6, 19);

INSERT INTO projet.acquis VALUES (7, 7);
INSERT INTO projet.acquis VALUES (7, 10);
INSERT INTO projet.acquis VALUES (7, 13);
INSERT INTO projet.acquis VALUES (7, 16);
INSERT INTO projet.acquis VALUES (7, 19);

INSERT INTO projet.acquis VALUES (8, 10);
INSERT INTO projet.acquis VALUES (8, 13);
INSERT INTO projet.acquis VALUES (8, 16);
INSERT INTO projet.acquis VALUES (8, 19);

-- ACQUIS étudiants 3e
INSERT INTO projet.acquis VALUES (9, 4);
INSERT INTO projet.acquis VALUES (9, 5);
INSERT INTO projet.acquis VALUES (9, 1);
INSERT INTO projet.acquis VALUES (9, 2);
INSERT INTO projet.acquis VALUES (9, 7);
INSERT INTO projet.acquis VALUES (9, 8);
INSERT INTO projet.acquis VALUES (9, 10);
INSERT INTO projet.acquis VALUES (9, 11);
INSERT INTO projet.acquis VALUES (9, 13);
INSERT INTO projet.acquis VALUES (9, 14);
INSERT INTO projet.acquis VALUES (9, 16);
INSERT INTO projet.acquis VALUES (9, 17);
INSERT INTO projet.acquis VALUES (9, 19);
INSERT INTO projet.acquis VALUES (9, 20);

INSERT INTO projet.acquis VALUES (10, 4);
INSERT INTO projet.acquis VALUES (10, 5);
INSERT INTO projet.acquis VALUES (10, 1);
INSERT INTO projet.acquis VALUES (10, 2);
INSERT INTO projet.acquis VALUES (10, 10);
INSERT INTO projet.acquis VALUES (10, 11);
INSERT INTO projet.acquis VALUES (10, 13);
INSERT INTO projet.acquis VALUES (10, 7);
INSERT INTO projet.acquis VALUES (10, 14);
INSERT INTO projet.acquis VALUES (10, 16);
INSERT INTO projet.acquis VALUES (10, 17);
INSERT INTO projet.acquis VALUES (10, 19);
INSERT INTO projet.acquis VALUES (10, 20);


INSERT INTO projet.acquis VALUES (11, 7);
INSERT INTO projet.acquis VALUES (11, 8);
INSERT INTO projet.acquis VALUES (11, 10);
INSERT INTO projet.acquis VALUES (11, 11);
INSERT INTO projet.acquis VALUES (11, 12);
INSERT INTO projet.acquis VALUES (11, 13);
INSERT INTO projet.acquis VALUES (11, 14);
INSERT INTO projet.acquis VALUES (11, 16);
INSERT INTO projet.acquis VALUES (11, 17);
INSERT INTO projet.acquis VALUES (11, 19);
INSERT INTO projet.acquis VALUES (11, 20);
INSERT INTO projet.acquis VALUES (11, 21);
INSERT INTO projet.acquis VALUES (11, 18);
INSERT INTO projet.acquis VALUES (11, 15);

INSERT INTO projet.acquis VALUES (12, 1);
INSERT INTO projet.acquis VALUES (12, 2);
INSERT INTO projet.acquis VALUES (12, 10);
INSERT INTO projet.acquis VALUES (12, 11);
INSERT INTO projet.acquis VALUES (12, 12);
INSERT INTO projet.acquis VALUES (12, 13);
INSERT INTO projet.acquis VALUES (12, 14);
INSERT INTO projet.acquis VALUES (12, 15);
INSERT INTO projet.acquis VALUES (12, 16);
INSERT INTO projet.acquis VALUES (12, 17);
INSERT INTO projet.acquis VALUES (12, 18);
INSERT INTO projet.acquis VALUES (12, 19);
INSERT INTO projet.acquis VALUES (12, 20);
INSERT INTO projet.acquis VALUES (12, 21);
