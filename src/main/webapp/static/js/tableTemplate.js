let app = new Vue({
    el: '#app',
    data: {
        urls: {
            // api for entity
            insertEntity: 'api/.../entity/insert',
            deleteEntityListByIds: 'api/.../entity/deleteListByIds',
            updateEntity: 'api/.../entity/update',
            selectEntityListByPage: 'api/.../entity/getListByPage',
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
        insertEntity: function () {
            // 首先检测表单数据是否合法
            this.$refs['form_insertEntity'].validate((valid) => {
                if (valid) {
                    let data = this.dialog.insertEntity.formData;
                    let app = this;
                    app.dialog.insertEntity.loading = true;
                    ajaxPostJSON(app.urls.insertEntity, data, function (d) {
                        app.dialog.insertEntity.loading = false;
                        app.dialog.insertEntity.visible = false;
                        window.parent.app.showMessage('添加成功！', 'success');
                        app.refreshTable_entity(); // 添加完成后刷新页面
                    }, function () {
                        app.dialog.insertEntity.loading = false;
                        app.dialog.insertEntity.visible = false;
                        window.parent.app.showMessage('添加失败！', 'error');
                    });
                } else {
                    console.log("表单数据不合法！");
                    return false;
                }
            });
        },
        deleteEntityListByIds: function (val) {
            if (val.length === 0) {
                window.parent.app.showMessage('提示：未选中任何用户', 'warning');
                return;
            }
            window.parent.app.$confirm('确认删除选中的角色', '警告', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                let data = val;
                let app = this;
                app.fullScreenLoading = true;
                ajaxPostJSON(this.urls.deleteEntityListByIds, data, function (d) {
                    app.fullScreenLoading = false;
                    window.parent.app.showMessage('删除成功！', 'success');
                    app.refreshTable_entity();
                })
            }).catch(() => {
                window.parent.app.showMessage('已取消删除', 'warning');
            });
        },
        updateEntity: function () {
            // 首先检测表单数据是否合法
            this.$refs['form_updateEntity'].validate((valid) => {
                if (valid) {
                    let data = this.dialog.updateEntity.formData;
                    let app = this;
                    app.dialog.updateEntity.loading = true;
                    ajaxPostJSON(app.urls.updateEntity, data, function (d) {
                        app.dialog.updateEntity.loading = false;
                        app.dialog.updateEntity.visible = false;
                        window.parent.app.showMessage('编辑成功！', 'success');
                        app.refreshTable_entity(); // 编辑完成后刷新页面
                    }, function () {
                        app.dialog.updateEntity.loading = false;
                        app.dialog.updateEntity.visible = false;
                        window.parent.app.showMessage('编辑失败！', 'error');
                    });
                } else {
                    console.log("表单数据不合法！");
                    return false;
                }
            });
        },
        selectEntityListByPage: function () {
            let data = {page: this.table.entity.params};
            let app = this;
            app.table.entity.loading = true;
            ajaxPostJSON(this.urls.selectEntityListByPage, data, function (d) {
                app.table.entity.loading = false;
                app.table.entity.data = d.data.resultList;
                app.table.entity.params.total = d.data.total;
            });
        },
        // 刷新entity table数据
        refreshTable_entity: function(){
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
    },
    mounted: function () {
        this.refreshTable_entity();
    }
});