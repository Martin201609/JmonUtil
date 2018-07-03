<!-- version : $Revision: 1.4 $ $Date: 2015/10/30 10:08:32 $ -->
<%@ page contentType="text/html;charset=GBK" %>
<%@ page import="com.icsc.dpms.dd.msg.ddjcComMsg" %>
<%@ page import="com.icsc.dpms.de.structs.dejcWebInfoOut" %>
<%@ page import="com.icsc.dpms.de.web.dejcQryGrid" %>
<%@ page import="com.icsc.dpms.de.web.dejcQryGridList" %>
<%@ page import="com.icsc.dpms.de.web.dejcQryRow" %>
<%@ page import="com.icsc.facc.zaf.bp.zafcmsg" %>
<%@ page import="com.icsc.facc.zaf.dao.zafcCommonDAO" %>
<%@ page import="com.icsc.facc.zaf.util.zafctool" %>
<%@ page import="com.icsc.ip.ipjcCommon" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.text.DecimalFormat" %>
<%! public static final String _AppId = "AEJJM1"; %>
<%@ include file="../../jsp/dzjjmain.jsp" %>
<%
    dejcWebInfoOut infoOut = (dejcWebInfoOut) request.getAttribute("infoOut") == null ? new dejcWebInfoOut() : (dejcWebInfoOut) request.getAttribute("infoOut");

    DecimalFormat fmt = new DecimalFormat("#,###,##0.0000");
    String verId_qry = zafctool.trim(infoOut.getParameter("verId_qry"));
    String fromYM_qry = zafctool.trim(infoOut.getParameter("fromYM_qry"));
    String toYM_qry = zafctool.trim(infoOut.getParameter("toYM_qry"));

    boolean isQuery = false;

    StringBuffer sqlStr = new StringBuffer();
    if (verId_qry.length() > 0 && fromYM_qry.length() > 0 && toYM_qry.length() > 0) {
        isQuery = true;
        sqlStr.append("select toObj, toObjType, sum(ia) as SUMIA from db.tbaet2");
        sqlStr.append(" where verId='" + verId_qry + "'");
        sqlStr.append(" and fromYM='" + fromYM_qry + "'");
        sqlStr.append(" and toYM='" + toYM_qry + "'");
        sqlStr.append(" group by toObj, toObjType");
        sqlStr.append(" order by toObj, toObjType");
    } else {
        sqlStr.append("select * from db.tbaet2 where 1=2");
    }

    dejcQryGrid g = new dejcQryGrid(_de300, sqlStr.toString(), 25, true);
    g.setImgBarType();
    dejcQryGridList list = g.getList();

    if (isQuery) {
        if (isQuery && infoOut.getMessage().length() == 0) {
            infoOut.setMessage(list.size() > 0 ? zafcmsg.INQ_OK : zafcmsg.ERR_NOT_FOUND);
        }
    }
%>
<body scroll="no" class="whole-bg">
<table width="100%">
    <de:form name="form1" action="/erp/ip/do?_pageId=ipjjPL">
    <de:text name="verId_qry" type="hidden" value="<%=verId_qry %>"/>
    <de:text name="fromYM_qry" type="hidden" value="<%=fromYM_qry %>"/>
    <de:text name="toYM_qry" type="hidden" value="<%=toYM_qry %>"/>
    <tr>
        <td nowrap width="10%" class="subsys-title"><%=ddjcComMsg.FLD_FUNCTION()%>
        </td>
        <td nowrap width="40%" class="function-bar-left">
            <%=g.printNavigator() %>
        </td>
        <td class="subsys-title" width="10%"><%=ddjcComMsg.FLD_MESSAGE()%>
        </td>
        <td class="msg" id="msg"><de:msg/></td>
    </tr>
</table>
<table width="100%" id="tab2">
    <tr class="subsys-title">
        <td width="15%"><de:dd key="ae.aejcm01VO.objId"/></td>
        <td width="25%"><de:dd key="ae.aejcm01VO.objName"/></td>
        <td width="20%"><de:dd key="ae.aejcm01VO.qty"/></td>
        <td width="20%"><de:dd key="ae.aejcm01VO.afterCost"/></td>
        <td width="20%"><de:dd key="ae.aejcm01VO.afterPrice"/></td>
    </tr>
    <%
        zafcCommonDAO commDao = new zafcCommonDAO(_dsCom);
        for (int i = 0, j = list.size(); i < j; i++) {
            String style = (i % 2 == 0) ? "light-bg" : "deep-bg";
            dejcQryRow r = list.row(i);
            String objid = r.getString("toObj");
            String toObjType = r.getString("toObjType");
            String objName = "";
            if (objid != null && objid.length() > 0) {
                if (toObjType != null && toObjType.length() > 0) {
                    if (toObjType.equals("DPD")) {
                        objName = ipjcCommon.getDPDDesc(_dsCom, objid);
                    }
                }
            }
            StringBuffer qtySQL = new StringBuffer();
            qtySQL.append("select qty as AMT from db.tbaet0");
            qtySQL.append(" where verId='" + verId_qry + "'");
            qtySQL.append(" and fromYM='" + fromYM_qry + "'");
            qtySQL.append(" and toYM='" + toYM_qry + "'");
            qtySQL.append(" and toObj='" + objid + "'");
            qtySQL.append(" and toObjType='" + toObjType + "'");
            qtySQL.append(" and ioType='O'");
            BigDecimal qty = commDao.queryAmt(qtySQL.toString());
            BigDecimal sumIa = r.getBigDecimal("SUMIA") != null ? r.getBigDecimal("SUMIA") : zafctool.ZERO;
            BigDecimal price = qty.signum() != 0 ? sumIa.divide(qty, BigDecimal.ROUND_HALF_UP, 6) : zafctool.ZERO;
    %>
    <tr height="25" class="<%=style%>">
        <td align="left"><a href="javascript: return false;"
                            onclick="openTab2('<%=verId_qry %>','<%=fromYM_qry %>','<%=toYM_qry %>','<%=objid %>','<%=toObjType %>','<%=objName %>','<%=qty.toString() %>')"><%=objid %>
        </a></td>
        <td align="left"><%=objName %>
        </td>
        <td align="right"><%=fmt.format(qty) %>
        </td>
        <td align="right"><%=fmt.format(sumIa) %>
        </td>
        <td align="right"><%=fmt.format(price) %>
        </td>
    </tr>
    <%
        }
    %>
</table>
</de:form>
</body>

<de:script src="dejtag"/>
<de:script src="dejtab06"/>
<de:script src="dejtFolderFrame"/>
<de:script src="dejtTemplate1"/>
<de:script src="dejtips"/>

<script language="JScript">

    var obj = new deScrollTable("tab2");
    obj.setNeedSort(false);
    obj.setHeight(90);
    obj.setEvent(false);
    obj.draw();

    function openTab2(verId_qry, fromYM_qry, toYM_qry, objid, toObjType, objName, qty) {
        parent.document.getElementById("fromYM_qry").value = fromYM_qry;
        parent.document.getElementById("costObj_qry").value = objid;
        parent.document.getElementById("costObjName_qry").value = objName;
        parent.document.getElementById("tabB_fr_main").src = "/erp/ae/do?_pageId=aejjm1B&_action=I&verId_qry=" + verId_qry + "&fromYM_qry=" + fromYM_qry + "&toYM_qry=" + toYM_qry + "&objid_qry=" + objid + "&toObjType_qry=" + toObjType + "&qty_qry=" + qty + "&objName_qry=" + objName;
        parent.ff.tabTable.show(parent.tab2);
    }
</script>
<de:footer/>