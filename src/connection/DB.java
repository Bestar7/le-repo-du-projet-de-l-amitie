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

    public static ResultSet select(String columns, String from) throws StatementAndSQLException{
        //return select(columns, from, "1=1");
        return null;
    }

    public static ResultSet select(String columns, String from, String leftConditions, String rightConditions, String orderBy) throws SQLException {
        String query = String.format("SELECT %s \n", columns) +
                String.format("FROM projet.%s \n", from) +
                String.format("WHERE %s ?\n", leftConditions) +
                String.format("%s;", orderBy);
        /*
        try (PreparedStatement statement = conn.prepareStatement(query)) {
            statement.setString(1, columns);
            statement.setString(2, from);
            statement.setString(3, conditions);
            return statement.executeQuery();
        } catch (SQLException se) {
            throw new StatementAndSQLException(query);
        }
        */
        PreparedStatement statement = conn.prepareStatement(query);
        statement.setString(1, rightConditions);
        return statement.executeQuery();
    }

    public static ResultSet select(String columns, String from, String leftConditions, int rightConditions, String orderBy) throws SQLException {
        String query = String.format("SELECT %s \n", columns) +
                String.format("FROM projet.%s \n", from) +
                String.format("WHERE %s ?\n", leftConditions) +
                String.format("%s;", orderBy);
        /*
        try (PreparedStatement statement = conn.prepareStatement(query)) {
            statement.setString(1, columns);
            statement.setString(2, from);
            statement.setString(3, conditions);
            return statement.executeQuery();
        } catch (SQLException se) {
            throw new StatementAndSQLException(query);
        }
        */

        /*
        PreparedStatement statement = null;
        try {
            statement = conn.prepareStatement(query);

            statement.setInt(1, rightConditions);
            System.out.println(statement.toString());
            return statement.executeQuery();
        } catch (StatementAndSQLException e){
            throw new StatementAndSQLException(statement);
        } finally {
            conn.close();
        }
        */
        return null;
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