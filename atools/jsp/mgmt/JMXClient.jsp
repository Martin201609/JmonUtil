<%@ page import="com.ibm.websphere.management.AdminClient" %>
<%@ page import="com.ibm.websphere.management.AdminClientFactory" %>
<%@ page import="com.ibm.websphere.management.exception.AdminException" %>
<%@ page import="com.ibm.websphere.pmi.*" %>
<%@ page import="com.ibm.websphere.pmi.client.*" %>
<%@ page import="com.ibm.websphere.pmi.stat.MBeanLevelSpec" %>
<%@ page import="com.ibm.websphere.pmi.stat.MBeanStatDescriptor" %>
<%@ page import="com.ibm.websphere.pmi.stat.StatDescriptor" %>
<%@ page import="com.ibm.ws.pmi.client.*" %>
<%@ page import="javax.management.ObjectName" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.Set" %>
<%!
    public static AdminClient getAdminClient(String hostStr, String portStr, String connector) {
        AdminClient adminc = null;
        java.util.Properties props = new java.util.Properties();
        props.put(AdminClient.CONNECTOR_TYPE, connector);
        props.put(AdminClient.CONNECTOR_HOST, hostStr);
        props.put(AdminClient.CONNECTOR_PORT, portStr);

        try {
            adminc = AdminClientFactory.createAdminClient(props);
        } catch (Exception ex) {
            new AdminException(ex).printStackTrace();
            System.out.println("getAdminClient: exception");
        }
        return adminc;
    }

    /** Get the MBean ObjectName for a specific mbean type from a specific server.
     *  If there are multiple instances of such MBean, it will return the first one. 
     *  It will return null if there is no such type of MBean in the server.
     *  If you need to have all the MBean instances for the MBean type, you need to slightly
     *  modify this method.
     *
     * @param node node name
     * @param server server name
     * @param mbeanType the type of the MBean
     */
    public static ObjectName getMbean(AdminClient ac, String node, String compId, String mbeanType, String process) {
        try {
            String queryStr;
            if (process.equals(""))
                queryStr = "WebSphere:*,type=" + mbeanType + ",name=ds" + compId;
            else
                queryStr = "WebSphere:*,type=" + mbeanType + ",process=" + process + ",name=ds" + compId;
            Set oSet = ac.queryNames(new ObjectName(queryStr), null);
            Iterator it = oSet.iterator();
            if (it.hasNext())
                return (ObjectName) it.next();
            else {
                System.out.println("Cannot find dataSourceMbean for node=" + queryStr);
                return null;
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return null;
    }

    private String getPoolContents(AdminClient ac, String node, String compId, String mbeanType, String process) {
        ObjectName dataSourceMbean = null;
        try {
            dataSourceMbean = getMbean(ac, node, compId, "DataSource", process);
            return "<pre>" + ac.invoke(dataSourceMbean, "getPoolContents", null, null) + "</pre>";
        } catch (Exception e) {
            e.printStackTrace();
            return "<pre>" + e.toString() + "</pre>";
        }
    }
%>
<%
    String port = "8881";          // default port number
    String connector = "SOAP";     // default JMX connector
    String host = "127.0.0.1";     // default host
    String mynode;
    try {
        mynode = java.net.InetAddress.getLocalHost().getHostName();
        AdminClient ac = getAdminClient(host, port, connector);
        out.println(getPoolContents(ac, mynode, "njsteel", "DataSource", ""));
    } catch (Exception e) {
        out.println("Host not found");
    }
%>