package com.wtools.monitor;

import java.util.Properties;
import java.util.ResourceBundle;


/**
 * Created by wrg on 2017/6/29.
 */
public class WASAdminClient {
    private String hostname = "localhost";    // default
    private String port = "8879";             // default

    private String username;
    private String password;
    private String connector_security_enabled;
    private String connector_soap_config;
    private String ssl_trustStore;
    private String ssl_keyStore;
    private String ssl_trustStorePassword;
    private String ssl_keyStorePassword;

    private ResourceBundle soapClient;
    private String soap_client_properties;

    private AdminClient adminClient;

    public WASAdminClient() throws ConnectorException {
        soap_client_properties = "soap_client";
    }

    public WASAdminClient(String soap_client_properties) throws ConnectorException {
        this.soap_client_properties = soap_client_properties;
    }

    public AdminClient getAdminClient() {
        return adminClient;
    }

    public AdminClient create() throws ConnectorException {
        getResourceBundle(soap_client_properties);

        Properties props = new Properties();
        props.setProperty(AdminClient.CONNECTOR_TYPE, AdminClient.CONNECTOR_TYPE_SOAP);
        props.setProperty(AdminClient.CONNECTOR_HOST, hostname);
        props.setProperty(AdminClient.CONNECTOR_PORT, port);
        props.setProperty(AdminClient.CACHE_DISABLED, "false");

        if (connector_security_enabled == "false") {
            adminClient = AdminClientFactory.createAdminClient(props);
            return adminClient;
        }

        props.setProperty(AdminClient.CONNECTOR_SECURITY_ENABLED, "true");
        props.setProperty(AdminClient.CONNECTOR_AUTO_ACCEPT_SIGNER, "true");
        props.setProperty("javax.net.ssl.trustStore", ssl_trustStore);
        props.setProperty("javax.net.ssl.keyStore", ssl_keyStore);
        props.setProperty("javax.net.ssl.trustStorePassword", ssl_trustStorePassword);
        props.setProperty("javax.net.ssl.keyStorePassword", ssl_keyStorePassword);

        // Use username and password or soap.client.props file
        if (username == null || password == null) {
            props.setProperty(AdminClient.CONNECTOR_SOAP_CONFIG, connector_soap_config);
        } else {
            props.setProperty(AdminClient.USERNAME, username);
            props.setProperty(AdminClient.PASSWORD, password);
        }

        adminClient = AdminClientFactory.createAdminClient(props);

        return adminClient;
    }

    public ResourceBundle getResourceBundle(String properties) {
        soapClient = ResourceBundle.getBundle(properties);

        hostname = soapClient.getString("hostname");
        port = soapClient.getString("port");
        connector_security_enabled = soapClient.getString("connector_security_enabled");
        ssl_trustStore = soapClient.getString("ssl_trustStore");
        ssl_keyStore = soapClient.getString("ssl_keyStore");
        ssl_trustStorePassword = soapClient.getString("ssl_trustStorePassword");
        ssl_keyStorePassword = soapClient.getString("ssl_keyStorePassword");

        if (soapClient.containsKey("connector_soap_config")) {
            connector_soap_config = soapClient.getString("connector_soap_config");
        }

        if (soapClient.containsKey("username")) {
            username = soapClient.getString("username");
        }

        if (soapClient.containsKey("password")) {
            password = soapClient.getString("password");
        }

        if (soapClient.containsKey("hostname")) {
            hostname = soapClient.getString("hostname");
        }

        if (soapClient.containsKey("port")) {
            port = soapClient.getString("port");
        }

        return soapClient;
    }
}
