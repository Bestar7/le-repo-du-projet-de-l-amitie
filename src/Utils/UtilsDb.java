package Utils;

import connection.DB;

import java.sql.ResultSet;

public class UtilsDb {

    public ResultSet select(String columns, String from, String conditions){
        String str  = String.format("SELECT %s\n", columns)
                + String.format("FROM %s\n", from)
                + String.format("%s;", conditions);
        return DB.query(str);
    }

    // TODO modifier si on doit faire un insert de plusieurs valeurs
    public void insert(String table, String values) {
        String str  = String.format("INSERT INTO %s\n", table)
                + String.format("VALUES (%s);", values);
        DB.update(str);
    }

    public void update(String table, String values, String conditions){
        String str  = String.format("UPDATE %s\n", table)
                + String.format("SET %s\n", values)
                + String.format("%s;", conditions);
        DB.update(str);
    }
}
