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
<div id="app" v-cloak v-loading="loading.fullScreen">
    <%-- 顶栏 --%>
    <div style="padding: 15px 20px 6px 15px;">
        <span class="button-group">
            <el-button size="small" type="danger" @click="deleteFundByIds(selectionList)">
                批量删除
            </el-button>
            <el-button size="small" type="warning" @click="deleteFundByStatus()">
                全部删除
            </el-button>
            <el-button size="small" type="primary" @click="initAllFund()" v-if="status === '-1'">
                初始化
            </el-button>
            <el-button size="small" type="primary" @click="matchUserFund()" v-if="status === '0'">
                自动匹配
            </el-button>
            <el-button size="small" type="primary" @click="completeFundByStatus()" v-if="status === '2'">
                全部完成
            </el-button>
        </span>

        <span style="float: right;margin-right: 10px;">
            <el-select v-model="status" size="small" style="margin-right: 10px;" @change="getFundList()">
                <el-option v-for="status in statusList"
                           :label="status.label"
                           :value="status.value"
                           :key="status.value"></el-option>
            </el-select>
            <el-input size="small" placeholder="请输入项目名称" suffix-icon="el-icon-search"
                      style="width: 250px;margin-right: 10px;" v-model="page.searchKey"
                      @keyup.enter.native="getFundList()">
            </el-input>
            <el-button size="small" type="primary" @click="getFundList()">
                搜索
            </el-button>
        </span>
    </div>
    <%-- 表格 --%>
    <el-table :data="fundList" height="calc(100% - 116px)" v-loading="loading.table"
              style="width: 100%;overflow-y: hidden;margin-top: 15px;" class="scroll-bar"
              @selection-change="selectionList=$event" stripe
              width="100%">
        <el-table-column type="selection" width="40"></el-table-column>
        <el-table-column label="指标名称" width="250" prop="metricName" align="center"></el-table-column>
        <el-table-column label="姓名" width="80" prop="personName" align="center"></el-table-column>
        <el-table-column label="工号" width="150" prop="personWorkId" align="center"></el-table-column>
        <el-table-column label="年份" width="100" prop="projectYear" align="center"></el-table-column>
        <el-table-column label="项目名称" width="700" prop="projectName" align="center"></el-table-column>
        <el-table-column label="金额（万元)" width="100" prop="projectMoney" align="center"></el-table-column>
        <el-table-column label="操作" width="250" header-align="center" align="center">
            <template slot-scope="scope">
                <el-button type="primary" size="mini" style="position:relative;bottom: 1px;"
                           @click="showMatchDialog(scope.row);" v-if="status === '1'">
                    <span>手动匹配</span>
                </el-button>
                <el-button type="primary" size="mini" style="position:relative;bottom: 1px;"
                           @click="complete(scope.row);" v-if="status === '2'">
                    <span>转入完成</span>
                </el-button>
                <el-button type="warning" size="mini" style="position:relative;bottom: 1px;margin-left: 6px;"
                           @click="showUpdateDialog(scope.row)" v-if="status === '2'">
                    <span>编辑</span>
                </el-button>
                <el-button type="warning" size="mini" style="position:relative;bottom: 1px;margin-left: 6px;"
                           @click="uncomplete(scope.row);" v-if="status === '3'">
                    <span>回滚状态</span>
                </el-button>
                <el-button type="danger" size="mini" style="position:relative;bottom: 1px;margin-left: 6px;"
                           @click="deleteFundByIds([{id: scope.row.id}])">
                    <span>删除</span>
                </el-button>
            </template>
        </el-table-column>
        <el-table-column width="50"></el-table-column>
    </el-table>
    <%-- 分页 --%>
    <el-pagination style="text-align: center;margin: 9px auto;"
                   @size-change="page.pageSize=$event;getFundList()"
                   @current-change="page.pageIndex=$event;getFundList()"
                   :current-page="page.pageIndex"
                   :page-sizes="page.pageSizes"
                   :page-size="page.pageSize"
                   :total="page.total"
                   layout="total, sizes, prev, pager, next, jumper">
    </el-pagination>

    <%-- 更新 dialog --%>
    <el-dialog title="更新信息" :visible.sync="updateDialog.visible">
        <el-form>
            <el-form-item label="年份" :required="true">
                <el-input v-model="updateDialog.data.projectYear"></el-input>
            </el-form-item>
            <el-form-item label="项目名称" :required="true">
                <el-input v-model="updateDialog.data.projectName"></el-input>
            </el-form-item>
            <el-form-item label="金额" :required="true" type="number">
                <el-input v-model="updateDialog.data.projectMoney"></el-input>
            </el-form-item>
        </el-form>

        <div slot="footer">
            <el-button size="medium" @click="updateDialog.visible=false;resetDialogData();">取消</el-button>
            <el-button size="medium" type="primary" style="margin-left: 10px;" @click="updateFund()">提交</el-button>
        </div>
    </el-dialog>

    <%-- 手动匹配 dialog --%>
    <el-dialog title="手动匹配" :visible.sync="matchDialog.visible">
        <div style="display: flex;">
            <el-input v-model="matchDialog.searchId" placeholder="工号"></el-input>
            <el-input v-model="matchDialog.searchName" placeholder="姓名"></el-input>
            <div style="width: 25%"></div>
            <el-button size="medium" type="primary" @click="searchForMatch()">查找</el-button>
        </div>



        <el-table :data="matchDialog.table" v-loading="matchDialog.loading"
                  style="width: 100%;overflow-y: hidden;margin-top: 15px;" class="scroll-bar" stripe
                  width="100%">
            <el-table-column label="姓名" width="80" prop="realName" align="center"></el-table-column>
            <el-table-column label="工号" width="150" prop="workId" align="center"></el-table-column>
            <el-table-column label="学院" width="200" prop="school" align="center"></el-table-column>
            <el-table-column label="职称" width="120" prop="title" align="center"></el-table-column>
            <el-table-column label="操作" width="80" header-align="center" align="center">
                <template slot-scope="matchScope">
                    <el-button type="primary" size="mini" style="position:relative;bottom: 1px;"
                               @click="matchFund(matchScope.row);">
                        <span>手动匹配</span>
                    </el-button>
                </template>
            </el-table-column>
        </el-table>
    </el-dialog>
</div>
<%@include file="/WEB-INF/views/include/blankScript.jsp" %>
<script src="/static/js/functions/doc/fundManager.js"></script>
</body>
</html>