package appCentral;

import connection.StatementAndSQLException;
import connection.DB;

import java.sql.*;
import java.util.Scanner;

public class ChoiceHandler {

    private static Scanner scanner = new Scanner(System.in);

    // TODO faire attention au numéro de bloc, pour qu'il corresponde au bon bloc
    private PreparedStatement ue;
    public void ajouterUe() {
        System.out.println("Code de la nouvelle UE : ");
        String code = scanner.nextLine();

        System.out.println("Nom de la nouvelle UE : ");
        String nom = scanner.nextLine();

        System.out.println("Nombre de crédit de la nouvelle UE : ");
        int nbrCredit = scanner.nextInt();

        System.out.println("Numéro de bloc de la nouvelle UE : ");
        int numBloc = scanner.nextInt();

        /*
        try{
            // TODO
            DB.select("","function ajouterUE");
            //UtilsDb.insert("unites_enseignement", String.format(" '%s','%s',%d,DEFAULT,%d", code, nom, nbrCredit, numBloc));
        } catch (StatementAndSQLException e){
            e.printStackTrace();
        }
        */
    }

    private PreparedStatement prerequis;
    public void ajouterPrerequis() {
        System.out.println("Code de l'UE qui requirt un autre UE : ");
        String ueQuiRequiert = scanner.nextLine();
        System.out.println("Code de l'UE requise par la première : ");
        String ueRequise = scanner.nextLine();

        /*
        try{
            // TODO
            DB.select("","function ajouterPrerequis");
            //UtilsDb.insert("prerequis", String.format(" '%s','%s' ", ueQuiRequiert, ueRequise));
        } catch (StatementAndSQLException e){
            e.printStackTrace();
        }
        */
    }

    // TODO faut-il déjà prévoir les étudiants qui change d'école ??? -> nbrDeCredit, bloc ???
    // TODO bcrypt du mdp
    private PreparedStatement etudiant;
    public void ajouterEtudiant() {
        System.out.println("Nom de famille de l'étudiant : ");
        String nom = scanner.nextLine();
        System.out.println("Prénom de l'étudiant  : ");
        String prenom = scanner.nextLine();
        System.out.println("Email de l'étudiant  : ");
        String email = scanner.nextLine();
        System.out.println("Mot de passe de l'étudiant  : ");
        String mdp = scanner.nextLine();

        /*
        try{
            // TODO
            DB.select("","function ajouterEtudiant");
            //UtilsDb.insert("etudiants", String.format(" '%s','%s','%s','%s' ", nom, prenom,email,mdp));
        } catch (StatementAndSQLException e){
            e.printStackTrace();
        }
        */
    }

    // TODO crée une view pour trouver le num d'étudiant avec son email
    private PreparedStatement ueValide;
    public void encoderUeValide() {
        System.out.println("email de l'étudiant : ");
        String email = scanner.nextLine();
        System.out.println("code de l'UE acquise par l'étudiant  : ");
        String code = scanner.nextLine();

        /*
        try{
            DB.select("","function validerUE");
            //UtilsDb.insert("acquis", String.format(" '______________ ", email));
        } catch (StatementAndSQLException e){
            e.printStackTrace();
        }
        */
    }

    private PreparedStatement etudiantBloc;
    public void visuEtudiantBloc() {
        System.out.println("code du bloc : ");
        int numBloc = scanner.nextInt();

        try {
            etudiantBloc.setInt(1, numBloc);
            try (ResultSet rs = etudiantBloc.executeQuery()) {
                while (rs.next()) {
                    System.out.println("  "+rs.getInt("numero_etudiant")+" "+
                            rs.getString("nom")+" "+rs.getString("prenom")+" "+
                            rs.getString("email"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private PreparedStatement nbrCreditPae; // TODO View
    public void visuNbrCreditPae() {
        try {
            try (ResultSet rs = nbrCreditPae.executeQuery()) {
                while (rs.next()) {
                    System.out.println("  "+rs.getInt("numero_etudiant")+" "+
                            rs.getString("nom")+" "+rs.getString("prenom")+" "+
                            rs.getString("email")+" avec "+rs.getInt("nbrCreditPae")+" credit dans son PAE");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private PreparedStatement paePasValide;
    public void visuEtudiantDontPaePasValide() {
        try {
            try (ResultSet rs = paePasValide.executeQuery()) {
                while (rs.next()) {
                    System.out.println("  "+rs.getInt("numero_etudiant")+" "+
                            rs.getString("nom")+" "+rs.getString("prenom")+" "+
                            rs.getString("email"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private PreparedStatement ueBloc;
    public void visuUeBloc() {
        System.out.println("numero du bloc : ");
        int numBloc = scanner.nextInt();

        try {
            ueBloc.setInt(1, numBloc);
            try (ResultSet rs = ueBloc.executeQuery()) {
                while (rs.next()) {
                    System.out.println("  "+rs.getString("code")+" "+
                            rs.getString("nom")+"\tavec "+rs.getString("nbr_inscrit")+" inscrit(s)");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private String url = "jdbc:postgresql://172.24.2.6:5432/dbjoachimbastin";
    private Connection conn=null;
    public ChoiceHandler(){
        { // connexion
            try {
                Class.forName("org.postgresql.Driver");
            } catch (ClassNotFoundException e) {
                System.out.println("Driver PostgreSQL manquant !");
                System.exit(1);
            }
            try {
                // TODO changer user et mdp pas en clair ???
                conn = DriverManager.getConnection(url,"joachimbastin","IQXR6CLVW");
            } catch (SQLException e) {
                System.out.println("Impossible de joindre le server !");
                System.exit(1);
            }
        }

        try {
            ue = conn.prepareStatement("SELECT e.prenom FROM projet.etudiants e");
            prerequis = conn.prepareStatement("SELECT e.prenom FROM projet.etudiants e");
            etudiant = conn.prepareStatement("SELECT e.prenom FROM projet.etudiants e");
            ueValide = conn.prepareStatement("SELECT e.prenom FROM projet.etudiants e");
            etudiantBloc = conn.prepareStatement("SELECT e.numero_etudiant, e.nom, e.prenom, e.email\n" +
                    "FROM projet.etudiants e\n" +
                    "WHERE numero_bloc = ?");
            nbrCreditPae = conn.prepareStatement("SELECT e.numero_etudiant, e.nom, e.prenom, e.email\n" +
                    "FROM projet.etudiants e\n" +
                    "WHERE e.numero_bloc IS NULL");
            paePasValide = conn.prepareStatement("SELECT e.numero_etudiant, e.nom, e.prenom, e.email\n" +
                    "FROM projet.etudiants e\n" +
                    "WHERE numero_bloc IS NULL");
            ueBloc = conn.prepareStatement("SELECT ue.code, ue.nom, ue.nbr_inscrit\n" +
                    "FROM projet.unites_enseignement ue\n" +
                    "WHERE numero_bloc = ?\n" +
                    "ORDER BY ue.nbr_inscrit");

        } catch (SQLException e) {
            System.out.println("Erreur avec les requêtes SQL !");
            System.exit(1);
        }
    }

    // TODO utiliser cela
    public void close(){
        try {
            conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
