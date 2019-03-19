<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>ssm</title>
    <%@include file="/WEB-INF/views/include/blankHead.jsp" %>
    <link rel="stylesheet" href="/static/css/functions/sys/functionManager.css"/>
</head>
<body>
<div id="app" v-cloak style="overflow-y: hidden;">
    <div class="card1" style="width: 349px;margin-left: 20px;margin-top: 20px;float: left;height: 100%;">
        <el-card style="height: calc(100% - 41px);" v-loading="treeLoading">
            <div slot="header" style="height: 10px;line-height: 10px;">
                <span style="font-size: 15px;color: rgb(47, 149, 208);">功能列表</span>
                <span class="button-group">
                    <el-button icon="el-icon-plus" size="mini" type="success" @click="addCategory()">添加分类</el-button>
                </span>
            </div>
            <el-tree style="overflow-y: auto;height: calc(100% - 40px);" :props="treeProp"
                     :data="tree" node-key="id" @node-drag-start="handleDragStart" @node-drag-enter="handleDragEnter"
                     @node-drag-leave="handleDragLeave" @node-drag-over="handleDragOver" @node-drag-end="handleDragEnd"
                     @node-drop="handleDrop" draggable :allow-drop="allowDrop" :allow-drag="allowDrag"
                     default-expand-all :expand-on-click-node="false">
                <span slot-scope="{ node, data }" class="tree-row">
                    <span :style="data.enable ? {} : {'color': 'rgb(184, 187, 192)'}"><span
                            :style="data.type === 0 ? {'font-size': '14px', 'font-weight': 'bold'} : {'font-size': '13px'}">
                        <i :class="data.icon === '' || data.icon == null ? 'fa fa-ban' : data.icon" aria-hidden="true"
                           :style="data.type === 0 ? {'width': '20px'} : {'width': '15px'}"></i>
                        {{ data.name }}
                    </span></span>
                    <span class="mini-button-group">
                        <el-button type="text" size="mini" @click="addFunction(data)"
                                   v-show="data.type === 0">添加子功能</el-button>
                        <el-button type="text" size="mini" @click="deleteFunctionOrCategory(node, data)">删除</el-button>
                        <el-button type="text" size="mini" @click="openEditForm(data)">设置</el-button>
                    </span>
                </span>
            </el-tree>
        </el-card>
    </div>
    <div class="card2" style="width: calc(100% - 409px);margin-left: 21px;margin-top: 20px;float: left;height: 100%;">
        <el-card style="height: calc(100% - 41px);" v-loading="form.loading">
            <div slot="header" style="height: 10px;line-height: 10px;">
                <span style="font-size: 15px;color: rgb(230, 162, 60);">设置</span>
                <span class="button-group" v-show="form.visible">
                    <el-button size="mini" type="warning" @click="submitForm()">保存修改</el-button>
                    <el-button size="mini" type="danger"
                               @click="form.visible = false;treeLoading = false;">取消</el-button>
                </span>
            </div>
            <el-form v-show="form.visible" label-position="left" label-width="80px" size="small"
                     style="padding-left: 20px;padding-right: 10px;overflow-y: auto;height: calc(100% - 40px);">
                <el-form-item :label="form.type_cn + '名'" prop="name">
                    <el-input v-model="form.data.name"></el-input>
                </el-form-item>
                <el-form-item label="权限码" prop="code">
                    <el-input v-model="form.data.code"></el-input>
                </el-form-item>
                <el-form-item v-show="form.type === 'function'" label="地址" prop="url">
                    <el-input v-model="form.data.url"></el-input>
                </el-form-item>
                <el-form-item label="备注" prop="remarks">
                    <el-input type="textarea" v-model="form.data.remarks"></el-input>
                </el-form-item>
                <el-form-item label="图标" prop="icon">
                    <el-button-group>
                        <el-button style="font-size: 20px;padding: 5px 10px;width: 52px;height: 32px;">
                            <i :class="form.data.icon" aria-hidden="true"></i>
                        </el-button>
                        <el-button @click="dialog.selectIcon.visible=true">选择图标</el-button>
                    </el-button-group>
                </el-form-item>
                <el-form-item label="状态" prop="enable">
                    <i-switch v-model="form.data.enable" size="large">
                        <span slot="open">启用</span>
                        <span slot="close">禁用</span>
                    </i-switch>
                </el-form-item>
            </el-form>
        </el-card>
    </div>
    <%-- 对话框 选择图标 --%>
    <el-dialog title="选择图标" :visible.sync="dialog.selectIcon.visible" class="dialog-chooseIcon">
        <i class="icon-choose" v-for="item in icons" :class="item.icon" aria-hidden="true"
           @click="dialog.selectIcon.visible=false;form.data.icon=item.icon"></i>
    </el-dialog>
</div>
<%@include file="/WEB-INF/views/include/blankScript.jsp" %>
<script src="/static/js/functions/sys/functionManager.js"></script>
</body>
</html>