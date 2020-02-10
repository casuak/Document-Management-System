let app = new Vue({
    el: '#app',
    data: {
        urls: {
            getPaperList: '/api/doc/rp/selectListByPage',
            initPaper: '/api/doc/rp/init',
            autoMatch: '/api/doc/rp/autoMatch',
            deletePaperEntryByIds: '/api/doc/rp/deletePaperEntryByIds',
            deletePaperEntryByStatus: '/api/doc/rp/deletePaperEntryByStatus',
            completePaperEntryById: '/api/doc/rp/completePaperEntryById',
            completePaperEntryByStatus: '/api/doc/rp/completePaperEntryByStatus',
            rollBackToSuccessById: '/api/doc/rp/rollBackToSuccessById',
            getEntryList: '/api/doc/rp/getEntryList',
            submitChange: '/api/doc/rp/submitChange'
        },
        loading: {
            fullScreen: false,
            table: false
        },
        status: '-1',   // 默认状态
        statusList: [
            {
                value: '-1',
                label: '1.未初始化'
            },
            {
                value: '0',
                label: '2.1 未匹配'
            },
            {
                value: '3',
                label: '2.2 无北理作者被过滤'
            },
            {
                value: '2',
                label: '3.1 匹配出错'
            },
            {
                value: '1',
                label: '3.2 匹配成功'
            },
            {
                value: '4',
                label: '4.匹配完成'
            }
        ],
        paperList: [],
        page: {
            pageIndex: 1,
            pageSize: 10,
            pageSizes: [5, 10, 20, 40],
            searchKey: '',  // 搜索词
            total: 0       // 总数
        },
        drawer: false,
        selectedPaper: '',
        authorList: [],
        addEntry: false,
        insertItem: {
            name: '',
            realName: '',
            workId: ''
        }
    },
    methods: {
        getPaperList: function () {
            let app = this;
            let data = {
                page: this.page,
                status: this.status
            };
            app.loading.table = true;
            ajaxPostJSON(this.urls.getPaperList, data, function (d) {
                app.loading.table = false;
                app.paperList = d.data.resultList;
                app.page.total = d.data.total;
            }, function (e) {
                app.loading.table = false;
                app.$message({
                    message: "操作失败,错误详情：" + e.data,
                    type: "error"
                });
            });
        },
        getAuthor: function (row, type) {
            if (type === 1) {
                if (row.firstAuthorId != null && row.firstAuthorId !== '')
                    return row.firstAuthorCname + '(' + row.firstAuthorId + ', ' + row.firstAuthorType + ')';
                return '';
            } else {
                if (row.secondAuthorId != null && row.secondAuthorId !== '')
                    return row.secondAuthorCname + '(' + row.secondAuthorId + ', ' + row.secondAuthorType + ')';
                return '';
            }
        },
        initAllPaper: function () {
            let app = this;
            app.loading.table = true;
            ajaxPostJSON(app.urls.initPaper, null, function () {
                app.loading.table = false;
                app.status = '0';
                app.getPaperList();
            }, function (e) {
                app.loading.table = false;
                app.$message({
                    message: "操作失败,错误详情：" + e.data,
                    type: "error"
                });
            });
        },
        autoMatch: function () {
            let app = this;
            app.loading.table = true;
            ajaxPostJSON(app.urls.autoMatch, null, function () {
                app.loading.table = false;
                app.status = '1';
                app.getPaperList();
            }, function (e) {
                app.loading.table = false;
                app.$message({
                    message: "操作失败,错误详情：" + e.data,
                    type: "error"
                });
            });
        },
        deletePaperEntryByIds: function (ids) {
            let app = this;
            if (ids.length === 0) {
                window.parent.app.showMessage('请先选择需要删除的论文！', 'warning');
                return;
            }
            window.parent.app.showConfirm(function () {
                let data = ids;
                app.loading.table = true;
                ajaxPostJSON(app.urls.deletePaperEntryByIds, data, function () {
                    app.loading.table = false;
                    window.parent.app.showMessage('删除成功！', 'success');
                    app.getPaperList();
                }, function (e) {
                    app.loading.table = false;
                    app.$message({
                        message: "操作失败,错误详情：" + e.data,
                        type: "error"
                    });
                })
            });
        },
        deletePaperEntryByStatus: function () {
            let app = this;
            window.parent.app.showConfirm(function () {
                let data = {
                    "status": app.status
                };
                app.loading.table = true;
                ajaxPost(app.urls.deletePaperEntryByStatus, data, function () {
                    app.loading.table = false;
                    window.parent.app.showMessage('删除成功！', 'success');
                    app.getPaperList();
                }, function (e) {
                    app.loading.table = false;
                    app.$message({
                        message: "操作失败,错误详情：" + e.data,
                        type: "error"
                    });
                })
            });
        },
        completePaperEntryById: function (id) {
            window.parent.app.showConfirm(function () {
                let data = id;
                app.loading.table = true;
                ajaxPostJSON(app.urls.completePaperEntryById, data, function () {
                    app.loading.table = false;
                    window.parent.app.showMessage('操作成功！', 'success');
                    app.getPaperList();
                }, function (e) {
                    app.loading.table = false;
                    app.$message({
                        message: "操作失败,错误详情：" + e.data,
                        type: "error"
                    });
                })
            });
        },
        completePaperEntryByStatus: function () {
            let app = this;
            window.parent.app.showConfirm(function () {
                let data = {
                    "status": app.status
                };
                app.loading.table = true;
                ajaxPost(app.urls.completePaperEntryByStatus, data, function () {
                    app.loading.table = false;
                    window.parent.app.showMessage('操作成功！', 'success');
                    app.status = '4';
                    app.getPaperList();
                }, function (e) {
                    app.loading.table = false;
                    app.$message({
                        message: "操作失败,错误详情：" + e.data,
                        type: "error"
                    });
                })
            });
        },
        rollBackToSuccessById: function (id) {
            window.parent.app.showConfirm(function () {
                let data = id;
                app.loading.table = true;
                ajaxPostJSON(app.urls.rollBackToSuccessById, data, function () {
                    app.loading.table = false;
                    window.parent.app.showMessage('操作成功！', 'success');
                    app.status = '1';
                    app.getPaperList();
                }, function (e) {
                    app.loading.table = false;
                    app.$message({
                        message: "操作失败,错误详情：" + e.data,
                        type: "error"
                    });
                })
            });
        },
        openMatchDialog: function (row) {
            let app = this;
            app.selectedPaper = row;
            let data = {
                "id": row.id
            };
            ajaxPost(app.urls.getEntryList, data, function (d) {
                app.authorList = d.data.resultList;
                app.drawer = true;
            }, function (e) {
                app.$message({
                    message: "操作失败,错误详情：" + e.data,
                    type: "error"
                });
            });
        },
        handleDrawerClose: function () {
            this.drawer = false;
            this.authorList = [];
        },
        getStatus: function (entry) {
            let status = entry.status;
            switch (status) {
                case '0':
                    return '唯一匹配';
                case '1':
                    return '已设置完成';
                case '-1':
                    return '无匹配';
                case '-2':
                    return '多个匹配结果';
            }
        },
        removeFromList: function (row) {
            this.authorList.splice(this.authorList.indexOf(row), 1);
        },
        submitChange: function () {
            let app = this;
            let data = [];
            if (app.authorList.length > 0)
                data = app.authorList;
            else
                data.push({paper: app.selectedPaper.id});
            ajaxPostJSON(app.urls.submitChange, data, function () {
                window.parent.app.showMessage('操作成功！', 'success');
                app.handleDrawerClose();
                app.getPaperList();
            }, function (e) {
                app.$message({
                    message: "操作失败,错误详情：" + e.data,
                    type: "error"
                });
            });
        },
        handleInsertClose: function () {
            this.insertItem = {
                name: '',
                realName: '',
                workId: ''
            };
            this.addEntry = false;
        },
        addOneEntry: function () {
            let entry = {
                paper: this.selectedPaper.id,
                authorName: this.insertItem.name,
                status: '0',
                authorWorkId: this.insertItem.workId,
                realName: this.insertItem.realName,
                remarks: '手动添加'
            };
            this.authorList.push(entry);
            this.handleInsertClose();
        }

    },
    mounted: function () {
        this.getPaperList();
    }
});