<%@ page contentType="text/html;charset=GBK" %>
<%! final static String _AppId = "DZJJWORK";
    static String WorkRoot = dejc332.getTempDirectory();
    static String WorkText = "WorkPath";
%>
<%@ include file="dzjjFile.jsp" %>
<%@ include file="dzjjmain.jsp" %>
<%
    String workPath = request.getParameter(WorkText);

    if (workPath == null || workPath.indexOf("..") != -1) {
        workPath = (String) _de300.getValue(_AppId + WorkText);
        workPath = (workPath == null) ? "" : workPath;
    }

    _de300.putValue(_AppId + WorkText, workPath);

%>
<body marginwidth="0" marginheight="0" leftmargin="0" topmargin="0" class="whole-bg">
<TABLE BORDER="0" WIDTH="100%">
    <tr>
        <td colspan="8" class=sys-title height="20">Work File Lister</td>
    </tr>
    <tr>
        <td colspan="5" class=msg><font size="+2">
            <input type="button" name="Submit" value="����" onClick="location.reload()">
            <%= SystemName %>
        </font></td>
    </tr>
    <tr>
        <td colspan=5><b><a href="dzjjWork.jsp?WorkPath="><%= WorkRoot %>
        </a><%= workPath %>
        </b></b></td>
    </tr>
    <tr>
        <td class=subsys-title><b>ɾ��</b></td>
        <td class=subsys-title><b>����</b></td>
        <td class=subsys-title><b>��С</b></td>
        <td class=subsys-title><b>��̬</b></td>
        <td class=subsys-title><b>�޸�����</b></td>
    </tr>
    <%= workList(application, workPath)%>
</table>
<script src="<%= _de300.script("de", "/dejtips.jss") %>"></script>
</body>
</html>

<%!
    public String workList(ServletContext application, String subPath) {
        StringWriter sw = new StringWriter();
        PrintWriter pw = new PrintWriter(sw);
        StringBuffer total = new StringBuffer();

        try {
//			String cd = request.getServletPath();
            String filePath = SystemRoot + WorkRoot;
            String path = "";
            long totalSize = 0L;
            int totalFile = 0;
            int totalFolder = 0;

            if (subPath != null && subPath.indexOf("..") == -1) {
                path += subPath;
            }

            File file = new File(filePath + path);

            if (!file.exists()) new File(file.getParent()).mkdirs();

            File[] files = sort(file.listFiles());
            String[] colors = {"light-bg-left", "deep-bg-left"};

            for (int i = 0; i < files.length; i++) {
                pw.print("  <tr class=\"");
                pw.print(colors[i % 2]);
                pw.println("\">");
                pw.print("    <td align=center>");
                if (files[i].isDirectory() == false) {
                    pw.print("<a target=_blank href=/erp/work/" + path + getName(files[i]) + ">");
                    pw.print("<img border=0 src=/erp/images/dzwifile.gif alt='���Ҽ������µ�'>");
//					pw.print("<img src=/erp/images/dzwidel.gif>");
                }
                pw.print("</td>");
                pw.print("    <td><a href=\"");

                String fileType = files[i].toString();

                if (fileType.endsWith(".log") || fileType.endsWith(".txt")) {
                    pw.print("dzjjlog.jsp?WorkPath=");
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
                    pw.print("dzjjWork.jsp?WorkPath=");
                    pw.print(path);
                    pw.print(getName(files[i]) + "/");
                } else {
                    pw.print("dzjjlog.jsp?WorkPath=");
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
            total.append("  <td>�ܼ�</td>");
            total.append("  <td>�� " + totalFolder + " ��Ŀ¼��" + totalFile + " ������</td>");
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
 