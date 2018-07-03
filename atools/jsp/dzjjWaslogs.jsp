<%@ page contentType="text/html;charset=GBK" %>
<%-- ----------------------------------------------------*/
/* DZJJWASLOGS	Ver $Revision: 1.2 $
/*-------------------------------------------------------*/
/* author : $Author: I20306 $
/* system : I20306 (叶育材)
/* target : Trace Log File Lister
/* create : 2002/04/28
/* update : $Date: 2007/03/08 02:48:10 $
/*---------------------------------------------------- --%>
<%! final static String _AppId = "DZJJLOG";
    static String LogRoot = "waslogs/";
    static String LogText = "LogPath";
%>
<%@ include file="dzjjFile.jsp" %>
<%@ include file="dzjjmain.jsp" %>
<%
    String logPath = request.getParameter(LogText);

    if (logPath == null || logPath.indexOf("..") != -1) {
        logPath = (String) _de300.getValue(_AppId + LogText);
        logPath = (logPath == null) ? "" : logPath;
    }

    _de300.putValue(_AppId + LogText, logPath);
%>
<body marginwidth="0" marginheight="0" leftmargin="0" topmargin="0" class="whole-bg">
<TABLE BORDER="0" WIDTH="100%">
    <tr>
        <td colspan="8" class=sys-title height="20">Trace Log File Lister</td>
    </tr>
    <tr>
        <td colspan="4" class=msg><font size="+2">
            <input type="button" name="Submit" value="更新" onClick="location.reload()">
            <%= SystemName %>
        </font> (如档案过大请点选 <img border=0 src=/erp/images/dzwifile.gif alt='压缩此档案后下载'> 下载压缩档)
        </td>
        <td>
            <a name=dzZipTag></a>
            <iframe name="dzjjZip" id="dzjjZip" width="100%" height="23" frameborder=0 src=dzjjZip.jsp></iframe>
            <form name="form1" method="post" target="dzjjZip"></form>
        </td>
    </tr>
    <tr>
        <td colspan=5><b><a href="dzjjWaslogs.jsp?LogPath="><%= LogRoot %>
        </a><%= logPath %>
        </b></td>
    </tr>
    <tr>
        <td class=subsys-title><b>下载</b></td>
        <td class=subsys-title><b>档名</b></td>
        <td class=subsys-title><b>大小</b></td>
        <td class=subsys-title><b>型态</b></td>
        <td class=subsys-title><b>修改日期</b></td>
    </tr>
    <%= logList(application, logPath)%>
</table>
<script src="<%= _de300.script("de", "/dejtips.jss") %>"></script>
<script>
    function dzZip(url) {
        form1.action = "dzjjZip.jsp?fl=" + url;
        form1.submit();
    }
</script>
</body>
</html>

<%!
    public String logList(ServletContext application, String subPath) {
        StringWriter sw = new StringWriter();
        PrintWriter pw = new PrintWriter(sw);
        StringBuffer total = new StringBuffer();

        try {
            String filePath = SystemRoot + LogRoot;
            String path = "";

            if (subPath != null && subPath.indexOf("..") == -1) {
                path += subPath;
            }

            File file = new File(filePath + path);

            if (!file.exists()) new File(file.getParent()).mkdirs();

            File[] files = sort(file.listFiles());
            String[] colors = {"light-bg-left", "deep-bg-left"};
            long totalSize = 0L;
            int totalFile = 0;
            int totalFolder = 0;


            for (int i = 0; i < files.length; i++) {
                pw.print("  <tr class=\"");
                pw.print(colors[i % 2]);
                pw.println("\">");
                pw.print("    <td align=center>");
                if (files[i].isDirectory() == false) {
//                    pw.print("<a target=_blank href=/erp/waslogs/" + path + getName(files[i]) + ">");
                    pw.print("<a href='#dzZipTag' onClick=\"dzZip('" + path + getName(files[i]) + "')\">");
                    pw.print("<img border=0 src=/erp/images/dzwifile.gif alt='压缩此档案后下载'>");
                }
                pw.print("</td>");
                pw.print("    <td><a href=\"");
                String fileType = files[i].toString();

                if (fileType.endsWith(".log") || fileType.endsWith(".txt")) {
                    pw.print("dzjjlog.jsp?LogPath=");
                    pw.print(path);
                    pw.print("&logFile=");
                    pw.print(getName(files[i]));
                } else if (fileType.endsWith(".xml")) {
                    pw.print("dzjjxml.jsp?Path=");
                    pw.print(path);
                    pw.println("&xmlFile=");
                    pw.print(getName(files[i]));
                    pw.print("\" target=\"_blank");
                } else if (files[i].isDirectory()) {
                    pw.print("dzjjWaslogs.jsp?LogPath=");
                    pw.print(path);
                    pw.print(getName(files[i]) + "/");
                } else {
                    pw.print("dzjjlog.jsp?LogPath=");
                    pw.print(path);
                    pw.print("&logFile=");
                    pw.print(getName(files[i]));
                }

                pw.print("\"><b>");
                pw.print(getName(files[i]));
                totalSize += files[i].length();
                if (files[i].isDirectory()) {
                    pw.print("/");
                    totalFile++;
                } else {
                    totalFolder++;
                }
                pw.println("</b></a></td>");
                pw.print("    <td align=\"right\" deTips=\"");
                pw.print(files[i].length() + "");
                pw.print(" bytes\">");
                pw.print(getSize(files[i]));
                pw.println(" </td>");
                pw.print("    <td align=\"center\"> ");
                pw.print(getType(files[i]));
                pw.println(" </td>");
                pw.print("    <td>");
                pw.print(getDate(files[i]));
                pw.println(" </td>");
                pw.println("  </tr>");
            }
            total.append("<tr class=subsys-title-left>");
            total.append("  <td>总计</td>");
            total.append("  <td>共 " + totalFolder + " 个目录，" + totalFile + " 个档案</td>");
            total.append("  <td colspan=5 deTips='" + totalSize + " bytes'>" + showSize(totalSize) + "</td>");
            total.append("</tr>");
        } catch (Exception e) {
            pw.print("  <tr><td colspan=4>");
            e.printStackTrace(pw);
            pw.println("</td></tr>");
        }
        return total.toString() + sw.toString();
    }
%>
 