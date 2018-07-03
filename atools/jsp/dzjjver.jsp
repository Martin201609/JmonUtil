<%@ page import="java.io.*" %>
<%!
    static java.util.Hashtable dzLastModified = new java.util.Hashtable();
    static java.util.Hashtable dzReadFileTable = new java.util.Hashtable();

    static String dzVersionFile = Boolean.getBoolean("com.icsc.dpms.de.dejc300.j2ee") ? "help/dz/version.html" : "../../help/dz/version.html";

    public static String dzInputFile(File readMeFile) throws IOException {
        String content = "";
        InputStream in = null;
        OutputStream out = null;

        try {
            InputStream inFile = new FileInputStream(readMeFile);
            in = new BufferedInputStream(inFile);

            byte[] temp = new byte[2000];
            StringBuffer tempStringBuffer = new StringBuffer(1000);

            while (true) {
                int data = in.read(temp);
                if (data == -1)
                    break;
                tempStringBuffer.append(new String(temp, 0, data));
            }
            content = tempStringBuffer.toString();
        } finally {
            if (in != null) in.close();
        }
        return content;
    }

    public String dzReadFile(String filePath) throws IOException {
        File readMeFile = new File(filePath);
        String readFileStr = (String) dzReadFileTable.get(filePath);
        String lastModified = (String) dzLastModified.get(filePath);

        if (lastModified == null) lastModified = "0";

        if (readMeFile.exists()) {
            long timeTmp = readMeFile.lastModified();

            if (String.valueOf(timeTmp).compareTo(lastModified) > 0) {
                readFileStr = dzInputFile(readMeFile);
                dzReadFileTable.put(filePath, readFileStr);
                lastModified = String.valueOf(timeTmp);
                dzLastModified.put(filePath, lastModified);
            }
        } else {
            // new File(readMeFile.getParent()).mkdirs();
            return "";
        }
        return readFileStr;
    }
%>
<%= dzReadFile(application.getRealPath(dzVersionFile)) %>
