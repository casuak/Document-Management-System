<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>模板管理</title>
    <%@include file="/WEB-INF/views/include/blankHead.jsp" %>
    <link rel="stylesheet" href="/static/css/functions/tool/importExcel/templateManager.css"/>
</head>
<body>
<div id="app" v-cloak style="background: white;height: 100%;overflow: hidden;" v-loading="fullScreenLoading">
    <%-- 顶栏 --%>
    <div style="padding: 10px 20px 0 15px;">
        <span class="button-group">
            <el-button size="small" type="success" @click="openInsertOrUpdateDialog('insert', null)">
                <span>新建模板</span>
            </el-button>
            <el-button size="small" type="danger" @click="deleteEntityListByIds(table.entity.selectionList)"
                       style="margin-left: 10px;">
                <span>批量删除</span>
            </el-button>
        </span>
        <span style="float: right;margin-right: 10px;">
            <el-input size="small" placeholder="请输入模板名搜索相关模板" suffix-icon="el-icon-search"
                      style="width: 250px;margin-right: 10px;" v-model="table.entity.params.searchKey"
                      @keyup.enter.native="table.entity.params.pageIndex=1;refreshTable_entity()">
            </el-input>
            <el-button size="small" type="primary" style="position:relative;"
                       @click="table.entity.params.pageIndex=1;refreshTable_entity()">
                <span>搜索</span>
            </el-button>
        </span>
    </div>
    <%-- entity表格 --%>
    <el-table :data="table.entity.data" height="calc(100% - 116px)" v-loading="table.entity.loading"
              style="width: 100%;overflow-y: hidden;margin-top: 10px;" class="scroll-bar"
              @selection-change="onSelectionChange_entity" stripe>
        <el-table-column type="selection" width="40"></el-table-column>
        <el-table-column label="模板名" min-width="40" prop="templateName"></el-table-column>
        <el-table-column label="导入表名" min-width="40" prop="tableName"></el-table-column>
        <el-table-column label="excel模板文件" min-width="40" prop="excelName">
            <template slot-scope="{row}">
                <a :href="'/api/tool/file/downloadExcelTemplate?excelName='
                + row.excelName + '&downloadName=' + row.templateName">{{ row.excelName }}</a>
            </template>
        </el-table-column>
        <el-table-column label="操作" width="190" header-align="center" align="center">
            <template slot-scope="scope">
                <el-button type="warning" size="mini" style="position:relative;bottom: 1px;margin-right: 5px;"
                           @click="openInsertOrUpdateDialog('update', scope.row)">
                    <span>编辑</span>
                </el-button>
                <el-button type="danger" size="mini" style="position:relative;bottom: 1px;"
                           @click="deleteEntityListByIds([{id: scope.row.id}])">
                    <span>删除</span>
                </el-button>
            </template>
        </el-table-column>
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
    <%-- entity添加或编辑弹窗 --%>
    <el-dialog :title="insertOrUpdateDialog.title" :visible.sync="insertOrUpdateDialog.visible"
               class="dialog-insertOrUpdate"
               @close="refreshTable_entity()">
        <div v-loading="insertOrUpdateDialog.loading" style="height: 480px;">
            <iframe v-if="insertOrUpdateDialog.visible" :src="insertOrUpdateDialog.src"
                    style="width: 100%;height: 100%;overflow-y: auto;border: 0;"
                    @load="insertOrUpdateDialog.loading=false;"></iframe>
        </div>
    </el-dialog>
</div>
<%@include file="/WEB-INF/views/include/blankScript.jsp" %>
<script src="/static/js/functions/tool/importExcel/templateManager.js"></script>
</body>
</html>