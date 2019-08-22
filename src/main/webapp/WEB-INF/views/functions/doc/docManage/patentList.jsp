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
    <title>专利统计详情</title>
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
                            <el-select v-model="optionView.commonSelect.institute"
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
                    <div class="commonInputSection" style="width: 320px;">
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

            <div id="patentBox" class="tmp">
                <row>
                    <span class="selectText">
                        <el-tag type="warning">专利筛选项</el-tag>
                    </span>
                    <div class="commonInputSection">
                        <span class="inputSpanText">专利名称:</span>
                        <div class="commonInput">
                            <el-input
                                    placeholder="请输入专利名"
                                    v-model="optionView.patent.patentName"
                                    clearable>
                            </el-input>
                        </div>
                    </div>
                    <div class="commonInputSection">
                        <span class="inputSpanText">专利号: </span>
                        <div class="commonInput">
                            <el-input
                                    placeholder="输入论文期刊号"
                                    v-model="optionView.patent.patentNumber"
                                    clearable>
                            </el-input>
                        </div>
                    </div>
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

                <row style="margin-top: 10px">
                     <span class="selectText">
                         <el-button type="primary"
                                    size="small"
                                    :disabled="table.patentTable.entity.loading"
                                    @click="selectPatentListByPage()">搜索查询</el-button>
                    </span>
                    <div class="commonInputSection">
                        <span class="inputSpanText">第一作者: </span>
                        <div class="commonInput">
                            <el-input
                                    placeholder="输入第一作者工号/学号"
                                    v-model="optionView.patent.firstAuthorWorkId"
                                    clearable>
                            </el-input>
                        </div>
                    </div>
                    <div class="commonInputSection">
                        <span class="inputSpanText">第二作者: </span>
                        <div class="commonInput">
                            <el-input
                                    placeholder="输入第二作者工号/学号"
                                    v-model="optionView.patent.secondAuthorWorkId"
                                    clearable>
                            </el-input>
                        </div>

                    </div>
                    <span class="selectText">
                         <el-button type="danger"
                                    size="small"
                                    :disabled="table.patentTable.entity.loading"
                                    @click="exportPatentList()">导出结果</el-button>
                    </span>
                </row>
            </div>
        </el-header>

        <el-main style="padding: 10px 0;">
            <%-- entity表格 --%>
            <el-table :data="table.patentTable.entity.data"
                      id="patentTable"
                      ref="multipleTable"
                      v-loading="table.patentTable.entity.loading"
                      style="width: 100%;height:100%"
                      class="scroll-bar"
                      @selection-change="table.patentTable.entity.selectionList=$event"
                      stripe>
                <el-table-column
                        prop="patentName"
                        width="240"
                        align="center"
                        fixed="left"
                        label="专利名"
                        show-overflow-tooltip>
                </el-table-column>
                <el-table-column
                        prop="patentNumber"
                        align="center"
                        fixed="left"
                        width="100"
                        label="专利号">
                </el-table-column>
                <%-- <el-table-column
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
                 </el-table-column>--%>

                <%--<el-table-column
                        prop="patentSubject"
                        align="center"
                        width="200"
                        label="一级学科">
                </el-table-column>--%>
                <el-table-column
                        prop="institute"
                        align="center"
                        width="180"
                        label="所属学院">
                </el-table-column>
                <el-table-column
                        prop="patentType"
                        align="center"
                        width="140"
                        label="专利种类"
                        show-overflow-tooltip>
                </el-table-column>
                <el-table-column
                        prop="patentAuthorizationDate"
                        align="center"
                        width="120"
                        label="专利授权日">
                </el-table-column>
                <el-table-column
                        prop="firstAuthorName"
                        align="center"
                        width="120"
                        label="第一作者">
                </el-table-column>
                <el-table-column
                        prop="firstAuthorWorkId"
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
                        align="center"
                        width="140"
                        label="第二作者工号">
                    <template slot-scope="{row}">
                        <template v-if="row.secondAuthorWorkId == null || row.secondAuthorWorkId == ''">
                            <el-button type="danger" size="mini"
                                       style="position:relative;bottom: 1px;margin-left: 6px;">
                                <span>无第二作者</span>
                            </el-button>
                        </template>
                        <template v-else>
                            {{row.secondAuthorWorkId}}
                        </template>
                    </template>
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
                        <template v-else-if="row.secondAuthorType == 'doctor'">
                            博士后
                        </template>
                        <template v-else="">
                            <el-button type="danger" size="mini"
                                       style="position:relative;bottom: 1px;margin-left: 6px;">
                                <span>无第二作者</span>
                            </el-button>
                        </template>
                    </template>
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
                                   @click="deletePatentListByIds([{id: scope.row.id}])">
                            <span>删除专利</span>
                        </el-button>
                    </template>
                </el-table-column>
            </el-table>
            <%-- entity分页 --%>
            <el-pagination style="text-align: center;margin: 8px auto;"
                           @size-change="onPageSizeChange_patent"
                           @current-change="onPageIndexChange_patent"
                           :current-page="table.patentTable.entity.params.pageIndex"
                           :page-sizes="table.patentTable.entity.params.pageSizes"
                           :page-size="table.patentTable.entity.params.pageSize"
                           :total="table.patentTable.entity.params.total"
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
                patentTypeOption: [],
                subjectOption: [],
                orgOption: [],
            },
            //条件输入(选择)框(V-model绑定的值)：
            optionView: {
                patent: {
                    show: false,
                    patentType: "",
                    patentName: "",
                    patentNumber: "",
                    firstAuthorWorkId: "",
                    secondAuthorWorkId: "",

                },
                commonSelect: {
                    show: true,
                    /*2019-08-09 change*/
                    subject: "",
                    institute: "",
                    publishDate: ['', ''],
                }
            },
            fullScreenLoading: false,
            urls: {
                patent: {
                    selectAllPatentByPage: '/api/patent/selectAllPatentByPage',
                    deletePatentListByIds: '/api/doc/paper/deleteListByIds',
                },
            },
            //表格
            table: {
                patentTable: {
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
            //按页条件查询论文数据
            selectPatentListByPage: function () {
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
                    patentName: app.optionView.patent.patentName,
                    patentType: app.optionView.patent.patentType,
                    patentNumber: app.optionView.patent.patentNumber,
                    firstAuthorWorkId: app.optionView.patent.firstAuthorWorkId,
                    secondAuthorWorkId: app.optionView.patent.secondAuthorWorkId,

                    page: app.table.patentTable.entity.params                    //分页
                };
                app.table.patentTable.entity.loading = true;
                ajaxPostJSON(app.urls.patent.selectAllPatentByPage, data, function (d) {
                    console.log(d.data.resultList);
                    app.table.patentTable.entity.loading = false;
                    /*处理日期*/
                    let resList = d.data.resultList;
                    for (let i = 0; i < resList.length; i++) {
                        tmpDate = resList[i].patentAuthorizationDate;
                        resList[i].patentAuthorizationDate = dateFormat(tmpDate);
                    }
                    app.table.patentTable.entity.data = resList;
                    app.table.patentTable.entity.params.total = d.data.total;
                });
            },

            deletePatentListByIds: function (val) {
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
                    ajaxPostJSON(this.urls.patent.deletePatentListByIds, data, function (d) {
                        app.fullScreenLoading = false;
                        window.parent.app.showMessage('删除成功！', 'success');
                        app.refreshTable_patent();
                    })
                }).catch(() => {
                    window.parent.app.showMessage('已取消删除', 'warning');
                });
            },

            // 刷新entity table数据
            refreshTable_patent: function () {
                this.selectPatentListByPage();
            },
            // 处理选中的行变化
            onSelectionChange_patent: function (val) {
                this.table.patentTable.selectionList = val;
            },
            // 处理patent的pageSize变化
            onPageSizeChange_patent: function (newSize) {
                this.table.patentTable.entity.params.pageSize = newSize;
                this.refreshTable_patent();
            },
            // 处理patent的pageIndex变化
            onPageIndexChange_patent: function (newIndex) {
                this.table.patentTable.entity.params.pageIndex = newIndex;
                this.refreshTable_patent();
            },
            //导出当前的所有的论文数据
            exportPatentList: function () {
                window.parent.app.$confirm('确认导出当前条件下的所有专利', '提示', {
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
                        patentName: app.optionView.patent.patentName,
                        patentType: app.optionView.patent.patentType,
                        patentNumber: app.optionView.patent.patentNumber,
                        firstAuthorWorkId: app.optionView.patent.firstAuthorWorkId,
                        secondAuthorWorkId: app.optionView.patent.secondAuthorWorkId,
                    };

                    window.location.href = "/api/patent/exportPatentList?" +
                        "subject=" + data.subject +
                        "&institute=" + data.institute +
                        "&patentName=" + data.patentName +
                        "&patentType=" + data.patentType +
                        "&patentNumber=" + data.patentNumber +
                        "&firstAuthorWorkId=" + data.firstAuthorWorkId +
                        "&secondAuthorWorkId=" + data.secondAuthorWorkId +
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
        let tmp = ${patentTypeList};
        for (let i = 0; i < tmp.length; i++) {
            let tmpItem = {
                value: tmp[i],
                label: tmp[i]
            };
            app.optionValue.patentTypeOption.push(tmpItem);
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
        let subjectList = ${subjectList};
        for (let i = 0; i < subjectList.length; i++) {
            let tmpSub = {
                value: subjectList[i],
                label: subjectList[i]
            };
            app.optionValue.subjectOption.push(tmpSub);
        }

        app.selectPatentListByPage();
    }

    //初始化页面接收初始参数
    window.onload = function () {
        app.optionView.commonSelect.subject = '${subject}';
        app.optionView.commonSelect.institute = '${institute}';
        app.optionView.commonSelect.publishDate[0] = new Date(Date.parse('${startDate}'));
        app.optionView.commonSelect.publishDate[1] = new Date(Date.parse('${endDate}'));
        app.optionView.patent.patentType = '${patentType}';               //这里是type的id
        initialize();
    };
</script>
</body>
</html>