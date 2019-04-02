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
        <el-row>
            &nbsp;选择表
        </el-row>
        <el-row style="margin-top: 10px;margin-bottom: 15px;">
            <el-col :span="17">
                <i-Select v-model="currentTableName">
                    <i-Option v-for="tableName in tableList" :value="tableName" :key="tableName">{{ tableName }}
                    </i-Option>
                </i-Select>
            </el-col>
        </el-row>
        <el-row>
            &nbsp;上传excel模板
        </el-row>
        <el-row style="margin-top: 10px;">
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
        <%--<i-table :columns="columns" :data="columnMapFieldList" size="small"--%>
        <%--style="display: none;" height="360">--%>
        <%--<template slot-scope="{row, index}" slot="columnIndex">--%>
        <%--<el-select :value="row.columnIndex" clearable filterable size="mini"--%>
        <%--@change="columnMapFieldList[index].columnIndex=$event">--%>
        <%--<el-option v-for="excelColumn in excelColumnList" :key="excelColumn.columnIndex"--%>
        <%--:label="excelColumn.columnName" :value="excelColumn.columnIndex"></el-option>--%>
        <%--</el-select>--%>
        <%--</template>--%>
        <%--<template slot-scope="{row}" slot="fk">--%>
        <%--<i-switch v-model="row.fk" @on-change="row.fixed=false"></i-switch>--%>
        <%--</template>--%>
        <%--<template slot-scope="{row}" slot="fixed">--%>
        <%--<i-switch v-model="row.fixed" @on-change="row.fk=false"></i-switch>--%>
        <%--</template>--%>
        <%--<template slot-scope="{row}" slot="custom">--%>
        <%--<span v-if="row.fk">--%>
        <%--外表：--%>
        <%--<el-select size="mini" clearable filterable style="width: 180px;margin-right: 10px;"--%>
        <%--v-model="row.fkTableName">--%>
        <%--<el-option v-for="tableName in tableList" :key="tableName" :value="tableName"--%>
        <%--:label="tableName"></el-option>--%>
        <%--</el-select>--%>
        <%--原字段：--%>
        <%--<el-select size="mini" clearable filterable style="width: 180px;margin-right: 10px;"--%>
        <%--v-model="row.fkTableName">--%>
        <%--<el-option v-for="tableName in tableList" :key="tableName" :value="tableName"--%>
        <%--:label="tableName"></el-option>--%>
        <%--</el-select>--%>
        <%--替换字段：--%>
        <%--<el-select size="mini" clearable filterable style="width: 180px;"--%>
        <%--v-model="row.fkTableName">--%>
        <%--<el-option v-for="tableName in tableList" :key="tableName" :value="tableName"--%>
        <%--:label="tableName"></el-option>--%>
        <%--</el-select>--%>
        <%--</span>--%>
        <%--<span v-if="row.fixed">--%>
        <%--固定值：--%>
        <%--</span>--%>
        <%--</template>--%>
        <%--</i-table>--%>

        <el-table :data="columnMapFieldList" size="mini" height="360">
            <el-table-column type="expand">
                <template slot-scope="{row}">
                    <el-form label-position="left" class="demo-table-expand" size="mini">
                        <el-form-item label="字段类型">
                            <span>{{ row.fieldType }}</span>
                        </el-form-item>
                        <el-form-item label="字段注释">
                            <span>{{ row.fieldComment }}</span>
                        </el-form-item>
                        <el-form-item label="外表" v-show="row.fk">
                            <el-select clearable filterable style="width: 250px;margin-right: 10px;"
                                       v-model="row.fkTableName">
                                <el-option v-for="tableName in tableList" :key="tableName" :value="tableName"
                                           :label="tableName"></el-option>
                            </el-select>
                        </el-form-item>
                        <el-form-item label="原字段" v-show="row.fk">
                            <el-select clearable filterable style="width: 250px;margin-right: 10px;"
                                       v-model="row.fkTableName">
                                <el-option v-for="tableName in tableList" :key="tableName" :value="tableName"
                                           :label="tableName"></el-option>
                            </el-select>
                        </el-form-item>
                        <el-form-item label="替换字段" v-show="row.fk">
                            <el-select clearable filterable style="width: 250px;margin-right: 10px;"
                                       v-model="row.fkTableName">
                                <el-option v-for="tableName in tableList" :key="tableName" :value="tableName"
                                           :label="tableName"></el-option>
                            </el-select>
                        </el-form-item>
                    </el-form>
                </template>
            </el-table-column>
            <el-table-column label="字段名" width="200" prop="fieldName"></el-table-column>
            <el-table-column label="请选择导入的excel中的列名" width="200">
                <template slot-scope="{row}">
                    <el-select v-model="row.columnIndex" clearable filterable size="mini"
                               @clear="row.columnIndex=-1;row.columnName=null"
                               @change="setColumnName($event, row)">
                        <el-option v-for="excelColumn in excelColumnList" :key="excelColumn.columnIndex"
                                   :label="excelColumn.columnName" :value="excelColumn.columnIndex"></el-option>
                        <el-option v-show="false" :key="-1" :value="-1" label="请选择"></el-option>
                    </el-select>
                </template>
            </el-table-column>
            <el-table-column label="外  键" width="80" align="center">
                <template slot-scope="{row}">
                    <i-switch v-model="row.fk" @on-change="row.fixed=false"></i-switch>
                </template>
            </el-table-column>
            <el-table-column label="固定值" width="80" align="center">
                <template slot-scope="{row}">
                    <i-switch v-model="row.fixed" @on-change="row.fk=false"></i-switch>
                </template>
            </el-table-column>
            <el-table-column></el-table-column>
        </el-table>

        <%--<card style="padding: 0;height: calc(100% - 120px);overflow: auto;">--%>
        <%--<el-row v-for="columnMapField in columnMapFieldList">--%>
        <%--<el-row class="map-title">--%>
        <%--<span class="map-title-item">--%>
        <%--<span class="map-title-tip">字段名: </span>--%>
        <%--{{ columnMapField.fieldName }}--%>
        <%--</span>--%>
        <%--<span class="map-title-item">--%>
        <%--<span class="map-title-tip">类型: </span>--%>
        <%--{{ columnMapField.fieldType }}--%>
        <%--</span>--%>
        <%--<span class="map-title-item">--%>
        <%--<span class="map-title-tip">注释: </span>--%>
        <%--{{ columnMapField.fieldComment }}--%>
        <%--</span>--%>
        <%--</el-row>--%>
        <%--<el-row style="font-size: 14px;margin: 3px 0 5px 0;line-height: 32px;">--%>
        <%--<el-col :span="2">--%>
        <%--<i-switch v-model="columnMapField.fixed" @on-change="columnMapField.fk=false"--%>
        <%--size="large">--%>
        <%--<span slot="open">固定</span>--%>
        <%--<span slot="close">固定</span>--%>
        <%--</i-switch>--%>
        <%--</el-col>--%>
        <%--<el-col :span="2">--%>
        <%--<i-switch v-model="columnMapField.fk" @on-change="columnMapField.fixed=false"--%>
        <%--style="margin-left: 10px;" size="large">--%>
        <%--<span slot="open">外键</span>--%>
        <%--<span slot="close">外键</span>--%>
        <%--</i-switch>--%>
        <%--</el-col>--%>
        <%--<el-col :offset="1" :span="6">--%>
        <%--<i-select v-model="columnMapField.columnIndex" placeholder="请选择导入的excel列名"--%>
        <%--&lt;%&ndash; 同时设置列名 &ndash;%&gt;--%>
        <%--@on-change="columnMapField.columnName=$event ? $event.label : null"--%>
        <%--clearable filterable size="small" :label-in-value="true">--%>
        <%--<i-option v-for="excelColumn in excelColumnList" :key="excelColumn.columnIndex"--%>
        <%--:label="excelColumn.columnName" :value="excelColumn.columnIndex"></i-option>--%>
        <%--</i-select>--%>
        <%--</el-col>--%>
        <%--</el-row>--%>
        <%--<el-row style="font-size: 14px;margin: 3px 0 5px 0;line-height: 32px;" v-if="columnMapField.fk">--%>
        <%--<el-col :span="8">--%>
        <%--<i-select size="small" placeholder="请选择外表" clearable filterable--%>
        <%--v-model="columnMapField.fkTableName" style="width: 90%;"--%>
        <%--@on-change="">--%>
        <%--<i-option v-for="tableName in tableList" :key="tableName"--%>
        <%--:label="tableName" :value="tableName"></i-option>--%>
        <%--</i-select>--%>
        <%--</el-col>--%>
        <%--<el-col :span="8">--%>
        <%--<i-select size="small" placeholder="请选择原字段" clearable filterable--%>
        <%--v-model="columnMapField.fkCurrentField" style="width: 90%;">--%>
        <%--<i-option v-for="in columnMapField.columnList"></i-option>--%>
        <%--</i-select>--%>
        <%--</el-col>--%>
        <%--<el-col :span="8">--%>
        <%--<i-select size="small" placeholder="请选择替换字段" clearable filterable--%>
        <%--v-model="columnMapField.fkReplaceField" style="width: 90%;">--%>
        <%--<i-option></i-option>--%>
        <%--</i-select>--%>
        <%--</el-col>--%>
        <%--</el-row>--%>
        <%--<el-row style="font-size: 14px;margin: 3px 0 5px 0;line-height: 32px;"--%>
        <%--v-if="columnMapField.fixed"></el-row>--%>
        <%--<hr style="margin-bottom: 10px;border-color: rgb(82,167,255);">--%>
        <%--</el-row>--%>
        <%--</card>--%>
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