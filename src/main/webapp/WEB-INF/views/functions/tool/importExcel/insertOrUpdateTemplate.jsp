<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>更新或插入模板</title>
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
    <div v-show="currentStep==0" style="padding: 10px 20px 10px 20px;">
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
    <div v-show="currentStep==1" style="margin: 5px 0px 45px 0px">
        <card style="padding: 0px 0px 0px 0px;height: 330px;overflow: auto;">
            <el-row v-for="columnMapField in columnMapFieldList">
                <el-row class="map-title">
                    <span class="map-title-item">
                        <span class="map-title-tip">字段名: </span>
                        {{ columnMapField.fieldName }}
                    </span>
                    <span class="map-title-item">
                        <span class="map-title-tip">类型: </span>
                        {{ columnMapField.fieldType }}
                    </span>
                    <span class="map-title-item">
                        <span class="map-title-tip">注释: </span>
                        {{ columnMapField.fieldComment }}
                    </span>
                </el-row>
                <el-row style="font-size: 14px;margin: 3px 0 5px 0;line-height: 32px;">
                    <el-col :span="2">
                        <i-switch v-model="columnMapField.fixed" @on-change="columnMapField.fk=false"
                                  size="large">
                            <span slot="open">固定</span>
                            <span slot="close">固定</span>
                        </i-switch>
                    </el-col>
                    <el-col :span="2">
                        <i-switch v-model="columnMapField.fk" @on-change="columnMapField.fixed=false"
                                  style="margin-left: 10px;" size="large">
                            <span slot="open">外键</span>
                            <span slot="close">外键</span>
                        </i-switch>
                    </el-col>
                    <el-col :offset="1" :span="6">
                        <i-select v-model="columnMapField.columnIndex" placeholder="请选择导入的excel列名"
                        <%-- 同时设置列名 --%>
                                  @on-change="columnMapField.columnName=$event ? $event.label : null"
                                  clearable filterable size="small" :label-in-value="true">
                            <i-option v-for="excelColumn in excelColumnList" :key="excelColumn.columnIndex"
                                      :label="excelColumn.columnName" :value="excelColumn.columnIndex"></i-option>
                        </i-select>
                    </el-col>
                </el-row>
                <el-row style="font-size: 14px;margin: 3px 0 5px 0;line-height: 32px;" v-if="columnMapField.fk">
                    <el-col :span="8">
                        <i-select size="small" placeholder="请选择外表" clearable filterable
                                  v-model="columnMapField.fkTableName" style="width: 90%;"
                                  @on-change="">
                            <i-option v-for="tableName in tableList" :key="tableName"
                                      :label="tableName" :value="tableName"></i-option>
                        </i-select>
                    </el-col>
                    <el-col :span="8">
                        <i-select size="small" placeholder="请选择原字段" clearable filterable
                                  v-model="columnMapField.fkCurrentField" style="width: 90%;">
                            <i-option v-for="in columnMapField.columnList"></i-option>
                        </i-select>
                    </el-col>
                    <el-col :span="8">
                        <i-select size="small" placeholder="请选择替换字段" clearable filterable
                                  v-model="columnMapField.fkReplaceField" style="width: 90%;">
                            <i-option></i-option>
                        </i-select>
                    </el-col>
                </el-row>
                <el-row style="font-size: 14px;margin: 3px 0 5px 0;line-height: 32px;"
                        v-if="columnMapField.fixed"></el-row>
                <hr style="margin-bottom: 10px;border-color: rgb(82,167,255);">
            </el-row>
        </card>
    </div>
    <%-- 右下按钮 --%>
    <div style="position: absolute;bottom: 27px;right: 45px;">
        <span v-if="currentStep==0">
            <el-button size="small" type="success" @click="nextStep()">下一步</el-button>
        </span>
        <span v-if="currentStep==1">
            <el-button size="small" type="warning" @click="beforeStep()">上一步</el-button>
            <el-button size="small" type="success" @click="submit()">提&nbsp;&nbsp;&nbsp;交</el-button>
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