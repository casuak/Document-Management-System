app = new Vue({
    el: '#app',
    data: {
        user: '',
        categoryList: [],
        tabList: [
            {
                id: 'home',
                url: 'functions/home',
                title: '首页',
                name: 'tab0',
                loading: true, // tab页进入加载状态
            }
        ],
        activeTabName: 'tab0',
        tabNameCount: 1,
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
        // 添加新的标签页
        addTab: function (indexString) {
            let indexes = indexString.split('-');
            let index1 = parseInt(indexes[0]);
            let index2 = parseInt(indexes[1]);
            let _function = this.categoryList[index1].functionList[index2];
            let exist = false;
            let index = -1;
            for (let i = 0; i < this.tabList.length; i++) {
                if (this.tabList[i].id === _function.id) {
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
            }
            else {
                let newTabName = 'tab' + this.tabNameCount;
                this.tabNameCount += 1;
                this.tabList.push({
                    id: _function.id,
                    title: _function.name,
                    url: _function.url,
                    name: newTabName,
                    loading: true // tab页进入加载状态
                });
                this.activeTabName = newTabName;
            }
        },
        // 删除标签页
        removeTab: function (targetName) {
            if (targetName == 'tab0') {
                console.log("首页不能删除!");
                return;
            }
            let tabs = this.tabList;
            let activeName = this.activeTabName;
            if (activeName == targetName) {
                tabs.forEach((tab, index) => {
                    if (tab.name == targetName) {
                        let nextTab = tabs[index + 1] || tabs[index - 1];
                        if (nextTab)
                            activeName = nextTab.name;
                    }
                })
            }
            this.activeTabName = activeName;
            this.tabList = tabs.filter(tab => tab.name != targetName);
        },
        // 刷新指定tab的iframe
        refreshTab: function (iframeId) {
            document.getElementById(iframeId).contentWindow.location.reload(true);
        },
        // 通用方法1：消息提示
        showMessage: function(message, type){
            this.$message({
                message: message,
                type: type
            });
        }
    },
    mounted: function () {
        // 初始化页面:
        // 1. 获取登陆用户信息
        // 2. 根据用户获取对应的菜单信息
        let app = this;
        app.fullScreenLoading = true;
        ajaxPost(app.urls.getCurrentUser, null, function(d){
            app.user = d.data;
            ajaxPostJSON(app.urls.getCategoryListByUser, app.user, function (d) {
                app.fullScreenLoading = false;
                app.categoryList = d.data;
            })
        });
    }
});