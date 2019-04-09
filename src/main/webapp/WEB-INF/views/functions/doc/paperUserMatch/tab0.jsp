<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>ssm</title>
    <%@include file="/WEB-INF/views/include/blankHead.jsp" %>
    <link rel="stylesheet" href="/static/css/functions/doc/paperUserMatch/tab0.css"/>
</head>
<body>
<div id="app" v-cloak style="background: white;height: 100%;overflow: hidden;" v-loading="fullScreenLoading">
    <%-- 顶栏 --%>
    <div style="padding: 10px 20px 0 15px;">
        <span class="button-group">
            <el-button size="small" type="danger" @click="deleteEntityListByIds(table.entity.selectionList)"
                       style="margin-left: 10px;">
                <span>批量删除</span>
            </el-button>
            <el-button size="small" type="warning" @click="deleteAllListNotInitial()"
                       style="margin-left: 10px;">
                <span>全部删除</span>
            </el-button>
            <el-button size="small" type="primary" style="margin-left: 10px;" @click="initAllPaper()">
                <span>初始化</span>
            </el-button>
        </span>
        <span style="float: right;margin-right: 10px;">
            <el-input size="small" placeholder="请输入论文名搜索相关论文" suffix-icon="el-icon-search"
                      style="width: 250px;margin-right: 10px;" v-model="table.entity.params.searchKey"
                      @keyup.enter.native="table.entity.params.pageIndex=1;refreshTable_entity()">
            </el-input>
            <el-button size="small" type="primary" style="position:relative;"
                       @click="table.entity.params.pageIndex=1;refreshTable_entity()">
                <span>搜索</span>
            </el-button>
        </span>
    </div>
    <%-- entity表格 --%>
    <el-table :data="table.entity.data" height="calc(100% - 116px)" v-loading="table.entity.loading"
              style="width: 100%;overflow-y: hidden;margin-top: 10px;" class="scroll-bar"
              @selection-change="onSelectionChange_entity" stripe>
        <el-table-column type="selection" width="40" fixed="left"></el-table-column>
        <el-table-column label="论文名" width="300" fixed="left">
            <template slot-scope="scope">
                <el-Tooltip open-delay="500" effect="dark" :content="scope.row.paperName" placement="top">
                    <div style="overflow: hidden;text-overflow:ellipsis;white-space: nowrap;width: 95%;">
                        {{ scope.row.paperName }}
                    </div>
                </el-Tooltip>
            </template>
        </el-table-column>
        <el-table-column label="作者列表" width="200">
            <template slot-scope="scope">
                <el-Tooltip open-delay="500" effect="dark" :content="scope.row.authorList" placement="top">
                    <div style="overflow: hidden;text-overflow:ellipsis;white-space: nowrap;width: 95%;">
                        {{ scope.row.authorList }}
                    </div>
                </el-Tooltip>
            </template>
        </el-table-column>
        <el-table-column label="第一作者名" width="150" prop="firstAuthorName"></el-table-column>
        <el-table-column label="第二作者名" width="150" prop="secondAuthorName"></el-table-column>
        <el-table-column label="第一作者工号/学号" width="150" prop="firstAuthorId"></el-table-column>
        <el-table-column label="第二作者工号/学号" width="150" prop="secondAuthorId"></el-table-column>
        <el-table-column label="ISSN" width="150" prop="ISSN"></el-table-column>
        <el-table-column label="入藏号" width="300" prop="storeNum" align="center"></el-table-column>
        <el-table-column label="论文种类" width="150" prop="docType" align="center"></el-table-column>
        <el-table-column label="发布日期" width="150" prop="publishDate"></el-table-column>
        <el-table-column label="PY" width="150" prop="_PY"></el-table-column>
        <el-table-column label="PD" width="150" prop="_PD"></el-table-column>
        <el-table-column label="操作" width="100" header-align="center" align="center" fixed="right">
            <template slot-scope="scope">
                <el-button type="danger" size="mini" style="position:relative;bottom: 1px;"
                           @click="deleteEntityListByIds([{id: scope.row.id}])">
                    <span>删除</span>
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
<script src="/static/js/functions/doc/paperUserMatch/tab0.js"></script>
</body>
</html>