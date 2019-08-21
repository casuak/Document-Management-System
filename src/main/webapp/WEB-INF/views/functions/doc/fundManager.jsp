<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>ssm</title>
    <%@include file="/WEB-INF/views/include/blankHead.jsp" %>
    <link rel="stylesheet" href="/static/css/functions/doc/fundManager.css"/>
</head>
<body>
<div id="app" v-cloak style="background: white;height: 100%;overflow: hidden;" v-loading="fullScreenLoading">
    <%-- 顶栏 --%>
    <div style="padding: 15px 20px 0 15px;">
        <span class="button-group">
            <el-button size="small" type="warning" @click="deleteByIds(table.selectionList)"
                       style="margin-left: 10px;">
                <span>批量删除</span>
            </el-button>
            <el-button size="small" type="danger" @click="deleteAll"  style="margin-left: 10px;">全部删除</el-button>
        </span>


        <span style="float: right;margin-right: 10px;">
            <el-input size="small" placeholder="请输入项目名称" suffix-icon="el-icon-search"
                      style="width: 250px;margin-right: 10px;" v-model="table.props.searchKey"
                      @keyup.enter.native="table.props.pageIndex=1;refreshTable()">
            </el-input>
            <el-button size="small" type="primary" style="position:relative;"
                       @click="table.props.pageIndex=1;refreshTable()">
                <span>搜索</span>
            </el-button>
        </span>
    </div>
    <%-- entity表格 --%>
        <el-table :data="table.data" height="calc(100% - 116px)" v-loading="table.loading"
                  style="width: 100%;overflow-y: hidden;margin-top: 15px;" class="scroll-bar"
                  @selection-change="onSelectionChange" stripe
                width="100%"
        >
            <el-table-column type="selection" width="40"></el-table-column>
            <el-table-column label="指标名称" width="200" prop="metricName" align="center"></el-table-column>
            <el-table-column label="姓名" width="150" prop="personName" align="center"></el-table-column>
            <el-table-column label="年份" width="150" prop="projectYear" align="center"></el-table-column>
            <el-table-column label="项目名称"  prop="projectName" align="center"></el-table-column>
            <el-table-column label="金额（万元)" width="150" prop="projectMoney" align="center"></el-table-column>
            <el-table-column label="操作" width="190" header-align="center" align="center">
                <template slot-scope="scope">
                    <el-button type="warning" size="mini" style="position:relative;bottom: 1px;"
                               @click="openDialog_updateEntity(scope.row)">
                        <span>编辑</span>
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
                   :current-page="table.props.pageIndex"
                   :page-sizes="table.props.pageSizes"
                   :page-size="table.props.pageSize"
                   :total="table.props.total"
                   layout="total, sizes, prev, pager, next, jumper">
    </el-pagination>

        <el-dialog title="编辑" :visible.sync="dialog.visible">
                <el-form label-position="left" label-width="140px" style="padding: 0 100px;"
                         v-loading="dialog.loading" status-icon>
                    <el-form-item label="指标名称" >
                        <el-input v-model="dialog.data.metricName"></el-input>
                    </el-form-item>

                    <el-form-item label="姓名" >
                        <el-input v-model="dialog.data.personName"></el-input>
                    </el-form-item>
                    <el-form-item label="年份" >
                        <el-input v-model="dialog.data.projectYear"></el-input>
                    </el-form-item>
                    <el-form-item label="项目名称" >
                        <el-input v-model="dialog.data.projectName"></el-input>
                    </el-form-item>
                    <el-form-item label="金额(万元)" >
                        <el-input v-model="dialog.data.projectMoney"></el-input>
                    </el-form-item>
                </el-form>
            <div slot="footer">
                <el-button size="medium" @click="dialog.visible=false">取消</el-button>
                <el-button size="medium" type="primary" style="margin-left: 10px;" @click="updateFund">提交
                </el-button>
            </div>
        </el-dialog>
</div>
<%@include file="/WEB-INF/views/include/blankScript.jsp" %>
<script src="/static/js/functions/doc/fundManager.js"></script>
</body>
</html>