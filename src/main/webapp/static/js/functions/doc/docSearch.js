let app = new Vue({
    el: '#app',
    data: {
        urls: {
            // api for entity
            insertEntity: '/api/sys/role/insert',
            deleteEntityListByIds: '/api/sys/role/deleteListByIds',
            updateEntity: '/api/sys/role/update',
            selectEntityListByPage: '/api/sys/role/selectListByPage',
        },
        doc:{
            checkAll:false,
            docType:[
                {
                    lable:"论文",
                    value:"paper"
                },
                {
                    lable:"著作权",
                    value:"copyright"
                },
                {
                    lable:"专利",
                    value:"patent"
                }
            ],
            checkedDoc:[],
            isIndeterminate:true
        },
        fullScreenLoading: false,
        table: {
            entity: {
                data: [],
                loading: false,
                selectionList: [],
                params: {
                    pageIndex: 1,
                    pageSize: 10,
                    pageSizes: [5, 10, 20, 40],
                    searchKey: '',  // 搜索词
                    total: 0,       // 总数
                }
            }
        },
        dialog: {
            insertEntity: {
                visible: false,
                loading: false,
                formData: {},
                rules: {},
            },
            updateEntity: {
                visible: false,
                loading: false,
                formData: {},
                rules: {},
            },
        },
        options: {},
    },
    methods: {
        handleCheckAllChange(val) {
            this.doc.checkedDoc = val ? this.doc.docType : [];
            this.doc.isIndeterminate = false;
        },
        handleCheckedDocsChange(value) {
            let checkedCount = value.length;
            this.doc.checkAll = checkedCount === this.doc.docType.length;
            this.doc.isIndeterminate = checkedCount > 0 && checkedCount < this.doc.docType.length;
        }
    },
    mounted: function () {
        this.refreshTable_entity();
    }
});