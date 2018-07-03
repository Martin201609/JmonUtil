package com.wtools.monitor;

import java.net.URL;
import java.net.URLEncoder;
import java.sql.Timestamp;
import java.util.Collection;
import java.util.List;
import java.util.Vector;

import org.codehaus.xfire.client.Client;
import org.springframework.remoting.rmi.RmiProxyFactoryBean;

import com.icsc.dpms.dq.pool.threadPool.server.dqjcDQRMIServer;
import com.icsc.dpms.dq.pool.threadPool.server.dqjiDQServer;
import com.icsc.dpms.du.dujc000;
import com.icsc.dpms.du.dujc007;
import com.icsc.dpms.dw.dwjc111;
//import com.icsc.ums.func.umscDqFunc;
//import com.shimne.util.DateUtil;

public class pfjcBatchTest extends pfjcTest
{
	private Timestamp newWorkItem;

	@SuppressWarnings("deprecation")
	//@Test
	public void test() throws Exception
	{
//		dwjc111 dw11 = new dwjc111(dsCom);
//		newWorkItem = dw11.newWorkItem("111", "2222", URLEncoder.encode("http://prod.rizhaosteel.com/erp/uw/jsp/uwjj01.jsp", "GBK"));
//		System.out.println(newWorkItem);
//		RmiProxyFactoryBean factoryBean = new RmiProxyFactoryBean();
//		factoryBean.setServiceUrl("rmi://10.1.198.176:1699/DQ");
//		factoryBean.setServiceInterface(dqjiDQServer.class);
//		factoryBean.afterPropertiesSet();
//		dqjiDQServer dqServer = (dqjiDQServer) factoryBean.getObject();
//		System.out.println(dqServer);
//		dqServer.getClass();
////		dqServer.getQueueList();
//		dqServer.getScheduleList();
//		dujc007 du07 = new dujc007(dsCom);
//		List<dujc000>  list = du07.getUpper("R024804");
//		List<dujc000>  list1 = du07.getUpper("R036954");
//		
//		for (dujc000 du00 : list)
//		{
//			System.out.println(du00.cName);
//		}
//		System.out.println("----------------");
//		for (dujc000 du00 : list1)
//		{
//			System.out.println(du00.cName);
//		}

//		umscDqFunc umsDqFunc = new umscDqFunc();
//		umsDqFunc.monitor(dsCom, "DQHAND");
// System.out.println(DateUtil.formatLong("2017-07-01"));
//		URL url = new URL("http://10.1.192.84:7001/rglms/services/LMSVS1Service?wsdl");
//		
//		Client client = new Client(url);
//		Object[] result = client.invoke("getTransUnitPrice", new Object[]{"RDSRH7100000227680004        61000   20170626R03"});
//		System.out.println(result[0].toString());
	}
}