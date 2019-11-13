app = new Vue({
    el: '#app',
    data: {
        formData: { // 与后端ExcelTemplate相对应
            id: '',
            excelName: '',      // excel模板文件的名字(默认存放/WEB-INF/excelTemplate)
            excelDataName: '',  // 存放数据的excel文件的名字(默认存放在/WEB-INF/temp)
        },
        urls: {
            selectAllExcelTemplate: '/api/tool/excelTemplate/selectAll',
            downloadExcelTemplate: '/api/tool/excelTemplate/downloadExcelTemplate',
            importExcelToTable: '/api/tool/excelTemplate/importExcelToTable',
            updateUserByExcel:'/api/tool/excelTemplate/updateUserByExcel'
        },
        excelTemplateList: [],
        defaultFileList: [],
        tmpFileName: '', // 当前上传的文件存储在服务器的临时文件夹上的名字
        loading: {
            importing: false,
            fullScreen: false
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
            this.tmpFileName = res.data;
            this.defaultFileList[0] = file;
            this.$refs.upload.fileList.pop();
            this.$refs.upload.fileList[0] = file;
        },
        // get all templates those has been enabled
        selectExcelTemplateByEnabled: function () {
            let excelTemplate = {
                enable: true
            };
            this.loading.fullScreen = true;
            let app = this;
            ajaxPostJSON(this.urls.selectAllExcelTemplate, excelTemplate, function (d) {
                app.loading.fullScreen = false;
                app.excelTemplateList = d.data;
            })
        },
        onSelectChange: function (value) {
            let flag = false;
            this.excelTemplateList.forEach(item => {
                if (flag) return;
                if (item.id === value) {
                    this.formData = copy(item);
                    flag = true;
                }
            });
        },
        downloadExcelTemplate: function () {
            if (this.formData.id == null || this.formData.id === '') {
                window.parent.parent.app.showMessage('请先选择模板!', 'warning');
                return;
            }
            let excelName = this.formData.excelName;
            let downloadName = this.formData.templateName;
            let requestUrl = this.urls.downloadExcelTemplate +
                "?excelName=" + excelName + "&downloadName=" + downloadName;
            // location.href = requestUrl;
            window.open(requestUrl);
        },
        startImport: function () {
            if (this.formData.id == null || this.formData.id === '') {
                window.parent.parent.app.showMessage('请先选择模板!', 'warning');
                return;
            }
            if (this.tmpFileName == null || this.tmpFileName === '') {
                window.parent.parent.app.showMessage('请先上传数据文件!', 'warning');
                return;
            }
            this.formData.excelDataName = this.tmpFileName;
            this.loading.importing = true;
            let app = this;
            let url=this.urls.importExcelToTable;
            if(app.formData.excelName ==="更新用户信息"){
                url=thisapp.urls.updateUserByExcel;
            }
            ajaxPostJSON(url, this.formData, function (d) {
                app.loading.importing = false;
                window.parent.parent.app.showMessage('导入成功');
            },function(d){
                app.loading.importing = false;
                window.parent.parent.app.showMessage('导入失败', 'error');
            })
        }
    },
    mounted: function () {
        this.selectExcelTemplateByEnabled();
    }
});