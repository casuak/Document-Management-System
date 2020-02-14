<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>ssm</title>
    <%@include file="/WEB-INF/views/include/blankHead.jsp" %>
    <link rel="stylesheet" href="/static/css/functions/tutor/ClaimPaper.css"/>
</head>
<body>
<div id="app" v-cloak style="background: white;height: 100%;overflow: hidden;" v-loading="fullScreenLoading">
    <%--&lt;%&ndash; 顶栏 &ndash;%&gt;--%>
    <%--<div style="padding: 0 10px 0 10px;height: 20px;">--%>
        <%--<span style="float: right;margin-right: 10px;">--%>
            <%--<el-input size="small" placeholder="请输入论文wos编号" suffix-icon="el-icon-search"--%>
                      <%--style="width: 200px;margin-right: 10px;" v-model="filterParams.storeNum"--%>
                      <%--@keyup.enter.native="table.entity.params.pageIndex=1;refreshTable_entity()">--%>
            <%--</el-input>--%>
            <%--<el-button size="small" type="primary" style="position:relative;"--%>
                       <%--@click="table.entity.params.pageIndex=1;refreshTable_entity()">--%>
                <%--<span>搜索</span>--%>
            <%--</el-button>--%>
        <%--</span>--%>
    <%--</div>--%>
        <%-- 表格 --%>
        <el-table :data="table.entity.data"
                  id="paperTable"
                  ref="multipleTable"
                  v-loading="table.entity.loading"
                  height="calc(100% - 100px)"
                  style="width: 100%;overflow-y: hidden;margin-top: 20px;"
                  class="scroll-bar"
                  @selection-change="table.entity.selectionList=$event"
                  stripe>
            <el-table-column
                    prop="tutorPaper[0].paperName"
                    width="240"
                    align="center"
                    fixed="left"
                    label="论文名"
                    show-overflow-tooltip>
            </el-table-column>
            <el-table-column
                    prop="paperWosId"
                    width="230"
                    fixed="left"
                    align="center"
                    label="入藏号">
            </el-table-column>
            <el-table-column
                    prop="createDate"
                    width="100"
                    fixed="left"
                    align="center"
                    label="申请时间">
            </el-table-column>

            <el-table-column
                    prop="firstAuthorName"
                    align="center"
                    width="120"
                    label="第一作者">
            </el-table-column>
            <el-table-column
                    prop="firstAuthorSchool"
                    align="center"
                    width="160"
                    label="第一作者学院">
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
                    prop="secondAuthorSchool"
                    align="center"
                    width="160"
                    label="第二作者学院">
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
                    prop="status"
                    width="100"
                    align="center"
                    fixed="left"
                    label="申请状态">
                <template slot-scope="{row}">
                    <template v-if="row.status == 1">
                        <el-button size ="small" type="success">认领成功</el-button>
                    </template>
                    <template v-else-if="row.status == 0">
                        <el-button size ="small" type="warning">正在申请</el-button>
                    </template>
                    <template v-else-if="row.status == -1">
                        <el-button size ="small" type="error">申请失败</el-button>
                    </template>
                </template>
            </el-table-column>

            <el-table-column
                    prop="remarks"
                    width="200"
                    align="center"
                    label="备注">
            </el-table-column>
            <%--<el-table-column--%>
                    <%--label="操作"--%>
                    <%--width="100"--%>
                    <%--fixed="right"--%>
                    <%--align="center">--%>
                <%--<template slot-scope="{row, $index}">--%>
                    <%--<el-button type="success"  @click="claimPaper(row,$index)" size="mini" style="position:relative;bottom: 1px;margin-left: 6px;">--%>
                        <%--<span>认领论文</span>--%>
                    <%--</el-button>--%>
                <%--</template>--%>
            <%--</el-table-column>--%>
        </el-table>
    <%-- entity分页 --%>
    <el-pagination style="text-align: center;margin: 8px auto;"
                   @size-change="onPageSizeChange_entity"
                   @current-change="onPageIndexChange_entity"
                   :current-page="table.entity.params.pageIndex"
                   :page-sizes="table.entity.params.pageSizes"
                   :page-size="table.entity.params.pageSize"
                   :total="table.entity.params.total"
                   layout="total, sizes, prev, pager, next, jumper">
    </el-pagination>
</div>
<%@include file="/WEB-INF/views/include/blankScript.jsp"%>
<script>
    // 接收页面初始化参数
    let pageParams = {};
    pageParams.ownerWorkId = '${workId}';
</script>
<script src="/static/js/functions/tutor/consult/ClaimPaperHistory.js"></script>
</body>
</html>