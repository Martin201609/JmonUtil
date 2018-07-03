<%@ page contentType="text/html;charset=GBK" %>
<%-- ----------------------------------------------------*/
/* DZJJSQL	Ver $Revision: 1.1 $
/*-------------------------------------------------------*/
/* author : $Author: I20306 $
/* system : I20306 (Ҷ����)
/* target : SQL ����ά����ҵ
/* create : 2002/04/28
/* update : $Date: 2007/12/18 08:37:11 $
/*---------------------------------------------------- --%>
<%! final static String _AppId = "DZJJSQL";

    String[] getSQLs(File sqlFile) {
        List sqlList = new ArrayList();

        try {
            BufferedReader bw = new BufferedReader(new FileReader(sqlFile));
            String line;
            String upperLine;

            while ((line = bw.readLine()) != null) {
                line = line.trim();
                upperLine = line.toUpperCase();
                // �հ���
                if (line.length() == 0) {
                    continue;
                }

                // ע��������
                if (line.startsWith("#")) {
                    continue;
                }

                if (line.startsWith("-")) {
                    continue;
                }

                if (upperLine.startsWith("INSERT ") == false) {
                    continue;
                }

                if (line.endsWith(";")) {
                    line = line.substring(0, line.length() - 1);
                }

                sqlList.add(new String(line));
            }
            bw.close();
        } catch (IOException ioe) {

        }

        return (String[]) sqlList.toArray(new String[sqlList.size()]);
    }

    int doSQL(Connection con, StringBuffer log, String updateSql) {
        int result = 0;
        dejc301 de301 = new dejc301();

        try {
            log.append(updateSql).append("\r\n");
            result = de301.update(con, updateSql);
            log.append(result).append(" Rows\r\n");
        } catch (SQLException sqle) {
            result = -1;
            log.append("<Font color=red>").append(sqle.getMessage()).append("</Font>\r\n");
        } finally {
            de301.close();
            de301 = null;
        }

        return result;
    }

    String doCommit(dsjccom dsCom, File sqlFile) {
        StringBuffer log = new StringBuffer();
        String sqlStrs[] = getSQLs(sqlFile);
        int errNum = 0;
        int okNum = 0;

        for (int i = 0; i < sqlStrs.length; i++) {
            dejc301 de301 = new dejc301();
            try {
                Connection con = de301.getConnection(dsCom, _AppId);
                int upNum = doSQL(con, log, sqlStrs[i]);
                if (upNum == -1) {
                    errNum++;
                } else {
                    okNum += upNum;
                }
            } catch (SQLException sqle) {
                log.append("<Font color=red>").append(sqle.getMessage()).append("</Font>\r\n");
                errNum++;
            } finally {
                de301.close();
                de301 = null;
            }
        }

        log.insert(0, "<b>Total: " + sqlStrs.length + ", Commit: " + okNum + ", Error: " + errNum + "</b>\r\n");

        return new String(log);
    }

    String doTransaction(dsjccom dsCom, File sqlFile) throws SQLException {
        StringBuffer log = new StringBuffer();
        String sqlStrs[] = getSQLs(sqlFile);

        dejc301 de301 = new dejc301();

        try {
            Connection con = de301.getConnection(dsCom, _AppId);

            for (int i = 0; i < sqlStrs.length; i++) {
                int rows = doSQL(con, log, sqlStrs[i]);

                if (rows < 0) {
                    de301.rollback();
                    break;
                }
            }
            de301.commit();
        } catch (SQLException sqle) {
            log.append("<Font color=red>").append(sqle.getMessage()).append("</Font>\r\n");
            de301.rollback();
        } finally {
            de301.close();
            de301 = null;
        }
        return new String(log);
    }
%>
<%@ include file="dzjjmain.jsp" %>
<%
    String commit = request.getParameter("Commit");
    String transaction = request.getParameter("Transaction");
    String fileString = request.getParameter("MsgFile");
    String message = "";
    StringBuffer text = new StringBuffer();

    fileString = (fileString == null) ? "" : fileString.trim();

    if (transaction == null && commit == null) {
        message = _dsD01.desc;
        text.append("");
    } else if (fileString.length() == 0) {
        message = "��ѡ���ϴ�����";
    } else {
        dejc329 de329 = new dejc329(fileString, _dsCom);
        dejc329 files[] = de329.parse();

        for (int i = 0; i < files.length; i++) {
            String fileName = files[i].getFileName();
            String fileSize = files[i].getFileSize();
            String filePath = files[i].getFilePath();
            File fromFile = files[i].getFile();

            if (fromFile.exists() == false) {
                text.append(false + "\t" + fileName + " -> �޴˵������������ϴ�\r\n");
                continue;
            }

            text.append(fileName + " -> <b>Executed</b>\r\n");

            if (transaction != null) {
                text.append(doTransaction(_dsCom, fromFile));
            } else if (commit != null) {
                text.append(doCommit(_dsCom, fromFile));
            }
        }

        _de318.logs(request.getRemoteAddr(), text.toString());

        message = "���� SQL ��ҵ���";
    }

%>
<script>
    function dzCheckFile() {
        var chFile = new checkList();
        chFile.addBlank("MsgFile");
        return chFile.check();
    }
</script>
<table border="0" width="100%" cellpadding="0" cellspacing="2" class=deep-bg-left>
    <form name="form1" action="<%= request.getRequestURI() %>" method="post">
        <tr>
            <td class=subsys-title width="10%">SQL��</td>
            <td colspan=3>
                <input type="hidden" name="MsgFile" value="<%= fileString %>">
                <span id="msgFileName"><%= fileString %></span>
            </td>
        </tr>
        <tr>
            <td colspan=2>
                <input type="button" value="�ϴ�..." onClick="dejt328('0', 'MsgFile', 'msgFileName', '')">
                <input type=submit name=Transaction value="Transaction" onClick="return dzCheckFile()">
                <input type=submit name=Commit value="Commit" onClick="return dzCheckFile()">
            </td>
            <td class=subsys-title width="10%">ѶϢ</td>
            <td class=msg width="40%" id=msg><%= message %>
            </td>
        </tr>
        </tr>
        <tr>
            <td colspan=4 class=light-bg-left>
                <span class=msg>����ҵ���й��̽����� log ��¼����������֮</span><br>
                <B>˵����</B> ��#���롰-����Ϊע����ţ�һ��һ�� SQL ָ��ɶ��У����ṩ <B>INSERT</B> ָ��ʹ�á�<br>
                <B>Transaction:</B> ���� SQL ָ��ɹ��� commit. <B>Commit:</B> ÿһ�� SQL ָ�� commit һ��<br>
            </td>
        </tr>
    </form>
</table>
<hr>
<pre>
<%= text %>
</pre>
</body>
</html>