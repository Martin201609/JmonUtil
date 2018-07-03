<%@ page pageEncoding="GBK" %>
<%@ page buffer="64kb"
         language="java"
         session="true"
         autoFlush="true"
         isThreadSafe="true"
         errorPage="../../jsp/dzjjerr.jsp"
%>
<%@ page import="com.icsc.dpms.de.*" %>
<%@ page import="com.icsc.dpms.di.dijc202" %>
<%@ page import="com.icsc.dpms.di.dijc309" %>
<%@ page import="com.icsc.dpms.dr.drjcdcvo" %>
<%@ page import="com.icsc.dpms.dr.drjctdc2" %>
<%@ page import="com.icsc.dpms.ds.*" %>
<%@ page import="com.icsc.dpms.du.*" %>
<%@ page import="com.icsc.dpms.dw.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page isELIgnored="true" %>
<%@ taglib uri="/WEB-INF/tld/deTagLib.tld" prefix="de" %>
<%!
    // 必要栏位符号
    static final String _Require = "<font color=Red>*</font>";

// Old method:  addICPMenu(menuId, menuDisplay, menuHelp, menuURL, target)
// Old method:  addICPSubMenu(menuId, subMenu, subMenuURL, target);
// New method:  addMenuItem(itemId, itemName, itemUrl, itemTarget) ;

    public String addICPSubMenu(String menuId, String subMenu, String subMenuURL, String target) {
        StringBuffer sb = new StringBuffer();
        sb.append("	addMenuItem(\"").append(menuId).append("\", \"").append(subMenu).append("\", \"").append(subMenuURL).append("\", \"").append(target).append("\");");
        return sb.toString();
    }

    public String addICPMenu(String menuId, String menuDisplay, String menuHelp, String menuURL, String target) {
        StringBuffer sb = new StringBuffer();
        sb.append("	addMenuItem(\"").append(menuId).append("\", \"").append(menuDisplay).append("\", \"").append(menuURL).append("\", \"").append(target).append("\");");
        return sb.toString();
    }

    public String appMenu(dsjccom _dsCom, dsjcd02 _dsD02, String tag) throws Exception {
        StringBuffer sb = new StringBuffer();
        sb.append(addICPMenu(tag + _dsD02.seq, _dsD02.desc, _dsD02.desc, "", "_self")).append("\r\n");
        dsjcd02 _dsD02s[] = _dsD02.getSeq(_dsCom);

        for (int i = 0; i < _dsD02s.length; i++) {
            if (_dsD02s[i].infoType.equalsIgnoreCase("Z")) {
                sb.append(appMenu(_dsCom, _dsD02s[i], tag + _dsD02.seq)).append("\r\n");
            } else if (_dsD02s[i].infoType.equalsIgnoreCase("H")) {
                sb.append(addICPSubMenu(tag + _dsD02.seq + _dsD02s[i].seq, _dsD02s[i].desc, _dsD02s[i].getInfoIdUrl(), "_blank")).append("\r\n");
            } else {
                sb.append(addICPSubMenu(tag + _dsD02.seq + _dsD02s[i].seq, _dsD02s[i].desc, _dsD02s[i].getInfoIdUrl(), "_self")).append("\r\n");
            }
        }
        return sb.toString();
    }

    /**
     * level:1  parent: ~,  dir : 0
     * level:2  parent: ~0,  dir : 591
     */
    public String addBookmarkMenu(Connection con, dsjccom dsCom, dejc301 de301, String root, String parent, String dir) {
        StringBuffer menu = new StringBuffer();

        String sqlPs = "SELECT FileID,FileDir,FileType, FileTitle, FileDesc, FileUrl FROM DB.TBDSPS WHERE  UserId = '" + dsCom.user.ID + "' and FILEDIR=" + dir + " order by (case when FileType = 'Z' THEN 1 when FileType = 'A' THEN 2 when FileType = 'H' THEN 3 END)";
        ResultSet rsPs = null;

        //dejc318 de318 =new dejc318(dsCom,"dzjjmenu");
        //de318.logs("addBookmarkMenu", "["+parent+","+dir+"],sql:"+sqlPs+"");

        try {
            rsPs = de301.query(con, sqlPs);


            int psi = '@';
            if (!parent.equals(root)) {
                psi = parent.charAt(parent.length() - 1);
            }
            while (rsPs.next()) {
                //psi = psi+1;

                while (true) {
                    psi++;
                    //if(psi =='\'' || psi =='\"' || psi =='(' || psi ==')'  ||( psi >= 'Z'+1 &&  psi <= 'Z'+6 ) ){
                    if (psi == '\'' || psi == '\"' || psi == '(' || psi == ')' || psi == '\\') {
                        continue;
                    }
                    break;
                }

                String fileType = rsPs.getString("FILETYPE");
                //de318.logs("addBookmarkMenu", "psi:"+(char)psi+",type:"+fileType);
                if ("Z".equals(fileType.trim())) {

                    String serNo = parent + (char) psi;
                    String fileTitle = rsPs.getString("FILETITLE") == null ? "" : rsPs.getString("FILETITLE").trim();
                    String fileDesc = rsPs.getString("FILEDESC") == null ? "" : rsPs.getString("FILEDESC").trim();
                    String infoDesc = "".equals(fileDesc) ? fileTitle : fileDesc;
                    String infoUrl = rsPs.getString("FILEURL");
                    String fileID = rsPs.getString("FILEID") == null ? "" : rsPs.getString("FILEID").trim();
                    //out.println(addICPSubMenu(serNo, infoDesc, "","_self"));
                    //de318.logs("addICPSubMenu", "DIR["+serNo+","+infoDesc+",_self]");
                    menu.append(addICPSubMenu(serNo, infoDesc, "", "_self"));
                    //de318.logs("addBookmarkMenu", "into["+serNo+","+fileID+"]");
                    menu.append(addBookmarkMenu(con, dsCom, de301, root, serNo, fileID));
                    continue;


                } else if ("A".equals(fileType.trim())) {
                    String serNo = parent + (char) psi;
                    String fileTitle = rsPs.getString("FILETITLE") == null ? "" : rsPs.getString("FILETITLE").trim();
                    String fileDesc = rsPs.getString("FILEDESC") == null ? "" : rsPs.getString("FILEDESC").trim();
                    String infoDesc = "".equals(fileDesc) ? fileTitle : fileDesc;
                    String infoUrl = rsPs.getString("FILEURL");
                    //de318.logs("addICPSubMenu", "A["+serNo+","+infoUrl+",_self]");
                    menu.append(addICPSubMenu(serNo, infoDesc, infoUrl, "_self"));
                } else {
                    String serNo = parent + (char) psi;
                    String fileTitle = rsPs.getString("FILETITLE") == null ? "" : rsPs.getString("FILETITLE").trim();
                    String fileDesc = rsPs.getString("FILEDESC") == null ? "" : rsPs.getString("FILEDESC").trim();
                    String infoDesc = "".equals(fileDesc) ? fileTitle : fileDesc;
                    String infoUrl = rsPs.getString("FILEURL");
                    //de318.logs("addICPSubMenu", "H["+serNo+","+infoDesc+","+infoUrl+",_blank]");
                    menu.append(addICPSubMenu(serNo, infoDesc, infoUrl, "_blank"));
                }


            }

        } catch (SQLException e) {
            //de318.logs(_AppId, "addBookmarkMenu.ex",e);
            new dejc318(dsCom, _AppId).logs("dzjjmenu", "addBookmarkMenu.ex", e);
        }


        return menu.toString();
    }


    // 客制化画面 Style
    String getStyleCss(dsjccom _dsCom, dsjcpcs _dsPcs, String _layoutUser) {
        String stlyeCss = "";
        try {
            if (_dsPcs.checkUserLayout(_dsCom, _layoutUser)) {
                stlyeCss = _dsPcs.getAppCss();

/*
			_isPersonal = _dsCom.user.ID.equals(_layoutUser);
			if (_isPersonal && request.getParameter(".HomeUrl") != null) {
				_dsPcs.setUserHomeUrl(request.getParameter(".HomeUrl"));
				int result = dsjcpcs.setupUserHome(_dsCom, _layoutUser, request.getParameter(".HomeUrl"));
			}
*/
            }
        } catch (Exception e) {
            dsjcstr.println(_dsCom, "Error", "[dzjjmenu] getStyleCss: " + e);
        }
        return stlyeCss;
    }
%>
<%
    // 授权监控、Session 监控
    dejc300 _de300 = new dejc300();
    // Commond Area 公用、使用率纪录
    dsjccom _dsCom = _de300.run(_AppId, this, request, response);
    // 重新登入
    if (_dsCom == null) return;

    // 网页输出编码
    _de300.setHeader();
    // Trace 公用
    dejc318 _de318 = _de300.getTrace();
    // AP 基本资料
    dsjcd01 _dsD01 = _de300.getInfoId();
    // 系统别
    String _AppSystem = _AppId.substring(0, 2).toUpperCase();
    // 程式串接公用
    dijc309 _di309 = null;

    // GUI CSS 公用
    dsjcpcs _dsPcs = new dsjcpcs();
    // 连接绪
    dejc301 _de301 = new dejc301();
    // 取得目前时间
    dejc308 _de308 = new dejc308();
    // 取得目前星期
    dejc311 _de311 = new dejc311();
    // 取得公用参数档
    dejc332 _de332 = dejc332.getConfig("DZJJMENU", "dzcfg");

    boolean isPortal = _de332.getBoolean("Portal", true);
    // 客制化 (暂时取消)
    boolean _isPersonal = false;
    String _layoutUser = (String) _de300.getValue("LayoutUser");
    // 控制 menu 显示状态
    String _menuBar = request.getParameter(".MenuBar");
    int _menuType = _de332.getInt("MainMenu.Type", 1);

    String idfParent = request.getParameter(".DSJCIDFParent");    // 资讯窗口 parent
    String idfSeq = request.getParameter(".DSJCIDFSeq");       // 资讯窗口 seq

    // 资讯窗口同步
    if (idfParent != null && idfSeq != null) {
        _de300.putValue("DSJCIDFParent", idfParent);
        _de300.putValue("DSJCIDFSeq", idfSeq);
    } else if (request.getParameter(".DSJCIDFBack") != null) {
        idfParent = (String) _de300.getValue("DSJCIDFParent");
        if (idfParent != null) {
            if (idfParent.length() > 1) {
                idfSeq = idfParent.substring(idfParent.length() - 1);
                idfParent = idfParent.substring(0, idfParent.length() - 1);
            } else {
                idfSeq = "A";
                idfParent = "@";
            }
            _de300.putValue("DSJCIDFParent", idfParent);
            _de300.putValue("DSJCIDFSeq", idfSeq);
        }
    }

    String _dzUserTitle = _dsCom.user.departmentName + "<br>" + _dsCom.user.chineseName + " " + _dsCom.user.positionName;
    if (isPortal == false) {
        dujctb01 _duTb01 = new dujctb01(_dsCom);
        _duTb01.userNo = _dsCom.user.ID;
        _duTb01 = _duTb01.iDu01(dujctb01.ALONE_KEY);

        if (_duTb01.isSuccess) {
            _dzUserTitle = _duTb01.subCompNo + "<br>" + _dsCom.user.chineseName;

            if (_duTb01.sex.equals("0")) {
                _dzUserTitle += " 女士";
            } else {
                _dzUserTitle += " 先生";
            }
        }
    }
%>
<html>
<head>
    <title><%=_AppId%>
    </title>
    <meta http-equiv="X-UA-Compatible" content="IE=5">
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="Content-Language" content="zh-cn">
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312">
    <link rel=stylesheet href="<%= _de300.html("", "/dzwcss.gui")%>" type="text/css">
    <style type="text/css">
        <!--
        <%= getStyleCss(_dsCom, _dsPcs, _layoutUser)%>
        -->
    </style>
    <script language="JavaScript" src="<%= _de300.script("de", "/dejtmf25.jss")%>"></script>
    <script language="JavaScript" src="<%= _de300.script("de", "/dejtut.jss")%>"></script>
    <script language="JavaScript" src="<%= _de300.script("de", "/dejtca.jss")%>"></script>
    <script language="JavaScript" src="<%= _de300.script("de", "/dejtcc.jss")%>"></script>
    <script language="JavaScript" src="<%= _de300.script("de", "/dejtck.jss")%>"></script>
    <script language="JavaScript" src="<%= _de300.script("de", "/dejtcl.jss")%>"></script>
    <script language="JavaScript" src="<%= _de300.script("de", "/dejtls.jss")%>"></script>
    <script language="JavaScript" src="<%= _de300.script("de", "/dejtag.jss")%>"></script>
    <script language="JavaScript" src="<%= _de300.script("de", "/dejtConfig.jss")%>"></script>
</head>
<body leftmargin="0" topmargin="0">
<div id=MenuTop>
    <table width="100%" border="0" cellspacing="0" cellpadding="0"
           background="<%= _de300.images("", "/logo/app_bg.gif") %>">
        <tbody id="MenuTitle">
        <tr>
            <td width="200" nowrap align="center"><img
                    src="<%= _de300.images("", "/logo/" + _dsCom.companyId +".gif") %>" border="0"
                    alt="<%= _dsCom.companyId %>"></td>
            <td align="center" nowrap width="1">&nbsp;</td>
            <td align="center" nowrap><font size="+2" color="<%=_dsPcs.getHeadColor()%>"><b><span
                    id="APTitle"></span></b></font></td>
            <td nowrap width="220"><a href="http://www.icsc.com.tw"><img border="0"
                                                                         src="<%= _de300.images("", "/logo/app_mark.gif") %>"
                                                                         align="right"></a>
                <%--
                      <div id="_dzLogo" class="subsys-title" style="position:absolute; z-index:1; visibility: hidden; border: 1px outset; width: 100%; height: 100%" onMouseOver="this.style.visibility = 'visible'" onMouseOut="this.style.visibility = 'hidden'">
                        <table width="100%" border="1" cellspacing="0" cellpadding="0">
                          <tr>
                            <td class=msg>主 功 能 选 单<br>
                              <a href="<%= request.getRequestURI()%>?.Return=1" style="color: white">返回前一个画面</a><br>
                              <a href="<%= _dsPcs.getUserUrl()%>" style="color: white">个人首页</a><br>
                              <a href="<%= request.getRequestURI()%>?.HomeUrl=<%= request.getRequestURI()%>" style="color: white">设此为登录后画面</a><br>
                              <a href="<%= request.getRequestURI()%>?.HomeUrl=/erp/ds/dsjsp00" style="color: white">取消还原为预设值</a><br>
                              <a href="/erp/ds/jsp/dsjjso1.jsp" style="color: white">登出系统并储存设定</a><br>
                            </td>
                          </tr>
                        </table>
                      </div> onMouseOver="_dzLogo.style.visibility = 'visible'"
                --%>
                <font size="-1" color="<%=_dsPcs.getHeadColor()%>"><%= _dzUserTitle %>
                </font>
                <input type="hidden" name="_dscom_user_ID" value="<%= _dsCom.user.ID %>">
                <input type="hidden" name="_dscom_user_chineseName" value="<%= _dsCom.user.chineseName %>">
                <input type="hidden" name="_dscom_user_department" value="<%= _dsCom.user.department %>">
                <input type="hidden" name="_dscom_user_departmentName" value="<%= _dsCom.user.departmentName %>">
                <input type="hidden" name="_dscom_user_position" value="<%= _dsCom.user.position %>">
                <input type="hidden" name="_dscom_user_positionName" value="<%= _dsCom.user.positionName %>">
            </td>
        </tr>
        </tbody>
        <tr>
            <td width="200" nowrap align="center">&nbsp;<font size="-1" color="<%=_dsPcs.getHeadColor()%>"><b><span
                    id="SYSTitle"></span></b></font></td>
            <td width="1" align="left" nowrap class="subsys-title" valign="top"><img
                    src="<%= _de300.images("", "/logo/app_tab.gif") %>"></td>
            <td class="subsys-title-left" nowrap><font size="-1"><%= _de308.getMonth()%>/<%= _de308.getDayOfMonth()%>
                <%= _de311.getChnNameOfWeekDay(_de308.getDayOfWeek())%> <%= _de308.getCrntTimeFmt2()%>
            </font>
                > <span id="MenuMsg" style="color:Yellow"></span></td>
            <th class="subsys-title-right" nowrap><a href="#" onClick="showToolBar(this)" title="隐藏标题"><img
                    src="<%= _de300.images("", "/dzwiform.gif") %>" border=0></a>
                <%= (dsjcst0.getTraceTag()) ? "<a href=\"/erp/jsp/dzjjlist.jsp\"><img src=\"" + _de300.images("", "/dzwilan.gif") + "\"  border=0 title=\"TraceLevel： " + dsjcst0.getTraceLevel() + "\"></a>" : ""%>
                <a href="#" onClick="dsjtComp()" title="切换帐套"><img border="0"
                                                                   src="<%= _de300.images("", "/dzwicard.gif") %>"></a>
                <a href="#" onClick="openChangPW()" title="修改密码"><img border="0"
                                                                      src="<%= _de300.images("", "/dzwilock.gif") %>"></a>
                <a href="/erp/ds/jsp/dsjjso1.jsp"><img border="0" src="<%= _de300.images("", "/dzwiexit.gif") %>"
                                                       alt="登出系统"></a></th>
        </tr>
    </table>
</div>
<script language='JavaScript'>
    <!--// Hide from old browsers
    var sessionId = "<%=session.getId()%>";
    var isShower = getMenuType();
    var isNewServerModel = <%= Boolean.getBoolean("com.icsc.dpms.de.dejc300.j2ee") %>

//	deChkSessionDrawFrame() ;
            // Customize default ICP menu color - bgColor, fontColor, mouseoverColor
            setDefaultICPMenuColor("<%=_dsPcs.getHeadColor()%>", "#ffffff", "#FF0000");
    // Customize toolbar background color
    setToolbarBGColor("<%=_dsPcs.getSubColor()%>");
    //***** Add ICP menus *****
    <%
        idfParent = (String) _de300.getValue("DSJCIDFParent");
        idfSeq    = (String) _de300.getValue("DSJCIDFSeq");

        try {

            Connection _con =  _de301.getConnection(_dsCom, "DZJJMENU");

            // 状态列文字
            out.println(new StringBuffer("	window.status = '").append(_dsCom.user.departmentName).append(_dsCom.user.positionName).append(_dsCom.user.chineseName).append(" (").append(_dsCom.user.ID).append(")';").toString());
            // AppId 名称
            out.println("	APTitle.innerHTML = \"" + _dsD01.desc + "\";" );
            out.println("	document.title = \"" + _dsD01.desc + "(" + _AppId + ")\";");

            // 讯息通报
            dwjc111 dw111 = new dwjc111(_dsCom, _con);
            String dwMsg = dw111.getNewMsg(_dsCom.user.ID, "Yellow");
            if ("".equalsIgnoreCase(dwMsg) == false) {
                out.println("	MenuMsg.innerHTML = \"" +  dwMsg+ "\";");
            }
            dsjcd02 _dsD02 = new dsjcd02(_con);

            //首页与个人设定选项选单
            //out.println(addICPMenu("_", "首页", "整体资讯系统入口首页", dsjcst0.getPortalUrl(request.getServerName()), "_self"));
            String portal =  _dsCom.portal==null ?dsjcst0.getPortalUrl(request.getServerName()):"".equals( _dsCom.portal)?dsjcst0.getPortalUrl(request.getServerName()):_dsCom.portal;
            out.println(addICPMenu("_", "首页", "整体资讯系统入口首页",portal , "_self"));

            if (isPortal) {
                out.println(addICPSubMenu("_0", "回到入口首页", "/erp/ds/dsjsp00", "_self"));

                if (_dsD02.get(_dsCom, "@", "@", "B")) {
                    dsjcd02 _dsD02s[] = _dsD02.getSeq(_dsCom);

                    for (int i=0; i<_dsD02s.length; i++) {
                        out.println(appMenu(_dsCom, _dsD02s[i], "_"));
                    }
                }
            }
    /*
            if (_isPersonal) {
                out.println(addICPSubMenu("_X", "设为个人首页", "?.HomeUrl=" + _dsCom.lastUrl, "_self"));
                out.println(addICPSubMenu("_Y", "取消个人首页", "?.HomeUrl=/erp/ds/dsjsp00", "_self"));
            }
    */
            // 个人常用资讯
            String dsD03Tag =  (_menuType == 1 && isPortal) ? "#" : "_F";
            out.println(addICPMenu(dsD03Tag, "常用资讯", "个人常用资讯", "", "_self"));

            dsjcd03 _dsD03s[] = new dsjcd03(_con).getTop(_dsCom, _dsCom.user.ID, 10);
            for (int i=0; i<_dsD03s.length; i++) {
                out.println(addICPSubMenu(dsD03Tag + i, _dsD03s[i].desc, _dsD03s[i].getInfoIdUrl(), "_self"));
            }



            //书签
            //out.println(addICPMenu("~", "个人书签", "个人书签", "", "_self"));
            /**  **/
            String rootSymble ="~";
            String  fileDir ="0";
            out.println(addICPMenu(rootSymble, "个人收藏夹", "个人收藏夹","", "_self"));
            out.println(addBookmarkMenu(_con,_dsCom,_de301,rootSymble,rootSymble,fileDir));
            //out.println(addBookmarkMenu(_dsCom,rootSymble,rootSymble,fileDir));


            // 资讯窗口选单
            if (isPortal == false || idfParent == null || idfParent.startsWith("AI")) {
                out.println("// 资讯窗口选单取消: " + idfParent);
            } else if (_dsD02.get(_dsCom, "@", idfParent, idfSeq)) {
    //			out.println(appMenu(_dsCom, _dsD02, "")); // 展开太多啰！
                out.println(addICPMenu("=", "<- " + _dsD02.desc, "回上层", "?.DSJCIDFBack=Back", "_self"));
                dsjcd02 _dsD02s[] = _dsD02.getSeq(_dsCom);

                for (int i=0; i<_dsD02s.length; i++) {
                    String infoType = _dsD02s[i].infoType;
                    if (infoType.equalsIgnoreCase("Z"))
                        out.println(addICPSubMenu("=" + _dsD02s[i].seq, _dsD02s[i].seq + " " + _dsD02s[i].desc + " ->", "?.DSJCIDFParent=" + _dsD02s[i].parentSeq + "&.DSJCIDFSeq=" + _dsD02s[i].seq , "_self"));
                    else if (infoType.equalsIgnoreCase("A"))
                        out.println(addICPSubMenu("=" + _dsD02s[i].seq, _dsD02s[i].seq + " " + _dsD02s[i].desc, _dsD02s[i].getInfoIdUrl(), "_self"));
                    else
                        out.println(addICPSubMenu("=" + _dsD02s[i].seq, _dsD02s[i].seq + " " + _dsD02s[i].desc, _dsD02s[i].getInfoIdUrl(), "_blank"));
                }
            }

            // 系统名称
            // 作业、子选单明细
            if (_dsD02.get(_dsCom, "@", "AI" + _AppSystem.substring(0,1), _AppSystem.substring(1))) {
                out.println("	SYSTitle.innerText = \"" + _dsD02.desc+ "\";" );
                if (_menuType == 1) {
                    out.println(appMenu(_dsCom, _dsD02, "")); // 展开太多啰！
                } else {
                    String tempTag = "0";
                    boolean tempWork = false;

                    dsjcd02 _dsD02s[] = _dsD02.getSeq(_dsCom);

                    for (int i=0; i<_dsD02s.length; i++) {
                        if (_dsD02s[i].infoType.equalsIgnoreCase("Z")) {
                            out.println(appMenu(_dsCom, _dsD02s[i], ""));
                        } else {
                            if (tempWork == false) {
                                out.println(addICPMenu(tempTag, "作业", _dsD02.desc + "作业", _dsPcs.getUserUrl(), "_self"));
                                tempWork = true;
                            }
                            out.println(addICPSubMenu(tempTag + _dsD02s[i].seq, _dsD02s[i].desc, _dsD02s[i].getInfoIdUrl(), "_self"));
                        }
                    }
                }
            }

            // 串接选单明细
            _di309 = new dijc309(_dsCom, _AppSystem, _AppId);
            Vector _rtnVector = _di309.getTransferProgram();

            out.println(addICPMenu("!", "串接程式", "程式串接选单","", "_self"));
            if (isPortal) {
                out.println(addICPSubMenu("!!", "资讯登录查询", "/erp/ds/jsp/dsjjd01.jsp?Button=INQUIRE&inqInfoId=" + _AppId, "_self"));
                out.println(addICPSubMenu("!@", "作业操作授权查询", "/erp/ds/jsp/dsjjacl.jsp?Button=INQUIRE&AuthorityId=" + _AppId, "_self"));
            }
            out.println(addICPSubMenu("!#", "返回上一个作业", _dsCom.fromUrl + "?.Return=1", "_self"));

            if (_rtnVector.size() > 0) {

              for (int i=0; i<_rtnVector.size(); i++) {
                String formTmp[][] = (String [][]) _rtnVector.elementAt(i);
                String var1 = "", var2 = "", formId= formTmp[0][1], formTitle= formTmp[0][1];
                int index = formTmp[0][1].indexOf(';');
                if (index != -1) {
                   formId = formTmp[0][1].substring(0, index);
                   formTitle = formTmp[0][1].substring(index+1);
                }
                for (int j=1; j<formTmp.length; j++) {
                  var1 += "\'" + formTmp[j][1] + "\',";
                  var2 += "\'" + formTmp[j][0] + "\',";
                }
                out.println(addICPSubMenu("!" + i, formTitle, "javascript: formTo(" + formId + ",new Array(" + var1 + "\'\'), " + formTmp[0][0] + ", new Array(" + var2 + "\'\'))", "_self"));
              }
            }

            // 辅助说明选单
            out.println(addICPMenu("$", "辅助说明", "辅助说明文件", _de300.help(_AppSystem.toLowerCase(), "/" + _AppSystem.toLowerCase() + "whelp.htm#" + _AppId), "_blank"));
            out.println(addICPSubMenu("$1", "使用者手册", _de300.help(_AppSystem.toLowerCase(), "/" + _AppSystem.toLowerCase() + "whelp.htm#" + _AppId), "_blank"));
            // 写入 Cookie
            Cookie cookie = new Cookie(_dsCom.homeUrl, _dsCom.user.ID);
            cookie.setMaxAge(-1);
            response.addCookie(cookie);
        } catch(Throwable t){
            _de318.logs("Error", "[dzjjmenu] Menu Error: " + _AppId + t);
            out.println("	<!-- Menu Error:" + t + "-->");
        } finally {
            _de301.close();
            _de301 = null;
        }
    %>
    <%= (_menuBar == null) ? "" : "isShower = " + _menuBar %>
    drawToolbar();
    showToolBar(this, true);
    //-->

    function dsjtComp() {
//	window.showModalDialog("/erp/ds/jsp/dsjjChangeAcc.jsp", null, "dialogWidth:25; dialogHeight:8; status:no; help:no");
        //event.srcElement.className = event.srcElement.className  + ' mouse-hand';
        var url = "/erp/ds/jsp/dsjjChangeAcc.jsp";
        var rtnDatas = window.open(url, 'LOGIN', 'top=0, left=0, height=150, width=380');
        rtnDatas.moveTo(screen.availWidth / 3, screen.availHeight / 3);
    }


    function openChangPW() {
//	window.showModalDialog("/erp/ds/jsp/dsjjChangeAcc.jsp", null, "dialogWidth:25; dialogHeight:8; status:no; help:no");
        //event.srcElement.className = event.srcElement.className  + ' mouse-hand';
        window.open("http://10.1.183.26:7001/buapx/DispatchAction.do?serviceName=UASYSF&efFormEname=UASYSF99&methodName=query");
    }

</script>
<!-- DI Form <%= this.getClass().getName()%> -->
<span style="position:absolute; visibility: hidden"><%= (_di309 != null) ? _di309.getTransferForm() : "<!-- No form -->" %></span>