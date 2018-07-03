package com.wtools.monitor;
import junit.framework.TestCase;

import com.icsc.dpms.ds.dsjccom;

public class pfjcTest extends TestCase
{
	protected String appId = "PFJCTEST";
	protected String compId = "rizhao";
	protected String url = "jdbc/rizhao";
	protected String userId = "R026344";
	protected String db_Url = "jdbc:oracle:thin:@10.1.198.241:1521:CXTEST";
	protected String db_userId = "javauser";
	protected String db_passwd = "javauser";
	protected String language = "UTF-8";
	protected String driver = "oracle.jdbc.OracleDriver";
	protected dsjccom dsCom;

	public pfjcTest ()
	{

	}

	@Override
	protected void setUp() throws Exception
	{
		this.dsCom = getDsCcom();
		super.setUp();
	}

	@SuppressWarnings("deprecation")
	protected dsjccom getDsCcom ()
	{
		dsjccom dsCom = new dsjccom();
		dsCom.setDsjccom(url, appId, userId);
		dsCom.db.userId = db_userId;
		dsCom.db.passwd = db_passwd;
		dsCom.db.url = db_Url;
		dsCom.ver = "1";
		dsCom.linkType = 1;
		dsCom.db.linkFlag = true;
		dsCom.dateType = 0;
		dsCom.debugFlag = 17;
		dsCom.language = language;
		dsCom.db.driver = driver;
		dsCom.companyId = compId;
		dsCom.user.ID = userId;
		dsCom.homeUrl = "";
		return dsCom;
	}
}
