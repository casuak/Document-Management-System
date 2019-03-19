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