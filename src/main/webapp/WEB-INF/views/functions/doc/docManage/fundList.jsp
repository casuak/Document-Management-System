<%--
  Created by IntelliJ IDEA.
  User: zch
  Date: 2019/9/16
  Time: 20:46
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
                </row>
            </div>

                <div id="fundBox" class="tmp">
                    <row>
                    <span class="selectText">
                        <el-tag type="success">基金筛选项</el-tag>
                    </span>
                        <div class="commonInputSection">
                            <span class="inputSpanText">基金类型: </span>
                            <div class="commonInput">
                                <el-select v-model="optionView.fund.fundType" clearable placeholder="选择基金种类">
                                    <el-option
                                            v-for="item in optionValue.fundOption"
                                            :key="item.value"
                                            :label="item.label"
                                            :value="item.value">
                                    </el-option>
                                </el-select>
                            </div>
                        </div>

                    </row>
                </div>

                <row style="margin-top: 10px">
                     <span class="selectText">
                         <el-button type="primary"
                                    size="small"
                                    :disabled="table.fundTable.entity.loading"
                                    @click="selectFundListByPage()">搜索查询</el-button>
                    </span>
                    <span class="selectText">
                         <el-button type="danger"
                                    size="small"
                                    :disabled="table.fundTable.entity.loading"
                                    @click="exportFundList()">导出结果</el-button>
                    </span>
                </row>
        </el-header>

        <el-main style="padding: 10px 0;">
            <%-- entity表格 --%>
            <el-table :data="table.fundTable.entity.data"
                      id="fundTable"
                      ref="multipleTable"
                      v-loading="table.fundTable.entity.loading"
                      style="width: 100%;height:100%"
                      class="scroll-bar"
                      @selection-change="table.fundTable.entity.selectionList=$event"
                      stripe>
                <el-table-column
                        type="index" label="序号"
                        header-align="center" align="center"
                        width="150">
                </el-table-column>
                <el-table-column label="指标名称" width="150" prop="metricName" align="center"></el-table-column>
                <el-table-column label="姓名" width="150" prop="personName" align="center"></el-table-column>
                <el-table-column label="工号" width="150" prop="personWorkId" align="center"></el-table-column>
                <el-table-column label="年份" width="150" prop="projectYear" align="center"></el-table-column>
                <el-table-column label="项目名称" width="600" prop="projectName" align="center"></el-table-column>
                <el-table-column label="金额（万元)" width="100" prop="projectMoney" align="center"></el-table-column>

                <el-table-column
                        label="操作"
                        width="100"
                        fixed="right"
                        align="center">
                    <template slot-scope="scope">
                        <el-button type="danger" size="mini" style="position:relative;bottom: 1px;margin-left: 6px;"
                                   @click="deleteFundListByIds([{id: scope.row.id}])">
                            <span>删除基金</span>
                        </el-button>
                    </template>
                </el-table-column>
            </el-table>
            <%-- entity分页 --%>
            <el-pagination style="text-align: center;margin: 8px auto;"
                           @size-change="onPageSizeChange_fund"
                           @current-change="onPageIndexChange_fund"
                           :current-page="table.fundTable.entity.params.pageIndex"
                           :page-sizes="table.fundTable.entity.params.pageSizes"
                           :page-size="table.fundTable.entity.params.pageSize"
                           :total="table.fundTable.entity.params.total"
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
                fundOption: [],
                orgOption: []
            },
            //条件输入(选择)框(V-model绑定的值)：
            optionView: {
                fund: {
                    show: false,
                    fundType: ""
                },
                commonSelect: {
                    show: true,
                    institute: ""
                }
            },
            fullScreenLoading: false,
            urls: {
                fund: {
                    selectAllFundByPage: 'selectAllFundByPage',
                    deleteFundListByIds: 'deleteFundListByIds'
                }
            },
            //表格
            table: {
                fundTable: {
                    entity: {
                        data: [],
                        loading: false,
                        selectionList: [],
                        params: {
                            pageIndex: 1,
                            pageSize: 10,
                            pageSizes: [5, 10, 20, 40],
                            searchKey: '',  // 搜索词
                            total: 0       // 总数
                        }
                    }
                }
            },
            dialog: {},
            options: {}
        },
        methods: {
            //按页条件查询论文数据
            selectFundListByPage: function () {
                let app = this;
                let data = {
                    //筛选条件
                    institute: app.optionView.commonSelect.institute,
                    fundType: app.optionView.fund.fundType,
                    page: app.table.fundTable.entity.params                    //分页
                };
                app.table.fundTable.entity.loading = true;
                ajaxPostJSON(app.urls.fund.selectAllFundByPage, data, function (d) {
                    console.log(d.data.resultList);
                    app.table.fundTable.entity.loading = false;
                    app.table.fundTable.entity.data = d.data.resultList;
                    app.table.fundTable.entity.params.total = d.data.total;
                });
            },

            deleteFundListByIds: function (val) {
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
                ajaxPostJSON(this.urls.fund.deleteFundListByIds, data, function (d) {
                    app.fullScreenLoading = false;
                    window.parent.app.showMessage('删除成功！', 'success');
                    app.refreshTable_fund();
                })
            }).catch(() => {
                    window.parent.app.showMessage('已取消删除', 'warning');
            });
            },

            // 刷新entity table数据
            refreshTable_fund: function () {
                this.selectFundListByPage();
            },
            // 处理选中的行变化
            onSelectionChange_fund: function (val) {
                this.table.fundTable.selectionList = val;
            },
            // 处理pageSize变化
            onPageSizeChange_fund: function (newSize) {
                this.table.fundTable.entity.params.pageSize = newSize;
                this.refreshTable_fund();
            },
            // 处理pageIndex变化
            onPageIndexChange_fund: function (newIndex) {
                this.table.fundTable.entity.params.pageIndex = newIndex;
                this.refreshTable_fund();
            },

            //todo 没改
            //导出当前的所有的论文数据
            exportFundList: function () {
                window.parent.app.$confirm('确认导出当前条件下的所有基金', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(() => {
                    let app = this;
                let data = {
                    //筛选条件
                    type: app.optionView.fund.fundType,
                    institute: app.optionView.commonSelect.institute,

                };

                window.location.href = "/api/doc/fund/exportFundList?" +
                    "type=" + data.type +
                    "&institute=" + data.institute

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
        /*初始化学校机构*/
        let org = ${orgList};
        for (let i = 0; i < org.length; i++) {
            let tmpOrg = {
                value: org[i],
                label: org[i]
            };
            app.optionValue.orgOption.push(tmpOrg);
        }

        /*初始化基金类型*/
        ajaxPostJSON("/api/doc/statistic/getFundTypeList", null, function (result) {
            (result.data).forEach(function (v) {
                let tmpFund = {
                    value: v,
                    label: v
                };
                app.optionValue.fundOption.push(tmpFund);
            })
        });

        app.selectFundListByPage();
    }

    //初始化页面接收初始参数
    window.onload = function () {
        app.optionView.commonSelect.institute = '${institute}';
        app.optionView.fund.fundType = '${fundType}';
        initialize();
    };
</script>
</body>
</html>
