<%--
  Created by IntelliJ IDEA.
  User: zch
  Date: 2020/2/8
  Time: 20:56
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>通讯作者匹配</title>
    <%@include file="/WEB-INF/views/include/blankHead.jsp" %>
    <link rel="stylesheet" href="/static/css/functions/document/paper/paperReprintAuthor.css"/>
</head>
<body>
<div id="app" v-cloak v-loading="loading.fullScreen">
    <%-- 提示 --%>
        <el-alert title="提示" type="info" description="通讯作者匹配前需完成作者匹配" show-icon></el-alert>

    <%-- 顶栏 --%>
    <div style="padding: 15px 20px 6px 15px;">
        <span class="button-group">
            <el-button size="small" type="danger" :disabled="status === '4'"
                       @click="deletePaperEntryByIds(selectionList)">
                批量删除
            </el-button>
            <el-button size="small" type="warning" :disabled="status === '4'"
                       @click="deletePaperEntryByStatus()">
                全部删除
            </el-button>
            <el-button size="small" type="primary" @click="initAllPaper()" v-if="status === '-1'">
                初始化
            </el-button>
            <el-button size="small" type="primary" @click="autoMatch()" v-if="status === '0'">
                自动匹配
            </el-button>
            <el-button size="small" type="primary" @click="completePaperEntryByStatus()" v-if="status === '1'">
                全部完成
            </el-button>
        </span>

        <span style="float: right;margin-right: 10px;">
            <el-select v-model="status" size="small" style="margin-right: 10px;" @change="getPaperList()">
                <el-option v-for="status in statusList"
                           :label="status.label"
                           :value="status.value"
                           :key="status.value"></el-option>
            </el-select>
            <el-input size="small" placeholder="请输入论文题目" suffix-icon="el-icon-search"
                      style="width: 250px;margin-right: 10px;" v-model="page.searchKey"
                      @keyup.enter.native="getPaperList()">
            </el-input>
            <el-button size="small" type="primary" @click="getPaperList()">
                搜索
            </el-button>
        </span>
    </div>

    <%-- 表格 --%>
    <el-table :data="paperList" height="calc(100% - 176px)" v-loading="loading.table"
              style="width: 100%;overflow-y: hidden;margin-top: 15px;" class="scroll-bar"
              @selection-change="selectionList=$event" stripe
              width="100%">
        <el-table-column type="selection" width="40"></el-table-column>

        <el-table-column label="论文名" width="300" fixed="left" header-align="center" align="center">
            <template slot-scope="{row}">
                <el-Tooltip open-delay="500" effect="dark" :content="row.paperName" placement="top">
                    <div style="overflow: hidden;text-overflow: ellipsis;white-space: nowrap;width: 95%;">
                        {{ row.paperName }}
                    </div>
                </el-Tooltip>
            </template>
        </el-table-column>

        <el-table-column label="通讯作者" width="200" fixed="left" header-align="center" align="center">
            <template slot-scope="{row}">
                <el-Tooltip open-delay="500" effect="dark" :content="row.rpimport" placement="top">
                    <div style="overflow: hidden;text-overflow: ellipsis;white-space: nowrap;width: 95%;">
                        {{ row.rpimport }}
                    </div>
                </el-Tooltip>
            </template>
        </el-table-column>

        <el-table-column label="第一匹配作者" width="200" align="center">
            <template slot-scope="{row}">
                <el-Tooltip open-delay="500" effect="dark" :content="getAuthor(row, 1)" placement="top">
                    <div style="overflow: hidden;text-overflow: ellipsis;white-space: nowrap;width: 95%;">
                        {{ getAuthor(row, 1) }}
                    </div>
                </el-Tooltip>
            </template>
        </el-table-column>

        <el-table-column label="第二匹配作者" width="200" align="center">
            <template slot-scope="{row}">
                <el-Tooltip open-delay="500" effect="dark" :content="getAuthor(row, 2)" placement="top">
                    <div style="overflow: hidden;text-overflow: ellipsis;white-space: nowrap;width: 95%;">
                        {{ getAuthor(row, 2) }}
                    </div>
                </el-Tooltip>
            </template>
        </el-table-column>

        <el-table-column label="单位名称" width="200" header-align="center" align="center">
            <template slot-scope="{row}">
                <el-Tooltip open-delay="500" effect="dark" :content="row.danweiCN" placement="top">
                    <div style="overflow: hidden;text-overflow: ellipsis;white-space: nowrap;width: 95%;">
                        {{ row.danweiCN }}
                    </div>
                </el-Tooltip>
            </template>
        </el-table-column>

        <el-table-column label="匹配结果" width="200" header-align="center" align="center" fixed="right">
            <template slot-scope="{row}">
                <el-Tooltip open-delay="500" effect="dark" :content="row.matchedAuthor" placement="top">
                    <div style="overflow: hidden;text-overflow: ellipsis;white-space: nowrap;width: 95%;">
                        {{ row.matchedAuthor }}
                    </div>
                </el-Tooltip>
            </template>

        </el-table-column>

        <el-table-column label="操作" width="280" header-align="center" align="center" fixed="right">
            <template slot-scope="{row}">
                <span style="position:relative;bottom: 1px;">
                    <el-button type="primary" size="mini" style="margin-right: 0px;"
                               @click="rollBackToSuccessById([{id:row.id}])"
                               v-if="status === '4'">
                        <span>转回成功</span>
                    </el-button>
                    <el-button type="primary" size="mini" style="margin-right: 0px;"
                               @click="openMatchDialog(row)"
                               v-if="status === '1' || status === '2' || status === '3'">
                        <span>手动匹配</span>
                    </el-button>
                    <el-button type="success" size="mini" style="margin-right: 0px;"
                               @click="completePaperEntryById([{id:row.id}])"
                               v-if="status === '1'">
                        <span>转入完成</span>
                    </el-button>
                    <el-button type="danger" size="mini" :disabled="status === '4'"
                               @click="deletePaperEntryByIds([{id: row.id}])">
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

    <%-- 更新 dialog --%>
    <el-dialog title="手动匹配" :visible.sync="drawer" width="52%" :before-close="handleDrawerClose">
        <div style="margin: 0; padding: 0; display: flex; justify-content: flex-end">
            <el-button type="primary" icon="el-icon-edit"
                       size="mini" @click="addEntry = true">手动添加记录
            </el-button>
        </div>
        <el-table :data="authorList" stripe class="scroll-bar"
                  style="width: 100%;overflow-y: hidden;margin-top: 15px;"
                  width="100%">
            <el-table-column prop="authorName" label="通讯作者" width="120"
                             header-align="center" align="center"></el-table-column>
            <el-table-column label="匹配结果" header-align="center" header-align="center" align="center">
                <el-table-column label="匹配状态" width="120" header-align="center" align="center">
                    <template slot-scope="{row}">
                        {{ getStatus(row) }}
                    </template>
                </el-table-column>
                <el-table-column prop="authorWorkId" label="工号" width="120"
                                 header-align="center" align="center"></el-table-column>
                <el-table-column prop="realName" label="姓名" width="120"
                                 header-align="center" align="center"></el-table-column>
            </el-table-column>
            <el-table-column label="操作" header-align="center" align="center">
                <template slot-scope="{row}">
                    <span style="position:relative;bottom: 1px;">
                        <el-button type="primary" size="mini" style="margin-right: 0px;"
                                   @click="openFindDialog(row);">
                            <span>修改</span>
                        </el-button>
                        <el-button type="danger" size="mini" style="margin-right: 0px;"
                                   @click="removeFromList(row)">
                            <span>删除记录</span>
                        </el-button>
                    </span>
                </template>
            </el-table-column>
        </el-table>
        <span slot="footer" class="dialog-footer">
            <el-button @click="handleDrawerClose">取消</el-button>
            <el-button type="primary" @click="submitChange">提交修改</el-button>
        </span>
    </el-dialog>

    <%--手动添加 dialog --%>
    <el-dialog title="添加记录" :visible="addEntry" :before-close="handleInsertClose">
        <span slot="footer" class="dialog-footer">
            <el-form>
                <el-form-item label="通讯作者">
                    <el-input v-model="insertItem.name"></el-input>
                </el-form-item>
                <el-form-item label="工号">
                    <el-input v-model="insertItem.workId"></el-input>
                </el-form-item>
                <el-form-item label="姓名">
                    <el-input v-model="insertItem.realName"></el-input>
                </el-form-item>
            </el-form>
            <el-button @click="handleInsertClose">取消</el-button>
            <el-button type="primary" @click="addOneEntry"
                       :disabled="!(insertItem.name && insertItem.workId && insertItem.realName)">
                添加记录
            </el-button>
        </span>
    </el-dialog>

    <%-- 手动匹配 dialog --%>
    <el-dialog title="选择作者" :visible.sync="searchUserDialog.visible"
               class="dialog-searchUser" :before-close="handleSearchClose">
        <%-- 顶栏 --%>
        <div style="padding: 0 20px 0 15px;">
            <span class="button-group" style="margin-bottom: 5px;">
                <el-select size="small" clearable filterable placeholder="选择学院"
                           style="width: 150px;margin-right: 10px;"
                           v-model="searchUserDialog.filterParams.school" @change="refreshTable_entity()">
                    <el-option v-for="(item, index) in searchUserDialog.danweiList" :key="item.id"
                               :value="item.name" :label="item.name"></el-option>
                </el-select>
            </span>
            <span style="float: right;margin-right: 10px;">
            <el-input size="small" placeholder="请输入工号/学号" suffix-icon="el-icon-search"
                      style="width: 200px;margin-right: 10px;" v-model="searchUserDialog.filterParams.workId"
                      @keyup.enter.native="searchUserDialog.table.entity.params.pageIndex=1;refreshTable_entity()">
            </el-input>
            <el-input size="small" placeholder="请输入作者别名" suffix-icon="el-icon-search"
                      style="width: 230px;margin-right: 10px;" v-model="searchUserDialog.table.entity.params.searchKey"
                      @keyup.enter.native="searchUserDialog.table.entity.params.pageIndex=1;refreshTable_entity()">
            </el-input>
            <el-button size="small" type="primary" style="position:relative;"
                       @click="searchUserDialog.table.entity.params.pageIndex=1;refreshTable_entity()">
                <span>搜索</span>
            </el-button>
        </span>
        </div>
        <%-- entity表格 --%>
        <el-table :data="searchUserDialog.table.entity.data"
                  height="50vh" v-loading="searchUserDialog.table.entity.loading"
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
            <el-table-column label="操作" fixed="right" width="80" header-align="center" align="center">
                <template slot-scope="{ row }">
                    <el-button type="warning" size="mini" style="position:relative;bottom: 1px;"
                               @click="selectUser(row.workId, row.realName)">
                        <span>选择</span>
                    </el-button>
                </template>
            </el-table-column>
        </el-table>
        <%-- entity分页 --%>
        <el-pagination style="text-align: center;margin: 8px auto;"
                       @size-change="onPageSizeChange_entity"
                       @current-change="onPageIndexChange_entity"
                       :current-page="searchUserDialog.table.entity.params.pageIndex"
                       :page-sizes="searchUserDialog.table.entity.params.pageSizes"
                       :page-size="searchUserDialog.table.entity.params.pageSize"
                       :total="searchUserDialog.table.entity.params.total"
                       layout="total, sizes, prev, pager, next, jumper">
        </el-pagination>
    </el-dialog>


</div>
</body>
<%@include file="/WEB-INF/views/include/blankScript.jsp" %>
<script src="/static/js/functions/document/paper/paperReprintAuthor.js"></script>
</html>
