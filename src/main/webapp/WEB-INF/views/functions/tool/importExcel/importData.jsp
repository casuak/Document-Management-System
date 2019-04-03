<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>数据导入</title>
    <%@include file="/WEB-INF/views/include/blankHead.jsp" %>
    <link rel="stylesheet" href="/static/css/functions/tool/importExcel/importData.css"/>
</head>
<body>
<div id="app" v-cloak>
    <p>选择模板</p>
    <p>下载模板</p>
    <p>上传数据文件</p>
</div>
<%@include file="/WEB-INF/views/include/blankScript.jsp" %>
<script src="/static/js/functions/tool/importExcel/importData.js"></script>
</body>
</html>