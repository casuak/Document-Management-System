let app = new Vue({
    el: '#app',
    data: {
        activeTabName: 'tab0',
        tabList: [
            {
                src: '/functions/doc/paperUserMatch/tab0',
                label: '未初始化',
                name: 'tab0',
                active: true,
            },
            {
                src: '/functions/doc/paperUserMatch/tab1',
                label: '未匹配',
                name: 'tab1',
                active: false
            },
            {
                src: '/functions/doc/paperUserMatch/tab2',
                label: '匹配出错',
                name: 'tab2',
                active: false
            },
            {
                src: '/functions/doc/paperUserMatch/tab3',
                label: '匹配成功',
                name: 'tab3',
                active: false
            },
            {
                src: '/functions/doc/paperUserMatch/tab4',
                label: '匹配完成',
                name: 'tab4',
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