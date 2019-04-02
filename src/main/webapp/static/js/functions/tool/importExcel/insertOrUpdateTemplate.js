let app = new Vue({
    el: '#app',
    data: {
        currentStep: 1,                 // 当前进行到的步骤(共2步)
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
        excelColumnList: [
            {"columnName": "PT", "columnIndex": 0}, {
                "columnName": "AU",
                "columnIndex": 1
            }, {"columnName": "BA", "columnIndex": 2}, {"columnName": "BE", "columnIndex": 3}, {
                "columnName": "GP",
                "columnIndex": 4
            }, {"columnName": "AF", "columnIndex": 5}, {"columnName": "BF", "columnIndex": 6}, {
                "columnName": "CA",
                "columnIndex": 7
            }, {"columnName": "TI", "columnIndex": 8}, {"columnName": "SO", "columnIndex": 9}, {
                "columnName": "SE",
                "columnIndex": 10
            }, {"columnName": "BS", "columnIndex": 11}, {"columnName": "LA", "columnIndex": 12}, {
                "columnName": "DT",
                "columnIndex": 13
            }, {"columnName": "CT", "columnIndex": 14}, {"columnName": "CY", "columnIndex": 15}, {
                "columnName": "CL",
                "columnIndex": 16
            }, {"columnName": "SP", "columnIndex": 17}, {"columnName": "HO", "columnIndex": 18}, {
                "columnName": "DE",
                "columnIndex": 19
            }, {"columnName": "ID", "columnIndex": 20}, {"columnName": "AB", "columnIndex": 21}, {
                "columnName": "C1",
                "columnIndex": 22
            }, {"columnName": "单位名称", "columnIndex": 23}, {"columnName": "PU", "columnIndex": 35}, {
                "columnName": "PI",
                "columnIndex": 36
            }, {"columnName": "PA", "columnIndex": 37}, {"columnName": "SN", "columnIndex": 38}, {
                "columnName": "EI",
                "columnIndex": 39
            }, {"columnName": "BN", "columnIndex": 40}, {"columnName": "J9", "columnIndex": 41}, {
                "columnName": "JI",
                "columnIndex": 42
            }, {"columnName": "PD", "columnIndex": 43}, {"columnName": "PY", "columnIndex": 44}, {
                "columnName": "VL",
                "columnIndex": 45
            }, {"columnName": "IS", "columnIndex": 46}, {"columnName": "PN", "columnIndex": 47}, {
                "columnName": "SU",
                "columnIndex": 48
            }, {"columnName": "SI", "columnIndex": 49}, {"columnName": "MA", "columnIndex": 50}, {
                "columnName": "BP",
                "columnIndex": 51
            }, {"columnName": "EP", "columnIndex": 52}, {"columnName": "AR", "columnIndex": 53}, {
                "columnName": "DI",
                "columnIndex": 54
            }, {"columnName": "D2", "columnIndex": 55}, {"columnName": "EA", "columnIndex": 56}, {
                "columnName": "EY",
                "columnIndex": 57
            }, {"columnName": "PG", "columnIndex": 58}, {"columnName": "WC", "columnIndex": 59}, {
                "columnName": "SC",
                "columnIndex": 60
            }, {"columnName": "GA", "columnIndex": 61}, {"columnName": "UT", "columnIndex": 62}, {
                "columnName": "PM",
                "columnIndex": 63
            }, {"columnName": "OA", "columnIndex": 64}, {"columnName": "HC", "columnIndex": 65}, {
                "columnName": "HP",
                "columnIndex": 66
            }, {"columnName": "DA", "columnIndex": 67}],         // excel列(供选择)
        columnMapFieldList: [
            {
                "id": null,
                "remarks": null,
                "createUserId": null,
                "modifyUserId": null,
                "createDate": null,
                "modifyDate": null,
                "delFlag": false,
                "page": null,
                "templateId": null,
                "fieldName": "author_list",
                "columnName": null,
                "columnIndex": -1,
                "fk": false,
                "fkTableName": null,
                "fkCurrentField": null,
                "fkReplaceField": null,
                "fkMessage": null,
                "fixed": false,
                "fixedContent": null,
                "tableName": null,
                "fieldComment": "全体作者名列表",
                "fieldType": "varchar"
            }, {
                "id": null,
                "remarks": null,
                "createUserId": null,
                "modifyUserId": null,
                "createDate": null,
                "modifyDate": null,
                "delFlag": false,
                "page": null,
                "templateId": null,
                "fieldName": "first_author_name",
                "columnName": null,
                "columnIndex": -1,
                "fk": false,
                "fkTableName": null,
                "fkCurrentField": null,
                "fkReplaceField": null,
                "fkMessage": null,
                "fixed": false,
                "fixedContent": null,
                "tableName": null,
                "fieldComment": "第一作者名字（从列表中分割出来，再和用户表匹配）",
                "fieldType": "varchar"
            }, {
                "id": null,
                "remarks": null,
                "createUserId": null,
                "modifyUserId": null,
                "createDate": null,
                "modifyDate": null,
                "delFlag": false,
                "page": null,
                "templateId": null,
                "fieldName": "second_author_name",
                "columnName": null,
                "columnIndex": -1,
                "fk": false,
                "fkTableName": null,
                "fkCurrentField": null,
                "fkReplaceField": null,
                "fkMessage": null,
                "fixed": false,
                "fixedContent": null,
                "tableName": null,
                "fieldComment": "第二作者名字（同上）",
                "fieldType": "varchar"
            }, {
                "id": null,
                "remarks": null,
                "createUserId": null,
                "modifyUserId": null,
                "createDate": null,
                "modifyDate": null,
                "delFlag": false,
                "page": null,
                "templateId": null,
                "fieldName": "first_author_id",
                "columnName": null,
                "columnIndex": -1,
                "fk": false,
                "fkTableName": null,
                "fkCurrentField": null,
                "fkReplaceField": null,
                "fkMessage": null,
                "fixed": false,
                "fixedContent": null,
                "tableName": null,
                "fieldComment": "第一作者 from 用户表",
                "fieldType": "varchar"
            }, {
                "id": null,
                "remarks": null,
                "createUserId": null,
                "modifyUserId": null,
                "createDate": null,
                "modifyDate": null,
                "delFlag": false,
                "page": null,
                "templateId": null,
                "fieldName": "second_author_id",
                "columnName": null,
                "columnIndex": -1,
                "fk": false,
                "fkTableName": null,
                "fkCurrentField": null,
                "fkReplaceField": null,
                "fkMessage": null,
                "fixed": false,
                "fixedContent": null,
                "tableName": null,
                "fieldComment": "第二作者 from 用户表",
                "fieldType": "varchar"
            }, {
                "id": null,
                "remarks": null,
                "createUserId": null,
                "modifyUserId": null,
                "createDate": null,
                "modifyDate": null,
                "delFlag": false,
                "page": null,
                "templateId": null,
                "fieldName": "status",
                "columnName": null,
                "columnIndex": -1,
                "fk": false,
                "fkTableName": null,
                "fkCurrentField": null,
                "fkReplaceField": null,
                "fkMessage": null,
                "fixed": false,
                "fixedContent": null,
                "tableName": null,
                "fieldComment": "总体匹配状态:null:未初始化;0:未匹配;1:匹配出错;2:匹配成功;3:匹配完成",
                "fieldType": "varchar"
            }, {
                "id": null,
                "remarks": null,
                "createUserId": null,
                "modifyUserId": null,
                "createDate": null,
                "modifyDate": null,
                "delFlag": false,
                "page": null,
                "templateId": null,
                "fieldName": "status_1",
                "columnName": null,
                "columnIndex": -1,
                "fk": false,
                "fkTableName": null,
                "fkCurrentField": null,
                "fkReplaceField": null,
                "fkMessage": null,
                "fixed": false,
                "fixedContent": null,
                "tableName": null,
                "fieldComment": "第一作者匹配状态:0:成功;1:重名;2:无匹配",
                "fieldType": "varchar"
            }, {
                "id": null,
                "remarks": null,
                "createUserId": null,
                "modifyUserId": null,
                "createDate": null,
                "modifyDate": null,
                "delFlag": false,
                "page": null,
                "templateId": null,
                "fieldName": "status_2",
                "columnName": null,
                "columnIndex": -1,
                "fk": false,
                "fkTableName": null,
                "fkCurrentField": null,
                "fkReplaceField": null,
                "fkMessage": null,
                "fixed": false,
                "fixedContent": null,
                "tableName": null,
                "fieldComment": "第二作者匹配状态:0:成功;1:重名;2:无匹配",
                "fieldType": "varchar"
            }, {
                "id": null,
                "remarks": null,
                "createUserId": null,
                "modifyUserId": null,
                "createDate": null,
                "modifyDate": null,
                "delFlag": false,
                "page": null,
                "templateId": null,
                "fieldName": "paper_name",
                "columnName": null,
                "columnIndex": -1,
                "fk": false,
                "fkTableName": null,
                "fkCurrentField": null,
                "fkReplaceField": null,
                "fkMessage": null,
                "fixed": false,
                "fixedContent": null,
                "tableName": null,
                "fieldComment": "论文名",
                "fieldType": "varchar"
            }, {
                "id": null,
                "remarks": null,
                "createUserId": null,
                "modifyUserId": null,
                "createDate": null,
                "modifyDate": null,
                "delFlag": false,
                "page": null,
                "templateId": null,
                "fieldName": "store_num",
                "columnName": null,
                "columnIndex": -1,
                "fk": false,
                "fkTableName": null,
                "fkCurrentField": null,
                "fkReplaceField": null,
                "fkMessage": null,
                "fixed": false,
                "fixedContent": null,
                "tableName": null,
                "fieldComment": "入藏号",
                "fieldType": "varchar"
            }, {
                "id": null,
                "remarks": null,
                "createUserId": null,
                "modifyUserId": null,
                "createDate": null,
                "modifyDate": null,
                "delFlag": false,
                "page": null,
                "templateId": null,
                "fieldName": "doc_type",
                "columnName": null,
                "columnIndex": -1,
                "fk": false,
                "fkTableName": null,
                "fkCurrentField": null,
                "fkReplaceField": null,
                "fkMessage": null,
                "fixed": false,
                "fixedContent": null,
                "tableName": null,
                "fieldComment": "文献类型",
                "fieldType": "varchar"
            }, {
                "id": null,
                "remarks": null,
                "createUserId": null,
                "modifyUserId": null,
                "createDate": null,
                "modifyDate": null,
                "delFlag": false,
                "page": null,
                "templateId": null,
                "fieldName": "publish_date",
                "columnName": null,
                "columnIndex": -1,
                "fk": false,
                "fkTableName": null,
                "fkCurrentField": null,
                "fkReplaceField": null,
                "fkMessage": null,
                "fixed": false,
                "fixedContent": null,
                "tableName": null,
                "fieldComment": "出版日期",
                "fieldType": "datetime"
            }, {
                "id": null,
                "remarks": null,
                "createUserId": null,
                "modifyUserId": null,
                "createDate": null,
                "modifyDate": null,
                "delFlag": false,
                "page": null,
                "templateId": null,
                "fieldName": "ISSN",
                "columnName": null,
                "columnIndex": -1,
                "fk": false,
                "fkTableName": null,
                "fkCurrentField": null,
                "fkReplaceField": null,
                "fkMessage": null,
                "fixed": false,
                "fixedContent": null,
                "tableName": null,
                "fieldComment": "国际标准期刊号(期刊表中唯一)",
                "fieldType": "varchar"
            }, {
                "id": null,
                "remarks": null,
                "createUserId": null,
                "modifyUserId": null,
                "createDate": null,
                "modifyDate": null,
                "delFlag": false,
                "page": null,
                "templateId": null,
                "fieldName": "remarks",
                "columnName": null,
                "columnIndex": -1,
                "fk": false,
                "fkTableName": null,
                "fkCurrentField": null,
                "fkReplaceField": null,
                "fkMessage": null,
                "fixed": false,
                "fixedContent": null,
                "tableName": null,
                "fieldComment": "备注",
                "fieldType": "varchar"
            }],            // excel列到table字段的映射(以table字段为基准)
        templateName: null,
        loading: {
            step1: false,
            step2: false,
        },
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
        setColumnName($event, row) {
            for (let i = 0; i < this.excelColumnList.length; i++) {
                if (this.excelColumnList[i].columnIndex === $event) {
                    row.columnName = this.excelColumnList[i].columnName;
                    return;
                }
            }
        }
    },
    mounted: function () {
        let app = this;
        app.fullScreenLoading = false;
        ajaxPost(app.urls.showTables, null, function (d) {
            app.tableList = d.data;
        })
    }
});