package connection;

import java.sql.*;

public class DB {

    private Connection conn;
    
    public DB(String user, String mdp) {
    	initDriver();
        setConnexion(user, mdp);
    }

    private void initDriver() {
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            System.out.println("Driver PostgreSQL manquant !");
            System.exit(1);
        }
    }

    private void setConnexion(String user, String mdp) {
    	String url = "jdbc:postgresql://localhost:5432/Projet 2021";//"jdbc:postgresql://172.24.2.6:5432/dbjoachimbastin";
        try {
            conn = DriverManager.getConnection(url, user, mdp);
        } catch (SQLException e) {
            System.out.println("Impossible de joindre le server !");
            System.exit(1);
        }
    }
    
    public Connection getConnection() {
    	return conn;
    }

    public void closeConnection(){
        try {
            conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}