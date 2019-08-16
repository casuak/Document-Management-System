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
    <title>docSearch</title>
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

        /* .has-gutter .cell {
             height: 45px;
             line-height: 45px;
         }*/
        .el-table__row .cell {
            height: 42px;
            line-height: 42px;
        }
    </style>
</head>
<body>
<div id="app" v-cloak style="background: white;height: 100%;">
    <el-container style="height: 100%">
        <el-header height="auto">
            <%--搜索选项部分--%>
            <div id="commonBox" class="tmp" v-show="optionView.commonSelect.show">
                <row>
                    <div class="commonInputSection">
                        <span class="inputSpanText">作者身份: </span>
                        <div class="commonInput">
                            <el-select v-model="optionView.commonSelect.userType"
                                       filterable
                                       clearable
                                       placeholder="选择作者身份">
                                <el-option
                                        v-for="item in optionValue.userTypeOption"
                                        :key="item.value"
                                        :label="item.label"
                                        :value="item.value">
                                </el-option>
                            </el-select>
                        </div>
                    </div>
                    <div class="commonInputSection">
                        <span class="inputSpanText">作者姓名: </span>
                        <div class="commonInput">
                            <el-input
                                    placeholder="输入作者真实姓名"
                                    v-model="optionView.commonSelect.realName"
                                    clearable>
                            </el-input>
                        </div>
                    </div>
                    <div class="commonInputSection">
                        <span class="inputSpanText">作者工号: </span>
                        <div class="commonInput">
                            <el-input
                                    placeholder="输入作者工号"
                                    v-model="optionView.commonSelect.workId"
                                    clearable>
                            </el-input>
                        </div>
                    </div>
                </row>
                <row>
                    <div class="commonInputSection">
                        <span class="inputSpanText">一级学科: </span>
                        <div class="commonInput">
                            <el-select v-model="optionView.commonSelect.subject"
                                       filterable
                                       clearable
                                       placeholder="选择一级学科">
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
                        <span class="inputSpanText">学校机构: </span>
                        <div class="commonInput">
                            <el-select v-model="optionView.commonSelect.organization"
                                       filterable
                                       clearable
                                       placeholder="选择学校机构">
                                <el-option
                                        v-for="item in optionValue.orgOption"
                                        :key="item.value"
                                        :label="item.label"
                                        :value="item.value">
                                </el-option>
                            </el-select>
                        </div>
                    </div>
                    <div class="commonInputSection" style="margin-top: 5px">
                        <el-button type="primary" size="small" @click="searchClick">查询作者
                        </el-button>
                    </div>
                </row>
            </div>

            <hr style="width: 100%;margin: 10px auto;"/>
        </el-header>

        <el-main style="padding: 0;height: 100%">
            <%--作者查询列表--%>
            <div style="height: 100%;overflow: hidden;margin-top: 0">
                <el-table :data="table.authorTable.data"
                          :header-cell-style="{background:'rgb(0, 124, 196)',color:'#fff'}"
                          height="calc(100% - 35px)"
                          v-loading="table.authorTable.loading"
                          class="scroll-bar"
                <%-- :default-sort = "{prop: 'paperAmount', order: 'descending'}"--%>
                <%--style="margin-top: 0;width: 100%;overflow-y: hidden;"--%>
                <%--@selection-change="onSelectionChange_entity"--%>
                          stripe>
                    <%--<el-table-column type="selection" width="60px">--%>
                    </el-table-column>
                    <el-table-column
                            type="index"
                            label="序号"
                            header-align="center"
                            align="center"
                            fixed="left"
                            width="50">
                    </el-table-column>
                    <el-table-column
                            prop="realName"
                            header-align="center"
                            align="center"
                            fixed="left"
                            width="130"
                            show-overflow-tooltip
                            label="作者姓名">
                    </el-table-column>
                    <el-table-column
                            prop="workId"
                            header-align="center"
                            align="center"
                            width="150"
                            fixed="left"
                            label="作者工号">
                    </el-table-column>
                    <el-table-column
                            prop="userType"
                            header-align="center"
                            fixed="left"
                            align="center"
                            width="80"
                            label="作者身份">
                        <template slot-scope="{row}">
                            <template v-if="row.userType == 'student'">
                                学生
                            </template>
                            <template v-else-if="row.userType == 'teacher'">
                                导师
                            </template>
                            <template v-else>
                                博士后
                            </template>
                        </template>
                    </el-table-column>
                    <el-table-column
                            prop="major"
                            header-align="center"
                            align="center"
                            sortable
                            width="195"
                            label="一级学科">
                    </el-table-column>
                    <el-table-column
                            prop="school"
                            header-align="center"
                            align="center"
                            sortable
                            width="195"
                            label="所属机构">
                    </el-table-column>
                    <el-table-column
                            header-align="center"
                            align="center"
                            width="150"
                            label="导师类别">
                        <template slot-scope="{row}">
                            <template v-if="row.userType == 'teacher'" key="keyTutorType0">
                                (职称){{row.tutorTitle}}
                            </template>
                            <template v-else key="keyTutorType1">
                                <template v-if="row.tutorType == '' || row.tutorType == null" key="keyTutorType2">
                                    <el-button type="primary" size="mini">暂无导师类别</el-button>
                                </template>
                                <template v-else key="keyTutorType3">
                                    {{row.tutorType}}
                                </template>
                            </template>
                        </template>
                    </el-table-column>
                    <el-table-column
                            header-align="center"
                            align="center"
                            width="120"
                            label="导师姓名">
                        <template slot-scope="{row}">
                            <template v-if="row.userType == 'teacher'" key="key1">
                                <el-button type="danger" size="mini">已是导师</el-button>
                            </template>
                            <template v-else key="key2">
                                <template v-if="row.tutorRealName == '' || row.tutorRealName == null" key="key3">
                                    <el-button type="primary" size="mini">暂无导师</el-button>
                                </template>
                                <template v-else key="key4">
                                    {{row.tutorRealName}}
                                </template>
                            </template>
                        </template>
                    </el-table-column>
                    <el-table-column
                            header-align="center"
                            align="center"
                            width="120"
                            label="导师工号">
                        <template slot-scope="{row}">
                            <template v-if="row.userType == 'teacher'" key="key5">
                                <el-button type="danger" size="mini">已是导师</el-button>
                            </template>
                            <template v-else key="key6">
                                <template v-if="row.tutorRealName == '' || row.tutorRealName == null" key="key7">
                                    <el-button type="primary" size="mini">暂无导师</el-button>
                                </template>
                                <template v-else key="key8">
                                    {{row.tutorWorkId}}
                                </template>
                            </template>
                        </template>
                    </el-table-column>
                    <el-table-column
                            header-align="center"
                            align="center"
                            width="120"
                            label="学生培养层次类型">
                        <template slot-scope="{row}">
                            <template v-if="row.userType == 'teacher'" key="keyTrainLevel0">
                                <el-button type="danger" size="mini">已是导师</el-button>
                            </template>
                            <template v-else key="keyTrainLevel1">
                                <template v-if="row.studentTrainLevel == '' || row.studentTrainLevel == null" key="keyTrainLevel2">
                                    <el-button type="primary" size="mini">暂无培养层次</el-button>
                                </template>
                                <template v-else key="keyTrainLevel3">
                                    {{row.studentTrainLevel}}
                                </template>
                            </template>
                        </template>
                    </el-table-column>

                    <el-table-column
                            header-align="center"
                            align="center"
                            width="120"
                            label="学生学位类型">
                        <template slot-scope="{row}">
                            <template v-if="row.userType == 'teacher'" key="keyDegreeType0">
                                <el-button type="danger" size="mini">已是导师</el-button>
                            </template>
                            <template v-else key="keyDegreeType1">
                                <template v-if="row.studentDegreeType == '' || row.studentDegreeType == null" key="keyDegreeType2">
                                    <el-button type="primary" size="mini">暂无学位类型</el-button>
                                </template>
                                <template v-else key="keyDegreeType3">
                                    {{row.studentDegreeType}}
                                </template>
                            </template>
                        </template>
                    </el-table-column>

                    <el-table-column
                            prop="nicknames"
                            header-align="center"
                            align="center"
                            width="200"
                            show-overflow-tooltip
                            label="昵称列表">
                    </el-table-column>
                    <el-table-column label="操作"
                                     width="100"
                                     fixed="right"
                                     header-align="center"
                                     align="center">
                        <template slot-scope="scope">
                            <el-button type="primary" plain
                                       size="mini"
                                       style="position:relative;bottom: 1px;"
                                       @click="viewAuthorDetail(scope.row)">
                                <span>查看作者详情</span>
                            </el-button>
                        </template>
                    </el-table-column>
                </el-table>
                <%-- entity分页 --%>
                <el-pagination style="text-align: center;margin:0 auto;"
                               @size-change="authorPageSizeChange"
                               @current-change="authorPageIndexChange"
                               :current-page="table.authorTable.params.pageIndex"
                               :page-sizes="table.authorTable.params.pageSizes"
                               :page-size="table.authorTable.params.pageSize"
                               :total="table.authorTable.params.total"
                               layout="total, sizes, prev, pager, next, jumper">
                </el-pagination>
            </div>
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
                paperLevelOption: [
                    {
                        label: "第一级",
                        value: 1
                    },
                    {
                        label: "第二级",
                        value: 2
                    },
                    {
                        label: "第三级",
                        value: 3
                    },
                    {
                        label: "第四级",
                        value: 4
                    },
                    {
                        label: "第五级",
                        value: 5
                    },
                    {
                        label: "第六级",
                        value: 6
                    },
                ],
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
                    userType: "",
                    realName:"",
                    workId: "",
                    publishDate: "",
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
                    paperLevel: ""                                   //论文级别
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
                paperTable: {
                    urls: {},
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
                authorTable: {
                    loading: false,
                    data: [],
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
                        },
                        {
                            docType: "著作权",
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

            // 处理选中的行变化
            onSelectionChange: function (val) {
                this.table.authorTable.selectionList = val;
            },
            // 处理pageSize变化
            authorPageSizeChange: function (newSize) {
                console.log("处理pageSize变化");
                app.table.authorTable.params.pageSize = newSize;
                authorSearch();
            },
            // 处理pageIndex变化
            authorPageIndexChange: function (newIndex) {
                console.log("处理pageIndex变化");
                app.table.authorTable.params.pageIndex = newIndex;
                authorSearch();
            },

            // 重置表单
            // resetForm: function (ref) {
            //     this.$refs[ref].resetFields();
            // },

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

    function searchClick() {
        app.table.authorTable.params = {
            pageIndex: 1,
            pageSize: app.table.authorTable.params.pageSize,
            pageSizes: [5, 10, 20, 40],
            searchKey: '',
            total: 100,
        };
        authorSearch();
    }

    /*执行作者查询*/
    function authorSearch() {
        app.table.authorTable.loading = true;
        let author = {
            //待查作者类型
            userType: app.optionView.commonSelect.userType,
            //待查作者的真实姓名
            realName: app.optionView.commonSelect.realName,
            //待查作者工号
            workId: app.optionView.commonSelect.workId,
            //待查作者学科名
            subjectName: app.optionView.commonSelect.subject,
            //待查作者机构名称
            organizationName: app.optionView.commonSelect.organization,
            //分页信息
            page: app.table.authorTable.params,
        };
        setTimeout(function () {
            ajaxPostJSON("/author/getAuthorListByPage", author,
                function success(res) {
                    if (res.code === 'success') {
                        console.log(res.data.resultList);
                        app.table.authorTable.data = res.data.resultList;
                        app.table.authorTable.params.total = res.data.total;
                        app.table.authorTable.loading = false;
                    }
                }, null, false
            );
        }, 200)
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
        authorSearch();
    };

    /*测试*/
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

    //模态框测试：
    function test3() {
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

    /*查看作者详情-打开新页面*/
    function viewAuthorDetail(row) {
        let authorId = row.id;
        let tabTitle = row.realName + "-作者详情";
        let link = "/author/goAuthorDetail?authorId=" + authorId;
        window.parent.app.addTab(tabTitle, link);
    }
</script>

<%--<script src="/static/js/functions/doc/docSearch.js"></script>--%>
</body>
</html>