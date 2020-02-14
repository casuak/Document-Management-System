<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>ssm</title>
    <%@include file="/WEB-INF/views/include/blankHead.jsp" %>
    <link rel="stylesheet" href="/static/css/functions/document/paper/searchUser.css"/>
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
                论文发布时间：{{ new Date(paperInfo.publishDate).Format('yyyy-MM-dd') }}
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
        <el-table-column label="学生层次" prop="studentTrainLevel" align="center" width="80"></el-table-column>
        <el-table-column label="入学/入职时间" align="center" width="110">
            <template slot-scope="{row}">
                {{ row.hireDate === null ? '' : (new Date(row.hireDate)).Format("yyyy-MM-dd") }}
            </template>
        </el-table-column>
        <%--<el-table-column></el-table-column>--%>
        <el-table-column label="操作" fixed="right" width="80" header-align="center" align="center">
            <template slot-scope="{ row }">
                <el-button type="warning" size="mini" style="position:relative;bottom: 1px;"
                           @click="selectUser(row)">
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
<%@include file="/WEB-INF/views/include/blankScript.jsp"%>
<script>
    // 接收页面初始化参数
    let pageParams = {};
    pageParams.paperId = '${paperId}';
    pageParams.authorIndex = ${authorIndex};
    pageParams.searchKey = '${searchKey}';
    pageParams.school = '${school}';
    pageParams.publishDate = ${publishDate};
    pageParams.workId = '${workId}';
    pageParams.paperIndex='${paperIndex}'
</script>
<script src="/static/js/functions/tutor/manage/searchUser.js"></script>
</body>
</html>