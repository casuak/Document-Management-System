<%--
  Created by IntelliJ IDEA.
  User: zm
  Date: 2019/7/3
  Time: 15:08
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>patentUserSearch</title>
    <%@include file="/WEB-INF/views/include/blankHead.jsp" %>
    <style>
        /* table左边的checkbox */
        .el-checkbox {
            margin: 0px;
            margin-left: 2px;
        }

        /* 设置table行高 */
        .el-table th > .cell {
            height: 40px;
            line-height: 40px;
        }

        /* 设置table行高 */
        .el-table__row .cell {
            height: 45px;
            line-height: 45px;
        }

        .el-table--enable-row-transition .el-table__body td, .el-table td, .el-table th {
            padding: 0px;
        }

        /* 设置table悬浮颜色 */
        .el-table--enable-row-hover .el-table__body tr:hover > td {
            background: #f6faff;
        }

        .el-table--enable-row-transition .el-table__body td, .el-table td, .el-table th {
            border: 0px !important;
        }

        .el-table th.is-leaf, tr .gutter {
            background: aliceblue;
        }

        .el-button--mini {
            font-size: 11px;
            padding: 6px 8px;
        }

        /* 取消button间的自动间隔 */
        .el-button + .el-button {
            margin-left: 0px;
        }

        /* 弹窗 */
        .el-dialog {
            width: 654px;
            margin-top: 30px !important;
        }

        /* 弹窗固定上下移动 */
        .el-dialog__wrapper {
            /*overflow-y: hidden;*/
        }

        .el-form {
            padding: 0 90px !important;
        }

        .el-dialog__body {
            padding: 0;
        }
    </style>
</head>
<body>
<div id="app" v-cloak style="background: white;height: 100%;overflow: hidden;" v-loading="fullScreenLoading">
    <%-- 顶栏 --%>
    <div style="padding: 0 20px 0 15px;">
        <span class="button-group" style="margin-bottom: 5px;">
            <%--<el-select size="small" clearable filterable placeholder="选择作者身份"--%>
                       <%--style="width: 150px;margin-right: 10px;"--%>
                       <%--v-model="filterParams.userType" @change="refreshTable_entity()">--%>
                <%--<el-option v-for="(item, index) in userTypeList" :key="item.value"--%>
                           <%--:value="item.value" :label="item.label"></el-option>--%>
            <%--</el-select>--%>
            <el-select size="small" clearable filterable placeholder="选择学院"
                       style="width: 150px;margin-right: 10px;"
                       v-model="filterParams.school" @change="refreshTable_entity()">
                <el-option v-for="(item, index) in danweiList" :key="item.id"
                           :value="item.name" :label="item.name"></el-option>
            </el-select>
            <span>
                授权公告日：{{ new Date(patentInfo.publishDate).Format('yyyy-MM-dd') }}
            </span>
        </span>
        <span style="float: right;margin-right: 10px;">
            <el-input size="small" placeholder="请输入工号/学号" suffix-icon="el-icon-search"
                      style="width: 200px;margin-right: 10px;" v-model="filterParams.workId"
                      @keyup.enter.native="table.entity.params.pageIndex=1;refreshTable_entity()">
            </el-input>
            <el-input size="small" placeholder="请输入作者别名" suffix-icon="el-icon-search"
                      style="width: 230px;margin-right: 10px;" v-model="table.entity.params.searchKey"
                      @keyup.enter.native="table.entity.params.pageIndex=1;refreshTable_entity()">
            </el-input>
            <el-button size="small" type="primary" style="position:relative;"
                       @click="table.entity.params.pageIndex=1;refreshTable_entity()">
                <span>搜索</span>
            </el-button>
        </span>
    </div>
    <%-- entity表格 --%>
    <el-table :data="table.entity.data" height="calc(100% - 87px)" v-loading="table.entity.loading"
              style="width: 100%;overflow-y: hidden;margin-top: 10px;" class="scroll-bar"
              @selection-change="onSelectionChange_entity" stripe>
        <el-table-column width="10" fixed="left"></el-table-column>
        <el-table-column label="姓名" prop="realName" width="70" fixed="left" align="center">
            <template slot-scope="{row}">
                <el-Tooltip open-delay="500" effect="dark" :content="row.realName" placement="top">
                    <div style="overflow: hidden;text-overflow: ellipsis;white-space: nowrap;width: 95%;">
                        {{ row.realName }}
                    </div>
                </el-Tooltip>
            </template>
        </el-table-column>
        <el-table-column label="工号" prop="workId" width="100" fixed="left" align="center"></el-table-column>
        <el-table-column label="别名列表" prop="nicknames" width="170" align="center">
            <template slot-scope="{row}">
                <el-Tooltip open-delay="500" effect="dark" :content="row.nicknames" placement="top">
                    <div style="overflow: hidden;text-overflow: ellipsis;white-space: nowrap;width: 95%;">
                        {{ row.nicknames }}
                    </div>
                </el-Tooltip>
            </template>
        </el-table-column>
        <el-table-column label="身份" prop="userType" width="70" align="center"></el-table-column>
        <el-table-column label="学院" prop="school" width="120" align="center"></el-table-column>
        <el-table-column label="导师" width="70" prop="tutorName" align="center"></el-table-column>
        <el-table-column label="导师工号" width="100" prop="tutorWorkId" align="center"></el-table-column>
        <el-table-column label="入学/入职时间" align="center" width="110">
            <template slot-scope="{row}">
                {{ row.hireDate === null ? '' : (new Date(row.hireDate)).Format("yyyy-MM-dd") }}
            </template>
        </el-table-column>
        <el-table-column label="学生层次" prop="studentTrainLevel" align="center" width="80"></el-table-column>
        <%--<el-table-column></el-table-column>--%>
        <el-table-column label="操作" fixed="right" width="80" header-align="center" align="center">
            <template slot-scope="{ row }">
                <el-button type="warning" size="mini" style="position:relative;bottom: 1px;"
                           @click="selectPatentAuthor(row.id,row.userType)">
                    <span>选择</span>
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
<%@include file="/WEB-INF/views/include/blankScript.jsp" %>
<script>
    // 接收页面初始化参数
    let pageParams = {};
    pageParams.patentId = '${patentId}';
    pageParams.authorIndex = ${authorIndex};
    pageParams.searchKey = '${searchKey}';
    pageParams.school = '${institute}';
    pageParams.publishDate = ${authorizationDate};
    pageParams.workId = '${workId}';
</script>
<script>
    var app = new Vue({
        el: '#app',
        data: {
            patentInfo: {
                publishDate: ''
            },
            urls: {
                selectUserListByPage: '/api/sys/user/selectUserListByPage',
                selectDanweiNicknamesAllList: '/api/doc/danweiNicknames/selectAllList',
                selectPatentAuthor: '/api/patent/setPatentAuthor'
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
                userType: '', // 用户类型
                school: '', // 所属单位
                workId: '', // 工号/学号
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
            danweiList: []
        },
        methods: {
            selectUserListByPage: function () {
                let data = this.filterParams;
                data.page = this.table.entity.params;
                let app = this;
                app.table.entity.loading = true;
                ajaxPostJSON(this.urls.selectUserListByPage, data, function (d) {
                    app.table.entity.loading = false;
                    app.table.entity.data = d.data.resultList;
                    app.table.entity.params.total = d.data.total;
                    console.log(d.data.resultList)
                });
            },
            // 刷新entity table数据
            refreshTable_entity: function () {
                this.selectUserListByPage();
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
            //选择专利用户
            selectPatentAuthor : function (id,userType) {
                let data = {
                    patentId: pageParams.patentId,
                    authorIndex: pageParams.authorIndex,
                    authorId: id,
                    userType: userType
                };
                let app = this;
                app.fullScreenLoading = true;
                ajaxPost(this.urls.selectPatentAuthor, data, function (d) {
                    app.fullScreenLoading = false;
                    window.parent.parent.app.showMessage('选择成功！', 'success');
                    window.parent.getPatentList();
                    window.parent.app.searchUserDialog.visible = false;
                });
            }
        },
        mounted: function () {
            this.table.entity.params.searchKey = pageParams.searchKey;
            this.filterParams.school = pageParams.school;
            this.filterParams.workId = pageParams.workId;
            this.patentInfo.publishDate = pageParams.publishDate;
            console.log("-----")
            console.log(pageParams.publishDatep);
            let app = this;
            app.table.entity.loading = true;
            ajaxPostJSON(app.urls.selectDanweiNicknamesAllList, null, function (d) {
                app.danweiList = d.data;
                app.table.entity.loading = false;
                app.selectUserListByPage();
            });
        }
    });
</script>
</body>
</html>