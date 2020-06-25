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
            submitChange: '/api/doc/rp/submitChange',
            selectEntityListByPage: '/api/sys/user/selectListByPage',
            selectDanweiNicknamesAllList: '/api/doc/danweiNicknames/selectAllList',
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
        },
        selectedEntry: '',
        searchUserDialog: {
            visible: false,
            fullScreenLoading: false,
            table: {
                entity: {
                    data: [],
                    loading: false,
                    selectionList: [],
                    params: {
                        pageIndex: 1,
                        pageSize: 10,
                        pageSizes: [5, 10, 20, 40],
                        searchKey: '',  // 搜索词
                        total: 0,       // 总数
                    }
                }
            },
            filterParams: {
                userType: '', // 用户类型
                school: '', // 所属单位
                workId: '', // 工号/学号
            },
            danweiList: []
        },
        userTypeList: [
            {
                value: 'teacher',
                label: '导师'
            },
            {
                value: 'student',
                label: '学生'
            },
            {
                value: 'doctor',
                label: '博士后'
            }
        ],
        uploadDialog: {
            visible: false,
            loading: false,
            fileList: [],
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
        },
        openFindDialog: function (row) {
            this.searchUserDialog.filterParams.school = this.selectedPaper.danweiCN;
            this.searchUserDialog.table.entity.params.searchKey = row.authorName;

            let app = this;
            app.searchUserDialog.table.entity.loading = true;
            ajaxPostJSON(app.urls.selectDanweiNicknamesAllList, null, function (d) {
                app.searchUserDialog.danweiList = d.data;
                app.searchUserDialog.table.entity.loading = false;
                app.selectEntityListByPage();
            });
            this.selectedEntry = row;
            this.searchUserDialog.visible = true;
        },
        handleSearchClose: function () {
            this.searchUserDialog = {
                visible: false,
                fullScreenLoading: false,
                table: {
                    entity: {
                        data: [],
                        loading: false,
                        selectionList: [],
                        params: {
                            pageIndex: 1,
                            pageSize: 10,
                            pageSizes: [5, 10, 20, 40],
                            searchKey: '',  // 搜索词
                            total: 0,       // 总数
                        }
                    }
                },
                filterParams: {
                    userType: '', // 用户类型
                    school: '', // 所属单位
                    workId: '', // 工号/学号
                },
                danweiList: []
            };
        },
        selectUser: function (workId, realName) {
            let app = this;
            let i = app.authorList.indexOf(app.selectedEntry);
            console.log(i);
            app.authorList[i].authorWorkId = workId;
            app.authorList[i].realName = realName;
            app.authorList[i].status = '0';
            app.handleSearchClose();
        },
        selectEntityListByPage: function () {
            let data = this.searchUserDialog.filterParams;
            data.page = this.searchUserDialog.table.entity.params;
            let app = this;
            app.searchUserDialog.table.entity.loading = true;
            ajaxPostJSON(this.urls.selectEntityListByPage, data, function (d) {
                app.searchUserDialog.table.entity.loading = false;
                app.searchUserDialog.table.entity.data = d.data.resultList;
                app.searchUserDialog.table.entity.params.total = d.data.total;
            });
        },
        // 刷新entity table数据
        refreshTable_entity: function () {
            this.selectEntityListByPage();
        },
        // 处理选中的行变化
        onSelectionChange_entity: function (val) {
            this.searchUserDialog.table.entity.selectionList = val;
        },
        // 处理pageSize变化
        onPageSizeChange_entity: function (newSize) {
            this.searchUserDialog.table.entity.params.pageSize = newSize;
            this.refreshTable_entity();
        },
        // 处理pageIndex变化
        onPageIndexChange_entity: function (newIndex) {
            this.searchUserDialog.table.entity.params.pageIndex = newIndex;
            this.refreshTable_entity();
        },
        beforeUpload: function (file) {
            this.uploadDialog.loading = true;
            let suffix = file.name.split('.').pop();
            if (suffix !== 'xlsx') {
                this.$message({
                    message: '仅支持.xlsx文件',
                    type: 'error'
                });
                this.uploadDialog.loading = false;
                return false;
            }
        },
        onUploadSuccess: function (response, file, fileList) {
            this.uploadDialog.loading = false;
            if (response.code === 'success')
                this.$message({
                    message: '上传成功，' + response.data,
                    type: 'success'
                });
            else
                this.$message({
                    message: '服务器错误：\n' + response.data,
                    type: 'error'
                });
            this.$refs.upload.clearFiles()
        }
    },
    mounted: function () {
        this.getPaperList();
        this.$message({
            showClose: true,
            message: '提示：通讯作者匹配前需完成作者匹配',
            duration: 5 * 1000
        });
    }
});