<%--
  Created by IntelliJ IDEA.
  User: zm
  Date: 2019/4/2
  Time: 14:27
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>tableTemplate</title>
    <%@include file="/WEB-INF/views/include/blankHead.jsp" %>
    <link rel="stylesheet" href="/static/css/tableTemplate.css"/>
    <style>
        html {
            height: 100%;
            overflow: auto;
        }

        body {
            height: 100%;
            overflow: auto;
            color: #000;
        }

        .tmp {
            margin-top: 15px;
            background-color: rgb(244, 244, 245);
            border-radius: 4px;
            padding: 7px 0;
            box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1)
        }

        .commonInput {
            float: right;
            margin-left: 10px;
        }

        .commonInputSection {
            width: 300px;
            float: left;
            margin-left: 15px;
        }

        .inputSpanText {
            float: left;
            padding-top: 12px;
        }

        .operateRow {
            padding: 7px 0;
        }
    </style>
</head>
<body>
<div id="app" v-cloak style="background: white;height: 100%;" v-loading="fullScreenLoading">
    <el-container>
        <el-header height="100%">
            <div style="margin-top: 10px">
                <template>
                    <el-checkbox :indeterminate="doc.isIndeterminate" v-model="doc.checkAll"
                                 @change="handleCheckAllChange">全选
                    </el-checkbox>
                    <div style="margin: 15px 0;"></div>
                    <el-checkbox-group v-model="doc.checkedDoc" @change="handleCheckedDocsChange">
                        <el-checkbox :label="doc.docType.paper" :key="doc.docType.paper"></el-checkbox>
                        <el-checkbox :label="doc.docType.patent" :key="doc.docType.patent"></el-checkbox>
                        <el-checkbox :label="doc.docType.copyright" :key="doc.docType.copyright"></el-checkbox>
                    </el-checkbox-group>
                </template>
            </div>
            <%--搜索选项部分--%>
            <div id="paperBox" class="tmp" v-show="optionView.paper.show">
                <row>
                    <div class="commonInputSection">
                        <span class="inputSpanText">论文名称:</span>
                        <div class="commonInput">
                            <el-input
                                    placeholder="请输入内容"
                                    v-model="optionView.paper.paperName"
                                    clearable>
                            </el-input>
                        </div>
                    </div>
                    <%--paper-第一作者--%>
                    <div class="commonInputSection">
                        <span class="inputSpanText">第一作者: </span>
                        <div class="commonInput">
                            <el-input
                                    placeholder="输入第一作者工号/学号"
                                    v-model="optionView.paper.firstAuthor"
                                    clearable>
                            </el-input>
                        </div>
                    </div>
                    <%--paper-第二作者--%>
                    <div class="commonInputSection">
                        <span class="inputSpanText">第二作者: </span>
                        <div class="commonInput">
                            <el-input
                                    placeholder="输入第二作者工号/学号"
                                    v-model="optionView.paper.secondAuthor"
                                    clearable>
                            </el-input>
                        </div>

                    </div>
                    <%--paper-其他作者--%>
                    <div class="commonInputSection">
                        <span class="inputSpanText">其他作者: </span>
                        <div class="commonInput">
                            <el-input
                                    placeholder="输入其他作者工号/学号"
                                    v-model="optionView.paper.otherAuthor"
                                    clearable>
                            </el-input>
                        </div>
                    </div>
                </row>

                <row style="margin-top: 10px">
                    <%--paper-期刊号--%>
                    <div class="commonInputSection">
                        <span class="inputSpanText">期刊号: </span>
                        <div class="commonInput">
                            <el-input
                                    placeholder="输入论文期刊号"
                                    v-model="optionView.paper.journalNum"
                                    clearable>
                            </el-input>
                        </div>
                    </div>
                    <%--paper-入藏号--%>
                    <div class="commonInputSection">
                        <span class="inputSpanText">入藏号: </span>
                        <div class="commonInput">
                            <el-input
                                    placeholder="输入论文入藏号"
                                    v-model="optionView.paper.storeNum"
                                    clearable>
                            </el-input>
                        </div>
                    </div>
                    <%--paper-文献类型--%>
                    <div class="commonInputSection">
                        <span class="inputSpanText">文献类型: </span>
                        <div class="commonInput">
                            <el-select v-model="optionView.paper.paperType" clearable placeholder="选择论文种类">
                                <el-option
                                        v-for="item in optionValue.paperTypeOption"
                                        :key="item.value"
                                        :label="item.label"
                                        :value="item.value">
                                </el-option>
                            </el-select>
                        </div>
                    </div>
                </row>
            </div>

            <div id="patentBox" class="tmp" v-show="optionView.patent.show">
                <row>
                    <div class="commonInputSection">
                        <span class="inputSpanText">专利申请号: </span>
                        <div class="commonInput">
                            <el-input
                                    placeholder="输入专利申请号"
                                    v-model="optionView.commonSelect.applicationNum"
                                    clearable>
                            </el-input>
                        </div>
                    </div>
                    <div class="commonInputSection">
                        <span class="inputSpanText">专利公开号: </span>
                        <div class="commonInput">
                            <el-input
                                    placeholder="输入专利公开号"
                                    v-model="optionView.commonSelect.publicNum"
                                    clearable>
                            </el-input>
                        </div>
                    </div>
                    <div class="commonInputSection">
                        <span class="inputSpanText">专利国别码: </span>
                        <div class="commonInput">
                            <el-input
                                    placeholder="输入专利国别码"
                                    v-model="optionView.commonSelect.countryCode"
                                    clearable>
                            </el-input>
                        </div>
                    </div>
                </row>
            </div>

            <div id="copyrightBox" class="tmp" v-show="optionView.copyright.show">
                <row>
                    <div class="commonInputSection">
                        <span class="inputSpanText">版权主体: </span>
                        <div class="commonInput">
                            <el-input
                                    placeholder="输入版权主体"
                                    v-model="optionView.copyright.copySubject"
                                    clearable>
                            </el-input>
                        </div>
                    </div>
                    <div class="commonInputSection">
                        <span class="inputSpanText">版权类型: </span>
                        <div class="commonInput">
                            <el-input
                                    placeholder="输入版权类型"
                                    v-model="optionView.copyright.copyType"
                                    clearable>
                            </el-input>
                        </div>
                    </div>
                </row>
            </div>

            <div id="commonBox" class="tmp" v-show="optionView.commonSelect.show">
                <row>
                    <div class="commonInputSection">
                        <span class="inputSpanText">作者姓名: </span>
                        <div class="commonInput">
                            <el-input
                                    placeholder="输入作者姓名"
                                    v-model="optionView.commonSelect.authorName"
                                    clearable>
                            </el-input>
                        </div>
                    </div>
                </row>
            </div>

            <div style="height: 10px"></div>
            <row>
                <el-button type="primary" size="medium">搜索文献</el-button>
                <el-button type="danger" size="medium" @click="test2()">Test1</el-button>
                <el-button type="success" size="medium" @click="test3()">Test2</el-button>
            </row>
        </el-header>
        <el-main style="margin-top: -35px">
            <%--paper列表--%>
            <div v-show="optionView.paper.show">
                <%-- entity表格 --%>
                <el-table :data="table.paperTable.data"
                          height="calc(100% - 116px)"
                          :header-cell-style="{background:'rgb(254, 240, 240)',color:'#555'}"
                          v-loading="table.paperTable.loading"
                          style="width: 100%;overflow-y: hidden;margin-top: 20px;"
                          class="scroll-bar"
                <%--@selection-change="onSelectionChange_entity"--%>
                          stripe>
                    <el-table-column type="selection" width="40"></el-table-column>
                    <el-table-column label="创建时间">
                        <%--<template slot-scope="scope">--%>
                        <%--{{ formatTimestamp(scope.row.createDate) }}--%>
                        <%--</template>--%>
                    </el-table-column>
                    <el-table-column label="操作" width="190" header-align="center" align="center">
                        <template slot-scope="scope">
                            <el-button type="warning" size="mini" style="position:relative;bottom: 1px;"
                            <%--@click="openDialog_updateEntity(scope.row)"--%>
                            >
                                <span>编辑</span>
                            </el-button>
                            <el-button type="danger" size="mini" style="position:relative;bottom: 1px;margin-left: 6px;"
                            <%--@click="deleteEntityListByIds([{id: scope.row.id}])"--%>
                            >
                                <span>删除</span>
                            </el-button>
                        </template>
                    </el-table-column>
                    <el-table-column width="50"></el-table-column>
                </el-table>
                <%-- entity分页 --%>
                <el-pagination style="text-align: center;margin: 8px auto;"
                <%--@size-change="onPageSizeChange_entity"--%>
                <%--@current-change="onPageIndexChange_entity"--%>
                               :current-page="table.paperTable.params.pageIndex"
                               :page-sizes="table.paperTable.params.pageSizes"
                               :page-size="table.paperTable.params.pageSize"
                               :total="table.paperTable.params.total"
                               layout="total, sizes, prev, pager, next, jumper">
                </el-pagination>
            </div>
            <%--patent列表--%>
            <div v-show="optionView.patent.show">
                <%-- entity表格 --%>
                <el-table :data="table.paperTable.data"
                          :header-cell-style="{background:'rgb(253, 246, 236)',color:'#555'}"
                          height="calc(100% - 116px)"
                          v-loading="table.paperTable.loading"
                          style="width: 100%;overflow-y: hidden;margin-top: 20px;" c
                          lass="scroll-bar"
                <%--@selection-change="onSelectionChange_entity"--%>
                          stripe>
                    <el-table-column type="selection" width="40"></el-table-column>
                    <el-table-column label="创建时间">
                        <%--<template slot-scope="scope">--%>
                        <%--{{ formatTimestamp(scope.row.createDate) }}--%>
                        <%--</template>--%>
                    </el-table-column>
                    <el-table-column label="操作" width="190" header-align="center" align="center">
                        <template slot-scope="scope">
                            <el-button type="warning" size="mini" style="position:relative;bottom: 1px;"
                            <%--@click="openDialog_updateEntity(scope.row)"--%>
                            >
                                <span>编辑</span>
                            </el-button>
                            <el-button type="danger" size="mini" style="position:relative;bottom: 1px;margin-left: 6px;"
                            <%--@click="deleteEntityListByIds([{id: scope.row.id}])"--%>
                            >
                                <span>删除</span>
                            </el-button>
                        </template>
                    </el-table-column>
                    <el-table-column width="50"></el-table-column>
                </el-table>
                <%-- entity分页 --%>
                <el-pagination style="text-align: center;margin: 8px auto;"
                <%--@size-change="onPageSizeChange_entity"--%>
                <%--@current-change="onPageIndexChange_entity"--%>
                               :current-page="table.paperTable.params.pageIndex"
                               :page-sizes="table.paperTable.params.pageSizes"
                               :page-size="table.paperTable.params.pageSize"
                               :total="table.paperTable.params.total"
                               layout="total, sizes, prev, pager, next, jumper">
                </el-pagination>
            </div>
            <%--copyr列表--%>
            <div v-show="optionView.copyright.show">
                <%-- entity表格 --%>
                <el-table :data="table.paperTable.data"
                          :header-cell-style="{background:'rgb(240, 249, 235)',color:'#555'}"
                          height="calc(100% - 116px)"
                          v-loading="table.paperTable.loading"
                          style="width: 100%;overflow-y: hidden;margin-top: 20px;"
                          class="scroll-bar"
                <%--@selection-change="onSelectionChange_entity"--%>
                          stripe>
                    <el-table-column type="selection" width="40"></el-table-column>
                    <el-table-column label="创建时间">
                        <%--<template slot-scope="scope">--%>
                        <%--{{ formatTimestamp(scope.row.createDate) }}--%>
                        <%--</template>--%>
                    </el-table-column>
                    <el-table-column label="操作" width="190" header-align="center" align="center">
                        <template slot-scope="scope">
                            <el-button type="warning" size="mini" style="position:relative;bottom: 1px;"
                            <%--@click="openDialog_updateEntity(scope.row)"--%>
                            >
                                <span>编辑</span>
                            </el-button>
                            <el-button type="danger" size="mini" style="position:relative;bottom: 1px;margin-left: 6px;"
                            <%--@click="deleteEntityListByIds([{id: scope.row.id}])"--%>
                            >
                                <span>删除</span>
                            </el-button>
                        </template>
                    </el-table-column>
                    <el-table-column width="50"></el-table-column>
                </el-table>
                <%-- entity分页 --%>
                <el-pagination style="text-align: center;margin: 8px auto;"
                <%--@size-change="onPageSizeChange_entity"--%>
                <%--@current-change="onPageIndexChange_entity"--%>
                               :current-page="table.paperTable.params.pageIndex"
                               :page-sizes="table.paperTable.params.pageSizes"
                               :page-size="table.paperTable.params.pageSize"
                               :total="table.paperTable.params.total"
                               layout="total, sizes, prev, pager, next, jumper">
                </el-pagination>
            </div>
            <%--common列表--%>
            <div v-show="optionView.commonSelect.show">
                <%-- entity表格 --%>
                <el-table :data="table.paperTable.data"
                          :header-cell-style="{background:'rgb(217, 236, 255)',color:'#555'}"
                          height="calc(100% - 116px)"
                          v-loading="table.paperTable.loading"
                          style="width: 100%;overflow-y: hidden;margin-top: 20px;"
                          class="scroll-bar"
                <%--@selection-change="onSelectionChange_entity"--%>
                          stripe>
                    <el-table-column type="selection" width="40"></el-table-column>
                    <el-table-column label="创建时间">
                        <%--<template slot-scope="scope">--%>
                        <%--{{ formatTimestamp(scope.row.createDate) }}--%>
                        <%--</template>--%>
                    </el-table-column>
                    <el-table-column label="操作" width="190" header-align="center" align="center">
                        <template slot-scope="scope">
                            <el-button type="warning" size="mini" style="position:relative;bottom: 1px;"
                            <%--@click="openDialog_updateEntity(scope.row)"--%>
                            >
                                <span>编辑</span>
                            </el-button>
                            <el-button type="danger" size="mini" style="position:relative;bottom: 1px;margin-left: 6px;"
                            <%--@click="deleteEntityListByIds([{id: scope.row.id}])"--%>
                            >
                                <span>删除</span>
                            </el-button>
                        </template>
                    </el-table-column>
                    <el-table-column width="50"></el-table-column>
                </el-table>
                <%-- entity分页 --%>
                <el-pagination style="text-align: center;margin: 8px auto;"
                <%--@size-change="onPageSizeChange_entity"--%>
                <%--@current-change="onPageIndexChange_entity"--%>
                               :current-page="table.paperTable.params.pageIndex"
                               :page-sizes="table.paperTable.params.pageSizes"
                               :page-size="table.paperTable.params.pageSize"
                               :total="table.paperTable.params.total"
                               layout="total, sizes, prev, pager, next, jumper">
                </el-pagination>
            </div>
        </el-main>
        <%--<el-footer>--%>
        <%--footer--%>
        <%--</el-footer>--%>
    </el-container>
</div>


<%@include file="/WEB-INF/views/include/blankScript.jsp" %>
<script>
    const docOptions = ["论文", "专利", "著作权"];
    var app = new Vue({
        el: '#app',
        data: {
            doc: {
                checkAll: false,
                docType: {
                    paper: "论文",
                    patent: "专利",
                    copyright: "著作权"
                },
                checkedDoc: [],
                isIndeterminate: true
            },
            //条件输入(选择)框(选项)
            optionValue: {
                paperTypeOption: [],
            },
            //条件输入(选择)框(V-model绑定的值)：
            optionView: {
                paper: {
                    show: false,
                    paperName: "",
                    firstAuthor: "",
                    secondAuthor: "",
                    otherAuthor: "",
                    journalNum: "",
                    storeNum: "",
                    paperType: ""
                },
                patent: {
                    show: false,
                    applicationNum: "",
                    publicNum: "",
                    countryCode: ""
                },
                copyright: {
                    show: false,
                    copySubject: "",
                    copyType: ""
                },
                commonSelect: {
                    show: true,
                    authorName: "",
                }
            },
            fullScreenLoading: false,
            table: {
                paperTable: {
                    data: [
                        // {
                        //     name:"",
                        //     firstAuthor:"",
                        //     secondAuthor:""
                        // }
                    ],
                    loading: false,
                    selectionList: [],
                    params: {
                        pageIndex: 1,
                        pageSize: 10,
                        pageSizes: [5, 10, 20, 40],
                        searchKey: '',  // 搜索词
                        total: 0,       // 总数
                    }
                },
                patentTable: {
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
                },
                copyrightTable: {
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
                },
                commonTable: {
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
            dialog: {},
            options: {},
        },
        methods: {
            handleCheckAllChange(val) {
                this.doc.checkedDoc = val ? docOptions : [];
                this.doc.isIndeterminate = false;
                optionViewSelect();
            },
            handleCheckedDocsChange(value) {
                let checkedCount = value.length;
                //console.log("已选的长度："+checkedCount);
                this.doc.checkAll = checkedCount === 3;
                this.doc.isIndeterminate = checkedCount > 0 && checkedCount < 3;
                optionViewSelect();
            }
        }
    });

    //选择对应筛选框视图:
    function optionViewSelect() {
        app.optionView.paper.show = false;
        app.optionView.patent.show = false;
        app.optionView.copyright.show = false;

        if (app.doc.checkedDoc.length > 0) {
            app.optionView.commonSelect.show = false;
        } else {
            app.optionView.commonSelect.show = true;
        }
        for (let i = 0; i < app.doc.checkedDoc.length; i++) {
            let tmpType = app.doc.checkedDoc[i];
            switch (tmpType) {
                case "论文":
                    app.optionView.paper.show = true;
                    break;
                case "专利":
                    app.optionView.patent.show = true;
                    break;
                case "著作权":
                    app.optionView.copyright.show = true;
                    break;
                default:
                    break;
            }
        }
    }

    //1. 格式化URL参数(传入单个参数对象)
    function formatParams(data) {
        let arr = [];
        for (let name in data) {
            arr.push(encodeURIComponent(name) + '=' + encodeURIComponent(data[name]));
        }
        // 添加一个随机数参数，防止缓存
        arr.push('v' + Math.random() + '=' + Math.random());
        //console.log(arr.join('&'));
        return arr.join('&');
    }

    //2. 格式化REL参数(传入参数对象数组)
    function formatParamsArray(data) {
        let arr = [];
        for (let i = 0; i < data.length; i++) {
            let tmpData = data[i];
            for (let name in tmpData) {
                arr.push(encodeURIComponent(name) + '=' + encodeURIComponent(tmpData[name]));
            }
        }
        arr.push('v=' + Math.random());
        return arr.join('&');
    }

    //初始化界面时候加载默认参数：
    function initialize() {
        let tmp = ${paperType};
        for (let i = 0; i< tmp.length;i++){
            let tmpItem = {
                value:tmp[i].id,
                label:tmp[i].name_cn
            };
            console.log(tmpItem);
            app.optionValue.paperTypeOption.push(tmpItem);
        }
    }

    window.onload = initialize();

    // 测试
    function test() {
        let tmpData = {
            id: "tmpId",
            name: "tmpName"
        };
        ajaxGet('/api/doc/search/test', tmpData, function success(res) {
                console.log("ok");
                console.log(res);
                console.log(res.data.paper)
            },
            function error(res) {
                console.log("请求失败"),
                    console.log(res);
            })
    }

    function test2() {

        let paperConditionParam = {
            paperName: app.optionView.paper.paperName,
            firstAuthorWorkNum: app.optionView.paper.firstAuthor,
            secondAuthorWorkNum: app.optionView.paper.secondAuthor,
            otherAuthorWorkNum: app.optionView.paper.otherAuthor,
            journalNum: app.optionView.paper.journalNum,
            storeNum: app.optionView.paper.storeNum,
            docType: app.optionView.paper.paperType,                    //paperType 的id
            paperPageIndex: app.table.paperTable.params.pageIndex,
            paperPageSize: app.table.paperTable.params.pageSize
        };
        let patentConditionParam = {
            applicationNum: "专利申请号2",
            publicNum: "专利公开号2",
            countryCode: "专利国别码2",
            patentPageIndex: 1,
            patentPageSize: 10
        };
        let copyrightConditionParam = {
            copySubject: "版权主体2",
            copyType: "版权类型2",
            copyPageIndex: 1,
            copyPageSize: 10
        };
        //全部参数：
        let paramObjectArray = [paperConditionParam, patentConditionParam, copyrightConditionParam];
        let conditionParam = formatParamsArray(paramObjectArray);
        console.log(conditionParam);

        // ajaxPost("/api/doc/search/getDocList", conditionParam,
        //     function success(res) {
        //         console.log("success "+res);
        //     },
        //     function error(res) {
        //         console.log("error "+res)
        //     }
        // )
    }

    function test3() {
        //模态框测试：
        app.$prompt('Module Test', 'Notice', {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
        }).then(({value}) => {
            app.$message({
                type: 'success',
                message: '输入信息是: ' + value
            });
        }).catch(() => {
            app.$message({
                type: 'info',
                message: '取消输入'
            });
        });
    }
</script>
<%--<script src="/static/js/functions/doc/docSearch.js"></script>--%>
</body>
</html>