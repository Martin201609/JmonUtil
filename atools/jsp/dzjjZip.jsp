<%@ page contentType="text/html;charset=GBK" %>
<%-- ----------------------------------------------------*/
/* DZJJZIP	Ver $Revision: 1.1 $
/*-------------------------------------------------------*/
/* author : $Author: I20306 $
/* system : I20306 (叶育材)
/* target : Trace Log Zip File
/* create : 2002/04/28
/* update : $Date: 2006/10/19 03:50:27 $
/*---------------------------------------------------- --%>
<%! final static String _AppId = "DZJJLOG";%>
<%@ page import="java.util.zip.ZipEntry" %>
<%@ page import="java.util.zip.ZipOutputStream" %>
<%@ include file="dzjjmain.jsp" %>
<%@ include file="dzjjFile.jsp" %>
<%!
    void zipFn(File in, File out) {
        try {
            dejc330.setDir(out.getParentFile());
            FileInputStream fin = new FileInputStream(in.toString());
            FileOutputStream fout = new FileOutputStream(out.toString());
            ZipOutputStream gzout = new ZipOutputStream(fout);
            ZipEntry ze = new ZipEntry(in.getName());
            gzout.putNextEntry(ze);
            byte[] buf = new byte[1024];
            int num;

            while ((num = fin.read(buf)) != -1) {
                gzout.write(buf, 0, num);
            }

            gzout.close();
            fout.close();
            fin.close();
        } catch (Throwable e) {
            System.err.println("err...err !!");
            e.printStackTrace();
        }
    }
%>
<body marginwidth="0" marginheight="0" leftmargin="0" topmargin="0" class="whole-bg">
<%
    String fl = request.getParameter("fl");
    if (fl == null) return;
    String home = System.getProperty("user.dir");
    File in = new File(home + "/waslogs/" + fl.trim());
    File ot = new File(home + "/public/de/" + _dsCom.user.ID + "/" + in.getName() + ".zip");
    zipFn(in, ot);
%>
<a id=dl href="/erp/public/de/<%=_dsCom.user.ID%>/<%=ot.getName()%>"> 压缩 <%= in.getName() %>(<%= getSize(ot) %>)
    完成，按此下载!</a>
</body>
</html>
<script>
    document.getElementById("dl").click();
</script>