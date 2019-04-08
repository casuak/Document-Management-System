<%--
  Created by IntelliJ IDEA.
  User: zm
  Date: 2019/4/8
  Time: 8:44
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>文献详情页</title>
    <%@include file="/WEB-INF/views/include/blankHead.jsp" %>
    <link rel="stylesheet" href="/static/css/functions/doc/paperUserMatch.css"/>
    <style>

    </style>
</head>
<body>
<div id="app" v-cloak>
文献详情
</div>
<%@include file="/WEB-INF/views/include/blankScript.jsp" %>
<script>
    var app = new Vue({
        el:'#app',
        data:{},
        methods:{
        }
    })
</script>
</body>
</html>
