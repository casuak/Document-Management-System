<%--
  Created by IntelliJ IDEA.
  User: zm
  Date: 2019/4/23
  Time: 10:55
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>作者详情</title>
    <%@include file="/WEB-INF/views/include/blankHead.jsp" %>
    <link rel="stylesheet" href="/static/css/tableTemplate.css"/>
    <%--<link rel="stylesheet" href="/static/css/"/>--%>
    <style>

    </style>
</head>
<body>
<div id="app" style="background: white;height: 100%;overflow: hidden;" v-cloak v-loading="fullScreenLoading">
    <el-tabs id="tabs"
             :tab-position="tabPosition"
             v-model="docSelected"
             type="border-card">

        <%--author个人信息模块--%>
        <el-tab-pane name="authorInfo" label="作者信息">
           <div  id="authorInfo">
               <h2>作者职位</h2>
               <el-row>
                   <el-col :span="8">
                       <div style="width: 150px;height: 150px;padding: 10px 10px;background-color: #a9acb3">
                           <img style="height: 100%;width: 100%" src="/static/images/lm.jpg" alt="null">
                       </div>
                   </el-col>
                   <el-col :span="16">
                       <p><span>姓名：</span></p>
                       <p><span>所在学科：</span></p>
                       <p><span>身份/职称：</span></p>
                       <p><span>联系电话：</span></p>
                       <p><span>联系邮箱：</span></p>
                   </el-col>
               </el-row>
               <br>
               <el-collapse v-model="activeNames" @change="handleCollapseChange">
                   <el-collapse-item title="个人信息" name="1">
                       <div>与现实生活一致：与现实生活的流程、逻辑保持一致，遵循用户习惯的语言和概念；</div>
                       <div>在界面中一致：所有的元素和结构需保持一致，比如：设计样式、图标和文本、元素的位置等。</div>
                   </el-collapse-item>
                   <el-collapse-item title="科研方向" name="2">
                       <div>控制反馈：通过界面样式和交互动效让用户可以清晰的感知自己的操作；</div>
                       <div>页面反馈：操作后，通过页面元素的变化清晰地展现当前状态。</div>
                   </el-collapse-item>
                   <el-collapse-item title="代表性学术成果" name="3">
                       <div>简化流程：设计简洁直观的操作流程；</div>
                       <div>清晰明确：语言表达清晰且表意明确，让用户快速理解进而作出决策；</div>
                       <div>帮助用户识别：界面简单直白，让用户快速识别而非回忆，减少用户记忆负担。</div>
                   </el-collapse-item>
                   <el-collapse-item title="备注" name="4">
                       <div>用户决策：根据场景可给予用户操作建议或安全提示，但不能代替用户进行决策；</div>
                       <div>结果可控：用户可以自由的进行操作，包括撤销、回退和终止当前操作等。</div>
                   </el-collapse-item>
               </el-collapse>
           </div>
        </el-tab-pane>

        <%--论文Tab--%>
        <el-tab-pane name="paper" label="论文">
            <el-main>
                <%-- 顶栏 --%>
                <div style="padding: 15px 20px 0 15px;">
                    <span class="button-group">
                        <el-button size="small" type="success" @click="dialog.insertPaper.visible=true">
                            <span>添加</span>
                        </el-button>
                        <el-button size="small" type="danger" @click="deletePaperListByIds(table.entity.selectionList)"
                                   style="margin-left: 10px;">
                            <span>批量删除</span>
                        </el-button>
                    </span>
                    <span style="float: right;margin-right: 10px;">
                        <el-input size="small" placeholder="输入相关论文名称搜索论文" suffix-icon="el-icon-search"
                                  style="width: 250px;margin-right: 10px;" v-model="table.paperTable.entity.params.searchKey"
                                  @keyup.enter.native="table.paperTable.entity.params.pageIndex=1;refreshTable_paper()">
                        </el-input>
                        <el-button size="small" type="primary" style="position:relative;"
                                   @click="table.paperTable.entity.params.pageIndex=1;refreshTable_paper()">
                            <span>搜索</span>
                        </el-button>
                    </span>
                </div>
                <%-- entity表格 --%>
                <el-table :data="table.paperTable.entity.data"
                          id="paperTable"
                          v-loading="table.paperTable.entity.loading"
                          height="calc(100% - 150px)"
                          style="width: 100%;overflow-y: hidden;margin-top: 20px;"
                          class="scroll-bar"
                          @selection-change="onSelectionChange_paper" stripe>
                    <el-table-column type="selection" width="40"></el-table-column>
                    <el-table-column
                            prop="paperName"
                            label="论文名">
                    </el-table-column>
                    <el-table-column
                            prop="ISSN"
                            label="ISSN">
                    </el-table-column>
                    <el-table-column
                            prop="docType"
                            label="论文种类">
                    </el-table-column>
                    <el-table-column
                            prop="firstAuthorName"
                            label="第一作者">
                    </el-table-column>
                    <el-table-column
                            prop="secondAuthorName"
                            label="第二作者">
                    </el-table-column>
                    <el-table-column
                            prop="publishDate"
                            label="出版日期">
                    </el-table-column>

                    <%--<el-table-column label="创建时间">
                        <template slot-scope="scope">
                            {{ formatTimestamp(scope.row.createDate) }}
                        </template>
                    </el-table-column>--%>
                    <el-table-column label="操作" width="190" header-align="center" align="center">
                        <template slot-scope="scope">
                            <el-button type="warning" size="mini" style="position:relative;bottom: 1px;"
                                       @click="openDialog_updatePaper(scope.row)">
                                <span>编辑</span>
                            </el-button>
                            <el-button type="danger" size="mini" style="position:relative;bottom: 1px;margin-left: 6px;"
                                       @click="deletePaperListByIds([{id: scope.row.id}])">
                                <span>删除</span>
                            </el-button>
                        </template>
                    </el-table-column>
                    <el-table-column width="50"></el-table-column>
                </el-table>
                <%-- entity分页 --%>
                <el-pagination style="text-align: center;margin: 8px auto;"
                               @size-change="onPageSizeChange_paper"
                               @current-change="onPageIndexChange_paper"
                               :current-page="table.paperTable.entity.params.pageIndex"
                               :page-sizes="table.paperTable.entity.params.pageSizes"
                               :page-size="table.paperTable.entity.params.pageSize"
                               :total="table.paperTable.entity.params.total"
                               layout="total, sizes, prev, pager, next, jumper">
                </el-pagination>
                <%-- entity添加窗口 --%>
                <el-dialog title="添加" :visible.sync="dialog.insertPaper.visible"
                           @closed="resetForm('form_insertPaper')">
                    <el-form label-position="left" label-width="80px" style="padding: 0 100px;"
                             :model="dialog.insertPaper.formData" :rules="dialog.insertPaper.rules"
                             ref="form_insertPaper" v-loading="dialog.insertPaper.loading" status-icon>
                        <el-form-item label="角色名" prop="name">
                            <el-input v-model="dialog.insertPaper.formData.name"></el-input>
                        </el-form-item>
                        <el-form-item label="角色代码" prop="code">
                            <el-input v-model="dialog.insertPaper.formData.code"></el-input>
                        </el-form-item>
                    </el-form>
                    <div slot="footer" class="dialog-footer">
                        <el-button size="medium" @click="dialog.insertPaper.visible=false">取 消</el-button>
                        <el-button size="medium" type="primary" @click="insertPaper()" style="margin-left: 10px;">提 交
                        </el-button>
                    </div>
                </el-dialog>
                <%-- entity编辑窗口 --%>
                <el-dialog title="编辑" :visible.sync="dialog.updatePaper.visible"
                           @closed="resetForm('form_updatePaper')">
                    <el-form label-position="left" label-width="80px"
                             style="padding: 0 100px;overflow-y: scroll;"
                             :model="dialog.updatePaper.formData" :rules="dialog.updatePaper.rules"
                             ref="form_updatePaper" v-loading="dialog.updatePaper.loading" status-icon size="medium">
                        <el-form-item label="角色名" prop="name">
                            <el-input v-model="dialog.updatePaper.formData.name"></el-input>
                        </el-form-item>
                        <el-form-item label="角色代码" prop="code">
                            <el-input v-model="dialog.updatePaper.formData.code"></el-input>
                        </el-form-item>
                    </el-form>
                    <div slot="footer" class="dialog-footer">
                        <el-button size="medium" @click="dialog.updatePaper.visible=false">取 消</el-button>
                        <el-button size="medium" type="primary" @click="updatePaper()" style="margin-left: 10px;">提 交
                        </el-button>
                    </div>
                </el-dialog>
            </el-main>
        </el-tab-pane>

        <%--专利Tab--%>
        <el-tab-pane name="patent" label="专利">

        </el-tab-pane>
        <%--著作权Tab--%>
        <el-tab-pane name="copyright" label="著作权">

        </el-tab-pane>
    </el-tabs>
</div>

<%@include file="/WEB-INF/views/include/blankScript.jsp" %>
<%--<script src="/static/js/"></script>--%>
<script>
    var app = new Vue({
        el: '#app',
        data: {
            /*当前激活的折叠面板*/
            activeNames: ['1'],
            /*分页位置*/
            tabPosition: 'top',
            /*绑定当前的表格*/
            docSelected: "paper",
            urls: {
                paper:{
                    insertPaper: '',
                    deletePaperListByIds: '',
                    updatePaper: '',
                    selectPaperListByPage: '/api/doc/search/selectPaperListByPage2',
                },
                patent:{
                    insertPaper: '',
                    deletePaperListByIds: '',
                    updatePaper: '',
                    selectPatentListByPage: '',
                },
                copyright:{
                    insertPaper: '',
                    deletePaperListByIds: '',
                    updatePaper: '',
                    selectCopyrightListByPage: '',
                }
            },
            fullScreenLoading: false,
            table: {
                paperTable:{
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
                patentTable:{
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
                copyrightTable:{
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
                }
            },
            dialog: {
                insertPaper: {
                    visible: false,
                    loading: false,
                    formData: {},
                    rules: {},
                },
                updatePaper: {
                    visible: false,
                    loading: false,
                    formData: {},
                    rules: {},
                },
            },
            options: {},
        },
        methods: {
            /*折叠面板绑定事件*/
            handleCollapseChange(val) {
                console.log(val);
            },
            insertPaper: function () {
                // 首先检测表单数据是否合法
                this.$refs['form_insertPaper'].validate((valid) => {
                    if (valid) {
                        let data = this.dialog.insertPaper.formData;
                        let app = this;
                        app.dialog.insertPaper.loading = true;
                        ajaxPostJSON(app.urls.paper.insertPaper, data, function (d) {
                            app.dialog.insertPaper.loading = false;
                            app.dialog.insertPaper.visible = false;
                            window.parent.app.showMessage('添加成功！', 'success');
                            app.refreshTable_paper(); // 添加完成后刷新页面
                        }, function () {
                            app.dialog.insertPaper.loading = false;
                            app.dialog.insertPaper.visible = false;
                            window.parent.app.showMessage('添加失败！', 'error');
                        });
                    } else {
                        console.log("表单数据不合法！");
                        return false;
                    }
                });
            },
            deletePaperListByIds: function (val) {
                if (val.length === 0) {
                    window.parent.app.showMessage('提示：未选中任何项', 'warning');
                    return;
                }
                window.parent.app.$confirm('确认删除选中的项', '警告', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(() => {
                    let data = val;
                    let app = this;
                    app.fullScreenLoading = true;
                    ajaxPostJSON(this.urls.paper.deletePaperListByIds, data, function (d) {
                        app.fullScreenLoading = false;
                        window.parent.app.showMessage('删除成功！', 'success');
                        app.refreshTable_paper();
                    })
                }).catch(() => {
                    window.parent.app.showMessage('已取消删除', 'warning');
                });
            },
            updatePaper: function () {
                // 首先检测表单数据是否合法
                this.$refs['form_updatePaper'].validate((valid) => {
                    if (valid) {
                        let data = this.dialog.updatePaper.formData;
                        let app = this;
                        app.dialog.updatePaper.loading = true;
                        ajaxPostJSON(app.urls.paper.updatePaper, data, function (d) {
                            app.dialog.updatePaper.loading = false;
                            app.dialog.updatePaper.visible = false;
                            window.parent.app.showMessage('编辑成功！', 'success');
                            app.refreshTable_paper(); // 编辑完成后刷新页面
                        }, function () {
                            app.dialog.updatePaper.loading = false;
                            app.dialog.updatePaper.visible = false;
                            window.parent.app.showMessage('编辑失败！', 'error');
                        });
                    } else {
                        console.log("表单数据不合法！");
                        return false;
                    }
                });
            },

            selectPaperListByPage: function () {
                let data = {
                    authorList:"${author.id}",                        //借用authorList来暂存一下authorId
                    page: this.table.paperTable.entity.params
                };
                let app = this;
                app.table.paperTable.entity.loading = true;
                ajaxPostJSON(this.urls.paper.selectPaperListByPage, data, function (d) {
                    console.log("查询paper返回：");
                    console.log(d.data.resultList);
                    app.table.paperTable.entity.loading = false;
                    app.table.paperTable.entity.data = d.data.resultList;
                    app.table.paperTable.entity.params.total = d.data.total;
                });
            },

            // 刷新paper table数据
            refreshTable_paper: function () {
                this.selectPaperListByPage();
            },
            // 打开编辑paper窗口
            openDialog_updatePaper: function (row) {
                this.dialog.updatePaper.visible = true;
                this.dialog.updatePaper.formData = copy(row);
            },
            // 处理选中的行变化
            onSelectionChange_paper: function (val) {
                this.table.entity.selectionList = val;
            },
            // 处理paper的pageSize变化
            onPageSizeChange_paper: function (newSize) {
                this.table.paperTable.entity.params.pageSize = newSize;
                this.refreshTable_paper();
            },
            // 处理paper的pageIndex变化
            onPageIndexChange_paper: function (newIndex) {
                this.table.paperTable.entity.params.pageIndex = newIndex;
                this.refreshTable_paper();
            },

            // 重置表单
            resetForm: function (ref) {
                this.$refs[ref].resetFields();
            },
        },
        mounted: function () {
            this.refreshTable_paper();
        }
    });

    function test() {
        console.log(app.docSelected);
    }

    /*获取app高度*/
    function getAppHeight(){
        return document.getElementById("app").clientHeight;
    }

    function setMainHeight(){
        let mains = document.getElementsByClassName("el-main");
        let appHeight = getAppHeight();
        for (let i = 0; i < mains.length; i++) {
            console.log(getAppHeight());
            mains[0].style.height = appHeight + "px";
        }

        document.getElementById("authorInfo").style.height= appHeight + 'px';
    }

    window.onload = function () {
       setMainHeight();
    };

    window.onresize = function () {
        setMainHeight();
    }
</script>
</body>
</html>