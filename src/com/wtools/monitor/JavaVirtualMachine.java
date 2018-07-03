package com.wtools.monitor;


import java.util.Set;

import javax.management.AttributeNotFoundException;
import javax.management.InstanceNotFoundException;
import javax.management.MBeanException;
import javax.management.MalformedObjectNameException;
import javax.management.ObjectName;
import javax.management.ReflectionException;


/**
 * Created by wrg on 2017/6/29.
 */
public class JavaVirtualMachine {

    private String heapSize;
    private String maxMemory;
    private Integer maxHeapDumpsOnDisk;
    private String freeMemory;

    private ObjectName mBean;
    private Set mBeans;
    private AdminClient adminClient;

    public JavaVirtualMachine() {
    }

    public JavaVirtualMachine(AdminClient adminClient) {
        this.adminClient = adminClient;
    }

    public AdminClient getAdminClient() {
        return adminClient;
    }

    public void setAdminClient(AdminClient adminClient) {
        this.adminClient = adminClient;
    }

    public Set queryMBeans() throws MalformedObjectNameException,
            NullPointerException, ConnectorException {
        String query = "WebSphere:type=JVM,*";
        ObjectName queryName = new ObjectName(query);
        mBeans = adminClient.queryNames(queryName, null);

        return mBeans;
    }

    public Set getMBeans() {
        return mBeans;
    }

    public void setMBeans(Set mBeans) {
        this.mBeans = mBeans;
    }

    public ObjectName getMBean() {
        return mBean;
    }

    public void setMBean(ObjectName mBean) {
        this.mBean = mBean;
    }

    public String getHeapSize(ObjectName mBean) throws AttributeNotFoundException,
            InstanceNotFoundException,
            MBeanException, ReflectionException,
            ConnectorException {
        heapSize = (String) adminClient.getAttribute(mBean, "heapSize");
        return heapSize;
    }

    public String getMaxMemory(ObjectName mBean) throws AttributeNotFoundException,
            InstanceNotFoundException, MBeanException,
            ReflectionException, ConnectorException {
        maxMemory = (String) adminClient.getAttribute(mBean, "maxMemory");
        return maxMemory;
    }

    public Integer getMaxHeapDumpsOnDisk(ObjectName mBean) throws AttributeNotFoundException,
            InstanceNotFoundException, MBeanException,
            ReflectionException, ConnectorException {
        maxHeapDumpsOnDisk = (Integer) adminClient.getAttribute(mBean, "maxHeapDumpsOnDisk");
        return maxHeapDumpsOnDisk;

    }

    public String getFreeMemory(ObjectName mBean) throws AttributeNotFoundException,
            InstanceNotFoundException, MBeanException,
            ReflectionException, ConnectorException {
        freeMemory = (String) adminClient.getAttribute(mBean, "freeMemory");
        return freeMemory;
    }
}
