<%--
  Created by IntelliJ IDEA.
  User: zm
  Date: 2019/3/26
  Time: 22:53
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>作者查询</title>
    <%@include file="/WEB-INF/views/include/blankHead.jsp" %>
    <link rel="stylesheet" href="/static/css/tableTemplate.css"/>
    <style>
        .textLeft {
            margin-left: 10px;
            font-size: 14px;
            float: left;
            padding-top: 20px;
        }

        .el-col {
            padding-top: 10px;
        }
        .header-panel{
            margin-top: 10px;
            padding:5px 18px
        }
        .singleSelect{
            float: left;
            margin-left: 20px;
        }
    </style>
</head>
<body>
<div id="app" v-cloak style="background: white;height: 100%;overflow: hidden;" v-loading="fullScreenLoading">

    <div class="header-panel">
       <div style="float: left">
           <span>作者角色： </span>
           <template>
               <el-select v-model="inputValue.roleId" clearable placeholder="请选择作者角色">
                   <el-option
                           v-for="item in condition.role"
                           :key="item.value"
                           :label="item.label"
                           :value="item.value">
                   </el-option>
               </el-select>
           </template>
       </div>
        <div class="singleSelect">
            <span>所在机构： </span>
            <template>
                <el-select v-model="inputValue.orgId" clearable placeholder="请选择所属机构">
                    <el-option
                            v-for="item in condition.organization"
                            :key="item.value"
                            :label="item.label"
                            :value="item.value">
                    </el-option>
                </el-select>
            </template>
        </div>
        <div class="singleSelect">
            <span>所属学科： </span>
            <template>
                <el-select v-model="inputValue.subId" clearable placeholder="请选择作者角色">
                    <el-option
                            v-for="item in condition.subject"
                            :key="item.value"
                            :label="item.label"
                            :value="item.value">
                    </el-option>
                </el-select>
            </template>
        </div>

        <div class="singleSelect">
            <span style="float: left;padding-top: 9px">作者姓名： </span>
            <div style="float: left">
                <el-input
                        placeholder="请输入作者姓名"
                        v-model="inputValue.authorName"
                        clearable>
                </el-input>
            </div>
        </div>

        <span style="float: right;margin-right: 10px;">
            <el-input size="small" placeholder="请输入角色名搜索相关角色" suffix-icon="el-icon-search"
                      style="width: 250px;margin-right: 10px;" v-model="table.entity.params.searchKey"
                      @keyup.enter.native="table.entity.params.pageIndex=1;refreshTable_entity()">
            </el-input>
            <el-button size="small" type="primary" style="position:relative;"
                       @click="table.entity.params.pageIndex=1;refreshTable_entity()">
                <span>搜索</span>
            </el-button>
        </span>
    </div>
    <%-- 顶栏 --%>
    <div style="padding: 15px 20px 0 15px;margin-top: 35px">
        <span class="button-group">
            <el-button size="small" type="success" @click="dialog.insertEntity.visible=true">
                <span>查询</span>
            </el-button>
            <el-button size="small" type="danger" @click="deleteEntityListByIds(table.entity.selectionList)"
                       style="margin-left: 10px;">
                <span>批量删除</span>
            </el-button>
        </span>
    </div>
    <%-- entity表格 --%>
    <el-table :data="table.entity.data" height="calc(100% - 116px)" v-loading="table.entity.loading"
              style="width: 100%;overflow-y: hidden;margin-top: 20px;" class="scroll-bar"
              @selection-change="onSelectionChange_entity" stripe>
        <el-table-column type="selection" width="40"></el-table-column>
        <el-table-column label="创建时间">
            <template slot-scope="scope">
                {{ formatTimestamp(scope.row.createDate) }}
            </template>
        </el-table-column>
        <el-table-column label="操作" width="190" header-align="center" align="center">
            <template slot-scope="scope">
                <el-button type="warning" size="mini" style="position:relative;bottom: 1px;"
                           @click="openDialog_updateEntity(scope.row)">
                    <span>编辑</span>
                </el-button>
                <el-button type="danger" size="mini" style="position:relative;bottom: 1px;margin-left: 6px;"
                           @click="deleteEntityListByIds([{id: scope.row.id}])">
                    <span>删除</span>
                </el-button>
            </template>
        </el-table-column>
        <el-table-column width="50"></el-table-column>
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
    <%-- entity添加窗口 --%>
    <el-dialog title="添加" :visible.sync="dialog.insertEntity.visible" @closed="resetForm('form_insertEntity')">
        <el-form label-position="left" label-width="80px" style="padding: 0 100px;"
                 :model="dialog.insertEntity.formData" :rules="dialog.insertEntity.rules"
                 ref="form_insertEntity" v-loading="dialog.insertEntity.loading" status-icon>
            <el-form-item label="角色名" prop="name">
                <el-input v-model="dialog.insertEntity.formData.name"></el-input>
            </el-form-item>
            <el-form-item label="角色代码" prop="code">
                <el-input v-model="dialog.insertEntity.formData.code"></el-input>
            </el-form-item>
        </el-form>
        <div slot="footer" class="dialog-footer">
            <el-button size="medium" @click="dialog.insertEntity.visible=false">取 消</el-button>
            <el-button size="medium" type="primary" @click="insertEntity()" style="margin-left: 10px;">提 交
            </el-button>
        </div>
    </el-dialog>
    <%-- entity编辑窗口 --%>
    <el-dialog title="编辑" :visible.sync="dialog.updateEntity.visible" @closed="resetForm('form_updateEntity')">
        <el-form label-position="left" label-width="80px"
                 style="padding: 0 100px;overflow-y: scroll;"
                 :model="dialog.updateEntity.formData" :rules="dialog.updateEntity.rules"
                 ref="form_updateEntity" v-loading="dialog.updateEntity.loading" status-icon size="medium">
            <el-form-item label="角色名" prop="name">
                <el-input v-model="dialog.updateEntity.formData.name"></el-input>
            </el-form-item>
            <el-form-item label="角色代码" prop="code">
                <el-input v-model="dialog.updateEntity.formData.code"></el-input>
            </el-form-item>
        </el-form>
        <div slot="footer" class="dialog-footer">
            <el-button size="medium" @click="dialog.updateEntity.visible=false">取 消</el-button>
            <el-button size="medium" type="primary" @click="updateEntity()" style="margin-left: 10px;">提 交
            </el-button>
        </div>
    </el-dialog>
</div>
<%@include file="/WEB-INF/views/include/blankScript.jsp" %>
<%--当前页js--%>
<script src="${pageContext.request.contextPath}/static/js/functions/doc/authorSearch.js"></script>
</body>
</html>