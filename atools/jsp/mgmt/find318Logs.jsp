<%@ page contentType = "text/html;charset=GBK"%>
<%@ page import="org.apache.commons.httpclient.*,
  org.apache.commons.httpclient.methods.*,
  org.apache.commons.httpclient.params.HttpMethodParams,
  java.io.IOException"
%>
<%!
    public String myGET(String myurl) {
      HttpClient client = new HttpClient();
      client.getHttpConnectionManager().getParams().setConnectionTimeout(3000);
      GetMethod method = new GetMethod(myurl);
      method.getParams().setParameter(HttpMethodParams.RETRY_HANDLER, new DefaultHttpMethodRetryHandler(3, false));
      try {
        // Execute the method.
        int statusCode = client.executeMethod(method);

        if (statusCode != HttpStatus.SC_OK) {
          System.err.println("Method failed: " + method.getStatusLine());
        }

        // Read the response body.
        byte[] responseBody = method.getResponseBody();

        // Deal with the response.
        // Use caution: ensure correct character encoding and is not binary data
        return new String(responseBody);

      } catch (HttpException e) {
        System.err.println("Fatal protocol violation: " + e.getMessage());
        e.printStackTrace();
      } catch (IOException e) {
        System.err.println("Fatal transport error: " + e.getMessage());
        e.printStackTrace();
      } finally {
        // Release the connection.
        method.releaseConnection();
      }
      return "";
    }
%>
<!DOCTYPE html>
<html>
<head>
<style>
h2{
 line-height:0.7em;
}
th, td {
vertical-align: top;
border: 1px solid black;
}
table
{
border: 1px solid black;
border-collapse:collapse;
width:100%;
}
div{
font-size: 14pt;
text-align: center;
font-weight: bold;
}
.bgwarn
{
background-color:pink;
font-weight:bold;
}
.bgerror
{
background-color:red
}
div{
font-size: 14pt;
text-align: center;
font-weight: bold;
}
</style>
</head>
<body>
<%
  String url2="erp/de/jsp/dejj318Test2.jsp";
  String[] urlList ={
  "http://10.1.198.171:9081/",
  "http://10.1.198.171:9082/",
  "http://10.1.198.171:9083/",
  "http://10.1.198.171:9084/",
  "http://10.1.198.172:9081/",
  "http://10.1.198.172:9082/",
  "http://10.1.198.172:9083/",
  "http://10.1.198.172:9084/",
  "http://10.1.198.173:9081/",
  "http://10.1.198.173:9082/",
  "http://10.1.198.173:9083/",
  "http://10.1.198.173:9084/",
  "http://10.1.198.174:9081/",
  "http://10.1.198.174:9082/",
  "http://10.1.198.174:9083/",
  "http://10.1.198.174:9084/",
  "http://10.1.198.181:9081/",
  "http://10.1.198.181:9082/",
  "http://10.1.198.181:9083/",
  "http://10.1.198.181:9084/",
  "http://10.1.198.182:9081/",
  "http://10.1.198.182:9082/",
  "http://10.1.198.182:9083/",
  "http://10.1.198.182:9084/"
  };
  for(int i=0;i<urlList.length;i++){
    if (i==0) out.println("<table><tr>");
    else if (i%2==0) out.println("</td><tr>");
    else if (i%2==1) out.println("</td>");
    String t=myGET(urlList[i]+url2);
    out.println("<td width=50%");
    if (t.equals("")) out.println(" class=bgerror");
    out.println(">");
    out.println(t);
  }
%>
</td></tr></table>
</body></html>
