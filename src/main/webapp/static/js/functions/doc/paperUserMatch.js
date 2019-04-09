app = new Vue({
    el: '#app',
    data: {
        loading: {
            fullScreen: false,
            table: false
        },
        status: '-1',   // current status
        statusList: [
            {
                value: '-1',
                label: '1. 未初始化'
            },
            {
                value: '0',
                label: '2. 未匹配'
            },
            {
                value: '1',
                label: '3.1 匹配出错'
            },
            {
                value: '2',
                label: '3.2 匹配成功'
            },
            {
                value: '3',
                label: '4. 匹配完成'
            }
        ],
        paperList: [],
        selectionList: [],  // the selected paperList
        page: {
            pageIndex: 1,
            pageSize: 10,
            pageSizes: [5, 10, 20, 40],
            searchKey: '',  // 搜索词
            total: 0,       // 总数
        },
        urls: {
            // api for entity
            deleteByIds: '/api/doc/paper/deleteListByIds',
            getPaperList: '/api/doc/paper/selectListByPage',
            initPapers: '/api/doc/paper/initAll',
            deleteByStatus: '/api/doc/paper/deleteByStatus'
        }
    },
    methods: {
        deleteByIds: function (ids) {
            let app = this;
            window.parent.app.showConfirm(function () {
                let data = ids;
                app.loading.table = true;
                ajaxPostJSON(app.urls.deleteByIds, data, function (d) {
                    app.loading.table = false;
                    window.parent.app.showMessage('删除成功！', 'success');
                    app.getPaperList();
                })
            });
        },
        deleteByStatus: function () {
            let app = this;
            window.parent.app.showConfirm(function () {
                app.loading.table = true;
                let data = {
                    status: app.status
                };
                ajaxPost(app.urls.deleteByStatus, data, function (d) {
                    app.loading.table = false;
                    app.getPaperList();
                    window.parent.app.showMessage("删除成功");
                })
            });
        },
        getPaperList: function () {
            let data = {
                page: this.page,
                status: this.status
            };
            let app = this;
            app.loading.table = true;
            ajaxPostJSON(this.urls.getPaperList, data, function (d) {
                app.loading.table = false;
                app.paperList = d.data.resultList;
                app.page.total = d.data.total;
            })
        },
        // init papers where status = '-1'
        initPapers: function () {
            let app = this;
            window.parent.app.showConfirm(() => {
                app.loading.table = true;
                ajaxPost(app.urls.initPapers, null, function (d) {
                    app.loading.table = false;
                    app.status = '0';
                    app.getPaperList();
                })
            });
        },
        // match user where status = '0'
        paperUserMatch: function () {

        },
        // complete papers where status in ('1', '2')
        completePapers: function () {
            let data = {
                status: this.status
            };
        }
    },
    mounted: function () {
        this.getPaperList();
    }
});