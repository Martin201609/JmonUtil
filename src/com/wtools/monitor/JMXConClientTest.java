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

public class JMXConClientTest implements NotificationListener{

    private MBeanServerConnection mbsc = null;
    private ObjectName nodeAgent;
    private ObjectName jvm;
    private long ntfyCount = 0;
    private static String userid = null;
    private static String pwd = null;

    public static void main(String[] args)
    {
        try {

            JMXConClientTest client = new JMXConClientTest();

            String host="10.1.99.16";
            String port="8879";
            String nodeName ="DESKTOP-U0LGOKV";
            userid ="admin";
            pwd ="passsword";

            client.connect(host,port);

//            // Find a node agent MBean
//            client.getNodeAgentMBean(nodeName);
//
//            // Invoke the launch process.
//            client.invokeLaunchProcess("server1");
//
//            // Register for node agent events
//            client.registerNotificationListener();
//
//            // Run until interrupted.
//            client.countNotifications();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void connect(String host,String port) throws Exception
    {
        String jndiPath="/WsnAdminNameService#JMXConnector";

        JMXServiceURL url =
                new JMXServiceURL("service:jmx:iiop://"+host+"/jndi/corbaname:iiop:"+host+":"+port+jndiPath);

        Hashtable h  = new Hashtable();

        //Specify the user ID and password for the server if security is enabled on server.

        System.out.println("Userid is " + userid);
        System.out.println("Password is " + pwd);
        if ((userid.length() != 0) && (pwd.length() != 0)) {
            System.out.println("adding userid and password to credentials...");
            String[] credentials = new String[] {userid , pwd };
            h.put("jmx.remote.credentials", credentials);
        } else {
            System.out.println("No credentials provided.");
        }


        //Establish the JMX connection.

        JMXConnector jmxc = JMXConnectorFactory.connect(url, h);

        //Get the MBean server connection instance.

        mbsc = jmxc.getMBeanServerConnection();

        System.out.println("Connected to DeploymentManager");
    }


    @Override
    public void handleNotification(Notification notification, Object handback) {

    }
}
