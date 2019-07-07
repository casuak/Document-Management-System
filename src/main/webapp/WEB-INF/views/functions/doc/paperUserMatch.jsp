<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>ssm</title>
    <%@include file="/WEB-INF/views/include/blankHead.jsp" %>
    <link rel="stylesheet" href="/static/css/functions/doc/paperUserMatch.css"/>
</head>
<body>
<div id="app" v-cloak v-loading="loading.fullScreen">
    <%-- 顶栏 --%>
    <div style="padding: 15px 20px 6px 15px;">
        <span class="button-group">
            <el-button size="small" type="danger" @click="deleteByIds(selectionList)">
                批量删除
            </el-button>
            <el-button size="small" type="warning" @click="deleteByStatus()">
                全部删除
            </el-button>
            <el-button size="small" type="primary" @click="initPapers()" v-if="status === '-1'">
                初始化
            </el-button>
            <el-button size="small" type="primary" @click="paperUserMatch()" v-if="status === '0'">
                自动匹配
            </el-button>
            <el-button size="small" type="primary" @click="completePapers()" v-if="status === '2'">
                全部完成
            </el-button>
        </span>
        <span style="float: right;margin-right: 10px;">
            <el-select v-model="status" size="small" style="margin-right: 10px;" @change="getPaperList()">
                <el-option v-for="status in statusList" :label="status.label"
                           :value="status.value" :key="status.value"></el-option>
            </el-select>
            <el-input size="small" placeholder="请输入论文名搜索相关论文" suffix-icon="el-icon-search"
                      style="width: 250px;margin-right: 10px;" v-model="page.searchKey"
                      @keyup.enter.native="getPaperList()">
            </el-input>
            <el-button size="small" type="primary" @click="getPaperList()">
                搜索
            </el-button>
        </span>
    </div>
    <%-- 表格 --%>
    <el-table :data="paperList" height="calc(100% - 116px)" v-loading="loading.table"
              style="width: 100%;overflow-y: hidden;margin-top: 10px;" class="scroll-bar"
              @selection-change="selectionList=$event" stripe>
        <el-table-column type="selection" width="40" fixed="left"></el-table-column>
        <el-table-column label="论文名" width="100" fixed="left">
            <template slot-scope="{row}">
                <el-Tooltip open-delay="500" effect="dark" :content="row.paperName" placement="top">
                    <div style="overflow: hidden;text-overflow: ellipsis;white-space: nowrap;width: 95%;">
                        {{ row.paperName }}
                    </div>
                </el-Tooltip>
            </template>
        </el-table-column>
        <el-table-column label="作者列表" width="200" fixed="left">
            <template slot-scope="{row}">
                <el-Tooltip open-delay="500" effect="dark" :content="row.authorList" placement="top">
                    <div style="overflow: hidden;text-overflow: ellipsis;white-space: nowrap;width: 95%;">
                        {{ row.authorList }}
                    </div>
                </el-Tooltip>
            </template>
        </el-table-column>
        <el-table-column label="单位名称（中文）" width="150" prop="danweiCN" fixed="left"></el-table-column>
        <el-table-column label="第一匹配作者" width="300" align="center"
                         v-if="['1', '2', '3'].contains(status)">
            <template slot-scope="{row}">
                <span v-if="row.firstAuthorId != null && row.firstAuthorId !== ''"
                      style="display: flex;align-items: center;justify-content: space-between">
                    <div @click="openSearchUser(row, 1, row.firstAuthorName, row.firstAuthorId)">{{ row.firstAuthorId }}</div>
                    <el-Tooltip open-delay="500" effect="dark" :content="row.firstAuthor.realName" placement="top">
                        <div style="display: inline-block;overflow: hidden;text-overflow: ellipsis;white-space: nowrap;width: 100px;">
                            {{ row.firstAuthor != null ? row.firstAuthor.realName : ''}}
                        </div>
                    </el-Tooltip>
                    <div>{{ row.firstAuthor != null ? row.firstAuthor.userType : ''}}</div>
                    <i-button style="height: 25px;position:relative;left: 4px;" v-if="row.status !== '3'"
                              type="warning" size="small" @click="clearAuthor(row, 1)">C</i-button>
                </span>
                <span v-else>
                    <i-button v-if="row.status !== '3'" type="success" size="small"
                              @click="openSearchUser(row, 1, row.firstAuthorName, '')">手动匹配</i-button>
                </span>
            </template>
        </el-table-column>
        <el-table-column label="第二匹配作者" width="300" align="center"
                         v-if="['1', '2', '3'].contains(status)">
            <template slot-scope="{row}">
                <span v-if="row.secondAuthorId != null && row.secondAuthorId !== ''"
                      style="display: flex;align-items: center;justify-content: space-between">
                    <div @click="openSearchUser(row, 2, row.secondAuthorName, row.secondAuthorId)">{{ row.secondAuthorId }}</div>
                    <el-Tooltip open-delay="500" effect="dark" :content="row.secondAuthor.realName" placement="top">
                        <div style="display: inline-block;overflow: hidden;text-overflow: ellipsis;white-space: nowrap;width: 100px;">
                            {{ row.secondAuthor != null ? row.secondAuthor.realName : '' }}
                        </div>
                    </el-Tooltip>
                    <div>{{ row.secondAuthor != null ? row.secondAuthor.userType : '' }}</div>
                    <i-button style="height: 25px;position:relative;left: 4px;" v-if="row.status !== '3'"
                              type="warning" size="small" @click="clearAuthor(row, 2)">C</i-button>
                </span>
                <span v-else>
                    <i-button v-if="row.status !== '3'" type="success" size="small"
                              @click="openSearchUser(row, 2, row.secondAuthorName, '')">手动匹配</i-button>
                </span>
            </template>
        </el-table-column>
        <%--<el-table-column label="ISSN" width="150" prop="ISSN" align="center"></el-table-column>--%>
        <%--<el-table-column label="入藏号" width="300" prop="storeNum" align="center"></el-table-column>--%>
        <%--<el-table-column label="论文种类" width="150" prop="docTypeValue" align="center"></el-table-column>--%>
        <el-table-column label="单位名称" width="200" header-align="center" align="center">
            <template slot-scope="{row}">
                <el-Tooltip open-delay="500" effect="dark" :content="row.danwei" placement="top">
                    <div style="overflow: hidden;text-overflow: ellipsis;white-space: nowrap;width: 95%;">
                        {{ row.danwei }}
                    </div>
                </el-Tooltip>
            </template>
        </el-table-column>
        <el-table-column label="发布日期" width="150" prop="publishDate" align="center">
            <template slot-scope="{row}">
                {{ row.publishDate === null ? '' : (new Date(row.publishDate)).Format("yyyy-MM-dd") }}
            </template>
        </el-table-column>
        <el-table-column label="PY" width="100" prop="_PY" align="center"></el-table-column>
        <el-table-column label="PD" width="100" prop="_PD" align="center">
            <template slot-scope="{row}">
                {{ row._PD === null ? '' : (new Date(row._PD)).Format("MM-dd") }}
            </template>
        </el-table-column>
        <el-table-column label="操作" width="160" header-align="center" align="center" fixed="right">
            <template slot-scope="{row}">
                <span style="position:relative;bottom: 1px;">
                    <el-button type="success" size="mini" style="margin-right: 0px;"
                               @click="convertToSuccessByIds([{id:row.id}])" :disabled="row.status !== '1'">
                    <span>转入成功</span>
                </el-button>
                <el-button type="danger" size="mini" style=""
                           @click="deleteByIds([{id: row.id}])">
                    <span>删除</span>
                </el-button>
                </span>
            </template>
        </el-table-column>
    </el-table>
    <%-- 分页 --%>
    <el-pagination style="text-align: center;margin: 9px auto;"
                   @size-change="page.pageSize=$event;getPaperList()"
                   @current-change="page.pageIndex=$event;getPaperList()"
                   :current-page="page.pageIndex"
                   :page-sizes="page.pageSizes"
                   :page-size="page.pageSize"
                   :total="page.total"
                   layout="total, sizes, prev, pager, next, jumper">
    </el-pagination>

    <%-- 选择用户 --%>
    <el-dialog title="手动选择作者" :visible.sync="searchUserDialog.visible" class="dialog-searchUser">
        <div v-loading="searchUserDialog.loading" style="height: 450px;">
            <iframe v-if="searchUserDialog.visible" :src="searchUserUrl"
                    style="width: 100%;height: 450px;overflow-y: auto;border: 0;"
                    @load="searchUserDialog.loading=false;"></iframe>
        </div>
    </el-dialog>
</div>
<%@include file="/WEB-INF/views/include/blankScript.jsp" %>
<script src="/static/js/functions/doc/paperUserMatch.js"></script>
</body>
</html>