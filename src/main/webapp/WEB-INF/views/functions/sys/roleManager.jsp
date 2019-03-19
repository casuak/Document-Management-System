<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>ssm</title>
    <%@include file="/WEB-INF/views/include/blankHead.jsp" %>
    <link rel="stylesheet" href="/static/css/functions/sys/roleManager.css"/>
</head>
<body>
<div id="app" v-cloak style="background: white;height: 100%;overflow: hidden;" v-loading="fullScreenLoading">
    <%-- 顶栏 --%>
    <div style="padding: 15px 20px 0px 15px;">
        <span class="button-group">
            <el-button size="small" type="success" @click="dialog.add.visible = true">
                <span>添加角色</span>
            </el-button>
            <el-button size="small" type="danger" @click="delete(table.selectionList)" style="margin-left: 10px;">
                <span>批量删除</span>
            </el-button>
        </span>
        <span style="float: right;margin-right: 10px;">
            <el-input size="small" placeholder="请输入角色名搜索相关角色" suffix-icon="el-icon-search"
                      style="width: 250px;margin-right: 10px;" v-model="table.params.searchKey"
                      @keyup.enter.native="table.params.pageIndex=1;getRoleList()">
            </el-input>
            <el-button size="small" type="primary" style="position:relative;" @click="table.params.pageIndex=1;getRoleList()">
                <span>搜索</span>
            </el-button>
        </span>
    </div>
    <%-- 表格 --%>
    <el-table :data="table.data" height="calc(100% - 116px)" v-loading="table.loading"
              style="width: 100%;overflow-y: hidden;margin-top: 20px;" class="scroll-bar"
              @selection-change="handleSelectionChange" stripe>
        <el-table-column type="selection" width="40"></el-table-column>
        <el-table-column label="角色名" prop="name" width="200"></el-table-column>
        <el-table-column label="角色代码" prop="code" width="200"></el-table-column>
        <el-table-column label="创建时间">
            <template slot-scope="scope">
                {{ formatTimestamp(scope.row.createDate) }}
            </template>
        </el-table-column>
        <el-table-column label="操作" width="190" header-align="center" align="center">
            <template slot-scope="scope">
                <el-button type="success" size="mini" style="position:relative;bottom: 1px;"
                           @click="openFunctionDialog(scope.row)">
                    <span>功能</span>
                </el-button>
                <el-button type="warning" size="mini" style="position:relative;bottom: 1px;margin-left: 6px;"
                           @click="openEditDialog(scope.row)">
                    <span>编辑</span>
                </el-button>
                <el-button type="danger" size="mini" style="position:relative;bottom: 1px;margin-left: 6px;"
                           @click="deleteRole(scope.row.id, 'single')">
                    <span>删除</span>
                </el-button>
            </template>
        </el-table-column>
        <el-table-column width="50"></el-table-column>
    </el-table>
    <%-- 分页 --%>
    <el-pagination style="text-align: center;margin: 8px auto;"
                   @size-change="handleSizeChange"
                   @current-change="handleCurrentChange"
                   :current-page="table.params.pageIndex"
                   :page-sizes="table.params.pageSizes"
                   :page-size="table.params.pageSize"
                   :total="table.params.total"
                   layout="total, sizes, prev, pager, next, jumper">
    </el-pagination>
    <%-- 添加角色窗口 --%>
    <el-dialog title="添加角色" :visible.sync="dialog.add.visible" @close="resetForm('form_add')" class="dialog-insertRole">
        <%--<el-form label-position="left" label-width="80px" style="padding: 0 100px;"--%>
                 <%--:model="dialog.add.formData" :rules="dialog.add.rules"--%>
                 <%--ref="form_add" v-loading="dialog.add.loading" status-icon>--%>
            <%--<el-form-item label="角色名" prop="name">--%>
                <%--<el-input v-model="dialog.add.formData.name"></el-input>--%>
            <%--</el-form-item>--%>
            <%--<el-form-item label="角色代码" prop="code">--%>
                <%--<el-input v-model="dialog.add.formData.code"></el-input>--%>
            <%--</el-form-item>--%>
        <%--</el-form>--%>
        <%--<div slot="footer" class="dialog-footer">--%>
            <%--<el-button size="medium" @click="dialog.add.visible=false">取 消</el-button>--%>
            <%--<el-button size="medium" type="primary" @click="submitAddForm()" style="margin-left: 10px;">提 交--%>
            <%--</el-button>--%>
        <%--</div>--%>
        <iframe src="/functions/sys/userManager" style="width: 100%;height: 450px;overflow-y: auto;border: 0;"></iframe>
    </el-dialog>
    <%-- 编辑角色窗口 --%>
    <el-dialog title="编辑角色" :visible.sync="dialog.edit.visible" @close="resetForm('form_edit')">
        <el-form label-position="left" label-width="80px"
                 style="padding: 0 100px;height: 350px;overflow-y: scroll;"
                 :model="dialog.edit.formData" :rules="dialog.edit.rules"
                 ref="form_edit" v-loading="dialog.edit.loading" status-icon size="medium">
            <el-form-item label="角色名" prop="name">
                <el-input v-model="dialog.edit.formData.name"></el-input>
            </el-form-item>
            <el-form-item label="角色代码" prop="code">
                <el-input v-model="dialog.edit.formData.code"></el-input>
            </el-form-item>
        </el-form>
        <div slot="footer" class="dialog-footer">
            <el-button size="medium" @click="dialog.edit.visible=false">取 消</el-button>
            <el-button size="medium" type="primary" @click="submitEditForm" style="margin-left: 10px;">提 交
            </el-button>
        </div>
    </el-dialog>
    <%-- 编辑功能窗口 --%>
    <el-dialog title="功能管理" :visible.sync="dialog.functionEdit.visible" width="500px">
        <div v-loading="dialog.functionEdit.loading">
            <el-tree ref="tree" :data="dialog.functionEdit.functionTree" :props="dialog.functionEdit.treeProps"
                     node-key="id" default-expand-all show-checkbox
                     style="height: 300px;overflow-y: auto;"></el-tree>
            <el-row style="margin-top: 20px;">
                <el-col :offset="15">
                    <el-button size="small" type="success" @click="submitEditFunction()"
                               style="margin-right: 10px;">
                        保存修改
                    </el-button>
                    <el-button size="small" type="danger" @click="dialog.functionEdit.visible=false">取消</el-button>
                </el-col>
            </el-row>
        </div>
    </el-dialog>
</div>
<%@include file="/WEB-INF/views/include/blankScript.jsp" %>
<script src="/static/js/functions/sys/roleManager.js"></script>
</body>
</html>