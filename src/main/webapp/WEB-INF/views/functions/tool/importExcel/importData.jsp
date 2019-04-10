<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>数据导入</title>
    <%@include file="/WEB-INF/views/include/blankHead.jsp" %>
    <link rel="stylesheet" href="/static/css/functions/tool/importExcel/importData.css"/>
</head>
<body>
<div id="app" v-cloak>
    <el-form ref="form" :model="formData" label-width="150px" style="padding: 34px 24px;" size="small"
             label-position="left">
        <el-form-item label="选择模板">
            <el-select @change="onSelectChange" v-model="formData.id">
                <el-option v-for="excelTemplate in excelTemplateList" :label="excelTemplate.templateName"
                           :key="excelTemplate.id" :value="excelTemplate.id"></el-option>
            </el-select>
        </el-form-item>
        <el-form-item label="下载excel模板">
            <el-button type="primary" icon="el-icon-download" style="font-size: 20px;padding: 4px 14px;"
            @click="downloadExcelTemplate()"></el-button>
        </el-form-item>
        <el-form-item label="上传数据文件">
            <Upload type="drag" action="/api/tool/file/uploadTempFile" ref="upload"
                    :before-upload="beforeUpload" :on-success="onUploadSuccess"
                    :default-file-list="defaultFileList" style="width: 50%" size="small">
                <div style="padding: 20px 0">
                    <Icon type="ios-cloud-upload" size="52" style="color: #3399ff"></Icon>
                    <p style="color: darkgray;">点击或者拖拽文件上传</p>
                </div>
            </Upload>
        </el-form-item>
        <el-form-item>
            <el-button type="success" @click="startImport()" :loading="loading.importing">开始导入</el-button>
        </el-form-item>
    </el-form>
</div>
<%@include file="/WEB-INF/views/include/blankScript.jsp" %>
<script src="/static/js/functions/tool/importExcel/importData.js"></script>
</body>
</html>