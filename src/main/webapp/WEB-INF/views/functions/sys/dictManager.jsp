<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>ssm</title>
    <%@include file="/WEB-INF/views/include/blankHead.jsp" %>
    <link rel="stylesheet" href="/static/css/functions/sys/dictManager.css"/>
</head>
<body>
<div id="app" v-cloak style="background: white;height: 100%;overflow: hidden;" v-loading="fullScreenLoading">
    <%-- 顶栏 --%>
    <div style="padding: 15px 20px 0 15px;">
        <span class="button-group">
            <el-button size="small" type="success" @click="dialog.insertEntity.visible=true">
                <span>添加字典项</span>
            </el-button>
            <el-button size="small" type="danger" @click="deleteEntityListByIds(table.entity.selectionList)">
                <span>批量删除</span>
            </el-button>
            <el-button size="small" type="warning"
                       @click="dialog.dictTypeManager.visible=true;dialog.dictTypeManager.loading=true">
                <span>字典类型管理</span>
            </el-button>
        </span>
        <span style="float: right;margin-right: 10px;">
            <el-select v-model="table.entity.condition.type" size="small" @change="refreshTable_entity()" clearable
                       filterable placeholder="选择字典类型">
                <el-option v-for="(item, index) in options.dictType" :key="item.id" :label="item.nameCn"
                           :value="item.id"></el-option>
            </el-select>
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
    <%-- entity表格 --%>
    <el-table :data="table.entity.data" height="calc(100% - 116px)" v-loading="table.entity.loading"
              style="width: 100%;overflow-y: hidden;margin-top: 20px;" class="scroll-bar"
              @selection-change="onSelectionChange_entity" stripe>
        <el-table-column type="selection" width="40"></el-table-column>
        <el-table-column label="键值（中文）" prop="nameCn"></el-table-column>
        <el-table-column label="键值（英文）" prop="nameEn"></el-table-column>
        <el-table-column label="类型" prop="typeNameCn"></el-table-column>
        <el-table-column label="父键值" prop="parentNameCn"></el-table-column>
        <el-table-column label="排序" prop="sort"></el-table-column>
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
        <el-form label-position="left" label-width="140px" style="padding: 0 100px;"
                 :model="dialog.insertEntity.formData" :rules="dialog.insertEntity.rules"
                 ref="form_insertEntity" v-loading="dialog.insertEntity.loading" status-icon>
            <el-form-item label="键值（中文）" prop="nameCn">
                <el-input v-model="dialog.insertEntity.formData.nameCn"></el-input>
            </el-form-item>
            <el-form-item label="键值（英文）" prop="nameEn">
                <el-input v-model="dialog.insertEntity.formData.nameEn"></el-input>
            </el-form-item>
            <el-form-item label="选择类型" prop="type">
                <el-select v-model="dialog.insertEntity.formData.type" clearable>
                    <el-option v-for="(item, index) in options.dictType" :key="item.id" :label="item.nameCn"
                               :value="item.id"></el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="选择父键值" prop="parentId">
                <el-select v-model="dialog.insertEntity.formData.parentId" clearable
                           @focus="selectParentDictList(dialog.insertEntity)" :loading="options.loading_dict">
                    <el-option v-for="(item, index) in options.dict" :key="item.id" :label="item.nameCn"
                               :value="item.id"></el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="排序" prop="sort">
                <el-input v-model="dialog.insertEntity.formData.sort"></el-input>
            </el-form-item>
        </el-form>
        <div slot="footer" class="dialog-footer">
            <el-button size="medium" @click="dialog.insertEntity.visible=false">取 消</el-button>
            <el-button size="medium" type="primary" @click="insertEntity()" style="margin-left: 10px;">提 交</el-button>
        </div>
    </el-dialog>
    <%-- entity编辑窗口 --%>
    <el-dialog title="编辑" :visible.sync="dialog.updateEntity.visible" @closed="resetForm('form_updateEntity')"
               @open="selectParentDictList(dialog.updateEntity)">
        <el-form label-position="left" label-width="140px"
                 style="padding: 0 100px;height: 350px;overflow-y: scroll;"
                 :model="dialog.updateEntity.formData" :rules="dialog.updateEntity.rules"
                 ref="form_updateEntity" v-loading="dialog.updateEntity.loading" status-icon size="medium">
            <el-form-item label="键值（中文）" prop="nameCn">
                <el-input v-model="dialog.updateEntity.formData.nameCn"></el-input>
            </el-form-item>
            <el-form-item label="键值（英文）" prop="nameEn">
                <el-input v-model="dialog.updateEntity.formData.nameEn"></el-input>
            </el-form-item>
            <el-form-item label="选择类型" prop="type">
                <el-select v-model="dialog.updateEntity.formData.type" clearable>
                    <el-option v-for="(item, index) in options.dictType" :key="item.id" :label="item.nameCn"
                               :value="item.id"></el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="选择父键值" prop="parentId">
                <el-select v-model="dialog.updateEntity.formData.parentId"
                           @focus="selectParentDictList(dialog.updateEntity)"
                           :loading="options.loading_dict" clearable>
                    <el-option v-for="(item, index) in options.dict" :key="item.id" :label="item.nameCn"
                               :value="item.id"></el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="排序" prop="sort">
                <el-input v-model="dialog.updateEntity.formData.sort"></el-input>
            </el-form-item>
        </el-form>
        <div slot="footer" class="dialog-footer">
            <el-button size="medium" @click="dialog.updateEntity.visible=false">取 消</el-button>
            <el-button size="medium" type="primary" @click="updateEntity()" style="margin-left: 10px;">提 交
            </el-button>
        </div>
    </el-dialog>
    <%-- 字典类型管理 --%>
    <el-dialog title="字典类型管理" :visible.sync="dialog.dictTypeManager.visible" class="dialog-dictTypeManager"
               @close="selectDictTypeAllList()">
        <div v-loading="dialog.dictTypeManager.loading" style="height: 450px;">
            <iframe v-if="dialog.dictTypeManager.visible" src="/functions/sys/dictTypeManager"
                    style="width: 100%;height: 450px;overflow-y: auto;border: 0;"
                    @load="dialog.dictTypeManager.loading=false;"></iframe>
        </div>
    </el-dialog>
</div>
<%@include file="/WEB-INF/views/include/blankScript.jsp" %>
<script src="/static/js/functions/sys/dictManager.js"></script>
</body>
</html>