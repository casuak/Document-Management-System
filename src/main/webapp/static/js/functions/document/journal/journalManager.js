var defaultUpdateDialog = {
    visible: false,
    loading: false,
    data: {
        id: '',
        journalTitle:'',
        journalDivision:'',
        journalYear:'',
        impactFactor:'',
        issn:''
    }
};

app = new Vue({
    el: '#app',
    data: {
        fullScreenLoading: false,
        urls: {
            getJournalList: '/api/doc/journal/list',
            deleteListByIds: '/api/doc/journal/deleteByIds',
            deleteAll: '/api/doc/journal/deleteAll',
            updateJournal:'/api/doc/journal/updateJournal'
        },
        table: {
            loading: false,
            selectionList: [],
            data: [],
            params: {
                searchKey: '',
                pageIndex: 1,
                pageSize: 10,
                pageSizes: [5, 10, 20, 40],
                total: 0
            }
        },
        updateDialog: defaultUpdateDialog,
        journalDivisionList:[
            {
                value:'Q1',
                label:'Q1'
            },
            {
                value:'Q2',
                label:'Q2'
            },
            {
                value:'Q3',
                label:'Q3'
            },
            {
                value:'Q4',
                label:'Q4'
            }
        ]
    },
    methods: {
        refreshTable: function () {
            let app = this;
            app.table.loading = true;
            let data = {
                page: app.table.params
            };
            ajaxPostJSON(this.urls.getJournalList, data, function (d) {
                app.table.loading = false;
                app.table.data = d.data.resultList;
                app.table.params.total = d.data.total;
            })
        },
        deleteByIds: function(journalList){
            if (journalList.length === 0) {
                window.parent.app.showMessage('提示：未选中任何项', 'warning');
                return;
            }
            let app = this;
            window.parent.app.$confirm('确认删除选中的项', '警告', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                let data = journalList;
                app.table.loading = true;
                ajaxPostJSON(app.urls.deleteListByIds, data, function (d) {
                    window.parent.app.showMessage('删除成功！', 'success');
                    app.refreshTable();
                })
            }).catch(() => {
                window.parent.app.showMessage('已取消删除', 'warning');
            });
        },
        deleteAll: function(){
            let app = this;
            window.parent.app.$confirm('确认删除选中的项', '警告', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                app.table.loading = true;
                ajaxPostJSON(this.urls.deleteAll, null, function (d) {
                    window.parent.app.showMessage('删除成功！', 'success');
                    app.refreshTable();
                })
            }).catch(() => {
                window.parent.app.showMessage('已取消删除', 'warning');
            });
        },
        // 打开编辑entity窗口
        openDialog_updateEntity: function (row) {
            this.dialog.updateEntity.visible = true;
            this.dialog.updateEntity.formData = copy(row);
        },
        // 处理选中的行变化
        onSelectionChange: function (val) {
            this.table.selectionList = val;
        },
        // 处理pageSize变化
        onPageSizeChange: function (newSize) {
            this.table.params.pageSize = newSize;
            this.refreshTable();
        },
        // 处理pageIndex变化
        onPageIndexChange: function (newIndex) {
            this.table.params.pageIndex = newIndex;
            this.refreshTable();
        },
        // 重置表单
        resetForm: function (ref) {
            this.$refs[ref].resetFields();
        },
        // 格式化时间为年份
        formatYear: function(timestamp){
            let date = new Date(timestamp);
            return date.Format("yyyy");
        },
        //清空对话框
        clearUpdateDialog: function () {
            this.updateDialog.data.id = '';
            this.updateDialog.data.journalDivision = '';
            this.updateDialog.data.journalTitle = '';
            this.updateDialog.data.journalYear = '';
            this.updateDialog.data.impactFactor = '';
            this.updateDialog.data.issn = '';
        },
        //显示对话框
        showUpdateDialog: function (v) {
            this.clearUpdateDialog();

            this.updateDialog.data.id = v['id'];
            this.updateDialog.data.journalDivision = v['journalDivision'];
            this.updateDialog.data.journalTitle = v['journalTitle'];
            this.updateDialog.data.journalYear = v['journalYear'];
            this.updateDialog.data.impactFactor = v['impactFactor'];
            this.updateDialog.data.issn = v['issn'];

            this.updateDialog.visible = true;
        },
        //更新信息
        updateJournal:function () {
            let data = {
                id: this.updateDialog.data.id,
                journalDivision: this.updateDialog.data.journalDivision,
                journalTitle: this.updateDialog.data.journalTitle,
                journalYear: this.updateDialog.data.journalYear,
                impactFactor: this.updateDialog.data.impactFactor,
                issn: this.updateDialog.data.issn
            };
            app.updateDialog.loading = true;
            ajaxPostJSON(app.urls.updateJournal, data, function (d) {
                app.updateDialog.loading = false;
                app.updateDialog.visible = false;
                app.$message({
                    message: "操作成功",
                    type: "success"
                });
                app.refreshTable();
            });
        }
    },
    mounted: function(){
        this.refreshTable();
    }
});