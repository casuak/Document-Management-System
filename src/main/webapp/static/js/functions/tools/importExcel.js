let app = new Vue({
    el: '#app',
    data: {
        urls: {
            showTables: '/api/tools/database/showTables',
            upload: 'api/tools/tempFile/upload',
            getColumnsInTableAndExcel: '/api/tools/importExcel/getColumnsInTableAndExcel',
            excelToTable: '/api/tools/importExcel/excelToTable'
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
            step2: false
        },
        tableColumnList: [],
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
                app.excelColumnList = copy(d.data.excelColumnList);
            }, function () {
                app.loading.step2 = false;
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
            console.log(data);
            ajaxPostJSON(app.urls.excelToTable, data, function (d) {
                console.log(d.data);
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