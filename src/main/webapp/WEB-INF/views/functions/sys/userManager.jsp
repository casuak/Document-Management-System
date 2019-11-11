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
            <el-button size="small" type="success" @click="openInsert()">
                <span>添加用户</span>
            </el-button>
            <el-button size="small" type="danger" @click="deleteUser(table.selectionList)" style="margin-left: 10px;">
                <span>批量删除</span>
            </el-button>
            <el-button size="small" type="warning" @click="initUser()" style="margin-left: 10px;">
                <span>初始化</span>
            </el-button>
        </span>
        <span style="float: right;margin-right: 10px;">
            <el-select v-model="table.params.userType" size="small" style="margin-right: 10px;"
                       @change="getUserList()" clearable placeholder="请选择用户类型">
                <el-option v-for="userType in options.userType" :label="userType.label"
                           :value="userType.value" :key="userType.value"></el-option>
            </el-select>
            <el-input size="small" placeholder="请输入用户名搜索相关用户" suffix-icon="el-icon-search"
                      style="width: 250px;margin-right: 10px;" v-model="table.params.searchKey"
                      @keyup.enter.native="table.params.pageIndex=1;getUserList()">
            </el-input>
            <el-button size="small" type="primary" style="position:relative;"
                       @click="table.params.pageIndex=1;getUserList()">
                <span>搜索</span>
            </el-button>
        </span>
    </div>
    <%-- 表格 --%>
    <el-table :data="table.data" height="calc(100% - 116px)" v-loading="table.loading"
              style="width: 100%;overflow-y: hidden;margin-top: 20px;" class="scroll-bar"
              @selection-change="handleSelectionChange" stripe>
        <el-table-column type="selection" width="40"></el-table-column>
        <el-table-column label="姓名" width="100" prop="realName"></el-table-column>
        <el-table-column label="学号/工号" width="100" prop="workId"></el-table-column>
        <el-table-column label="用户类型" width="100" align="center">
            <template slot-scope="scope">
                {{ translateUserType(scope.row.userType) }}
            </template>
        </el-table-column>
        <el-table-column label="用户名" prop="username" width="100"></el-table-column>
        <el-table-column label="密码" prop="password" width="150"></el-table-column>
        <el-table-column label="创建时间">
            <template slot-scope="scope">
                {{ formatTimestamp(scope.row.createDate) }}
            </template>
        </el-table-column>
        <el-table-column label="状态">
            <template slot-scope="scope">
                {{  translateStatus(scope.row.status) }}
            </template>
        </el-table-column>
        <el-table-column label="操作" width="190" header-align="center" align="center">
            <template slot-scope="scope">
                <el-button type="success" size="mini" style="position:relative;bottom: 1px;"
                           @click="openMapRole(scope.row)">
                    <span>角色</span>
                </el-button>
                <el-button type="warning" size="mini" style="position:relative;bottom: 1px;margin-left: 6px;"
                           @click="openUpdate(scope.row)">
                    <span>编辑</span>
                </el-button>
                <el-button type="danger" size="mini" style="position:relative;bottom: 1px;margin-left: 6px;"
                           @click="deleteUser(scope.row.id, 'single')">
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
    <%-- 添加或编辑窗口 --%>
    <el-dialog :title="dialog.insertOrUpdate.status == 'insert' ? '添加用户' : '编辑用户'"
               :visible.sync="dialog.insertOrUpdate.visible" @close="resetDialog()">
        <el-form label-position="left" label-width="80px" style="padding: 0 100px;"
                 :model="dialog.insertOrUpdate.formData" :rules="dialog.insertOrUpdate.rules"
                 ref="form_insertOrUpdate" label-width="100px"
                 v-loading="dialog.insertOrUpdate.loading" status-icon>
            <el-form-item label="用户名" :prop="dialog.insertOrUpdate.status == 'insert' ? 'username' : null"
                          class="is-required">
                <el-input v-model="dialog.insertOrUpdate.formData.username"
                          :disabled="dialog.insertOrUpdate.status == 'update'"></el-input>
            </el-form-item>
            <el-form-item label="密码" prop="password">
                <el-input v-model="dialog.insertOrUpdate.formData.password"></el-input>
            </el-form-item>
            <el-form-item label="用户类型" prop="userType">
                <el-select v-model="dialog.insertOrUpdate.formData.userType" placeholder="请选择">
                    <el-option v-for="userType in dialog.insertOrUpdate.userTypeList" :key="userType.value"
                               :label="userType.label" :value="userType.value"></el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="姓名" prop="realName">
                <el-input v-model="dialog.insertOrUpdate.formData.realName"></el-input>
            </el-form-item>
            <el-form-item label="别名" prop="nicknames">
                <el-input v-model="dialog.insertOrUpdate.formData.nicknames"></el-input>
            </el-form-item>
            <el-form-item label="学院" prop="school">
                <el-select v-model="dialog.insertOrUpdate.formData.school" placeholder="请选择">
                    <el-option v-for="school in dialog.insertOrUpdate.schoolList" :key="school"
                               :label="school" :value="school"></el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="学科" prop="major">
                <el-select v-model="dialog.insertOrUpdate.formData.major" placeholder="请选择">
                    <el-option v-for="major in dialog.insertOrUpdate.majorList" :key="major"
                               :label="major" :value="major"></el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="硕导" prop="isMaster" v-if="dialog.insertOrUpdate.formData.userType == 'teacher'">
                <el-switch v-model="dialog.insertOrUpdate.formData.isMaster"
                           active-color="#13ce66" inactive-color="#ff4949"
                           active-value="1" inactive-value="0"
                           :disabled="dialog.insertOrUpdate.formData.userType !== 'teacher'">
                </el-switch>
            </el-form-item>
            <el-form-item label="博导" prop="isDoctor" v-if="dialog.insertOrUpdate.formData.userType == 'teacher'">
                <el-switch v-model="dialog.insertOrUpdate.formData.isDoctor"
                           active-color="#13ce66" inactive-color="#ff4949"
                           active-value="1" inactive-value="0"
                           :disabled="dialog.insertOrUpdate.formData.userType !== 'teacher'">
                </el-switch>
            </el-form-item>
            <el-form-item label="培养层次" prop="studentTrainLevel" v-if="dialog.insertOrUpdate.formData.userType == 'student'">
                <el-switch v-model="dialog.insertOrUpdate.formData.studentTrainLevel"
                           active-text="硕士" inactive-text="博士"
                           active-value="硕士" inactive-value="博士"
                           :disabled="dialog.insertOrUpdate.formData.userType !== 'student'">
                </el-switch>
            </el-form-item>
            <el-form-item label="学位类型" prop="studentDegreeType" v-if="dialog.insertOrUpdate.formData.userType == 'student'">
                <el-switch v-model="dialog.insertOrUpdate.formData.studentDegreeType"
                           active-text="专业学位" inactive-text="学术型"
                           active-value="专业学位" inactive-value="学术型"
                           :disabled="dialog.insertOrUpdate.formData.userType !== 'student'">
                </el-switch>
            </el-form-item>
            <el-form-item label="导师姓名" prop="tutorName"
                          v-if="dialog.insertOrUpdate.formData.userType == 'student'"
                          :required="app.dialog.insertOrUpdate.status === 'insert'">
                <el-input v-model="dialog.insertOrUpdate.formData.tutorName"></el-input>
            </el-form-item>
            <el-form-item label="导师工号" prop="tutorWorkId"
                          v-if="dialog.insertOrUpdate.formData.userType == 'student'"
                          :required="app.dialog.insertOrUpdate.status === 'insert'">
                <el-input v-model="dialog.insertOrUpdate.formData.tutorWorkId"></el-input>
            </el-form-item>
            <el-form-item label="导师别名" prop="tutorNicknames" v-if="dialog.insertOrUpdate.formData.userType == 'student'">
                <el-input v-model="dialog.insertOrUpdate.formData.tutorNicknames"></el-input>
            </el-form-item>
        </el-form>
        <div slot="footer" class="dialog-footer">
            <el-button size="medium" @click="dialog.insertOrUpdate.visible=false;resetDialog()">取 消</el-button>
            <el-button v-if="dialog.insertOrUpdate.status == 'insert'"
                       size="medium" type="primary" @click="insertOrUpdate()" style="margin-left: 10px;">提 交
            </el-button>
            <el-button v-else size="medium" type="primary" @click="insertOrUpdate()" style="margin-left: 10px;">提 交
            </el-button>
        </div>
    </el-dialog>
    <%-- 编辑用户-角色关联 --%>
    <el-dialog title="关联角色" :visible.sync="dialog.mapRole.visible" v-loading="dialog.mapRole.loading">
        <el-tree ref="tree" :data="roleTree" :props="{label:'name'}" node-key="id" show-checkbox
                 style="height: 300px;overflow-y: auto;">
        </el-tree>
        <div slot="footer" class="dialog-footer">
            <el-button size="medium" @click="dialog.mapRole.visible=false">取 消</el-button>
            <el-button size="medium" type="primary" @click="updateUserRole()" style="margin-left: 10px;">保 存</el-button>
        </div>
    </el-dialog>
</div>
<%@include file="/WEB-INF/views/include/blankScript.jsp" %>
<script src="/static/js/functions/sys/userManager.js"></script>
</body>
</html>