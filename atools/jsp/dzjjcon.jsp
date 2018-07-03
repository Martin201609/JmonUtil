<%@ page contentType="text/html;charset=GBK" %>
<%@ page buffer="64kb"
         language="java"
         session="true"
         autoFlush="true"
         isThreadSafe="true"
         errorPage="dzjjerr.jsp"
%>
<%@ page import="com.icsc.dpms.de.*" %>
<%@ page import="com.icsc.dpms.ds.dsjcst0" %>
<%@ page import="java.io.BufferedWriter" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.FileWriter" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="java.util.Hashtable" %>
<%!
    String commondFile[] = new String[]{"conTest.jsp", "errorMsg.jsp"};
    String includeFile[] = new String[]{"dzjjcon.jsp", "dzjjerr.jsp"};

    void WriteConTest(String path, boolean isDpms, int i) throws IOException {
        String fullPath = path + File.separator + "jsp" + File.separator + commondFile[i];

        File file = new File(fullPath);
        if (!file.exists()) new File(file.getParent()).mkdirs();

        BufferedWriter bw = new BufferedWriter(new FileWriter(fullPath));
        bw.write("<");

        if (isDpms) {
            bw.write("%@ include ");
            bw.write("file=\"../../../jsp/" + includeFile[i] + "\" %");
        } else {
            bw.write("%@ include ");
            bw.write("file=\"../../jsp/" + includeFile[i] + "\" %");
        }

        bw.write(">");
        bw.newLine();
        bw.close();
    }
%>
<%
    response.setContentType("text/html;charset=" + dsjcst0.getLanguage());
    dejc300 de300 = new dejc300();
    dejc301 de301 = new dejc301();
    // 取得目前时间
    dejc308 de308 = new dejc308();
    // 取得目前星期
    dejc311 de311 = new dejc311();

    String msg = request.getParameter("SYS");

    msg = (msg == null) ? "" : msg;
    msg += System.getProperty("com.ibm.ejs.sm.adminServer.primaryNode", "");


%>
<head>
    <title>Connect 监测 Ⅱ</title>
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="Content-Language" content="zh-cn">
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312">
    <link rel=stylesheet href="<%= de300.html("", "/dzwcss.gui") %>" type="text/css">
    <script language="JavaScript" src="<%= de300.script("de", "/dejtmf25.jss") %>"></script>
</head>
<body leftmargin="0" topmargin="0" class="whole-bg">
<table width="100%" border="0" cellspacing="0" cellpadding="0" background="/erp/images/logo/app_bg.gif">
    <tr>
        <td width="200" nowrap align="center">
            <img src="/erp/images/logo/app_logo.gif" border="0" alt="icsc"></td>
        <td align="center" nowrap width="1">&nbsp;</td>
        <td align="center" nowrap><font size="+2" color="#6A86CF"><b><span id="APTitle">Connection
      监控程式</span></b></font></td>
        <td nowrap width="220"><a href="http://www.icsc.com.tw"><img border="0" src="/erp/images/logo/app_mark.gif"
                                                                     align="right"></a>
        </td>
    </tr>

    <tr>
        <td width="200" nowrap align="center">&nbsp;<font size="-1" color="#6A86CF"><b><span
                id="SYSTitle"></span></b></font></td>
        <td width="1" align="left" nowrap class="subsys-title" valign="top"><img src="/erp/images/logo/app_tab.gif">
        </td>
        <td class="subsys-title-left" nowrap><font size="-1"><%= de308.getMonth()%>/<%= de308.getDayOfMonth()%>
            <%= de311.getChnNameOfWeekDay(de308.getDayOfWeek())%> <%= de308.getCrntTimeFmt2()%>
        </font>
            > <span id="MenuMsg" style="color:Yellow"><%= msg %> 系统总连结次数: <%=de301.getInt()%></span></td>
        <th class="subsys-title-right" nowrap><a href="/erp/ds/jsp/dsjjso1.jsp"><img border="0"
                                                                                     src="/erp/images/dzwiexit.gif"
                                                                                     alt="登出系统"></a></th>
    </tr>
</table>
<script language='JavaScript'>
    var ToolBar_Supported = ToolBar_Supported;

    if (ToolBar_Supported != null && ToolBar_Supported == true) {
        //To Turn on/off Frame support, set Frame_Supported = true/false.
        Frame_Supported = false;

        // Customize default ICP menu color - bgColor, fontColor, mouseoverColor
        setDefaultICPMenuColor("#6A86CF", "#ffffff", "#FF0000");

        // Customize toolbar background color
        setToolbarBGColor("White");

        //***** Add ICP menus *****

        addMenuItem("_", "首页", "/erp/ds/dsjsp00", "_self");
        addMenuItem("_0", "回到入口首页", "/erp/ds/dsjsp00", "_self");
        addMenuItem("_Z", "上一页", "javascript:history.go(-1)", "_self");
        addMenuItem("-", "总表", "/erp/jsp/dzjj301.jsp", "_blank");
        addMenuItem("-0", "Connection 总表", "/erp/jsp/dzjj301.jsp", "_blank");

        addMenuItem("D", "IPMS", "/erp/jsp/dzjjcon.jsp", "_self");
        <%
        /*
            String path = application.getRealPath("");
            int root = path.indexOf(File.separator);
            int appRoot = path.indexOf(File.separator, root+1);
            path = (appRoot == -1 ) ? path : path.substring(0, appRoot);
        */
            String path = dejc332.getERPHome();

            String conTest = request.getParameter(".ConTest");
            String dpms = request.getParameter(".DPMS");
            String errorMsg = request.getParameter(".ErrorMsg");

            File fileDPMS = new File(path + File.separator + "dpms" + File.separator);
            File[] filesDPMS = fileDPMS.listFiles();

            if (filesDPMS != null) {
                Arrays.sort(filesDPMS);

                for (int i=0; filesDPMS != null && i<filesDPMS.length; i++) {
                    if(filesDPMS [i].getName().length() > 2) continue;
                    if (filesDPMS [i].isDirectory()) {
                        out.println("        addMenuItem(\"" + filesDPMS [i].getName().toUpperCase() + "\",\"" + filesDPMS [i].getName().toUpperCase() + "\",\"/erp/" + filesDPMS[i].getName() + "/jsp/conTest.jsp\", \"_self\");");
                        if(conTest != null || dpms != null)
                            WriteConTest(path + File.separator + "dpms" + File.separator + filesDPMS [i].getName(), true, 0);
                        if(errorMsg != null)
                            WriteConTest(path + File.separator + "dpms" + File.separator + filesDPMS [i].getName(), true, 1);
                    }
                }
            }

            File file = new File(path  + File.separator);
            File[] files = file.listFiles();

            if (files != null) {
                Arrays.sort(files);

                String sys = "";
                for (int i=0; i<files.length; i++) {
                    if(files[i].getName().length() > 2) continue;

                    String tempSYS = files[i].getName().substring(0,1).toUpperCase();

                    if (files[i].isDirectory()) {
                        if (sys.equals(tempSYS) == false) {
                            sys = tempSYS;
                            out.println("        addMenuItem(\"" + sys + "\",\"" + sys + "\",\"/erp/" + files[i].getName() + "/jsp/conTest.jsp\", \"_self\");");
                        }
                        out.println("        addMenuItem(\"" + files [i].getName().toUpperCase() + "\",\"" + files [i].getName().toUpperCase() + "\",\"/erp/" + files[i].getName() + "/jsp/conTest.jsp\", \"_self\");");
                        if(conTest != null)
                            WriteConTest(path + File.separator + files [i].getName(), false, 0);
                        if(errorMsg != null)
                            WriteConTest(path + File.separator + files [i].getName(), false, 1);
                    }
                }
            }
        %>
        drawToolbar();
    }
    //-->
</script>
<%
    Hashtable appCount = de301.getAppCount();
    Enumeration app = appCount.keys();
    StringBuffer appBuf = new StringBuffer();

    while (app.hasMoreElements()) {
        String appId = (String) app.nextElement();
        Integer count = (Integer) appCount.get(appId);
        appBuf.append("  <tr>\r\n");
        appBuf.append("    <td class=light-bg-left>&nbsp;").append(appId).append("</td>\r\n");
        appBuf.append("    <td class=light-bg-right>&nbsp;").append(count.intValue()).append("</td>\r\n");
        appBuf.append("  </tr>\r\n");
    }

    Hashtable conCount = de301.getCount();
    Enumeration con = conCount.keys();
    StringBuffer conBuf = new StringBuffer();
    int conTotal = 0;

    while (con.hasMoreElements()) {
        String appId = (String) con.nextElement();
        Integer count = (Integer) conCount.get(appId);
        conBuf.append("  <tr>\r\n");
        conBuf.append("    <td class=light-bg-left>&nbsp;").append(appId).append("</td>\r\n");
        if (count.intValue() == 0)
            conBuf.append("    <td align=right>&nbsp;").append(count.intValue()).append("</td>\r\n");
        else
            conBuf.append("    <td style=color:red align=right bgcolor=white><b>&nbsp;").append(count.intValue()).append("</b></td>\r\n");
        conBuf.append("  </tr>\r\n");
        conTotal += count.intValue();
    }

    Hashtable poolCount = de301.getPoolCount();
    Enumeration pool = poolCount.keys();
    StringBuffer timeBuf = new StringBuffer();

    while (pool.hasMoreElements()) {
        String appId = (String) pool.nextElement();
        Integer count = (Integer) appCount.get(appId);
        Long times = (Long) poolCount.get(appId);
        long ave = (count == null) ? times.longValue() : times.longValue() / count.intValue();
        timeBuf.append("  <tr>\r\n");
        timeBuf.append("    <td class=light-bg-left>&nbsp;").append(appId).append("</td>\r\n");
        timeBuf.append("    <td class=light-bg-right>&nbsp;").append(times.longValue()).append("</td>\r\n");
        if (ave > 1000)
            timeBuf.append("    <td style=color:red align=right bgcolor=white>&nbsp;").append(ave).append("</td>\r\n");
        else
            timeBuf.append("    <td class=light-bg-right>&nbsp;").append(ave).append("</td>\r\n");
        timeBuf.append("  </tr>\r\n");
    }
%>
<form name="form1" method="post" action="">
    <table border="1" class=function-bar cellspacing="0" cellpadding="0" align="center">
        <tr>
            <td colspan=3 class=subsys-title-left>
                <input type="submit" name="Button" value="更新">
                监控各系统程式使用 de301 的使用统计表
            </td>
        </tr>
        <tr>
            <td valign="top">
                <table border="0" cellspacing="2" cellpadding="1">
                    <tr class=subsys-title>
                        <th nowrap>程 式 别</th>
                        <th nowrap>使用次数</th>
                    </tr>
                    <%= appBuf.toString() %>
                </table>
            </td>
            <td valign="top">
                <table border="0" cellspacing="2" cellpadding="1">
                    <tr>
                        <th nowrap class=msg><%= conTotal%> / <%= de301.getInt()%>
                        </th>
                        <th nowrap class=subsys-title>非标准数</th>
                    </tr>
                    <%= conBuf.toString() %>
                </table>
            </td>
            <td valign="top">
                <table border="0" cellspacing="2" cellpadding="1">
                    <tr class=subsys-title>
                        <th nowrap>程 式 别</th>
                        <th nowrap>使用微秒数</th>
                        <th nowrap>平均</th>
                    </tr>
                    <%= timeBuf.toString() %>
                </table>
            </td>
        </tr>
    </table>
</form>
</body>
</html>