package appCentral;

import java.util.Scanner;

import connection.DB;

public class MainCentral {
    private static Scanner scanner = new Scanner(System.in);

    // array choix TODO améliorer ???
    private static final String[] OPTIONS = new String[] {
            "ajouter une UE",
            "ajouter un prérequis à une EU",
            "ajouter un étudiant",
            "Encoder une UE validée par un étudiant",
            "Visualiser les étudiants d'un bloc",
            "visualiser le nombre crédit du PAE de tout les étudiants",
            "visualiser les étudiants qui n'ont pas validé leur PAE",
            "visualiser les UE d'un bloc",
    };


    public MainCentral(){
        
        System.out.println("Veuillez entrer votre nom d'utilisateur");
        String user = scanner.nextLine();
        System.out.println("Veuillez entrer votre mot de passe");
        String mdp = scanner.nextLine();
        
        DB db = new DB(user, mdp);
        ChoiceHandler ch = new ChoiceHandler(db);

        logIn();
        while (true) {
            printChoicesEtudiant();
            int choix = readChoiceEtudiant();
            choicesEtudiant(ch, choix);
        }
    }

    public static void main(String[] args) {
        new MainCentral();
    }

    private static void logIn() {
        System.out.println("Bonjour, administrateur !");
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

    // TODO peut-Ãªtre utiliser un pattern chain of command ???
    private void choicesEtudiant(ChoiceHandler ch, int choix) {
        switch (choix) {
            case 1:
                ch.ajouterUe();
                break;
            case 2:
                ch.ajouterPrerequis();
                break;
            case 3:
                ch.ajouterEtudiant();
                break;
            case 4:
                ch.encoderUeValide();
                break;
            case 5:
                ch.visuEtudiantBloc();
                break;
            case 6:
                ch.visuNbrCreditPae();
                break;
            case 7:
                ch.visuEtudiantDontPaePasValide();
                break;
            case 8:
                ch.visuUeBloc();
                break;
            default:
            	ch.close();
                System.exit(0);
        }
    }
}
