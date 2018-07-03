<html>
<head>
    <link rel=stylesheet href="/erp/html/dzwcss.gui" type="text/css">
    <style type="text/css">
        <!--
        u {
            FONT-FAMILY: "Courier New", "Courier", "mono"
        }

        a {
            TEXT-DECORATION: none
        }

        a:visited {
            COLOR: Blue
        }

        a:hover {
            COLOR: Red;
            background-color: #AAC0F8;
            TEXT-DECORATION: underline
        }

        a:link {
            COLOR: Blue
        }

        .display-area {
            BACKGROUND-COLOR: #6A86CF;
            COLOR: white;
            FONT-SIZE: 12pt;
            TEXT-ALIGN: center
        }

        .display-area-left {
            BACKGROUND-COLOR: #6A86CF;
            COLOR: white;
            FONT-SIZE: 12pt;
            TEXT-ALIGN: left
        }

        .display-area-right {
            BACKGROUND-COLOR: #6A86CF;
            COLOR: white;
            FONT-SIZE: 12pt;
            TEXT-ALIGN: right
        }

        .function-bar {
            BACKGROUND-COLOR: #AAC0F8;
            TEXT-ALIGN: center
        }

        .function-bar-left {
            BACKGROUND-COLOR: #AAC0F8;
            TEXT-ALIGN: left
        }

        .function-bar-right {
            BACKGROUND-COLOR: #AAC0F8;
            TEXT-ALIGN: right
        }

        .msg {
            BACKGROUND-COLOR: #FFFFFF;
            COLOR: Red;
            FONT-WEIGHT: bold;
            FONT-SIZE: 12pt;
            TEXT-ALIGN: left;
            BORDER: 1px outset
        }

        .subsys-title {
            BACKGROUND-COLOR: #6A86CF;
            COLOR: white;
            TEXT-ALIGN: center
        }

        .subsys-title-left {
            BACKGROUND-COLOR: #6A86CF;
            COLOR: white;
            TEXT-ALIGN: left
        }

        .subsys-title-right {
            BACKGROUND-COLOR: #6A86CF;
            COLOR: white;
            TEXT-ALIGN: right
        }

        .whole-bg {
            BACKGROUND-COLOR: #E8F0F6
        }

        -->
    </style>
    <script>
        document.all("DZJJ301LIST").style.display = "none";
        function startTimer() {
            if (sel1.selectedIndex == 1) {
                document.all.startBtn.disabled = true;
                document.all.stopBtn.disabled = false;
                reloadPage(1);
            }
            else
                document.all.msgBox.innerText = "Use reload button instead";
        }
        function stopTimer() {
            document.all.startBtn.disabled = false;
            document.all.stopBtn.disabled = true;
            clearTimeout(timer);
        }
        function reloadPage(isReload) {
            target = "http://testbx.icsc.com.tw:9085" + document.all.sel1.value;
            if (document.all.fm1.src == target)
                fm1.document.location.reload();
            else
                document.all.fm1.src = target;
            reloadInterval = (reloadTime.selectedIndex + 1) * 2 * 1000;
            if (isReload == 1 && document.all.sel1.selectedIndex == 1)
                timer = setTimeout('reloadPage(1);', reloadInterval);
        }
    </script>
</head>
<body leftmargin="0" topmargin="0">
<table width="100%" border="0" cellspacing="0" cellpadding="0" background="/erp/images/logo/app_bg.gif">
    <tr>
        <td width="200" nowrap align="center"><img src="/erp/images/logo/bx.gif" border="0" alt="bx"></td>
        <td align="center" nowrap width="1">&nbsp;</td>
        <td align="center" nowrap><font size="+2" color="#6A86CF"><b><span id="APTitle">&nbsp;</span></b></font></td>
        <td nowrap width="220"><a href="http://www.icsc.com.tw"><img border="0" src="/erp/images/logo/app_mark.gif"
                                                                     align="right"></td>
    </tr>
</table>
<table width="100%" border="0" class=light-bg>
    <tr>
        <td class=light-bg-left colspan=2>
            <select name=sel1>
                <option value="/erp/jsp/mgmt/ThreadList.jsp">Show Thread List</option>
                <option value="/erp/jsp/mgmt/Running.jsp">Show Running Pages</option>
                <option value="/erp/jsp/mgmt/PMIClient.jsp">Use PMI Client</option>
                <option value="/erp/jsp/dzjj301.jsp">Connection List</option>
            </select>
            Auto Refresh
            <input name=startBtn type=button value="Start" onclick="startTimer();">
            <input name=stopBtn type=button value="Stop" onclick="stopTimer();" disabled>
            <input type=button value="Refresh" onclick="reloadPage(0);">Reload Time
            <select name=reloadTime>
                <option value="2">2</option>
                <option value="4">4</option>
                <option value="6">6</option>
                <option value="8">8</option>
            </select>
        </td>
        <td width='10%' class=subsys-title>Message</td>
        <td width='40%' class=Msg id=msg colspan=3><span id=msgBox></span></td>
    </tr>
</table>
<iframe name=fm1 border=1 width="100%" height="40%" src=""></iframe>
</body>
</html>