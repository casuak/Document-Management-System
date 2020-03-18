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
            searchUser:'/tutor/goSearchUser',
            doPaperClaim:'/tutor/doTutorClaim'
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
        expands: [],
        searchUserDialog: {
            control: {
                visible: false,
                loading: false
            },
            url:''
        },

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
                    tmpDate=resList[i].tutorPaper[0].publishDate;
                    resList[i].tutorPaper[0].publishDate=dateFormat(tmpDate);
                }
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
        },
        getRowKeys(row) {
            return row.id;
        },
        openSearchUser: function (props, authorIndex, authorName, school) {
            console.log(props, authorIndex, authorName, school);
            this.searchUserDialog.url = this.urls.searchUser + "?paperId=" + props.row.tutorPaper[0].id +
                "&authorIndex=" + authorIndex + '&searchKey=' + authorName + ';'
                + '&school=' + (school ? school : '')
                +'&publishDate=' + ReDateFormate(props.row.tutorPaper[0].publishDate)
                +'&paperIndex='+props.$index
                + '&workId=';
            this.searchUserDialog.control.visible = true;
            this.searchUserDialog.control.loading = true;
        },
        clearAuthor: function (paper, authorIndex) {
            let app = this;
            window.parent.app.showConfirm(function () {
                if (authorIndex === 1)
                    paper.firstAuthorId = null;
                else
                    paper.secondAuthorId = null;
            });
        },
        doTutorClaim:function (row,status) {
            let app = this;
            app.table.entity.loading = true;
            let data=row;
            data.status=status;
            console.log(data);
            ajaxPostJSON(this.urls.doPaperClaim, data, function (d) {
                app.table.entity.loading = false;
                app.$message({
                    message:'处理成功！',
                    type:'success'
                })
                app.refreshTable_entity();
            },function error(d) {
                app.table.entity.loading = false;
                app.$message({
                    message:'处理失败',
                    type:'error'
                })
            })
        },
        /** 处理备注编辑函数*/
        loseFocus:function(index, row) {
            row.seen=false;
        },
        cellClick:function(row, column) {
            if(column.label !== '备注'){
                console.log(1);
                row.seen=false;
            }else{
                row.seen=true;
            }

        }
    },
    mounted: function () {
        this.refreshTable_entity();
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

/**
 * @return {number}
 */
function ReDateFormate(riqi) {
// 可以这样做
    var date = new Date(riqi.replace(/-/g, '/'));
    return date.getTime();
}

function setAuthorBySelect(workId,name,school,type,authorIndex,paperIndex) {
    let tmpData=app.table.entity.data;
    if (authorIndex === 1) {
        tmpData[paperIndex].tutorPaper[0].firstAuthorId = workId;
        tmpData[paperIndex].tutorPaper[0].firstAuthorCname = name;
        tmpData[paperIndex].tutorPaper[0].firstAuthorSchool = school;
        tmpData[paperIndex].tutorPaper[0].firstAuthorType = type;
    } else if (authorIndex === 2) {
        tmpData[paperIndex].tutorPaper[0].secondAuthorId = workId;
        tmpData[paperIndex].tutorPaper[0].secondAuthorCname = name;
        tmpData[paperIndex].tutorPaper[0].secondAuthorSchool = school;
        tmpData[paperIndex].tutorPaper[0].secondAuthorType = type;
    }
    app.table.entity.data=tmpData;
    console.log( app.table.entity.data)
    app.searchUserDialog.control.visible = false;
}