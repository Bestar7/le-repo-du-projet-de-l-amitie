package appEtudiant;

import java.util.Scanner;

import connection.DB;

public class MainEtudiant {
	private static Scanner scanner = new Scanner(System.in);

	
	// TODO : demander si requête pour num_etudiant lors de la connexion de l'etudiant
	// TODO : Faire des transaction, pour gerer l'utilisation de plusieurs utilisateur à la DB
	/*
	CREATE USER un_email WITH PASSWORD 'un mdp';
	GRANT CONNECT ON DATABASE "Projet 2021" TO joachimbastin;
	GRANT USAGE ON SCHEMA projet TO joachimbastin;
	GRANT SELECT ON projet.acquis, projet.blocs, projet.etudiants, projet.pae_ue, 
	projet.paes, projet.prerequis, projet.unites_enseignement TO joachimbastin ;
	*/
	// puis email = le nom d'urilisateur
	
	
	/*
	CREATE OR REPLACE FUNCTION projet.grant_to_student() RETURNS TRIGGER AS $$
	DECLARE
	    email varchar;
		mdp varchar;
	BEGIN
		SELECT NEW.email INTO email;
		SELECT NEW.mdp INTO email;
		
	    CREATE USER email WITH PASSWORD mdp;
		GRANT CONNECT ON DATABASE "Projet 2021" TO email;
		GRANT USAGE ON SCHEMA projet TO email;
		GRANT SELECT ON 
		projet.acquis, projet.blocs, projet.etudiants, 
		projet.pae_ue, projet.paes, projet.prerequis, 
		projet.unites_enseignement TO email ;
		RETURN NEW
	END;
	$$ LANGUAGE plpgsql;
	*/
	
	/*
	CREATE OR REPLACE FUNCTION projet.create_user()
	RETURNS TRIGGER AS $$
	DECLARE
	BEGIN
		EXECUTE FORMAT('CREATE USER "%I" WITH PASSWORD ''%L'';', NEW.email, NEW.mdp);
		EXECUTE FORMAT('GRANT CONNECT ON DATABASE "Projet 2021" TO "%I";', NEW.email);
	    EXECUTE FORMAT('GRANT USAGE ON SCHEMA projet TO "%I";', NEW.email);
		EXECUTE FORMAT(
			'GRANT SELECT ON 
			projet.acquis, projet.blocs, projet.etudiants, 
			projet.pae_ue, projet.paes, projet.prerequis, 
			projet.unites_enseignement TO "%I" ;',NEW.email
			);
			
			--EXECUTE FORMAT('CREATE ROLE "%I" LOGIN PASSWORD ''%L''', v_username, v_password);
	    RETURN NULL;
	END;
	$$ LANGUAGE plpgsql-- STRICT VOLATILE SECURITY DEFINER COST 100;
	--ALTER FUNCTION public.create_databaseuser(NAME, TEXT) OWNER TO postgres;
	CREATE TRIGGER trigger_create_user AFTER UPDATE ON projet.etudiants
	    FOR EACH STATEMENT EXECUTE PROCEDURE projet.create_user();
    */
	
	private static final String[] OPTIONS = new String[] {
		"ajouter une UE à votre PAE",
		"retirer une UE à votre PAE",
		"valider votre PAE",
		"visualiser les différentes UE dsiponible pour votre PAE",
		"Visualiser votre PAE",
		"Réinitialiser votre PAE",
		"TEST supp : OPTIONS, choicesEtudiant, test()"
	};


	public MainEtudiant(){
		System.out.println("Veuillez entrer votre email");
		String user = scanner.nextLine();
		System.out.println("Veuillez entrer votre mot de passe");
		String mdp = scanner.nextLine();

		DB db = new DB(user, mdp);
		ChoiceHandler ch = new ChoiceHandler(db, user);

		while (true) {
			printChoicesEtudiant();
			int choix = readChoiceEtudiant();
			choicesEtudiant(ch, choix);
			}
		}

	public static void main(String[] args) {
		new MainEtudiant();
	}

	private static void printChoicesEtudiant() {
		// affichage choix
		System.out.println("Voici les options : ");
		for (int i=1; i<=OPTIONS.length; i++) {
			System.out.println(i+"."+OPTIONS[i-1]);
			}
		System.out.println("autre. Quitter");
		System.out.print("Faites votre choix : ");
	}

	private static int readChoiceEtudiant(){
		int choix = 0;
		try {
			choix = Integer.parseInt(scanner.nextLine());
		} catch (NumberFormatException e){ // l'utilisateur appuy sur un autre boutton
			System.out.println("Au revoir !");
			System.exit(0);
		}

		if (choix<OPTIONS.length+1 && choix>0)
			System.out.println("-->"+OPTIONS[choix-1]);
		else {
			System.out.println("Au revoir !");
			System.exit(0);
			}

		return choix;
		}

	private void choicesEtudiant(ChoiceHandler ch, int choix) {
		switch (choix) {
		case 1:
			ch.ajouterUeAuPae();
			break;
		case 2:
			ch.retirerUeDuPae();
			break;
		case 3:
			ch.validerPae();
			break;
		case 4:
			ch.afficherUeDispo();
			break;
		case 5:
			ch.visualiserPae();
			break;
		case 6:
			ch.reinitialiserPae();
			break;
		case 7:
			ch.test();
			break;
		default:
			ch.close();
			System.exit(0);
		}
	}
}
