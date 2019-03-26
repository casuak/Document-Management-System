let app = new Vue({
    el: '#app',
    data: {
        urls: {
            showTables: '/api/tools/database/showTables',
            upload: 'api/tools/tempFile/upload',
            getColumnsInTableAndExcel: '/api/tools/importExcel/getColumnsInTableAndExcel',
            excelToTable: '/api/tools/importExcel/excelToTable',
            selectColumnsInTable: '/api/tools/database/selectColumnsInTable'
        },
        currentStep: 0,
        currentExcelFileId: '',
        options: {
            tableList: {
                data: [],
                value: null
            }
        },
        loading: {
            step1: false,
            step2: false,
            step3: false,
        },
        tableColumnList: [
            {
                name: 'first_author_id',
                comment: "第一作者 from 用户表",
                type: 'varchar',
                excelColumnIndex: null,
                fk: null,
                fkTable: null,
                fkOriginalField: null,
                fkReplaceField: null
            }
        ],
        excelColumnList: [],
        fileList: []
    },
    methods: {
        beforeUpload: function (file) {
            let suffix = file.name.split('.').pop();
            if (suffix !== 'xlsx') {
                window.parent.app.showMessage('仅支持xlsx文件', 'error');
                return false;
            }
            app.loading.step1 = true;
        },
        // step1
        onUploadSuccess: function (res, file) {
            app.currentExcelFileId = res.data;
            app.loading.step1 = false;
            app.fileList[0] = file;
            app.$refs.upload.fileList.pop();
            app.$refs.upload.fileList[0] = file;
        },
        // after step2
        getColumnsInTableAndExcel: function () {
            let app = this;
            let data = {
                tableName: app.options.tableList.value,
                excelFileName: app.currentExcelFileId
            };
            app.loading.step2 = true;
            ajaxPost(app.urls.getColumnsInTableAndExcel, data, function (d) {
                console.log(d.data);
                app.loading.step2 = false;
                app.currentStep += 1;
                app.tableColumnList = copy(d.data.tableColumnList);
                for (let i = 0; i < app.tableColumnList.length; i++) {
                    app.tableColumnList[i].fkColumnList = [];
                    app.tableColumnList[i].loading = false;
                }
                app.excelColumnList = copy(d.data.excelColumnList);
            }, function () {
                app.loading.step2 = false;
            })
        },
        // 获取某张表的所有字段
        getColumnsInTable: function (tableColumn) {
            let app = this;
            if (tableColumn.fk === false || tableColumn.fkTable === '' || tableColumn.fkTable == null)
                return;
            let data = {
                tableName: tableColumn.fkTable
            };
            tableColumn.loading = true;
            ajaxPost(app.urls.selectColumnsInTable, data, function (d) {
                tableColumn.fkColumnList = copy(d.data);
                tableColumn.loading = false;
                app.tableColumnList.push({});
                app.tableColumnList.pop();
            })
        },
        // 将excel中的数据导入table
        excelToTable: function () {
            let app = this;
            let data = copy(app.tableColumnList);
            for (let i = 0; i < data.length; i++) {
                data[i].excelColumnIndex = parseInt(data[i].excelColumnIndex);
                if (isNaN(data[i].excelColumnIndex)) {
                    data[i].excelColumnIndex = -1;
                }
            }
            data = {
                tableColumnList: copy(data),
                tableName: app.options.tableList.value,
                excelName: app.currentExcelFileId
            };
            app.loading.step3 = true;
            ajaxPostJSON(app.urls.excelToTable, data, function (d) {
                app.loading.step3 = false;
                console.log(d.data);
            }, function () {
                app.loading.step3 = false;
            })
        }
    },
    mounted: function () {
        let app = this;
        ajaxPost(this.urls.showTables, null, function (d) {
            app.options.tableList.data = d.data;
        })
    }
});