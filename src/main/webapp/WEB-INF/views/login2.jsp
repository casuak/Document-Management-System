<%--
  Created by IntelliJ IDEA.
  User: zm
  Date: 2019/3/30
  Time: 15:32
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>文献管理系统</title>
    <%@include file="/WEB-INF/views/include/blankHead.jsp" %>
    <link rel="stylesheet" href="/static/plugins/loginStatics/css/jq22.css"/>
</head>
<body>
<div id="app" v-cloak>
    <%--<div class="text-center">--%>
        <%--<h1>研究生院文献管理系统</h1>--%>
    <%--</div>--%>
    <div id="login">
        <div class="wrapper">
            <div class="login">
                <form action="#" method="post" class="container offset1 loginform">
                    <div id="owl-login">
                        <div class="hand"></div>
                        <div class="hand hand-r"></div>
                        <div class="arms">
                            <div class="arm"></div>
                            <div class="arm arm-r"></div>
                        </div>
                    </div>
                    <div class="pad">
                        <input type="hidden" name="_csrf" value="9IAtUxV2CatyxHiK2LxzOsT6wtBE6h8BpzOmk=">
                        <div class="control-group">
                            <div class="controls">
                                <label for="email" class="control-label fa fa-user-md"></label>
                                <input id="email" v-model="formData.username" type="email" name="email" placeholder="用户名" tabindex="1" autofocus="autofocus" class="form-control input-medium">
                            </div>
                        </div>
                        <div class="control-group">
                            <div class="controls">
                                <label for="password" class="control-label fa fa-asterisk"></label>
                                <input id="password" v-model="formData.password" type="password" name="password" placeholder="密码" tabindex="2" class="form-control input-medium">
                            </div>
                        </div>
                    </div>
                    <div class="form-actions">
                            <el-button type="primary" style="width:100%;" @click="login()" :loading="fullScreenLoading">登录
                            </el-button>
                    </div>
                </form>
            </div>
        </div>
        <script src="/static/plugins/jquery/jquery-3.3.1.min.js"></script>
        <script>

            $(function() {
                $('#login #password').focus(function() {
                    $('#owl-login').addClass('password');
                }).blur(function() {
                    $('#owl-login').removeClass('password');
                });
            });
        </script>
    </div>
</div>

<%@include file="/WEB-INF/views/include/blankScript.jsp" %>
<script>
    let app = new Vue({
        el: '#app',
        data: {
            formData: {
                username: '',
                password: ''
            },
            checked: false,
            fullScreenLoading: false,
            urls: {
                login: '/login'
            }
        },
        methods: {
            login: function () {
                let app = this;
                let data = app.formData;
                app.fullScreenLoading = true;
                ajaxPostJSON(app.urls.login, data, function (d) {
                    app.fullScreenLoading = false;
                    if (d.code === 'success') {
                        location.href = "/";
                        app.$message({
                            message: '登陆成功',
                            type: 'success'
                        });
                    } else {
                        app.$message({
                            message: '登陆失败',
                            type: 'error'
                        });
                    }
                })
            }
        }
    });
</script>
</body>
</html>