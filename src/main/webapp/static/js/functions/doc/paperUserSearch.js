const cityOptions = ['学生', '教师'];
var app = new Vue({
    el: '#app',
    data: {
        input: '',
        checkboxGroup1: ['学生'],
        cities: cityOptions,
        identityList: [{
            value: 'first',
            label: '第一作者'
        }, {
            value: 'first',
            label: '第二作者'
        }, {
            value: 'first',
            label: '其他'
        }],
        orgList: [{
            value: '选项1',
            label: '软件学院'
        }, {
            value: '选项2',
            label: '计算机学院'
        }, {
            value: '选项3',
            label: '生命学院'
        }, {
            value: '选项4',
            label: '管理学院'
        }, {
            value: '选项5',
            label: '车辆学院'
        }],
        Identity: '',
        institution: '',
        tableData: [{
            date: '2016-05-03',
            name: '王小虎',
            identity: '教师',
            org: '软件学院',
            address: '上海市普陀区金沙江路 1518 弄'
        }, {
            date: '2016-05-02',
            name: '王小虎',
            identity: '教师',
            org: '软件学院',
            address: '北京理工大学软件学院'
        }, ]
    },
    methods: {
        viewDocInfo(index, row) {
            console.log(index, row);
            location.href = "/api/doc/search/searchDocList"
            // $.ajax({
            //     url:"/api/doc/search/searchDocList",//请求的url地址
            //     dataType:"json",//返回的格式为json
            //     async:true,//请求是否异步，默认true异步，这是ajax的特性
            //     data:{},//参数值
            //     type:"GET",//请求的方式
            //     beforeSend:function(){},//请求前的处理
            //     success:function(req){
            //         console.log(req)
            //     },//请求成功的处理
            //     complete:function(){},//请求完成的处理
            //     error:function(){
            //         location.href = "/";
            //         console.log("error")
            //     }//请求出错的处理
            // })
        },
        handleDelete(index, row) {
            console.log(index, row);
        }
    }
})