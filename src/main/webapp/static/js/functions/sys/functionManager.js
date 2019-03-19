let app = new Vue({
    el: '#app',
    data: {
        urls: {
            updateFunction: '/api/sys/function/update',
            appendCategory: '/api/sys/function/appendCategory',
            appendFunction: '/api/sys/function/appendFunction',
            deleteFunction: '/api/sys/function/delete',
            getCategoryList: '/api/sys/function/getCategoryList',
            updateCategoryList: '/api/sys/function/updateCategoryList',
        },
        tree: [], // 功能树
        treeProp: {
            label: 'name',
            children: 'functionList'
        },
        treeLoading: false,
        form: {
            visible: false,
            type: 'function',
            type_cn: '功能',
            data: {},
            loading: false
        },
        icons: [],
        dialog: {
            selectIcon: {
                visible: false
            }
        }
    },
    methods: {
        // 上传表单（保存对分类或功能的修改）
        submitForm: function () {
            let data = copy(this.form.data);
            let app = this;
            app.form.loading = true;
            ajaxPostJSON(this.urls.updateFunction, data, function (d) {
                window.parent.app.showMessage('更新成功!', 'success');
                app.form.visible = false;
                app.treeLoading = false;
                app.form.loading = false;
                if (app.form.type === 'category') {
                    app.tree[data.index] = data;
                    app.tree.push({});
                    app.tree.pop();
                } else if (app.form.type === 'function') {
                    for (let i = 0; i < app.tree.length; i++) {
                        if (app.tree[i].id === data.parentId) {
                            app.tree[i].functionList[data.index] = data;
                            app.tree[i].functionList.push({});
                            app.tree[i].functionList.pop();
                            break;
                        }
                    }
                }
            });
        },
        // 打开编辑表单
        openEditForm: function (node) {
            let app = this;
            app.form.visible = true;
            app.form.loading = true;
            app.treeLoading = true;
            app.form.loading = false;
            if (node.type === 1) {
                app.form.type = 'function';
                app.form.type_cn = '功能';
            } else if (node.type === 0) {
                app.form.type = 'category';
                app.form.type_cn = '分类';
            }
            app.form.data = copy(node);
        },
        // 添加分类（添加至末尾）
        addCategory: function () {
            let data = {
                index: this.tree.length
            };
            let app = this;
            app.treeLoading = true;
            ajaxPostJSON(this.urls.appendCategory, data, function (d) {
                window.parent.app.showMessage('添加成功', 'success');
                let category = copy(d.data);
                category.functionList = [];
                app.tree.push(category);
                app.treeLoading = false;
            })
        },
        // 添加功能到某个分类下
        addFunction: function (category) {
            let data = copy(category);
            let app = this;
            app.treeLoading = true;
            console.log(category);
            ajaxPostJSON(this.urls.appendFunction, data, function (d) {
                let newFunction = copy(d.data);
                window.parent.app.showMessage('添加成功', 'success');
                app.tree[data.index].functionList.push(newFunction);
                app.treeLoading = false;
            })
        },
        // 删除分类或功能
        deleteFunctionOrCategory: function (_node, node) {
            window.parent.app.$confirm('确认删除: ' + node.name, '警告', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                let data = [];
                if (node.type === 0) {  //删除分类
                    for (let i = node.index; i < this.tree.length; i++) {
                        let category = copy(this.tree[i]);
                        category.index -= 1;
                        data.push(category);
                    }
                    let app = this;
                    app.treeLoading = true;
                    ajaxPostJSON(this.urls.deleteFunction, data, function (d) {
                        app.treeLoading = false;
                        if (d.code === 'success') {
                            window.parent.app.showMessage('删除成功', 'success');
                            app.tree.splice(node.index, 1);
                            for (let i = node.index; i < app.tree.length; i++) {
                                app.tree[i].index -= 1;
                            }
                        } else {
                            window.parent.app.showMessage('删除失败', 'error');
                        }
                    })
                } else if (node.type === 1) {   //删除功能
                    let parent = _node.parent.data;
                    for (let i = node.index; i < parent.functionList.length; i++) {
                        let func = copy(parent.functionList[i]);
                        func.index -= 1;
                        data.push(func);
                    }
                    let app = this;
                    app.treeLoading = true;
                    ajaxPostJSON(this.urls.deleteFunction, data, function (d) {
                        app.treeLoading = false;
                        if (d.code === 'success') {
                            console.log('删除成功');
                            parent.functionList.splice(node.index, 1);
                            for (let i = node.index; i < parent.functionList.length; i++) {
                                parent.functionList[i].index -= 1;
                            }
                        } else {
                            console.log('删除失败');
                        }
                    })
                }
            }).catch(() => {
                window.parent.app.showMessage('已取消删除', 'warning');
            });
        },
        handleDragStart: function (node, ev) {
            // console.log('drag start', node);
        },
        handleDragEnter: function (draggingNode, dropNode, ev) {
            // console.log('tree drag enter: ', dropNode.label);
        },
        handleDragLeave: function (draggingNode, dropNode, ev) {
            // console.log('tree drag leave: ', dropNode.label);
        },
        handleDragOver: function (draggingNode, dropNode, ev) {
            // console.log('tree drag over: ', dropNode.label);
        },
        handleDragEnd: function (draggingNode, dropNode, dropType, ev) {
            // console.log('tree drag end: ', dropNode && dropNode.label, dropType);
        },
        handleDrop: function (draggingNode, dropNode, dropType, ev) {
            let app = this;
            app.treeLoading = true;
            // 重设index
            for (let i = 0; i < this.tree.length; i++) {
                this.tree[i].index = i;
                for (let j = 0; j < this.tree[i].functionList.length; j++) {
                    this.tree[i].functionList[j].index = j;
                    this.tree[i].functionList[j].parentId = this.tree[i].id;
                }
            }
            ajaxPostJSON(this.urls.updateCategoryList, this.tree, function (d) {
                app.treeLoading = false;
                window.parent.app.showMessage('位置更新成功!', 'success');
            })
        },
        allowDrop: function (draggingNode, dropNode, type) {
            // 拖动节点为分类节点时
            if (draggingNode.data.type === 0) {
                // 只能将节点拖拽到其他分类节点的'prev' or 'next'
                if (type === 'inner') return false;
                return dropNode.data.type === 0;
            }
            // 拖动节点为功能节点时
            else if (draggingNode.data.type === 1) {
                // 只能将节点拖拽到其他功能节点的'prev' or 'next'或者分类节点的'inner'
                if (dropNode.data.type === 1)
                    return type !== 'inner';
                else if (dropNode.data.type === 0)
                    return type === 'inner';
            }
            return false;
        },
        allowDrag: function (draggingNode) {
            // 分类节点和功能节点都可拖拽
            return draggingNode.data.type === 1 || draggingNode.data.type === 0;
        }
    },
    mounted: function () {
        // 获取功能树
        let app = this;
        app.treeLoading = true;
        ajaxPost(this.urls.getCategoryList, null, function (d) {
            app.tree = copy(d.data);
            app.treeLoading = false;
            // 获取图标库
            ajaxGet("/static/plugins/font-awesome-4.7.0/tubiao.txt", null, function (d) {
                app.icons = JSON.parse(d).icons;
            })
        })
    }
});