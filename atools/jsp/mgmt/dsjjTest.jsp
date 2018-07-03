<%@ page contentType = "text/html;charset=GBK"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.icsc.dpms.ds.*" %>
<%@ page import="com.icsc.dpms.du.*" %>
%>
<%@ include file="../../jsp/dzjjmenu.jsp" %>
<%!	static final String _AppId = "DSJJEIP"; %>
<%
dejc301 de301=new dejc301();
try {
	Connection con=de301.getConnection(_dsCom,_AppId);
	String sql="SELECT INFOID,AUTHORITYGROUP FROM DB.TBDSMF";
	ResultSet rs=con.createStatement().executeQuery(sql);
	while(rs.next()){
		String infoid=rs.getString(1);
		String auth=rs.getString(2);
		if(auth!=null && !"".equals(auth.trim())){
			dsjcagc dsAgc = new dsjcagc(_dsCom);

			try {
			
					

				long start=System.currentTimeMillis();
					boolean errCode = dsAgc.check(_dsCom, auth, "I12345");

					
					

					if (errCode == false) {
						System.out.println("ÄúÎ´«@ÊÚ™à: " + errCode);
					} else {
						System.out.println("ÄúÒÑ«@ÊÚ™à: " + errCode);
					}
					long cost =System.currentTimeMillis()-start;
					if(cost>100L){
						System.out.println("auth["+auth+"] "+errCode +" cost "+cost+" ms<br>");
					}
					
				} catch(Exception e) {
					e.printStackTrace(new PrintWriter(System.out));
				}
		}
		

		
	}
} catch (Exception e) {
	e.printStackTrace(new PrintWriter(System.out));
}finally{
	de301.close();
}
	 

%>
