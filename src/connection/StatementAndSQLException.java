package connection;

import java.sql.SQLException;

public class StatementAndSQLException extends SQLException {

    String wrongQuery;

    public StatementAndSQLException(String query){
        wrongQuery = query;
    }

    @Override
    public void printStackTrace() {
        System.err.println(wrongQuery);
        super.printStackTrace(System.err);
    }
}
