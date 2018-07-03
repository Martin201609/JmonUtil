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
    // ��Ҫ��λ����
    static final String _Require = "<font color=Red>*</font>";

    // ���ƻ����� Style
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
    // ��Ȩ��ء�Session ���
    dejc300 _de300 = new dejc300();
    // Commond Area ���á�ʹ���ʼ�¼
    dsjccom _dsCom = _de300.run(_AppId, this, request, response);
    // ���µ���
    if (_dsCom == null) return;

    // ��ҳ�������
    _de300.setHeader();
    // Trace ����
    dejc318 _de318 = _de300.getTrace();
    // AP ��������
    dsjcd01 _dsD01 = _de300.getInfoId();
    // ϵͳ��
    String _AppSystem = _AppId.substring(0, 2).toUpperCase();

    // GUI CSS ����
    dsjcpcs _dsPcs = new dsjcpcs();
    // ������
    dejc301 _de301 = new dejc301();
    // ȡ��Ŀǰʱ��
    dejc308 _de308 = new dejc308();
    // ȡ��Ŀǰ����
    dejc311 _de311 = new dejc311();
    // ȡ�ù��ò�����
    dejc332 _de332 = dejc332.getConfig("DZJJMENU", "dzcfg");

    // ���ƻ� (��ʱȡ��)
    boolean _isPersonal = false;
    String _layoutUser = (String) _de300.getValue("LayoutUser");

    String idfParent = request.getParameter(".DSJCIDFParent");    // ��Ѷ���� parent
    String idfSeq = request.getParameter(".DSJCIDFSeq");       // ��Ѷ���� seq

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
    // ״̬������
    <%
          out.println(new StringBuffer("	window.status = '").append(_dsCom.user.departmentName).append(_dsCom.user.positionName).append(_dsCom.user.chineseName).append(" (").append(_dsCom.user.ID).append(")';").toString());
          // AppId ����
          out.println("	document.title = \"" + _dsD01.desc + "(" + _AppId + ")\";");
        try {
          // д�� Cookie
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