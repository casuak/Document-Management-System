-- 初始化数据库
drop database if exists docManager;
create database docManager;
ALTER DATABASE docManager CHARACTER SET 'utf8mb4' COLLATE 'utf8mb4_unicode_ci';
use docManager;

-- 1. 系统表 sys
-- 1.1 用户表
create table sys_user
(
  user_type_id     varchar(100) comment '用户类型 from 字典表',
  sex_id           varchar(100) comment '性别 from 字典表',

  username         varchar(100) comment '用户名',
  password         varchar(100) comment '密码',
  work_id          varchar(100) comment '工号/学号',
  real_name        varchar(100) comment '真名',
  id_number        varchar(100) comment '身份证号',
  duty             varchar(100) comment '职务',
  title            varchar(100) comment '职称',
  mobile           varchar(100) comment '手机号',
  phone            varchar(100) comment '座机',
  email            varchar(100) comment '邮箱',
  political_status varchar(100) comment '政治面貌',
  healthy          varchar(100) comment '健康状况',
  birthplace       varchar(100) comment '出生地',
  birthday         datetime comment '出生日期',
  hire_date        datetime comment '入职/入学日期',

  id               varchar(100) primary key,
  remarks          varchar(200) comment '备注',
  create_user_id   varchar(100) comment '创建者id',
  modify_user_id   varchar(100) comment '最后修改者id',
  create_date      datetime comment '创建日期',
  modify_date      datetime comment '最后修改日期',
  del_flag         bool default false comment '是否被删除'
);

-- 1.2 角色表
create table sys_role
(
  name           varchar(100) comment '角色名',
  code           varchar(100) comment '角色代码',
  sort           int comment '排序',

  id             varchar(100) primary key,
  remarks        varchar(200) comment '备注',
  create_user_id varchar(100) comment '创建者id',
  modify_user_id varchar(100) comment '最后修改者id',
  create_date    datetime comment '创建日期',
  modify_date    datetime comment '最后修改日期',
  del_flag       bool default false comment '是否被删除'
);

-- 1.3 功能
create table sys_function
(
  parent_id      varchar(100) comment '功能所属的分类 from 功能表',

  name           varchar(100) comment '功能或分类名称',
  code           varchar(100) comment '功能或分类代码',
  url            varchar(100) comment '如果是功能，则此项代表功能页地址，否则为空',
  icon           varchar(100) comment '图标',
  enable         bool comment '功能是否启用',
  type           int comment '0 - 功能分类，点击展开子功能;1 - 功能，点击进入功能页',
  `index`        int comment '排序，功能栏上自上而下，从0开始递增(相当于数组中的序号)',

  id             varchar(100) primary key,
  remarks        varchar(200) comment '备注',
  create_user_id varchar(100) comment '创建者id',
  modify_user_id varchar(100) comment '最后修改者id',
  create_date    datetime comment '创建日期',
  modify_date    datetime comment '最后修改日期',
  del_flag       bool default false comment '是否被删除'
);

-- 1.4 用户-角色关联表
create table sys_map_user_role
(
  user_id        varchar(100) comment '用户 from 用户表',
  role_id        varchar(100) comment '角色 from 角色表',

  id             varchar(100) primary key,
  remarks        varchar(200) comment '备注',
  create_user_id varchar(100) comment '创建者id',
  modify_user_id varchar(100) comment '最后修改者id',
  create_date    datetime comment '创建日期',
  modify_date    datetime comment '最后修改日期',
  del_flag       bool default false comment '是否被删除'
);

-- 1.5 角色-功能关联表
create table sys_map_role_function
(
  role_id        varchar(100) comment '角色 from 角色表',
  function_id    varchar(100) comment '功能 from 功能表',

  id             varchar(100) primary key,
  remarks        varchar(200) comment '备注',
  create_user_id varchar(100) comment '创建者id',
  modify_user_id varchar(100) comment '最后修改者id',
  create_date    datetime comment '创建日期',
  modify_date    datetime comment '最后修改日期',
  del_flag       bool default false comment '是否被删除'
);

-- 1.6 字典表
create table sys_dict
(
  type_id        varchar(100) comment '字典类型 from 字典类型表',
  parent_id      varchar(100) comment '父字典项 from 字典表',

  name_cn        varchar(100) comment '字典中文名',
  name_en        varchar(100) comment '字典英文名',
  sort           int comment '用户可手动设置sort值进行排序',

  id             varchar(100) primary key,
  remarks        varchar(200) comment '备注',
  create_user_id varchar(100) comment '创建者id',
  modify_user_id varchar(100) comment '最后修改者id',
  create_date    datetime comment '创建日期',
  modify_date    datetime comment '最后修改日期',
  del_flag       bool default false comment '是否被删除'
);

-- 1.7 字典类型表
create table sys_dict_type
(
  parent_id      varchar(100) comment '父类型 from 字典类型表',

  name_cn        varchar(100) comment '字典类型中文名',
  name_en        varchar(100) comment '字典类型英文名',
  sort           int comment '用户可手动设置sort值进行排序',

  id             varchar(100) primary key,
  remarks        varchar(200) comment '备注',
  create_user_id varchar(100) comment '创建者id',
  modify_user_id varchar(100) comment '最后修改者id',
  create_date    datetime comment '创建日期',
  modify_date    datetime comment '最后修改日期',
  del_flag       bool default false comment '是否被删除'
);

-- 2. 公共基础信息 common
-- 2.1 机构表
create table common_organize
(
  parent_id      varchar(100) comment '夫机构 from 机构表',

  org_code       varchar(100) comment '机构编号',
  org_name       varchar(100) comment '机构名称',
  description    varchar(2048) comment '描述信息',

  id             varchar(100) primary key,
  remarks        varchar(200) comment '备注',
  create_user_id varchar(100) comment '创建者id',
  modify_user_id varchar(100) comment '最后修改者id',
  create_date    datetime comment '创建日期',
  modify_date    datetime comment '最后修改日期',
  del_flag       bool default false comment '是否被删除'
);

-- 2.2 学科表
create table common_subject
(
  parent_id        varchar(100) comment '父学科 from 学科表',
  subject_level_id varchar(100) comment '学科等级 from 字典表',


  subject_name     varchar(100) comment '学科名',
  subject_code     varchar(100) comment '学科编号',
  description      varchar(2048) comment '描述信息',

  id               varchar(100) primary key,
  remarks          varchar(200) comment '备注',
  create_user_id   varchar(100) comment '创建者id',
  modify_user_id   varchar(100) comment '最后修改者id',
  create_date      datetime comment '创建日期',
  modify_date      datetime comment '最后修改日期',
  del_flag         bool default false comment '是否被删除'
);

-- 2.3 教师-学生关联表
create table common_map_teacher_student
(
  teacher_id     varchar(100) comment '教师 from 用户表',
  student_id     varchar(100) comment '学生 from 用户表',

  id             varchar(100) primary key,
  remarks        varchar(200) comment '备注',
  create_user_id varchar(100) comment '创建者id',
  modify_user_id varchar(100) comment '最后修改者id',
  create_date    datetime comment '创建日期',
  modify_date    datetime comment '最后修改日期',
  del_flag       bool default false comment '是否被删除'
);

-- 2.4 教师/学生-学科关联
create table common_map_user_subject
(
  user_id        varchar(100) comment '教师/学生 from 用户表',
  subject_id     varchar(100) comment '学科 from 学科表',

  id             varchar(100) primary key,
  remarks        varchar(200) comment '备注',
  create_user_id varchar(100) comment '创建者id',
  modify_user_id varchar(100) comment '最后修改者id',
  create_date    datetime comment '创建日期',
  modify_date    datetime comment '最后修改日期',
  del_flag       bool default false comment '是否被删除'
);

-- 3. 文献信息表 doc
-- 3.1 论文表
create table doc_paper
(
  first_author_id    varchar(100) comment '第一作者 from 用户表',
  second_author_id   varchar(100) comment '第二作者 from 用户表',
  journal_id         varchar(100) comment '所属期刊 from 期刊表',

  paper_name         varchar(100) comment '论文名',
  author_list        varchar(300) comment '全体作者名列表',
  first_author_name  varchar(100) comment '第一作者名字（从列表中分割出来，再和用户表匹配）',
  second_author_name varchar(100) comment '第二作者名字（同上）',
  store_num          varchar(100) comment '入藏号',
  doc_type           varchar(100) comment '文献类型',
  publish_date       datetime comment '出版日期',

  id                 varchar(100) primary key,
  remarks            varchar(200) comment '备注',
  create_user_id     varchar(100) comment '创建者id',
  modify_user_id     varchar(100) comment '最后修改者id',
  create_date        datetime comment '创建日期',
  modify_date        datetime comment '最后修改日期',
  del_flag           bool default false comment '是否被删除'
);

-- 3.2 期刊表
create table doc_journal
(
  journal_level_id   varchar(100) comment '期刊分级 from 字典表',
  journal_subject_id varchar(100) comment '期刊学科 from 字典表',
  journal_status_id  varchar(100) comment '期刊地位 from 字典表',
  journal_content_id varchar(100) comment '期刊内容 from 字典表',

  journal_name       varchar(100) comment '期刊名',
  ISSN_num           varchar(100) comment '国际标准连续出版物号',

  id                 varchar(100) primary key,
  remarks            varchar(200) comment '备注',
  create_user_id     varchar(100) comment '创建者id',
  modify_user_id     varchar(100) comment '最后修改者id',
  create_date        datetime comment '创建日期',
  modify_date        datetime comment '最后修改日期',
  del_flag           bool default false comment '是否被删除'
);

-- 3.3 教师/学生-论文关联表
create table doc_map_user_paper
(
  user_id        varchar(100) comment '教师/学生 from 用户表',
  paper_id       varchar(100) comment '论文 from 论文表',
  author_type_id varchar(100) comment '作者类型 from 字典表',

  id             varchar(100) primary key,
  remarks        varchar(200) comment '备注',
  create_user_id varchar(100) comment '创建者id',
  modify_user_id varchar(100) comment '最后修改者id',
  create_date    datetime comment '创建日期',
  modify_date    datetime comment '最后修改日期',
  del_flag       bool default false comment '是否被删除'
);