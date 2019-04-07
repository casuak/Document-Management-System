let app = new Vue({
    el: '#app',
    data: {
        activeTabName: 'tab0',
        tabList: [
            {
                src: '/functions/tool/importExcel/templateManager',
                label: '模板管理',
                name: 'tab0',
            },
            {
                src: '/functions/tool/importExcel/importData',
                label: '数据导入',
                name: 'tab1',
            },
        ]
    },
    methods: {
        tabClick: function (tab) {
            if (tab.name === 'tab1' && document.getElementById('tab1') != null) {
                document.getElementById('tab1').contentWindow.location.reload(true);
            }
        }
    }
});