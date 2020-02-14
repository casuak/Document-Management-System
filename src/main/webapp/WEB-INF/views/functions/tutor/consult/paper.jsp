<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>test</title>
    <%@include file="/WEB-INF/views/include/blankHead.jsp" %>
    <link rel="stylesheet" href="/static/css/functions/tutor/paper.css"/>
    <style>
        .el-tabs--border-card > .el-tabs__content {
            padding: 0;
        }
        .el-dialog{
            width: 1200px;
        }
    </style>
</head>
<body>
<div id="app" style="background: white;height: 100%;overflow: hidden;" v-cloak v-loading="fullScreenLoading">
    <el-main style="padding: 10px 0;">
    <%-- 顶栏 --%>
    <div style="margin-left: 10px">
        <span class="button-group">
            <el-button size="small" type="warning"
                       @click="openSearchUser"
                       style="margin-left: 10px;">
                <span>论文认领</span>
            </el-button>
              <el-button size="small" type="success"
                         @click="openSearchUserHistory"
                         style="margin-left: 10px;">
                <span>认领记录</span>
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
            <%--<el-table-column--%>
                    <%--label="操作"--%>
                    <%--width="100"--%>
                    <%--fixed="right"--%>
                    <%--align="center">--%>
                <%--<template slot-scope="scope">--%>
                    <%--<el-button type="danger" size="mini" style="position:relative;bottom: 1px;margin-left: 6px;"--%>
                               <%--@click="deletePaperListByIds([{id: scope.row.id}])">--%>
                        <%--<span>删除论文</span>--%>
                    <%--</el-button>--%>
                <%--</template>--%>
            <%--</el-table-column>--%>
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
        <%-- 论文认领 --%>
        <el-dialog title="论文认领" :visible.sync="searchPaperDialog.visible" class="dialog-searchUser">
            <div v-loading="searchPaperDialog.loading" style="height: 550px;">
                <iframe v-if="searchPaperDialog.visible" :src="searchPaperUrl"
                        style="width: 100%;height: 550px;overflow-y: auto;border: 0;"
                        @load="searchPaperDialog.loading=false;"></iframe>
            </div>
        </el-dialog>


        <%-- 论文认领记录 --%>
        <el-dialog title="认领记录" :visible.sync="searchPaperHistoryDialog.control.visible" class="dialog-searchUser">
            <div v-loading="searchPaperHistoryDialog.control.loading" style="height: 550px;">
                <iframe v-if="searchPaperHistoryDialog.control.visible" :src="searchPaperHistoryDialog.url"
                        style="width: 100%;height: 550px;overflow-y: auto;border: 0;"
                        @load="searchPaperHistoryDialog.control.loading=false;"></iframe>
            </div>
        </el-dialog>
</el-main>
</div>
</body>
<%@include file="/WEB-INF/views/include/blankScript.jsp" %>
<script>
    // 接收页面初始化参数
    let pageParams = {};
    pageParams.workId = '${author.workId}';
</script>
<script src="${pageContext.request.contextPath}/static/js/functions/tutor/consult/paper.js"></script>
</html>
