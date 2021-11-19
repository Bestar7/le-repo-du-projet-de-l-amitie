package connection;

import java.sql.*;

public class DB {

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

    public static void update(String update) throws StatementAndSQLException{
        try (PreparedStatement statement = conn.prepareStatement(update)) {
            statement.executeUpdate();
        } catch (SQLException e) {
            throw new StatementAndSQLException(update);
        }
    }

    public static ResultSet query(String query) throws StatementAndSQLException{
        try (PreparedStatement statement = conn.prepareStatement(query)) {
            return statement.executeQuery();
        } catch (SQLException se) {
            throw new StatementAndSQLException(query);
        }
    }

    /* TODO INUTILE ???
    private static DB instance;

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