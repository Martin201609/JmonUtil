<%@ page pageEncoding="GBK" %>
<%@ page buffer="64kb"
         language="java"
         session="true"
         autoFlush="true"
         isThreadSafe="true"
         errorPage="../../jsp/dzjjerr.jsp"
%>
<%@ page import="com.icsc.dpms.de.*" %>
<%@ page import="com.icsc.dpms.dr.drjcUtil" %>
<%@ page import="com.icsc.dpms.dr.drjcdcvo" %>
<%@ page import="com.icsc.dpms.ds.*" %>
<%@ page import="com.icsc.dpms.du.*" %>
<%@ page import="com.icsc.dpms.dw.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page isELIgnored="true" %>
<%@ taglib uri="/WEB-INF/tld/deTagLib.tld" prefix="de" %>
<%!
    // 必要栏位符号
    static final String _Require = "<font color=Red>*</font>";

    // 客制化画面 Style
    String getStyleCss(dsjccom _dsCom, dsjcpcs _dsPcs, String _layoutUser) {
        String stlyeCss = "";

        try {
            if (_dsPcs.checkUserLayout(_dsCom, _layoutUser)) {
                stlyeCss = _dsPcs.getAppCss();

/*
				_isPersonal = _dsCom.user.ID.equals(_layoutUser);
				if(_isPersonal && request.getParameter(".HomeUrl") != null) {
					_dsPcs.setUserHomeUrl(request.getParameter(".HomeUrl"));
					int result = dsjcpcs.setupUserHome(_dsCom, _layoutUser, request.getParameter(".HomeUrl"));
				}
*/
            }
        } catch (Exception e) {
            dsjcstr.println(_dsCom, "Error", "[dzjjmain] getStyleCss: " + e);
        }
        return stlyeCss;
    }
%>
<%
    // 授权监控、Session 监控
    dejc300 _de300 = new dejc300();
    // Commond Area 公用、使用率纪录
    dsjccom _dsCom = _de300.run(_AppId, this, request, response);
    // 重新登入
    if (_dsCom == null) return;

    // 网页输出编码
    _de300.setHeader();
    // Trace 公用
    dejc318 _de318 = _de300.getTrace();
    // AP 基本资料
    dsjcd01 _dsD01 = _de300.getInfoId();
    // 系统别
    String _AppSystem = _AppId.substring(0, 2).toUpperCase();

    // GUI CSS 公用
    dsjcpcs _dsPcs = new dsjcpcs();
    // 连接绪
    dejc301 _de301 = new dejc301();
    // 取得目前时间
    dejc308 _de308 = new dejc308();
    // 取得目前星期
    dejc311 _de311 = new dejc311();
    // 取得公用参数档
    dejc332 _de332 = dejc332.getConfig("DZJJMENU", "dzcfg");

    // 客制化 (暂时取消)
    boolean _isPersonal = false;
    String _layoutUser = (String) _de300.getValue("LayoutUser");

    String idfParent = request.getParameter(".DSJCIDFParent");    // 资讯窗口 parent
    String idfSeq = request.getParameter(".DSJCIDFSeq");       // 资讯窗口 seq

    idfParent = (String) _de300.getValue("DSJCIDFParent");
    idfSeq = (String) _de300.getValue("DSJCIDFSeq");
%>
<html>
<head>
    <title><%=_AppId%>
    </title>
    <meta http-equiv="X-UA-Compatible" content="IE=5">
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="Content-Language" content="zh-cn">
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312">
    <link rel=stylesheet href="<%= _de300.html("", "/dzwcss.gui")%>" type="text/css">
    <style type="text/css">
        <!--
        <%= getStyleCss(_dsCom, _dsPcs, _layoutUser)%>
        -->
    </style>
    <script language="JavaScript" src="<%= _de300.script("de", "/dejtmf25.jss")%>"></script>
    <script language="JavaScript" src="<%= _de300.script("de", "/dejtut.jss")%>"></script>
    <script language="JavaScript" src="<%= _de300.script("de", "/dejtca.jss")%>"></script>
    <script language="JavaScript" src="<%= _de300.script("de", "/dejtcc.jss")%>"></script>
    <script language="JavaScript" src="<%= _de300.script("de", "/dejtcl.jss")%>"></script>
    <script language="JavaScript" src="<%= _de300.script("de", "/dejtls.jss")%>"></script>
    <script language="JavaScript" src="<%= _de300.script("de", "/dejtag.jss")%>"></script>
    <script language="JavaScript" src="<%= _de300.script("de", "/dejtConfig.jss")%>"></script>
</head>
<body leftmargin="0" topmargin="0">
<input type="hidden" name="_dscom_user_ID" value="<%= _dsCom.user.ID %>">
<input type="hidden" name="_dscom_user_chineseName" value="<%= _dsCom.user.chineseName %>">
<input type="hidden" name="_dscom_user_department" value="<%= _dsCom.user.department %>">
<input type="hidden" name="_dscom_user_departmentName" value="<%= _dsCom.user.departmentName %>">
<input type="hidden" name="_dscom_user_position" value="<%= _dsCom.user.position %>">
<input type="hidden" name="_dscom_user_positionName" value="<%= _dsCom.user.positionName %>">
<script language='JavaScript'>
    <!--// Hide from old browsers
    var sessionId = "<%=session.getId()%>";
    var isNewServerModel =
    <%= Boolean.getBoolean("com.icsc.dpms.de.dejc300.j2ee") %>
    // 状态列文字
    <%
          out.println(new StringBuffer("	window.status = '").append(_dsCom.user.departmentName).append(_dsCom.user.positionName).append(_dsCom.user.chineseName).append(" (").append(_dsCom.user.ID).append(")';").toString());
          // AppId 名称
          out.println("	document.title = \"" + _dsD01.desc + "(" + _AppId + ")\";");
        try {
          // 写入 Cookie
          Cookie cookie = new Cookie(_dsCom.homeUrl, _dsCom.user.ID);
          cookie.setMaxAge(-1);
          response.addCookie(cookie);
        } catch(Throwable t){
          _de318.logs("Error", "[dzjjmain] Menu Error: " + _AppId + t);
          out.println("	<!-- Main Error:" + t + "-->");
        } finally {
          _de301.close();
          _de301 = null;
        }
    %>
    //-->
</script>