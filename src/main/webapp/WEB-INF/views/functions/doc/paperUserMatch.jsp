<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>ssm</title>
    <%@include file="/WEB-INF/views/include/blankHead.jsp" %>
    <link rel="stylesheet" href="/static/css/functions/doc/paperUserMatch.css"/>
</head>
<body>
<div id="app" v-cloak>
    <%-- 未匹配；匹配出错；匹配成功；匹配完成 --%>
    <el-tabs v-model="activeTabName" style="padding: 5px 20px;">
        <el-tab-pane label="未匹配" name="tab1">
            <iframe src="/functions/doc/paperUserMatch/tab1"></iframe>
        </el-tab-pane>
        <el-tab-pane label="匹配出错" name="tab2">
            <iframe src="/functions/doc/paperUserMatch/tab2"></iframe>
        </el-tab-pane>
        <el-tab-pane label="匹配成功" name="tab3">
            <iframe src="/functions/doc/paperUserMatch/tab3"></iframe>
        </el-tab-pane>
        <el-tab-pane label="匹配完成" name="tab4">
            <iframe src="/functions/doc/paperUserMatch/tab4"></iframe>
        </el-tab-pane>
    </el-tabs>
</div>
<%@include file="/WEB-INF/views/include/blankScript.jsp" %>
<script src="/static/js/functions/doc/paperUserMatch.js"></script>
</body>
</html>