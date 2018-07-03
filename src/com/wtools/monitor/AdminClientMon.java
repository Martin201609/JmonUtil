package com.wtools.monitor;

import javax.management.MalformedObjectNameException;
import javax.management.*;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Properties;
import java.util.Set;

/**
 * Created by wrg on 2017/7/7.
 */
public class AdminClientMon {





    public  AdminClient createAdminClient(String host,String port,String connector,String username,String password) {
        AdminClient adminclient = null;
        Properties props = new Properties();

        props.put(AdminClient.CONNECTOR_HOST,host);
        props.put(AdminClient.CONNECTOR_PORT,port);
        props.put(AdminClient.CONNECTOR_TYPE,connector);

        props.setProperty(AdminClient.USERNAME,username);
        props.setProperty(AdminClient.PASSWORD,password);

        try {
            adminclient = AdminClientFactory.createAdminClient(props);
        } catch (ConnectorException ex) {
            new AdminException(ex).printStackTrace();
            System.out.println("getAdminClient: exception");
        }

        return adminclient;
    }

    public  ObjectName getMbean(AdminClient adminclient, String queryStr)  {
        try {
            ObjectName obj = new ObjectName(queryStr);
            Set objectNameSet = adminclient.queryNames(obj, null);
            // you can check properties like type, name, and process to find a specified ObjectName
            //After you get all the ObjectNames, you can use the following example code to get all the node names:

            HashSet nodeSet = new HashSet();
            Iterator it = objectNameSet.iterator();
            if (it.hasNext()) {
                return (ObjectName) it.next();
            } else {
                System.out.println("Cann't not find the Mbean,the queryStr :" + queryStr);
                return null;
            }
        } catch (MalformedObjectNameException e) {
            e.printStackTrace();
        } catch (ConnectorException e) {
            e.printStackTrace();
        }
        return null;
    }




    public static String  getNodeContents(AdminClient ac, ObjectName ob)
    {
        //HashSet nodeSet = new HashSet();
        //String type = ob.getKeyProperty("type");
        String s;
        try {
            s = String.valueOf(ac.invoke(ob,null,null,null));
            return s;
        } catch (InstanceNotFoundException e) {
            e.printStackTrace();
        } catch (MBeanException e) {
            e.printStackTrace();
        } catch (ReflectionException e) {
            e.printStackTrace();
        } catch (ConnectorException e) {
            e.printStackTrace();
        }

        return null ;
    }





    public static void main(String [] args) {
        String host = "10.1.99.16";
        String port = "8879";
        String connector = "SOAP";

        String username = "admin";
        String password = "password";

        AdminClient adminclient = null;
        ObjectName ob = null;


        //connector properties
        Properties props = new Properties();
        props.put(AdminClient.CONNECTOR_HOST, host);
        props.put(AdminClient.CONNECTOR_PORT, port);
        props.put(AdminClient.CONNECTOR_TYPE, connector);

        props.setProperty(AdminClient.USERNAME, "admin");
        props.setProperty(AdminClient.PASSWORD, "password");
        props.setProperty(AdminClient.CONNECTOR_SOAP_CONFIG,"D:\\u01\\IBM\\WebSphere\\AppServer\\profiles\\Dmgr01\\properties\\soap.client.props");



        try {
            System.out.println("hhhhhhh");
            adminclient = AdminClientFactory.createAdminClient(props);
            System.out.println("connected to soap");

        } catch (Exception e) {
           // new AdminException().printStackTrace();
            e.printStackTrace();
            System.out.println("getAdminClient:Exception");
        }



    }



}
