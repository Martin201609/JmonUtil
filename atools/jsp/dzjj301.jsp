<%@ page contentType="text/html;charset=GBK" %>
<%-- ----------------------------------------------------*/
/* DZJJ301	Ver $Revision: 1.3 $
/*-------------------------------------------------------*/
/* author : $Author: I20306 $
/* system : I20306 (叶育材)
/* target : Connection 监控器
/* create : 2002/04/28
/* update : $Date: 2007/03/08 06:30:34 $
/*---------------------------------------------------- --%>
<%@ page buffer="64kb"
         language="java"
         session="true"
         autoFlush="true"
         isThreadSafe="true"
         errorPage="dzjjerr.jsp"
%>
<%@ page import="com.icsc.dpms.de.dejc300" %>
<%@ page import="com.icsc.dpms.de.dejc301" %>
<%@ page import="com.icsc.dpms.de.dejc308" %>
<%@ page import="com.icsc.dpms.de.dejc332" %>
<%@ page import="com.icsc.dpms.de.sql.dejc301c" %>
<%@ page import="com.icsc.dpms.de.sql.dejc301q" %>
<%@ page import="java.io.BufferedWriter" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.FileWriter" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.util.*" %>
<%! final static String _AppId = "DZJJ301";
    final static String SysId = "erp";
    static boolean isJ2EEServer = Boolean.getBoolean("com.icsc.dpms.de.dejc300.j2ee");
    static boolean isRunLog = false;
    static boolean isStop = false;
    static boolean isWrite = false;
    static int sleepTime = 30000;
    static int countNo = 0;
    static String runtimeStr = "";
    static NewThread t = null;

    // 执行相关资料的起始
    public void jspInit() {
        new NewThread();
        runtimeStr = new dejc308().getCrntTimeFmt3() + "- Init";
        System.err.println(SysId + this + runtimeStr);
    }

    // 执行关闭各种物件的动作
    public void jspDestroy() {
        isStop = true;
    }

    String commondFile[] = new String[]{"conTest.jsp", "errorMsg.jsp", "conList.jsp"};
    String includeFile[] = new String[]{"dzjjcon.jsp", "dzjjerr.jsp", "dzjj301c.jsp"};

    synchronized boolean WriteConTest(String sysId, String path, boolean isDpms, int i) throws IOException {
        String jspPath = path + File.separator + "jsp" + File.separator;

        File jspDir = new File(jspPath);

        if (jspDir.exists() == false) {
            return false;
        }

        BufferedWriter bw = new BufferedWriter(new FileWriter(jspPath + commondFile[i]));
/*
		bw.write("<");
		bw.write("%@ page contentType = \"text/html;charset=cp950\"%");
		bw.write(">");
*/
        bw.newLine();
        bw.write("<");
        bw.write("%! static final String SysId =\"" + sysId + "\"; %");
        bw.write(">");
        bw.newLine();
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
        return true;
    }

    public String genJsp(String path, File[] files, boolean isDpms, int index) throws IOException {
        StringBuffer result = new StringBuffer();
        String jspPath = path + File.separator;

        for (int i = 0; files != null && i < files.length; i++) {
            if (files[i].getName().length() > 3) continue;
            if (files[i].isDirectory()) {
                if (isDpms) {
                    jspPath = path + File.separator + "dpms" + File.separator;
                    result.append("dpms/");
                }

                boolean isOK = WriteConTest(files[i].getName(), jspPath + files[i].getName(), isDpms, index);
                result.append(files[i].getName()).append(": ").append(isOK).append(", ");
            }
        }

        return result.toString();
    }

    public String genSys(String path, File[] files, boolean isDpms, int index) throws IOException {
        StringBuffer result = new StringBuffer();
        String jspPath = null;
        String sysId = null;
        Set sysSet = new HashSet();

        for (int i = 0; files != null && i < files.length; i++) {
            sysId = files[i].getName();
            if (sysId.length() > 3) continue;

            if (files[i].isDirectory()) {
                jspPath = path + File.separator;

                if (isDpms) {
                    jspPath += "dpms" + File.separator;
                }

                jspPath += sysId + File.separator + "jsp" + File.separator;

                File jspDir = new File(jspPath);

                if (jspDir.exists() == false) {
                    continue;
                }

                String sysType = sysId.substring(0, 1).toUpperCase();

                if (sysSet.add(sysType)) {
                    result.append("addMenuItem(\"").append(sysType).append("\", \"").append(sysType).append("\",\"#\");\r\n");
                }

                result.append("addMenuItem(\"").append(sysId.substring(0, 2).toUpperCase()).append("\", \"").append(sysId.toUpperCase()).append("\",\"?SysId=").append(sysId).append("\");\r\n");
            }
        }

        return result.toString();
    }

    synchronized public void writeLog(Map sqlTable, int total, String nowTime) {
        Iterator i = sqlTable.keySet().iterator();

        if (i.hasNext()) {
            dejc308 de308 = new dejc308();
            StringBuffer logBuf = new StringBuffer();
            logBuf.append(nowTime + "--- [" + SysId + "] --- [" + total + "] --- (" + de308.getCrntTimeFmt3() + ")\r\n");
            // 讯息
            do {
                Object conKey = i.next();
                dejc301q queryCon = (dejc301q) sqlTable.get(conKey);

                if (queryCon != null) {
                    logBuf.append(SysId).append("\t");
                    logBuf.append(conKey).append("\t");
                    logBuf.append(queryCon.getAppId()).append("\t");
                    logBuf.append(queryCon.getClassId()).append("\t");
                    logBuf.append(queryCon.getUserId()).append("\t");
                    logBuf.append(queryCon.showTime(nowTime)).append("\t");
                    queryCon.toTableString(logBuf);
                    logBuf.append("\r\n");
                }
            } while (i.hasNext());
            // 写档
            try {
                String fileName = "waslogs/Connection/" + de308.getCrntDateWFmt1() + "/SQL/" + SysId + de308.getCrntTimeFmt1() + ".log";
                File conLog = new File(fileName);
                if (conLog.exists() == false) {
                    new File(conLog.getParent()).mkdirs();
                }

                BufferedWriter bw = new BufferedWriter(new FileWriter(fileName, true), 1024);
                bw.write(logBuf.toString());
                bw.newLine();
                bw.flush();
                bw.close();
            } catch (Exception e) {
                e.printStackTrace();
                System.err.println(logBuf);
            }
        }
    }

    void setSleepTime(String timer) {
        try {
            int tmp = Integer.parseInt(timer) * 1000;
            if (sleepTime > 10000) {
                sleepTime = tmp;
            }
        } catch (NumberFormatException nfe) {
        }
    }

    class NewThread implements Runnable {
        Thread t;

        NewThread() {
            // Create a new, second thread
            t = new Thread(this, "dzjj301 - Log Thread - " + System.currentTimeMillis());
            t.start(); // Start the thread
        }

        // This is the entry point for the second thread.
        public void run() {
            while (true) {
                try {
                    Thread.sleep(sleepTime);
                    if (isRunLog && isWrite == false) {
                        isWrite = true;
                        writeConLog();
                        isWrite = false;
                    }
                } catch (InterruptedException e) {
                    isWrite = false;
                    System.out.println("[conTest] writeConLog NewThread Interrupted: " + e);
                    runtimeStr = new dejc308().getCrntTimeFmt3() + " - Error";
                } catch (Exception e) {
                    System.out.println("[conTest] writeConLog NewThread Error: " + e);
                    runtimeStr = new dejc308().getCrntTimeFmt3() + " - Exp";
                }

                if (isStop) {
                    runtimeStr = new dejc308().getCrntTimeFmt3() + " - Stop";
                    break;
                }
            }
        }

        synchronized public void writeConLog() {
            dejc301 de301 = new dejc301();
            // 使用次数
            Map appCount = de301.getAppCount();
            // 未关次数
            Map conCount = de301.getCount();
            // 使用微秒数
            Map poolCount = de301.getPoolCount();
            // 未关明细
            Map sqlTable = dejc301c.getSQLTable();

            StringBuffer appBuf = new StringBuffer();
            int conTotal = 0;
            int sqlTotal = 0;

            for (Iterator i = appCount.keySet().iterator(); i.hasNext(); ) {
                Object appId = i.next();
                Integer aCount = (Integer) appCount.get(appId);
                Integer cCount = (Integer) conCount.get(appId);
                Long times = (Long) poolCount.get(appId);

                appBuf.append(new dejc308().getCrntTimeFmt3()).append("\t");
                appBuf.append(countNo).append("\t");
                appBuf.append(appId).append("\t");
                appBuf.append(aCount.intValue()).append("\t");
                appBuf.append(cCount.intValue()).append("\t");
                appBuf.append(times.longValue()).append("\r\n");
                conTotal += cCount.intValue();
            }

            for (Iterator i = sqlTable.keySet().iterator(); i.hasNext(); ) {
                Object conKey = i.next();

                if (sqlTable.get(conKey) != null) {
                    sqlTotal++;
                }
            }

            // 讯息
            StringBuffer logBuf = new StringBuffer();

            logBuf.append("时间\t");
            logBuf.append("顺序\t");
            logBuf.append("程式别\t");
            logBuf.append("使用次数\t");
            logBuf.append("未关次数\t");
            logBuf.append("总微秒数\r\n");

            logBuf.append(new dejc308().getCrntTimeFmt3()).append("\t");
            logBuf.append(countNo).append("\t");
            logBuf.append(SysId).append("\t");
            logBuf.append(de301.getInt()).append("\t");
            logBuf.append(conTotal).append("\t");
            logBuf.append(sqlTotal).append("\r\n");
            logBuf.append(appBuf);

            // 写档
            try {
                dejc308 de308 = new dejc308();
                runtimeStr = new dejc308().getCrntTimeFmt3() + " - Trace";

                String fileName = "waslogs/Connection/" + de308.getCrntDateWFmt1() + "/LOG/" + SysId + ".log";
                File conLog = new File(fileName);
                if (conLog.exists() == false) {
                    new File(conLog.getParent()).mkdirs();
                }

                BufferedWriter bw = new BufferedWriter(new FileWriter(fileName, true), 1024);
                bw.write(logBuf.toString());
                countNo++;
                bw.newLine();
                bw.flush();
                bw.close();
            } catch (Exception e) {
                e.printStackTrace();
                System.err.println(logBuf);
            }
        }
    }

    String computeTime(long conLong) {
        StringBuffer timeStr = new StringBuffer();
        dejc308 de308 = new dejc308(conLong);

        timeStr.append(de308.getCrntDateWFmt2());
        timeStr.append(" ").append(de308.getCrntTimeFmt3());

        long diffInSeconds = (System.currentTimeMillis() - conLong) / 1000;
        int hoursOfDiff = (int) (diffInSeconds / 3600); // 须避免 int 溢位
        int minutesOfDiff = (int) (diffInSeconds % 3600);
        int secondsOfDiff = minutesOfDiff % 60;
        minutesOfDiff = minutesOfDiff / 60;
        timeStr.append(" + ");
        timeStr.append(hoursOfDiff).append(":");
        timeStr.append(minutesOfDiff).append(":");
        timeStr.append(secondsOfDiff);

        return timeStr.toString();
    }
%>
<%
    String path = dejc332.getERPHome();

    String conTest = request.getParameter(".ConTest");
    String dpms = request.getParameter(".DPMS");
    String errorMsg = request.getParameter(".ErrorMsg");
    String conList = request.getParameter(".ConList");

    String nowTime = request.getParameter(".Current");
    String logFile = request.getParameter(".Log");
    String runLog = request.getParameter(".Run");
    String stopLog = request.getParameter(".Stop");
    String timer = request.getParameter(".Time");
    String addClass = request.getParameter(".Class");
    String printLog = request.getParameter(".Print");
    String closeCon = request.getParameter(".Close");
    String clearCon = request.getParameter(".Clear");

    String logStr = (logFile == null) ? "" : "&.Log=" + logFile;
    logStr += (runLog != null) ? "&.Run=true" : "";
    logStr += (stopLog != null) ? "&.Stop=false" : "";

    StringBuffer html = new StringBuffer();
    Runtime Memory = Runtime.getRuntime();

    if (path.equals("") || new File(path).exists() == false) {
        path = System.getProperty("user.dir");
    }

    if (nowTime == null) {
        nowTime = "" + System.currentTimeMillis();
    }

    File file = new File(path + File.separator);
    File[] files = file.listFiles();
    File fileDPMS = new File(path + File.separator + "dpms" + File.separator);
    File[] filesDPMS = fileDPMS.listFiles();

    if (conTest != null) {
        out.println("Gen Jsp: " + commondFile[0] + "<br>");
        out.println(genJsp(path, files, false, 0));
        out.println(genJsp(path, filesDPMS, true, 0));
    }

    if (errorMsg != null) {
        out.println("Gen Jsp: " + commondFile[1] + "<br>");
        out.println(genJsp(path, files, false, 1));
        out.println(genJsp(path, filesDPMS, true, 1));
    }

    if (conList != null) {
        out.println("Gen Jsp: " + commondFile[2] + "<br>");
        out.println(genJsp(path, files, false, 2));
        out.println(genJsp(path, filesDPMS, true, 2));
    }

    if (addClass != null) {
        dejc301c.addList(addClass);
    }

    boolean isPrint = (printLog != null && printLog.equals("true")) ? true : false;
    boolean isClose = (closeCon != null) ? true : false;

    dejc301 de301 = new dejc301();
    Map sqlTable = dejc301c.getSQLTable();

    StringBuffer sqlBuf = new StringBuffer();
    StringBuffer listBuf = new StringBuffer();

    int sqlTotal = 0;
    int conNo = 0;
    Map table = new TreeMap();

    for (Iterator i = sqlTable.keySet().iterator(); i.hasNext(); ) {
        Object conKey = i.next();
        dejc301q queryCon = (dejc301q) sqlTable.get(conKey);

        if (queryCon != null) {
            if (closeCon != null) {
                if (queryCon.isClosed()) {
                    i.remove();
                    continue;
                }
            }

            if (clearCon != null) {
                if (queryCon.getFinalize()) {
                    i.remove();
                    continue;
                }
            }

            boolean isCheck = (request.getParameter(conKey.toString()) != null);
            try {
                listBuf.append("  <tr class=light-bg-left>\r\n");
                if (isCheck || isPrint) {
                    listBuf.append("    <td><input type=checkbox name=").append(conKey).append(" checked></td>\r\n");

                    sqlBuf.append("  <tr class=light-bg-left>\r\n");
                    sqlBuf.append("    <td>&nbsp;").append(computeTime(queryCon.getStartTime())).append("</td>\r\n");
                    sqlBuf.append("    <td><a id=").append(conKey).append("></a><pre>&nbsp;").append(queryCon).append("</pre></td>\r\n");
                    sqlBuf.append("  </tr>\r\n");
                } else {
                    listBuf.append("    <td><input type=checkbox name=").append(conKey.toString()).append("></td>\r\n");
                }
                listBuf.append("    <td>").append(queryCon.getUserId()).append("</a></td>\r\n");
                listBuf.append("    <td>").append(queryCon.getAppId()).append("</td>\r\n");
                listBuf.append("    <td>").append(queryCon.getClassId()).append("</td>\r\n");
                listBuf.append("    <td><a href=#").append(conKey).append(">").append(queryCon.getClassMethod()).append("</a></td>\r\n");
                listBuf.append("    <td class=text-right>").append(queryCon.getCostTime()).append(" ms</td>\r\n");
                listBuf.append("  </tr>\r\n");

                sqlTotal++;
            } catch (ArrayIndexOutOfBoundsException e) {
                // 已释放
            }
        } else {
            listBuf.append("  <tr class=light-bg-left>" + conKey + "</tr>\r\n");
        }
    }

    setSleepTime(timer);

    if (logFile != null) {
        writeLog(sqlTable, sqlTotal, nowTime);
    }

    if (runLog != null) {
        isRunLog = true;
    }

    if (stopLog != null) {
        isRunLog = false;
    }

    dejc300 de300 = new dejc300();
    String conTestUrl = "/erp/jsp/dzjjcon.jsp";
    String conListUrl = "/erp/jsp/dzjj301.jsp";

    if (SysId.equals("erp") == false) {
        conTestUrl = "/erp/" + SysId.toLowerCase() + "/jsp/conTest.jsp";
        conListUrl = "/erp/" + SysId.toLowerCase() + "/jsp/conList.jsp";
    }

    dejc308 de308 = new dejc308();
    String today = de308.getMonth() + "/" + de308.getDayOfMonth() + " " + de308.getCrntTimeFmt3();

    if (isJ2EEServer == false) {
        html.append("DPMS<br>");
        for (int i = 0; filesDPMS != null && i < filesDPMS.length; i++) {
            if (filesDPMS[i].getName().length() > 2) continue;
            if (filesDPMS[i].isDirectory()) {
                html.append("<iframe src=\"/erp/" + filesDPMS[i].getName() + "/jsp/" + commondFile[2] + "?.Current=" + nowTime + logStr + "\"></iframe>");
            }
        }

        html.append("<hr>System<br>");
        for (int i = 0; files != null && i < files.length; i++) {
            if (files[i].getName().length() > 2) continue;
            if (files[i].isDirectory()) {
                html.append("<iframe src=\"/erp/" + files[i].getName() + "/jsp/" + commondFile[2] + "?.Current=" + nowTime + logStr + "\"></iframe>");
            }
        }
    }
    String serverName = System.getProperty("com.icsc.serverName", "");
    serverName = (serverName == null) ? "" : serverName;

    String sysId = request.getParameter("SysId");
    String href = (sysId == null) ? "" : "/erp/" + sysId + "/jsp/conList.jsp";
%>
<html>
<head>
    <title>Connect 监测 Ⅲ(<%= isRunLog %>)</title>
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="Content-Language" content="zh-cn">
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312">
    <link rel=stylesheet href="<%= de300.html("", "/dzwcss.gui") %>" type="text/css">
    <script language="JavaScript" src="<%= de300.script("de", "/dejtb01.jss") %>"></script>
    <script language="JavaScript" src="<%= de300.script("de", "/dejtag.jss") %>"></script>
    <script language="JavaScript" src="<%= de300.script("de", "/dejtmf25.jss")%>"></script>
</head>
<body leftmargin="0" topmargin="0" class="whole-bg">
<script language="JavaScript">
    <!--// Hide from old browsers
        // Customize default ICP menu color - bgColor, fontColor, mouseoverColor
    setDefaultICPMenuColor("#6A86CF", "#ffffff", "#FF0000");

    // Customize toolbar background color
    setToolbarBGColor("White");
    <%= genSys(path, files, false, 0) %>
    //***** Add ICP menus *****
    drawToolbar();
    //-->
</script>
<div id="dzjj301ERP">
    <form method=post actoin=/erp/jsp/dzjj301.jsp>
        <table id=DZJJ301LOG border="0" class=function-bar-left cellspacing="2" cellpadding="0" align="center"
               width=100%>
            <tr>
                <td width=10% class=subsys-title>Run Con</td>
                <td><%= sqlTotal %>
                </td>
                <td width=10% class=subsys-title>Total Con</td>
                <td><%= de301.getInt() %>
                </td>
            </tr>
            <tr>
                <td class=subsys-title>CrntTime</td>
                <td><%= today %>
                </td>
                <td class=subsys-title>Memory</td>
                <td><b><%= Memory.freeMemory() * 100 / Memory.totalMemory() %>%</b> (<%= Memory.freeMemory() %>
                    / <%= Memory.totalMemory() %>)
                </td>
            </tr>
            <!--
  <tr>
    <td class=subsys-title>Root</td>
    <td><%= path %></td>
    <td class=subsys-title>Logs</td>
    <td>
      <input type=submit value=手动 name=.Log title="waslogs/Connection/<%= de308.getCrntDateWFmt1() %>/SQL/<%= SysId + de308.getCrntTimeFmt1() %>.log">
<%
	if (isRunLog) {
		out.println("<input type=submit value=关闭(" + (sleepTime/1000) + "s.) name=.Stop> ");
		out.println(" waslogs/Connection/" + de308.getCrntDateWFmt1() + "/LOG/" + SysId + ".log");
	} else {
		out.println("<input type=submit value=定时 name=.Run>");
	}
%>
    </td>
  </tr>
<% if (isRunLog) { %>
  <tr>
    <td class=subsys-title>Status</td>
    <td nowrap><%= runtimeStr %></td>
    <td class=subsys-title>Desc</td>
    <td>写档监控执行中，每 <%= sleepTime / 1000 %> 秒监控一次，已执行 <%= countNo %> 次</td>
  </tr>
<% } %>
-->
        </table>
        <%= html %>
        <table id="DZJJ301INDEX" border="0" class=function-bar cellspacing="2" cellpadding="0" align="center"
               width=100%>
            <tr class=subsys-title>
                <th width="5%"><input type=submit value=明细 name=List></th>
                <th width="10%">使用者</th>
                <th width="10%">起始作业</th>
                <th width="10%">执行作业</th>
                <th><%= serverName %> 目前正在运行且尚未释放 Connection 的底层程式</th>
                <th width="10%">历时</th>
            </tr>
            <%= listBuf.toString() %>
        </table>
        <table id="DZJJ301LIST" border="0" class=function-bar cellspacing="2" cellpadding="0" align="center" width=100%>
            <tr class=subsys-title>
                <th>时间序号</th>
                <th>connect 明细</th>
            </tr>
            <%= sqlBuf.toString() %>
        </table>
    </form>
</div>
<div id="dzjj301APPID">
    <iframe width="100%" height="95%" src="<%= href%>" target="_blank" title="Java Doc">Java Doc</iframe>
</div>
<script language="Javascript">
    var tabObj = new TabTable();
    tabObj.add("ERP", dzjj301ERP);
    tabObj.add("AP", dzjj301APPID);
    <%= (href.equals("") == false) ? "tabObj.setDefault(dzjj301APPID);" : "" %>
    tabObj.setHeight(90);
    tabObj.draw();

    dejtb01Init("DZJJ301LIST");

</script>