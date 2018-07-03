<%@ page contentType="text/html;charset=GBK" %>
<body topmargin="0" leftmargin="0">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312">
</head>
<script src="/erp/de/html/dejtjquery-1.2.1.pack.jss"></script>
<script src="/erp/de/html/jquery.selectboxes.pack.js"></script>
<script src="/erp/html/de/dejtjquery-1.2.1.pack.jss"></script>
<script src="/erp/html/de/jquery.selectboxes.pack.js"></script>
<form name=form1>

    <button id="go">grab form</button>
    <select id="testdata">
        <option>汇入测试资料…
    </select><img src="/erp/images/dzwinext.gif" style="cursor:hand" onclick=importTestData()>

    <select id="user"></select>
    <img src="/erp/images/dzwinext.gif" style="cursor:hand" onclick=changeUser($("#user"))>
    <select id="link"></select>
    <img src="/erp/images/dzwinext.gif" style="cursor:hand" onclick=go2link($("#link"))>
    <div id="menubar" style="display:none">
        <span id="type" style="color:red"></span> :
        代号:<input type="text" name="code" value="">
        名称:<input type="text" name="name" value="">
        所属代号:<input type="text" name="belong" value="">
        <button id="genData">产生</button>
</form>

</div>
<div id="output"></div>

<iframe name="main" width="100%" height="150%" src=""></iframe>
<script>
    var globalCounter = 0;
    function initSelects() {
        var testdata = ["/erp/ud/test/udjjDocReg.js 收文登录",
            "/erp/ud/test/udjjHostReg.js 创稿登录",
            "/erp/ud/test/udjjHostRegReq.js 请示报告"
        ]
        var users = ["000028 总收文", "000030 总发文", "A01001 公司办主任",
            "A31001 炼铁新厂主任", "A31011 炼铁新厂综管科", "A31099 炼铁新厂厂长",
            "B61001 焦化厂主任", "B61011 焦化厂综管科员",
            "A33001 能源中心主任",
            "UDDEPA15 保卫部主任",
            "UDA1501 护卫大队队员",
            "UDBOS01 老板一号", "UDBOS02 老板二号",
            "UDSEC01 秘书一号", "UDSEC02 秘书二号"
        ];
        var links = ["ud/jsp 请选择",
            "ud/jsp/udjjWorkMain.jsp 待处理工作",
            "ud/jsp/udjjRcvSeqMain.jsp 收文序号设定",
            "ud/jsp/udjjIssueSeqMain.jsp 发文序号设定",
            "ud/jsp/udjjDocRegMain.jsp 总收文登录",
            "ud/jsp/udjjHostRegMain.jsp 创稿登录",
            "ud/jsp/udjjMsgerMain.jsp 收发人员设定",
            "ud/jsp/udjjBossListCfg.jsp 公司领导设定",
            "ud/jsp/udjjSecretaryCfg.jsp 领导秘书设定",
            "ud/jsp/udjjDocTypeMain.jsp 公文种类设定",
            "ud/jsp/udjjWorkMini.jsp?role=3 mini工作",
            "ds/jsp/dsjjsql.jsp sql命令"
        ];
        makeList($("#user"), users);
        makeList($("#link"), links, true);
        makeList($("#testdata"), testdata, true);
    }
    function makeList(jqueryObj, datas, novalue) {
        for (var i = 0; i < datas.length; i++) {
            var u = datas[i].split(" ");
            if (novalue) {
                jqueryObj.addOption(u[0], u[1]);
            } else {
                jqueryObj.addOption(u[0], datas[i]);
            }
        }
    }
    var _userNo = "", _deptNo = "";
    function importTestData() {
        var v = $("#testdata").val();
        _userNo = document.frames("main").document.getElementsByName("_dscom_user_ID")[0].value;
        _deptNo = document.frames("main").document.getElementsByName("_dscom_user_department")[0].value;
        $.getScript(v, function () {
            var tf = getTargetForm();
            globalCounter++;
            for (var p in data) {
                try {
                    tf.elements(p).value = _replaceVar(data[p]);
                } catch (e) {
                    alert("element[" + p + "]not found");
                }
            }
        });
    }
    function _replaceVar(v) {
        var date = new Date();
        var dateStr = date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate();
        var empNo =
                v = v.replace(/{seq}/g, globalCounter);
        v = v.replace(/{date}/g, dateStr);
        v = v.replace(/{userNo}/g, _userNo);
        v = v.replace(/{deptNo}/g, _deptNo);
        return v;
    }
    function grabFormField() {
        var fr = document.frames("main");
        var f1 = fr.form1;
        var s = "";
        for (var i = 0; i < f1.elements.length; i++) {
            var n = f1.elements[i].name;
            s += "\"" + n + "\":\"" + f1.elements[i].value + "\",<br>";
        }
        s += "<hr>";
        for (var i = 0; i < fr.frames.length; i++) {
            for (var k = 0; k < fr.frames[i].document.forms.length; k++) {
                var form = fr.frames[i].document.forms[k];
                s += "<br>[frame_" + i + "_form_" + form.name + "]<hr>";
//			if(targetForm==null&&form.name=="form1"){
//				targetForm=form;
//			}

                for (var j = 0; j < form.elements.length; j++) {
                    var n = form.elements[j].name;
                    if (n == null)continue;
                    if (n == "button" || n.search(/_label/g) != -1 || n.search(/,old/g) != -1) {
                        continue;
                    }
                    if (n) {
                        s += "\"" + n + "\":\"" + form.elements[j].value + "\",<br>";
                    }
                }
            }
        }

        $("#output").html(s);
    }
    function go2link(sel) {
        document.frames("main").location = "/erp/" + sel.val();
    }
    function changeUser(sel) {
        $(eipform.UserId).val(sel.val());
        $(eipform.Passwd).val("1");
        eipform.submit();
    }

    $(document).ready(function () {
        initSelects();
        $("#go").click(function () {
            grabFormField();
        });
        $("#testdata").change(function () {
            importTestData();
        });
        $("#user").change(function () {
            changeUser($(this));
        });
        $("#link").change(function () {
            go2link($(this));
        });
        $("#makeuser").click(function () {
            $("#type").text("user");
            $("#menubar").toggle();
        });
        $("#makedept").click(function () {
            $("#type").text("dept");
            $("#menubar").toggle();
        });
        $("#genData").click(function () {
            if ($("#type").text() == "user") {
                var userId = $("input[name='code']").val();
                var userName = $("input[name='name']").val();
                var deptNo = $("input[name='belong']").val();
                var sql = "insert into DB.TBDU01 values('icsc','" + userId + "','1','31','" + deptNo + "','E122549900','" + userName + "','TESTMAN','19930101','07-08575757','','','','','高雄市测试园区测试路一号','20120401','','','E','高雄市测试园区测试路一号','017','00208409999','B','','','','',0,'ICSC01',1062126182204,'')";
                var pwdSql = "insert into db.tbdu02 values ('" + userId + "','1251049905','1251049299','20171231','127.0.0.1')";
                sqlform.SqlStr.value = sql;
                sqlform.submit();
                sqlform.SqlStr.value = pwdSql;
                sqlform.submit();
            }
            if ($("#type").text() == "dept") {
                var deptNo = $("input[name='code']").val();
                var deptName = $("input[name='name']").val();
                var sql = "insert into DB.TBDU05 (ORGTYPE, DEPNO, DEPNAME, DEPADMIN, DEPENGNAME, STATUS, ISFROMDU) values ('ADMIN', '" + deptNo + "', '" + deptName + "', '','' , 'OP', 'N')";
                sqlform.SqlStr.value = sql;
                sqlform.submit();
            }
        });
    });
</script>
<form name="eipform" method="post" target="main" action="/erp/ds/jsp/dsjjeip.jsp">
    <input type="hidden" name="UserId" value="ICSCDS">
    <input type="hidden" name="Passwd" value="icsc">
    <input type="hidden" name="CompId" value="A">
    <input type="hidden" name="Button" value="登入">
</form>
<form name="sqlform" method="post" target="main" action="/erp/ds/jsp/dsjjsql.jsp">
    <input type="hidden" name="SqlStr" value="">
    <input type="hidden" name="Submit" value="确定">
    <input type="hidden" name="Type" value="0">
</form>

</body>