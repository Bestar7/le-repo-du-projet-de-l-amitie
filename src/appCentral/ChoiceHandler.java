package appCentral;

import utils.UtilsDb;

import java.util.Scanner;

public class ChoiceHandler {

    private static Scanner scanner = new Scanner(System.in);

    // TODO finir ça ISSOU
    public static void ajouterUe() {
        String code;
        do {
            System.out.println("Code de la nouvelle UE : ");
            code = scanner.nextLine();
        } while (code != "BINV(1|2|3)___");
        String nom;
        int nbrCredit;
        int numBloc;
        UtilsDb.insert("unites_enseignement", String.format("%s, %s", code));
    }

    public static void ajouterPrerequis() {
    }

    public static void ajouterEtudiant() {
    }

    public static void encoderUeValide() {
    }

    public static void visuEtudiantBloc() {
    }

    public static void visuNbrCreditPae() {
    }

    public static void visuEtudiantDontPaePasValide() {
    }

    public static void visuUeBloc() {
    }
}
