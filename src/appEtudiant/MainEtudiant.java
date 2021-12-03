package appEtudiant;

import java.util.Scanner;

import connection.DB;

public class MainEtudiant {
	private static Scanner scanner = new Scanner(System.in);
	
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
		DB db = new DB("tanguyraskin","67DTB.!?8H0" ); // joachimbastin IQXR6CLVW

		System.out.println("Veuillez entrer votre email");
		String user = scanner.nextLine();
		System.out.println("Veuillez entrer votre mot de passe");
		String mdp = scanner.nextLine();


		ChoiceHandler ch = new ChoiceHandler(db, user, mdp);

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
