<%--
  Created by IntelliJ IDEA.
  User: zm
  Date: 2019/7/3
  Time: 8:43
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>ssm</title>
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
            height: 44px;
            line-height: 44px;
        }

        td {
            border: 1px solid #e2e2e2 !important;
        }

        .el-table--enable-row-transition .el-table__body td, .el-table td, .el-table th {
            padding: 0px;
        }

        .el-table--enable-row-transition .el-table__body td, .el-table td, .el-table th {
            /*border: 0px !important;*/
        }

        .el-table__fixed-right-patch {
            background: #DCDCDC !important;
        }

        .el-table th.is-leaf {
            background: aliceblue !important;
        }

        .el-button--mini {
            font-size: 11px;
            padding: 6px 8px;
        }

        .dialog-searchUser .el-dialog {
            width: 900px;
        }

        .dialog-searchUser .el-dialog__body {
            padding: 0;
        }

        /* 弹窗 */
        .el-dialog {
            width: 654px;
            margin-top: 30px !important;
        }

        /*下拉框最大高度*/
        .el-select-dropdown__wrap {
            max-height: 334px;
        }
    </style>
</head>
<body>
<div id="app" v-cloak v-loading="loading.fullScreen">
    <%-- 顶栏 --%>
    <div style="padding: 15px 20px 6px 15px;">
        <span class="button-group">
            <el-button size="small" type="danger" @click="deletePatentByIds(selectionList)">
                批量删除
            </el-button>
            <el-button size="small" type="warning" @click="deletePatentByStatus()">
                全部删除
            </el-button>
            <el-button size="small" type="primary" @click="initAllPatent()" v-if="status === '-1'">
                初始化
            </el-button>
            <el-button size="small" type="primary" @click="patentUserMatch()" v-if="status === '0'">
                自动匹配
            </el-button>
            <el-button size="small" type="primary" @click="completeAllPatent()" v-if="status === '2'">
                全部完成
            </el-button>
        </span>
        <span style="float: right;margin-right: 10px;">
            <el-select v-model="status" size="small" style="margin-right: 10px;" @change="getPatentList()">
                <el-option v-for="status in statusList"
                           :label="status.label"
                           :value="status.value"
                           :key="status.value"></el-option>
            </el-select>
            <el-input size="small" placeholder="请输入专利名搜索相关专利" suffix-icon="el-icon-search"
                      style="width: 250px;margin-right: 10px;" v-model="page.searchKey"
                      @keyup.enter.native="getPatentList()">
            </el-input>
            <el-button size="small" type="primary" @click="getPatentList()">
                搜索
            </el-button>
        </span>
    </div>
    <%-- 表格 --%>
    <el-table :data="patentList" height="calc(100% - 116px)" v-loading="loading.table"
              style="width: 100%;overflow-y: hidden;margin-top: 10px;" class="scroll-bar"
              @selection-change="selectionList=$event" stripe>
        <el-table-column type="selection" width="40" fixed="left"></el-table-column>
        <el-table-column label="专利名" width="346" fixed="left" align="center" v-if="['-3','-2','-1'].contains(status)">
            <template slot-scope="{row}">
                <el-Tooltip open-delay="500" effect="dark" :content="row.patentName" placement="top">
                    <div style="overflow: hidden;text-overflow: ellipsis;white-space: nowrap;width: 95%;">
                        {{ row.patentName }}
                    </div>
                </el-Tooltip>
            </template>
        </el-table-column>
        <el-table-column label="专利名" width="100" fixed="left" align="center" v-else>
            <template slot-scope="{row}">
                <el-Tooltip open-delay="500" effect="dark" :content="row.patentName" placement="top">
                    <div style="overflow: hidden;text-overflow: ellipsis;white-space: nowrap;width: 95%;">
                        {{ row.patentName }}
                    </div>
                </el-Tooltip>
            </template>
        </el-table-column>
        <el-table-column label="作者列表" width="190" fixed="left" align="center">
            <template slot-scope="{row}">
                <el-Tooltip open-delay="500" effect="dark" :content="row.authorList" placement="top">
                    <div style="overflow: hidden;text-overflow: ellipsis;white-space: nowrap;width: 95%;">
                        {{ row.authorList }}
                    </div>
                </el-Tooltip>
            </template>
        </el-table-column>
        <el-table-column label="所属学院" width="150" prop="institute" fixed="left" align="center"
                         v-if="status == 4" key="ketInstitute0">
        </el-table-column>
        <el-table-column label="所属学院" width="150" fixed="left" align="center"
                         v-else-if="['1', '2', '3'].contains(status)" key="ketInstitute1">
            <template slot-scope="{row}">
                <template v-if="row.institute != null&&row.institute != ''" key="key3">
                   <span>
                       <span>
                           {{row.institute}}
                       </span>
                       <i-button style="height: 25px;position:relative;left: 4px;"
                              type="primary" size="small" @click="openInstituteSelect(row)">C</i-button>
                   </span>
                </template>
                <el-button v-else type="primary" size="small" key="ketInstitute2"
                           @click="openInstituteSelect(row)">手动选择学院
                </el-button>
            </template>
        </el-table-column>

        <el-table-column label="第一发明人" width="332" align="center"
                         v-if="['0','1', '2', '3', '4'].contains(status)">
            <template slot-scope="{row}">
                <%--如果有patent的firstAuthorId信息(证明当前已经匹配到这个人)--%>
                <span v-if="row.firstAuthorId != null && row.firstAuthorId !== ''"
                      style="display: flex;align-items: center;justify-content: space-between">
                    <%--作者id--%>
                    <div @click="openSearchUser(row, 1, row.firstAuthor.workId)">
                        {{ row.firstAuthor.workId }}
                    </div>
                    <%--第一作者名--%>
                    <el-Tooltip open-delay="500" effect="dark" :content="row.firstAuthor.realName" placement="top">
                        <div style="display: inline-block;overflow: hidden;text-overflow: ellipsis;white-space: nowrap;width: 100px;">
                            {{ row.firstAuthor.realName != null ? row.firstAuthor.realName : ''}}
                        </div>
                    </el-Tooltip>
                    <%--第一作者类别--%>
                    <div style="width: 65px;">
                        {{ row.firstAuthor.userType != null ? row.firstAuthor.userType : ''}}
                    </div>
                    <%--清除用户--%>
                    <i-button style="height: 25px;position:relative;left: 4px;"
                              type="warning" size="small" @click="clearAuthor(row, 1)">X</i-button>
                </span>
                <i-button v-else type="success" size="small"
                          @click="openSearchUser(row, 1, '')">手动匹配
                </i-button>
            </template>
        </el-table-column>
        <el-table-column label="第二发明人" width="332" align="center"
                         v-if="['0','1', '2', '3', '4'].contains(status)">
            <template slot-scope="{row}">
                <span v-if="row.secondAuthorId !== null && row.secondAuthorId !== ''"
                      style="display: flex;align-items: center;justify-content: space-between">
                    <div @click="openSearchUser(row, 2, row.secondAuthor.workId)">
                        {{ row.secondAuthor.workId }}
                    </div>
                    <el-Tooltip open-delay="500" effect="dark" :content="row.secondAuthor.realName" placement="top">
                        <div style="display: inline-block;overflow: hidden;text-overflow: ellipsis;white-space: nowrap;width: 100px;">
                            {{ row.secondAuthor.realName != null ? row.secondAuthor.realName : '' }}
                        </div>
                    </el-Tooltip>
                    <div>{{ row.secondAuthor.userType != null ? row.secondAuthor.userType : '' }}</div>
                    <i-button style="height: 25px;position:relative;left: 4px;"
                              type="warning" size="small" @click="clearAuthor(row, 2)">X</i-button>
                </span>
                <i-button v-else type="success" size="small"
                          @click="openSearchUser(row, 2, '')">手动匹配
                </i-button>
            </template>
        </el-table-column>
        <el-table-column label="专利号" width="170" prop="patentNumber" align="center">
            <template slot-scope="{row}">
                {{ row.patentNumber}}
            </template>
        </el-table-column>
        <el-table-column label="专利类别" width="100" prop="patentType" align="center">
            <template slot-scope="{row}">
                {{ row.patentType}}
            </template>
        </el-table-column>
        <el-table-column label="专利权人" width="150" prop="patentRightPerson" align="center">
            <template slot-scope="{row}">
                <el-Tooltip open-delay="500" effect="dark" :content="row.patentRightPerson" placement="top">
                    <div style="overflow: hidden;text-overflow: ellipsis;white-space: nowrap;">
                        {{ row.patentRightPerson}}
                    </div>
                </el-Tooltip>
            </template>
        </el-table-column>
        <el-table-column label="授权公告日" width="150"
                         prop="patentAuthorizationDate"
                         align="center"
                         v-if="['-1', '-2', '-3'].contains(status)">
            <template slot-scope="{row}">
                {{ row.patentAuthorizationDateString }}
            </template>
        </el-table-column>
        <el-table-column label="授权公告日" width="150"
                         prop="patentAuthorizationDate"
                         align="center"
                         v-else>
            <template slot-scope="{row}">
                {{ row.patentAuthorizationDate === null ? '' : (new
                Date(row.patentAuthorizationDate)).Format("yyyy-MM-dd") }}
            </template>
        </el-table-column>
        <el-table-column></el-table-column>
        <el-table-column label="操作" width="160" header-align="center" align="center" fixed="right">
            <template slot-scope="{row}">
                <span style="position:relative;bottom: 1px;">
                    <el-button type="primary" size="mini"
                               style="margin-right: 0;"
                               @click="completePatent([{id:row.id}])"
                               v-if="status === '2'">
                        <span>转入完成</span>
                    </el-button>
                    <el-button type="success" size="mini"
                               style="margin-right: 0;"
                               @click="convertToSuccessByIds([{id:row.id}])"
                               :disabled="!['0','1','3','4'].contains(status)"
                               v-else>
                        <span>转入成功</span>
                    </el-button>
                    <el-button type="danger" size="mini" style=""
                               @click="deletePatentByIds([{id: row.id}])">
                        <span>删除</span>
                    </el-button>
                </span>
            </template>
        </el-table-column>
    </el-table>
    <%-- 分页 --%>
    <el-pagination style="text-align: center;margin: 9px auto;"
                   @size-change="page.pageSize=$event;getPatentList()"
                   @current-change="page.pageIndex=$event;getPatentList()"
                   :current-page="page.pageIndex"
                   :page-sizes="page.pageSizes"
                   :page-size="page.pageSize"
                   :total="page.total"
                   layout="total, sizes, prev, pager, next, jumper">
    </el-pagination>
    <%-- 选择用户 dialog --%>
    <el-dialog title="手动匹配发明人" :visible.sync="searchUserDialog.visible" class="dialog-searchUser">
        <div v-loading="searchUserDialog.loading" style="height: 450px;">
            <iframe v-if="searchUserDialog.visible" :src="searchUserUrl"
                    style="width: 100%;height: 450px;overflow-y: auto;border: 0;"
                    @load="searchUserDialog.loading=false;"></iframe>
        </div>
    </el-dialog>
    <%--选择学院 dialog--%>
    <el-dialog title="选择专利所属学院"
               width="250px" center
               :before-close="cancelInstituteSelect"
               :visible.sync="searchInstituteDialog.visible">
        <div v-loading="searchInstituteDialog.loading">
            <el-select v-model="searchInstituteDialog.selectedInstitute"
                       filterable clearable
                       placeholder="请选择专利的学院">
                <el-option v-for="(item, index) in searchInstituteDialog.instituteList"
                           :key="item.id"
                           :value="item.name"
                           :label="item.name"></el-option>
            </el-select>
        </div>
        <span slot="footer" class="dialog-footer">
                <el-button size="small" @click="cancelInstituteSelect">取 消</el-button>
                <el-button size="small" type="primary" @click="ensureInstituteSelect">确 定</el-button>
        </span>
    </el-dialog>
</div>
<%@include file="/WEB-INF/views/include/blankScript.jsp" %>
<script type="text/javascript">
    var app = new Vue({
        el: '#app',
        data: {
            loading: {
                fullScreen: false,
                table: false
            },
            status: '-1',   // 当前的状态
            statusList: [
                {
                    value: '-1',
                    label: '1.  未初始化'
                },
                {
                    value: '-3',
                    label: '2.1 缺少发明人信息'
                },
                {
                    value: '-2',
                    label: '2.2 专利权人不是北理被过滤'
                },
                {
                    value: '0',
                    label: '2.3 初始化完成(暂未匹配)'
                },
                {
                    value: '1',
                    label: '3.1 匹配出错'
                },
                {
                    value: '2',
                    label: '3.2 匹配成功'
                },
                {
                    value: '3',
                    label: '3.3 需要人工判断'
                },
                {
                    value: '4',
                    label: '4.  匹配完成'
                }
            ],
            patentList: [],
            selectionList: [],  // 已选中的专利列表
            page: {
                pageIndex: 1,
                pageSize: 10,
                pageSizes: [5, 10, 20, 40],
                searchKey: '',  // 搜索词
                total: 0,       // 总数
            },
            urls: {
                getPatentList: '/api/patent/selectListByPage',
                deletePatentByIds: '/api/patent/deleteListByIds',
                initAllPatent: '/api/patent/initAllPatent',
                deletePatentByStatus: '/api/patent/deletePatentByStatus',
                patentUserMatch: '/api/patent/patentUserMatch',
                convertToSuccessByIds: '/api/patent/convertToSuccessByIds',
                convertToCompleteByIds: '/api/patent/convertToCompleteByIds',
                patentUserSearch: '/functions/patent/searchUser',
                setPatentAuthor: '/api/patent/setPatentAuthor',
                selectDanweiNicknamesAllList: '/api/doc/danweiNicknames/selectAllList',
                changeInstitute: '/api/patent/changeInstitute'
            },
            searchUserDialog: {
                visible: false,
                loading: false,
            },
            searchInstituteDialog: {
                visible: false,
                loading: false,
                patentNow: {},
                instituteList: [],
                selectedInstitute: '',
            },
            searchUserUrl: ''
        },
        methods: {}
    });

    //获取专利列表
    function getPatentList() {
        let data = {
            page: app.page,
            status: app.status
        };
        app.loading.table = true;
        ajaxPostJSON(app.urls.getPatentList, data, function (d) {
            app.loading.table = false;
            app.patentList = d.data.resultList;
            app.page.total = d.data.total;
        });
    }

    // 初始化专利状态是-1的
    function initAllPatent() {
        window.parent.app.showConfirm(() => {
            app.loading.table = true;
            ajaxPost(app.urls.initAllPatent, null, function (d) {
                app.loading.table = false;
                app.status = '0';
                getPatentList();
            }, null)
        });
    }

    //专利用户匹配所有status是0的
    function patentUserMatch() {
        window.parent.app.showConfirm(() => {
            app.loading.table = true;
            ajaxPost(app.urls.patentUserMatch, null, function (d) {
                app.loading.table = false;
                app.status = '2';
                getPatentList();
            })
        });
    }

    //根据ids删除专利
    function deletePatentByIds(ids) {
        if (ids.length === 0) {
            window.parent.app.showMessage('请先选择需要删除的专利！', 'warning');
            return;
        }
        window.parent.app.showConfirm(function () {
            let data = ids;
            app.loading.table = true;
            ajaxPostJSON(app.urls.deletePatentByIds, data, function (d) {
                app.loading.table = false;
                window.parent.app.showMessage('删除成功！', 'success');
                getPatentList();
            })
        });
    }

    //根据status删除专利
    function deletePatentByStatus() {
        window.parent.app.showConfirm(function () {
            app.loading.table = true;
            let data = {
                status: app.status
            };
            ajaxPost(app.urls.deletePatentByStatus, data, function (d) {
                app.loading.table = false;
                getPatentList();
                window.parent.app.showMessage("删除成功");
            })
        });
    }

    //转入成功(仅仅对于status是0，1，3的生效)
    function convertToSuccessByIds(ids) {
        window.parent.app.showConfirm(function () {
            let data = ids;
            app.loading.table = true;
            ajaxPostJSON(app.urls.convertToSuccessByIds, data, function (d) {
                app.loading.table = false;
                window.parent.app.showMessage('操作成功！', 'success');
                getPatentList();
            }, function (d) {
                app.loading.table = false;
                window.parent.app.showMessage('操作失败！', 'error');
            })
        });
    }

    // 打开选择用户对话框: targetAuthorIndex (1 - firstAuthor, 2 - secondAuthor)
    function openSearchUser(row, authorIndex, workId) {
        let authorName = '';
        if (authorIndex === 1) {
            if (row.firstAuthor) {
                authorName = row.firstAuthor.realName;
            } else {
                authorName = row.firstAuthorName;
            }
        } else {
            if (row.secondAuthor) {
                authorName = row.secondAuthor.realName;
            } else {
                authorName = row.secondAuthorName;
            }
        }
        app.searchUserUrl = app.urls.patentUserSearch
            + "?patentId=" + row.id + "&authorIndex=" + authorIndex
            + '&searchKey=' + authorName + '&institute=' + (row.institute ? row.institute : '')
            + '&authorizationDate=' + (row.patentAuthorizationDate ? row.patentAuthorizationDate : '')
            + '&workId=' + workId;
        console.log(app.searchUserUrl);
        app.searchUserDialog.visible = true;
        app.searchUserDialog.loading = true;
    }

    //打开选择学院对话框
    function openInstituteSelect(row) {
        app.searchInstituteDialog.visible = true;
        app.searchInstituteDialog.loading = true;
        app.searchInstituteDialog.patentNow = row;
        ajaxPostJSON(app.urls.selectDanweiNicknamesAllList, null, function (d) {
            app.searchInstituteDialog.instituteList = d.data;
            app.searchInstituteDialog.loading = false;
        });
    }

    // 清空第一或第二作者
    function clearAuthor(patent, authorIndex) {
        window.parent.app.showConfirm(function () {
            let data = {
                patentId: patent.id,
                authorIndex: authorIndex,
                authorId: null
            };
            app.loading.table = true;
            ajaxPost(app.urls.setPatentAuthor, data, function (d) {
                app.loading.table = false;
                if (authorIndex === 1)
                    patent.firstAuthorId = null;
                else
                    patent.secondAuthorId = null;
            })
        });
    }

    //全部完成或者把选中的完成
    function completeAllPatent() {
        window.parent.app.showConfirm(function () {
            //判断有没有选中：
            if (app.selectionList.length === 0) {
                //1：全部转到成功
                ajaxPost("/api/patent/convertToCompleteAll", null,
                    function success(res) {
                        app.loading.table = false;
                        window.parent.app.showMessage('操作成功！', 'success');
                        app.status = '4';
                        getPatentList();
                    },
                    function error() {
                        app.loading.table = false;
                        window.parent.app.showMessage('操作失败！', 'error');
                    }
                );
            } else {
                //2.仅仅把选中的完成
                completePatent(app.selectionList);
            }
        })
    }

    //根据ids把专利设置成完成状态
    function completePatent(ids) {
        console.log(ids);
        window.parent.app.showConfirm(function () {
            let data = ids;
            app.loading.table = true;
            ajaxPostJSON(app.urls.convertToCompleteByIds, data, function (d) {
                app.loading.table = false;
                window.parent.app.showMessage('操作成功！', 'success');
                getPatentList();
            }, function (d) {
                app.loading.table = false;
                window.parent.app.showMessage('操作失败！', 'error');
            })
        });
    }

    //取消选择学院
    function cancelInstituteSelect() {
        app.searchInstituteDialog.visible = false;
        app.searchInstituteDialog.patentNow = {};
        app.searchInstituteDialog.selectedInstitute = '';
    }

    //确定选择学院
    function ensureInstituteSelect() {
        let data = {
            patentId: app.searchInstituteDialog.patentNow.id,
            institute: app.searchInstituteDialog.selectedInstitute
        };
        console.log(data);
        ajaxPost(app.urls.changeInstitute, data, function (res) {
            console.log(res.message);
            cancelInstituteSelect();
            window.parent.app.showMessage('操作成功', 'success');
            getPatentList();
        })
    }

    window.onload = function () {
        getPatentList();
    }
</script>
</body>
</html>
