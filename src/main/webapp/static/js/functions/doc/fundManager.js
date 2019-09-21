var defaultUpdateDialog = {
    visible: false,
    loading: false,
    data: {
        id: '',
        projectYear: '',
        projectName: '',
        projectMoney: ''
    }
};

var defaultMatchDialog = {
    visible: false,
    loading: false,
    fundId: '',
    searchId: '',
    searchName: '',
    table: []
};

var app = new Vue({
        el: '#app',
        data: {
            loading: {
                fullScreen: false,
                table: false
            },
            status: '-1',   // 默认状态
            statusList: [
                {
                    value: '-1',
                    label: '1.未初始化'
                },
                {
                    value: '0',
                    label: '2.未匹配'
                },
                {
                    value: '1',
                    label: '3.1 匹配出错'
                },
                {
                    value: '2',
                    label: '3.2 匹配成功'
                },
                {
                    value:'3',
                    label:'4.匹配完成'
                }
            ],
            fundList: [],
            selectionList: [],  // 已选中的基金列表
            page: {
                pageIndex: 1,
                pageSize: 10,
                pageSizes: [5, 10, 20, 40],
                searchKey: '',  // 搜索词
                total: 0       // 总数
            },
            urls: {
                initFirst: '/api/doc/fund/initFirst',
                getFundList: '/api/doc/fund/list',
                deleteFundByIds: '/api/doc/fund/deleteByIds',
                deleteFundByStatus: '/api/doc/fund/deleteFundByStatus',
                initAllFund: '/api/doc/fund/initAllFund',
                matchUserFund: '/api/doc/fund/matchUserFund',
                updateFund: '/api/doc/fund/updateFund',
                searchForMatch: '/api/doc/fund/searchForMatch',
                matchFund: '/api/doc/fund/matchFund',
                completeFundByStatus:'/api/doc/fund/completeFundByStatus',
                completeFundByChoice:'/api/doc/fund/completeFundByChoice'
            },
            updateDialog: defaultUpdateDialog,
            matchDialog: defaultMatchDialog
        },
        methods: {}
    })
;

//更新状态为-1
function init() {
    ajaxPostJSON(app.urls.initFirst, null, null, null);
}

//获取基金列表
function getFundList() {
    let data = {
        page: app.page,
        status: app.status
    };
    app.loading.table = true;
    ajaxPostJSON(app.urls.getFundList, data, function (d) {
        app.loading.table = false;
        app.fundList = d.data.resultList;
        app.page.total = d.data.total;
    });
}

//根据ids删除基金
function deleteFundByIds(ids) {
    if (ids.length === 0) {
        window.parent.app.showMessage('请先选择需要删除的基金！', 'warning');
        return;
    }
    window.parent.app.showConfirm(function () {
        let data = ids;
        app.loading.table = true;
        ajaxPostJSON(app.urls.deleteFundByIds, data, function (d) {
            app.loading.table = false;
            window.parent.app.showMessage('删除成功！', 'success');
            getFundList();
        })
    });
}

//根据status删除基金
function deleteFundByStatus() {
    window.parent.app.showConfirm(function () {
        app.loading.table = true;
        let data = {
            status: app.status
        };
        ajaxPost(app.urls.deleteFundByStatus, data, function (d) {
            app.loading.table = false;
            getFundList();
            window.parent.app.showMessage("删除成功");
        })
    });
}

//初始化基金
function initAllFund() {
    window.parent.app.showConfirm(() => {
        app.loading.table = true;
    ajaxPost(app.urls.initAllFund, null, function (d) {
        app.loading.table = false;
        app.status = '0';
        getFundList();
    }, null)
});
}

//匹配
function matchUserFund() {
    window.parent.app.showConfirm(() => {
        app.loading.table = true;
    ajaxPost(app.urls.matchUserFund, null, function (d) {
        app.loading.table = false;
        app.status = '2';
        getFundList();
    })
});
}

//显示更新对话框
function showUpdateDialog(v) {
    app.updateDialog.data.id = v["id"];
    app.updateDialog.data.projectYear = v["projectYear"];
    app.updateDialog.data.projectName = v["projectName"];
    app.updateDialog.data.projectMoney = v["projectMoney"];

    app.updateDialog.visible = true;
}

//重置更新对话框
function resetDialogData() {
    app.updateDialog.data.id = '';
    app.updateDialog.data.projectYear = '';
    app.updateDialog.data.projectName = '';
    app.updateDialog.data.projectMoney = '';
}

//更新信息
function updateFund() {
    let data = {
        id: app.updateDialog.data.id,
        projectYear: app.updateDialog.data.projectYear,
        projectName: app.updateDialog.data.projectName,
        projectMoney: app.updateDialog.data.projectMoney,

    };
    app.loading.table = true;
    ajaxPostJSON(app.urls.updateFund, data, function (d) {
        app.updateDialog.loading = false;
        app.updateDialog.visible = false;
        app.$message({
            message: "操作成功",
            type: "success"
        });
        resetDialogData();
        getFundList();
    });
}

//更新匹配选项
function searchForMatch() {
    app.matchDialog.loading = true;
    $.ajax({
        type: "POST",
        url: app.urls.searchForMatch,
        data: {
            id: app.matchDialog.searchId,
            name: app.matchDialog.searchName
        },
        success: function (result) {
            app.matchDialog.loading = false;
            app.matchDialog.table = result;
        },
        error: function (result) {
            console.log(result)
        }
    });
}

//显示匹配对话框
function showMatchDialog(v) {
    clearMatchDialog();

    app.matchDialog.fundId = v["id"];
    app.matchDialog.searchId = v["personWorkId"];
    app.matchDialog.searchName = v["personName"];
    searchForMatch();

    app.matchDialog.visible = true;
}

//清空匹配对话框
function clearMatchDialog() {
    app.matchDialog.fundId = '';
    app.matchDialog.searchId = '';
    app.matchDialog.searchName = '';
    app.matchDialog.table = [];
}

//匹配
function matchFund(v) {
    let data = {
        id: app.matchDialog.fundId,
        personName: v["realName"],
        personWorkId: v["workId"],
        personId: v["id"]
    };
    app.matchDialog.loading = true;
    ajaxPostJSON(app.urls.matchFund, data, function (d) {
        app.matchDialog.loading = false;
        app.matchDialog.visible = false;
        app.$message({
            message: "操作成功",
            type: "success"
        });
        clearMatchDialog();
        getFundList();
    });
}

//全部完成
function completeFundByStatus(){
    window.parent.app.showConfirm(() => {
        app.loading.table = true;
    ajaxPost(app.urls.completeFundByStatus, null, function (d) {
        app.loading.table = false;
        app.status = '3';
        getFundList();
    })
});
}

//选择完成
function complete(v){
    app.loading.table=true;
    ajaxPostJSON(app.urls.completeFundByChoice,v,function () {
        app.loading.table=false;
        getFundList();
    })
}

window.onload = function () {
    init();
    getFundList();
};