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
            margin-top: 0px;
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
        .el-tabs__content{
            height: 95%;
        }
        .el-tab-pane{
            height: 100%;
        }
        .el-container{
            height: 100%;
        }
    </style>
</head>
<body>
<div id="app" v-cloak style="background: white;height: 100%;">

    <el-tabs v-model="activeName" @tab-click="handleTabClick" style="margin-left:5px;margin-top:5px;height: 100%;" type="border-card">
        <el-tab-pane id="first" label="导师统计" name="first" >
            <el-container >
                <el-header height="auto">
                    <%--搜索选项部分--%>
                    <div id="commonBox" class="tmp" v-show="optionView.commonSelect.show">
                        <row>
                            <div class="commonInputSection">
                                <span class="inputSpanText">姓名: </span>
                                <div class="commonInput">
                                    <el-input
                                            placeholder="输入导师姓名"
                                            v-model="optionView.commonSelect.realName"
                                            clearable>
                                    </el-input>
                                </div>
                            </div>
                            <div class="commonInputSection">
                                <span class="inputSpanText">导师工号: </span>
                                <div class="commonInput">
                                    <el-input
                                            placeholder="输入导师工号"
                                            v-model="optionView.commonSelect.workId"
                                            clearable>
                                    </el-input>
                                </div>
                            </div>


                            <div class="commonInputSection">
                                <span class="inputSpanText">导师类型: </span>
                                <div class="commonInput">
                                    <el-select v-model="optionView.commonSelect.type"
                                               filterable
                                               clearable
                                               placeholder="选择导师类型">
                                        <el-option
                                                v-for="item in optionValue.typeOption"
                                                :key="item.value"
                                                :label="item.label"
                                                :value="item.value">
                                        </el-option>
                                    </el-select>
                                </div>
                            </div>

                        </row>
                        <row>
                            <div class="commonInputSection">
                                <span class="inputSpanText">一级学科: </span>
                                <div class="commonInput">
                                    <el-select v-model="optionView.commonSelect.major"
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
                                    <el-select v-model="optionView.commonSelect.school"
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
                            <div class="commonInputSection" style="margin-top: 5px;margin-left: 20px">
                                <el-button type="primary" size="small" @click="searchClick">查询导师
                                </el-button>
                                <el-button type="danger" size="small" style="margin-left: 20px"
                                           @click="exportStatisticResult()">导出结果
                                </el-button>
                            </div>

                        </row>
                    </div>

                    <hr style="width: 100%;margin: 10px auto;"/>
                </el-header>

                <el-main style="padding: 0;" >
                    <%--作者查询列表--%>
                    <div style="height: 100%;overflow: hidden;margin-top: 0">
                        <el-table :data="table.authorTable.data"
                                  :header-cell-style="{background:'rgb(0, 124, 196)',color:'#fff'}"
                                  height="calc(100% - 45px)"
                                  v-loading="table.authorTable.loading"
                                  class="scroll-bar"
                                  @sort-change='sortChange'
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
                            </el-table-column>     <el-table-column
                                prop="school"
                                header-align="center"
                                align="center"
                                width="195"
                                fixed="left"
                                label="管理所在学院">
                        </el-table-column>
                            <el-table-column
                                    prop="realName"
                                    header-align="center"
                                    align="center"
                                    fixed="left"
                                    width="130"
                                    fixed="left"
                                    show-overflow-tooltip
                                    label="姓名">
                            </el-table-column>
                            <el-table-column
                                    prop="major"
                                    header-align="center"
                                    align="center"
                                    fixed="left"
                                    width="195"
                                    label="学科一">
                            </el-table-column>
                            <el-table-column
                                    prop="workId"
                                    header-align="center"
                                    align="center"
                                    width="150"
                                    fixed="left"
                                    label="工号">
                            </el-table-column>
                            <el-table-column
                                    header-align="center"
                                    align="center"
                                    label="SCI/SSCI发文量">
                                <el-table-column
                                        header-align="center"
                                        align="center"
                                        label="导师">
                                    <el-table-column
                                            prop="tutorPaperSum"
                                            header-align="center"
                                            align="center"
                                            width="75"
                                            sortable='custom'
                                            label="总计">
                                    </el-table-column>
                                    <el-table-column
                                            prop="tutorQ1"
                                            header-align="center"
                                            align="center"
                                            width="50"
                                            label="Q1">
                                    </el-table-column>
                                    <el-table-column
                                            prop="tutorQ2"
                                            header-align="center"
                                            align="center"
                                            width="50"
                                            label="Q2">
                                    </el-table-column>
                                    <el-table-column
                                            prop="tutorQ3"
                                            header-align="center"
                                            align="center"
                                            width="50"
                                            label="Q3">
                                    </el-table-column>
                                    <el-table-column
                                            prop="tutorQ4"
                                            header-align="center"
                                            align="center"
                                            width="50"
                                            label="Q4">
                                    </el-table-column>



                                </el-table-column>
                                <el-table-column
                                        header-align="center"
                                        align="center"
                                        label="学生">
                                    <el-table-column
                                            prop="stuPaperSum"
                                            header-align="center"
                                            align="center"
                                            width="75"
                                            sortable='custom'
                                            label="合计">
                                    </el-table-column>
                                    <el-table-column
                                            prop="stuQ1"
                                            header-align="center"
                                            align="center"
                                            width="50"
                                            label="Q1">
                                    </el-table-column>
                                    <el-table-column
                                            prop="stuQ2"
                                            header-align="center"
                                            align="center"
                                            width="50"
                                            label="Q2">
                                    </el-table-column>
                                    <el-table-column
                                            prop="stuQ3"
                                            header-align="center"
                                            align="center"
                                            width="50"
                                            label="Q3">
                                    </el-table-column>
                                    <el-table-column
                                            prop="stuQ4"
                                            header-align="center"
                                            align="center"
                                            width="50"
                                            label="Q4">
                                    </el-table-column>



                                </el-table-column>
                            </el-table-column>
                            <el-table-column
                                    header-align="center"
                                    align="center"
                                    label="发明专利数">
                                <el-table-column
                                        prop="tutorPatent"
                                        header-align="center"
                                        align="center"
                                        width="75"
                                        sortable='custom'
                                        label="导师">
                                </el-table-column>
                                <el-table-column
                                        prop="stuPatent"
                                        header-align="center"
                                        align="center"
                                        width="75"
                                        sortable='custom'
                                        label="学生">
                                </el-table-column>
                            </el-table-column>
                            <el-table-column
                                    header-align="center"
                                    align="center"
                                    label="基金项目数">
                                <el-table-column
                                        prop="fundSum"
                                        header-align="center"
                                        align="center"
                                        width="150"
                                        sortable='custom'
                                        label="合计">
                                </el-table-column>
                                <el-table-column
                                        prop="nationFocus"
                                        header-align="center"
                                        align="center"
                                        width="150"
                                        label="国家重点研发计划">
                                </el-table-column>
                                <el-table-column
                                        prop="nsfcZDYF"
                                        header-align="center"
                                        align="center"
                                        width="150"
                                        label="NSFC重大研发计划">
                                </el-table-column>
                                <el-table-column
                                        prop="nationInstrument"
                                        header-align="center"
                                        align="center"
                                        width="150"
                                        label="国家重大科研仪器研制项目">
                                </el-table-column>
                                <el-table-column
                                        prop="nsfcKXZX"
                                        header-align="center"
                                        align="center"
                                        width="150"
                                        label="NSFC科学中心项目">
                                </el-table-column>
                                <el-table-column
                                        prop="nsfcZDAXM"
                                        header-align="center"
                                        align="center"
                                        width="150"
                                        label="NSFC重大项目">
                                </el-table-column>

                                <el-table-column
                                        prop="nationResearch"
                                        header-align="center"
                                        align="center"
                                        width="200"
                                        label=" 国际（地区）合作研究与交流项目">
                                </el-table-column>
                                <el-table-column
                                        prop="nsfcZDIANXM"
                                        header-align="center"
                                        align="center"
                                        width="150"
                                        label="NSFC重点项目">
                                </el-table-column>
                                <el-table-column
                                        prop="nsfcMSXM"
                                        header-align="center"
                                        align="center"
                                        width="150"
                                        label="NSFC面上项目">
                                </el-table-column>
                                <el-table-column
                                        prop="nsfcQNXM"
                                        header-align="center"
                                        align="center"
                                        width="150"
                                        label="NSFC青年项目">
                                </el-table-column>
                                <el-table-column
                                        prop="nsfcZDAXM"
                                        header-align="center"
                                        align="center"
                                        width="150"
                                        label="NSSFC重大项目">
                                </el-table-column>
                                <el-table-column
                                        prop="nsfcZDIANXM"
                                        header-align="center"
                                        align="center"
                                        width="150"
                                        label="NSSFC重点项目">
                                </el-table-column>
                                <el-table-column
                                        prop="nssfcYBXM"
                                        header-align="center"
                                        align="center"
                                        width="150"
                                        label="NSSFC一般项目">
                                </el-table-column>
                                <el-table-column
                                        prop="nssfcQNXM"
                                        header-align="center"
                                        align="center"
                                        width="150"
                                        label="NSSFC青年项目">
                                </el-table-column>
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
            </el-container >
        </el-tab-pane>
        <el-tab-pane id="second" label="按学院统计" name="second">
            <el-header height="auto">
                <%--搜索选项部分--%>
                <div id="commonBox" class="tmp" v-show="optionView.commonSelect.show">
                    <row>
                        <div class="commonInputSection">
                            <span class="inputSpanText">学院 </span>
                            <div class="commonInput">
                                <el-select v-model="optionView.school.school"
                                           filterable
                                           clearable
                                           placeholder="选择学院">
                                    <el-option
                                            v-for="item in optionValue.orgOption"
                                            :key="item.value"
                                            :label="item.label"
                                            :value="item.value">
                                    </el-option>
                                </el-select>
                            </div>
                        </div>
                        <div class="commonInputSection" style="margin-top: 5px;margin-left: 20px">
                            <el-button type="primary" size="small" @click="searchSchoolClick">查询学院
                            </el-button>
                            <el-button type="danger" size="small" style="margin-left: 20px"
                                       @click="exportStatisticSchoolResult()">导出结果
                            </el-button>
                        </div>

                    </row>
                </div>

                <hr style="width: 100%;margin: 10px auto;"/>
            </el-header>
            <el-table :data="table.schoolTable.data"
                      :header-cell-style="{background:'rgb(0, 124, 196)',color:'#fff'}"
                      height="calc(100% - 135px)"
                      v-loading="table.schoolTable.loading"
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
                </el-table-column>     <el-table-column
                    prop="school"
                    header-align="center"
                    align="center"
                    width="195"
                    fixed="left"
                    label="学院">
            </el-table-column>
                <el-table-column
                        prop="totalNum"
                        header-align="center"
                        align="center"
                        width="150"
                        fixed="left"
                        label="导师人数">
                </el-table-column>
                <el-table-column
                        header-align="center"
                        align="center"
                        label="SCI/SSCI发文量">
                    <el-table-column
                            header-align="center"
                            align="center"
                            label="导师">
                        <el-table-column
                                prop="tutorPaperSum"
                                header-align="center"
                                align="center"
                                width="75"
                                label="总计">
                        </el-table-column>
                        <el-table-column
                                prop="tutorAverage"
                                header-align="center"
                                align="center"
                                width="75"
                                label="人均">
                        </el-table-column>
                        <el-table-column
                                prop="tutorQ1"
                                header-align="center"
                                align="center"
                                width="50"
                                label="Q1">
                        </el-table-column>
                        <el-table-column
                                prop="tutorQ2"
                                header-align="center"
                                align="center"
                                width="50"
                                label="Q2">
                        </el-table-column>
                        <el-table-column
                                prop="tutorQ3"
                                header-align="center"
                                align="center"
                                width="50"
                                label="Q3">
                        </el-table-column>
                        <el-table-column
                                prop="tutorQ4"
                                header-align="center"
                                align="center"
                                width="50"
                                label="Q4">
                        </el-table-column>

                    </el-table-column>
                    <el-table-column
                            header-align="center"
                            align="center"
                            label="学生">
                        <el-table-column
                                prop="stuPaperSum"
                                header-align="center"
                                align="center"
                                width="75"
                                label="合计">
                        </el-table-column>
                        <el-table-column
                                prop="stuAverage"
                                header-align="center"
                                align="center"
                                width="75"
                                label="人均">
                        </el-table-column>
                        <el-table-column
                                prop="stuQ1"
                                header-align="center"
                                align="center"
                                width="50"
                                label="Q1">
                        </el-table-column>
                        <el-table-column
                                prop="stuQ2"
                                header-align="center"
                                align="center"
                                width="50"
                                label="Q2">
                        </el-table-column>
                        <el-table-column
                                prop="stuQ3"
                                header-align="center"
                                align="center"
                                width="50"
                                label="Q3">
                        </el-table-column>
                        <el-table-column
                                prop="stuQ4"
                                header-align="center"
                                align="center"
                                width="50"
                                label="Q4">
                        </el-table-column>


                    </el-table-column>
                </el-table-column>
                <el-table-column
                        header-align="center"
                        align="center"
                        label="发明专利数">
                    <el-table-column
                            header-align="center"
                            align="center"
                            width="75"
                            label="导师">
                        <el-table-column
                                prop="tutorPatent"
                                header-align="center"
                                align="center"
                                width="75"
                                label="合计">
                        </el-table-column>
                    <el-table-column
                            prop="tutorPatentAverage"
                            header-align="center"
                            align="center"
                            width="75"
                            label="人均">
                    </el-table-column>
                    </el-table-column>
                    <el-table-column
                            header-align="center"
                            align="center"
                            width="75"
                            label="学生">
                        <el-table-column
                                prop="stuPatent"
                                header-align="center"
                                align="center"
                                width="75"
                                label="合计">
                        </el-table-column>
                            <el-table-column
                                    prop="stuPatentAverage"
                                    header-align="center"
                                    align="center"
                                    width="75"
                                    label="人均">
                    </el-table-column>
                </el-table-column>
                </el-table-column>
                <el-table-column
                        header-align="center"
                        align="center"
                        label="基金项目数">
                    <el-table-column
                            prop="fundSum"
                            header-align="center"
                            align="center"
                            width="150"
                            label="合计">
                    </el-table-column>
                    <el-table-column
                            prop="nationFocus"
                            header-align="center"
                            align="center"
                            width="150"
                            label="国家重点研发计划">
                    </el-table-column>
                    <el-table-column
                            prop="nsfcZDYF"
                            header-align="center"
                            align="center"
                            width="150"
                            label="NSFC重大研发计划">
                    </el-table-column>
                    <el-table-column
                            prop="nationInstrument"
                            header-align="center"
                            align="center"
                            width="150"
                            label="国家重大科研仪器研制项目">
                    </el-table-column>
                    <el-table-column
                            prop="nsfcKXZX"
                            header-align="center"
                            align="center"
                            width="150"
                            label="NSFC科学中心项目">
                    </el-table-column>
                    <el-table-column
                            prop="nsfcZDAXM"
                            header-align="center"
                            align="center"
                            width="150"
                            label="NSFC重大项目">
                    </el-table-column>

                    <el-table-column
                            prop="nationResearch"
                            header-align="center"
                            align="center"
                            width="200"
                            label=" 国际（地区）合作研究与交流项目">
                    </el-table-column>
                    <el-table-column
                            prop="nsfcZDIANXM"
                            header-align="center"
                            align="center"
                            width="150"
                            label="NSFC重点项目">
                    </el-table-column>
                    <el-table-column
                            prop="nsfcMSXM"
                            header-align="center"
                            align="center"
                            width="150"
                            label="NSFC面上项目">
                    </el-table-column>
                    <el-table-column
                            prop="nsfcQNXM"
                            header-align="center"
                            align="center"
                            width="150"
                            label="NSFC青年项目">
                    </el-table-column>
                    <el-table-column
                            prop="nsfcZDAXM"
                            header-align="center"
                            align="center"
                            width="150"
                            label="NSSFC重大项目">
                    </el-table-column>
                    <el-table-column
                            prop="nsfcZDIANXM"
                            header-align="center"
                            align="center"
                            width="150"
                            label="NSSFC重点项目">
                    </el-table-column>
                    <el-table-column
                            prop="nssfcYBXM"
                            header-align="center"
                            align="center"
                            width="150"
                            label="NSSFC一般项目">
                    </el-table-column>
                    <el-table-column
                            prop="nssfcQNXM"
                            header-align="center"
                            align="center"
                            width="150"
                            label="NSSFC青年项目">
                    </el-table-column>

                </el-table-column>
            </el-table>
            <el-pagination style="text-align: center;margin:0 auto;"
                           @size-change="schoolPageSizeChange"
                           @current-change="schoolPageIndexChange"
                           :current-page="table.schoolTable.params.pageIndex"
                           :page-sizes="table.schoolTable.params.pageSizes"
                           :page-size="table.schoolTable.params.pageSize"
                           :total="table.schoolTable.params.total"
                           layout="total, sizes, prev, pager, next, jumper">
            </el-pagination>
        </el-tab-pane>
        <el-tab-pane id="third" label="按学科统计" name="third">
            <el-header height="auto">
                <%--搜索选项部分--%>
                <div id="commonBox" class="tmp" v-show="optionView.commonSelect.show">
                    <row>
                        <div class="commonInputSection">
                            <span class="inputSpanText">一级学科: </span>
                            <div class="commonInput">
                                <el-select v-model="optionView.major.major"
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
                        <div class="commonInputSection" style="margin-top: 5px;margin-left: 20px">
                            <el-button type="primary" size="small" @click="searchMajorClick">查询学科
                            </el-button>
                            <el-button type="danger" size="small" style="margin-left: 20px"
                                       @click="exportStatisticMajorResult()">导出结果
                            </el-button>
                        </div>

                    </row>
                </div>

                <hr style="width: 100%;margin: 10px auto;"/>
            </el-header>
            <el-table :data="table.majorTable.data"
                      :header-cell-style="{background:'rgb(0, 124, 196)',color:'#fff'}"
                      height="calc(100% - 135px)"
                      v-loading="table.majorTable.loading"
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
                </el-table-column>     <el-table-column
                    prop="major"
                    header-align="center"
                    align="center"
                    width="195"
                    fixed="left"
                    label="学科">
            </el-table-column>
                <el-table-column
                        prop="totalNum"
                        header-align="center"
                        align="center"
                        width="150"
                        fixed="left"
                        label="导师人数">
                </el-table-column>
                <el-table-column
                        header-align="center"
                        align="center"
                        label="SCI/SSCI发文量">
                    <el-table-column
                            header-align="center"
                            align="center"
                            label="导师">
                        <el-table-column
                                prop="tutorPaperSum"
                                header-align="center"
                                align="center"
                                width="75"
                                label="合计">
                        </el-table-column>
                        <el-table-column
                                prop="tutorAverage"
                                header-align="center"
                                align="center"
                                width="75"
                                label="人均">
                        </el-table-column>
                        <el-table-column
                                prop="tutorQ1"
                                header-align="center"
                                align="center"
                                width="50"
                                label="Q1">
                        </el-table-column>
                        <el-table-column
                                prop="tutorQ2"
                                header-align="center"
                                align="center"
                                width="50"
                                label="Q2">
                        </el-table-column>
                        <el-table-column
                                prop="tutorQ3"
                                header-align="center"
                                align="center"
                                width="50"
                                label="Q3">
                        </el-table-column>
                        <el-table-column
                                prop="tutorQ4"
                                header-align="center"
                                align="center"
                                width="50"
                                label="Q4">
                        </el-table-column>

                    </el-table-column>
                    <el-table-column
                            header-align="center"
                            align="center"
                            label="学生">
                        <el-table-column
                                prop="stuPaperSum"
                                header-align="center"
                                align="center"
                                width="75"
                                label="合计">
                        </el-table-column>
                        <el-table-column
                                prop="stuAverage"
                                header-align="center"
                                align="center"
                                width="75"
                                label="人均">
                        </el-table-column>
                        <el-table-column
                                prop="stuQ1"
                                header-align="center"
                                align="center"
                                width="50"
                                label="Q1">
                        </el-table-column>
                        <el-table-column
                                prop="stuQ2"
                                header-align="center"
                                align="center"
                                width="50"
                                label="Q2">
                        </el-table-column>
                        <el-table-column
                                prop="stuQ3"
                                header-align="center"
                                align="center"
                                width="50"
                                label="Q3">
                        </el-table-column>
                        <el-table-column
                                prop="stuQ4"
                                header-align="center"
                                align="center"
                                width="50"
                                label="Q4">
                        </el-table-column>



                    </el-table-column>
                </el-table-column>
                <el-table-column
                        header-align="center"
                        align="center"
                        label="发明专利数">
                    <el-table-column
                            header-align="center"
                            align="center"
                            width="75"
                            label="导师">
                        <el-table-column
                                prop="tutorPatent"
                                header-align="center"
                                align="center"
                                width="75"
                                label="总计">
                        </el-table-column>
                        <el-table-column
                                prop="tutorPatentAverage"
                                header-align="center"
                                align="center"
                                width="75"
                                label="人均">
                        </el-table-column>
                    </el-table-column>
                    <el-table-column
                            header-align="center"
                            align="center"
                            width="75"
                            label="学生">
                        <el-table-column
                                prop="stuPatent"
                                header-align="center"
                                align="center"
                                width="75"
                                label="总计">
                        </el-table-column>
                        <el-table-column
                                prop="stuPatentAverage"
                                header-align="center"
                                align="center"
                                width="75"
                                label="人均">
                        </el-table-column>
                    </el-table-column>
                </el-table-column>
                <el-table-column
                        header-align="center"
                        align="center"
                        label="基金项目数">
                    <el-table-column
                            prop="fundSum"
                            header-align="center"
                            align="center"
                            width="150"
                            label="合计">
                    </el-table-column>
                    <el-table-column
                            prop="nationFocus"
                            header-align="center"
                            align="center"
                            width="150"
                            label="国家重点研发计划">
                    </el-table-column>
                    <el-table-column
                            prop="nsfcZDYF"
                            header-align="center"
                            align="center"
                            width="150"
                            label="NSFC重大研发计划">
                    </el-table-column>
                    <el-table-column
                            prop="nationInstrument"
                            header-align="center"
                            align="center"
                            width="150"
                            label="国家重大科研仪器研制项目">
                    </el-table-column>
                    <el-table-column
                            prop="nsfcKXZX"
                            header-align="center"
                            align="center"
                            width="150"
                            label="NSFC科学中心项目">
                    </el-table-column>
                    <el-table-column
                            prop="nsfcZDAXM"
                            header-align="center"
                            align="center"
                            width="150"
                            label="NSFC重大项目">
                    </el-table-column>

                    <el-table-column
                            prop="nationResearch"
                            header-align="center"
                            align="center"
                            width="200"
                            label=" 国际（地区）合作研究与交流项目">
                    </el-table-column>
                    <el-table-column
                            prop="nsfcZDIANXM"
                            header-align="center"
                            align="center"
                            width="150"
                            label="NSFC重点项目">
                    </el-table-column>
                    <el-table-column
                            prop="nsfcMSXM"
                            header-align="center"
                            align="center"
                            width="150"
                            label="NSFC面上项目">
                    </el-table-column>
                    <el-table-column
                            prop="nsfcQNXM"
                            header-align="center"
                            align="center"
                            width="150"
                            label="NSFC青年项目">
                    </el-table-column>
                    <el-table-column
                            prop="nsfcZDAXM"
                            header-align="center"
                            align="center"
                            width="150"
                            label="NSSFC重大项目">
                    </el-table-column>
                    <el-table-column
                            prop="nsfcZDIANXM"
                            header-align="center"
                            align="center"
                            width="150"
                            label="NSSFC重点项目">
                    </el-table-column>
                    <el-table-column
                            prop="nssfcYBXM"
                            header-align="center"
                            align="center"
                            width="150"
                            label="NSSFC一般项目">
                    </el-table-column>
                    <el-table-column
                            prop="nssfcQNXM"
                            header-align="center"
                            align="center"
                            width="150"
                            label="NSSFC青年项目">
                    </el-table-column>

                </el-table-column>
            </el-table>
            <el-pagination style="text-align: center;margin:0 auto;"
                           @size-change="majorPageSizeChange"
                           @current-change="majorPageIndexChange"
                           :current-page="table.majorTable.params.pageIndex"
                           :page-sizes="table.majorTable.params.pageSizes"
                           :page-size="table.majorTable.params.pageSize"
                           :total="table.majorTable.params.total"
                           layout="total, sizes, prev, pager, next, jumper">
            </el-pagination>


        </el-tab-pane>
    </el-tabs>

</div>


<%@include file="/WEB-INF/views/include/blankScript.jsp" %>
<script>
    const docOptions = ["论文", "专利", "著作权"];
    var app = new Vue({
        el: '#app',
        data: {
            activeName:"first",
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
                subjectOption: [],
                typeOption:[],
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
                },
                school:{
                    school:""
                },
                major:{
                    major:""
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
                schoolTable:{
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
                majorTable:{
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
            //当排序发生变化时
            sortChange:function(o){
                let column=o["column"];
                let prop=o["prop"];
                let order=o["order"];
                let app=this;
                let oorder="";
                let col="";
                console.log(column,prop,order);
                if(prop == null) {
                    app.table.authorTable.params.searchKey = "";
                }
                else{
                    if(order === "descending") {
                        oorder = "DESC"
                    }else{
                        oorder ="ASC"
                    }
                  switch (prop) {
                      case "tutorPaperSum":
                          col="tutor_paper_sum";
                          break;
                      case "stuPaperSum" :
                          col="stu_paper_sum";
                          break;
                      case "tutorPatent":
                          col="tutor_patent";
                          break;
                      case "stuPatent":
                          col="stu_patent";
                          break;
                      case "fundSum":
                          col = "fund_sum";
                          break;
                  }
                    app.table.authorTable.params.searchKey=col+" "+oorder;

                }
                console.log( app.table.authorTable.params.searchKey);
                authorSearch();
            },
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
                        pageSize: app.table.paperTable.params.pageSize,
                        type:app.optionView.paper.type
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
            schoolPageSizeChange: function (newSize) {
                console.log("处理pageSize变化");
                app.table.schoolTable.params.pageSize = newSize;
                schoolSearch();
            },
            // 处理pageIndex变化
            schoolPageIndexChange: function (newIndex) {
                console.log("处理pageIndex变化");
                app.table.schoolTable.params.pageIndex = newIndex;
                schoolSearch();
            },
            majorPageSizeChange: function (newSize) {
                console.log("处理pageSize变化");
                app.table.majorTable.params.pageSize = newSize;
                majorSearch();
            },
            // 处理pageIndex变化
            majorPageIndexChange: function (newIndex) {
                console.log("处理pageIndex变化");
                app.table.majorTable.params.pageIndex = newIndex;
                majorSearch();
            },

            // 重置表单
            // resetForm: function (ref) {
            //     this.$refs[ref].resetFields();
            // },
            exportStatisticResult() {
                let app = this;
                window.location.href = "/author/exportStatisticsList?" +
                    "realName=" + app.optionView.commonSelect.realName +
                    "&workId=" + app.optionView.commonSelect.workId +
                    "&school=" + app.optionView.commonSelect.school+
                    "&major=" +app.optionView.commonSelect.major+
                        "&type=" +app.optionView.commonSelect.type
            },
            exportStatisticMajorResult() {
                let app = this;
                window.location.href = "/author/exportStatisticsMajorList?" +
                    "&major=" + app.optionView.major.major
            },
            exportStatisticSchoolResult() {
                let app = this;
                window.location.href = "/author/exportStatisticsSchoolList?" +
                    "&school=" + app.optionView.school.school
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
            handleTabClick(tab, event) {
                console.log(event.target.getAttribute('id'));
                let tabL  = event.target.getAttribute('id');
                if(tabL ==="tab-first"){
                    authorSearch();
                }else if(tabL ==="tab-second"){
                    schoolSearch();
                }else if(tabL ==="tab-third"){
                    majorSearch();
                }
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
    function  searchSchoolClick() {
        app.table.schoolTable.params = {
            pageIndex: 1,
            pageSize: app.table.authorTable.params.pageSize,
            pageSizes: [5, 10, 20, 40],
            searchKey: app.optionView.school.school,
            total: 100,
        };
        console.log(app.table.schoolTable.params);
        schoolSearch();
    }
    function searchMajorClick() {
        app.table.majorTable.params = {
            pageIndex: 1,
            pageSize: app.table.authorTable.params.pageSize,
            pageSizes: [5, 10, 20, 40],
            searchKey: app.optionView.major.major,
            total: 100,
        };
        majorSearch();
    }
    

    /*执行作者查询*/
    function authorSearch() {
        app.table.authorTable.loading = true;
        let author = {
            //待查作者的真实姓名
            realName: app.optionView.commonSelect.realName,
            //待查作者工号
            workId: app.optionView.commonSelect.workId,
            //待查作者学科名
            major: app.optionView.commonSelect.major,
            //待查作者机构名称
            school: app.optionView.commonSelect.school,

            type:app.optionView.commonSelect.type,
            //分页信息
            page: app.table.authorTable.params,
        };
        setTimeout(function () {
            ajaxPostJSON("/author/getAuthorStatisticsByPage", author,
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

    /*执行作者查询*/
    function schoolSearch() {
        app.table.schoolTable.loading = true;
        let author = {
            //待查作者的真实姓名
            realName: app.optionView.commonSelect.realName,
            //待查作者工号
            workId: app.optionView.commonSelect.workId,
            //待查作者学科名
            major: app.optionView.commonSelect.major,
            //待查作者机构名称
            school: app.optionView.commonSelect.school,
            type:app.optionView.commonSelect.type,
            //分页信息
            page: app.table.schoolTable.params,
        };
        setTimeout(function () {
            ajaxPostJSON("/author/getAuthorStatisticsBySchool", author,
                function success(res) {
                    if (res.code === 'success') {
                        console.log(res.data.resultList);
                        app.table.schoolTable.data = res.data.resultList;
                        app.table.schoolTable.params.total = res.data.total;
                        app.table.schoolTable.loading = false;
                    }
                }, null, false
            );
        }, 200)
    }
    /*执行作者查询*/
    function majorSearch() {
        app.table.majorTable.loading = true;
        let author = {
            //待查作者的真实姓名
            realName: app.optionView.commonSelect.realName,
            //待查作者工号
            workId: app.optionView.commonSelect.workId,
            //待查作者学科名
            major: app.optionView.commonSelect.major,
            //待查作者机构名称
            school: app.optionView.commonSelect.school,

            type:app.optionView.commonSelect.type,
            //分页信息
            page: app.table.majorTable.params,
        };
        setTimeout(function () {
            ajaxPostJSON("/author/getAuthorStatisticsByMajor", author,
                function success(res) {
                    if (res.code === 'success') {
                        console.log(res.data.resultList);
                        app.table.majorTable.data = res.data.resultList;
                        app.table.majorTable.params.total = res.data.total;
                        app.table.majorTable.loading = false;
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

        /*初始化类型*/
        app.optionValue.typeOption.push({
            value:"硕士生导师",
            label:"硕士生导师"
        });

        app.optionValue.typeOption.push({
            value:"博士生导师",
            label:"博士生导师"
        });
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

</script>

<%--<script src="/static/js/functions/doc/docSearch.js"></script>--%>
</body>
</html>