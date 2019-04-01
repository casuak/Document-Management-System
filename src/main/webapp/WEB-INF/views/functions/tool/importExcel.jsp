<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>ssm</title>
    <%@include file="/WEB-INF/views/include/blankHead.jsp" %>
    <link rel="stylesheet" href="/static/css/functions/tool/importExcel.css"/>
</head>
<body>
<div id="app" v-cloak>
    <%-- 未匹配；匹配出错；匹配成功；匹配完成 --%>
    <el-tabs v-model="activeTabName" style="height: 100%;overflow-y: hidden">
        <el-tab-pane v-for="tab in tabList" :label="tab.label" :name="tab.name"  :lazy="true">
            <iframe :src="tab.src"></iframe>
        </el-tab-pane>
    </el-tabs>
</div>
<%@include file="/WEB-INF/views/include/blankScript.jsp" %>
<script src="/static/js/functions/tool/importExcel.js"></script>
</body>
</html>