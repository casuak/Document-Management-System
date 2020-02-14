<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>ssm</title>
    <%@include file="/WEB-INF/views/include/blankHead.jsp" %>
    <link rel="stylesheet" href="/static/css/functions/tutor/paperClaimManage.css"/>
</head>
<body>
<div id="app" v-cloak style="background: white;height: 100%;overflow: hidden;" v-loading="fullScreenLoading">
    <%-- 顶栏 --%>
    <div style="padding: 0 10px 0 10px;height: 20px; margin-top: 10px">
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
        <%-- 表格 --%>
        <el-table :data="table.entity.data"
                  id="paperTable"
                  ref="multipleTable"
                  v-loading="table.entity.loading"
                  height="calc(100% - 100px)"
                  style="width: 100%;overflow-y: hidden;margin-top: 20px;"
                  class="scroll-bar"
                  @selection-change="table.entity.selectionList=$event"
                  :row-key="getRowKeys"
                  :expand-row-keys="expands"
                  stripe>

            <el-table-column type="expand" >
                <template slot-scope="props">
                    <el-table  :data="props.row.tutorPaper">
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
                                <template v-if="(row.journalDivision == null || row.journalDivision == '')&&row.paperName!='申请信息'">
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
                                <template v-if="(row.impactFactor == null || row.impactFactor == '')&&row.paperName!='申请信息'">
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

                        <el-table-column label="第一匹配作者" width="300" align="center">
                            <template slot-scope="{row}">
                <span v-if="row.firstAuthorId != null && row.firstAuthorId !== ''"
                      style="display: flex;align-items: center;justify-content: space-between">
                    <div>{{ row.firstAuthorId }}</div>
                    <el-Tooltip open-delay="500" effect="dark" :content="row.firstAuthorCname" placement="top">
                        <div style="display: inline-block;overflow: hidden;text-overflow: ellipsis;white-space: nowrap;width: 100px;">
                            {{ row.firstAuthorCname != null ? row.firstAuthorCname : ''}}
                        </div>
                    </el-Tooltip>
                    <div>{{ row.firstAuthorType != null ? row.firstAuthorType : ''}}</div>
                    <i-button style="height: 25px;position:relative;left: 4px;" v-if="row.status !== '3'"
                              type="warning" size="small" @click="clearAuthor(row, 1)">X</i-button>
                        </span>

                                <span v-else-if="row.paperName == '申请信息'"
                                      style="display: flex;align-items: center;justify-content: space-between">
                                  <div>{{ row.firstAuthorName }}</div>
                                  <div>{{ row.firstAuthorSchool }}</div>
                                  <div>{{ row.firstAuthorType }}</div>
                              </span>
                                  <span v-else>
                                    <i-button type="success" size="small" v-if="row.status !== '3'"
                                              @click="openSearchUser(props, 1, props.row.tutorPaper[1].firstAuthorName,props.row.tutorPaper[1].firstAuthorSchool)">手动匹配</i-button>
                                 </span>
                            </template>
                        </el-table-column>

                        <el-table-column label="第二匹配作者" width="300" align="center">
                            <template slot-scope="{row}">
                <span v-if="row.secondAuthorId != null && row.secondAuthorId !== ''"
                      style="display: flex;align-items: center;justify-content: space-between">
                    <div>{{ row.secondAuthorId }}</div>
                    <el-Tooltip open-delay="500" effect="dark" :content="row.secondAuthorCname" placement="top">
                        <div style="display: inline-block;overflow: hidden;text-overflow: ellipsis;white-space: nowrap;width: 100px;">
                            {{ row.secondAuthorCname != null ? row.secondAuthorCname : '' }}
                        </div>
                    </el-Tooltip>
                    <div>{{ row.secondAuthorType != null ? row.secondAuthorType : '' }}</div>
                    <i-button style="height: 25px;position:relative;left: 4px;" v-if="row.status !== '3'"
                              type="warning" size="small" @click="clearAuthor(row, 2)">X</i-button>
                        </span>
                              <span v-else-if="row.paperName == '申请信息'"
                                    style="display: flex;align-items: center;justify-content: space-between">
                                  <div>{{ row.secondAuthorName }}</div>
                                  <div>{{ row.secondAuthorSchool }}</div>
                                  <div>{{ row.secondAuthorType }}</div>
                              </span>

                                <span v-else>
                            <i-button type="success" size="small" v-if="row.status !== '3'"
                                      @click="openSearchUser(props, 2, props.row.tutorPaper[1].secondAuthorName, props.row.tutorPaper[1].secondAuthorSchool)">手动匹配</i-button>
                              </span>
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
                    </el-table>
                </template>
            </el-table-column>
            <el-table-column
                    prop="tutorPaper[0].paperName"
                    width="400"
                    align="center"
                    label="论文名"
                    show-overflow-tooltip>
            </el-table-column>
            <el-table-column
                    prop="paperWosId"
                    width="230"
                    align="center"
                    label="入藏号">
            </el-table-column>

            <el-table-column
                    prop="ownerName"
                    width="100"
                    align="center"
                    label="申请人姓名">
            </el-table-column>
            <el-table-column
                    prop="ownerWorkId"
                    width="100"
                    align="center"
                    label="申请人工号">
            </el-table-column>
            <el-table-column
                    prop="createDate"
                    width="100"
                    align="center"
                    label="申请时间">
            </el-table-column>
            <el-table-column
                    prop="status"
                    width="150"
                    align="center"
                    label="申请状态">
                <template slot-scope="{row}">
                    <template v-if="row.status == 1">
                        <el-button size ="small" type="success">认领成功</el-button>
                    </template>
                    <template v-else-if="row.status == 0">
                        <el-button size ="small" type="warning">正在申请</el-button>
                    </template>
                    <template v-else-if="row.status == -1">
                        <el-button size ="small" type="error">申请失败</el-button>
                    </template>
                </template>
            </el-table-column>

            <el-table-column
                    prop="remarks"
                    width="300"
                    align="center"
                    label="备注">
            </el-table-column>
            <el-table-column
                    label="操作"
                    align="center">
                <template slot-scope="{row, $index}">
                    <el-button type="success" @click="doTutorClaim(row,1)" size="mini" style="position:relative;bottom: 1px;margin-left: 6px;" :disabled="row.status!=0">
                        <span>同意</span>
                    </el-button>
                    <el-button type="danger"  @click="doTutorClaim(row,-1)" size="mini" style="position:relative;bottom: 1px;margin-left: 6px;" :diabled="row.status!=0">
                        <span>拒绝</span>
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

        <%-- 选择用户 --%>
        <el-dialog title="手动选择作者" :visible.sync="searchUserDialog.control.visible" class="dialog-searchUser">
            <div v-loading="searchUserDialog.control.loading" style="height: 450px;">
                <iframe v-if="searchUserDialog.control.visible" :src="searchUserDialog.url"
                        style="width: 100%;height: 450px;overflow-y: auto;border: 0;"
                        @load="searchUserDialog.control.loading=false;"></iframe>
            </div>
        </el-dialog>
</div>
<%@include file="/WEB-INF/views/include/blankScript.jsp"%>
<script>

</script>
<script src="/static/js/functions/tutor/manage/paperClaimManage.js"></script>
</body>
</html>