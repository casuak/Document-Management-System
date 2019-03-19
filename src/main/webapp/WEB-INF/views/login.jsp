<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>ssm</title>
    <%@include file="/WEB-INF/views/include/blankHead.jsp" %>
    <link rel="stylesheet" href="/static/css/login.css"/>
</head>
<body>
<div id="app" v-cloak>
    <div class="login-container">
        <el-form label-position="left" label-width="0px" class="demo-ruleForm login-page">
            <h3 class="title">人力资源市场管理系统</h3>
            <el-form-item>
                <el-input type="text" v-model="formData.username" placeholder="用户名"
                          auto-complete="off"></el-input>
            </el-form-item>
            <el-form-item>
                <el-input type="password" v-model="formData.password" placeholder="密码"
                          auto-complete="off"></el-input>
            </el-form-item>
            <el-checkbox v-model="checked" class="rememberme" style="margin: 0 0 10px 125px;">记住密码
            </el-checkbox>
            <el-form-item style="width:100%;">
                <el-button type="primary" style="width:100%;" @click="login()" :loading="fullScreenLoading">登录
                </el-button>
            </el-form-item>
        </el-form>
    </div>
</div>
<%@include file="/WEB-INF/views/include/blankScript.jsp" %>
<script src="/static/js/login.js"></script>
</body>
</html>