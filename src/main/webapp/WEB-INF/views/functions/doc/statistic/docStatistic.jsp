<%--
  Created by IntelliJ IDEA.
  User: zm
  Date: 2019/8/5
  Time: 14:24
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
                                    start-placeholder="开始日期"
                                    end-placeholder="结束日期">
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
                            <el-select v-model="optionView.paper.journalDivision" clearable placeholder="选择论文分区">
                                <el-option
                                        v-for="item in optionValue.journalDivisionOption"
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
                                    v-model="optionView.paper.impactFactorMin"
                                    @change=""
                                    :min="0"
                                    :step="0.001"
                                    controls-position="right"
                                    style="width: 106px;margin-left: 10px"
                                    placeholder="最低影响因子">
                            </el-input-number>
                            <el-input-number
                                    v-model="optionView.paper.impactFactorMax"
                                    @change=""
                                    :min="0.001"
                                    :step="0.001"
                                    controls-position="right"
                                    style="width: 106px;margin-left: 10px"
                                    placeholder="最高影响因子">
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
                        <span class="inputSpanText">专利类型: </span>
                        <div class="commonInput">
                            <el-select v-model="optionView.patent.patentType" clearable placeholder="选择专利种类">
                                <el-option
                                        v-for="item in optionValue.patentTypeOption"
                                        :key="item.value"
                                        :label="item.label"
                                        :value="item.value">
                                </el-option>
                            </el-select>
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
                    <el-button type="primary" size="medium"
                               :disabled="table.commonTable.loading"
                               @click="statisticalSearch()">统计结果
                    </el-button>
                    <el-button type="danger" size="medium"
                               :disabled="table.commonTable.loading"
                               @click="exportStatisticResult()">导出结果
                    </el-button>
                   <%-- <el-button type="success" size="medium"
                               @click="viewStatisticsDetail({'type':'论文'})">TEST
                    </el-button>--%>
                </div>
            </row>

            <hr style="width: 100%;margin: 10px auto;"/>
        </el-header>

        <el-main style="padding-top: 0;height: 100%">
            <%--文献统计列表--%>
            <div v-show="radio == 2">
                <template>
                    <el-table :data="table.commonTable.data"
                              :header-cell-style="{background:'rgb(79, 165, 254)',color:'#fff'}"
                              v-loading="table.commonTable.loading"
                              style="width: 100%;overflow-y: hidden;margin-top: 20px;"
                              class="scroll-bar"
                              show-summary
                              stripe>
                        <el-table-column
                                type="index"
                                label="序号"
                                header-align="center"
                                align="center"
                                width="80px">
                        </el-table-column>
                        <el-table-column
                                prop="type"
                                header-align="center"
                                align="center"
                                label="文献类型">
                        </el-table-column>
                        <el-table-column
                                prop="totalDocNum"
                                header-align="center"
                                align="center"
                                label="文献总数目">
                        </el-table-column>

                        <el-table-column label="文献分类"
                                         align="center"
                                         header-align="center">
                            <el-table-column
                                    prop="teacherDocNum"
                                    header-align="center"
                                    align="center"
                                    label="教师文献数目">
                            </el-table-column>
                            <el-table-column
                                    prop="studentDocNum"
                                    header-align="center"
                                    align="center"
                                    label="学生文献数目">
                            </el-table-column>
                            <el-table-column
                                    prop="postdoctoralDocNum"
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
                                           @click="viewStatisticsDetail(scope.row)">
                                    <span>查看统计详情</span>
                                </el-button>
                            </template>
                        </el-table-column>
                    </el-table>
                </template>

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
                    isIndeterminate: true,
                    paperResult:{
                       /* totalPaper:0,
                        teacherPaper:0,
                        studentPaper:0,
                        doctorPaper:0*/
                    },
                    patentResult:{
                       /* totalPatent:0,
                        teacherPatent:0,
                        studentPatent:0,
                        doctorPatent:0*/
                    }
                },
                //条件输入(选择)框的候选项：
                optionValue: {
                    journalDivisionOption: [
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
                    patentTypeOption: [],
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
                    subjectOption: []
                },

                //条件输入(选择)框(V-model绑定的值)：
                optionView: {
                    commonSelect: {
                        show: true,
                        userType: "",                             //作者工号
                        workId: "",
                        publishDate: ['', ''],
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
                        impactFactorMin: 0.000,                                //影响因子min
                        impactFactorMax: 100,                                //影响因子max
                        paperLevel: "",                                     //论文级别

                        DOI: "",
                        journalDivision: "",
                    },
                    patent: {
                        show: false,
                        applicationNum: "",
                        countryCode: "",
                        patentType: ""
                    },
                    copyright: {
                        show: false,
                        copySubject: "",
                        copyType: ""
                    }
                },
                table: {
                    commonTable: {
                        data: [],
                        loading: true,
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
                viewStatisticsDetail: function (row) {
                    let app = this;

                    if (row.type === "论文") {
                        let data = {
                            subject: app.optionView.commonSelect.subject,
                            institute: app.optionView.commonSelect.organization,
                            startDate: app.optionView.commonSelect.publishDate[0],
                            endDate: app.optionView.commonSelect.publishDate[1],
                            paperType: app.optionView.paper.paperType,
                            journalDivision: app.optionView.paper.journalDivision,
                            impactFactorMin: app.optionView.paper.impactFactorMin,
                            impactFactorMax: app.optionView.paper.impactFactorMax
                        };

                        let getParam = formatParams(data);
                        let getLink = "/api/doc/search/selectPaperListByPageGet?" + getParam;
                        //console.log(getLink);
                        window.parent.app.addTab("论文", getLink);
                    } else if (row.type === "专利") {
                        let data = {
                            subject: app.optionView.commonSelect.subject,
                            institute: app.optionView.commonSelect.organization,
                            startDate: app.optionView.commonSelect.publishDate[0],
                            endDate: app.optionView.commonSelect.publishDate[1],
                            patentType: app.optionView.patent.patentType
                        };
                        console.log(data);
                        let getParam = formatParams(data);
                        let getLink = "/api/patent/selectPatentListByPageGet?" + getParam;
                        window.parent.app.addTab("专利", getLink);
                    } else {
                        alert("著作权统计详情页面");
                    }
                },

                /*统计搜索*/
                statisticalSearch: function () {
                    this.table.commonTable.loading = true;
                    let app = this;
                    /*version2.0_2019/08/05*/
                    let params = {
                        subject: app.optionView.commonSelect.subject,
                        institute: app.optionView.commonSelect.organization,
                        paperType: app.optionView.paper.paperType,
                        startDate: app.optionView.commonSelect.publishDate[0],
                        endDate: app.optionView.commonSelect.publishDate[1],
                        journalDivision: app.optionView.paper.journalDivision,
                        impactFactorMin: app.optionView.paper.impactFactorMin,
                        impactFactorMax: app.optionView.paper.impactFactorMax,
                        patentType: app.optionView.patent.patentType
                    };
                    ajaxPostJSON("/api/doc/statistic/doDocStatistic", params,
                        function suc(d) {
                            let res = d.data;
                            let paper = {
                                type: '论文',
                                totalDocNum: res.totalPaper,
                                teacherDocNum: res.teacherPaper,
                                studentDocNum: res.studentPaper,
                                postdoctoralDocNum: res.doctorPaper
                            };
                            let patent = {
                                type: '专利',
                                totalDocNum: res.totalPatent,
                                teacherDocNum: res.teacherPatent,
                                studentDocNum: res.studentPatent,
                                postdoctoralDocNum: res.doctorPatent
                            };
                            app.doc.paperResult = paper;
                            console.log("论文统计结果")
                            console.log(paper)
                            app.doc.patentResult = patent;
                          /*  app.doc.paperResult.totalPaper = paper.totalDocNum;
                            app.doc.paperResult.teacherPaper = paper.teacherDocNum;
                            app.doc.paperResult.studentPaper = paper.studentDocNum;
                            app.doc.paperResult.doctorPaper = paper.postdoctoralDocNum;*/

                            app.table.commonTable.data = [];
                            app.table.commonTable.data.push(paper);
                            app.table.commonTable.data.push(patent);

                            app.table.commonTable.loading = false;
                        }, null)
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
                },

                //4. 统计结果导出成excel格式
                exportStatisticResult() {
                    let app = this;
                    /*console.log(app.doc.paperResult);
                    console.log(app.doc.patentResult);*/
                    window.location.href = "/api/doc/statistic/exportStatisticExcel?" +
                        "studentPaper=" + app.doc.paperResult.studentDocNum +
                        "&teacherPaper=" + app.doc.paperResult.teacherDocNum +
                        "&doctorPaper=" + app.doc.paperResult.postdoctoralDocNum +
                        "&totalPaper=" + app.doc.paperResult.totalDocNum +
                        "&studentPatent=" + app.doc.patentResult.studentDocNum +
                        "&teacherPatent=" + app.doc.patentResult.teacherDocNum +
                        "&doctorPatent=" + app.doc.patentResult.postdoctoralDocNum +
                        "&totalPatent=" + app.doc.patentResult.totalDocNum
                }
            },
            /*加载的时候就执行一次*/
            mounted: function () {
                this.statisticalSearch();
            }
        })
    ;

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
        /*初始化patentType*/
        let tmp1 = ${patentType};
        for (let i = 0; i < tmp1.length; i++) {
            let tmpItem = {
                value: tmp1[i],
                label: tmp1[i]
            };
            app.optionValue.patentTypeOption.push(tmpItem);
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
        initialize();
    };
</script>

</body>
</html>