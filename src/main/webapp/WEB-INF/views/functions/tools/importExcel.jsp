<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>ssm</title>
    <%@include file="/WEB-INF/views/include/blankHead.jsp" %>
    <link rel="stylesheet" href="/static/css/functions/tools/importExcel.css"/>
</head>
<body>
<div id="app" v-cloak>
    <div style="padding: 30px">
        <Steps :current="currentStep" status="process">
            <Step title="选择导入的Excel文件" content="这里是该步骤的描述信息"></Step>
            <Step title="选择导入的表" content="这里是该步骤的描述信息"></Step>
            <Step title="列名映射" content="包括选择是否自动生成id，字典id替换"></Step>
            <Step title="完成" content="这里是该步骤的描述信息"></Step>
        </Steps>
        <div style="margin-top: 30px;width: 50%;">
            <el-card v-if="currentStep==0">
                <div slot="header">
                    <span>选择导入的Excel文件</span>
                </div>
                <div>
                    <Upload type="drag" action="/api/tools/tempFile/upload" ref="upload"
                            :before-upload="beforeUpload" :on-success="onUploadSuccess"
                            :default-file-list="fileList">
                        <div style="padding: 20px 0">
                            <Icon type="ios-cloud-upload" size="52" style="color: #3399ff"></Icon>
                            <p>Click or drag files here to upload</p>
                        </div>
                    </Upload>
                    <el-row type="flex" justify="end" style="margin-top: 15px;">
                        <el-col :span="12">
                            <span style="float: right;">
                                <el-button type="success" size="small" @click="currentStep += 1"
                                           :loading="loading.step1">下一步</el-button>
                            </span>
                        </el-col>
                    </el-row>
                </div>
            </el-card>
            <el-card v-if="currentStep==1">
                <div slot="header">
                    <span>选择导入的表</span>
                </div>
                <div>
                    <i-select v-model="options.tableList.value" placeholder="请选择导入的表">
                        <i-option v-for="(item, index) in options.tableList.data" :key="index" :label="item"
                                  :value="item"></i-option>
                    </i-select>
                    <el-row type="flex" justify="end" style="margin-top: 15px;">
                        <el-col :span="12">
                            <span style="float: right;">
                                <el-button type="primary" size="small" @click="currentStep -= 1;">上一步</el-button>
                                <el-button type="success" size="small" :loading="loading.step2"
                                           @click="getColumnsInTableAndExcel()">下一步</el-button>
                            </span>
                        </el-col>
                    </el-row>
                </div>
            </el-card>
            <el-card v-if="currentStep==2">
                <div slot="header">
                    <span>列名映射</span>
                </div>
                <div>
                    <el-form size="mini" label-position="top">
                        <el-form-item v-for="tableColumn in tableColumnList"
                                      :label="tableColumn.name + '(' + tableColumn.comment + ')' + '(' + tableColumn.type + ')'">
                            <el-select v-model="tableColumn.excelColumnIndex" clearable>
                                <el-option v-for="excelColumn in excelColumnList" :key="excelColumn.colIndex"
                                           :label="excelColumn.name"
                                           :value="excelColumn.colIndex"></el-option>
                            </el-select>
                        </el-form-item>
                    </el-form>
                    <el-row type="flex" justify="end" style="margin-top: 15px;">
                        <el-col :span="12">
                            <span style="float: right;">
                                <el-button type="primary" size="small" @click="currentStep -= 1">上一步</el-button>
                                <el-button type="success" size="small" @click="excelToTable()">开始导入</el-button>
                            </span>
                        </el-col>
                    </el-row>
                </div>
            </el-card>
            <el-card v-if="currentStep==3">
                <div slot="header">
                    <span>完成</span>
                </div>
                <div>
                    <el-row type="flex" justify="end" style="margin-top: 15px;">
                        <el-col :span="12">
                            <span style="float: right;">
                                <el-button type="warning" size="small" @click="currentStep=0">再次导入</el-button>
                            </span>
                        </el-col>
                    </el-row>
                </div>
            </el-card>
        </div>
    </div>
</div>
<%@include file="/WEB-INF/views/include/blankScript.jsp" %>
<script src="/static/js/functions/tools/importExcel.js"></script>
</body>
</html>