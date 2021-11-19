package appCentral;

import connection.StatementAndSQLException;
import utils.UtilsDb;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Scanner;

public class ChoiceHandler {

    private static Scanner scanner = new Scanner(System.in);

    // TODO faire attention au numéro de bloc, pour qu'il corresponde au bon bloc
    public static void ajouterUe() {
        System.out.println("Code de la nouvelle UE : ");
        String code = scanner.nextLine();

        System.out.println("Nom de la nouvelle UE : ");
        String nom = scanner.nextLine();

        System.out.println("Nombre de crédit de la nouvelle UE : ");
        int nbrCredit = scanner.nextInt();

        System.out.println("Numéro de bloc de la nouvelle UE : ");
        int numBloc = scanner.nextInt();

        try{
            UtilsDb.insert("unites_enseignement", String.format(" '%s','%s',%d,DEFAULT,%d", code, nom, nbrCredit, numBloc));
        } catch (StatementAndSQLException e){
            e.printStackTrace();
        }
    }

    public static void ajouterPrerequis() {
        System.out.println("Code de l'UE qui requirt un autre UE : ");
        String ueQuiRequiert = scanner.nextLine();
        System.out.println("Code de l'UE requise par la première : ");
        String ueRequise = scanner.nextLine();

        try{
            UtilsDb.insert("prerequis", String.format(" '%s','%s' ", ueQuiRequiert, ueRequise));
        } catch (StatementAndSQLException e){
            e.printStackTrace();
        }
    }

    // TODO faut-il déjà prévoir les étudiants qui change d'école ??? -> nbrDeCredit, bloc ???
    // TODO bcrypt du mdp
    public static void ajouterEtudiant() {
        System.out.println("Nom de famille de l'étudiant : ");
        String nom = scanner.nextLine();
        System.out.println("Prénom de l'étudiant  : ");
        String prenom = scanner.nextLine();
        System.out.println("Email de l'étudiant  : ");
        String email = scanner.nextLine();
        System.out.println("Mot de passe de l'étudiant  : ");
        String mdp = scanner.nextLine();

        try{
            UtilsDb.insert("etudiants", String.format(" '%s','%s','%s','%s' ", nom, prenom,email,mdp));
        } catch (StatementAndSQLException e){
            e.printStackTrace();
        }
    }

    // TODO crée une view pour trouver le num d'étudiant avec son email
    public static void encoderUeValide() {
        System.out.println("eamil de l'étudiant : ");
        String email = scanner.nextLine();
        System.out.println("code de l'UE acquise par l'étudiant  : ");
        String code = scanner.nextLine();

        try{
            UtilsDb.insert("acquis", String.format(" '______________ ", email));
        } catch (StatementAndSQLException e){
            e.printStackTrace();
        }
    }

    public static void visuEtudiantBloc() {
        System.out.println("code du bloc : ");
        String code = scanner.nextLine();

        try {
            ResultSet rs = UtilsDb.select("numero_etudiant, nom, prenom, email",
                    "etudiants", "WHERE numero_bloc = "+code);
            while (rs.next()) {
                System.out.println("  "+rs.getString("numero_etudiant")+" "+
                        rs.getString("nom")+" "+rs.getString("prenom")+" "+
                        rs.getString("email"));
            }
        } catch (StatementAndSQLException e){
            e.printStackTrace();
        } catch (SQLException e){
            e.printStackTrace();
        }
    }

    public static void visuNbrCreditPae() {
        try {
            ResultSet rs = UtilsDb.select("numero_etudiant, nom, prenom, email",
                    "etudiants", "WHERE numero_bloc IS NULL");
            while (rs.next()) {
                System.out.println("  "+rs.getString("numero_etudiant")+" "+
                        rs.getString("nom")+" "+rs.getString("prenom")+" "+
                        rs.getString("email"));
            }
        } catch (StatementAndSQLException e){
            e.printStackTrace();
        } catch (SQLException e){
            e.printStackTrace();
        }
    }

    public static void visuEtudiantDontPaePasValide() {

    }

    public static void visuUeBloc() {
    }
}
