<%--
  Created by IntelliJ IDEA.
  User: zm
  Date: 2019/4/23
  Time: 10:55
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>作者详情</title>
    <%@include file="/WEB-INF/views/include/blankHead.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/tableTemplate.css"/>
    <%--<link rel="stylesheet" href="/static/css/"/>--%>
    <style>
        .el-tabs--border-card > .el-tabs__content {
            padding: 0;
        }
    </style>
</head>
<body>
<div id="app" style="background: white;height: 100%;overflow: hidden;" v-cloak v-loading="fullScreenLoading">
    <el-tabs id="tabs"
             :tab-position="tabPosition"
             v-model="docSelected"
             type="border-card">

        <%--1.论文Tab--%>
        <el-tab-pane name="paper" label="论文">
            <el-main style="padding: 10px 0;">
                <%-- 顶栏 --%>
                <div style="margin-left: 10px">
                    <span class="button-group">
                        <el-button size="small" type="danger"
                                   @click="deletePaperListByIds(table.paperTable.entity.selectionList)"
                                   style="margin-left: 10px;">
                            <span>论文-批量删除</span>
                        </el-button>
                    </span>
                    <span style="float: right;margin-right: 10px;">
                        <el-input size="small" placeholder="输入论文名称" suffix-icon="el-icon-search"
                                  style="width: 250px;margin-right: 10px;"
                                  v-model="table.paperTable.entity.params.searchKey"
                                  @keyup.enter.native="table.paperTable.entity.params.pageIndex=1;refreshTable_paper()">
                        </el-input>
                        <el-button size="small" type="primary" style="position:relative;"
                                   @click="table.paperTable.entity.params.pageIndex=1;refreshTable_paper()">
                            <span>搜索</span>
                        </el-button>
                    </span>
                </div>
                <%-- entity表格 --%>
                <el-table :data="table.paperTable.entity.data"
                          id="paperTable"
                          ref="multipleTable"
                          v-loading="table.paperTable.entity.loading"
                          height="calc(100% - 130px)"
                          style="width: 100%;overflow-y: hidden;margin-top: 20px;"
                          class="scroll-bar"
                          @selection-change="table.paperTable.entity.selectionList=$event"
                          stripe>
                    <el-table-column type="selection" width="40"></el-table-column>
                    <el-table-column
                            prop="paperName"
                            width="220"
                            align="center"
                            fixed="left"
                            label="论文名"
                            show-overflow-tooltip>
                    </el-table-column>
                    <el-table-column
                            prop="issn"
                            align="center"
                            fixed="left"
                            width="120"
                            label="ISSN">
                    </el-table-column>

                    <%--2019-08-15 add--%>
                    <%--<el-table-column
                            align="center"
                            fixed="left"
                            width="120"
                            label="期刊年份">
                        <template slot-scope="{row}">
                            <template v-if="row.journalYear == null || row.journalYear == ''">
                                <el-button type="danger" size="mini" style="position:relative;bottom: 1px;margin-left: 6px;">
                                    <span>暂无期刊年份</span>
                                </el-button>
                            </template>
                            <template v-else>
                                {{row.journalYear}}
                            </template>
                        </template>
                    </el-table-column>--%>
                    <el-table-column
                            align="center"
                            fixed="left"
                            width="80"
                            label="分区">
                        <template slot-scope="{row}">
                            <template v-if="row.journalDivision == null || row.journalDivision == ''">
                                <el-button type="danger" size="mini" style="position:relative;bottom: 1px;margin-left: 6px;">
                                    <span>暂无分区</span>
                                </el-button>
                            </template>
                            <template v-else>
                                {{row.journalDivision}}
                            </template>
                        </template>
                    </el-table-column>
                    <el-table-column
                            align="center"
                            fixed="left"
                            width="100"
                            label="影响因子">
                        <template slot-scope="{row}">
                            <template v-if="row.impactFactor == null || row.impactFactor == ''">
                                <el-button type="danger" size="mini" style="position:relative;bottom: 1px;margin-left: 6px;">
                                    <span>暂无影响因子</span>
                                </el-button>
                            </template>
                            <template v-else>
                                {{row.impactFactor}}
                            </template>
                        </template>
                    </el-table-column>

                    <el-table-column
                            prop="danweiCn"
                            align="center"
                            width="150"
                            label="所属学院"
                            show-overflow-tooltip>
                    </el-table-column>
                    <el-table-column
                            prop="docType"
                            align="center"
                            width="100"
                            label="论文种类">
                    </el-table-column>
                    <el-table-column
                            prop="publishDate"
                            align="center"
                            width="120"
                            label="出版日期">
                    </el-table-column>
                    <el-table-column
                            prop="firstAuthorName"
                            align="center"
                            width="120"
                            label="第一作者">
                    </el-table-column>
                    <el-table-column
                            prop="firstAuthorId"
                            align="center"
                            width="160"
                            label="第一作者工号">
                    </el-table-column>
                    <el-table-column
                            prop="firstAuthorType"
                            align="center"
                            width="80"
                            label="第一作者类型">
                        <template slot-scope="{row}">
                            <template v-if="row.firstAuthorType == 'student'">
                                学生
                            </template>
                            <template v-else-if="row.firstAuthorType == 'teacher'">
                                导师
                            </template>
                            <template v-else>
                                博士后
                            </template>
                        </template>
                    </el-table-column>
                    <el-table-column
                            prop="secondAuthorName"
                            align="center"
                            width="120"
                            label="第二作者">
                    </el-table-column>
                    <el-table-column
                            prop="secondAuthorId"
                            align="center"
                            width="160"
                            label="第二作者工号">
                    </el-table-column>
                    <el-table-column
                            prop="secondAuthorType"
                            align="center"
                            width="80"
                            label="第二作者类型">
                        <template slot-scope="{row}">
                            <template v-if="row.secondAuthorType == 'student'">
                                学生
                            </template>
                            <template v-else-if="row.secondAuthorType == 'teacher'">
                                导师
                            </template>
                            <template v-else>
                                博士后
                            </template>
                        </template>
                    </el-table-column>
                    <el-table-column
                            prop="storeNum"
                            width="230"
                            align="center"
                            label="入藏号">
                    </el-table-column>
                    <el-table-column
                            prop="authorList"
                            width="300"
                            align="center"
                            show-overflow-tooltip
                            label="作者列表">
                    </el-table-column>
                    <el-table-column
                            label="操作"
                            width="100"
                            fixed="right"
                            align="center">
                        <template slot-scope="scope">
                            <el-button type="danger" size="mini" style="position:relative;bottom: 1px;margin-left: 6px;"
                                       @click="deletePaperListByIds([{id: scope.row.id}])">
                                <span>删除论文</span>
                            </el-button>
                        </template>
                    </el-table-column>
                </el-table>
                <%-- entity分页 --%>
                <el-pagination style="text-align: center;margin: 8px auto;"
                               @size-change="onPageSizeChange_paper"
                               @current-change="onPageIndexChange_paper"
                               :current-page="table.paperTable.entity.params.pageIndex"
                               :page-sizes="table.paperTable.entity.params.pageSizes"
                               :page-size="table.paperTable.entity.params.pageSize"
                               :total="table.paperTable.entity.params.total"
                               layout="total, sizes, prev, pager, next, jumper">
                </el-pagination>

            </el-main>
        </el-tab-pane>

        <%--2.专利Tab--%>
        <el-tab-pane name="patent" label="专利">
            <el-main style="padding: 10px 0;">
                <%-- 顶栏 --%>
                <div style="margin-left: 10px">
                    <span class="button-group">
                        <el-button size="small" type="danger"
                                   @click="deletePatentByIds(table.patentTable.entity.selectionList)"
                                   style="margin-left: 10px;">
                            <span>专利-批量删除</span>
                        </el-button>
                    </span>
                    <span style="float: right;margin-right: 10px;">
                        <el-input size="small" placeholder="输入专利名称" suffix-icon="el-icon-search"
                                  style="width: 250px;margin-right: 10px;"
                                  v-model="table.patentTable.entity.params.searchKey"
                                  @keyup.enter.native="table.patentTable.entity.params.pageIndex=1;refreshTable_patent()">
                        </el-input>
                        <el-button size="small" type="primary" style="position:relative;"
                                   @click="table.patentTable.entity.params.pageIndex=1;refreshTable_patent()">
                            <span>搜索</span>
                        </el-button>
                    </span>
                </div>
                <%-- entity表格 --%>
                <el-table :data="table.patentTable.entity.data"
                          id="patentTable"
                          ref="multipleTable"
                          v-loading="table.patentTable.entity.loading"
                          height="calc(100% - 130px)"
                          style="width: 100%;overflow-y: hidden;margin-top: 20px;"
                          class="scroll-bar"
                          @selection-change="table.patentTable.entity.selectionList=$event"
                          stripe>
                    <template slot="empty">
                        <img class="data-pic" src="/static/ima" alt="" />
                    </template>
                    <el-table-column type="selection" width="40"></el-table-column>
                    <el-table-column
                            prop="patentName"
                            width="250"
                            align="center"
                            fixed="left"
                            label="专利名"
                            show-overflow-tooltip>
                    </el-table-column>
                    <el-table-column
                            prop="patentNumber"
                            align="center"
                            width="100"
                            fixed="left"
                            label="专利号">
                    </el-table-column>
                    <el-table-column
                            prop="institute"
                            align="center"
                            width="200"
                            label="所属学院">
                    </el-table-column>
                    <el-table-column
                            prop="patentType"
                            align="center"
                            width="100"
                            label="专利类型">
                    </el-table-column>
                    <el-table-column
                            prop="patentAuthorizationDateString"
                            align="center"
                            width="120"
                            label="专利授权日">
                    </el-table-column>
                    <el-table-column
                            prop="patentRightPerson"
                            align="center"
                            width="120"
                            label="专利权人">
                    </el-table-column>
                    <el-table-column
                            prop="firstAuthorName"
                            align="center"
                            width="120"
                            label="第一作者">
                    </el-table-column>
                    <el-table-column
                            prop="firstAuthorWorkId"
                            align="center"
                            width="160"
                            label="第一作者工号">
                    </el-table-column>
                    <el-table-column
                            align="center"
                            width="160"
                            label="第一作者类型">
                        <template slot-scope="{row}">
                            <template v-if="row.firstAuthorType == 'student'">
                                学生
                            </template>
                            <template v-else-if="row.firstAuthorType == 'teacher'">
                                导师
                            </template>
                            <template v-else>
                                博士后
                            </template>
                        </template>
                    </el-table-column>
                    <el-table-column
                            align="center"
                            width="120"
                            label="第二作者">
                        <template slot-scope="{row}">
                            <template v-if="row.secondAuthorName == '' || row.secondAuthorName == null">
                                <el-button type="primary" size="mini">暂无第二作者</el-button>
                            </template>
                            <template v-else>
                                {{row.secondAuthorName}}
                            </template>
                        </template>
                    </el-table-column>
                    <el-table-column
                            align="center"
                            width="160"
                            label="第二作者工号">
                        <template slot-scope="{row}">
                            <template v-if="row.secondAuthorWorkId == '' || row.secondAuthorWorkId == null">
                                <el-button type="primary" size="mini">暂无第二作者</el-button>
                            </template>
                            <template v-else>
                                {{row.secondAuthorWorkId}}
                            </template>
                        </template>
                    </el-table-column>
                    <el-table-column
                            align="center"
                            width="160"
                            label="第二作者类型">
                        <template slot-scope="{row}">
                            <template
                                    v-if="row.secondAuthorType == '' || row.secondAuthorType == null"
                                    key="keySecondAuthorType0">
                                <el-button type="primary" size="mini">暂无第二作者</el-button>
                            </template>
                            <template v-else
                                      key="keySecondAuthorType1">
                                <template
                                        key="keySecondAuthorType2"
                                        v-if="row.secondAuthorType == 'student'">
                                    学生
                                </template>
                                <template
                                        key="keySecondAuthorType3"
                                        v-else-if="row.secondAuthorType == 'teacher'">
                                    导师
                                </template>
                                <template
                                        key="keySecondAuthorType4"
                                        v-else>
                                    博士后
                                </template>
                            </template>
                        </template>
                    </el-table-column>
                    <el-table-column
                            prop="authorList"
                            width="260"
                            align="center"
                            show-overflow-tooltip
                            label="作者列表">
                    </el-table-column>

                    <el-table-column
                            label="操作"
                            width="100"
                            fixed="right"
                            align="center">
                        <template slot-scope="scope">
                            <el-button type="danger" size="mini" style="position:relative;bottom: 1px;margin-left: 6px;"
                                       @click="deletePatentByIds([{id: scope.row.id}])">
                                <span>删除专利</span>
                            </el-button>
                        </template>
                    </el-table-column>
                </el-table>
                <%-- entity分页 --%>
                <el-pagination style="text-align: center;margin: 8px auto;"
                               @size-change="onPageSizeChange_patent"
                               @current-change="onPageIndexChange_patent"
                               :current-page="table.patentTable.entity.params.pageIndex"
                               :page-sizes="table.patentTable.entity.params.pageSizes"
                               :page-size="table.patentTable.entity.params.pageSize"
                               :total="table.patentTable.entity.params.total"
                               layout="total, sizes, prev, pager, next, jumper">
                </el-pagination>
            </el-main>
        </el-tab-pane>
    </el-tabs>
</div>

<%@include file="/WEB-INF/views/include/blankScript.jsp" %>
<%--<script src="/static/js/"></script>--%>
<script>
    var app = new Vue({
        el: '#app',
        data: {
            /*当前激活的折叠面板*/
            activeNames: ['1'],
            /*分页位置*/
            tabPosition: 'top',
            /*绑定当前的表格*/
            docSelected: "paper",
            urls: {
                paper: {
                    insertPaper: '',
                    deletePaperListByIds: '/api/doc/paper/deleteListByIds',
                    updatePaper: '',
                    selectPaperListByPage: '/api/paper/selectMyPaperByPage',
                },
                patent: {
                    insertPaper: '',
                    deletePatentByIds: '/api/patent/deleteListByIds',
                    updatePaper: '',
                    selectMyPatentListByPage: '/api/patent/selectMyPatentByPage',
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
                            total: 0,       // 总数
                        }
                    }
                },
                patentTable: {
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
                }
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
            },
            /*------- 论文部分函数 end  ------*/


            /*------- 专利部分函数 start ------*/
            selectMyPatentListByPage: function () {
                // 1.docPatent.firstAuthorId暂存作者id
                // 2.docPatent.secondAuthorId暂存作者工号
                // 3.docPatent.page存贮所需分页
                let docPatent = {
                    firstAuthorId: "${author.id}",
                    secondAuthorId: "${author.workId}",
                    page: this.table.patentTable.entity.params
                };
                let app = this;
                app.table.patentTable.entity.loading = true;
                ajaxPostJSON(this.urls.patent.selectMyPatentListByPage, docPatent, function (d) {
                    console.log("查询patent返回：");
                    console.log(d.data.resultList);

                    let resList = d.data.resultList;
                    /*处理日期*/
                    /*for (let i = 0; i < resList.length; i++) {
                        tmpDate = resList[i].patentAuthorizationDate;
                        resList[i].patentAuthorizationDate = dateFormat(tmpDate);
                    }*/
                    app.table.patentTable.entity.data = resList;
                    app.table.patentTable.entity.params.total = d.data.total;
                    app.table.patentTable.entity.loading = false;
                });
            },
            //根据ids删除专利
            deletePatentByIds: function (ids) {
                let app = this;
                if (ids.length === 0) {
                    window.parent.app.showMessage('提示：未选中任何项', 'warning');
                    return;
                }
                window.parent.app.showConfirm(function () {
                    let data = ids;
                    app.table.patentTable.entity.loading = true;
                    ajaxPostJSON(app.urls.patent.deletePatentByIds, data, function (d) {
                        app.table.patentTable.entity.loading = false;
                        window.parent.app.showMessage('删除成功！', 'success');
                        app.selectMyPatentListByPage();
                    })
                });
            },
            // 刷新patent_table数据
            refreshTable_patent: function () {
                this.selectMyPatentListByPage();
            },
            // 处理patent的pageSize变化
            onPageSizeChange_patent: function (newSize) {
                this.table.patentTable.entity.params.pageSize = newSize;
                this.refreshTable_patent();
            },
            // 处理patent的pageIndex变化
            onPageIndexChange_patent: function (newIndex) {
                this.table.patentTable.entity.params.pageIndex = newIndex;
                this.refreshTable_patent();
            },
            /*------- 专利部分函数 end ------*/

            // 重置表单
            /*resetForm: function (ref) {
                this.$refs[ref].resetFields();
            },*/
        },
        /*加载的时候就执行一次*/
        mounted: function () {
            this.refreshTable_paper();
            this.refreshTable_patent();
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
</script>
</body>
</html>