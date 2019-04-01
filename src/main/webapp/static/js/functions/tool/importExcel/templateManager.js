app = new Vue({
    el: '#app',
    data: {
        urls: {
            // api for entity
            deleteEntityListByIds: '/api/tool/excelTemplate/deleteListByIds',
            selectEntityListByPage: '/api/tool/excelTemplate/selectListByPage',
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
        insertOrUpdateDialog: {
            visible: false,
            loading: false,
            src: 'null',
            title: '',
        },
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
            };
            let app = this;
            app.table.entity.loading = true;
            ajaxPostJSON(this.urls.selectEntityListByPage, data, function (d) {
                app.table.entity.loading = false;
                app.table.entity.data = d.data.resultList;
                app.table.entity.params.total = d.data.total;
            });
        },
        // 刷新entity table数据
        refreshTable_entity: function () {
            this.selectEntityListByPage();
        },
        // 打开添加或编辑窗口
        openInsertOrUpdateDialog: function (status, row) {
            this.insertOrUpdateDialog.src = "/functions/tool/importExcel/insertOrUpdateTemplate?status='" + status
                + "'&templateId=";
            if (status === 'insert') {
                this.insertOrUpdateDialog.src += "''";
                this.insertOrUpdateDialog.title = '新建模板';
            } else {
                this.insertOrUpdateDialog.src += "'" + row.templateId + "'";
                this.insertOrUpdateDialog.title = '编辑模板';
            }
            this.insertOrUpdateDialog.loading = true;
            this.insertOrUpdateDialog.visible = true;
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
    },
    mounted: function () {
        this.refreshTable_entity();
    }
});