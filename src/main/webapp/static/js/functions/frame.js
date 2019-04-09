app = new Vue({
    el: '#app',
    data: {
        user: '',
        categoryList: [],
        tabList: [
            {
                url: 'functions/home',
                title: '首页',
                name: 'tab0',
                loading: true, // tab页进入加载状态
            }
        ],
        activeTabName: 'tab0',
        tabNameCount: 1, // 只增不减
        fullScreenLoading: false,
        urls: {
            getCurrentUser: '/api/sys/user/getCurrentUser',
            getCategoryListByUser: 'api/sys/function/getCategoryListByUser'
        },
    },
    methods: {
        // 登出
        logout: function () {
            location.href = "/logout";
        },
        // 点击左边功能栏的功能页时触发
        onClickFunctionBar: function (indexString) {
            let indexes = indexString.split('-');
            let index1 = parseInt(indexes[0]);
            let index2 = parseInt(indexes[1]);
            let _function = this.categoryList[index1].functionList[index2];
            this.addTab(_function.name, _function.url);
        },
        /**
         * 添加一个新的标签页，如果已经存在url相同的标签页，则激活那个标签页并重新加载tab中的iframe
         * @param title tab的名字
         * @param url 内容页的地址
         * @returns 返回当前激活的tabName(即新添加的tab)(删除时使用该参数)
         */
        addTab: function (title, url) {
            let exist = false;
            let index = -1;
            // 判断是否已经有url相同的标签页被打开
            for (let i = 0; i < this.tabList.length; i++) {
                if (this.tabList[i].url === url) {
                    exist = true;
                    index = i;
                    break;
                }
            }
            // 标签页已被打开，则不再添加新的标签页，而是设置目标标签页为active
            if (exist === true) {
                this.activeTabName = this.tabList[index].name;
                this.tabList[index].loading = true; // tab页进入加载状态
                this.refreshTab(this.activeTabName);
            } else {
                let newTabName = 'tab' + this.tabNameCount;
                this.tabNameCount += 1;
                this.tabList.push({
                    title: title,
                    url: url,
                    name: newTabName,
                    loading: true // tab页进入加载状态
                });
                this.activeTabName = newTabName;
            }
            return this.activeTabName;
        },
        // 删除标签页
        removeTab: function (targetName) {
            if (targetName === 'tab0') {
                console.log("首页不能删除!");
                return;
            }
            let tabs = this.tabList;
            let activeName = this.activeTabName;
            if (activeName === targetName) {
                this.tabList.forEach((tab, index) => {
                    if (tab.name === targetName) {
                        let nextTab = tabs[index + 1] || tabs[index - 1];
                        if (nextTab)
                            activeName = nextTab.name;
                    }
                })
            }
            this.activeTabName = activeName;
            this.tabList = tabs.filter(tab => tab.name !== targetName);
        },
        // 刷新指定tab的iframe
        refreshTab: function (iframeId) {
            document.getElementById(iframeId).contentWindow.location.reload(true);
        },
        // 通用方法1：消息提示
        showMessage: function (message, type = 'success') {
            this.$message({
                message: message,
                type: type
            });
        },
        // 通用方法2：确认框
        showConfirm: function (yesFunction, noFunction = () => {
        }, title = '警告', content = '请确认当前的操作', type = 'warning') {
            this.$confirm(content, title, {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: type
            }).then(yesFunction, noFunction);
        },
        // 刷新功能栏
        refreshFunctions: function () {
            let app = this;
            ajaxPostJSON(app.urls.getCategoryListByUser, app.user, function (d) {
                app.categoryList = d.data;
            })
        }
    },
    mounted: function () {
        // 初始化页面:
        // 1. 获取登陆用户信息
        // 2. 根据用户获取对应的菜单信息
        let app = this;
        app.fullScreenLoading = true;
        ajaxPost(app.urls.getCurrentUser, null, function (d) {
            app.user = d.data;
            ajaxPostJSON(app.urls.getCategoryListByUser, app.user, function (d) {
                app.fullScreenLoading = false;
                app.categoryList = d.data;
            })
        });
    }
});