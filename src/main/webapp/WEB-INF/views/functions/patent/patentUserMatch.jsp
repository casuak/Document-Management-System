<%--
  Created by IntelliJ IDEA.
  User: zm
  Date: 2019/7/3
  Time: 8:43
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>ssm</title>
    <%@include file="/WEB-INF/views/include/blankHead.jsp" %>
    <%--<link rel="stylesheet" href="/static/css/functions/patent/patentUserMatch.css"/--%>
    <style>
        /* table左边的checkbox */
        .el-checkbox {
            margin: 0px;
            margin-left: 2px;
        }

        /* 设置table行高 */
        .el-table th > .cell {
            height: 40px;
            line-height: 40px;
        }

        /* 设置table行高 */
        .el-table__row .cell {
            height: 44px;
            line-height: 44px;
        }

        td {
            border: 1px solid #e2e2e2 !important;
        }

        .el-table--enable-row-transition .el-table__body td, .el-table td, .el-table th {
            padding: 0px;
        }

        .el-table--enable-row-transition .el-table__body td, .el-table td, .el-table th {
            /*border: 0px !important;*/
        }

        .el-table__fixed-right-patch {
            background: #DCDCDC !important;
        }

        .el-table th.is-leaf {
            background: aliceblue !important;
        }

        .el-button--mini {
            font-size: 11px;
            padding: 6px 8px;
        }

        .dialog-searchUser .el-dialog {
            width: 900px;
        }

        .dialog-searchUser .el-dialog__body {
            padding: 0;
        }

        /* 弹窗 */
        .el-dialog {
            width: 654px;
            margin-top: 30px !important;
        }
    </style>
</head>
<body>
<div id="app" v-cloak v-loading="loading.fullScreen">
    <%-- 顶栏 --%>
    <div style="padding: 15px 20px 6px 15px;">
        <span class="button-group">
            <el-button size="small" type="danger" @click="deleteByIds(selectionList)">
                批量删除
            </el-button>
            <el-button size="small" type="warning" @click="deleteByStatus()">
                全部删除
            </el-button>
            <el-button size="small" type="primary" @click="initPapers()" v-if="status === '-1'">
                初始化
            </el-button>
            <el-button size="small" type="primary" @click="paperUserMatch()" v-if="status === '0'">
                自动匹配
            </el-button>
            <el-button size="small" type="primary" @click="completePapers()" v-if="status === '2'">
                全部完成
            </el-button>
        </span>
        <span style="float: right;margin-right: 10px;">
            <el-select v-model="status" size="small" style="margin-right: 10px;" @change="getPaperList()">
                <el-option v-for="status in statusList" :label="status.label"
                           :value="status.value" :key="status.value"></el-option>
            </el-select>
            <el-input size="small" placeholder="请输入论文名搜索相关论文" suffix-icon="el-icon-search"
                      style="width: 250px;margin-right: 10px;" v-model="page.searchKey"
                      @keyup.enter.native="getPaperList()">
            </el-input>
            <el-button size="small" type="primary" @click="getPaperList()">
                搜索
            </el-button>
        </span>
    </div>
</div>
<%@include file="/WEB-INF/views/include/blankScript.jsp" %>
<script type="text/javascript">
    var app = new Vue({
        el: '#app',
        data: {
            loading: {
                fullScreen: false,
                table: false
            },
            status: '1',   // current status
            statusList: [
                {
                    value: '-1',
                    label: '1. 未初始化'
                },
                {
                    value: '-3',
                    label: '2.1 作者信息缺失'
                },
                {
                    value: '-2',
                    label: '2.2 专利权人不是北理被过滤'
                },
                {
                    value: '0',
                    label: '2.2 初始化完成(未匹配)'
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
                    value: '3',
                    label: '3.3 需要人工判断'
                },
                {
                    value: '4',
                    label: '4. 匹配完成'
                }
            ],
            patentList: [],
            selectionList: [],  // the selected patentList
            page: {
                pageIndex: 1,
                pageSize: 10,
                pageSizes: [5, 10, 20, 40],
                searchKey: '',  // 搜索词
                total: 0,       // 总数
            },
            urls: {
                // api for entity
                deletePatentByIds: '/api/patent/deleteListByIds',
                getPatentList: '/api/patent/selectListByPage',
                initPatent: '/api/patent/initAllPatent',
                deleteByStatus: '/api/patent/deleteByStatus',
                patentUserMatch: '/api/patent/patentUserMatch',
                searchUser: '/functions/doc/paperUserMatch/searchUser',
                selectAuthor: '/api/patent/selectAuthor'
                /*deleteByIds: '/api/doc/paper/deleteListByIds',
                getPaperList: '/api/doc/paper/selectListByPage',
                initPapers: '/api/doc/paper/initAll',
                deleteByStatus: '/api/doc/paper/deleteByStatus',
                paperUserMatch: '/api/doc/paper/paperUserMatch',
                convertToSuccessByIds: '/api/doc/paper/convertToSuccessByIds',
                searchUser: '/functions/doc/paperUserMatch/searchUser',
                selectAuthor: '/api/doc/paper/selectAuthor'*/
            },
            searchUserDialog: {
                visible: false,
                loading: false,
            },
            searchUserUrl: ''
        },
        methods: {
            deletePatentByIds: function (ids) {
                let app = this;
                window.parent.app.showConfirm(function () {
                    let data = ids;
                    app.loading.table = true;
                    ajaxPostJSON(app.urls.deleteByIds, data, function (d) {
                        app.loading.table = false;
                        window.parent.app.showMessage('删除成功！', 'success');
                        app.getPaperList();
                    })
                });
            },
            convertToSuccessByIds: function (ids) {
                let app = this;
                window.parent.app.showConfirm(function () {
                    let data = ids;
                    app.loading.table = true;
                    ajaxPostJSON(app.urls.convertToSuccessByIds, data, function (d) {
                        app.loading.table = false;
                        window.parent.app.showMessage('操作成功！', 'success');
                        app.getPaperList();
                    }, function (d) {
                        app.loading.table = false;
                        window.parent.app.showMessage('操作失败！', 'error');
                    })
                });
            },
            deleteByStatus: function () {
                let app = this;
                window.parent.app.showConfirm(function () {
                    app.loading.table = true;
                    let data = {
                        status: app.status
                    };
                    ajaxPost(app.urls.deleteByStatus, data, function (d) {
                        app.loading.table = false;
                        app.getPaperList();
                        window.parent.app.showMessage("删除成功");
                    })
                });
            },
            getPaperList: function () {
                let data = {
                    page: this.page,
                    status: this.status
                };
                let app = this;
                app.loading.table = true;
                ajaxPostJSON(this.urls.getPaperList, data, function (d) {
                    app.loading.table = false;
                    app.paperList = d.data.resultList;
                    app.page.total = d.data.total;
                })
            },
            // init papers where status = '-1'
            initPapers: function () {
                let app = this;
                window.parent.app.showConfirm(() = > {
                    app.loading.table = true;
                ajaxPost(app.urls.initPapers, null, function (d) {
                    app.loading.table = false;
                    app.status = '0';
                    app.getPaperList();
                })
            })
                ;
            },
            // match user where status = '0'
            paperUserMatch: function () {
                let app = this;
                window.parent.app.showConfirm(() = > {
                    app.loading.table = true;
                ajaxPost(app.urls.paperUserMatch, null, function (d) {
                    app.loading.table = false;
                    app.status = '1';
                    app.getPaperList();
                })
            })
                ;
            },
            // complete papers where status = '2'
            completePapers: function () {
                let data = {
                    status: this.status
                };
            },
            // 打开选择用户对话框: targetAuthorIndex (1 - firstAuthor, 2 - secondAuthor)
            openSearchUser: function (row, authorIndex, authorName, workId) {
                this.searchUserUrl = this.urls.searchUser + "?paperId=" + row.id +
                    "&authorIndex=" + authorIndex + '&searchKey=' + authorName + ';'
                    + '&school=' + (row.danweiCN ? row.danweiCN : '') + '&publishDate=' + row.publishDate + '&workId=' + workId;
                this.searchUserDialog.visible = true;
                this.searchUserDialog.loading = true;
            },
            // 清空作者
            clearAuthor: function (paper, authorIndex) {
                let app = this;
                window.parent.app.showConfirm(function () {
                    let data = {
                        paperId: paper.id,
                        authorIndex: authorIndex,
                        authorWorkId: null
                    };
                    app.loading.table = true;
                    ajaxPost(this.urls.selectAuthor, data, function (d) {
                        app.loading.table = false;
                        if (authorIndex === 1)
                            paper.firstAuthorId = null;
                        else
                            paper.secondAuthorId = null;
                    })
                });
            }
        },
        mounted: function () {
            this.getPaperList();
        }
    });
</script>
</body>
</html>
