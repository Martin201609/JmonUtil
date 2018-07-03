<%@ page contentType="text/html;charset=GBK" %>
<%-- ----------------------------------------------------*/
/* DZJJWARN	Ver $Revision: 1.3 $
/*-------------------------------------------------------*/
/* author : $Author: I20306 $
/* system : I20306 (Ҷ����)
/* target : ��ʾ�Ӵ�
/* create : 2002/04/28
/* update : $Date: 2007/03/08 02:48:10 $
/*---------------------------------------------------- --%>
<%@ page buffer="64kb"
         language="java"
         session="true"
         autoFlush="true"
         isThreadSafe="true"
         errorPage="dzjjerr.jsp"
%>
<%@ page import="com.icsc.dpms.de.dejc300" %>
<%@ page import="com.icsc.dpms.ds.*" %>
<%@ page import="com.icsc.dpms.du.dujc001" %>
<%@ page import="java.net.URLEncoder" %>
<%!
    static final String Login = "���ѳ���ʹ��ʱЧ��û�кϷ���¼�� �����µ���";
    static final String Script = "relogin('/erp/ds/jsp/dsjjsn2.jsp')";

    String getHtmlMeta() {
        String charset = dsjcst0.getLanguage();

        StringBuffer meta = new StringBuffer();
        meta.append("<meta http-equiv=pragma content=no-cache>\r\n");
        meta.append("<meta http-equiv=expires content=0>\r\n");
        meta.append("<meta http-equiv=cache-control content=no-cache>\r\n");
        meta.append("<meta http-equiv=Content-Language content=zh-tw>\r\n");
        meta.append("<meta http-equiv=Content-Type content=\"text/html; charset=").append(charset).append("\">\r\n");
        return meta.toString();
    }

    String relogin(dejc300 de300, String title, String button, String onClick, String javaScript) {
        StringBuffer sb = new StringBuffer();

        sb.append("<html>\r\n");
        sb.append(getHtmlMeta());
        sb.append("<title>").append(title).append("</title>\r\n");
        sb.append("<link rel=stylesheet href=").append(de300.html("", "/dzwcss.gui")).append(" type=text/css>\r\n");
        sb.append("<script language=JavaScript src=").append(de300.script("de", "/dejtmf.jss")).append("></script>\r\n");
        sb.append("<script language=JavaScript src=").append(de300.script("de", "/dejtls.jss")).append("></script>\r\n");
        sb.append("<body class=whole-bg>\r\n");
        sb.append("<div id=divWin align=center style='position:absolute;width:94%'> \r\n");
        sb.append("  <table width=100% border=1 cellspacing=0 cellpadding=0 align=center bordercolor=#446d8c>\r\n");
        sb.append("    <tr class=subsys-title> \r\n");
        sb.append("      <td nowrap bgcolor=#446d8c><img src=").append(de300.images("", "/dzwistop.gif")).append(" align=left>");
        sb.append(button).append("</td>\r\n");
        sb.append("    </tr>\r\n");
        sb.append("    <tr class=deep-bg> \r\n");
        sb.append("      <td nowrap> \r\n");
        sb.append("        <table width=80% border=0 cellspacing=2 cellpadding=0>\r\n");
        sb.append("          <tr> \r\n");
        sb.append("            <td class=subsys-title>" + "Ѷ Ϣ" + "</td>\r\n");
        sb.append("            <td class=msg nowrap id=MenuMsg>").append(title).append("</td>\r\n");
        sb.append("          </tr>\r\n");
        sb.append("        </table>\r\n");
        sb.append("        <br>\r\n");
        sb.append("        <input type=button onClick=\"").append(onClick).append("\" value=\"").append(button).append("\" name=button>\r\n");
        sb.append("      </td>\r\n");
        sb.append("    </tr>\r\n");
        sb.append("  </table>\r\n");
        sb.append("</div>\r\n");
        sb.append("<script>\r\n");
        sb.append("  divWin.style.top = (document.body.clientHeight - divWin.offsetHeight) / 2;\r\n");
        sb.append("  divWin.style.left = (document.body.clientWidth - divWin.offsetWidth) / 2;\r\n");
        sb.append("  ").append(javaScript).append(";\r\n");
        sb.append("</script>\r\n");
        sb.append("</html>");

        return sb.toString();
    }
%>
<%
    dsjccom _dsCom = (dsjccom) session.getValue("dsjccom");    // commond area ����
    dsjcpcs _dsPcs = new dsjcpcs();                            // GUI CSS ����
    boolean isExist = false;
    String message = "����ó�ʽӵ��������ʹ��Ȩ�ޣ�";
    dejc300 _de300 = new dejc300();

    try {
        if (_dsCom == null) {
            out.println(relogin(_de300, Login, "���µ���", Script, Script));
            return;
        }
    } catch (Exception e) {
        System.out.println("[dzjjwarn] Error: " + e);
    }

    dsjcd01 _dsD01 = new dsjcd01();

    String appId = request.getParameter("AppId");
    String state = request.getParameter("State");
    int level = 3;

    try {
        level = Integer.parseInt(state);
    } catch (NumberFormatException nfe) {
        level = 3;
    }

    String errCode = "*";
    _dsD01.owner = "ICSC01";

    if (appId == null) {
        message = "���κ�ѶϢ";
    } else if (level == 0) {
        message = "��Ѷ���벻��Ϊ�հײ��ұ�����ϱ�׼����";
        _dsD01.infoId = appId;
    } else if (level == 1) {
        message = "��Ѷ��������д�ִ�����";
        _dsD01.infoId = appId;
    } else if (level == -1) {
        message = "���Ͽ��ȡ" + appId + "��������";
        _dsD01.infoId = appId;
    } else if (level == 2 || level == 3 || level == 4) {
        _dsD01.infoId = appId;
        isExist = _dsD01.get(_dsCom);

        if (_dsD01.getErrCode() == -1) {
            level = -1;
            message = "���Ͽ��ȡ��������: " + _dsD01.getMessage();
        } else if (isExist == false) {
            level = 2;
            message = "�ó�ʽδ��¼��ϵͳ�ϣ�����ʹ��֮Ȩ�ޣ���";
        } else if (level == 4) {
            String url = request.getParameter("URL");
            message = "δ���ȡ��λַ: /erp" + url;
        } else {
            message = "δ����Ȩʹ�ø���Ѷ����";
        }
    }
%>
<html><title>�����Ӵ�</title>
<link rel=stylesheet href="<%=_dsCom.homeUrl%>/html/dzwcss.gui" type="text/css">
<script language="JavaScript" src="<%= _de300.html("de", "/dejtls.jss") %>"></script>
<style type="text/css">
    <!--
    <%
      // ���ƻ����� Style
        _dsPcs.checkUserLayout(_dsCom, _dsCom.user.ID);
        String styleColor = _dsPcs.getAppCss();
        out.println(styleColor);
    %>
    -->
</style>
<body>
<div id=divWin align="center" style="position:absolute; width: 94%">
    <table width="600" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td colspan="3"><img src="/erp/images/dz/warning_top.gif"></td>
        </tr>
        <tr>
            <td width="6" background="/erp/images/dz/center_bg_l.gif">&nbsp;</td>
            <td width="580" valign="top">
                <table width="100%" border="0" cellpadding="3" cellspacing="5"
                       background="/erp/images/dz/warning_bg.gif">
                    <tr>
                        <td width="18%" bgcolor="#E8E8E8">
                            <div align="center">Ѷ����Ϣ<br>
                            </div>
                        </td>
                        <td width="82%"><font color="#990000"><strong><span id=msg><%= message%></span></strong></font>
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#E8E8E8">
                            <div align="center">��Ѷ����</div>
                        </td>
                        <td id=InfoId><a href="/erp/ds/jsp/dsjjd01.jsp?inqInfoId=<%=_dsD01.infoId%>"><%=_dsD01.infoId%>
                        </a></td>
                    </tr>
                    <tr>
                        <td height="16" bgcolor="#E8E8E8">
                            <div align="center">��Ѷ˵��</div>
                        </td>
                        <td id=InfoDesc><a href="<%=_dsD01.getInfoIdUrl()%>"><%=_dsD01.desc%>
                        </td>
                    </tr>
                    <tr>
                        <td height="16" bgcolor="#E8E8E8">
                            <div align="center">������Ȩ</div>
                        </td>
                        <td id=AuthorityName title='<%= _dsD01.authorityGroup %>'><a
                                href="/erp/ds/jsp/dsjjagc.jsp?Button=INQUIRE&AuthorityId=<%= _dsD01.authorityGroup %>"><%= _dsD01.authorityGroup %> <%= dsjcagc.getAuthorityGroup(_dsCom, _dsD01.authorityGroup) %>
                        </td>
                    </tr>
                    <tr>
                        <td height="16" bgcolor="#E8E8E8">
                            <div align="center">ӵ �� ��</div>
                        </td>
                        <td nowrap><%= dujc001.getName(_dsCom, _dsD01.owner) %>
                        </td>
                    </tr>
                    <tr>
                        <td colspan=2 align=center>
                            <% if (level == -1) { %>
                            <input type=button onClick="window.close()" value="�ر�">
                            <% } else if (level == 3) { %>
                            <input type=button onClick="dzRegister(0)" value="����">
                            <input type=button onClick="dzBack()" value="����">
                            <% } else if (level == 4) { %>
                            <input type=button onClick="dzBack()" value="����">
                            <% } else { %>
                            <input type=button onClick="dzRegister(1)" value="ע��">
                            <input type=button onClick="dzBack()" value="����">
                            <% } %>
                        </td>
                    </tr>
                </table>
            </td>
            <td width="22" background="/erp/images/dz/center_bg_r.gif">&nbsp;</td>
        </tr>
        <tr>
            <td height="12" colspan="3"><img src="/erp/images/dz/down.gif"></td>
        </tr>
    </table>
    <table width="100%" border="1" cellspacing="0" cellpadding="0" align="center" bordercolor="#446d8c">
        <tr class=deep-bg>
        </tr>
    </table>
</div>
    <% String msgTitle = "���롰" + _dsD01.desc + "��ʹ��Ȩ��";
   String msgContent = "�����Ա: " + _dsCom.user.ID + "\t" + _dsCom.user.chineseName + "\r\n" +
	                   "��Ѷ����: " + _dsD01.infoId + "\t" + _dsD01.desc + "\r\n" +
				       "������Ȩ: " + _dsD01.authorityGroup + "\t" + dsjcagc.getAuthorityGroup(_dsCom, _dsD01.authorityGroup) + "\r\n" +
				       "����˵��: ";
   msgTitle = URLEncoder.encode(msgTitle);
   msgContent = URLEncoder.encode(msgContent);
%>
<script>
    divWin.style.top = (document.body.clientHeight - divWin.offsetHeight) / 2;
    divWin.style.left = (document.body.clientWidth - divWin.offsetWidth) / 2;

    var isDzBack = false;

    function dzRegister(tag) {
        var title = '<%=msgTitle%>';
        var content = '<%=msgContent%>';
        if (tag == 0)
            dsjtagc_Msg('<%=_dsD01.owner%>', '<%=_dsCom.user.ID%>', '<%=_dsD01.authorityGroup%>', title, content);
        else if (tag == 1)
            location.href = "/erp/ds/jsp/dsjjd01.jsp?inqInfoId=<%= appId %>";
    }

    function dzBack() {
        if (isDzBack) {
            window.close();
        } else if (history.length > 0) {
            history.go(-1);
        } else {
            window.close();
        }
        isDzBack = true;
    }
</script>
</html>