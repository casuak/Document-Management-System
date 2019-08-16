<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>登录</title>
    <%@include file="/WEB-INF/views/include/blankHead.jsp" %>
    <link rel="stylesheet" href="/static/css/login.css"/>
</head>
<body>
<div id="app" v-cloak style="height: 100%;overflow: hidden;" v-loading="fullScreenLoading">
    <div class="login-body">
        <div class="login-logo" style="text-align: center;letter-spacing: 0.2em;font-size: 40px;font-weight: bold;">
            <div>
                北京理工大大学研究生院
            </div>
            <div style="padding-top: 15px;">
                文献管理系统
            </div>
        </div>

        <div class="login-container" style="top: 15px;position:relative;">

            <div class="login-left">
                <div class="left-logo">
                </div>
            </div>
            <div class="login-mid">
            </div>
            <div class="login-right">
                <div class="login-content">
                    <div class="login-input-wrap">
                        <div class="margin-bottom-5">
                            <label class="loginLabal">用户登录</label>
                        </div>
                        <div class="margin-bottom-5">
                            <input type="text" class="txtInput"
                                   v-model="formData.username" placeholder="用户名">
                        </div>
                        <div class="margin-bottom-5">
                            <input type="password" class="txtInput formIpt"
                                   placeholder="密码" v-model="formData.password">
                        </div>
                        <div class="login-button-container">
                            <%--<input id="rememberMe"  type="checkbox" name="rememberMe" ${rememberMe ? 'checked' : ''} />--%>
                            <%--<label for="rememberMe">记住用户名</label>--%>
                            <button class="login-button" style="font-family: 黑体 !important;"
                                    @click="login()">登 录
                            </button>
                            <div class="kclear"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <footer class="footer" style="position: absolute;bottom: 10px;width: 100%">
        <p style="text-align: center">&copy; 开发单位：北京理工大学软件学院</p>
    </footer>
</div>
<%@include file="/WEB-INF/views/include/blankScript.jsp" %>
<script src="/static/js/login.js"></script>
</body>
</html>