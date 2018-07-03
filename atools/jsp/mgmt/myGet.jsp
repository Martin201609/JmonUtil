<%@ page contentType = "text/html;charset=GBK"%>
<%@ page import="org.apache.commons.httpclient.*,
  org.apache.commons.httpclient.methods.*,
  org.apache.commons.httpclient.params.HttpMethodParams,
  org.apache.commons.io.IOUtils,
  java.io.*,org.json.*"
%>
<%!
  java.util.Hashtable myInstancess=new java.util.Hashtable();
  java.util.Hashtable myPages=new java.util.Hashtable();
  {
    try{
      InputStream is = new FileInputStream( "html/dn/mgmt.json");
      String jsonTxt = IOUtils.toString( is );
      JSONArray json = new JSONObject(jsonTxt).getJSONArray("data");
      System.out.println(json);
      for (int i=0;i<json.length();i++){
        myInstancess.put(json.getJSONArray(i).get(0),json.getJSONArray(i).get(1));
      }
      json = new JSONObject(jsonTxt).getJSONArray("func");
      for (int i=0;i<json.length();i++){
        myPages.put(json.get(i),json.get(i));
      }
    } catch (Exception e) {
      System.err.println("myGet JSON init error: " + e.getMessage());
    }
  }
  public String myGET(String myurl) {
    HttpClient client = new HttpClient();
    client.getHttpConnectionManager().getParams().setConnectionTimeout(3000);
    GetMethod method = new GetMethod(myurl);
    method.getParams().setParameter(HttpMethodParams.RETRY_HANDLER, new DefaultHttpMethodRetryHandler(3, false));
    try {
      // Execute the method.
      int statusCode = client.executeMethod(method);

      String status="";
      if (statusCode != HttpStatus.SC_OK) {
        System.err.println("Method failed: " + method.getStatusLine());
        status=statusCode+"<br>";
      }

      // Read the response body.
      byte[] responseBody = method.getResponseBody();

      // Deal with the response.
      // Use caution: ensure correct character encoding and is not binary data
      return status+new String(responseBody);

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
<%
  String myPage=request.getParameter("page");
  String myInstance=request.getParameter("instance");
  if (myPage==null || myInstance==null){
    out.println("Usage: ?page=MYPAGE&instance=INSTANCE");
    return;
  }
  Object myURL=myInstancess.get(myInstance);
  if (myURL==null){
    out.println("Available instance: "+myInstancess);
    return;
  }
  if (!myPages.contains(myPage)){
    out.println("Available pages: "+myPages);
    return;
  }
  String url2="http://"+myURL+"/erp/jsp/mgmt/"+myPage+".jsp";
  String t=myGET(url2);
  if (t.equals("")) response.setStatus(503);
  if (t.startsWith("404")) response.setStatus(404);
  out.println(t);
%>
