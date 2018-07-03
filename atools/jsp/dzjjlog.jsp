<%@ page contentType="text/html;charset=GBK" %>
<%! final static String _AppId = "DZJJLOG";
    static String LogRoot = "waslogs/";
    static String LogText = "LogPath";
    static String ConfigRoot = dejc332.getConfigDirectory();
    static String ConfigText = "INIPath";
    static String WorkRoot = dejc332.getTempDirectory();
    static String WorkText = "WorkPath";

    public static String readFile(File readMeFile) throws IOException {
        if (readMeFile.length() > 1048576) {
            return "<a href='/erp/" + readMeFile.getPath() + "'>档案过大请按右键另存目录下载！</a>";
        }

        String content = "";
        InputStream in = null;
        OutputStream out = null;

        try {
            InputStream inFile = new FileInputStream(readMeFile);
            in = new BufferedInputStream(inFile);

            byte[] temp = new byte[2000];
            StringBuffer tempStringBuffer = new StringBuffer(1000);

            while (true) {
                int data = in.read(temp);
                if (data == -1)
                    break;
                tempStringBuffer.append(new String(temp, 0, data));
            }
            content = tempStringBuffer.toString();
            in.close();
        } finally {
            if (in != null)
                in.close();
        }
        return content;
    }

    public static String readFile1(File readMeFile) throws IOException {
        if (readMeFile.length() > 1048576) {
            return "<a href='/erp/" + readMeFile.getPath() + "'>档案过大请按右键另存目录下载！</a>";
        }
        StringBuffer sb = new StringBuffer();
        BufferedReader bw = new BufferedReader(new FileReader(readMeFile));
        String tmpStr = null;
        while ((tmpStr = bw.readLine()) != null)
            sb.append(tmpStr).append("\r\n");
        bw.close();
        return sb.toString();
    }
%>
<%@ include file="dzjjFile.jsp" %>
<%@ include file="dzjjmain.jsp" %>
<%
    String name = "";
    String subPath = null;
    String filePath = "";
    String path = "";

    String iniPath = request.getParameter(ConfigText);
    String logPath = request.getParameter(LogText);
    String workPath = request.getParameter(WorkText);

    if (iniPath == null || iniPath.indexOf("..") != -1) {
        iniPath = (String) _de300.getValue(_AppId + ConfigText);
        iniPath = (iniPath == null) ? "" : iniPath;
    } else {
        name = ConfigText;
        subPath = iniPath;
        filePath = ConfigRoot;
        path += subPath;
    }

    if (logPath == null || logPath.indexOf("..") != -1) {
        logPath = (String) _de300.getValue(_AppId + LogText);
        logPath = (logPath == null) ? "" : logPath;
    } else {
        name = LogText;
        subPath = logPath;
        filePath = LogRoot;
        path += subPath;
    }

    if (workPath == null || workPath.indexOf("..") != -1) {
        workPath = (String) _de300.getValue(_AppId + WorkText);
        workPath = (workPath == null) ? "" : workPath;
    } else {
        name = WorkText;
        subPath = workPath;
        filePath = WorkRoot;
        path += subPath;
    }

    _de300.putValue(_AppId + ConfigText, iniPath);
    _de300.putValue(_AppId + LogText, logPath);
    _de300.putValue(_AppId + WorkText, workPath);

    String select = request.getParameter("logFile");

    File file = new File(filePath + path);
    File[] files = file.listFiles();
    File selectFile = null;
%>
<body marginwidth="0" marginheight="0" leftmargin="0" topmargin="0" class="whole-bg">
<table width="100%" border="0" cellspacing="2" cellpadding="0" height="100%">
    <tr>
        <td colspan="8" class=sys-title height="20">Trace Log File Viewer</td>
    </tr>
    <tr class=function-bar-left>
        <form name="form1" method="post" action="dzjjlog.jsp">
            <td height="20" width="10%" class=subsys-title nowrap>清
                单
            </td>
            <td height="20" nowrap>
                <%= path %>
                <select name="logFile" onChange="form1.submit()">
                    <option>请选择</option>
                    <%
                        for (int i = 0; files != null && i < files.length; i++) {
                            if (files[i].isDirectory())
                                continue;
                            if (files[i].toString().endsWith(".jsp"))
                                continue;
                            if (files[i].getName().equals(select))
                                selectFile = files[i];
                            out.println("<option value=" + files[i].getName() + ">" + files[i].getName() + " (" + getSize(files[i]) + ")</option>");
                        }
                    %>
                </select>
                <a href="dzjjWaslogs.jsp"><img border=0 src=/erp/images/dzwirun.gif></a>
            </td>
            <% if (selectFile != null) { %>
            <td height="20" width="10%" class=subsys-title nowrap>档 案</td>
            <td height="20" width="10%" nowrap><%= select%>
            </td>
            <td height="20" width="10%" class=subsys-title nowrap>大 小</td>
            <td height="20" width="10%" nowrap><%= getSize(selectFile) %>
            </td>
            <td height="20" width="10%" class=subsys-title nowrap>修 改 时 间</td>
            <td height="20" nowrap><%= getDate(selectFile)%>
            </td>
            <% } %>
            <% if (subPath != null) { %>
            <input type="hidden" value="<%= path %>" name="<%= name %>">
            <% } %>
        </form>
    </tr>
    <tr valign="top" align="left">
        <td colspan="8" height="100%">
            <div id="Layer1"
                 style="position:absolute; border:2px outset; width:100%; height:100%; z-index:1; overflow: auto">
                <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
                    <tr>
                        <td>
              <pre>
<%
    try {
        if (select != null && selectFile != null) {
            out.flush();
            out.println(readFile(selectFile));
        }
    } catch (Exception e) {
        out.println("开启[" + select + "]档案错误!! " + e);
        StringWriter sw = new StringWriter();
        PrintWriter pw = new PrintWriter(sw);
        e.printStackTrace(pw);
        out.println(sw);
    }
%>
                </pre>
                        </td>
                    </tr>
                </table>
            </div>
        </td>
    </tr>
</table>
</body>
</html>