<%@ page import="java.io.*" %>
<%@ page buffer="64kb"
         language="java"
         session="true"
         autoFlush="true"
         isThreadSafe="true"
         errorPage="errorMsg.jsp"
%>
<%@ page contentType="text/xml" %>
<%!
    public static String readFile(File readMeFile) throws IOException {
        StringBuffer sb = new StringBuffer();
        BufferedReader bw = new BufferedReader(new FileReader(readMeFile));
        String tmpStr = null;
        while ((tmpStr = bw.readLine()) != null)
            sb.append(tmpStr).append("\r\n");
        bw.close();
        return sb.toString();
    }
%>
<%
    String subPath = request.getParameter("Path");
    String WorkPath = System.getProperty("user.dir");
    String filePath = WorkPath + File.separator + "waslogs";
    String path = "";

    if (subPath != null && subPath.indexOf("..") == -1) {
        path += subPath;
    }

    String select = request.getParameter("xmlFile");
    File file = new File(filePath + path + File.separator + select);
%>
<?xml version="1.0"?>
<Trace>
    <%
        if (select != null && file != null) {
            try {
                out.println(readFile(file));
            } catch (Exception e) {
                out.println("¿ªÆô[" + select + "]µµ°¸´íÎó!! " + e);
                StringWriter sw = new StringWriter();
                PrintWriter pw = new PrintWriter(sw);
                e.printStackTrace(pw);
                out.println(sw);
            }
        }
    %>
</Trace>