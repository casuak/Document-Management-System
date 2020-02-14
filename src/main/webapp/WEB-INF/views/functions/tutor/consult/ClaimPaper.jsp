<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>论文认领</title>
    <%@include file="/WEB-INF/views/include/blankHead.jsp" %>
    <link rel="stylesheet" href="/static/css/functions/tutor/ClaimPaper.css"/>
    <style>
        .row-expand-cover .el-table__expand-column .el-icon{
            visibility:hidden;
            pointer-events: none;
        }
        .row-expand-cover .el-table__expand-column{
            pointer-events: none;
        }
    </style>
</head>
<body>
<div id="app" v-cloak style="background: white;height: 100%;overflow: hidden;" v-loading="fullScreenLoading">
    <%-- 顶栏 --%>
    <div style="padding: 0 10px 0 10px;height: 20px;">


        <span style="float: right;margin-right: 10px;">
            <el-input size="small" placeholder="请输入论文wos编号" suffix-icon="el-icon-search"
                      style="width: 200px;margin-right: 10px;" v-model="filterParams.storeNum"
                      @keyup.enter.native="table.entity.params.pageIndex=1;refreshTable_entity()">
            </el-input>
            <el-button size="small" type="primary" style="position:relative;"
                       @click="table.entity.params.pageIndex=1;refreshTable_entity()">
                <span>搜索</span>
            </el-button>
        </span>
    </div>
        <%-- entity表格 --%>
        <el-table :data="table.entity.data"
                  id="paperTable"
                  ref="multipleTable"
                  v-loading="table.entity.loading"
                  height="calc(100% - 100px)"
                  style="width: 100%;overflow-y: hidden;margin-top: 20px;"
                  class="scroll-bar"
                  @selection-change="table.entity.selectionList=$event"
                  :row-class-name="getRowClass"
                  :row-key="getRowKeys"
                  :expand-row-keys="expands"
                  stripe>
            <el-table-column type="expand" fixed="left">
                <template slot-scope="{row, $index}">

                        <el-form label-position="right" class="demo-table-expand" size="medium" style="padding-left: 40px !important;margin-top: 30px">
                            <el-row type="flex" class="row-bg">
                                <el-col :span="3">
                                    <el-form-item label="第一作者" label-width="80px">
                                        <i-input v-model="row.firstAuthorName" style="width: 100px;" size="medium"
                                                 placeholder="请输入" style="position: relative;"></i-input>
                                    </el-form-item>
                                </el-col>
                                <el-col :span="3">
                                    <el-form-item label="第二作者"  label-width="80px" >
                                        <i-input v-model="row.secondAuthorName" style="width: 100px;" size="medium"
                                                 placeholder="请输入" style="position: relative;"></i-input>
                                    </el-form-item>
                                </el-col>
                            </el-row>
                            <el-row type="flex" class="row-bg">
                            <el-col :span="3">
                                <el-form-item label="第一作者学院" label-width="100px" >
                                    <el-select clearable filterable style="width: 150px;"
                                               v-model="row.firstAuthorSchool" >
                                        <el-option v-for="org in orgOption" :key="org.value" :value="org.value"
                                                   :label="org.label"></el-option>
                                    </el-select>
                                </el-form-item>
                            </el-col>
                            <el-col :span="3">

                                <el-form-item label="第二作者学院" label-width="100px">
                                    <el-select clearable filterable style="width: 150px;"
                                               v-model="row.secondAuthorSchool" >
                                        <el-option v-for="org in orgOption" :key="org.value" :value="org.value"
                                                   :label="org.label"></el-option>
                                    </el-select>
                                </el-form-item>

                            </el-col>
                        </el-row>
                            <el-row type="flex" class="row-bg">
                                <el-col :span="3">
                                    <el-form-item label="第一作者身份" label-width="100px">
                                        <el-select clearable filterable style="width: 100px;"
                                                   v-model="row.firstAuthorType" >
                                            <el-option v-for="user in userTypeList" :key="user.value" :value="user.value"
                                                       :label="user.label"></el-option>
                                        </el-select>
                                    </el-form-item>
                                </el-col>
                                <el-col :span="3">
                                    <el-form-item label="第二作者身份" label-width="100px">
                                        <el-select clearable filterable style="width: 100px;"
                                                   v-model="row.secondAuthorType" >
                                            <el-option v-for="user in userTypeList" :key="user.value" :value="user.value"
                                                       :label="user.label"></el-option>
                                        </el-select>
                                    </el-form-item>
                                </el-col>
                            </el-row>
                            <el-button size="medium" type="primary"
                                       @click="commitClaim(row)">
                                <span>提交</span>
                            </el-button>
                        </el-form>
                </template>
            </el-table-column>

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
                    width="120"
                    label="ISSN">
            </el-table-column>

            <el-table-column
                    align="center"
                    fixed="left"
                    width="80"
                    label="分区">
                <template slot-scope="{row}">
                    <template v-if="row.journalDivision == null || row.journalDivision == ''">
                        <el-button type="danger" size="mini" style="position:relative;bottom: 1px;margin-left: 6px;">
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
                        <el-button type="danger" size="mini" style="position:relative;bottom: 1px;margin-left: 6px;">
                            <span>暂无影响因子</span>
                        </el-button>
                    </template>
                    <template v-else>
                        {{row.impactFactor}}
                    </template>
                </template>
            </el-table-column>

            <el-table-column
                    prop="danweiCn"
                    align="center"
                    width="150"
                    label="所属学院"
                    show-overflow-tooltip>
            </el-table-column>
            <el-table-column
                    prop="docType"
                    align="center"
                    width="100"
                    label="论文种类">
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
                    prop="firstAuthorSchool"
                    align="center"
                    width="160"
                    label="第一作者学院">
            </el-table-column>
            <el-table-column
                    prop="firstAuthorType"
                    align="center"
                    width="80"
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
                    prop="secondAuthorSchool"
                    align="center"
                    width="160"
                    label="第二作者学院">
            </el-table-column>
            <el-table-column
                    prop="secondAuthorType"
                    align="center"
                    width="80"
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
                    width="230"
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
                <template slot-scope="{row, $index}">
                    <el-button type="success"  @click="claimPaper(row,$index)" size="mini" style="position:relative;bottom: 1px;margin-left: 6px;">
                        <span>认领论文</span>
                    </el-button>
                </template>
            </el-table-column>
        </el-table>
    <%-- entity分页 --%>
    <el-pagination style="text-align: center;margin: 8px auto;"
                   @size-change="onPageSizeChange_entity"
                   @current-change="onPageIndexChange_entity"
                   :current-page="table.entity.params.pageIndex"
                   :page-sizes="table.entity.params.pageSizes"
                   :page-size="table.entity.params.pageSize"
                   :total="table.entity.params.total"
                   layout="total, sizes, prev, pager, next, jumper">
    </el-pagination>
</div>
<%@include file="/WEB-INF/views/include/blankScript.jsp"%>
<script>
        let app = new Vue({
            el: '#app',
            data: {
                paperInfo: {
                    publishDate: 0
                },
                urls: {
                    // api for entity
                    selectEntityListByPage: '/tutor/getPaperByWOS',
                    selectDanweiNicknamesAllList: '/api/doc/danweiNicknames/selectAllList',
                    tutorClaimPaper:'/tutor/tutorClaimPaper'
                },
                fullScreenLoading: false,
                table: {
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
                },
                filterParams: {
                    storeNum:'',
                    ownerWorkId: '${author.workId}'
                },
                userTypeList: [
                    {
                        value: 'teacher',
                        label: '导师'
                    },
                    {
                        value: 'student',
                        label: '学生'
                    },
                    {
                        value: 'doctor',
                        label: '博士后'
                    }
                ],
                orgOption:[],
                danweiList: [],
                expands: []
            },
            methods: {
                selectEntityListByPage: function () {
                    let data = this.filterParams;
                    data.page = this.table.entity.params;
                    let app = this;
                    app.table.entity.loading = true;
                    ajaxPostJSON(this.urls.selectEntityListByPage, data, function (d) {
                        let resList = d.data.resultList;
                        for (let i = 0; i < resList.length; i++) {
                            tmpDate = resList[i].publishDate;
                            resList[i].publishDate = dateFormat(tmpDate);
                        }
                        app.table.entity.loading = false;
                        app.table.entity.data = resList;
                        app.table.entity.params.total = d.data.total;
                    });
                },
                // 刷新entity table数据
                refreshTable_entity: function () {
                    this.selectEntityListByPage();
                    this.expands=[];
                },
                // 处理选中的行变化
                onSelectionChange_entity: function (val) {
                    this.table.entity.selectionList = val;
                },
                // 处理pageSize变化
                onPageSizeChange_entity: function (newSize) {
                    this.table.entity.params.pageSize = newSize;
                    this.refreshTable_entity();
                },
                // 处理pageIndex变化
                onPageIndexChange_entity: function (newIndex) {
                    this.table.entity.params.pageIndex = newIndex;
                    this.refreshTable_entity();
                },
                // 重置表单
                resetForm: function (ref) {
                    this.$refs[ref].resetFields();
                },
                // 隐藏表格箭头
                getRowClass(row, index) {
                    let res = [];
                    if (1==1){
                        res.push('row-expand-cover');
                    }
                    return res.join(' ') ;
                },
                claimPaper(row,index){
                    this.expands.push(row.id)

                },
                getRowKeys(row) {
                    return row.id;
                },
                commitClaim(row){
                    var app =this;
                    app.table.entity.loading=true;
                    let data = {
                        ownerWorkId:app.filterParams.ownerWorkId,
                        firstAuthorName:row.firstAuthorName,
                        firstAuthorType:row.firstAuthorType,
                        firstAuthorSchool:row.firstAuthorSchool,
                        secondAuthorName:row.secondAuthorName,
                        secondAuthorType:row.secondAuthorType,
                        secondAuthorSchool:row.secondAuthorSchool,
                        paperName:row.paperName,
                        paperWosId:row.storeNum,
                        status:0
                    };
                    ajaxPostJSON(this.urls.tutorClaimPaper, data, function success(res) {
                        if (res.code === 'success') {
                            console.log('success');
                            app.table.entity.loading=false;
                            app.$message({
                                message:'认领申请成功',
                                type:'success'
                            })
                        }else {
                            console.log('error');
                            app.table.entity.loading=false;
                            app.$message({
                                message:res.data,
                                type:'error'
                            })
                        }
                    });
                }
            },
            mounted: function () {
                /*初始化学校机构*/
                let org =${orgList};
                for (let i = 0; i < org.length; i++) {
                    let tmpOrg = {
                        value: org[i],
                        label: org[i]
                    };
                    this.orgOption.push(tmpOrg);
                }

            }
        });


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

        function add0(m) {
            return m < 10 ? '0' + m : m
        }


</script>
</body>
</html>