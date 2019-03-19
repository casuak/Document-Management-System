<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>ssm</title>
    <%@include file="/WEB-INF/views/include/blankHead.jsp" %>
    <link rel="stylesheet" href="/static/css/functions/sys/userManager.css"/>
</head>
<body>
<div id="app" v-cloak style="background: white;height: 100%;overflow: hidden;" v-loading="fullScreenLoading">
    <%-- 顶栏 --%>
    <div style="padding: 15px 20px 0px 15px;">
        <span class="button-group">
            <el-button size="small" type="success" @click="dialog.addUser.visible = true">
                <span>添加用户</span>
            </el-button>
            <el-button size="small" type="danger" @click="deleteUser(table.selectionList)" style="margin-left: 10px;">
                <span>批量删除</span>
            </el-button>
            <%--<el-button size="small" type="primary" @click="test()">--%>
                <%--<span>测试</span>--%>
            <%--</el-button>--%>
        </span>
        <span style="float: right;margin-right: 10px;">
            <el-input size="small" placeholder="请输入用户名搜索相关用户" suffix-icon="el-icon-search"
                      style="width: 250px;margin-right: 10px;" v-model="table.params.searchKey"
                      @keyup.enter.native="table.params.pageIndex=1;getUserList()">
            </el-input>
            <el-button size="small" type="primary" style="position:relative;" @click="table.params.pageIndex=1;getUserList()">
                <span>搜索</span>
            </el-button>
        </span>
    </div>
    <%-- 表格 --%>
    <el-table :data="table.data" height="calc(100% - 116px)" v-loading="table.loading"
              style="width: 100%;overflow-y: hidden;margin-top: 20px;" class="scroll-bar"
              @selection-change="handleSelectionChange" stripe>
        <el-table-column type="selection" width="40"></el-table-column>
        <el-table-column label="用户名" prop="username" width="200"></el-table-column>
        <el-table-column label="密码" prop="password" width="200"></el-table-column>
        <el-table-column label="创建时间">
            <template slot-scope="scope">
                {{ formatTimestamp(scope.row.createDate) }}
            </template>
        </el-table-column>
        <el-table-column label="操作" width="130" header-align="center" align="center">
            <template slot-scope="scope">
                <el-button type="warning" size="mini" style="position:relative;bottom: 1px;" @click="openEditUser(scope.row)">
                    <span>编辑</span>
                </el-button>
                <el-button type="danger" size="mini" style="position:relative;bottom: 1px;margin-left: 6px;" @click="deleteUser(scope.row.id, 'single')">
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
    <%-- 添加窗口 --%>
    <el-dialog title="添加用户" :visible.sync="dialog.addUser.visible" @close="resetForm('form_addUser')">
        <el-form label-position="left" label-width="80px" style="padding: 0 100px;"
                 :model="dialog.addUser.formData" :rules="dialog.addUser.rules"
                 ref="form_addUser" v-loading="dialog.addUser.loading" status-icon >
            <el-form-item label="用户名" prop="username" class="is-required">
                <el-input v-model="dialog.addUser.formData.username"></el-input>
            </el-form-item>
            <el-form-item label="密码" prop="password">
                <el-input v-model="dialog.addUser.formData.password"></el-input>
            </el-form-item>
        </el-form>
        <div slot="footer" class="dialog-footer">
            <el-button size="medium" @click="dialog.addUser.visible=false">取 消</el-button>
            <el-button size="medium" type="primary" @click="addUser()" style="margin-left: 10px;">提 交</el-button>
        </div>
    </el-dialog>
    <%-- 编辑窗口 --%>
    <el-dialog title="编辑用户" :visible.sync="dialog.editUser.visible">
        <el-form label-position="left" label-width="80px"
                 style="padding: 0 100px;height: 350px;overflow-y: scroll;"
                 :model="dialog.editUser.formData" :rules="dialog.editUser.rules"
                 ref="form_editUser" v-loading="dialog.editUser.loading" status-icon size="medium">
            <el-form-item label="用户名" prop="username" class="is-required">
                <el-input v-model="dialog.editUser.formData.username" disabled></el-input>
            </el-form-item>
            <el-form-item label="密码" prop="password">
                <el-input v-model="dialog.editUser.formData.password"></el-input>
            </el-form-item>
            <%-- 一个角色都没有时显示 --%>
            <el-form-item v-if="dialog.editUser.formData.roleList.length == 0" label="相关角色">
                <el-dropdown @command="addRoleIntoUser" placement="right" trigger="click">
                    <el-button>添加</el-button>
                    <el-dropdown-menu slot="dropdown">
                        <el-dropdown-item v-for="(role2, index) in dialog.editUser.roleOptions"
                                          :command="role2">
                            {{ role2.name }}
                        </el-dropdown-item>
                        <el-dropdown-item v-if="dialog.editUser.roleOptions.length == 0">
                            没有角色啦
                        </el-dropdown-item>
                    </el-dropdown-menu>
                </el-dropdown>
            </el-form-item>
            <el-form-item v-for="(role, index) in dialog.editUser.formData.roleList"
                          :label="index == 0 ? '相关角色' : ''" :key="role.id">
                <el-input v-model="role.name" :disabled="true" style="width: 195px;"></el-input>
                <el-button @click="deleteRoleFromUser(role)">删除</el-button>
                <el-dropdown v-if="index == dialog.editUser.formData.roleList.length - 1" @command="addRoleIntoUser"
                             placement="right" trigger="click">
                    <el-button>添加</el-button>
                    <el-dropdown-menu slot="dropdown">
                        <el-dropdown-item v-for="(role2, index) in dialog.editUser.roleOptions"
                                          :command="role2">
                            {{ role2.name }}
                        </el-dropdown-item>
                        <el-dropdown-item v-if="dialog.editUser.roleOptions.length == 0" command="noRole">
                            没有角色啦
                        </el-dropdown-item>
                    </el-dropdown-menu>
                </el-dropdown>
            </el-form-item>
        </el-form>
        <div slot="footer" class="dialog-footer">
            <el-button size="medium" @click="dialog.editUser.visible=false">取 消</el-button>
            <el-button size="medium" type="primary" @click="editUser()" style="margin-left: 10px;">提 交</el-button>
        </div>
    </el-dialog>
</div>
<%@include file="/WEB-INF/views/include/blankScript.jsp" %>
<script src="/static/js/functions/sys/userManager.js"></script>
</body>
</html>