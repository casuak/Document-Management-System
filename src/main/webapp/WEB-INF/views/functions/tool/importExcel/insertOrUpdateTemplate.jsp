<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>添加或更新模板表单</title>
    <%@include file="/WEB-INF/views/include/blankHead.jsp" %>
    <link rel="stylesheet" href="/static/css/functions/tool/importExcel/insertOrUpdateTemplate.css"/>
</head>
<body>
<div id="app" v-cloak v-loading="fullScreenLoading">
    <Steps :current="currentStep" status="process" style="padding: 10px 20px;">
        <Step title="选择和上传" content=""></Step>
        <Step title="列名映射" content=""></Step>
    </Steps>
    <%-- 步骤1 --%>
    <div v-if="currentStep==0" style="padding: 10px 20px 10px 20px;">
        <el-row>
            &nbsp;模板名称
        </el-row>
        <el-row style="margin-top: 10px;margin-bottom: 15px;">
            <el-col :span="17">
                <i-input v-model="templateName" placeholder="请输入新建的模板名称"/>
            </el-col>
        </el-row>
        <el-row v-if="pageParams.status === 'insert'">
            &nbsp;选择表
        </el-row>
        <el-row style="margin-top: 10px;margin-bottom: 15px;" v-if="pageParams.status === 'insert'">
            <el-col :span="17">
                <i-Select v-model="currentTableName">
                    <i-Option v-for="tableName in tableList" :value="tableName" :key="tableName">{{ tableName }}
                    </i-Option>
                </i-Select>
            </el-col>
        </el-row>
        <el-row v-if="pageParams.status === 'insert'">
            &nbsp;上传excel模板
        </el-row>
        <el-row style="margin-top: 10px;" v-if="pageParams.status === 'insert'">
            <el-col :span="17">
                <Upload type="drag" action="/api/tool/file/uploadTempFile" ref="upload"
                        :before-upload="beforeUpload" :on-success="onUploadSuccess"
                        :default-file-list="defaultFileList">
                    <div style="padding: 20px 0">
                        <Icon type="ios-cloud-upload" size="52" style="color: #3399ff"></Icon>
                        <p style="color: darkgray;">点击或者拖拽文件上传</p>
                    </div>
                </Upload>
            </el-col>
        </el-row>
    </div>
    <%-- 步骤2 --%>
    <div v-if="currentStep==1" style="margin-bottom: 45px;height: 100%;">
        <el-table :data="columnMapFieldList" size="mini" height="360" v-loading="loading.table" ref="table"
                  @expand-change="onExpandChange" row-key="fieldName" :expand-row-keys="expandRowKeys">
            <el-table-column type="expand">
                <template slot-scope="{row, $index}">
                    <el-form label-position="left" class="demo-table-expand" size="mini">
                        <el-form-item label="字段类型">
                            <span style="font-size: 13px;">{{ row.fieldType }}</span>
                        </el-form-item>
                        <el-form-item label="字段注释">
                            <span style="font-size: 13px;">{{ row.fieldComment }}</span>
                        </el-form-item>
                        <el-form-item label="外表" v-show="row.fk">
                            <el-select clearable filterable style="width: 250px;margin-right: 10px;"
                                       v-model="row.fkTableName" @change="onFkTableNameChange($event, row, $index)">
                                <el-option v-for="tableName in tableList" :key="tableName" :value="tableName"
                                           :label="tableName"></el-option>
                            </el-select>
                        </el-form-item>
                        <el-form-item label="原字段" v-if="row.fk">
                            <el-select clearable filterable style="width: 250px;margin-right: 10px;"
                                       v-model="row.fkCurrentField" :loading="row.loading_fkFieldList">
                                <el-option v-for="tableField in row.fkFieldList" :key="tableField.fieldName"
                                           :value="tableField.fieldName" :label="tableField.fieldName"></el-option>
                            </el-select>
                        </el-form-item>
                        <el-form-item label="替换字段" v-if="row.fk">
                            <el-select clearable filterable style="width: 250px;margin-right: 10px;"
                                       v-model="row.fkReplaceField" :loading="row.loading_fkFieldList">
                                <el-option v-for="tableField in row.fkFieldList" :key="tableField.fieldName"
                                           :value="tableField.fieldName" :label="tableField.fieldName"></el-option>
                            </el-select>
                        </el-form-item>
                        <el-form-item label="固定值" v-if="row.fixed">
                            <i-input v-model="row.fixedContent" style="width: 300px;" size="small"
                                     placeholder="请输入" style="position: relative;bottom: 1px;"></i-input>
                        </el-form-item>
                    </el-form>
                </template>
            </el-table-column>
            <el-table-column label="字段名" width="200" prop="fieldName"></el-table-column>
            <el-table-column label="请选择导入的excel中的列名" width="200">
                <template slot-scope="{row}">
                    <el-select v-model="row.columnIndex" clearable filterable size="mini"
                               @clear="row.columnIndex=-1;row.columnName=null"
                               @change="setColumnName($event, row)" :disabled="row.fixed">
                        <el-option v-for="excelColumn in excelColumnList" :key="excelColumn.columnIndex"
                                   :label="excelColumn.columnName" :value="excelColumn.columnIndex"></el-option>
                        <el-option v-show="false" :key="-1" :value="-1" label="请选择"></el-option>
                    </el-select>
                </template>
            </el-table-column>
            <el-table-column label="外  键" width="80" align="center">
                <template slot-scope="{row}">
                    <el-switch v-model="row.fk"
                               @change="row.fixed=false;$refs.table.toggleRowExpansion(row, $event)"></el-switch>
                </template>
            </el-table-column>
            <el-table-column label="固定值" width="80" align="center">
                <template slot-scope="{row}">
                    <el-switch v-model="row.fixed"
                               @change="row.fk=false;$refs.table.toggleRowExpansion(row, $event)"></el-switch>
                </template>
            </el-table-column>
            <el-table-column></el-table-column>
        </el-table>
    </div>
    <%-- 右下按钮 --%>
    <div style="position: absolute;bottom: 27px;right: 45px;">
        <span v-if="currentStep==0">
            <el-button size="small" type="success" @click="nextStep()" :loading="loading.step1">下一步</el-button>
        </span>
        <span v-if="currentStep==1">
            <el-button size="small" type="warning" @click="beforeStep()" :loading="loading.step2">上一步</el-button>
            <el-button size="small" type="success" @click="submit()"
                       :loading="loading.step2">提&nbsp;&nbsp;&nbsp;交</el-button>
        </span>
    </div>
</div>
<%@include file="/WEB-INF/views/include/blankScript.jsp" %>
<script>
    // 接收页面初始化参数
    let pageParams = {};
    pageParams.status = ${status};
    pageParams.templateId = ${templateId};
</script>
<script src="/static/js/functions/tool/importExcel/insertOrUpdateTemplate.js"></script>
</body>
</html>