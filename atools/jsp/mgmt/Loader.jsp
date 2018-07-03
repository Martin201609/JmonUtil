<%
String action=request.getParameter("action");
com.ibm.ws.classloader.CompoundClassLoader ccl =(com.ibm.ws.classloader.CompoundClassLoader)this.getClass().getClassLoader().getParent();
//out.println(ccl);
if ("reload".equals(action)){
  ccl.reload(true);
  out.println("ACTION: "+action+"</br>");
} else if ("addPath".equals(action)){
  String path=request.getParameter("path");
  if (path!=null) {
    String ss[]=new String[1];
    ss[0]=path;
    ccl.addPaths(ss);
  }
} else{
out.println("<pre style=word-wrap:break-word;>"+ccl+"</pre>");
}
%>