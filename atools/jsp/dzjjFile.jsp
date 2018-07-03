<%-- ----------------------------------------------------*/
/* DZJJFILE	Ver $Revision: 1.3 $
/*-------------------------------------------------------*/
/* author : $Author: I20306 $
/* system : I20306 (Ò¶Óý²Ä)
/* target : File API
/* create : 2002/04/28
/* update : $Date: 2007/03/08 02:48:10 $
/*---------------------------------------------------- --%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.zip.ZipEntry" %>
<%@ page import="java.util.zip.ZipOutputStream" %>
<%!
    static String SystemRoot = dejc332.getERPHome();
    //	static String SystemName = System.getProperty("com.ibm.ejs.sm.adminServer.primaryNode", "EIP");
    static String SystemName = System.getProperty("com.icsc.serverName", "EIP");

    private File[] sort(File[] fa) {
        if (fa == null) return new File[0];
        Arrays.sort(fa);
        List dirList = new ArrayList(fa.length);
        List otherList = new ArrayList(fa.length);
        for (int i = 0; i < fa.length; i++) {
            if (fa[i].isDirectory())
                dirList.add(fa[i]);
            else
                otherList.add(fa[i]);
        }
        dirList.addAll(otherList);
        return (File[]) dirList.toArray(fa);
    }

    private String getName(File file) {
        return file.getName();
    }

    private String getType(File file) {
        if (file.isDirectory())
            return "Directory";

        String subFileName = file.toString();

        if (subFileName.endsWith(".jsp"))
            return "JSP File";
        if (subFileName.endsWith(".log"))
            return "Log File";
        if (subFileName.endsWith(".tmp"))
            return "Tmp File";
        if (subFileName.endsWith(".jar"))
            return "JAR File";
        if (subFileName.endsWith(".xml"))
            return "XML File";

        String type = getServletContext().getMimeType(file.toString());

        if (type == null) return "Unknown";
        if (type.equals("text/html")) return "HTML";
        if (type.startsWith("text/")) return "Text File";
        if (type.startsWith("image/")) return "Image File";

        return type;
    }

    private String getSize(File file) {
        if (file.isDirectory())
            return File.separator;

        long fileSize = file.length();
        return showSize(fileSize);
    }

    private String showSize(long fileSize) {
        if (fileSize > 1048576)
            return ((fileSize / 1048576) + " MB");
        if (fileSize > 1024)
            return ((fileSize / 1024) + " KB");
        return fileSize + " B ";
    }

    private String getDate(File file) {
        String pattern = "";
        Calendar now = Calendar.getInstance();
//		now.roll(Calendar.DATE, true);
        now.add(Calendar.HOUR_OF_DAY, -(Calendar.HOUR));
        java.util.Date fileDate = new java.util.Date(file.lastModified());

        if (fileDate.before(now.getTime())) {
            SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd EEEE a hh:mm:ss ");
            return formatter.format(fileDate);
        } else {
            SimpleDateFormat formatter = new SimpleDateFormat("a hh:mm:ss");
            return "<font color=red>" + formatter.format(fileDate) + "</font>";
        }
    }

    void zipFile(File in, File out) throws IOException {
        FileInputStream fin = null;
        FileOutputStream fout = null;
        ZipOutputStream gzout = null;

        try {
            dejc330.setDir(out.getParentFile());
            fin = new FileInputStream(in.toString());
            fout = new FileOutputStream(out.toString());
            gzout = new ZipOutputStream(fout);
            ZipEntry ze = new ZipEntry(in.getName());
            gzout.putNextEntry(ze);
            byte[] buf = new byte[1024];
            int num;

            while ((num = fin.read(buf)) != -1) {
                gzout.write(buf, 0, num);
            }
        } finally {
            if (gzout != null) gzout.close();
            if (fout != null) fout.close();
            if (fin != null) fin.close();
        }
    }
%>