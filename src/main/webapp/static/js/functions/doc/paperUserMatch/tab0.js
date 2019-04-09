let app = new Vue({
    el: '#app',
    data: {
        urls: {
            // api for entity
            insertEntity: '/api/sys/role/insert',
            deleteEntityListByIds: '/api/doc/paper/deleteListByIds',
            updateEntity: '/api/sys/role/update',
            selectEntityListByPage: '/api/doc/paper/selectListByPage',
            initAllPaper: '/api/doc/paper/initAll',
            deleteAllListNotInitial: '/api/doc/paper/deleteByStatus'
        },
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
        dialog: {
            insertEntity: {
                visible: false,
                loading: false,
                formData: {},
                rules: {},
            },
            updateEntity: {
                visible: false,
                loading: false,
                formData: {},
                rules: {},
            },
        },
        options: {},
    },
    methods: {
        deleteEntityListByIds: function (val) {
            if (val.length === 0) {
                window.parent.parent.app.showMessage('提示：未选中任何项', 'warning');
                return;
            }
            window.parent.parent.app.$confirm('确认删除选中的项', '警告', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                let data = val;
                let app = this;
                app.fullScreenLoading = true;
                ajaxPostJSON(this.urls.deleteEntityListByIds, data, function (d) {
                    app.fullScreenLoading = false;
                    window.parent.parent.app.showMessage('删除成功！', 'success');
                    app.refreshTable_entity();
                })
            }).catch(() => {
                window.parent.parent.app.showMessage('已取消删除', 'warning');
            });
        },
        selectEntityListByPage: function () {
            let data = {
                page: this.table.entity.params,
                status: '-1'
            };
            let app = this;
            app.table.entity.loading = true;
            ajaxPostJSON(this.urls.selectEntityListByPage, data, function (d) {
                app.table.entity.loading = false;
                app.table.entity.data = d.data.resultList;
                app.table.entity.params.total = d.data.total;
            });
        },
        // 初始化
        initAllPaper: function () {
            let app = this;
            app.fullScreenLoading = true;
            ajaxPost(app.urls.initAllPaper, null, function (d) {
                app.fullScreenLoading = false;
                app.refreshTable_entity();
            })
        },
        // 刷新entity table数据
        refreshTable_entity: function () {
            this.selectEntityListByPage();
        },
        // 打开编辑entity窗口
        openDialog_updateEntity: function (row) {
            this.dialog.updateEntity.visible = true;
            this.dialog.updateEntity.formData = copy(row);
        },
        // 处理选中的行变化
        onSelectionChange_entity: function (val) {
            this.table.entity.selectionList = val;
        },
        // 处理pageSize变化
        onPageSizeChange_entity: function (newSize) {
            this.table.entity.params.pageSize = newSize;
            this.refreshTable_entity();
        },
        // 处理pageIndex变化
        onPageIndexChange_entity: function (newIndex) {
            this.table.entity.params.pageIndex = newIndex;
            this.refreshTable_entity();
        },
        // 重置表单
        resetForm: function (ref) {
            this.$refs[ref].resetFields();
        },
        deleteAllListNotInitial: function () {
            let app = this;
            window.parent.parent.app.showConfirm('警告', '确认删除所有未初始化的论文', 'error',
                function () {
                    app.fullScreenLoading = true;
                    let data = {
                        status: '-1'
                    };
                    ajaxPost(app.urls.deleteAllListNotInitial, data, function (d) {
                        app.fullScreenLoading = false;
                        app.refreshTable_entity();
                        window.parent.parent.app.showMessage("删除成功");
                    })
                }, function () {});
        }
    },
    mounted: function () {
        this.refreshTable_entity();
    }
});