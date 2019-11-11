let app = new Vue({
    el: '#app',
    data: {
        urls: {
            getUserList: "/api/sys/user/getList",
            putUser: '/api/sys/user/put',
            updateUser: '/api/sys/user/update',
            deleteUserList: '/api/sys/user/deleteList',
            getAllRoleList: '/api/sys/role/selectAllList',
            updateUserRole: '/api/sys/map/userRole/update',
            initUser: '/api/sys/user/initUser',
            getSchoolList: '/api/sys/user/getSchoolList',
            getMajorList: '/api/sys/user/getMajorList'
        },
        fullScreenLoading: false,
        table: {
            data: [],
            loading: false,
            selectionList: [],
            params: {
                pageIndex: 1,
                pageSize: 10,
                pageSizes: [5, 10, 20, 40],
                searchKey: '',  // 搜索词
                total: 2,       // 总数
                userType: ''
            }
        },
        dialog: {
            insertOrUpdate: {
                visible: false,
                loading: false,
                formData: {
                    id: '',
                    username: '',
                    password: '',
                    userType: '',
                    realName: '',
                    nicknames: '',
                    isMaster: '',
                    isDoctor: '',
                    school: '',
                    major: '',
                    studentTrainLevel: '',
                    studentDegreeType: '',
                    tutorWorkId: '',
                    tutorName: '',
                    tutorNicknames: ''
                },
                rules: {
                    username: [
                        {validator: validateUsername, trigger: 'blur'},
                        {validator: validateUsername, trigger: 'change'},
                    ],
                    password: [
                        {required: true, message: '密码不能为空', trigger: 'blur'},
                        {required: true, message: '密码不能为空', trigger: 'change'},
                    ],
                    nothing: [
                        {required: true, message: '密码不能为空', trigger: 'blur'},
                    ]
                },
                status: '', // insert or update
                userTypeList: [
                    {label: '管理员', value: 'admin'},
                    {label: '教师', value: 'teacher'},
                    {label: '学生', value: 'student'}
                ],
                schoolList: [],
                majorList: []
            },
            mapRole: {
                visible: false,
                loading: false,
                currentUser: null
            }
        },
        roleTree: [],
        options: {
            userType: [
                {
                    label: '学生',
                    value: 'student'
                },
                {
                    label: '老师',
                    value: 'teacher'
                },
                {
                    label: '博士后',
                    value: 'doctor'
                },
                {
                    label: '其他',
                    value: 'other'
                }
            ]
        }
    },
    methods: {
        // 处理选中的行变化
        handleSelectionChange: function (val) {
            this.table.selectionList = val;
        },
        // 处理pageSize变化
        handleSizeChange: function (newSize) {
            this.table.params.pageSize = newSize;
            this.getUserList();
        },
        // 处理pageIndex变化
        handleCurrentChange: function (newIndex) {
            this.table.params.pageIndex = newIndex;
            this.getUserList();
        },
        // 刷新table的数据
        getUserList: function () {
            let data = {
                page: this.table.params,
                userType: this.table.params.userType
            };
            let app = this;
            this.table.loading = true;
            ajaxPostJSON(this.urls.getUserList, data, function (d) {
                app.table.loading = false;
                app.table.data = d.data.resultList;
                app.table.params.total = d.data.total;
            }, function () {
                app.table.loading = false;
                window.parent.app.showMessage('查找失败！', 'error');
            });
        },
        // 重置表单
        resetForm: function (ref) {
            this.$refs[ref].resetFields();
        },
        // 删除指定id的用户
        deleteUser: function (val, type = 'multi') {
            // 未选中任何用户的情况下点选批量删除
            if (type === 'multi' && val.length == 0) {
                window.parent.app.showMessage('提示：未选中任何用户', 'warning');
                return;
            }
            window.parent.app.$confirm('确认删除选中的用户', '警告', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                let idList = [];
                if (type === 'single') {
                    let id = val;
                    idList.push({
                        id: id
                    });
                } else {
                    let selectionList = val;
                    for (let i = 0; i < selectionList.length; i++) {
                        idList.push({
                            id: selectionList[i].id
                        });
                    }
                }
                let data = idList;
                let app = this;
                app.fullScreenLoading = true;
                ajaxPostJSON(app.urls.deleteUserList, data, function (d) {
                    app.fullScreenLoading = false;
                    window.parent.app.showMessage('删除成功！', 'success');
                    // if (app.table.data.length === 1 && app.table.params.pageIndex > 0)
                    //     app.table.params.pageIndex -= 1;
                    app.getUserList();
                })
            }).catch(() => {
                window.parent.app.showMessage('已取消删除', 'warning');
            });
        },
        // 打开关联角色窗口
        openMapRole: function (user) {
            let app = this;
            app.dialog.mapRole.visible = true;
            let idList = [];
            for (let i = 0; i < user.roleList.length; i++) {
                idList.push(user.roleList[i].id);
            }
            app.dialog.mapRole.currentUser = user;
            setTimeout(() => {
                app.$refs.tree.setCheckedKeys(idList);
            }, 10);
        },
        // 更新用户和角色的关联
        updateUserRole: function () {
            let app = this;
            let data = copy(app.dialog.mapRole.currentUser);
            data.roleList = [];
            let idList = app.$refs.tree.getCheckedKeys();
            for (let i = 0; i < idList.length; i++) {
                data.roleList.push({id: idList[i]});
            }
            app.dialog.mapRole.loading = true;
            ajaxPostJSON(app.urls.updateUserRole, data, function (d) {
                app.dialog.mapRole.loading = false;
                window.parent.app.showMessage('保存成功!');
            })
        },
        // 打开添加用户窗口
        openInsert: function () {
            this.dialog.insertOrUpdate.visible = true;
            this.dialog.insertOrUpdate.status = 'insert';
        },
        // 打开编辑用户窗口
        openUpdate: function (user) {
            this.dialog.insertOrUpdate.visible = true;
            this.dialog.insertOrUpdate.status = 'update';
            this.dialog.insertOrUpdate.formData = copy(user);
        },
        // 添加或编辑用户信息
        insertOrUpdate: function () {
            this.$refs['form_insertOrUpdate'].validate((valid) => {
                if (valid) {
                    // this.dialog.insertOrUpdate.formData.tutorName = this.dialog.insertOrUpdate.tutor.realName;
                    // this.dialog.insertOrUpdate.formData.tutorNicknames = this.dialog.insertOrUpdate.tutor.nicknames;
                    // this.dialog.insertOrUpdate.formData.tutorWorkId = this.dialog.insertOrUpdate.tutor.workId;

                    let data = this.dialog.insertOrUpdate.formData;
                    let app = this;
                    let url = app.dialog.insertOrUpdate.status === 'insert' ? app.urls.putUser : app.urls.updateUser;
                    app.dialog.insertOrUpdate.loading = true;
                    ajaxPostJSON(url, data, function (d) {
                        app.dialog.insertOrUpdate.loading = false;
                        app.dialog.insertOrUpdate.visible = false;
                        let successMes = app.dialog.insertOrUpdate.status === 'insert' ? '添加成功!' : '编辑成功!';
                        window.parent.app.showMessage(successMes, 'success');
                        app.getUserList(); // 添加完成后刷新页面
                    }, function () {
                        app.dialog.insertOrUpdate.loading = false;
                        app.dialog.insertOrUpdate.visible = false;
                        let errorMes = app.dialog.insertOrUpdate.status === 'insert' ? '添加失败!' : '编辑失败!';
                        window.parent.app.showMessage(errorMes, 'error');
                    });
                } else {
                    console.log("表单数据不合法！");
                    return false;
                }
            });
            // let data = this.dialog.insertOrUpdate.formData;
        },
        // 翻译
        translateUserType: function (en) {
            let cn = '';
            if (en === 'teacher') {
                cn = '老师';
            } else if (en === 'student') {
                cn = '学生';
            } else if (en === 'doctor') {
                cn = '博士后';
            }
            return cn;
        },
        initUser: function () {
            let app = this;
            window.parent.app.showConfirm(() => {
                app.fullScreenLoading = true;
                ajaxPost(app.urls.initUser, null, function (d) {
                    app.fullScreenLoading = false;
                })
            });
        },
        translateStatus: function (status) {
            let cn = '';
            switch (status) {
                case '0':
                    cn = '未初始化';
                    break;
                case '1':
                    cn = '初始化完成';
                    break;
                default:
                    cn = 'error';
                    break;
            }
            return cn;
        },
        resetDialog: function () {
            this.dialog.insertOrUpdate.formData.id = '';
            this.dialog.insertOrUpdate.formData.username = '';
            this.dialog.insertOrUpdate.formData.password = '';
            this.dialog.insertOrUpdate.formData.userType = '';
            this.dialog.insertOrUpdate.formData.realName = '';
            this.dialog.insertOrUpdate.formData.nicknames = '';
            this.dialog.insertOrUpdate.formData.isMaster = '';
            this.dialog.insertOrUpdate.formData.isDoctor = '';
            this.dialog.insertOrUpdate.formData.school = '';
            this.dialog.insertOrUpdate.formData.major = '';
            this.dialog.insertOrUpdate.formData.studentDegreeType = '';
            this.dialog.insertOrUpdate.formData.studentTrainLevel = '';
            this.dialog.insertOrUpdate.formData.tutorWorkId = '';
            this.dialog.insertOrUpdate.formData.tutorNicknames = '';
            this.dialog.insertOrUpdate.formData.tutorName = '';
        }
    },
    mounted: function () {
        // 获取角色列表
        let data = null;
        let app = this;
        app.fullScreenLoading = true;
        ajaxPost(this.urls.getAllRoleList, data, function (d) {
            app.roleTree = d.data;
            app.getUserList();
        });

        //获取学院列表
        ajaxPost(this.urls.getSchoolList, null, function (d) {
            d.data.forEach(function (v) {
                app.dialog.insertOrUpdate.schoolList.push(v);
            })
        });
        //获取学科列表
        ajaxPost(this.urls.getMajorList, null, function (d) {
            d.data.forEach(function (v) {
                app.dialog.insertOrUpdate.majorList.push(v);
            })
        });
        app.fullScreenLoading = false;
    }
});

/**
 * 验证用户名
 * @param rule
 * @param value
 * @param callback
 */
function validateUsername(rule, value, callback) {
    let url = '/api/sys/user/checkUsername';
    let data = {
        username: value
    };
    if (value == null || value.length === 0) {
        callback(new Error('用户名不能为空'));
        return;
    }
    ajaxPostJSON(url, data, function (d) {
        if (d.code === 'error') {
            callback(new Error('用户名已被注册'));
            callback(new Error('用户名已被注册'));
        } else {
            callback();
        }
    })
}
