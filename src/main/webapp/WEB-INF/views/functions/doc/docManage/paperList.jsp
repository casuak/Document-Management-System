<%--
  Created by IntelliJ IDEA.
  User: zm
  Date: 2019/4/11
  Time: 9:00
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>论文统计详情</title>
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
            background-color: rgb(237, 237, 238);
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
    </style>
</head>
<body>
<div id="app" v-cloak style="background: white;height: 100%;" v-loading="fullScreenLoading">
    <el-container>
        <el-header height="100%">
            <%--搜索选项部分--%>
            <div id="commonBox" class="tmp">
                <row>
                    <span class="selectText">
                        <el-tag>公共筛选项</el-tag>
                    </span>
                    <%--所属学科--%>
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
                    <%--所在机构--%>
                    <div class="commonInputSection">
                        <span class="inputSpanText">所在机构: </span>
                        <div class="commonInput">
                            <el-select v-model="optionView.commonSelect.institute"
                                       filterable
                                       clearable
                                       placeholder="选择所属学科">
                                <el-option
                                        v-for="item in optionValue.orgOption"
                                        :key="item.value"
                                        :label="item.label"
                                        :value="item.value">
                                </el-option>
                            </el-select>
                        </div>
                    </div>
                </row>
                <row style="margin-top: 10px">
                    <div class="commonInputSection" style="margin-left:145px;width: 430px">
                        <span class="inputSpanText">出版时间: </span>
                        <div class="commonInput">
                            <el-date-picker
                                    v-model="optionView.commonSelect.publishDate"
                                    type="daterange"
                                    align="right"
                                    unlink-panels
                                    range-separator="至"
                                    start-placeholder="开始日期"
                                    end-placeholder="结束日期">
                            </el-date-picker>
                        </div>
                    </div>
                </row>
            </div>

            <div id="paperBox" class="tmp">
                <row>
                    <span class="selectText">
                        <el-tag type="danger">论文筛选项</el-tag>
                    </span>
                    <div class="commonInputSection">
                        <span class="inputSpanText">论文名称:</span>
                        <div class="commonInput">
                            <el-input
                                    placeholder="请输入论文名"
                                    v-model="optionView.paper.paperName"
                                    clearable>
                            </el-input>
                        </div>
                    </div>
                    <%--paper-论文种类--%>
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
                    <%--paper-论文分区--%>
                    <div class="commonInputSection">
                        <span class="inputSpanText">论文分区: </span>
                        <div class="commonInput">
                            <el-select v-model="optionView.paper.journalDivision" clearable placeholder="选择论文分区">
                                <el-option
                                        v-for="item in optionValue.partitionOption"
                                        :key="item.value"
                                        :label="item.label"
                                        :value="item.value">
                                </el-option>
                            </el-select>
                        </div>
                    </div>
                </row>

                <row style="margin-top: 10px">
                    <%--paper-第一作者--%>
                    <div class="commonInputSection" style="margin-left: 145px">
                        <span class="inputSpanText">第一作者: </span>
                        <div class="commonInput">
                            <el-input
                                    placeholder="输入第一作者工号/学号"
                                    v-model="optionView.paper.firstAuthorWorkId"
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
                                    v-model="optionView.paper.secondAuthorWorkId"
                                    clearable>
                            </el-input>
                        </div>

                    </div>
                    <%--paper-期刊号--%>
                    <div class="commonInputSection">
                        <span class="inputSpanText">ISSN: </span>
                        <div class="commonInput">
                            <el-input
                                    placeholder="输入论文期刊号"
                                    v-model="optionView.paper.ISSN"
                                    clearable>
                            </el-input>
                        </div>
                    </div>
                </row>

                <row style="margin-top: 10px">

                    <span class="selectText">
                         <el-button type="primary"
                                    size="small"
                                    :disabled="table.paperTable.entity.loading"
                                    @click="selectPaperListByPage()">搜索查询</el-button>
                    </span>

                    <div class="commonInputSection" style="width: 330px">
                        <span class="inputSpanText">影响因子: </span>
                        <div class="commonInput">
                            <el-input-number
                                    v-model="optionView.paper.impactFactorMin"
                                    @change=""
                                    :min="0"
                                    :step="0.001"
                                    controls-position="right"
                                    style="width: 120px;margin-left: 10px"
                                    placeholder="最低影响因子">
                            </el-input-number>
                            <el-input-number
                                    v-model="optionView.paper.impactFactorMax"
                                    @change=""
                                    :min="0.001"
                                    :step="0.001"
                                    controls-position="right"
                                    style="width: 120px;margin-left: 10px"
                                    placeholder="最高影响因子">
                            </el-input-number>
                        </div>
                    </div>

                    <span class="selectText">
                         <el-button type="danger"
                                    size="small"
                                    :disabled="table.paperTable.entity.loading"
                                    @click="exportPaperList()">导出结果</el-button>
                    </span>
                </row>
            </div>
        </el-header>

        <el-main style="padding: 10px 0;">
            <%-- entity表格 --%>
            <el-table :data="table.paperTable.entity.data"
                      id="paperTable"
                      ref="multipleTable"
                      v-loading="table.paperTable.entity.loading"
                      style="width: 100%;height:100%"
                      class="scroll-bar"
                      @selection-change="table.paperTable.entity.selectionList=$event"
                      stripe>
                <%--<el-table-column type="selection" width="40"></el-table-column>--%>
                <el-table-column
                        prop="paperName"
                        width="240"
                        align="center"
                        fixed="left"
                        label="论文名"
                        show-overflow-tooltip>
                </el-table-column>
                <el-table-column
                        prop="issn"
                        align="center"
                        fixed="left"
                        width="100"
                        label="ISSN">
                </el-table-column>
                <el-table-column
                        align="center"
                        fixed="left"
                        width="100"
                        label="分区">
                    <template slot-scope="{row}">
                        <template v-if="row.journalDivision == null || row.journalDivision == ''">
                            <el-button type="danger" size="mini"
                                       style="position:relative;bottom: 1px;margin-left: 6px;">
                                <span>暂无分区</span>
                            </el-button>
                        </template>
                        <template v-else>
                            {{row.journalDivision}}
                        </template>
                    </template>
                </el-table-column>
                <el-table-column
                        align="center"
                        fixed="left"
                        width="100"
                        label="影响因子">
                    <template slot-scope="{row}">
                        <template v-if="row.impactFactor == null || row.impactFactor == ''">
                            <el-button type="danger" size="mini"
                                       style="position:relative;bottom: 1px;margin-left: 6px;">
                                <span>暂无影响因子</span>
                            </el-button>
                        </template>
                        <template v-else>
                            {{row.impactFactor}}
                        </template>
                    </template>
                </el-table-column>
                <%--<el-table-column
                        prop="subject"
                        align="center"
                        width="200"
                        label="一级学科">
                </el-table-column>--%>
                <el-table-column
                        prop="danweiCn"
                        align="center"
                        width="180"
                        label="所属学院">
                </el-table-column>
                <el-table-column
                        prop="docType"
                        align="center"
                        width="140"
                        label="论文种类"
                        show-overflow-tooltip>
                </el-table-column>
                <el-table-column
                        prop="publishDate"
                        align="center"
                        width="120"
                        label="出版日期">
                </el-table-column>
                <el-table-column
                        prop="firstAuthorName"
                        align="center"
                        width="120"
                        label="第一作者">
                </el-table-column>
                <el-table-column
                        prop="firstAuthorId"
                        align="center"
                        width="140"
                        label="第一作者工号">
                </el-table-column>
                <el-table-column
                        prop="firstAuthorType"
                        align="center"
                        width="140"
                        label="第一作者类型">
                    <template slot-scope="{row}">
                        <template v-if="row.firstAuthorType == 'student'">
                            学生
                        </template>
                        <template v-else-if="row.firstAuthorType == 'teacher'">
                            导师
                        </template>
                        <template v-else>
                            博士后
                        </template>
                    </template>
                </el-table-column>
                <el-table-column
                        prop="secondAuthorName"
                        align="center"
                        width="120"
                        label="第二作者">
                </el-table-column>
                <el-table-column
                        prop="secondAuthorId"
                        align="center"
                        width="140"
                        label="第二作者工号">
                </el-table-column>
                <el-table-column
                        prop="secondAuthorType"
                        align="center"
                        width="140"
                        label="第二作者类型">
                    <template slot-scope="{row}">
                        <template v-if="row.secondAuthorType == 'student'">
                            学生
                        </template>
                        <template v-else-if="row.secondAuthorType == 'teacher'">
                            导师
                        </template>
                        <template v-else>
                            博士后
                        </template>
                    </template>
                </el-table-column>
                <el-table-column
                        prop="storeNum"
                        width="160"
                        align="center"
                        label="入藏号">
                </el-table-column>
                <el-table-column
                        prop="authorList"
                        width="300"
                        align="center"
                        show-overflow-tooltip
                        label="作者列表">
                </el-table-column>
                <el-table-column
                        label="操作"
                        width="100"
                        fixed="right"
                        align="center">
                    <template slot-scope="scope">
                        <el-button type="danger" size="mini" style="position:relative;bottom: 1px;margin-left: 6px;"
                                   @click="deletePaperListByIds([{id: scope.row.id}])">
                            <span>删除论文</span>
                        </el-button>
                    </template>
                </el-table-column>
            </el-table>
            <%-- entity分页 --%>
            <el-pagination style="text-align: center;margin: 8px auto;"
                           @size-change="onPageSizeChange_paper"
                           @current-change="onPageIndexChange_paper"
                           :current-page="table.paperTable.entity.params.pageIndex"
                           :page-sizes="table.paperTable.entity.params.pageSizes"
                           :page-size="table.paperTable.entity.params.pageSize"
                           :total="table.paperTable.entity.params.total"
                           layout="total, sizes, prev, pager, next, jumper">
            </el-pagination>
        </el-main>
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
                    /*应该从字典项中查询：*/
                    paper: "论文",
                    patent: "专利",
                    copyright: "著作权"
                },
                checkedDoc: [],
                isIndeterminate: true
            },
            //条件输入(选择)框的候选项：
            optionValue: {
                authorTypeOption: [
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
                        value: "doctor"
                    }
                ],
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
                subjectOption: [],
                orgOption: [],
            },
            //条件输入(选择)框(V-model绑定的值)：
            optionView: {
                paper: {
                    /*2019-08-09 change*/
                    show: false,
                    paperName: "",
                    firstAuthorWorkId: "",
                    secondAuthorWorkId: "",
                    ISSN: "",
                    paperType: "",
                    journalDivision: "",                   //论文分区
                    impactFactorMin: null,
                    impactFactorMax: null
                    /*2019-08-09 change*/
                },
                commonSelect: {
                    show: true,
                    /*2019-08-09 change*/
                    authorType: "",
                    subject: "",
                    institute: "",
                    publishDate: ['', ''],
                }
            },
            fullScreenLoading: false,
            urls: {
                paper: {
                    selectAllPaperByPage: '/api/paper/selectAllPaperByPage',
                    deletePaperListByIds: '/api/doc/paper/deleteListByIds',
                },
            },
            //表格
            table: {
                paperTable: {
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
            //按页条件查询论文数据
            selectPaperListByPage: function () {
                let app = this;

                if (app.optionView.commonSelect.publishDate == null) {
                    app.optionView.commonSelect.publishDate = ['', ''];
                }

                let data = {
                    //筛选条件
                    subject: app.optionView.commonSelect.subject,
                    institute: app.optionView.commonSelect.institute,
                    startDate: app.optionView.commonSelect.publishDate[0],
                    endDate: app.optionView.commonSelect.publishDate[1],
                    paperName: app.optionView.paper.paperName,
                    paperType: app.optionView.paper.paperType,
                    journalDivision: app.optionView.paper.journalDivision,        //分区
                    impactFactorMin: app.optionView.paper.impactFactorMin,
                    impactFactorMax: app.optionView.paper.impactFactorMax,
                    firstAuthorWorkId: app.optionView.paper.firstAuthorWorkId,
                    secondAuthorWorkId: app.optionView.paper.secondAuthorWorkId,
                    issn: app.optionView.paper.ISSN,

                    page: app.table.paperTable.entity.params                    //分页
                };
                app.table.paperTable.entity.loading = true;
                ajaxPostJSON(app.urls.paper.selectAllPaperByPage, data, function (d) {
                    console.log(d.data.resultList);
                    app.table.paperTable.entity.loading = false;
                    /*处理日期*/
                    let resList = d.data.resultList;
                    for (let i = 0; i < resList.length; i++) {
                        tmpDate = resList[i].publishDate;
                        resList[i].publishDate = dateFormat(tmpDate);
                    }
                    app.table.paperTable.entity.data = resList;
                    app.table.paperTable.entity.params.total = d.data.total;
                });
            },

            deletePaperListByIds: function (val) {
                if (val.length === 0) {
                    window.parent.app.showMessage('提示：未选中任何项', 'warning');
                    return;
                }
                window.parent.app.$confirm('确认删除选中的项', '警告', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(() => {
                    let data = val;
                    let app = this;
                    app.fullScreenLoading = true;
                    ajaxPostJSON(this.urls.paper.deletePaperListByIds, data, function (d) {
                        app.fullScreenLoading = false;
                        window.parent.app.showMessage('删除成功！', 'success');
                        app.refreshTable_paper();
                    })
                }).catch(() => {
                    window.parent.app.showMessage('已取消删除', 'warning');
                });
            },

            // 刷新entity table数据
            refreshTable_paper: function () {
                this.selectPaperListByPage();
            },
            // 处理选中的行变化
            onSelectionChange_paper: function (val) {
                this.table.paperTable.selectionList = val;
            },
            // 处理paper的pageSize变化
            onPageSizeChange_paper: function (newSize) {
                this.table.paperTable.entity.params.pageSize = newSize;
                this.refreshTable_paper();
            },
            // 处理paper的pageIndex变化
            onPageIndexChange_paper: function (newIndex) {
                this.table.paperTable.entity.params.pageIndex = newIndex;
                this.refreshTable_paper();
            },
            //导出当前的所有的论文数据
            exportPaperList: function () {
                window.parent.app.$confirm('确认导出当前条件下的所有论文', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(() => {
                    let app = this;
                    let data = {
                        //筛选条件
                        subject: app.optionView.commonSelect.subject,
                        institute: app.optionView.commonSelect.institute,
                        startDate: app.optionView.commonSelect.publishDate[0],
                        endDate: app.optionView.commonSelect.publishDate[1],
                        paperName: app.optionView.paper.paperName,
                        paperType: app.optionView.paper.paperType,
                        journalDivision: app.optionView.paper.journalDivision,        //分区
                        impactFactorMin: app.optionView.paper.impactFactorMin,
                        impactFactorMax: app.optionView.paper.impactFactorMax,
                        firstAuthorWorkId: app.optionView.paper.firstAuthorWorkId,
                        secondAuthorWorkId: app.optionView.paper.secondAuthorWorkId,
                        issn: app.optionView.paper.ISSN,
                    };

                    window.location.href = "/api/paper/exportPaperList?" +
                        "paperName=" + data.paperName +
                        "&paperType=" + data.paperType +
                        "&subject=" + data.subject +
                        "&institute=" + data.institute +
                        "&journalDivision=" + data.journalDivision +
                        "&impactFactorMin=" + data.impactFactorMin +
                        "&impactFactorMax=" + data.impactFactorMax +
                        "&firstAuthorWorkId=" + data.firstAuthorWorkId +
                        "&secondAuthorWorkId=" + data.secondAuthorWorkId +
                        "&issn=" + data.issn +
                        "&startDate=" + dateToString(data.startDate) +
                        "&endDate=" + dateToString(data.endDate);
                }).catch(() => {
                    window.parent.app.showMessage('已取消导出', 'warning');
                });
            }
        }
    });

    function dateToString(date) {
        console.log(date);
        console.log(typeof (date));
        console.log(date.getFullYear);
        let year = date.getFullYear();
        let month = (date.getMonth() + 1).toString();
        let day = (date.getDate()).toString();
        if (month.length === 1) {
            month = "0" + month;
        }
        if (day.length === 1) {
            day = "0" + day;
        }
        return year + "-" + month + "-" + day;
    }

    function add0(m) {
        return m < 10 ? '0' + m : m
    }

    //格式化时间
    function dateFormat(shijianchuo) {
        //时间戳是整数，否则要parseInt转换
        let time = new Date(shijianchuo);
        let y = time.getFullYear();
        let m = time.getMonth() + 1;
        let d = time.getDate() + 1;
        let h = time.getHours() + 1;
        let mm = time.getMinutes() + 1;
        let s = time.getSeconds() + 1;
        //return y + '-' + add0(m) + '-' + add0(d) + ' ' + add0(h) + ':' + add0(mm) + ':' + add0(s);
        return y + '-' + add0(m) + '-' + add0(d);
    }

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
        /*1.初始化论文种类*/
        let tmp = ${paperTypeList};
        for (let i = 0; i < tmp.length; i++) {
            let tmpItem = {
                value: tmp[i].id,
                label: tmp[i].name_en
            };
            app.optionValue.paperTypeOption.push(tmpItem);
        }
        /*2.初始化学校机构*/
        let org = ${orgList};
        for (let i = 0; i < org.length; i++) {
            let tmpOrg = {
                value: org[i],
                label: org[i]
            };
            app.optionValue.orgOption.push(tmpOrg);
        }
        /*3.初始化学科*/
        let subject = ${subjectList};
        for (let i = 0; i < subject.length; i++) {
            let tmpSub = {
                value: subject[i],
                label: subject[i]
            };
            app.optionValue.subjectOption.push(tmpSub);
        }

        app.selectPaperListByPage();
    }

    //初始化页面接收初始参数
    window.onload = function () {
        app.optionView.commonSelect.subject = '${subject}';
        app.optionView.commonSelect.institute = '${institute}';
        app.optionView.commonSelect.publishDate[0] = new Date(Date.parse('${startDate}'));
        app.optionView.commonSelect.publishDate[1] = new Date(Date.parse('${endDate}'));
        app.optionView.paper.paperType = '${paperType}';               //这里是type的id
        app.optionView.paper.paperPartition = '${journalDivision}';
        app.optionView.paper.impactFactorMin = ${impactFactorMin};
        app.optionView.paper.impactFactorMax = ${impactFactorMax};

        initialize();
    };
</script>
</body>
</html>