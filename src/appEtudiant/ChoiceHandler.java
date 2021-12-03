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
	private int numeroUser;
	
    
    private Connection conn;
    public ChoiceHandler(DB db, String emailUser, String mdp){
        conn = db.getConnection();
        this.emailUser = emailUser;

        try {
        	PreparedStatement ps = conn.prepareStatement("SELECT *\n"
        			+ "FROM projet.etudiants e\n"
        			+ "WHERE e.email = ?"
                    + "AND e.mdp = ?");
        	ps.setString(1, emailUser);
        	ps.setString(2, mdp);
        	try (ResultSet rs = ps.executeQuery()) {
        		rs.next();
        		numeroUser = rs.getInt("numero_etudiant");
            }
        } catch (SQLException e) {
            System.out.println("Erreur avec les requêtes SQL !");
            close();
            System.exit(1);
        }

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
            System.out.println("Erreur avec les requ�tes SQL !");
            close();
            System.exit(1);
        }
    }
    
    private PreparedStatement ueAjout; //1.TODO ajouter le num de l'etudiant � la requ�te
    public void ajouterUeAuPae() {
    	System.out.println("code de l'UE que vous voulez ajouter au PAE  : ");
        String code = scanner.nextLine();

        try {
        	ueAjout.setString(1, code);
        	ueAjout.setInt(2, numeroUser);
        	
        	ueAjout.executeQuery();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    private PreparedStatement ueRetrait; //2.TODO ajouter le num de l'etudiant � la requ�te
    public void retirerUeDuPae() {
    	System.out.println("code de l'UE que vous voulez enlever du PAE  : ");
        String code = scanner.nextLine();

        try {
        	ueRetrait.setString(1, code);
        	ueRetrait.setInt(2, numeroUser);
        	
        	ueRetrait.executeQuery();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    private PreparedStatement validation; //3.TODO ajouter le num de l'etudiant � la requ�te
    public void validerPae() {
        try {
        	validation.setInt(1, numeroUser);
        	
        	validation.executeQuery();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    private PreparedStatement ueDispo; //4.TODO ajouter le num de l'etudiant � la requ�te
    public void afficherUeDispo() {
        try {
        	ueDispo.setInt(1, numeroUser);
        	
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
    private PreparedStatement visuPae; //5.TODO ajouter le num de l'etudiant � la requ�te
    public void visualiserPae() {
        System.out.println("numero du bloc : ");
        try {
        	visuPae.setInt(1, numeroUser);
        	
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
    private PreparedStatement reinitPae; //6.TODO ajouter le num de l'etudiant � la requ�te
    public void reinitialiserPae() {
        try {
        	reinitPae.executeQuery();
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
