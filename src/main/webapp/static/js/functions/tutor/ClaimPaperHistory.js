let app = new Vue({
    el: '#app',
    data: {
        paperInfo: {
            publishDate: 0
        },
        urls: {
            // api for entity
            selectEntityListByPage: '/tutor/getTutorClaimHistory',
            selectDanweiNicknamesAllList: '/api/doc/danweiNicknames/selectAllList',

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
            ownerWorkId:''
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
        orgOption:[],
        danweiList: [],
        expands: []
    },
    methods: {
        selectEntityListByPage: function () {
            let data = this.filterParams;
            data.page = this.table.entity.params;
            let app = this;
            app.table.entity.loading = true;
            ajaxPostJSON(this.urls.selectEntityListByPage, data, function (d) {
                let resList = d.data.resultList;
                for (let i = 0; i < resList.length; i++) {
                    tmpDate = resList[i].createDate;
                    resList[i].createDate = dateFormat(tmpDate);
                }
                console.log(resList)
                app.table.entity.loading = false;
                app.table.entity.data = resList;
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
        }


    },
    mounted: function () {
      this.refreshTable_entity();
      this.filterParams.ownerWorkId=pageParams.ownerWorkId;
    }
});

function dateFormat(shijianchuo) {
    //时间戳是整数，否则要parseInt转换
    let time = new Date(shijianchuo);
    let y = time.getFullYear();
    let m = time.getMonth() + 1;
    let d = time.getDate() + 1;
    let h = time.getHours() + 1;
    let mm = time.getMinutes() + 1;
    let s = time.getSeconds() + 1;
    //return y + '-' + add0(m) + '-' + add0(d) + ' ' + add0(h) + ':' + add0(mm) + ':' + add0(s);
    return y + '-' + add0(m) + '-' + add0(d);
}

function add0(m) {
    return m < 10 ? '0' + m : m
}

