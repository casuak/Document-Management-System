let app = new Vue({
    el: '#app',
    data: {
        urls: {
            // api for entity
            selectEntityListByPage: '/api/sys/user/selectListByPage',
            selectDanweiNicknamesAllList: '/api/doc/danweiNicknames/selectAllList',
            selectAuthor: '/api/doc/paper/selectAuthor'
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
        filterParams: {
            userType: '', // 用户类型
            school: '', // 所属单位
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
        danweiList: []
    },
    methods: {
        selectEntityListByPage: function () {
            let data = this.filterParams;
            data.page = this.table.entity.params;
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
        selectUser: function (workId) {
            let data = {
                paperId: pageParams.paperId,
                authorIndex: pageParams.authorIndex,
                authorWorkId: workId
            };
            let app = this;
            app.fullScreenLoading = true;
            ajaxPost(this.urls.selectAuthor, data, function (d) {
                app.fullScreenLoading = false;
                window.parent.parent.app.showMessage('选择成功！', 'success');
                window.parent.app.getPaperList();
                window.parent.app.searchUserDialog.visible = false;
            });
        }
    },
    mounted: function () {
        // get user list
        let data = this.filterParams;
        data.page = this.table.entity.params;
        let app = this;
        app.table.entity.loading = true;
        ajaxPostJSON(this.urls.selectEntityListByPage, data, function (d) {
            app.table.entity.data = d.data.resultList;
            app.table.entity.params.total = d.data.total;
            // get school list
            ajaxPostJSON(app.urls.selectDanweiNicknamesAllList, null, function (d) {
                app.danweiList = d.data;
                app.table.entity.loading = false;
            });
        });
    }
});