package connection;

import java.sql.*;

public class DB {
    private static DB instance;
    private static Connection conn;

    static {
        initDriver();
        setConnexion();
    }

    private static void initDriver() {
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            System.out.println("Driver PostgreSQL manquant !");
            System.exit(1);
        }
    }

    private static void setConnexion() {
        String url = "jdbc:postgresql://172.24.2.6:5432/dbjoachimbastin";
        try {
            conn = DriverManager.getConnection(url,"joachimbastin","IQXR6CLVW");
        } catch (SQLException e) {
            System.out.println("Impossible de joindre le server !");
            System.exit(1);
        }
    }

    public static void update(String update) {
        //System.out.println(update);
        try (Statement statement = conn.createStatement()) {
            statement.executeUpdate(update);
        } catch (SQLException e) {
            System.out.println(update);
            e.printStackTrace();
        }
    }

    public static ResultSet query(String query) {
        try (Statement statement = conn.createStatement()){
            ResultSet resultSet = statement.executeQuery(query);
            return resultSet;
        } catch (SQLException se) {
            System.out.println(query);
            se.printStackTrace();
            return null;
        }
    }

    /* TODO INUTILE ???
    public static connection.DB getInstance() {
        if (instance == null)
            instance = new connection.DB();
        return instance;
    }

    public static Connection getConnection(){
        return conn;
    }
    */

    public void closeConnection(){
        try {
            conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}