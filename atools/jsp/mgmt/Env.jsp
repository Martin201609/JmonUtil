<table style="border:1px solid black" border CELLSPACING="0" CELLPADDING="0">
<%
	java.util.Properties p=System.getProperties();
	java.util.Enumeration names=p.propertyNames();
	while (names.hasMoreElements()){
		String s=names.nextElement().toString();
		out.println("<tr><td>"+s+"</td><td>"+p.getProperty(s)+"</td></tr>");
	}
%>
</table>