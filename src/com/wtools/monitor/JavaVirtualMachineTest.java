package com.wtools.monitor;

import java.util.Set;

import javax.management.MalformedObjectNameException;


/**
 * Created by wrg on 2017/6/29.
 */
public class JavaVirtualMachineTest {
    AdminClient adminClient;
    JavaVirtualMachine jvm;

    @Before
    public void setUp() throws Exception {
        WASAdminClient wasAdminClient = new WASAdminClient();
        adminClient = wasAdminClient.create();
    }

    @After
    public void tearDown() throws Exception {
    }

    @Test
    public void testJavaVirtualMachine() {
        jvm = new JavaVirtualMachine();
        assertNull(jvm.getAdminClient());
    }

    @Test
    public void testJavaVirtualMachineAdminClient() {
        jvm = new JavaVirtualMachine(adminClient);
        assertNotNull(jvm.getAdminClient());
        assertTrue(jvm.getAdminClient() instanceof AdminClient);
    }

    @Test
    public void testGetAdminClient() {
        jvm = new JavaVirtualMachine(adminClient);
        assertEquals(jvm.getAdminClient(), adminClient);
    }

    @Test
    public void testSetAdminClient() {
        jvm = new JavaVirtualMachine();
        jvm.setAdminClient(adminClient);
        assertEquals(jvm.getAdminClient(), adminClient);
    }

    @Test
    public void testQueryMBeans() throws MalformedObjectNameException,
            NullPointerException, ConnectorException {
        jvm = new JavaVirtualMachine();
        Set mBeans = jvm.queryMBeans();
        assertTrue(mBeans.size() > 0);
    }

    @Test
    public void testGetMBeans() {
        fail("Not yet implemented");
    }

    @Test
    public void testSetMBeans() {
        fail("Not yet implemented");
    }

    @Test
    public void testGetMBean() {
        fail("Not yet implemented");
    }

    @Test
    public void testSetMBean() {
        fail("Not yet implemented");
    }

    @Test
    public void testGetHeapSize() {
        fail("Not yet implemented");
    }

    @Test
    public void testGetMaxMemory() {
        fail("Not yet implemented");
    }

    @Test
    public void testGetMaxHeapDumpsOnDisk() {
        fail("Not yet implemented");
    }

    @Test
    public void testGetFreeMemory() {
        fail("Not yet implemented");
    }
}
