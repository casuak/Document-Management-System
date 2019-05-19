<%--
  Created by IntelliJ IDEA.
  User: zm
  Date: 2019/5/8
  Time: 19:57
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>文献统计</title>
    <%@include file="/WEB-INF/views/include/blankHead.jsp" %>
    <link rel="stylesheet" href="/static/css/functions/doc/docSearch.css"/>
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
            margin-top: 8px;
            background-color: rgb(237, 237, 238);
            border-radius: 4px;
            padding: 5px 0;
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

        .selectText {
            float: left;
            width: 120px;
            padding-top: 6px;
            margin-left: 10px;
            /*margin-left: 15px;*/
            /*font-size: 15px;*/
        }

        .inputSpanText {
            float: left;
            padding-top: 12px;
        }

        .operateRow {
            padding: 7px 0;
        }

        /*日期选择框样式*/
        .el-date-editor .el-range-separator {
            padding: 0 0;
        }

        .el-date-editor--daterange {
            width: 221.4px;
        }

        .has-gutter .cell {
            height: 45px;
            line-height: 45px;
        }
    </style>
</head>
<body>
<div id="app" v-cloak style="background: white;height: 100%;">
    <el-container style="height: 100%">
        <el-header height="auto">
            <div style="margin-top: 5px" class="tmp" v-show="radio == 2">
                <template>
                    <el-checkbox :indeterminate="doc.isIndeterminate" v-model="doc.checkAll"
                                 style="float: left;margin-left:10px;margin-right: 5px"
                                 @change="handleCheckAllChange">全选
                    </el-checkbox>
                    <el-checkbox-group v-model="doc.checkedDoc" @change="handleCheckedDocsChange">
                        <el-checkbox :label="doc.docType.paper" :key="doc.docType.paper"></el-checkbox>
                        <el-checkbox :label="doc.docType.patent" :key="doc.docType.patent"></el-checkbox>
                    </el-checkbox-group>
                </template>
            </div>
            <%--搜索选项部分--%>
            <div id="commonBox" class="tmp" v-show="optionView.commonSelect.show">
                <row>
                    <span class="selectText" v-show="radio ==2">
                        <el-tag>公共筛选项</el-tag>
                    </span>

                    <div class="commonInputSection">
                        <span class="inputSpanText">所属学科: </span>
                        <div class="commonInput">
                            <el-select v-model="optionView.commonSelect.subject"
                                       filterable
                                       clearable
                                       placeholder="选择所属学科">
                                <el-option
                                        v-for="item in optionValue.subjectOption"
                                        :key="item.value"
                                        :label="item.label"
                                        :value="item.value">
                                </el-option>
                            </el-select>
                        </div>
                    </div>
                    <div class="commonInputSection">
                        <span class="inputSpanText">所属学院: </span>
                        <div class="commonInput">
                            <el-select v-model="optionView.commonSelect.organization"
                                       filterable
                                       clearable
                                       placeholder="所属学院">
                                <el-option
                                        v-for="item in optionValue.orgOption"
                                        :key="item.value"
                                        :label="item.label"
                                        :value="item.value">
                                </el-option>
                            </el-select>
                        </div>
                    </div>
                    <div class="commonInputSection" style="width: 320px;" v-show="radio ==2">
                        <span class="inputSpanText">时间: </span>
                        <div class="commonInput">
                            <el-date-picker
                                    style="width: 250px;float: right;margin-top: 0"
                                    v-model="optionView.commonSelect.publishDate"
                                    type="daterange"
                                    align="right"
                                    unlink-panels
                            <%--                                    range-separator="至"--%>
                                    start-placeholder="开始日期"
                                    end-placeholder="结束日期"
                                    :picker-options="optionValue.pickerOptions">
                            </el-date-picker>
                        </div>
                    </div>
                </row>
            </div>

            <div id="paperBox" class="tmp" v-show="radio == 2 && optionView.paper.show">
                <row>
                    <span class="selectText">
                        <el-tag type="danger">论文筛选项</el-tag>
                    </span>

                    <div class="commonInputSection">
                        <span class="inputSpanText">论文种类: </span>
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

                    <div class="commonInputSection">
                        <span class="inputSpanText">科睿唯安: </span>
                        <div class="commonInput">
                            <el-select v-model="optionView.paper.partition" clearable placeholder="选择论文种类">
                                <el-option
                                        v-for="item in optionValue.partitionOption"
                                        :key="item.value"
                                        :label="item.label"
                                        :value="item.value">
                                </el-option>
                            </el-select>
                        </div>
                    </div>

                    <div class="commonInputSection">
                        <span class="inputSpanText">影响因子: </span>
                        <div class="commonInput">
                            <el-input-number
                                    v-model="optionView.paper.impactFactor"
                                    @change=""
                                    :min="0"
                                    controls-position="right"
                                    style="width: 217px"
                                    placeholder="输入论文影响因子">
                            </el-input-number>
                        </div>
                    </div>
                </row>
            </div>

            <div id="patentBox" class="tmp" v-show="radio == 2 &&  optionView.patent.show">
                <row>
                    <span class="selectText">
                        <el-tag type="warning">专利筛选项</el-tag>
                    </span>
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
                </row>
            </div>

            <div id="copyrightBox" class="tmp" v-show="radio == 2 &&  optionView.copyright.show">
                <row>
                    <span class="selectText">
                        <el-tag type="success">版权筛选项</el-tag>
                    </span>
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

            <div style="height: 10px"></div>

            <row>
                <div v-show="radio ==2">
                    <el-button type="primary" size="medium" @click="statisticalSearch()">统计结果</el-button>
                    <%--  <el-button type="danger" size="medium" @click="">结果导出</el-button>
                      <el-button type="success" size="medium" @click="test4">Test</el-button>--%>
                </div>
            </row>

            <hr style="width: 100%;margin: 10px auto;"/>
        </el-header>

        <el-main style="padding-top: 0;height: 100%">
            <%--文献统计列表--%>
            <div v-show="radio == 2">
                <el-table :data="table.commonTable.data"
                          :header-cell-style="{background:'rgb(79, 165, 254)',color:'#fff'}"
                          v-loading="table.commonTable.loading"
                          style="width: 100%;overflow-y: hidden;
                          margin-top: 20px;"
                          class="scroll-bar"
                          show-summary
                <%--:summary-method="getSummaries"
                @selection-change="onSelectionChange_entity"--%>
                          stripe>
                    <el-table-column
                            type="index"
                            label="序号"
                            header-align="center"
                            align="center"
                            width="80px">
                    </el-table-column>
                    <el-table-column
                            prop="docType"
                            header-align="center"
                            align="center"
                            label="文献类型">
                    </el-table-column>
                    <el-table-column
                            prop="totalDocAmount"
                            header-align="center"
                            align="center"
                            label="文献总数目">
                    </el-table-column>

                    <el-table-column label="文献分类"
                                     align="center"
                                     header-align="center">
                        <el-table-column
                                prop="teacherDocAmount"
                                header-align="center"
                                align="center"
                                label="教师文献数目">
                        </el-table-column>
                        <el-table-column
                                prop="studentDocAmount"
                                header-align="center"
                                align="center"
                                label="学生文献数目">
                        </el-table-column>
                        <el-table-column
                                prop="postdoctoralDocAmount"
                                header-align="center"
                                align="center"
                                label="博士后文献数目">
                        </el-table-column>
                    </el-table-column>

                    <el-table-column label="操作" width="190px" header-align="center" align="center">
                        <template slot-scope="scope">
                            <el-button type="primary" plain
                                       size="mini"
                                       style="position:relative;bottom: 1px;"
                                       @click="viewStatistics(scope.row)">
                                <span>查看统计详情</span>
                            </el-button>
                        </template>
                    </el-table-column>
                </el-table>
            </div>
        </el-main>
    </el-container>
</div>


<%@include file="/WEB-INF/views/include/blankScript.jsp" %>
<script>
    const docOptions = ["论文", "专利"];
    var app = new Vue({
        el: '#app',
        data: {
            radio: "2",
            doc: {
                checkAll: false,
                docType: {
                    /*应该从字典项中查询：*/
                    paper: "论文",
                    patent: "专利",
                },
                checkedDoc: [],
                isIndeterminate: true
            },
            //条件输入(选择)框的候选项：
            optionValue: {
                partitionOption: [
                    {
                        label: "Q1",
                        value: "Q1"
                    },
                    {
                        label: "Q2",
                        value: "Q2"
                    },
                    {
                        label: "Q3",
                        value: "Q3"
                    },
                    {
                        label: "Q4",
                        value: "Q4"
                    }
                ],
                paperTypeOption: [],
                orgOption: [],
                userTypeOption: [
                    {
                        label: "教师",
                        value: "teacher"
                    },
                    {
                        label: "学生",
                        value: "student"
                    },
                    {
                        label: "博士后",
                        value: "postdoctoral"
                    }
                ],
                subjectOption: [],
                pickerOptions: {
                    shortcuts: [{
                        text: '最近一周',
                        onClick(picker) {
                            const end = new Date();
                            const start = new Date();
                            start.setTime(start.getTime() - 3600 * 1000 * 24 * 7);
                            picker.$emit('pick', [start, end]);
                        }
                    }, {
                        text: '最近一个月',
                        onClick(picker) {
                            const end = new Date();
                            const start = new Date();
                            start.setTime(start.getTime() - 3600 * 1000 * 24 * 30);
                            picker.$emit('pick', [start, end]);
                        }
                    }, {
                        text: '最近三个月',
                        onClick(picker) {
                            const end = new Date();
                            const start = new Date();
                            start.setTime(start.getTime() - 3600 * 1000 * 24 * 90);
                            picker.$emit('pick', [start, end]);
                        }
                    }]
                }
            },

            //条件输入(选择)框(V-model绑定的值)：
            optionView: {
                commonSelect: {
                    show: true,
                    userType: "",                             //作者工号
                    workId: "",
                    publishDate: [new Date(1889, 9, 10, 8, 40),new Date()],
                    subject: "",
                    organization: ""
                },
                paper: {
                    show: false,
                    paperName: "",
                    firstAuthorWorkNum: "",
                    secondAuthorWorkNum: "",
                    otherAuthorWorkNum: "",
                    ISSN: "",
                    storeNum: "",
                    paperType: "",
                    /*new add*/
                    impactFactor: "",                                //影响因子
                    paperLevel: "",                                 //论文级别

                    DOI: "",
                    partition: "",
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
                }
            },
            //fullScreenLoading: false,
            //表格
            table: {
                commonTable: {
                    data: [
                        {
                            docType: "论文",
                            totalDocAmount: 300,
                            teacherDocAmount: 100,
                            studentDocAmount: 100,
                            postdoctoralDocAmount: 100
                        },
                        {
                            docType: "专利",
                            totalDocAmount: 300,
                            teacherDocAmount: 100,
                            studentDocAmount: 100,
                            postdoctoralDocAmount: 100
                        }
                    ],
                    loading: false,
                    selectionList: [],
                    params: {
                        pageIndex: 1,
                        pageSize: 10,
                        pageSizes: [5, 10, 20, 40],
                        searchKey: '',  // 搜索词
                        total: 100,       // 总数
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
                console.log("checkedDoc：" + app.doc.checkedDoc);
                this.doc.checkAll = checkedCount === 3;
                this.doc.isIndeterminate = checkedCount > 0 && checkedCount < 3;
                optionViewSelect();
            },

            /*查看文献统计详情*/
            viewStatistics: function (row) {
                if (row.docType === "论文") {
                    let data = {
                        paperName: app.optionView.paper.paperName,
                        firstAuthorName: app.optionView.paper.firstAuthorWorkNum,            //其实是FA工号
                        secondAuthorName: app.optionView.paper.secondAuthorWorkNum,          //其实是SA工号
                        authorList: app.optionView.paper.otherAuthorWorkNum,                 //其实是OA工号
                        storeNum: app.optionView.paper.storeNum,
                        paperType: app.optionView.paper.paperType,
                        ISSN: app.optionView.paper.ISSN,
                        pageIndex: app.table.paperTable.params.pageIndex,
                        pageSize: app.table.paperTable.params.pageSize
                    };
                    let getParam = formatParams(data);
                    let getLink = "/api/doc/search/selectPaperListByPageGet?" + getParam;
                    console.log(getLink);
                    window.parent.app.addTab("论文", getLink);
                } else if (row.docType === "专利") {
                    alert("专利统计详情页面");
                } else {
                    alert("著作权统计详情页面");
                }
            },

            /*paper_table函数*/
            insertPaper: function () {

            },
            deletePaperListByIds: function () {

            },
            updatePaper: function () {

            },
            selectPaperListByPage: function () {
                //formatParams
                let data = {
                    paperName: app.optionView.paper.paperName,
                    firstAuthorName: app.optionView.paper.firstAuthorWorkNum,            //其实是FA工号
                    secondAuthorName: app.optionView.paper.secondAuthorWorkNum,          //其实是SA工号
                    authorList: app.optionView.paper.otherAuthorWorkNum,                 //其实是OA工号
                    storeNum: app.optionView.paper.storeNum,
                    docType: app.optionView.paper.paperType,
                    ISSN: app.optionView.paper.ISSN,
                    page: app.table.paperTable.params
                };
                console.log("post: " + data);
                app.table.paperTable.loading = true;
                ajaxPostJSON("/api/doc/search/selectPaperListByPagePost", data,
                    function success(res) {
                        app.table.paperTable.loading = false;
                        console.log("post请求成功" + res);
                        app.table.paperTable.data = res.data.paperList;
                        app.table.paperTable.params.total = res.data.paperAmount;
                    },
                    function error(res) {
                        console.log("post请求失败: " + res);
                    }
                );
            },

            // 重置表单
            // resetForm: function (ref) {
            //     this.$refs[ref].resetFields();
            // },

            /*统计搜索*/
            statisticalSearch: function () {
                let params = {
                    subject: app.optionView.commonSelect.subject,
                    organization: app.optionView.commonSelect.organization,
                    startDate:app.optionView.commonSelect.publishDate[0],
                    endDate:app.optionView.commonSelect.publishDate[1],
                    paperType: app.optionView.paper.paperType,
                    partition: app.optionView.paper.partition,
                    impactFactor: app.optionView.paper.impactFactor
                };

                if(params.startDate == null){

                }
                console.log(params);

                app.table.commonTable.loading = true;

                ajaxPost(
                    "/doc/statisticalSearch",
                    params,
                    function success(res) {
                        console.log(res);
                    },
                    function error(res) {
                        console.log(res);
                    }
                );
                app.table.commonTable.loading = false;
            },

            /*查看文献详情*/
            viewDocDetails(row) {
                parent.addTab1("文献详情test1", "api/doc/search/docDetails");
                // alert($('#default', window.parent.document).html());
                console.log(row);
                ajaxGet("api/doc/search/docDetails", null,
                    function success(res) {
                        console.log(res);
                    },
                    function error(res) {
                        console.log(res);
                    })
            },

            getSummaries(param) {
                const {columns, data} = param;
                const sums = [];
                columns.forEach((column, index) => {
                    if (index === 1) {
                        sums[index] = '总价';
                        return;
                    }
                    const values = data.map(item => Number(item[column.property]));
                    if (!values.every(value => isNaN(value))) {
                        sums[index] = values.reduce((prev, curr) => {
                            const value = Number(curr);
                            if (!isNaN(value)) {
                                return prev + curr;
                            } else {
                                return prev;
                            }
                        }, 0);
                        sums[index] += ' 元';
                    } else {
                        sums[index] = 'N/A';
                    }
                });
                return sums;
            }
        }
    });

    //选择对应筛选框视图:
    function optionViewSelect() {
        app.optionView.paper.show = false;
        app.optionView.patent.show = false;
        app.optionView.copyright.show = false;
        // app.optionView.commonSelect.show = app.doc.checkedDoc.length <= 0;

        for (let i = 0; i < app.doc.checkedDoc.length; i++) {
            let tmpType = app.doc.checkedDoc[i];
            switch (tmpType) {
                case "论文":
                    app.optionView.paper.show = true;
                    break;
                case "专利":
                    app.optionView.patent.show = true;
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

    //3. 初始化界面时候加载默认参数：
    function initialize() {
        /*初始化paperType*/
        let tmp = ${paperType};
        for (let i = 0; i < tmp.length; i++) {
            let tmpItem = {
                value: tmp[i].id,
                label: tmp[i].name_en
            };
            app.optionValue.paperTypeOption.push(tmpItem);
        }
        /*初始化学校机构*/
        let org = ${orgList};
        for (let i = 0; i < org.length; i++) {
            let tmpOrg = {
                value: org[i],
                label: org[i]
            };
            app.optionValue.orgOption.push(tmpOrg);
        }

        /*初始化学科*/
        let subject = ${subjectList};
        for (let i = 0; i < subject.length; i++) {
            let tmpSub = {
                value: subject[i],
                label: subject[i]
            };
            app.optionValue.subjectOption.push(tmpSub);
        }
    }

    window.onload = function () {
        // app.selectPaperListByPage();
        initialize();
        /*更新一下作者表格数据*/
        // authorSearch();
    };

    /*测试*/
    function test4() {
        /*输出时间段*/
        console.log(app.optionView.commonSelect.publishDate);
    }

    /*查看作者详情-打开新页面*/
    function viewAuthorDetail(row) {
        console.log(row)
        let authorId = row.id;
        let tabTitle = row.realName + "-作者详情";
        let link = "/author/goAuthorDetail?authorId=" + authorId;
        window.parent.app.addTab(tabTitle, link);
    }
</script>

<%--<script src="/static/js/functions/doc/docSearch.js"></script>--%>
</body>
</html>