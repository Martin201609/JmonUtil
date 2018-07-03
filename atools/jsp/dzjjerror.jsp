<%@ page pageEncoding="Cp950" %>
<%-- ----------------------------------------------------*/
/* DZJJERR	Ver $Revision: 1.3 $
/*-------------------------------------------------------*/
/* author : $Author: I22369 $
/* system : I20306 (葉育材)
/* target : 錯誤訊息畫面 J2EE
/* create : 2000/11/24
/* update : $Date: 2009/01/13 09:53:23 $
/*---------------------------------------------------- --%>
<%@ page buffer="64kb"
         language="java"
         session="true"
         autoFlush="true"
         isThreadSafe="true"
         isErrorPage="true"
%>
<%@ page import="com.icsc.dpms.de.dejc300" %>
<%@ page import="com.icsc.dpms.de.dejc332" %>
<%@ page import="com.icsc.dpms.ds.dsjccom" %>
<%@ page import="com.icsc.dpms.ds.dsjcst0" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.io.StringWriter" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%!
    private String throwableToString(Throwable t) {
        StringWriter sw = new StringWriter();
        PrintWriter w = new PrintWriter(sw);

        if (t != null) {
            t.printStackTrace(w);
        }

        return sw.toString();
    }

    private String dateFormat() {
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd EEEE a hh:mm:ss ");
        return formatter.format(new java.util.Date());
    }
%>
<%
    String serverName = System.getProperty("com.icsc.serverName", "");
    ServletException errReport = (ServletException) request.getAttribute("ErrorReport");
    response.setContentType("text/html;charset=" + dsjcst0.getLanguage());
    dsjccom dsCom = (dsjccom) session.getValue("dsjccom");
    if (dsCom == null) dsCom = new dsjccom();
    dejc300 de300 = new dejc300();

    String sysUser = "";
    String sysEmail = "";
    String informBtnValue = "";
    try {
        dejc332 de332 = dejc332.getConfig("DZJJERR", "dzcfg");
        sysUser = de332.getProperty("SysUser", "ICSC01");
        sysEmail = de332.getProperty("SysEmail", "");
        //錯誤通報按鈕的value
        informBtnValue = de332.getProperty("informBtnValue", "將錯誤通報資訊人員");
    } catch (Exception e) {

    }
%>
<html>
<head>
    <title><%= serverName %> 錯誤訊息</title>
    <meta http-equiv="pragma" content="no-cache"/>
    <meta http-equiv="expires" content="0"/>
    <meta http-equiv="cache-control" content="no-cache"/>
    <meta http-equiv="Content-Language" content="zh-tw">
    <meta http-equiv="Content-Type" content="text/html; charset=big5">
    <link rel=stylesheet href="<%= de300.html("", "/dzwcss.gui") %>" type="text/css">
    <script language="JavaScript" src="<%= de300.script("de", "/dejtls.jss") %>"></script>
    <script>
        var traceOpen = false;
        function trace() {
            traceOpen = !traceOpen;
            if (traceOpen) {
                Layer1.style.visibility = 'visible';
                trace.height = '100%';
            } else {
                Layer1.style.visibility = 'hidden';
                trace.height = '0px';
            }
        }

        function contentMsg(obj) {
            obj.value = "Time: <%= dateFormat() %>\r\n" +
                    "Serv: <%= request.getServerName() %> <%= serverName %> \r\n" +
                    "User: <%= dsCom.user.ID%> <%= dsCom.user.chineseName %> \r\n" +
                    "ApID: <%= dsCom.appId %> <%= request.getRequestURI()%>?<%=request.getQueryString() %> \r\n" +
                    "Desc: " + Layer1.innerText;
        }
    </script>
</head>
<body>
<%
    if (exception == null && errReport == null) { %>
<table width="100%" border="1" cellspacing="0" cellpadding="0" class="msg">
    <tr>
        <td align="center"><b><%= serverName %> 無任何錯誤可報告</b></td>
    </tr>
</table>
<%
        return;
    }

    String name = "";
    String local = "";
    String message = "";
    String stackTrace = "";

    String nameR = "";
    String localR = "";
    int code = 0;
    String messageR = "";
    String stackTraceR = "";

    if (exception != null) {
        name = exception.getMessage();
        local = exception.getLocalizedMessage();
        message = exception.toString();
        stackTrace = throwableToString(exception);
        exception.printStackTrace();
    }

    if (errReport != null) {
        nameR = errReport.getMessage();
        localR = errReport.getLocalizedMessage();
        messageR = errReport.toString();
        stackTraceR = throwableToString(errReport);
    }

%>
<table width="600" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr>
        <td colspan="3">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" background="/erp/images/dz/error_top_bg.gif">
                <tr>
                    <td width="28%"><img src="/erp/images/dz/error_top.gif"></td>
                    <td width="69%"><strong><font color="#FFFFFF"><%= serverName %> <%= code %>
                    </font></strong></td>
                    <td width="3%">
                        <div align="right"><img src="/erp/images/dz/error_top_r.gif"></div>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td width="6" background="/erp/images/dz/center_bg_l.gif">&nbsp;</td>
        <td width="572" valign="top">
            <table width="100%" border="0" cellpadding="3" cellspacing="5" background="/erp/images/dz/error_bg.gif">
                <tr>
                    <form name=form1 method="post"
                          action="mailTo:<%= sysEmail %>?subject=[DZJJERR] <%= dsjcst0.getCompanyId() %>(<%= request.getServerName() %>) Exception Report: <%= message %>"
                          onSubmit="contentMsg(this.Body)" enctype="text/plain">
                        <td height=25>　　
                            <input type=submit value="寄信">
                            <input type=hidden name="Error" value="[<%= request.getServerName() %>]<%= message %>">
                            <input type=hidden name="Body" value="">
                        </td>
                    </form>
                    <form method="post" action="/erp/dw/jsp/dwjj0091.jsp" target="_blank"
                          onSubmit="contentMsg(this.content)">
                        <td>
                            <input type=submit value="<%=informBtnValue%>">
                            <input type=hidden name="toUser" value="<%= sysUser %>">
                            <input type=hidden name="title" value="Error Report: <%= message %>">
                            <input type=hidden name="content" value="">
                            <input type=hidden name="programUrl"
                                   value="http://<%= request.getServerName() + request.getRequestURI()%>">
                        </td>
                    </form>
                </tr>
                <tr>
                    <td width="18%" bgcolor="#E8E8E8">
                        <div align="center">物件訊息<br>
                        </div>
                    </td>
                    <td width="82%"><font color="#990000"><%= name %>
                    </font></td>
                </tr>
                <tr>
                    <td bgcolor="#E8E8E8">
                        <div align="center">本地訊息</div>
                    </td>
                    <td><font color="#990000"><%= local %>
                    </font></td>
                </tr>
                <tr>
                    <td height="16" bgcolor="#E8E8E8">
                        <div align="center">錯誤訊息</div>
                    </td>
                    <td><font color="#333333"><a href="javascript:trace()"><%= message %>
                    </a></font></td>
                </tr>
                <% if (errReport != null) { %>
                <tr>
                    <td width="18%" bgcolor="#E8E8E8">
                        <div align="center">物件訊息<br>
                        </div>
                    </td>
                    <td width="82%"><font color="#990000"><%= nameR %>
                    </font></td>
                </tr>
                <tr>
                    <td bgcolor="#E8E8E8">
                        <div align="center">本地訊息</div>
                    </td>
                    <td><font color="#990000"><%= localR %>
                    </font></td>
                </tr>
                <tr>
                    <td height="16" bgcolor="#E8E8E8">
                        <div align="center">錯誤訊息</div>
                    </td>
                    <td><font color="#333333"><a href="javascript:trace()"><%= messageR %>
                    </a></font></td>
                </tr>
                <% } %>
            </table>
        </td>
        <td width="22" background="/erp/images/dz/center_bg_r.gif">&nbsp;</td>
    </tr>
    <tr>
        <td colspan="3"><img src="/erp/images/dz/down.gif"></td>
    </tr>
</table>
<div class=msg id="Layer1"
     style="position:absolute; z-index:1; overflow: auto; width: 100%; border: 0px outset; visibility: hidden; height: 100%">
    <table width="600" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td colspan="3">
                <table width="100%" border="0" cellpadding="0" cellspacing="0"
                       background="/erp/images/dz/error_top_bg.gif">
                    <tr>
                        <td width="28%"><img src="/erp/images/dz/error_top.gif"></td>
                        <td width="69%"><strong><font color="#FFFFFF"><%= code %>
                        </font></strong></td>
                        <td width="3%">
                            <div align="right"><img src="/erp/images/dz/error_top_r.gif"></div>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td width="6" background="/erp/images/dz/center_bg_l.gif">&nbsp;</td>
            <td width="572" valign="top"><textarea style="border: 0px; width: 572; height: 100%;"
                                                   wrap=OFF><%= stackTrace %></textarea></td>
            <td width="22" background="/erp/images/dz/center_bg_r.gif">&nbsp;</td>
        </tr>
        <tr>
            <td colspan="3"><img src="/erp/images/dz/down.gif"></td>
        </tr>
    </table>
</div>
</body>
</html>