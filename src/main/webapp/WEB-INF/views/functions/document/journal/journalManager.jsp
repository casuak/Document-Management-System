<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>ssm</title>
    <%@include file="/WEB-INF/views/include/blankHead.jsp" %>
    <link rel="stylesheet" href="/static/css/functions/document/journal/journalManager.css"/>
</head>
<body>
<div id="app" v-cloak style="background: white;height: 100%;overflow: hidden;" v-loading="fullScreenLoading">
    <%-- 顶栏 --%>
    <div style="padding: 15px 20px 0 15px;">
        <span class="button-group">
            <%--<el-button size="small" type="success" @click="">--%>
                <%--<span>操作</span>--%>
            <%--</el-button>--%>
            <el-button size="small" type="warning" @click="deleteAll()">
                <span>全部删除</span>
            </el-button>
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
        <el-table-column label="分区" width="200" prop="journalDivision" align="center"></el-table-column>
        <el-table-column label="年份" width="200" prop="journalYear" align="center">
            <template slot-scope="scope">
                {{ formatYear(scope.row.journalYear) }}
            </template>
        </el-table-column>
        <el-table-column label="影响因子" width="200" prop="impactFactor" align="center"></el-table-column>
        <el-table-column label="ISSN" width="200" prop="issn" align="center"></el-table-column>
        <el-table-column></el-table-column>
        <el-table-column label="操作" width="190" header-align="center" align="center">
            <template slot-scope="scope">
                <%--<el-button type="warning" size="mini" style="position:relative;bottom: 1px;"--%>
                <%--@click="openDialog_updateEntity(scope.row)">--%>
                <%--<span>编辑</span>--%>
                <%--</el-button>--%>
                <el-button type="warning" size="mini" style="position:relative;bottom: 1px;margin-left: 6px;"
                           @click="showUpdateDialog(scope.row)">
                    <span>修改</span>
                </el-button>
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

    <%-- 更新对话框 --%>
    <el-dialog title="更新信息" :visible.sync="updateDialog.visible">
        <el-form>
            <el-form-item label="期刊名" :required="true">
                <el-input v-model="updateDialog.data.journalTitle"></el-input>
            </el-form-item>
            <el-form-item label="分区" :required="true">
                <el-select v-model="updateDialog.data.journalDivision" size="small" style="margin-right: 10px;">
                    <el-option v-for="journalDivision in journalDivisionList"
                               :label="journalDivision.label"
                               :value="journalDivision.value"
                               :key="journalDivision.value"></el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="年份" :required="true">
                <el-date-picker
                        v-model="updateDialog.data.journalYear"
                        type="year"
                        placeholder="选择年">
                </el-date-picker>
            </el-form-item>
            <el-form-item label="影响因子" :required="true">
                <el-input v-model="updateDialog.data.impactFactor"></el-input>
            </el-form-item>
            <el-form-item label="ISSN" :required="true">
                <el-input v-model="updateDialog.data.issn"></el-input>
            </el-form-item>
        </el-form>

        <div slot="footer">
            <el-button size="medium" @click="updateDialog.visible=false;clearUpdateDialog();">取消</el-button>
            <el-button size="medium" type="primary" style="margin-left: 10px;" @click="updateJournal()">提交</el-button>
        </div>
    </el-dialog>
</div>
<%@include file="/WEB-INF/views/include/blankScript.jsp" %>
<script src="/static/js/functions/document/journal/journalManager.js"></script>
</body>
</html>