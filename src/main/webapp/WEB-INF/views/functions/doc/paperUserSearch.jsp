<%--
  Created by IntelliJ IDEA.
  User: zm
  Date: 2019/3/26
  Time: 22:53
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>ssm</title>
    <%@include file="/WEB-INF/views/include/blankHead.jsp" %>
    <link rel="stylesheet" href="/static/css/functions/doc/paperUserMatch.css"/>
    <style>
        .textLeft{
            margin-left: 10px;
            font-size: 14px;
            float: left;
            padding-top: 20px;
        }
        .el-col{
            padding-top: 10px;
        }
    </style>
</head>
<body>
<div id="app" v-cloak>
    <el-container>
        <el-header  style="margin-bottom: 30px">
            <el-row>
                <div class="textLeft" >作者角色(可多选)：</div>
                <el-col :span="3">
                    <el-checkbox-group v-model="checkboxGroup1">
                        <el-checkbox-button v-for="city in cities" :label="city" :key="city">{{city}}</el-checkbox-button>
                    </el-checkbox-group>
                </el-col>

                <div class="textLeft" >作者身份：</div>
                <el-col :span="4">
                    <el-select v-model="value" placeholder="请选择作者机构">
                        <el-option
                                v-for="item in identityList"
                                :key="item.value"
                                :label="item.label"
                                :value="item.value">
                        </el-option>
                    </el-select>
                </el-col>

                <div class="textLeft">作者机构：</div>
                <el-col :span="4">
                    <el-select v-model="value" placeholder="请选择作者机构">
                        <el-option
                                v-for="item in orgList"
                                :key="item.value"
                                :label="item.label"
                                :value="item.value">
                        </el-option>
                    </el-select>
                </el-col>

                <div class="textLeft">作者姓名：</div>
                <el-col :span="4">
                    <el-input v-model="input"
                              placeholder="请输入作者姓名"
                              clearable
                              style="width:200px"></el-input>
                </el-col>
            </el-row>
            <el-row>
                <div class="textLeft" style="margin-left: 90px">
                    操作：
                </div>
                <el-col :span="4">
                    <el-button type="primary" icon="el-icon-search">查询</el-button>
                </el-col>
            </el-row>
        </el-header>
        <el-main>
            <el-table
                    :data="tableData"
                    height="600"
                    border
                    stripe
                    highlight-current-row
                    style="width: 100%">
                <el-table-column
                        align="center"
                        type="index">
                </el-table-column>
                <el-table-column
                        prop="name"
                        label="姓名"
                        align="center"
                        width="180">
                </el-table-column>
                <el-table-column
                        prop="identity"
                        label="身份"
                        align="center"
                        width="180">
                </el-table-column>
                <el-table-column
                        prop="org"
                        label="机构"
                        align="center"
                        width="180">
                </el-table-column>
                <el-table-column
                        prop="address"
                        align="center"
                        label="地址">
                </el-table-column>
                <el-table-column
                        align="center"
                        label="操作">
                    <template slot-scope="scope">
                        <el-button
                                size="mini"
                                type="primary" plain
                                @click="viewDocInfo(scope.$index, scope.row)"
                        >查看所属文献信息</el-button>
                        <el-button
                                size="mini"
                                type="danger"
                                @click="handleDelete(scope.$index, scope.row)"
                        >删除</el-button>
                    </template>
                </el-table-column>
            </el-table>
        </el-main>
    </el-container>

</div>
<%@include file="/WEB-INF/views/include/blankScript.jsp" %>
<script>
    const cityOptions = ['学生', '教师'];
    var app = new Vue({
        el:'#app',
        data:{
            input:'',
            checkboxGroup1: ['学生'],
            cities: cityOptions,
            identityList:[{
                value:'first',
                label:'第一作者'
            },{
                value:'first',
                label:'第二作者'
            },{
                value:'first',
                label:'其他'
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
            value: '',
            tableData: [{
                date: '2016-05-03',
                name: '王小虎',
                identity:'教师',
                org:'软件学院',
                address: '上海市普陀区金沙江路 1518 弄'
            }, {
                date: '2016-05-02',
                name: '王小虎',
                identity:'教师',
                org:'软件学院',
                address: '北京理工大学软件学院'
            }, {
                date: '2016-05-04',
                name: '王小虎',
                identity:'教师',
                org:'软件学院',
                address: '北京理工大学软件学院'
            }, {
                date: '2016-05-01',
                name: '王小虎',
                identity:'教师',
                org:'软件学院',
                address: '北京理工大学软件学院'
            }, {
                date: '2016-05-08',
                name: '王小虎',
                identity:'教师',
                org:'软件学院',
                address: '北京理工大学软件学院'
            }, {
                date: '2016-05-06',
                name: '王小虎',
                identity:'教师',
                org:'软件学院',
                address: '北京理工大学软件学院'
            }, {
                date: '2016-05-07',
                name: '王小虎',
                identity:'教师',
                org:'软件学院',
                address: '北京理工大学软件学院'
            }]
        },
        methods:{
            viewDocInfo(index, row) {
                console.log(index, row);
                location.href="/api/doc/search/searchDocList"
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
</script>
</body>
</html>