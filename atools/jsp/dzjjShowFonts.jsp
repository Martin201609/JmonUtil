<%@ page pageEncoding="GBK" %>
<%@ page contentType="image/jpeg" %>
<%@ page import="javax.imageio.ImageIO" %>
<%@ page import="java.awt.*" %>
<%@ page import="java.awt.image.BufferedImage" %>
<%
    GraphicsEnvironment ge = GraphicsEnvironment.getLocalGraphicsEnvironment();
    String font[] = ge.getAvailableFontFamilyNames();
    BufferedImage img = new BufferedImage(500, font.length * 20 + 50, BufferedImage.TYPE_INT_RGB);
    Graphics g = img.getGraphics();
    g.drawString("Font         Chinese          English", 20, 10);

    for (int i = 0; i < font.length; i++) {
        Font f = new Font(font[i], 16, 16);
        System.out.println("FONT: " + f.getName());
        g.setFont(f.deriveFont(0));
        g.drawString(font[i] + "    [中文字型展示]    [aBcXyZ-1234]", 20, i * 20 + 30);
    }

    ImageIO.write(img, "JPEG", response.getOutputStream());
    response.getOutputStream().flush();
%>