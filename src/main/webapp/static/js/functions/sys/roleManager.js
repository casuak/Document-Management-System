let app = new Vue({
    el: '#app',
    data: {
        urls: {
            getRoleListByPage: '/api/sys/role/getListByPage',
            updateRoleFunction: '/api/sys/map/roleFunction/update',
            deleteRoleByIdList: '/api/sys/role/deleteByIdList',
            getCategoryListByRole: '/api/sys/function/getCategoryListByRole',
            getCategoryList: '/api/sys/function/getCategoryList',
            putRole: '/api/sys/role/put',
        },
        fullScreenLoading: false,
        table: {
            data: [],
            loading: false,
            selectionList: [],
            params: {
                pageIndex: 1,
                pageSize: 10,
                pageSizes: [5, 10, 20, 40],
                searchKey: '',  // 搜索词
                total: 2,       // 总数
            }
        },
        dialog: {
            add: {
                visible: false,
                loading: false,
                formData: {},
                rules: {},
            },
            edit: {
                visible: false,
                loading: false,
                formData: {},
                rules: {},
            },
            functionEdit: {
                visible: false,
                loading: false,
                functionTree: [],
                treeProps: {
                    label: 'name',
                    children: 'functionList'
                },
                currentRole: ''
            }
        },
        options: {},
        functionTree: []
    },
    methods: {
        // 处理选中的行变化
        handleSelectionChange: function (val) {
            this.table.selectionList = val;
        },
        // 处理pageSize变化
        handleSizeChange: function (newSize) {
            this.table.params.pageSize = newSize;
            this.getRoleList();
        },
        // 处理pageIndex变化
        handleCurrentChange: function (newIndex) {
            this.table.params.pageIndex = newIndex;
            this.getRoleList();
        },
        // 刷新table的数据
        getRoleList: function () {
            let data = {page: this.table.params};
            let app = this;
            app.table.loading = true;
            ajaxPostJSON(this.urls.getRoleListByPage, data, function (d) {
                app.table.loading = false;
                app.table.data = d.data.resultList;
                app.table.params.total = d.data.total;
            });
        },
        // 添加信息提交
        submitAddForm: function () {
            // 首先检测表单数据是否合法
            this.$refs['form_add'].validate((valid) => {
                if (valid) {
                    let data = this.dialog.add.formData;
                    let app = this;
                    app.dialog.add.loading = true;
                    ajaxPostJSON(app.urls.putRole, data, function (d) {
                        app.dialog.add.loading = false;
                        app.dialog.add.visible = false;
                        window.parent.app.showMessage('添加成功！', 'success');
                        app.getRoleList(); // 添加完成后刷新页面
                    }, function () {
                        app.dialog.add.loading = false;
                        app.dialog.add.visible = false;
                        window.parent.app.showMessage('添加失败！', 'error');
                    });
                } else {
                    console.log("表单数据不合法！");
                    return false;
                }
            });
        },
        // 编辑角色信息提交
        submitEditForm: function () {
            // 首先检测表单数据是否合法
            this.$refs['form_edit'].validate((valid) => {
                if (valid) {
                    let url = this.rootUrl + 'edit';
                    let data = this.dialog.edit.formData;
                    let app = this;
                    app.dialog.edit.loading = true;
                    ajaxPostJSON(url, data, function (d) {
                        app.dialog.edit.loading = false;
                        app.dialog.edit.visible = false;
                        window.parent.app.showMessage('编辑成功！', 'success');
                        app.getRoleList(); // 编辑完成后刷新页面
                    }, function () {
                        app.dialog.edit.loading = false;
                        app.dialog.edit.visible = false;
                        window.parent.app.showMessage('编辑失败！', 'error');
                    });
                } else {
                    console.log("表单数据不合法！");
                    return false;
                }
            });
        },
        // 编辑角色功能提交
        submitEditFunction: function () {
            let data = this.dialog.functionEdit.currentRole;
            data.functionList = this.$refs.tree.getCheckedNodes();
            let tmp = this.$refs.tree.getHalfCheckedNodes();
            tmp.forEach(function (val, index) {
                data.functionList.push(val);
            });
            let app = this;
            app.dialog.functionEdit.loading = true;
            ajaxPostJSON(this.urls.updateRoleFunction, data, function (d) {
                app.dialog.functionEdit.loading = false;
                window.parent.app.showMessage('修改成功!', 'success');
            })
        },
        // 重置表单
        resetForm: function (ref) {
            this.$refs[ref].resetFields();
        },
        // 删除指定id的用户
        delete: function (val, type = 'multi') {
            // 未选中任何用户的情况下点选批量删除
            if (type === 'multi' && val.length === 0) {
                window.parent.app.showMessage('提示：未选中任何用户', 'warning');
                return;
            }
            window.parent.app.$confirm('确认删除选中的角色', '警告', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                let idList = [];
                if (type === 'single') {
                    let id = val;
                    idList.push(id);
                } else {
                    let selectionList = val;
                    for (let i = 0; i < selectionList.length; i++) {
                        idList.push(selectionList[i].id);
                    }
                }
                let data = {
                    idList: idList
                };
                let app = this;
                app.fullScreenLoading = true;
                ajaxPost(this.urls.deleteRoleByIdList, data, function (d) {
                    app.fullScreenLoading = false;
                    window.parent.app.showMessage('删除成功！', 'success');
                    app.getRoleList();
                })
            }).catch(() => {
                window.parent.app.showMessage('已取消删除', 'warning');
            });
        },
        // 打开编辑窗口
        openEditDialog: function (row) {
            this.dialog.edit.visible = true;
            this.dialog.edit.formData = copy(row);
        },
        // 打开编辑角色功能窗口
        openFunctionDialog: function (row) {
            this.dialog.functionEdit.visible = true;
            // 获取用户拥有的角色树
            this.dialog.functionEdit.currentRole = copy(row);
            let data = {
                id: row.id
            };
            let app = this;
            app.dialog.functionEdit.loading = true;
            ajaxPostJSON(this.urls.getCategoryListByRole, data, function (d) {
                // 赋予选择
                let tree = copy(app.functionTree);
                app.dialog.functionEdit.functionTree = tree;
                let idList = [];
                for (let i = 0; i < d.data.length; i++) {
                    if (d.data[i].functionList.length === 0)
                        idList.push(d.data[i].id);
                    for (let j = 0; j < d.data[i].functionList.length; j++) {
                        idList.push(d.data[i].functionList[j].id);
                    }
                }
                app.$refs.tree.setCheckedKeys(idList);
                app.dialog.functionEdit.loading = false;
            })
        }
    },
    mounted: function () {
        // 首先获取所有功能
        let data = null;
        let app = this;
        app.fullScreenLoading = true;
        ajaxPost(this.urls.getCategoryList, data, function (d) {
            app.fullScreenLoading = false;
            app.functionTree = d.data;
            app.getRoleList();
        });
    }
});

$(document).ready(function () {

});