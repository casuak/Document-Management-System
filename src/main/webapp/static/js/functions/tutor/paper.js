var app = new Vue({
    el: '#app',
    data: {
        /*绑定当前的表格*/
        docSelected: "paper",
        urls: {
            paper: {
                insertPaper: '',
                deletePaperListByIds: '/api/doc/paper/deleteListByIds',
                updatePaper: '',
                selectPaperListByPage: '/api/paper/selectMyPaperByPage'
            }
        },
        fullScreenLoading: false,
        table: {
            paperTable: {
                entity: {
                    data: [],
                    loading: false,
                    selectionList: [],
                    params: {
                        pageIndex: 1,
                        pageSize: 10,
                        pageSizes: [5, 10, 20, 40],
                        searchKey: '',  // 搜索词
                        total: 0       // 总数
                    }
                }
            },
        },
        dialog: {
            insertPaper: {
                visible: false,
                loading: false,
                formData: {},
                rules: {},
            },
            updatePaper: {
                visible: false,
                loading: false,
                formData: {},
                rules: {},
            },
        },
        options: {},
    },
    methods: {
        /*折叠面板绑定事件*/
        handleCollapseChange(val) {
            console.log(val);
        },

        /*------- 论文部分函数 start ------*/
        insertPaper: function () {
            // 首先检测表单数据是否合法
            this.$refs['form_insertPaper'].validate((valid) => {
                if (valid) {
                    let data = this.dialog.insertPaper.formData;
                    let app = this;
                    app.dialog.insertPaper.loading = true;
                    ajaxPostJSON(app.urls.paper.insertPaper, data, function (d) {
                        app.dialog.insertPaper.loading = false;
                        app.dialog.insertPaper.visible = false;
                        window.parent.app.showMessage('添加成功！', 'success');
                        app.refreshTable_paper(); // 添加完成后刷新页面
                    }, function () {
                        app.dialog.insertPaper.loading = false;
                        app.dialog.insertPaper.visible = false;
                        window.parent.app.showMessage('添加失败！', 'error');
                    });
                } else {
                    console.log("表单数据不合法！");
                    return false;
                }
            });
        },
        deletePaperListByIds: function (val) {
            if (val.length === 0) {
                window.parent.app.showMessage('提示：未选中任何项', 'warning');
                return;
            }
            window.parent.app.$confirm('确认删除选中的项', '警告', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                let data = val;
                let app = this;
                app.fullScreenLoading = true;
                ajaxPostJSON(this.urls.paper.deletePaperListByIds, data, function (d) {
                    app.fullScreenLoading = false;
                    window.parent.app.showMessage('删除成功！', 'success');
                    app.refreshTable_paper();
                })
            }).catch(() => {
                window.parent.app.showMessage('已取消删除', 'warning');
            });
        },
        updatePaper: function () {
            // 首先检测表单数据是否合法
            this.$refs['form_updatePaper'].validate((valid) => {
                if (valid) {
                    let data = this.dialog.updatePaper.formData;
                    let app = this;
                    app.dialog.updatePaper.loading = true;
                    ajaxPostJSON(app.urls.paper.updatePaper, data, function (d) {
                        app.dialog.updatePaper.loading = false;
                        app.dialog.updatePaper.visible = false;
                        window.parent.app.showMessage('编辑成功！', 'success');
                        app.refreshTable_paper(); // 编辑完成后刷新页面
                    }, function () {
                        app.dialog.updatePaper.loading = false;
                        app.dialog.updatePaper.visible = false;
                        window.parent.app.showMessage('编辑失败！', 'error');
                    });
                } else {
                    console.log("表单数据不合法！");
                    return false;
                }
            });
        },
        //获取当前作者的论文List
        selectPaperListByPage: function () {
            let data = {
                theAuthorWorkId: "${author.workId}",                        //借用authorList来暂存一下authorId
                page: this.table.paperTable.entity.params
            };
            let app = this;
            app.table.paperTable.entity.loading = true;
            ajaxPostJSON(this.urls.paper.selectPaperListByPage, data, function (d) {
                console.log("查询paper返回：");
                console.log(d.data.resultList);
                app.table.paperTable.entity.loading = false;
                /*处理日期*/
                let resList = d.data.resultList;
                for (let i = 0; i < resList.length; i++) {
                    tmpDate1 = resList[i].publishDate;
                    //tmpDate2 = resList[i].journalYear;
                    resList[i].publishDate = dateFormat(tmpDate1);
                    //resList[i].journalYear = dateFormat(tmpDate2);
                }
                app.table.paperTable.entity.data = resList;
                app.table.paperTable.entity.params.total = d.data.total;
            });
        },
        // 刷新paper table数据
        refreshTable_paper: function () {
            this.selectPaperListByPage();
        },
        // 打开编辑paper窗口
        openDialog_updatePaper: function (row) {
            this.dialog.updatePaper.visible = true;
            this.dialog.updatePaper.formData = copy(row);
        },
        // 处理paper的pageSize变化
        onPageSizeChange_paper: function (newSize) {
            this.table.paperTable.entity.params.pageSize = newSize;
            this.refreshTable_paper();
        },
        // 处理paper的pageIndex变化
        onPageIndexChange_paper: function (newIndex) {
            this.table.paperTable.entity.params.pageIndex = newIndex;
            this.refreshTable_paper();
        }
    },
    /*加载的时候就执行一次*/
    mounted: function () {
        this.refreshTable_paper();

    }
});

function add0(m) {
    return m < 10 ? '0' + m : m
}

//格式化时间
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

//获取app高度
function getAppHeight() {
    return document.getElementById("app").clientHeight;
}

//设置el-main的高度
function setMainHeight() {
    let mains = document.getElementsByClassName("el-main");
    let appHeight = getAppHeight();
    for (let i = 0; i < mains.length; i++) {
        console.log(getAppHeight());
        mains[i].style.height = appHeight + "px";
    }
}

window.onload = function () {
    setMainHeight();
};

window.onresize = function () {
    setMainHeight();
};
