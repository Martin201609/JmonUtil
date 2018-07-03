<%
    //com.ibm.ws.classloader.CompoundClassLoader c=(com.ibm.ws.classloader.CompoundClassLoader)this.getClass().getClassLoader();
    out.println(this.getClass().getClassLoader().getParent());
    java.io.File f = new java.io.File("WEB-INF/lib");
    java.io.File f2[] = f.listFiles();
    out.println("<br>");
    for (int i = 0; i < f2.length; i++)
        out.println(f2[i] + "<br>");
%>