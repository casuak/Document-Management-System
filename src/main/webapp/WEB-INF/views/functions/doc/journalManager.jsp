<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>ssm</title>
    <%@include file="/WEB-INF/views/include/blankHead.jsp" %>
    <link rel="stylesheet" href="/static/css/functions/doc/journalManager.css"/>
</head>
<body>
<div id="app" v-cloak style="background: white;height: 100%;overflow: hidden;" v-loading="fullScreenLoading">
    <%-- 顶栏 --%>
    <div style="padding: 15px 20px 0 15px;">
        <span class="button-group">
            <%--<el-button size="small" type="success" @click="">--%>
                <%--<span>操作</span>--%>
            <%--</el-button>--%>
            <el-button size="small" type="danger" @click="deleteByIds(table.selectionList)"
                       style="margin-left: 10px;">
                <span>批量删除</span>
            </el-button>
        </span>
        <span style="float: right;margin-right: 10px;">
            <el-input size="small" placeholder="请输入期刊名" suffix-icon="el-icon-search"
                      style="width: 250px;margin-right: 10px;" v-model="table.params.searchKey"
                      @keyup.enter.native="table.params.pageIndex=1;refreshTable()">
            </el-input>
            <el-button size="small" type="primary" style="position:relative;"
                       @click="table.params.pageIndex=1;refreshTable()">
                <span>搜索</span>
            </el-button>
        </span>
    </div>
    <%-- entity表格 --%>
    <el-table :data="table.data" height="calc(100% - 116px)" v-loading="table.loading"
              style="width: 100%;overflow-y: hidden;margin-top: 15px;" class="scroll-bar"
              @selection-change="onSelectionChange" stripe>
        <el-table-column type="selection" width="40"></el-table-column>
        <el-table-column label="期刊名" width="400" prop="journalTitle"></el-table-column>
        <el-table-column label="分区" width="100" prop="journalDivision" align="center"></el-table-column>
        <el-table-column label="年份" width="100" prop="journalYear" align="center">
            <template slot-scope="scope">
                {{ formatYear(scope.row.journalYear) }}
            </template>
        </el-table-column>
        <el-table-column label="影响因子" width="100" prop="impactFactor" align="center"></el-table-column>
        <el-table-column></el-table-column>
        <el-table-column label="操作" width="190" header-align="center" align="center">
            <template slot-scope="scope">
                <%--<el-button type="warning" size="mini" style="position:relative;bottom: 1px;"--%>
                           <%--@click="openDialog_updateEntity(scope.row)">--%>
                    <%--<span>编辑</span>--%>
                <%--</el-button>--%>
                <el-button type="danger" size="mini" style="position:relative;bottom: 1px;margin-left: 6px;"
                           @click="deleteByIds([{id: scope.row.id}])">
                    <span>删除</span>
                </el-button>
            </template>
        </el-table-column>
        <el-table-column width="50"></el-table-column>
    </el-table>
    <%-- 分页 --%>
    <el-pagination style="text-align: center;margin: 8px auto;"
                   @size-change="onPageSizeChange"
                   @current-change="onPageIndexChange"
                   :current-page="table.params.pageIndex"
                   :page-sizes="table.params.pageSizes"
                   :page-size="table.params.pageSize"
                   :total="table.params.total"
                   layout="total, sizes, prev, pager, next, jumper">
    </el-pagination>
</div>
<%@include file="/WEB-INF/views/include/blankScript.jsp" %>
<script src="/static/js/functions/doc/journalManager.js"></script>
</body>
</html>