package appCentral;

import java.sql.*;
import java.util.Scanner;

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

    public static void main(String[] args) {
        logIn();
        while (true) {
            printChoicesEtudiant();
            int choix = readChoiceEtudiant();
            choicesEtudiant(choix);
        }
    }

    private String url="jdbc:postgresql://postgres.ipl.be/pubs2?user=public&password=public";
    private PreparedStatement listeAuteurs;
    private PreparedStatement listeAuteursAvecNom;
    private Connection conn=null;
    public MainCentral(){
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            System.out.println("Driver PostgreSQL manquant !");
            System.exit(1);
        }
        try {
            conn=DriverManager.getConnection(url);
        } catch (SQLException e) {
            System.out.println("Impossible de joindre le server !");
            System.exit(1);
        }
        /*
        try {

            listeAuteurs=
                    conn.prepareStatement("SELECT nom" +
                            " FROM projet.etudiants");
            listeAuteursAvecNom=
                    conn.prepareStatement("SELECT au_lname" +
                            " FROM Authors" +
                            " WHERE au_fname LIKE ?");

        } catch (SQLException e) {
            System.out.println("Erreur avec les requêtes SQL !");
            System.exit(1);
        }
        */
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

    // TODO peut-être utiliser un pattern chain of command ???
    private static void choicesEtudiant(int choix) {
        switch (choix) {
            case 1:
                ChoiceHandler.ajouterUe();
                break;
            case 2:
                ChoiceHandler.ajouterPrerequis();
                break;
            case 3:
                ChoiceHandler.ajouterEtudiant();
                break;
            case 4:
                ChoiceHandler.encoderUeValide();
                break;
            case 5:
                ChoiceHandler.visuEtudiantBloc();
                break;
            case 6:
                ChoiceHandler.visuNbrCreditPae();
                break;
            case 7:
                ChoiceHandler.visuEtudiantDontPaePasValide();
                break;
            case 8:
                ChoiceHandler.visuUeBloc();
                break;
            default:
                System.exit(0);
        }
    }
}
