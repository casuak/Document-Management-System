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
            <div style="margin-top: 10px">
                <template>
                    <el-checkbox :indeterminate="doc.isIndeterminate" v-model="doc.checkAll"
                                 style="float: left;margin-right: 10px"
                                 @change="handleCheckAllChange">全选
                    </el-checkbox>
                    <el-checkbox-group v-model="doc.checkedDoc" @change="handleCheckedDocsChange">
                        <el-checkbox :label="doc.docType.paper" :key="doc.docType.paper"></el-checkbox>
                        <el-checkbox :label="doc.docType.patent" :key="doc.docType.patent"></el-checkbox>
                        <el-checkbox :label="doc.docType.copyright" :key="doc.docType.copyright"></el-checkbox>
                    </el-checkbox-group>
                </template>
            </div>
            <hr style="width: 100%;margin: 10px auto;"/>
            <%--搜索选项部分--%>
            <div id="commonBox" class="tmp" v-show="optionView.commonSelect.show">
                <row>
                    <span class="selectText">
                        <el-tag>公共筛选项</el-tag>
                    </span>
                    <div class="commonInputSection">
                        <span class="inputSpanText">作者身份: </span>
                        <div class="commonInput">
                            <el-select v-model="optionView.commonSelect.authorIdentity"
                                       filterable
                                       clearable
                                       placeholder="选择作者身份">
                                <el-option
                                        v-for="item in optionValue.authorIdentityOption"
                                        :key="item.value"
                                        :label="item.label"
                                        :value="item.value">
                                </el-option>
                            </el-select>
                        </div>
                    </div>
                    <div class="commonInputSection">
                        <span class="inputSpanText">作者工号: </span>
                        <div class="commonInput">
                            <el-input
                                    placeholder="输入作者工号"
                                    v-model="optionView.commonSelect.authorWorkNum"
                                    clearable>
                            </el-input>
                        </div>
                    </div>
                    <div class="commonInputSection">
                        <span class="inputSpanText">所属学科: </span>
                        <div class="commonInput">
                            <el-select v-model="optionView.commonSelect.authorSubject"
                                       filterable
                                       clearable
                                       placeholder="选择所属学科">
                                <el-option
                                        v-for="item in optionValue.authorSubjectOption"
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
                                    end-placeholder="结束日期"
                                    :picker-options="optionView.commonSelect.pickerOptions">
                            </el-date-picker>
                        </div>
                    </div>
                </row>
            </div>

            <div id="paperBox" class="tmp" v-show="optionView.paper.show">
                <row>
                    <span class="selectText">
                        <el-tag type="danger">论文筛选项</el-tag>
                    </span>
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
                                    v-model="optionView.paper.firstAuthorWorkNum"
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
                                    v-model="optionView.paper.secondAuthorWorkNum"
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
                                    v-model="optionView.paper.otherAuthorWorkNum"
                                    clearable>
                            </el-input>
                        </div>
                    </div>
                </row>

                <row style="margin-top: 10px">
                    <%--paper-期刊号--%>
                    <div class="commonInputSection" style="margin-left: 145px">
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
                </row>
            </div>

            <div id="patentBox" class="tmp" v-show="optionView.patent.show">
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
                <el-button type="primary" size="medium" @click="selectAllDoc()">统计搜索</el-button>
                <el-button type="danger" size="medium" @click="selectPaperListByPage('post')">论文搜索</el-button>
                <el-button type="warning" size="medium" @click="">专利搜索</el-button>
                <el-button type="success" size="medium" @click="">著作权搜索</el-button>
            </row>
        </el-header>

        <hr style="width: 97%;margin: 10px auto;"/>

        <el-main style="margin-top: -35px">
            <%--common列表--%>
            <div v-show="optionView.commonSelect.show">
                <%-- entity表格 --%>
                <el-table :data="table.commonTable.data"
                          :header-cell-style="{background:'rgb(217, 236, 255)',color:'#555'}"
                <%--max-height="500"--%>
                          height="calc(100% - 116px)"
                          v-loading="table.commonTable.loading"
                          style="width: 100%;overflow-y: hidden;margin-top: 20px;"
                          class="scroll-bar"
                <%--@selection-change="onSelectionChange_entity"--%>
                          stripe>
                    <el-table-column type="selection" width="40">
                    </el-table-column>
                    <el-table-column
                            type="index"
                            label="序号"
                            width="60px">
                    </el-table-column>
                    <%--                    <el-table-column--%>
                    <%--                            prop="docName"--%>
                    <%--                            label="文献名">--%>
                    <%--                    </el-table-column>--%>
                    <el-table-column
                            prop="docType"
                            label="文献类型">
                    </el-table-column>
                    <el-table-column
                            prop="totalDocAmount"
                            label="文献总数目">
                    </el-table-column>
                    <el-table-column
                            prop="teacherDocAmount"
                            label="教师文献数目">
                    </el-table-column>
                    <el-table-column
                            prop="studentDocAmount"
                            label="学生文献数目">
                    </el-table-column>
                    <el-table-column
                            prop="pubDate"
                            label="出版时间">
                    </el-table-column>
                    <el-table-column label="操作" width="190" header-align="center" align="center">
                        <template slot-scope="scope">
                            <el-button type="primary" size="mini" style="position:relative;bottom: 1px;"
                                       @click="openDialog_updateEntity(scope.row)"
                            >
                                <span>查看统计详情</span>
                            </el-button>
                        </template>
                    </el-table-column>
                    <el-table-column width="50"></el-table-column>
                </el-table>
                <%-- entity分页 --%>
                <%--<el-pagination style="text-align: center;margin: 8px auto;"
                               @size-change="onPageSizeChange_entity"
                               @current-change="onPageIndexChange_entity"
                               :current-page="table.commonTable.params.pageIndex"
                               :page-sizes="table.commonTable.params.pageSizes"
                               :page-size="table.commonTable.params.pageSize"
                               :total="table.commonTable.params.total"
                               layout="total, sizes, prev, pager, next, jumper">
                </el-pagination>--%>
            </div>

            <%--paper列表--%>
            <div v-show="optionView.paper.show">
                <el-table :data="table.paperTable.data"
                          highlight-current-row
                          max-height="500"
                          :header-cell-style="{background:'rgb(254, 240, 240)',color:'#555'}"
                          v-loading="table.paperTable.loading"
                          style="width: 100%;overflow-y: hidden;margin-top: 20px;"
                          class="scroll-bar"
                <%--@selection-change="onSelectionChange_entity"--%>
                          stripe>
                    <el-table-column type="selection" width="50">
                    </el-table-column>
                    <el-table-column
                            type="index"
                            label="序号"
                            width="60px">
                    </el-table-column>
                    <el-table-column
                            prop="paperName"
                            label="论文名"
                            width="300px">
                    </el-table-column>
                    <el-table-column
                            prop="docType"
                            label="论文种类">
                    </el-table-column>
                    <el-table-column
                            prop="issn"
                            label="期刊号">
                    </el-table-column>
                    <el-table-column
                            prop="storeNum"
                            label="入藏号">
                    </el-table-column>
                    <el-table-column
                            prop="firstAuthorName"
                            label="第一作者">
                    </el-table-column>
                    <el-table-column
                            prop="secondAuthorName"
                            label="第二作者">
                    </el-table-column>
                    <el-table-column label="操作" width="190" header-align="center" align="center">
                        <template slot-scope="scope">
                            <el-button type="primary" size="mini" style="position:relative;bottom: 1px;"
                                       @click="viewDocDetails(scope.row)"
                            >
                                <span>查看</span>
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

                <%-- 分页 --%>
                <el-pagination style="text-align: center;margin: 8px auto;"
                               @size-change="onPageSizeChange_paper"
                               @current-change="onPageIndexChange_paper"
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
                <el-table :data="table.patentTable.data"
                          :header-cell-style="{background:'rgb(253, 246, 236)',color:'#555'}"
                          max-height="500"
                          v-loading="table.patentTable.loading"
                          style="width: 100%;overflow-y: hidden;margin-top: 20px;" c
                          lass="scroll-bar"
                <%--@selection-change="onSelectionChange_entity"--%>
                          stripe>
                    <el-table-column type="selection" width="40"></el-table-column>
                    <el-table-column
                            type="index"
                            label="序号"
                            width="50">
                    </el-table-column>
                    <el-table-column
                            prop="applicationNum"
                            label="专利申请号"
                            width="180">
                    </el-table-column>
                    <el-table-column
                            prop="publicNum"
                            label="专利公开号"
                            width="180">
                    </el-table-column>
                    <el-table-column
                            prop="countryCode"
                            label="专利国别码"
                            width="180">
                    </el-table-column>
                    <el-table-column
                            prop="countryCode"
                            label="tmp">
                    </el-table-column>
                    <el-table-column label="操作" width="190" header-align="center" align="center">
                        <template slot-scope="scope">
                            <el-button type="primary" size="mini" style="position:relative;bottom: 1px;"
                                       @click="viewDocDetails(scope.row)"
                            >
                                <span>查看</span>
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
                               :current-page="table.patentTable.params.pageIndex"
                               :page-sizes="table.patentTable.params.pageSizes"
                               :page-size="table.patentTable.params.pageSize"
                               :total="table.patentTable.params.total"
                               layout="total, sizes, prev, pager, next, jumper">
                </el-pagination>
            </div>

            <%--copyr列表--%>
            <div v-show="optionView.copyright.show">
                <%-- entity表格 --%>
                <el-table :data="table.copyrightTable.data"
                          :header-cell-style="{background:'rgb(240, 249, 235)',color:'#555'}"
                          max-height="500"
                          v-loading="table.copyrightTable.loading"
                          style="width: 100%;overflow-y: hidden;margin-top: 20px;"
                          class="scroll-bar"
                <%--@selection-change="onSelectionChange_entity"--%>
                          stripe>
                    <el-table-column type="selection" width="40"></el-table-column>
                    <el-table-column
                            type="index"
                            label="序号"
                            width="50">
                    </el-table-column>
                    <el-table-column
                            prop="copySubject"
                            label="版权主体"
                            width="180">
                    </el-table-column>
                    <el-table-column
                            prop="copyType"
                            label="版权类型"
                            width="180">
                    </el-table-column>
                    <el-table-column
                            prop="tmp"
                            label="tmp">
                    </el-table-column>
                    <el-table-column label="操作" width="190" header-align="center" align="center">
                        <template slot-scope="scope">
                            <el-button type="primary" size="mini" style="position:relative;bottom: 1px;"
                            <%--@click="openDialog_updateEntity(scope.row)"--%>
                            >
                                <span>查看</span>
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
                               :current-page="table.copyrightTable.params.pageIndex"
                               :page-sizes="table.copyrightTable.params.pageSizes"
                               :page-size="table.copyrightTable.params.pageSize"
                               :total="table.copyrightTable.params.total"
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
                authorIdentityOption: [
                    {
                        label: "教师",
                        value: "teacher"
                    },
                    {
                        label: "学生",
                        value: "student"
                    }
                ],
                authorSubjectOption: [
                    {
                        label: "哲学",
                        value: "philosophy"
                    },
                    {
                        label: "经济学",
                        value: "economics"
                    },
                    {
                        label: "法学",
                        value: "law"
                    },
                    {
                        label: "教育学",
                        value: "education"
                    },
                    {
                        label: "文学",
                        value: "literature"
                    },
                    {
                        label: "历史学",
                        value: "history"
                    },
                    {
                        label: "理学",
                        value: "science"
                    },
                    {
                        label: "工学",
                        value: "engineering"
                    },
                    {
                        label: "农学",
                        value: "agronomy"
                    },
                    {
                        label: "医学",
                        value: "medicine"
                    },
                    {
                        label: "军事学",
                        value: "military"
                    },
                    {
                        label: "管理学",
                        value: "management"
                    },
                ]
            },
            //条件输入(选择)框(V-model绑定的值)：
            optionView: {
                paper: {
                    show: false,
                    paperName: "",
                    firstAuthorWorkNum: "",
                    secondAuthorWorkNum: "",
                    otherAuthorWorkNum: "",
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
                    authorIdentity: "",
                    authorWorkNum: "",
                    publishDate: "",
                    authorSubject: "",
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
                }
            },
            fullScreenLoading: false,
            //表格
            table: {
                paperTable: {
                    urls: {
                        // insertEntity: '/api/doc/search/insert',
                        // deleteEntityListByIds: '/api/doc/search/deleteListByIds',
                        // updateEntity: '/api/doc/search/update',
                        // selectPaperListByPage: '/api/doc/search/selectListByPage',
                    },
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
                    data: [
                        {
                            docType: "论文",
                            totalDocAmount: 100,
                            teacherDocAmount: 100,
                            studentDocAmount: 100,
                            pubDate: "2019-04-10"
                        },
                        {
                            docType: "专利",
                            totalDocAmount: 100,
                            teacherDocAmount: 100,
                            studentDocAmount: 100,
                            pubDate: "2019-04-10"
                        },
                        {
                            docType: "著作权",
                            totalDocAmount: 100,
                            teacherDocAmount: 100,
                            studentDocAmount: 100,
                            pubDate: "2019-04-10"
                        }
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

            //查看详情
            openDialog_updateEntity: function (row) {
                let data = {
                    paperName: app.optionView.paper.paperName,
                    firstAuthorName: app.optionView.paper.firstAuthorWorkNum,            //其实是FA工号
                    secondAuthorName: app.optionView.paper.secondAuthorWorkNum,          //其实是SA工号
                    authorList: app.optionView.paper.otherAuthorWorkNum,                 //其实是OA工号
                    storeNum: app.optionView.paper.storeNum,
                    docType: app.optionView.paper.paperType,
                    ISSN: app.optionView.paper.journalNum,
                    pageIndex: app.table.paperTable.params.pageIndex,
                    pageSize: app.table.paperTable.params.pageSize
                };
                let getParam = formatParams(data);
                let getLink = "/api/doc/search/selectPaperListByPageGet?" + getParam;
                console.log(getLink)
                window.parent.app.addTab("论文", getLink);
                /* let title;
                 if (row.docType === "论文") {
                     title = "论文";
                     window.parent.app.addTab("title",)

                 } else if (row.docType === "专利") {
                     title = "专利";
                 } else {
                     title = "著作权";
                 }
                 window.parent.app.addTab("title", "api/doc/search/selectPaperListByPage")*/
            },

            /*paper_table函数*/
            insertPaper: function () {

            },
            deletePaperListByIds: function () {

            },
            updatePaper: function () {

            },
            selectPaperListByPage: function (requestType) {
                //formatParams
                let data = {
                    paperName: app.optionView.paper.paperName,
                    firstAuthorName: app.optionView.paper.firstAuthorWorkNum,            //其实是FA工号
                    secondAuthorName: app.optionView.paper.secondAuthorWorkNum,          //其实是SA工号
                    authorList: app.optionView.paper.otherAuthorWorkNum,                 //其实是OA工号
                    storeNum: app.optionView.paper.storeNum,
                    docType: app.optionView.paper.paperType,
                    ISSN: app.optionView.paper.journalNum,
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
            // 刷新entity table数据
            refreshTable_paper: function () {
                console.log("刷新entity table数据");
                app.selectPaperListByPage();
            },
            // 处理选中的行变化
            onSelectionChange_paper: function (val) {
                this.table.paperTable.selectionList = val;
            },
            // 处理pageSize变化
            onPageSizeChange_paper: function (newSize) {
                console.log("处理pageSize变化");
                app.table.paperTable.params.pageSize = newSize;
                app.refreshTable_paper();
            },
            // 处理pageIndex变化
            onPageIndexChange_paper: function (newIndex) {
                console.log("处理pageIndex变化");
                app.table.paperTable.params.pageIndex = newIndex;
                app.refreshTable_paper();
            },
            // 重置表单
            // resetForm: function (ref) {
            //     this.$refs[ref].resetFields();
            // },

            /*patent_table函数*/
            selectPatentListByPage: function () {
                console.log("selectPatentListByPage()");
            },

            /*copyright_table函数*/
            selectCopyrightListByPage: function () {
                console.log("selectCopyrightListByPage()");
            },

            /*common_table函数*/
            selectDocListByPage: function () {
                app.table.commonTable.loading = true;
                console.log("selectDocListByPage()");
                app.table.commonTable.loading = false;

            },

            /*全部搜索*/
            selectAllDoc: function () {
                let paperIndex = $.inArray('论文', app.doc.checkedDoc);
                let patentIndex = $.inArray('专利', app.doc.checkedDoc);
                let copyrightIndex = $.inArray('著作权', app.doc.checkedDoc);

                /*全部未选中则是统一显示在commonTable中*/
                if (paperIndex === -1 && patentIndex === -1 && copyrightIndex === -1) {
                    console.log("commonTable Search");
                    app.selectDocListByPage();
                }

                if (paperIndex !== -1) {
                    app.selectPaperListByPage();
                }
                if (patentIndex !== -1) {
                    app.selectPatentListByPage();
                }
                if (copyrightIndex !== -1) {
                    app.selectCopyrightListByPage();
                }
            },

            /*查看文献详情：*/
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
        for (let i = 0; i < tmp.length; i++) {
            let tmpItem = {
                value: tmp[i].id,
                label: tmp[i].name_cn
            };
            console.log(tmpItem);
            app.optionValue.paperTypeOption.push(tmpItem);
        }
    }

    window.onload = function () {
        app.selectPaperListByPage();
        initialize();
    };

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
            firstAuthorWorkNum: app.optionView.paper.firstAuthorWorkNum,
            secondAuthorWorkNum: app.optionView.paper.secondAuthorWorkNum,
            otherAuthorWorkNum: app.optionView.paper.otherAuthorWorkNum,
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

        ajaxPost("/api/doc/search/getDocList", conditionParam,
            function success(res) {
                console.log("success " + res);
            },
            function error(res) {
                console.log("error " + res)
            }
        )

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
</script>
</body>
</html>