package utils;

import connection.DB;
import connection.StatementAndSQLException;

import java.sql.ResultSet;
import java.sql.SQLException;

public class UtilsDb {

    public static ResultSet select(String columns, String from, String conditions) throws StatementAndSQLException {
        String str  = String.format("SELECT %s\n", columns)
                + String.format("FROM %s\n", from)
                + String.format("%s;", conditions);
        return DB.query(str);
    }

    // TODO modifier si on doit faire un insert de plusieurs valeurs
    public static void insert(String table, String values) throws StatementAndSQLException {
        String str  = String.format("INSERT INTO %s\n", table)
                + String.format("VALUES (%s);", values);
        DB.update(str);
    }

    public static void update(String table, String values, String conditions) throws StatementAndSQLException {
        String str  = String.format("UPDATE %s\n", table)
                + String.format("SET %s\n", values)
                + String.format("%s;", conditions);
        DB.update(str);
    }
}
