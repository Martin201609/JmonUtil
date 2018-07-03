<%@ page buffer="64kb"
         language="java"
         session="true"
         autoFlush="true"
         isThreadSafe="true"
         errorPage="dzjjerr.jsp"
         contentType="text/html"
%>
<%@ page import="com.icsc.dpms.de.dejc300" %>
<%@ page import="com.icsc.dpms.ds.dsjcst0" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.io.StringWriter" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.*" %>
<%
    response.setContentType("text/html;charset=" + dsjcst0.getLanguage());
    dejc300 _de300 = new dejc300();
    String subPath = request.getParameter(".Delete");

    if (subPath == null || subPath.indexOf("..") != -1) {
        subPath = "";
    }
%>
<HTML> <!-- ************* SortIndex.jsp **************** -->
<HEAD>
    <TITLE><%= request.getServerName() %> Log 目录清单</TITLE>
    <STYLE>
        TH, TD {
            font-size: 16px
        }
    </STYLE>
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="Content-Language" content="zh-tw">
    <meta http-equiv="Content-Type" content="text/html; charset=GBK">
    <link rel=stylesheet href="<%= _de300.html("", "/dzwcss.gui") %>" type="text/css">
</HEAD>
<body marginwidth="0" marginheight="0" leftmargin="0" topmargin="0" class="whole-bg">
<TABLE BORDER="0" WIDTH="100%">
    <tr>
        <td colspan="8" class=sys-title height="20">DEJC301c File Lister</td>
    </tr>
    <tr>
        <td colspan="4" class=msg><font size="+2">
            <input type="button" name="Submit" value="更新" onClick="location.reload()">
            <a href="dzjjwork.jsp"><%= System.getProperty("com.ibm.ejs.sm.adminServer.primaryNode", "EIP")%>
                /work/<%= subPath %>/DEJC301c.tmp</a>
        </font></td>
    </tr>
    <tr>
        <td class=subsys-title><b>档名</b></td>
        <td class=subsys-title><b>大小</b></td>
        <td class=subsys-title><b>型态</b></td>
        <td class=subsys-title><b>修改日期</b></td>
    </tr>
    <tr>
        <td colspan="4">
            <hr>
        </td>
    </tr>
    <%= fileList(application, subPath)%>
</table>
</body>
</html>

<%!
    public String fileList(ServletContext application, String subPath) {
        StringWriter sw = new StringWriter();
        PrintWriter pw = new PrintWriter(sw);
        String WorkPath = System.getProperty("user.dir");
        try {
//    String cd = request.getServletPath();
            String filePath = WorkPath + File.separator + "work";
            String tmpFilePath = WorkPath + File.separator + "work" + File.separator + subPath + File.separator + "DEJC301c.tmp";
            String path = "";

            if (subPath != null && subPath.indexOf("..") == -1) {
                path += subPath;
            }

            File file = new File(filePath);
            File tmpFile = new File(tmpFilePath);

            if (!file.exists()) new File(file.getParent()).mkdirs();

            if (tmpFile.exists()) {
                pw.print("<tr><td colspan=4> Delete " + tmpFile + " -> " + tmpFile.delete() + "</td></tr>");
            }
            File[] files = sort(file.listFiles());
            String[] colors = {"light-bg-left", "deep-bg-left"};

            for (int i = 0; i < files.length; i++) {

                if (files[i].isDirectory()) {
                    File de301c = new File(filePath + File.separator + getName(files[i]) + File.separator + "DEJC301c.tmp");
                    if (de301c.exists()) {
                        pw.print("  <tr class=\"");
                        pw.print(colors[i % 2]);
                        pw.println("\">");
                        pw.print("    <td>");
                        pw.print("<a href='?.Delete=" + getName(files[i]) + "'><b>");
                        pw.print(getName(files[i]) + File.separator + getName(de301c));
                        pw.println("</b></a></td>");
                        pw.print("    <td align=\"right\" title=\"");
                        pw.print(de301c.length() + "");
                        pw.print(" bytes\">");
                        pw.print(getSize(de301c));
                        pw.println(" </td>");
                        pw.print("    <td align=\"center\"> ");
                        pw.print(getType(de301c));
                        pw.println(" </td>");
                        pw.print("    <td>");
                        pw.print(getDate(de301c));
                        pw.println(" </td>");
                        pw.println("  </tr>");
                    }
                }
            }

        } catch (Exception e) {
            pw.print("  <tr><td colspan=4>");
            e.printStackTrace(pw);
            pw.println("</td></tr>");
        }
        return sw.toString();
    }

    private File[] sort(File[] fa) {
        Arrays.sort(fa);
        List dirList = new ArrayList(fa.length);
        List otherList = new ArrayList(fa.length);
        for (int i = 0; i < fa.length; i++) {
            if (fa[i].isDirectory())
                dirList.add(fa[i]);
            else
                otherList.add(fa[i]);
        }
        dirList.addAll(otherList);
        return (File[]) dirList.toArray(fa);
    }

    private String getName(File file) {
        return file.getName();
    }

    private String getType(File file) {
        if (file.isDirectory())
            return "Directory";

        String subFileName = file.toString();

        if (subFileName.endsWith(".jsp"))
            return "JSP File";
        if (subFileName.endsWith(".log"))
            return "Log File";
        if (subFileName.endsWith(".tmp"))
            return "Tmp File";
        if (subFileName.endsWith(".jar"))
            return "JAR File";
        if (subFileName.endsWith(".xml"))
            return "XML File";

        String type = getServletContext().getMimeType(file.toString());

        if (type == null) return "Unknown";
        if (type.equals("text/html")) return "HTML";
        if (type.startsWith("text/")) return "Text File";
        if (type.startsWith("image/")) return "Image File";

        return type;
    }

    private String getSize(File file) {
        if (file.isDirectory())
            return File.separator;

        long fileSize = file.length();
        if (fileSize > 1048576)
            return ((fileSize / 1048576) + " MB");
        if (fileSize > 1024)
            return ((fileSize / 1024) + " KB");
        return fileSize + " B ";
    }

    private String getDate(File file) {
        String pattern = "";
        Calendar now = Calendar.getInstance();
//  now.roll(Calendar.DATE, true);
        now.add(Calendar.HOUR_OF_DAY, -(Calendar.HOUR));
        Date fileDate = new Date(file.lastModified());

        if (fileDate.before(now.getTime())) {
            SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd EEEE a hh:mm:ss ");
            return formatter.format(fileDate);
        } else {
            SimpleDateFormat formatter = new SimpleDateFormat("a hh:mm:ss");
            return "<font color=red>" + formatter.format(fileDate) + "</font>";
        }
    }
%>
 