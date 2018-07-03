<%@ page contentType="text/html;charset=GBK" %>
<%@ page import="
            javax.naming.InitialContext,
                 javax.sql.DataSource,
                 java.sql.Connection,
                 java.sql.ResultSet,
                 java.sql.Statement,
                 java.util.Hashtable"
%>
<%!
    String sqlStr = "select 1 from sysibm.sysdummy1";
    //String sqlStr="select 1 from dual";
    //String sqlStr="select 1 (tested on SQL-Server 9.0, 10.5 [2008])";
    String dataSource = "jdbc/dsrizhaoqs_o";

    public DataSource getDataSource() {
        DataSource datasource = null;
        Hashtable hashtable = new Hashtable();
        //hashtable.put("java.naming.factory.initial", "com.ibm.ejs.ns.jndi.CNInitialContextFactory");
        try {
            InitialContext initialcontext = new InitialContext();
            datasource = (DataSource) initialcontext.lookup(dataSource);
            if (datasource == null) {
                InitialContext initialcontext1 = new InitialContext(hashtable);
                datasource = (DataSource) initialcontext1.lookup(dataSource);
            }
            if (datasource == null)
                return null;
        } catch (Exception e) {
            System.out.println(e.getMessage());
            return null;
        }
        return datasource;
    }

    public Connection getConnection() {
        Connection con = null;
        try {
            DataSource datasource = getDataSource();
            if (datasource == null)
                return null;
            con = datasource.getConnection();
            if (con == null) {
                con = datasource.getConnection();
            }
            if (con != null) {
                con.setTransactionIsolation(2);
                con.setAutoCommit(true);
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
            return null;
        }
        return con;
    }
%>
<%
    Connection con = null;
    try {
        con = getConnection();
        out.println("Con: " + con + "<br>");
        Statement stat = con.createStatement();
        ResultSet rs = null;
        rs = stat.executeQuery(sqlStr);
        while (rs.next()) {
            out.println(rs.getString(1) + "</br>");
        }
        con.close();
        out.println("End of connection close<br>");
    } catch (Exception ex) {
        //ex.printStackTrace();
        out.println("[dejc301FuncTest] Exception: " + ex + "<br>");
    }
    out.println("Test completed<br>");
%>
