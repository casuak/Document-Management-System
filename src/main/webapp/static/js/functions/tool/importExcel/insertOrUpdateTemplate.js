let app = new Vue({
    el: '#app',
    data: {
        currentStep: 1,                 // 当前进行到的步骤(共2步)
        tableList: [],                  // 数据库中的所有表(供选择)
        urls: {
            showTables: '/api/tool/excelTemplate/showTables',
            selectAllFieldsInTable: '/api/tool/excelTemplate/selectAllFieldsInTable',
            getColumnsInTableAndExcel: '/api/tool/excelTemplate/getColumnsInTableAndExcel',
            insertOrUpdateExcelTemplate: '/api/tool/excelTemplate/insertOrUpdate',
            selectExcelTemplateById: '/api/tool/excelTemplate/selectById'
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
            table: false
        },
        expandRowKeys: [],
        pageParams: {
            status: 'insert', // or update
            templateId: ''
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
            if (pageParams.status === 'update') {
                this.currentStep += 1;
                return;
            }
            let app = this;
            let data = {
                tableName: app.currentTableName,
                excelName: app.currentTemplateName
            };
            app.loading.step1 = true;
            ajaxPost(app.urls.getColumnsInTableAndExcel, data, function (d) {
                app.excelColumnList = d.data.excelColumnList;
                app.columnMapFieldList = d.data.columnMapFieldList;
                for (let i = 0; i < app.columnMapFieldList.length; i++) {
                    app.columnMapFieldList[i].loading_fkFieldList = false;
                    app.columnMapFieldList[i].fkFieldList = [];
                }
                console.log(JSON.stringify(app.excelColumnList));
                console.log(JSON.stringify(app.columnMapFieldList));
                app.currentStep += 1;
                app.loading.step1 = false;
            })
        },
        // 上一步(选择和上传)
        beforeStep: function () {
            this.currentStep -= 1;
        },
        // 提交模板信息(创建或更新模板)
        submit: function () {
            let app = this;
            let data = {
                id: app.templateId ? app.templateId : null,
                templateName: app.templateName,
                tableName: app.currentTableName,
                excelName: app.currentTemplateName,
                enable: app.enable,
                columnMapFieldList: app.columnMapFieldList
            };
            app.loading.step2 = true;
            ajaxPostJSON(app.urls.insertOrUpdateExcelTemplate, data, function (d) {
                app.loading.step2 = false;
                let msg = '更新模板成功!';
                if (pageParams.status === 'insert')
                    msg = '新建模板成功!';
                window.parent.parent.parent.app.showMessage(msg);
                window.parent.app.insertOrUpdateDialog.visible = false;
            })
        },
        // save column name
        setColumnName($event, row) {
            for (let i = 0; i < this.excelColumnList.length; i++) {
                if (this.excelColumnList[i].columnIndex === $event) {
                    row.columnName = this.excelColumnList[i].columnName;
                    return;
                }
            }
        },
        // called when fkTableName change
        onFkTableNameChange: function ($event, row, index) {
            let app = this;
            let data = {
                tableName: $event
            };
            row.loading_fkFieldList = true;
            row.fkCurrentField = null;
            row.fkReplaceField = null;
            ajaxPost(app.urls.selectAllFieldsInTable, data, function (d) {
                row.fkFieldList = d.data;
                app.$set(row, 'loading_fkFieldList', false);
                app.columnMapFieldList.push({});
                app.columnMapFieldList.pop();
            }, null, true);
        },
        onExpandChange: function (row, expandedRow) {
            this.expandRowKeys = [];
            for (let i = 0; i < expandedRow.length; i++) {
                this.expandRowKeys.push(expandedRow[i].fieldName);
            }
        }
    },
    mounted: function () {
        let app = this;
        app.fullScreenLoading = true;
        app.pageParams = pageParams;
        // get table list
        ajaxPost(app.urls.showTables, null, function (d) {
            app.tableList = d.data;
            app.fullScreenLoading = false;
            // set step according to page status
            if (pageParams.status === 'insert') {
                app.currentStep = 0;
            } else {
                app.currentStep = 1;
                let data = {templateId: pageParams.templateId};
                app.fullScreenLoading = true;
                ajaxPost(app.urls.selectExcelTemplateById, data, function (d) {
                    app.fullScreenLoading = false;
                    app.columnMapFieldList = d.data.columnMapFieldList;
                    app.excelColumnList = d.data.excelColumnList;
                    app.currentTableName = d.data.tableName;
                    app.currentTemplateName = d.data.excelName;
                    app.templateName = d.data.templateName;
                    app.templateId = d.data.id;
                    app.enable = d.data.enable;
                })
            }
        })
    }
});