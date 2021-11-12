public class DB {
    public static void main(String[] args) {
        String url="jdbc:postgresql://172.24.2.6:5432/dbjoachimbastin";
        Connection conn=null;
        try {
            conn=DriverManager.getConnection(url,"joachimbastin","IQXR6CLVW");
        } catch (SQLException e) {
            System.out.println("Impossible de joindre le server !");
            System.exit(1);
        }
    }
}