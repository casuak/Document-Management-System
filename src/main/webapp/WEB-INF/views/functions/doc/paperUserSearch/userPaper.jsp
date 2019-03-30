<%--
  Created by IntelliJ IDEA.
  User: zm
  Date: 2019/3/27
  Time: 12:12
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>ssm</title>
    <%@include file="/WEB-INF/views/include/blankHead.jsp" %>
    <link rel="stylesheet" href="/static/css/functions/doc/paperUserMatch.css"/>
    <style>

    </style>
</head>
<body>
<div id="app" v-cloak>

</div>
<%@include file="/WEB-INF/views/include/blankScript.jsp" %>
<script>
    const cityOptions = [];
    var app = new Vue({
        el:'#app',
        data:{},
        methods:{
        }
    })
</script>
</body>
</html>
