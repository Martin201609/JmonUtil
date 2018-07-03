<%@ page contentType="text/html;charset=GBK" %>
<%-- ----------------------------------------------------*/
/* DZJJERR	Ver $Revision: 1.1 $
/*-------------------------------------------------------*/
/* author : $Author: I20306 $
/* system : I20306 (叶育材)
/* target : 错误讯息画面
/* create : 2000/11/24
/* update : $Date: 2007/03/08 02:48:48 $
/*---------------------------------------------------- --%>
<%!
    static boolean isJ2EEServer = Boolean.getBoolean("com.icsc.dpms.de.dejc300.j2ee");
%>
<%
    try {
        Class.forName("com.ibm.websphere.servlet.error.ServletErrorReport");

        if (isJ2EEServer) {
            pageContext.include("/jsp/dzjjerrIBMn.jsp");
        } else {
            pageContext.include("/jsp/dzjjerrIBMo.jsp");
        }
    } catch (ClassNotFoundException cnfe) {
        pageContext.include("/jsp/dzjjerror.jsp");
    }
%>
