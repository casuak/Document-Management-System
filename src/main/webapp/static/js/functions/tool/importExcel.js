let app = new Vue({
    el: '#app',
    data: {
        activeTabName: 'tab0',
        tabList: [
            {
                src: '/functions/tool/importExcel/importData',
                label: '数据导入',
                name: 'tab0',
            },
            {
                src: '/functions/tool/importExcel/templateManager',
                label: '模板管理',
                name: 'tab1',
            },
        ]
    },
    methods: {
        tabClick: function (tab) {
            if (tab.name === 'tab0') {
                // document.getElementById('tab0').contentWindow.location.reload(true);
                document.getElementById('tab0').contentWindow.app.selectExcelTemplateByEnabled();
            }
        }
    }
});