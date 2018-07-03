<%@ page contentType="text/html;charset=GBK" %>
<%! final static String _AppId = "DZJJSQL";

    String[] getSQLs(File sqlFile) {
        List sqlList = new ArrayList();

        try {
            BufferedReader bw = new BufferedReader(new FileReader(sqlFile));
            String line;

            while ((line = bw.readLine()) != null) {
                line = line.trim();
                // �հ���
                if (line.length() == 0) {
                    continue;
                }
                // ע��������
                if (line.length() > 0 && line.startsWith("#")) {
                    continue;
                }

                if (line.length() > 0 && line.startsWith("-")) {
                    continue;
                }
                // ������ֵ
                sqlList.add("update db.tbdsa1 set compid='F' where member='" + line + "' and compid='A'");
                sqlList.add("update db.tbdsg1 set compid='F' where member='" + line + "' and compid='A'");
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

        for (int i = 0; i < sqlStrs.length; i++) {
            dejc301 de301 = new dejc301();
            try {
                Connection con = de301.getConnection(dsCom, _AppId);
                doSQL(con, log, sqlStrs[i]);
            } catch (SQLException sqle) {
                log.append("<Font color=red>").append(sqle.getMessage()).append("</Font>\r\n");
            } finally {
                de301.close();
                de301 = null;
            }
        }

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

            text.append(fileName + " -> <b>ִ����</b>\r\n");

            if (transaction != null) {
                text.append(doTransaction(_dsCom, fromFile));
            } else if (commit != null) {
                text.append(doCommit(_dsCom, fromFile));
            }
        }
//		fileString = "";
        _de318.logs(request.getRemoteAddr(), text.toString());
        message = "���� SQL ��ҵ���";
    }

%>
<table border="0" width="100%" cellpadding="0" cellspacing="2">
    <form name="form1" action="<%= request.getRequestURI() %>" method="post">
        <tr class=deep-bg-left>
            <td class=subsys-title width="10%">ʹ�����ʺ����ֵ�</td>
            <td colspan=3>
                <input type="hidden" name="MsgFile" value="<%= fileString %>">
                <span id="msgFileName"><%= fileString %></span>
            </td>
        </tr>
        <tr>
            <td colspan=2>
                <input type="button" value="�ϴ�..." onClick="dejt328('0', 'MsgFile', 'msgFileName', '')">
                <input type=submit name=Transaction value="Transaction">
                <input type=submit name=Commit value="Commit">
            </td>
            <td class=subsys-title width="10%">ѶϢ</td>
            <td class=msg width="40%" id=msg><%= message %>
            </td>
        </tr>
        </tr>
        <tr>
            <td colspan=4>
                <span class=msg>����ҵ���й��̽�������¼����������֮</span><br>
            </td>
        </tr>
    </form>
</table>
<pre>
<%= text %>
</pre>
</body>
</html>