package appEtudiant;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Scanner;

import connection.DB;

public class ChoiceHandler {
	private static Scanner scanner = new Scanner(System.in);
	
	private String emailUser;
	private int numeroUser; // TODO le mettre ou pas ???
	
    
    private Connection conn;
    public ChoiceHandler(DB db, String emailUser){
        conn = db.getConnection();
        this.emailUser = emailUser;
        
        /*
        try {
        	PreparedStatement ps = conn.prepareStatement("SELECT *\n"
        			+ "FROM projet.etudiants e\n"
        			+ "WHERE e.email = ?");
        	ps.setString(1, emailUser);
        	try (ResultSet rs = ps.executeQuery()) {
        		rs.next();
        		numeroUser = rs.getInt("numero_etudiant");
            }
        } catch (SQLException e) {
            System.out.println("Erreur avec les requêtes SQL !");
            close();
            System.exit(1);
        }
        */

        try {
        	//1.
        	ueAjout = conn.prepareStatement("SELECT projet.ajouter_ue_pae(?,?);");
            //2.
        	ueRetrait = conn.prepareStatement("SELECT projet.retirer_ue_pae(?,?);");
            //3.
        	validation = conn.prepareStatement("SELECT projet.valider_pae(?);");
            //4.
        	ueDispo = conn.prepareStatement("SELECT projet.afficher_ue_inscrivable(?);");
            //5.
        	visuPae = conn.prepareStatement("SELECT projet.afficher_pae(?);");
            //6.
            reinitPae = conn.prepareStatement("SELECT projet.reinitialiser_pae(?);");
        } catch (SQLException e) {
            System.out.println("Erreur avec les requêtes SQL !");
            close();
            System.exit(1);
        }
    }
    
    private PreparedStatement ueAjout; //1.TODO ajouter le num de l'etudiant à la requête
    public void ajouterUeAuPae() {
    	System.out.println("code de l'UE que vous voulez ajouter au PAE  : ");
        String code = scanner.nextLine();

        try {
        	ueAjout.setString(1, code);
        	
        	ueAjout.executeQuery();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    private PreparedStatement ueRetrait; //2.TODO ajouter le num de l'etudiant à la requête
    public void retirerUeDuPae() {
    	System.out.println("code de l'UE que vous voulez enlever du PAE  : ");
        String code = scanner.nextLine();

        try {
        	ueRetrait.setString(1, code);
        	
        	ueRetrait.executeQuery();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    private PreparedStatement validation; //3.TODO ajouter le num de l'etudiant à la requête
    public void validerPae() {
        try {
        	validation.executeQuery();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    private PreparedStatement ueDispo; //4.TODO ajouter le num de l'etudiant à la requête
    public void afficherUeDispo() {
        try {
        	try (ResultSet rs = ueDispo.executeQuery()) {
                while (rs.next()) {
                    System.out.println("  "+rs.getString("code")+" "+
                            rs.getString("nom")+"\tavec "+rs.getString("nbr_inscrit")+" inscrit(s)");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    private PreparedStatement visuPae; //5.TODO ajouter le num de l'etudiant à la requête
    public void visualiserPae() {
        System.out.println("numero du bloc : ");
        try {
            try (ResultSet rs = visuPae.executeQuery()) {
                while (rs.next()) {
                    System.out.println("  "+rs.getString("code")+" "+
                            rs.getString("nom")+"\tavec "+rs.getString("nbr_inscrit")+" inscrit(s)");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    private PreparedStatement reinitPae; //6.TODO ajouter le num de l'etudiant à la requête
    public void reinitialiserPae() {
        try {
        	reinitPae.executeQuery();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void test() {
    	try {
        	PreparedStatement ps = conn.prepareStatement(
        			"SELECT *\n"
        			+ "FROM projet.etudiants e");
        	try (ResultSet rs = ps.executeQuery()) {
        		while (rs.next()) {
                    System.out.println("  "+rs.getInt("numero_etudiant")+" "+
                            rs.getString("nom")+" "+rs.getString("prenom")+" "+
                            rs.getString("email"));
                }
            }
        } catch (SQLException e) {
            System.out.println("Erreur avec les requêtes SQL !");
            close();
            System.exit(1);
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
