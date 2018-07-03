package com.wtools.monitor;

import java.io.File;
import java.util.Date;
import java.util.Set;
import java.util.Hashtable;

import javax.management.Notification;
import javax.management.NotificationListener;
import javax.management.ObjectName;
import javax.management.MBeanServerConnection;
import javax.management.remote.JMXConnector;
import javax.management.remote.JMXConnectorFactory;
import javax.management.remote.JMXServiceURL;

public class StandaloneWASJMXClient {

    private MBeanServerConnection mbsc = null;
    private ObjectName server;
    private ObjectName jvm;
    private long ntfyCount = 0;
    private static String userid = null;
    private static String pwd = null;

    public static void main(String[] args) {
        try {

            StandaloneWASJMXClient client = new StandaloneWASJMXClient();

/*String host=args[0];
String port=args[1];
String nodeName =args[2];
userid =args[3];
pwd = args[4];*/

            String host = "10.1.99.16";
            String port = "9081";
            String nodeName = "DESKTOP-U0LGOKV";
            userid = "admin";
            pwd = "password";

            client.connect(host, port);

// Find a node agent MBean
            client.getServerMBean(nodeName);


        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void connect(String host, String port) throws Exception {
        String jndiPath = "/WsnAdminNameService#JMXConnector";

        JMXServiceURL url = new JMXServiceURL("service:jmx:iiop://" + host + "/jndi/corbaname:iiop:" + host + ":" + port + jndiPath);
//JMXServiceURL url = new JMXServiceURL("service:jmx:iiop://192.168.0.175:9100/jndi/JMXConnector");

        Hashtable h = new Hashtable();

//Specify the user ID and password for the server if security is enabled on server.

/*System.out.println("Userid is " + userid);
System.out.println("Password is " + pwd);
if ((userid.length() != 0) && (pwd.length() != 0)) {
System.out.println("adding userid and password to credentials...");
String[] credentials = new String[] {userid , pwd };
h.put("jmx.remote.credentials", credentials);
} else {
System.out.println("No credentials provided.");
}*/


//Establish the JMX connection.

        JMXConnector jmxc = JMXConnectorFactory.connect(url, h);

//Get the MBean server connection instance.

        mbsc = jmxc.getMBeanServerConnection();

        System.out.println("Connected to Application Server");
    }


    private void getServerMBean(String serverName) {
// Query for the object name of the node agent MBean on the given node
        try {
            String query = "WebSphere:type=Server,*";
            ObjectName queryName = new ObjectName(query);
            Set s = mbsc.queryNames(queryName, null);
            if (!s.isEmpty()) {
                server = (ObjectName) s.iterator().next();
                System.out.println("Server mbean found " + server.toString());
                getServerAttributes(server);
            } else {
                System.out.println("Server MBean was not found");
                System.exit(-1);
            }
        } catch (Exception e) {
            System.out.println(e);
            System.exit(-1);
        }
    }


    private void getServerAttributes(ObjectName attribObjName) {
// Query for the object name of the node agent MBean on the given node
        try {


            String name = (String) mbsc.getAttribute(attribObjName, "name");
            String state = (String) mbsc.getAttribute(attribObjName, "state");
            System.out.println("Server name: " + name + ". Server state: " + state);

        } catch (Exception e) {
            System.out.println(e);
            System.exit(-1);
        }
    }
}
