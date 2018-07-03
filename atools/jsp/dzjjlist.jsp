<%@ page contentType="text/html;charset=GBK" %>
<%! static String _AppId = "DZJJDOC"; %>
<%@ include file="dzjjmain.jsp" %>
<%
    String jsp = request.getParameter("JSP");
    String src = request.getParameter("Href");
    String href = (jsp == null) ? "/erp/jsp/dzjjWaslogs.jsp" : "/erp/jsp/" + jsp + ".jsp";
    href = (src == null) ? href : src;
%>
<script language="JavaScript" src="/erp/html/dzjtlist.jss"></script>
<script language="JavaScript">
    // Customize default ICP menu color - bgColor, fontColor, mouseoverColor
    setDefaultICPMenuColor("#6A86CF", "#ffffff", "#FF0000");

    // Customize toolbar background color
    setToolbarBGColor("White");

    //***** Add ICP menus *****
    drawToolbar();
    //-->
</script>
<iframe width="100%" height="90%" src="<%= href%>" target="_blank" title="Java Doc">Java Doc</iframe>