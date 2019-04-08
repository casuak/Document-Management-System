let app = new Vue({
    el: '#app',
    data: {
        activeTabName: 'tab0',
        tabList: [
            {
                src: '/functions/tool/importExcel/templateManager',
                label: '模板管理',
                name: 'tab0',
                active: true,
            },
            {
                src: '/functions/tool/importExcel/importData',
                label: '数据导入',
                name: 'tab1',
                active: false
            },
        ]
    },
    methods: {
        test: function () {
            let url = "/api/tool/tempFile/test";
            ajaxPost(url, null, function (d) {
                console.log(d);
            })
        }
    }
});