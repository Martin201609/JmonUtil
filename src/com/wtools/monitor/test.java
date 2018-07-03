package com.wtools.monitor;

import javax.management.*;
import java.net.UnknownHostException;
import java.util.Iterator;
import java.util.Properties;
import java.util.Set;

public class test {
    public static void main(String[] args) throws ConnectorException {
        String host = "10.1.99.16";
        String connector = "SOAP";
        String port = "8879";
        String mynode = null;

        //AdminClient
        AdminClient adminclient = null;
        String hostStr = "10.1.99.16";
        String portStr = "8879";
        String connector2 = "SOAP";
        String node = "DESKTOP-U0LGOKV";
        String mbeanType = "DataSource";

        //connector properties
        Properties props = new Properties();
        props.put(AdminClient.CONNECTOR_HOST, hostStr);
        props.put(AdminClient.CONNECTOR_PORT, portStr);
        props.put(AdminClient.CONNECTOR_TYPE, connector);

        props.setProperty(AdminClient.USERNAME, "admin");
        props.setProperty(AdminClient.PASSWORD, "password");
        props.setProperty(AdminClient.CONNECTOR_SOAP_CONFIG,"D:\\u01\\IBM\\WebSphere\\AppServer\\profiles\\Dmgr01\\properties\\soap.client.props");
        props.setProperty(AdminClient.CONNECTOR_SECURITY_ENABLED, "true");
        props.setProperty("javax.net.ssl.trustStore", "D:\\u01\\IBM\\WebSphere\\AppServer\\profiles\\AppSrv01\\etc\\DummyClientTrustFile.jks");
        props.setProperty("javax.net.ssl.keyStore", "D:\\u01\\IBM\\WebSphere\\AppServer\\profiles\\AppSrv01\\etc\\DummyClientKeyFile.jks");
        props.setProperty("javax.net.ssl.trustStorePassword", "WebAS");
        props.setProperty("javax.net.ssl.keyStorePassword", "WebAS");



        try {
            adminclient = AdminClientFactory.createAdminClient(props);
        } catch (Exception e) {
            new AdminException(e).printStackTrace();
            System.out.println("getAdminClient:Exception");
        }



        //Get datasource  status
        String queryStr;
        String process = "server1";
        String compId = "rizhao";
        ObjectName obj = null;

        //queryStr = "WebSphere:*,type=" + mbeanType + ",process="+process+",name=ds" + compId;
        queryStr = "WebSphere:type=JVM,process=server1,*";


        try {
            Set oSet = adminclient.queryNames(new ObjectName(queryStr),null);
            Iterator it = oSet.iterator();
            if (it.hasNext()) {
                obj = (ObjectName) it.next();
            } else {
                System.err.println("Cannot find dataSourceMbean for node=" + queryStr);
            }
        } catch (ConnectorException e) {
            e.printStackTrace();
        } catch (MalformedObjectNameException e) {
            e.printStackTrace();
        }

        System.out.println(adminclient);
        System.out.println(obj);



    }
}
