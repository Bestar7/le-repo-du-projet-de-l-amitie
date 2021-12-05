package appCentral;

import java.sql.*;
import java.util.Scanner;

import connection.DB;

public class ChoiceHandler {

    private static Scanner scanner = new Scanner(System.in);
    
    private Connection conn;
    public ChoiceHandler(DB db){
        conn = db.getConnection();

        try {
        	//1.DONE
            ue = conn.prepareStatement("SELECT projet.ajouter_ue(?,?,?,?);");
            //2.DONE
            prerequis = conn.prepareStatement("SELECT projet.ajouter_prerequis(?,?);");
            //3.DONE
            etudiant = conn.prepareStatement("SELECT projet.ajouter_etudiant(?,?,?,?);");
            //4.DONE
            ueValide = conn.prepareStatement("SELECT projet.ajouter_acquis(?,?);");
            //5.DONE
            etudiantBloc = conn.prepareStatement(
                    "SELECT e.numero_etudiant, e.nom, e.prenom, e.email\n" +
                    "FROM projet.etudiants e\n" +
                    "WHERE e.numero_bloc = ?;");
            //6.DONE
            nbrCreditPae = conn.prepareStatement(
                    "SELECT * FROM projet.afficher_tout_etudiant;");
            //7.DONE
            paePasValide = conn.prepareStatement(
                    "SELECT * FROM projet.afficher_etudiant_pae_non_valide;");
            //8.DONE
            ueBloc = conn.prepareStatement(
                    "SELECT *\n"
                    + "FROM projet.afficher_ue_bloc\n"
                    + "WHERE \"Numero Bloc\" = ?;");

        } catch (SQLException e) {
            System.out.println("Erreur avec les requ�tes SQL !");
            close();
            System.exit(1);
        }
    }

    private PreparedStatement ue; // 1.DONE
    public void ajouterUe() {
        System.out.println("Code de la nouvelle UE : ");
        String code = scanner.nextLine();

        System.out.println("Nom de la nouvelle UE : ");
        String nom = scanner.nextLine();

        System.out.println("Nombre de cr�dit de la nouvelle UE : ");
        int nbrCredit = Integer.parseInt(scanner.nextLine()); // cela evite les probleme de retour � la ligne pas pris avec nextInt

        System.out.println("Num�ro de bloc de la nouvelle UE : ");
        int numBloc = Integer.parseInt(scanner.nextLine()); // cela evite les probleme de retour � la ligne pas pris avec nextInt

        try {
            ue.setString(1, code);
            ue.setString(2, nom);
            ue.setInt(3, nbrCredit);
            ue.setInt(4, numBloc);

            ue.executeQuery();
        } catch (SQLException e) {
        	System.out.println(ue.toString());
            e.printStackTrace();
        }
    }

    private PreparedStatement prerequis; // 2.DONE
    public void ajouterPrerequis() {
        System.out.println("Code de l'UE qui requiert un autre UE : ");
        String ueQuiRequiert = scanner.nextLine();
        System.out.println("Code de l'UE requise par la premi�re : ");
        String ueRequise = scanner.nextLine();

        try {
        	prerequis.setString(1, ueQuiRequiert);
        	prerequis.setString(2, ueRequise);

        	prerequis.executeQuery();
        } catch (SQLException e) {
        	System.out.println(prerequis.toString());
            e.printStackTrace();
        }
    }

    // TODO bcrypt du mdp
    private PreparedStatement etudiant; // 3.almost DONE
    public void ajouterEtudiant() {
        System.out.println("Nom de famille de l'�tudiant : ");
        String nom = scanner.nextLine();
        System.out.println("Pr�nom de l'�tudiant  : ");
        String prenom = scanner.nextLine();
        System.out.println("Email de l'�tudiant  : ");
        String email = scanner.nextLine();
        System.out.println("Mot de passe de l'�tudiant  : ");
        String mdp = scanner.nextLine();

        try {
        	etudiant.setString(1, nom);
        	etudiant.setString(2, prenom);
        	etudiant.setString(3, email);
        	etudiant.setString(4, mdp);

        	etudiant.executeQuery();
        } catch (SQLException e) {
        	System.out.println(etudiant.toString());
            e.printStackTrace();
        }
    }

    private PreparedStatement ueValide; // 4.DONE
    public void encoderUeValide() {
        System.out.println("email de l'�tudiant : ");
        String email = scanner.nextLine();
        System.out.println("code de l'UE acquise par l'�tudiant  : ");
        String code = scanner.nextLine();

        try {
        	ueValide.setString(1, email);
        	ueValide.setString(2, code);

        	ueValide.executeQuery();
        } catch (SQLException e) {
        	System.out.println(ueValide.toString());
            e.printStackTrace();
        }
    }

    private PreparedStatement etudiantBloc; // 5.DONE
    public void visuEtudiantBloc() {
        System.out.println("num�ro du bloc : ");
        int numBloc = Integer.parseInt(scanner.nextLine()); // cela evite les probleme de retour � la ligne pas pris avec nextInt

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
        	System.out.println(etudiantBloc.toString());
            e.printStackTrace();
        }
    }

    private PreparedStatement nbrCreditPae; // 6.DONE
    public void visuNbrCreditPae() {
        try {
            try (ResultSet rs = nbrCreditPae.executeQuery()) {
                while (rs.next()) { //nom,prenom,nbr_credit_total
                    System.out.println("  "+/*rs.getInt("numero_etudiant")+" "+*/
                            rs.getString("nom")+" "+rs.getString("prenom")+" "+
                            /*rs.getString("email")+*/" bloc "+rs.getInt("numero_bloc")+" "+
                            " avec "+rs.getInt("nbr_credit_total")+" credit dans son PAE");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private PreparedStatement paePasValide; //7.DONE
    public void visuEtudiantDontPaePasValide() {
        try {
            try (ResultSet rs = paePasValide.executeQuery()) {
                while (rs.next()) {
                    System.out.println("  "/*+rs.getInt("numero_etudiant")+" "*/+
                            rs.getString("nom")+" "+rs.getString("prenom")+" "+
                            /*rs.getString("email")+" "+*/rs.getInt("nbr_credit_valide")+" cr�dit valid�" );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private PreparedStatement ueBloc; //8.DONE
    public void visuUeBloc() {
        System.out.println("numero du bloc : ");
        int numBloc = Integer.parseInt(scanner.nextLine()); // cela evite les probleme de retour � la ligne pas pris avec nextInt

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

    public void close(){
        try {
            conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
