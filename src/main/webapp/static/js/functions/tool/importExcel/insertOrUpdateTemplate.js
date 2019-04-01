let app = new Vue({
    el: '#app',
    data: {
        currentStep: 0,                 // 当前进行到的步骤(共2步)
        tableList: [],                  // 数据库中的所有表(供选择)
        urls: {
            showTables: '/api/tool/importExcel/showTables',
            getColumnsInTableAndExcel: '/api/tool/importExcel/getColumnsInTableAndExcel',
            insertExcelTemplate: '/api/tool/excelTemplate/insert'
        },
        fullScreenLoading: false,
        defaultFileList: [],            // 默认的文件列表(最多一个)
        currentTemplateName: null,      // 当前上传的excel文件在服务端存储的名字
        currentTableName: null,         // 当前选择的表名
        excelColumnList: [],         // excel列(供选择)
        columnMapFieldList: [],            // excel列到table字段的映射(以table字段为基准)
        templateName: null,
        loading: {
            step1: false,
            step2: false,
        }
    },
    methods: {
        // 上传模板前调用
        beforeUpload: function (file) {
            let suffix = file.name.split('.').pop();
            if (suffix !== 'xlsx') {
                window.parent.parent.parent.app.showMessage('仅支持xlsx文件', 'error');
                return false;
            }
        },
        // 上传完成后调用
        onUploadSuccess: function (res, file) {
            this.currentTemplateName = res.data;
            this.defaultFileList[0] = file;
            this.$refs.upload.fileList.pop();
            this.$refs.upload.fileList[0] = file;
        },
        // 下一步(进入列名映射)
        nextStep: function () {
            let app = this;
            let data = {
                tableName: app.currentTableName,
                excelName: app.currentTemplateName
            };
            app.loading.step1 = true;
            ajaxPost(app.urls.getColumnsInTableAndExcel, data, function (d) {
                app.excelColumnList = d.data.excelColumnList;
                app.columnMapFieldList = d.data.columnMapFieldList;
                app.currentStep += 1;
                app.loading.step1 = false;
            })
        },
        // 上一步(选择和上传)
        beforeStep: function () {
            this.currentStep -= 1;
        },
        // 提交模板信息(创建新模板)
        submit: function () {
            let app = this;
            let data = {
                templateName: app.templateName,
                tableName: app.currentTableName,
                excelName: app.currentTemplateName,
                columnMapFieldList: app.columnMapFieldList
            };
            app.loading.step2 = true;
            ajaxPostJSON(app.urls.insertExcelTemplate, data, function (d) {
                app.loading.step2 = false;
                window.parent.parent.parent.app.showMessage('新建模板成功!');
                window.parent.app.insertOrUpdateDialog.visible = false;
            })
        },
    },
    mounted: function () {
        let app = this;
        app.fullScreenLoading = false;
        ajaxPost(app.urls.showTables, null, function (d) {
            app.tableList = d.data;
        })
    }
});