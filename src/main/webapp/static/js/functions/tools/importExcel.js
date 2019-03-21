let app = new Vue({
    el: '#app',
    data: {
        urls: {
            showTables: '/api/tools/database/showTables',
            upload: 'api/tools/tempFile/upload',
            getColumnsInTableAndExcel: '/api/tools/importExcel/getColumnsInTableAndExcel'
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
            step2: false
        }
    },
    methods: {
        onUploadSuccess: function (res, file) {
            app.currentExcelFileId = res.data;
        },
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
                // app.currentStep += 1;
            }, function () {
                app.loading.step2 = false;
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