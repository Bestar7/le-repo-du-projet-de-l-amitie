-- BLOC
INSERT INTO projet.blocs VALUES (1);
INSERT INTO projet.blocs VALUES (2);
INSERT INTO projet.blocs VALUES (3);

-- UE
INSERT INTO projet.unites_enseignement VALUES (DEFAULT, 'BINV11', 'BD1', 31, DEFAULT, 1);
INSERT INTO projet.unites_enseignement VALUES (DEFAULT, 'BINV12', 'APOO', 16, DEFAULT, 1);
INSERT INTO projet.unites_enseignement VALUES (DEFAULT, 'BINV13', 'Algo', 13, DEFAULT, 1);
INSERT INTO projet.unites_enseignement VALUES (DEFAULT, 'BINV21', 'BD2', 42, DEFAULT, 2);
INSERT INTO projet.unites_enseignement VALUES (DEFAULT, 'BINV311', 'Anglais', 16, DEFAULT, 3);
INSERT INTO projet.unites_enseignement VALUES (DEFAULT, 'BINV32', 'Stage', 44, DEFAULT, 3);

-- PREREQUIS
INSERT INTO projet.prerequis VALUES (4,1);
INSERT INTO projet.prerequis VALUES (6,4);

-- ETUDIANT
INSERT INTO projet.etudiants VALUES (DEFAULT, 'C.', 'Damas', 'damas@vinci.be', 'damas', DEFAULT, NULL);
INSERT INTO projet.etudiants VALUES (DEFAULT, 'S.', 'Ferneeuw', 'ferneeuw@vinci.be', 'ferneeuw', DEFAULT, NULL);
INSERT INTO projet.etudiants VALUES (DEFAULT, 'J.', 'Vander Meulen', 'vander.meulen@vinci.be', 'vander.meulen', DEFAULT, NULL);
INSERT INTO projet.etudiants VALUES (DEFAULT, 'E.', 'Leconte', 'leconte@vinci.be', 'leconte', DEFAULT, NULL);

-- ACQUIS
INSERT INTO projet.acquis VALUES (1, 2);
INSERT INTO projet.acquis VALUES (1, 3);
INSERT INTO projet.acquis VALUES (2, 1);
INSERT INTO projet.acquis VALUES (2, 2);
INSERT INTO projet.acquis VALUES (3, 1);
INSERT INTO projet.acquis VALUES (3, 2);
INSERT INTO projet.acquis VALUES (3, 3);
INSERT INTO projet.acquis VALUES (4, 1);
INSERT INTO projet.acquis VALUES (4, 2);
INSERT INTO projet.acquis VALUES (4, 3);
INSERT INTO projet.acquis VALUES (4, 4);
INSERT INTO projet.acquis VALUES (4, 6);