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
                value: '-2',
                label: '2.1 被过滤'
            },
            {
                value: '0',
                label: '2.2 初始化完成'
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
                value: '4',
                label: '3.3 人工匹配导入完成'
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
            deleteByStatus: '/api/doc/paper/deleteByStatus',
            paperUserMatch: '/api/doc/paper/paperUserMatch',
            convertToSuccessByIds: '/api/doc/paper/convertToSuccessByIds',
            searchUser: '/functions/doc/paperUserMatch/searchUser',
            selectAuthor: '/api/doc/paper/selectAuthor',
            completeAll: '/api/doc/paper/completeAll',
            completeImportPaper: '/api/doc/paper/completeImportPaper'
        },
        searchUserDialog: {
            visible: false,
            loading: false,
        },
        searchPaperUrl: ''
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
        convertToSuccessByIds: function (ids) {
            let app = this;
            window.parent.app.showConfirm(function () {
                let data = ids;
                app.loading.table = true;
                ajaxPostJSON(app.urls.convertToSuccessByIds, data, function (d) {
                    app.loading.table = false;
                    window.parent.app.showMessage('操作成功！', 'success');
                    app.getPaperList();
                }, function (d) {
                    app.loading.table = false;
                    window.parent.app.showMessage('操作失败！', 'error');
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
            let app = this;
            window.parent.app.showConfirm(() => {
                app.loading.table = true;
                ajaxPost(app.urls.paperUserMatch, null, function (d) {
                    app.loading.table = false;
                    app.status = '1';
                    app.getPaperList();
                })
            });
        },
        // complete papers where status = '2'
        completePapers: function () {
            let app = this;
            window.parent.app.showConfirm(() => {
                app.loading.table = true;
                ajaxPost(app.urls.completeAll, null, function (d) {
                    app.loading.table = false;
                    app.status = '3';
                    app.getPaperList();
                })
            });
        },
        // 打开选择用户对话框: targetAuthorIndex (1 - firstAuthor, 2 - secondAuthor)
        openSearchUser: function (row, authorIndex, authorName, workId) {
            this.searchUserUrl = this.urls.searchUser + "?paperId=" + row.id +
                "&authorIndex=" + authorIndex + '&searchKey=' + authorName + ';'
                + '&school=' + (row.danweiCN ? row.danweiCN : '') + '&publishDate=' + row.publishDate + '&workId=' + workId;
            this.searchUserDialog.visible = true;
            this.searchUserDialog.loading = true;
        },
        // 清空作者
        clearAuthor: function (paper, authorIndex) {
            let app = this;
            window.parent.app.showConfirm(function () {
                let data = {
                    paperId: paper.id,
                    authorIndex: authorIndex,
                    authorWorkId: null
                };
                app.loading.table = true;
                ajaxPost(app.urls.selectAuthor, data, function (d) {
                    app.loading.table = false;
                    if (authorIndex === 1)
                        paper.firstAuthorId = null;
                    else
                        paper.secondAuthorId = null;
                })
            });
        },
        completeImportPaper: function () {
            window.parent.app.showConfirm(function () {
                app.loading.table = true;
                ajaxPostJSON(app.urls.completeImportPaper, null, function (d) {
                    app.loading.table = false;
                    window.parent.app.showMessage('操作成功！', 'success');
                    app.status = '3';
                    getPatentList();
                }, function (d) {
                    app.loading.table = false;
                    window.parent.app.showMessage('操作失败！', 'error');
                    app.status = '3';
                    getPatentList();
                })
            });
        }
    },
    mounted: function () {
        this.getPaperList();
    }
});