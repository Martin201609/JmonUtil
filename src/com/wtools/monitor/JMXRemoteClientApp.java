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

public class JMXRemoteClientApp implements NotificationListener {

    private MBeanServerConnection mbsc = null;
    private ObjectName nodeAgent;
    private ObjectName jvm;
    private long ntfyCount = 0;
    private static String userid = null;
    private static String pwd = null;

    public static void main(String[] args)
    {
        try {

            JMXRemoteClientApp client = new JMXRemoteClientApp();

            String host=args[0];
            String port=args[1];
            String nodeName =args[2];
            userid =args[3];
            pwd = args[4];

            client.connect(host,port);

            // Find a node agent MBean
            client.getNodeAgentMBean(nodeName);

            // Invoke the launch process.
            client.invokeLaunchProcess("server1");

            // Register for node agent events
            client.registerNotificationListener();

            // Run until interrupted.
            client.countNotifications();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void connect(String host,String port) throws Exception
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


    private void getNodeAgentMBean(String nodeName)
    {
        // Query for the object name of the node agent MBean on the given node
        try {
            String query = "WebSphere:type=NodeAgent,node=" + nodeName + ",*";
            ObjectName queryName = new ObjectName(query);
            Set s = mbsc.queryNames(queryName, null);
            if (!s.isEmpty()) {
                nodeAgent = (ObjectName)s.iterator().next();
                System.out.println("NodeAgent mbean found "+ nodeAgent.toString());
            } else {
                System.out.println("Node agent MBean was not found");
                System.exit(-1);
            }
        } catch (Exception e) {
            System.out.println(e);
            System.exit(-1);
        }
    }


    private void invokeLaunchProcess(String serverName)
    {
        // Use the launch process on the node agent MBean to start
        // the given server.
        String opName = "launchProcess";
        String signature[] = { "java.lang.String"};
        String params[] = { serverName};
        boolean launched = false;
        try {
            Boolean b = (Boolean)mbsc.invoke(nodeAgent, opName, params, signature);
            launched = b.booleanValue();
            if (launched)
                System.out.println(serverName + " was launched");
            else
                System.out.println(serverName + " was not launched");

        } catch (Exception e) {
            System.out.println("Exception invoking launchProcess: " + e);
        }
    }


    private void registerNotificationListener()
    {
        // Register this object as a listener for notifications from the
        // node agent MBean.  Do not use a filter and do not use a handback
        // object.
        try {
            mbsc.addNotificationListener(nodeAgent, this, null, null);
            System.out.println("Registered for event notifications");
        } catch (Exception e) {
            System.out.println(e);
        }
    }

    @Override
	public void handleNotification(Notification ntfyObj, Object handback)
    {
        // Each notification that the node agent MBean generates results in
        // a call to this method.
        ntfyCount++;
        System.out.println("***************************************************");
        System.out.println("* Notification received at " + new Date().toString());
        System.out.println("* type      = " + ntfyObj.getType());
        System.out.println("* message   = " + ntfyObj.getMessage());
        System.out.println("* source    = " + ntfyObj.getSource());
        System.out.println(
                "* seqNum    = " + Long.toString(ntfyObj.getSequenceNumber()));
        System.out.println("* timeStamp = " + new Date(ntfyObj.getTimeStamp()));
        System.out.println("* userData  = " + ntfyObj.getUserData());
        System.out.println("***************************************************");

    }

    private void countNotifications()
    {
        // Run until stopped.
        try {
            while (true) {
                Thread.currentThread();
				Thread.sleep(60000);
                System.out.println(ntfyCount + " notification have been received");
            }
        } catch (InterruptedException e) {
        }
    }

}