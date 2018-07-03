<%@ page contentType="text/html" language="java" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.TimeZone" %>
<%@ page import="java.util.Calendar" %>

<%
  Date date=new Date();
  DateFormat format=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
  String time=format.format(date);
  //System.out.println(time);
  out.println("Current OS Date:" + time +"<br>");
%>
<%
        DateFormat nowFormat = new SimpleDateFormat();
        DateFormat cstFormat = new SimpleDateFormat();
        DateFormat gmtFormat = new SimpleDateFormat();

        TimeZone nowTime = TimeZone.getTimeZone("GMT+8:00");
        TimeZone gmtTime = TimeZone.getTimeZone("GMT");
        TimeZone cstTime = TimeZone.getTimeZone("CST");
        cstFormat.setTimeZone(gmtTime);
        gmtFormat.setTimeZone(cstTime);
        nowFormat.setTimeZone(nowTime);
        out.println("NOW Time: "+ nowFormat.format(date) + "<br>");
        out.println("GMT Time: " + cstFormat.format(date) + "<br>");
        out.println("CST Time: " + gmtFormat.format(date) + "<br>");
%>

<%
        Calendar cal = Calendar.getInstance();
        TimeZone timeZone = cal.getTimeZone();
        out.println(timeZone.getID());
        out.println(timeZone.getDisplayName());
%>
