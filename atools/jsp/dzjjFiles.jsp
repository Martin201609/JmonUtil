<%@ page contentType="text/html;charset=GBK" %>
<%! final static String _AppId = "DZJJWORK"; %>
<%@ include file="dzjjmain.jsp" %>
<%
    String button = request.getParameter("Button");
    String fileString = request.getParameter("MsgFile");
    String message = "";
    StringBuffer text = new StringBuffer();

    fileString = (fileString == null) ? "" : fileString.trim();

    String path = request.getParameter("FilePath");
    String isAdmin = request.getParameter("isAdmin") == null ? "" : request.getParameter("isAdmin");

    if (path == null || path.indexOf("..") != -1) {
        path = "";
    }
    String WorkPath = System.getProperty("user.dir");
    String rootPath = WorkPath + File.separator;

    File file = new File(rootPath + path);

    if (button == null) {
        message = "手动维护作业";
        text.append("");
    } else if (fileString.length() == 0) {
        message = "请选择上传档案";
    } else if (file.exists() == false && "Y".equals(isAdmin)) {
        file.mkdirs();
        dejc329 de329 = new dejc329(fileString, _dsCom);
        dejc329 files[] = de329.parse();

        for (int i = 0; i < files.length; i++) {
            String fileName = files[i].getFileName();
            String fileSize = files[i].getFileSize();
            String filePath = files[i].getFilePath();
            File fromFile = files[i].getFile();
            if (fromFile.exists() == false) {
                text.append(false + "\t" + fileName + " -> 无此档案，请重新上传\r\n");
                continue;
            }
            File toFile = new File(path + fileName);
            boolean result = dejc330.moveFile(fromFile, toFile);
            text.append(result + "\t" + fileName + " -> " + toFile.getPath() + "\r\n");
        }
        fileString = "";
        _de300.getTrace().logs("dzjjFiles", text.toString());
        message = "手动维护档案完成";
    } else if (file.isDirectory() == false || path.startsWith("/") || path.endsWith("/") == false) {
        message = "请输入相对目录并以“/”结尾";
    } else if (file.exists() == false) {
        message = "请输入已存在之相对目录";
    } else {
        dejc329 de329 = new dejc329(fileString, _dsCom);
        dejc329 files[] = de329.parse();

        for (int i = 0; i < files.length; i++) {
            String fileName = files[i].getFileName();
            String fileSize = files[i].getFileSize();
            String filePath = files[i].getFilePath();
            File fromFile = files[i].getFile();
            if (fromFile.exists() == false) {
                text.append(false + "\t" + fileName + " -> 无此档案，请重新上传\r\n");
                continue;
            }
            File toFile = new File(path + fileName);
            boolean result = dejc330.moveFile(fromFile, toFile);
            text.append(result + "\t" + fileName + " -> " + toFile.getPath() + "\r\n");
        }
        fileString = "";
        _de300.getTrace().logs("dzjjFiles", text.toString());
        message = "手动维护档案完成";
    }

%>
<form name="form1" action="<%= request.getRequestURI() %>" method="post">
    <table border="0" width="100%" cellpadding="0" cellspacing="2">
        <tr class=deep-bg-left>
            <td class=subsys-title width="10%">路径</td>
            <td colspan=3><%= rootPath.replace(File.separatorChar, '/') %>
                <input type=text name=FilePath size=10 value="<%= path %>">
                <input type="hidden" name="MsgFile" value="<%= fileString %>">
                <input type="hidden" name="isAdmin" value="<%= isAdmin %>">
                <span id="msgFileName"><%= fileString %></span>
            </td>
        </tr>
        <tr>
            <td colspan=2>
                <input type=submit name=Button value="复制">
                <input type="button" value="上传..." onClick="dejt328('0', 'MsgFile', 'msgFileName', '')">
                <span class=msg>此作业所有过程将会做纪录，请勿擅用之</span>
            </td>
            <td class=subsys-title width="10%">路径</td>
            <td class=msg width="40%" id=msg><%= message %>
            </td>
        <tr>
    </table>
</form>
<pre>
<%= text %>
</pre>
</body>
</html>