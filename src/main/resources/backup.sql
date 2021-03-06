-- 初始化数据库
drop database if exists docManager;
create database docManager;
ALTER DATABASE docManager CHARACTER SET 'utf8mb4' COLLATE 'utf8mb4_unicode_ci';
use docManager;

create table common_map_teacher_student
(
  id             varchar(100)         not null
    primary key,
  student_id     varchar(100)         null comment '学生 from 用户表',
  teacher_id     varchar(100)         null comment '教师 from 用户表',
  remarks        varchar(200)         null comment '备注',
  create_user_id varchar(100)         null comment '创建者id',
  modify_user_id varchar(100)         null comment '最后修改者id',
  create_date    datetime             null comment '创建日期',
  modify_date    datetime             null comment '最后修改日期',
  del_flag       tinyint(1) default 0 null comment '是否被删除'
);


create table common_map_user_subject
(
  id             varchar(100)         not null
    primary key,
  subject_id     varchar(100)         null comment '学科 from 学科表',
  user_id        varchar(100)         null comment '教师/学生 from 用户表',
  remarks        varchar(200)         null comment '备注',
  create_user_id varchar(100)         null comment '创建者id',
  modify_user_id varchar(100)         null comment '最后修改者id',
  create_date    datetime             null comment '创建日期',
  modify_date    datetime             null comment '最后修改日期',
  del_flag       tinyint(1) default 0 null comment '是否被删除'
);


create table common_organize
(
  id             varchar(100)         not null
    primary key,
  org_code       varchar(100)         null comment '机构编号',
  org_name       varchar(100)         null comment '机构名称',
  description    varchar(2048)        null comment '描述信息',
  parent_id      varchar(100)         null comment '夫机构 from 机构表',
  remarks        varchar(200)         null comment '备注',
  create_user_id varchar(100)         null comment '创建者id',
  modify_user_id varchar(100)         null comment '最后修改者id',
  create_date    datetime             null comment '创建日期',
  modify_date    datetime             null comment '最后修改日期',
  del_flag       tinyint(1) default 0 null comment '是否被删除'
);


create table common_subject
(
  id               varchar(100)         not null
    primary key,
  subject_level_id varchar(100)         null comment '学科等级 from 字典表',
  subject_name     varchar(100)         null comment '学科名',
  subject_code     varchar(100)         null comment '学科编号',
  description      varchar(2048)        null comment '描述信息',
  parent_id        varchar(100)         null comment '父学科 from 学科表',
  remarks          varchar(200)         null comment '备注',
  create_user_id   varchar(100)         null comment '创建者id',
  modify_user_id   varchar(100)         null comment '最后修改者id',
  create_date      datetime             null comment '创建日期',
  modify_date      datetime             null comment '最后修改日期',
  del_flag         tinyint(1) default 0 null comment '是否被删除'
);


create table doc_journal
(
  id                 varchar(100)         not null
    primary key,
  journal_subject_id varchar(100)         null comment '期刊学科 from 字典表',
  journal_status_id  varchar(100)         null comment '期刊地位 from 字典表',
  journal_content_id varchar(100)         null comment '期刊内容 from 字典表',
  journal_name       varchar(300)         null comment '期刊名',
  ISSN_num           varchar(100)         null comment '国际标准连续出版物号',
  journal_level_id   varchar(100)         null comment '期刊分级 from 字典表',
  remarks            varchar(200)         null comment '备注',
  create_user_id     varchar(100)         null comment '创建者id',
  modify_user_id     varchar(100)         null comment '最后修改者id',
  create_date        datetime             null comment '创建日期',
  modify_date        datetime             null comment '最后修改日期',
  del_flag           tinyint(1) default 0 null comment '是否被删除'
);


create table doc_map_user_paper
(
  id             varchar(100)         not null
    primary key,
  paper_id       varchar(100)         null comment '论文 from 论文表',
  author_type_id varchar(100)         null comment '作者类型 from 字典表',
  user_id        varchar(100)         null comment '教师/学生 from 用户表',
  remarks        varchar(200)         null comment '备注',
  create_user_id varchar(100)         null comment '创建者id',
  modify_user_id varchar(100)         null comment '最后修改者id',
  create_date    datetime             null comment '创建日期',
  modify_date    datetime             null comment '最后修改日期',
  del_flag       tinyint(1) default 0 null comment '是否被删除'
);


create table doc_paper
(
  id                 varchar(100)         not null
    primary key,
  author_list        varchar(300)         null comment '全体作者名列表',
  first_author_name  varchar(100)         null comment '第一作者名字（从列表中分割出来，再和用户表匹配）',
  second_author_name varchar(100)         null comment '第二作者名字（同上）',
  first_author_id    varchar(100)         null comment '第一作者 from 用户表',
  second_author_id   varchar(100)         null comment '第二作者 from 用户表',
  status             varchar(100)         null comment '总体匹配状态:null:未初始化;0:未匹配;1:匹配出错;2:匹配成功;3:匹配完成',
  status_1           varchar(100)         null comment '第一作者匹配状态:0:成功;1:重名;2:无匹配',
  status_2           varchar(100)         null comment '第二作者匹配状态:0:成功;1:重名;2:无匹配',
  paper_name         varchar(300)         null comment '论文名',
  store_num          varchar(100)         null comment '入藏号',
  doc_type           varchar(100)         null comment '文献类型',
  publish_date       datetime             null comment '出版日期',
  ISSN               varchar(100)         null comment '国际标准期刊号(期刊表中唯一)',
  remarks            varchar(200)         null comment '备注',
  create_user_id     varchar(100)         null comment '创建者id',
  modify_user_id     varchar(100)         null comment '最后修改者id',
  create_date        datetime             null comment '创建日期',
  modify_date        datetime             null comment '最后修改日期',
  del_flag           tinyint(1) default 0 null comment '是否被删除'
);

INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('0ea25397b32c4c319a76723120b460a2', 'Wang, C; Chen, X; Ouyang, JT; Li, T; Fu, JL', 'Wang, C', ' Chen, X', null,
        null, '0', null, null,
        'Pulse Current of Multi-Needle Negative Corona Discharge and Its Electromagnetic Radiation Characteristics',
        'WOS:000451814000258', 'Article', null, '1996-1073', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('0f3d491f2fb84039ab7622e5f5e5f440', 'Wu, Y; Cao, CB', 'Wu, Y', ' Cao, CB', null, null, '0', null, null,
        'The way to improve the energy density of supercapacitors: Progress and perspective', 'WOS:000450218200002',
        'Review', null, '2095-8226', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('12c7a65b3f8544a78888dc0092322ef7', 'Wei, W; Jian, HC; Yan, QD; Luo, XM; Wu, XH', 'Wei, W', ' Jian, HC', null,
        null, '0', null, null,
        'Nonlinear modeling and stability analysis of a pilot-operated valve-control hydraulic system',
        'WOS:000450097900001', 'Article', '2019-11-06 00:00:00', '1687-8140', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('134d1c27f9b040458bad049bcce5d907', 'Wang, TS; Chen, JJ; Ye, L; Zhang, AY; Feng, ZG', 'Wang, TS', ' Chen, JJ',
        null, null, '0', null, null,
        'Synthesis of Oxygen-bridged Binuclear Titanium and Nickel Complexes and Application in Catalysis of Bimodal Polyethylene',
        'WOS:000453440300031', 'Article', '2019-11-10 00:00:00', '0251-0790', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('146562c11e344b27801b4f77948c027b', 'Wang, SB; Na, J; Ren, XM', 'Wang, SB', ' Na, J', null, null, '0', null,
        null, 'RISE-Based Asymptotic Prescribed Performance Tracking Control of Nonlinear Servo Mechanisms',
        'WOS:000450617000031', 'Article', null, '2168-2216', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('1480c28da043405fa7e7187d85cb75e3', 'Zhou, JQ; Wang, M; Li, X', 'Zhou, JQ', ' Wang, M', null, null, '0', null,
        null,
        'Facile preparation of nitrogen-doped high-surface-area porous carbon derived from sucrose for high performance supercapacitors',
        'WOS:000447741800053', 'Article', '2019-12-31 00:00:00', '0169-4332', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('14c8df550dac49f09a96a2ceb709952d', 'Liu, CC; Zhang, LD; Chen, WQ; Yang, F', 'Liu, CC', ' Zhang, LD', null,
        null, '0', null, null,
        'Chiral Spin Density Wave and d plus id Superconductivity in the Magic-Angle-Twisted Bilayer Graphene',
        'WOS:000451010600013', 'Article', '2019-11-21 00:00:00', '0031-9007', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('1560fb40a7da4b7a9e4c2169d7603861', 'Han, N; Huang, LL; Wang, YT', 'Han, N', ' Huang, LL', null, null, '0',
        null, null, 'Illusion and cloaking using dielectric conformal metasurfaces', 'WOS:000451213200050', 'Article',
        '2019-11-26 00:00:00', '1094-4087', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('162b5289040e49f6b8ac26ff4d2710fe', 'Liu, FS; Zhang, XY; Li, YK; Wu, H; Hua, Y', 'Liu, FS', ' Zhang, XY', null,
        null, '0', null, null, 'Characteristics of premixed hydrogen/air squish flame in a confined vessel',
        'WOS:000452584800029', 'Article', null, '1743-9671', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('181506aa3b0c4dbeafb02ea4f9fbace9', 'Yuan, WJ; Wu, N; Yan, CX; Li, YH; Huang, XJ; Hanzo, L', 'Yuan, WJ',
        ' Wu, N', null, null, '0', null, null,
        'A Low-Complexity Energy-Minimization-Based SCMA Detector and Its Convergence Analysis', 'WOS:000454112100093',
        'Article', null, '0018-9545', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('18f4d3f78e284f13b071430749a64bf7', 'Zhang, X; Bai, X; Zhong, H', 'Zhang, X', ' Bai, X', null, null, '0', null,
        null, 'Electric vehicle adoption in license plate-controlled big cities: Evidence from Beijing',
        'WOS:000448098000018', 'Article', '2019-11-20 00:00:00', '0959-6526', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('1909bd56f339475cbb1f2983cc833dc0', 'Li, YH; Hu, C; Ao, DY; Dong, XC; Tian, WM; Li, SW; Hu, JQ', 'Li, YH',
        ' Hu, C', null, null, '0', null, null,
        'Ionospheric Scintillation Impacts on L-band Geosynchronous D-InSAR System: Models and Analysis',
        'WOS:000455462100028', 'Article', null, '1939-1404', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('19c0773a9c61471d9a9c645788661f70', 'Sun, SX; Ma, S; Zhao, BB; Zhang, GP; Luo, YJ', 'Sun, SX', ' Ma, S', null,
        null, '0', null, null, 'A Facile Way to Prolong Service Life of Double Base Propellant', 'WOS:000451755500171',
        'Article', null, '1996-1944', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('19f109be32ca41d5934cf4efb0cfc853', 'Kong, T; Ye, L; Zhang, AY; Feng, ZG', 'Kong, T', ' Ye, L', null, null, '0',
        null, null,
        'How Does PHEMA Pass through the Cavity of gamma-CDs to Create Mismatched Overfit Polypseudorotaxanes?',
        'WOS:000451245800030', 'Article', '2019-11-20 00:00:00', '0743-7463', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('1a5bb0af3dac4c458a6787366d7b0cdd', 'Wang, GL; Lu, T; Fan, GJ; Li, CQ; Yin, HQ; Chen, FX', 'Wang, GL', ' Lu, T',
        null, null, '0', null, null,
        'The Chemistry and Properties of Energetic Materials Bearing [1,2,4]Triazolo[4,3-b][1,2,4,5]tetrazine Fused Rings',
        'WOS:000452186500018', 'Article', '2019-12-04 00:00:00', '1861-4728', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('1b0bf6689dc14cb09b02b97bfe969a1b', 'Cheng, L; Yang, GY', 'Cheng, L', ' Yang, GY', null, null, '0', null, null,
        'Three Alumino/Galloborate Frameworks Templated by Organic Amines: Syntheses, Structures, and Nonlinear Optical Properties',
        'WOS:000449576900052', 'Article', '2019-11-05 00:00:00', '0020-1669', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('1b11b712cecc4508a285ec7823833a7a', 'Chen, TR; Chen, H; Huang, B; Liang, WD; Xiang, L; Wang, GY', 'Chen, TR',
        ' Chen, H', null, null, '0', null, null,
        'Thermal transition and its evaluation of liquid hydrogen cavitating flow in a wide range of free-stream conditions',
        'WOS:000445994000116', 'Article', null, '0017-9310', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('1b2346d6c7fa4bae8d99046ad6c8726f', 'Qiu, QG; Cui, LR', 'Qiu, QG', ' Cui, LR', null, null, '0', null, null,
        'Reliability evaluation based on a dependent two-stage failure process with competing failures',
        'WOS:000447117200042', 'Article', null, '0307-904X', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('1b3132a83c6245baa2473e3a5d1c956e', 'Wang, K; Shi, FG', 'Wang, K', ' Shi, FG', null, null, '0', null, null,
        'M-FUZZIFYING TOPOLOGICAL CONVEX SPACES', 'WOS:000456438500010', 'Article', null, '1735-0654', null, 'u1', 'u1',
        '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('1d0b840b4a474077b0c558d05d744046', 'Zhu, HW; Feng, YD; Lu, DF; Sandali, Y; Li, B; Sun, G; Zheng, N; Shi, QF',
        'Zhu, HW', ' Feng, YD', null, null, '0', null, null,
        'Dynamics of quasi-static collapse process of a binary granular column', 'WOS:000449892500094', 'Article', null,
        '0032-5910', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('1e854aefc89f46c2ab7f0ad3a1c6f091', 'Lin, C; Xu, JY; He, SJ; Zhang, WJ; Li, HQ; Huo, B; Ji, BH', 'Lin, C',
        ' Xu, JY', null, null, '0', null, null, 'Collective cell polarization and alignment on curved surfaces',
        'WOS:000448090700036', 'Article', null, '1751-6161', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('1f9e70deb61b4397b5cee4d7ff7ca4dd', 'Wang, XQ; Ghulam, M; Zhu, C; Qu, F', 'Wang, XQ', ' Ghulam, M', null, null,
        '0', null, null,
        'Online Capillary Electrophoresis Reaction for Interaction Study of Amino Acid Modified Peptide Nucleic Acid and Proteins',
        'WOS:000455916100006', 'Article', null, '0253-3820', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('2032a93967e74c849dcb03177cfa966a', 'Liu, YK; Kong, ZJ; Zhang, Q', 'Liu, YK', ' Kong, ZJ', null, null, '0',
        null, null,
        'Failure modes and effects analysis (FMEA) for the security of the supply chain system of the gas station in China',
        'WOS:000449247600039', 'Article', '2019-11-30 00:00:00', '0147-6513', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('20a3b37c466046a08af67c3c5d866f30', 'Wang, K; Wang, JY; Wei, YM; Zhang, C', 'Wang, K', ' Wang, JY', null, null,
        '0', null, null,
        'A novel dataset of emission abatement sector extended input-output table for environmental policy analysis',
        'WOS:000452345400097', 'Article', '2019-12-01 00:00:00', '0306-2619', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('22b545d649e34efba64b187256231e48',
        'Chu, YK; Li, X; Yang, XL; Ai, DN; Huang, Y; Song, H; Jiang, YR; Wang, YT; Chen, XH; Yang, J', 'Chu, YK',
        ' Li, X', null, null, '0', null, null,
        'Perception enhancement using importance-driven hybrid rendering for augmented reality based endoscopic surgical navigation',
        'WOS:000449192700007', 'Article', '2019-11-01 00:00:00', '2156-7085', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('2309a722ab49470badf6d241338ca38a', 'Fang, YS; Hu, ZM; Teng, HH', 'Fang, YS', ' Hu, ZM', null, null, '0', null,
        null,
        'Numerical investigation of oblique detonations induced by a finite wedge in a stoichiometric hydrogen-air mixture',
        'WOS:000445253100053', 'Article', '2019-12-15 00:00:00', '0016-2361', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('233359becf2b4a6d9146326a1568e7bd', 'Dong, CY', 'Dong, CY', null, null, null, '0', null, null,
        'A new integral formula for the variation of matrix elastic energy of heterogeneous materials',
        'WOS:000437820000043', 'Article', '2019-12-01 00:00:00', '0377-0427', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('233956e980ea4527a014e8f5cbf63db2', 'Zhang, JJ; Yu, BY; Wei, YM', 'Zhang, JJ', ' Yu, BY', null, null, '0', null,
        null, 'Heterogeneous impacts of households on carbon dioxide emissions in Chinese provinces',
        'WOS:000449891500020', 'Article; Proceedings Paper', '2019-11-01 00:00:00', '0306-2619', null, 'u1', 'u1',
        '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('2407d7d943ba4d7487a09ba1c7fee7b6', 'Cao, YP; Wang, QS; Liu, YB; Ning, XJ', 'Cao, YP', ' Wang, QS', null, null,
        '0', null, null,
        'High-Temperature Thermal Properties of Ba(Ni1/3Ta2/3)O-3 Ceramic and Characteristics of Plasma-Sprayed Coatings',
        'WOS:000452893200029', 'Article', null, '1059-9630', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('2430f881ab2a45e7a3afa1e561da4639', 'An, T; Zhao, FQ; Yan, QL; Yang, YJ; Luo, YJ; Yi, JH; Hong, WL', 'An, T',
        ' Zhao, FQ', null, null, '0', null, null,
        'Preparation and Evaluation of Effective Combustion Catalysts Based on Cu(I)/Pb(II) or Cu(II)/Bi(II) Nanocomposites Carried by Graphene Oxide (GO)',
        'WOS:000450162700002', 'Article', null, '0721-3115', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('25240d3d959d4f9ca882817c8d284e7a',
        'Su, YF; Yang, YQ; Chen, L; Lu, Y; Bao, LY; Chen, G; Yang, ZR; Zhang, QY; Wang, J; Chen, RJ; Chen, S; Wu, F',
        'Su, YF', ' Yang, YQ', null, null, '0', null, null,
        'Improving the cycling stability of Ni-rich cathode materials by fabricating surface rock salt phase',
        'WOS:000449708500025', 'Article', '2019-12-01 00:00:00', '0013-4686', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('270685b73ab849cb94802fdbb6b18cf8', 'Wang, B; Wang, ZH', 'Wang, B', ' Wang, ZH', null, null, '0', null, null,
        'Heterogeneity evaluation of China''s provincial energy technology based on large-scale technical text data mining',
        'WOS:000448098000086', 'Article', '2019-11-20 00:00:00', '0959-6526', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('2815b4737858410a9764931e226a69be', 'Huang, JX; Fei, ZS; Cao, CZ; Xiao, M; Jia, D', 'Huang, JX', ' Fei, ZS',
        null, null, '0', null, null, 'Performance Analysis and Improvement of Online Fountain Codes',
        'WOS:000454112200006', 'Article', null, '0090-6778', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('29768ab1c4ef42eca3a18719808f7987', 'Sun, QL; Sang, C; Wang, Z; Luo, YJ', 'Sun, QL', ' Sang, C', null, null,
        '0', null, null,
        'Improvement of the creep resistance of glycidyl azide polyol energetic thermoplastic elastomer-based propellant by nitrocellulose filler and its mechanism',
        'WOS:000449288600001', 'Article', null, '0095-2443', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('2b7bd4ddfa49419dbd986d1241923cde', 'Gao, HC; Jiang, Y; Cui, Y; Zhang, LC; Jia, JS; Jiang, L', 'Gao, HC',
        ' Jiang, Y', null, null, '0', null, null,
        'Investigation on the Thermo-Optic Coefficient of Silica Fiber Within a Wide Temperature Range',
        'WOS:000451904600021', 'Article', '2019-12-15 00:00:00', '0733-8724', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('2bbb95f3b02a48c7ab342cf28276eaf9',
        'Dong, J; Lv, HJ; Sun, XR; Wang, Y; Ni, YM; Zou, B; Zhang, N; Yin, AX; Chi, YN; Hu, CW', 'Dong, J', ' Lv, HJ',
        null, null, '0', null, null,
        'A Versatile Self-Detoxifying Material Based on Immobilized Polyoxoniobate for Decontamination of Chemical Warfare Agent Simulants',
        'WOS:000453829200016', 'Article', '2019-12-20 00:00:00', '0947-6539', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('2cbf15170e8d458fbf630a4725b473f1', 'Wang, QQ; Zhao, J; Shan, B; Li, XY', 'Wang, QQ', ' Zhao, J', null, null,
        '0', null, null,
        'A novel method for laser radar cross section calculation of complex laser targets with partial and Gaussian beam irradiation',
        'WOS:000448183200001', 'Article', null, '1054-660X', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('2d625096d3a54663b21f21b393f422f2', 'Ding, ZG; Xiao, F; Xie, YZ; Yu, WY; Yang, Z; Chen, L; Long, T', 'Ding, ZG',
        ' Xiao, F', null, null, '0', null, null,
        'A Modified Fixed-Point Chirp Scaling Algorithm Based on Updating Phase Factors Regionally for Spaceborne SAR Real-Time Imaging',
        'WOS:000451621000045', 'Article', null, '0196-2892', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('2e2c469c372e4cc6ac04c99539a886ad', 'Yang, YC; Jin, X; Liu, CM; Xiao, MZ; Lu, JP; Fan, HL; Ma, SY', 'Yang, YC',
        ' Jin, X', null, null, '0', null, null,
        'Residual Stress, Mechanical Properties, and Grain Morphology of Ti-6Al-4V Alloy Produced by Ultrasonic Impact Treatment Assisted Wire and Arc Additive Manufacturing',
        'WOS:000451735100073', 'Article', null, '2075-4701', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('2ebca98503a24f5b893a0af80ea51c09', 'Tong, ZW; He, RJ; Cheng, TB; Zhang, KQ; Dai, DW; Yang, YZ; Fang, DN',
        'Tong, ZW', ' He, RJ', null, null, '0', null, null,
        'High temperature oxidation behavior of ZrB2-SiC added MoSi2 ceramics', 'WOS:000448226900062', 'Article',
        '2019-12-01 00:00:00', '0272-8842', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('2f8a20154de7400c894443cb43766aca', 'Ma, C; Ma, Z; Gao, LH; Liu, YB; Wu, TT; Wang, LJ; Wei, CH; Wang, FC',
        'Ma, C', ' Ma, Z', null, null, '0', null, null,
        'Preparation and characterization of coatings with anisotropic thermal conductivity', 'WOS:000453008100118',
        'Article', '2019-12-15 00:00:00', '0264-1275', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55',
        0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('2fe888ab7412431ca3397d639364e659', 'Li, HW; Liang, ZQ; Pei, JJ; Jiao, L; Xie, LJ; Wang, XB', 'Li, HW',
        ' Liang, ZQ', null, null, '0', null, null,
        'New Measurement Method for Spline Shaft Rolling Performance Evaluation using Laser Displacement Sensor',
        'WOS:000442267700006', 'Article', null, '1000-9345', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('3072d6b785b9441bb51c2a1b50b1895f', 'Lin, XY; Li, ZM; Zhang, TH; Wan, L; Yang, L; Zhang, TL', 'Lin, XY',
        ' Li, ZM', null, null, '0', null, null,
        'Iron complexes based on di(1H-tetrazol-5-yl) methanone: Syntheses, crystal structures and characterization',
        'WOS:000449137000003', 'Article', '2019-11-15 00:00:00', '0277-5387', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('30965648520a467297ecc72dd8ee9e23', 'Sun, GQ; Yang, HS; Zhang, GF; Gao, J; Jin, XT; Zhao, Y; Jiang, L; Qu, LT',
        'Sun, GQ', ' Yang, HS', null, null, '0', null, null, 'A capacity recoverable zinc-ion micro-supercapacitor',
        'WOS:000452317700005', 'Article', '2019-12-01 00:00:00', '1754-5692', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('3183cc01b2974fda8ff98102f8c2015f', 'Guo, CX; Hao, XH; Li, P', 'Guo, CX', ' Hao, XH', null, null, '0', null,
        null, 'An Improved Trilinear Model-Based Angle Estimation Method for Co-Prime Planar Arrays',
        'WOS:000454817100099', 'Article', null, '1424-8220', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('328c3814cc4749bebd3a6624451f518a',
        'Shao, PP; Li, J; Chen, F; Ma, L; Li, QB; Zhang, MX; Zhou, JW; Yin, AX; Feng, X; Wang, B', 'Shao, PP', ' Li, J',
        null, null, '0', null, null,
        'Flexible Films of Covalent Organic Frameworks with Ultralow Dielectric Constants under High Humidity',
        'WOS:000453346300044', 'Article', '2019-12-10 00:00:00', '1433-7851', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('33bbad5a0f9d46b18b24849b1b951efd', 'Ma, C; Ma, Z; Gao, LH; Liu, YB; Wu, TT; Zhu, YX; Wang, FC', 'Ma, C',
        ' Ma, Z', null, null, '0', null, null,
        'Laser ablation behavior of flake graphite and SiO2 particle-filled hyperbranched polycarbosilane matrix composite coatings',
        'WOS:000448226900100', 'Article', '2019-12-01 00:00:00', '0272-8842', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('33bd6bef78004643b1b266d487ca385e', 'Wang, QS; Zhu, ZY; Zheng, HF', 'Wang, QS', ' Zhu, ZY', null, null, '0',
        null, null, 'Investigation of a floating solar desalination film', 'WOS:000447476500004', 'Article',
        '2019-12-01 00:00:00', '0011-9164', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('35b62d7c85ae4cd391a1dc03e8e1b71a', 'Wu, GY; Sun, J; Chen, J', 'Wu, GY', ' Sun, J', null, null, '0', null, null,
        'Optimal Data Injection Attacks in Cyber-Physical Systems', 'WOS:000450613100004', 'Article', null, '2168-2267',
        null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('35fdb711004f44a1a27cfe7717f8aca1', 'Wang, R; Wang, J; Chen, S; Jiang, CL; Bao, W; Su, YF; Tan, GQ; Wu, F',
        'Wang, R', ' Wang, J', null, null, '0', null, null,
        'Toward Mechanically Stable Silicon-Based Anodes Using Si/SiOx@C Hierarchical Structures with Well-Controlled Internal Buffer Voids',
        'WOS:000452694100051', 'Article', '2019-12-05 00:00:00', '1944-8244', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('36062a89ed2243c1984947cbda6f628f', 'Li, Y; Xiong, SH; Li, XG; Wen, YQ', 'Li, Y', ' Xiong, SH', null, null, '0',
        null, null, 'Mechanism of velocity enhancement of asymmetrically two lines initiated warhead',
        'WOS:000449140300014', 'Article', null, '0734-743X', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('363c54f68e844f0aa1c5132f7b1e98af', 'Reda, AT; Zhang, DX; Lu, X', 'Reda, AT', ' Zhang, DX', null, null, '0',
        null, null, 'Rapid and selective uranium adsorption by glycine functionalized europium hydroxide',
        'WOS:000444957600036', 'Article', '2019-11-05 00:00:00', '0927-7757', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('36a3fadbca1240a4bfd8d69b6a4f916d', 'Shen, WQ; Dai, LL; Shim, B; Wang, ZC; Heath, RW', 'Shen, WQ', ' Dai, LL',
        null, null, '0', null, null,
        'Channel Feedback Based on AoD-Adaptive Subspace Codebook in FDD Massive MIMO Systems', 'WOS:000450191400017',
        'Article', null, '0090-6778', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('37823441fe9544678dc2384c78892577', 'Shi, SJ; Wang, XZ; Zheng, SH; Zhang, YX; Lu, DY', 'Shi, SJ', ' Wang, XZ',
        null, null, '0', null, null, 'A New Diode-Clamped Multilevel Inverter With Balance Voltages of DC Capacitors',
        'WOS:000451909800063', 'Article', null, '0885-8969', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('389da594b3ae4d6b86769fe561ed5aa5',
        'Wang, SS; Zhao, Y; Gao, MM; Xue, HL; Xu, YC; Feng, CH; Shi, DX; Liu, KH; Jiao, QZ', 'Wang, SS', ' Zhao, Y',
        null, null, '0', null, null,
        'Green Synthesis of Porous Cocoon-like rGO for Enhanced Microwave-Absorbing Performances',
        'WOS:000453488900111', 'Article', '2019-12-12 00:00:00', '1944-8244', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('3a73fa1717bb493ebf2e495a768bc543',
        'Wu, JF; Li, XY; Zhao, YZ; Liu, L; Qu, WJ; Luo, R; Chen, RJ; Li, YJ; Chen, Q', 'Wu, JF', ' Li, XY', null, null,
        '0', null, null, 'Interface engineering in solid state Li metal batteries by quasi-2D hybrid perovskites',
        'WOS:000451600200034', 'Article', '2019-11-14 00:00:00', '2050-7488', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('3bd6d6b170034eaf87bd28fc34332940', 'Li, EZ; Li, YQ; Sheng, NY; Li, TE; Sun, YY; Wei, PZ', 'Li, EZ', ' Li, YQ',
        null, null, '0', null, null,
        'A nonlinear measurement method of polarization aberration in immersion projection optics by spectrum analysis of aerial image',
        'WOS:000452612200032', 'Article', '2019-12-10 00:00:00', '1094-4087', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('3ea8d1f6293d442995dcea8fbd06cace', 'Gu, L; Cheng, DW; Wang, QW; Hou, QC; Wang, YT', 'Gu, L', ' Cheng, DW',
        null, null, '0', null, null,
        'Design of a two-dimensional stray-light-free geometrical waveguide head-up display', 'WOS:000448953800008',
        'Article', '2019-11-01 00:00:00', '1559-128X', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55',
        0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('3f0329e51b2e44459b5eecd15bc71ba1',
        'Chen, DY; Ma, DS; Li, YK; Du, ZZ; Xiong, XL; He, Y; Duan, JX; Han, JF; Chen, D; Xiao, WD; Yao, YG', 'Chen, DY',
        ' Ma, DS', null, null, '0', null, null, 'Quantum transport properties in single crystals of alpha-Bi4I4',
        'WOS:000451589500004', 'Article', '2019-11-27 00:00:00', '2475-9953', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('3f6b1830a73b468ca5dc86a4a0a7f510',
        'Zhang, KL; Cheng, XD; Zhang, YJ; Chen, MJ; Chen, HS; Yang, YZ; Song, WL; Fang, DN', 'Zhang, KL', ' Cheng, XD',
        null, null, '0', null, null, 'Weather-Manipulated Smart Broadband Electromagnetic Metamaterials',
        'WOS:000451932800048', 'Article', '2019-11-28 00:00:00', '1944-8244', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('3f7fcf1a046c4d13971412ed87c6d502', 'Xiong, R; Chen, H; Wang, C; Sun, FC', 'Xiong, R', ' Chen, H', null, null,
        '0', null, null,
        'Towards a smarter hybrid energy storage system based on battery and ultracapacitor - A critical review on topology and energy management',
        'WOS:000448098000110', 'Review', '2019-11-20 00:00:00', '0959-6526', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('3fd94cb462a4474dac704fc88411a55e', 'Zhu, C; Song, PQ; Qiu, LL; Liu, Y; Xu, ZB; Meng, ZH', 'Zhu, C',
        ' Song, PQ', null, null, '0', null, null,
        'Synthesis and Characterization of the Guanidine Salt Based on 1,1,2,2-Tetranitraminoethane (TNAE)',
        'WOS:000452614000014', 'Article', null, '0721-3115', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('3fffca9777d44b6a85f056bdcf7480e2', 'Pang, B; Shi, FG', 'Pang, B', ' Shi, FG', null, null, '0', null, null,
        'Strong inclusion orders between L-subsets and its applications in L-convex spaces', 'WOS:000452766600001',
        'Article', '2019-11-17 00:00:00', '1607-3606', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55',
        0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('405eebb102e44777abaf2deceff5c1b9', 'Wang, SG; Qin, JW; Zheng, LR; Guo, DL; Cao, MH', 'Wang, SG', ' Qin, JW',
        null, null, '0', null, null,
        'A Self-Sacrificing Dual-Template Strategy to Heteroatom-Enriched Porous Carbon Nanosheets with High Pyridinic-N and Pyrrolic-N Content for Oxygen Reduction Reaction and Sodium Storage',
        'WOS:000454229900012', 'Article', '2019-12-07 00:00:00', '2196-7350', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('40cbdf769f5b4dd7a97b651755bde447', 'Ma, LR; Liao, LJ; Song, DD; Wang, JG', 'Ma, LR', ' Liao, LJ', null, null,
        '0', null, null,
        'A Latent Entity-Document Class Mixture of Experts Model for Cumulative Citation Recommendation',
        'WOS:000452622900003', 'Article', null, '1007-0214', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('420fea2867d8490985d3cb238aaff9bd', 'Chen, J; Guo, YX; Mei, FX', 'Chen, J', ' Guo, YX', null, null, '0', null,
        null, 'New methods to find solutions and analyze stability of equilibrium of nonholonomic mechanical systems',
        'WOS:000450715600011', 'Article', null, '0567-7718', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('43b06f1f541b417289c03fc9b4a75762', 'Hu, J; Lam, N', 'Hu, J', ' Lam, N', null, null, '0', null, null,
        'Symmetric structure for the endomorphism algebra of projective-injective module in parabolic category',
        'WOS:000447482700007', 'Article', '2019-12-01 00:00:00', '0021-8693', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('44901a6cc6ee422ca0460cbe2e8ac1cf',
        'Li, LF; Liu, YN; Yang, ZT; He, Y; Yang, P; Chen, DY; Li, YK; Ye, SY; Yang, YB; Shi, QF; Zhao, M; Wang, QS; Xiao, WD; Han, JF',
        'Li, LF', ' Liu, YN', null, null, '0', null, null,
        'Studies of BiCuSeO thin films for potential infrared detector application', 'WOS:000446244700023', 'Article',
        '2019-12-15 00:00:00', '0167-577X', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('48a04e23a07447798e5ebccc4c3a4bae', 'Li, YY; Li, JH; Xu, LX', 'Li, YY', ' Li, JH', null, null, '0', null, null,
        'Method of Calculating the Inductance Value of MEMS Suspended Inductors with Silicon Substrates',
        'WOS:000451314900067', 'Article', null, '2072-666X', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('48a534b8a567417fa31f8bd69d508b2d', 'Zhang, L; Zheng, QZ; Liu, HK; Huang, H', 'Zhang, L', ' Zheng, QZ', null,
        null, '0', null, null,
        'Full-Reference Stability Assessment of Digital Video Stabilization Based on Riemannian Metric',
        'WOS:000444842900001', 'Article', null, '1057-7149', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('49d2dd1886354863bc4c7f48aaeef9a1', 'Cheng, Y; Cao, J; Zhang, FH; Hao, Q', 'Cheng, Y', ' Cao, J', null, null,
        '0', null, null,
        'Design and modeling of pulsed-laser three-dimensional imaging system inspired by compound and human hybrid eye',
        'WOS:000450766300022', 'Article', '2019-11-21 00:00:00', '2045-2322', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('4ae26335e15f4dcab68784eea14ce528', 'Wang, K; Yang, KX; Wei, YM; Zhang, C', 'Wang, K', ' Yang, KX', null, null,
        '0', null, null,
        'Shadow prices of direct and overall carbon emissions in China''s construction industry: A parametric directional distance function-based sensitive estimation',
        'WOS:000454377700017', 'Article', null, '0954-349X', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('4bddf9fadb104222a52aae9f2e94ca44', 'Zou, WD; Xia, YQ; Li, HF', 'Zou, WD', ' Xia, YQ', null, null, '0', null,
        null,
        'Fault Diagnosis of Tennessee-Eastman Process Using Orthogonal Incremental Extreme Learning Machine Based on Driving Amount',
        'WOS:000450613100013', 'Article', null, '2168-2267', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('4cf738217e79457285377b9815545978', 'Jia, DK; Tong, Y; Hu, J', 'Jia, DK', ' Tong, Y', null, null, '0', null,
        null,
        'The effects of N,N-(pyromellitoyl)-bis-l-phenylalanine diacid ester glycol on the flame retardancy and physical-mechanical properties of rigid polyurethane foams',
        'WOS:000450325100005', 'Article', null, '0734-9041', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('4e42bddb18cb4a2ca6fabc27e123518d', 'Guo, W; Ma, Z; Liu, L; Liu, YB', 'Guo, W', ' Ma, Z', null, null, '0', null,
        null,
        'Influence of Feedstock on the Microstructure of Sm2Zr2O7 Thermal Barrier Coatings Deposited by Plasma Spraying',
        'WOS:000452893200023', 'Article', null, '1059-9630', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('4fc11c34d1634525bf2a99928011ebae',
        'Ji, MW; Wang, HZ; Gong, Y; Cheng, HX; Zheng, LR; Li, XY; Huang, L; Liu, J; Nie, ZH; Zeng, QS; Xu, M; Liu, JJ; Wang, XX; Qian, P; Zhu, CZ; Wang, J; Li, XD; Zhang, JT',
        'Ji, MW', ' Wang, HZ', null, null, '0', null, null,
        'High Pressure Induced in Situ Solid-State Phase Transformation of Nonepitaxial Grown Metal@Semiconductor Nanocrystals',
        'WOS:000451362100025', 'Article', '2019-11-15 00:00:00', '1948-7185', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('506d0676318a4c48994b5097cd897272', 'Wang, J; Xu, TZ; Wang, GW', 'Wang, J', ' Xu, TZ', null, null, '0', null,
        null,
        'Numerical algorithm for time-fractional Sawada-Kotera equation and Ito equation with Bernstein polynomials',
        'WOS:000441871500001', 'Article', '2019-12-01 00:00:00', '0096-3003', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('50b45ddf95fc435c800bc8de7cae40fd', 'Li, G; Li, N; Sambandam, N; Sethi, SP; Zhang, FP', 'Li, G', ' Li, N', null,
        null, '0', null, null, 'Flow shop scheduling with jobs arriving at different times', 'WOS:000451938400019',
        'Article', null, '0925-5273', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('51769b61ee7c4dee8e5ee0f5e292d1a0', 'Chen, YB; Yang, D; Yu, JQ', 'Chen, YB', ' Yang, D', null, null, '0', null,
        null,
        'Multi-UAV Task Assignment With Parameter and Time-Sensitive Uncertainties Using Modified Two-Part Wolf Pack Search Algorithm',
        'WOS:000452608000017', 'Article', null, '0018-9251', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('51873348e3e94981a1ef3faf42e30b8a', 'Cheng, WG; Xu, TZ', 'Cheng, WG', ' Xu, TZ', null, null, '0', null, null,
        'Lump solutions and interaction behaviors to the (2+1)-dimensional extended shallow water wave equation',
        'WOS:000450009500014', 'Article', '2019-11-10 00:00:00', '0217-9849', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('51dea921363348dc8d871512cba1d482', 'Chen, HJ; Li, F; Wang, Y', 'Chen, HJ', ' Li, F', null, null, '0', null,
        null, 'SoundMark: Accurate Indoor Localization via Peer-Assisted Dead Reckoning', 'WOS:000456475500050',
        'Article', null, '2327-4662', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('524c6909a2c14fc8af61632f52579303', 'Zhang, HM; Xu, CG; Xiao, DG', 'Zhang, HM', ' Xu, CG', null, null, '0',
        null, null, 'Crack Assessment of Wheel Hubs via an Ultrasonic Transducer and Industrial Robot',
        'WOS:000454817100255', 'Article', null, '1424-8220', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('5311e66786eb4cc9bf9223ffe59f3e57', 'Qu, XY; Dong, CY; Bai, Y; Gong, YP', 'Qu, XY', ' Dong, CY', null, null,
        '0', null, null,
        'Isogeometric boundary element method for calculating effective property of steady state thermal conduction in 2D heterogeneities with a homogeneous interphase',
        'WOS:000437820000010', 'Article', '2019-12-01 00:00:00', '0377-0427', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('5368f0bf5a5d4b1fbdeaef0c5f932e4c', 'Li, B; Fei, ZS; Chu, Z; Zhang, Y', 'Li, B', ' Fei, ZS', null, null, '0',
        null, null,
        'Secure Transmission for Heterogeneous Cellular Networks With Wireless Information and Power Transfer',
        'WOS:000451262300067', 'Article', null, '1932-8184', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('53bb3890660042b4bc1041f64a24614d', 'Zhang, Z; Wang, YL; Yang, GY', 'Zhang, Z', ' Wang, YL', null, null, '0',
        null, null,
        'An unprecedented Zr-containing polyoxometalate tetramer with mixed trilacunary/dilacunary Keggin-type polyoxotungstate units',
        'WOS:000449511500011', 'Article', null, '2053-2296', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('53bbfc85290747a8b9d5a7dcb3120655', 'Han, GH; Liu, XB; Zheng, GY; Wang, MR; Huang, S', 'Han, GH', ' Liu, XB',
        null, null, '0', null, null,
        'Automatic recognition of 3D GGO CT imaging signs through the fusion of hybrid resampling and layer-wise fine-tuning CNNs',
        'WOS:000450519300004', 'Article', null, '0140-0118', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('5490f603062f4f0abc4b76e200e2342b', 'Jiang, W; Cheng, XW; Cai, HN; Ali, T; Zhang, J', 'Jiang, W', ' Cheng, XW',
        null, null, '0', null, null,
        'The response of yttrium aluminum garnet (YAG) grains and grain boundaries to nanoindentation',
        'WOS:000445912300002', 'Article', null, '0022-2461', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('54ba5ae75c454b1a80d457622a44eced', 'Yang, YH; Qi, ML; Wang, JL', 'Yang, YH', ' Qi, ML', null, null, '0', null,
        null,
        'Separation performance of a star-shaped truxene-based stationary phase functionalized with peripheral 3,4-ethylenedioxythiophene moieties for capillary gas chromatography',
        'WOS:000452563300009', 'Article', '2019-11-30 00:00:00', '0021-9673', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('5595e815da674cb0a5dbf16a039cd823', 'Lv, ZL; Liu, J; Xiao, JS; Kuang, Y', 'Lv, ZL', ' Liu, J', null, null, '0',
        null, null,
        'Integrated holographic waveguide display system with a common optical path for visible and infrared light',
        'WOS:000452612200038', 'Article', '2019-12-10 00:00:00', '1094-4087', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('55fdb5b73e6f4daa835138e6c61d3319', 'Liu, F; Hu, Q; Liu, YF', 'Liu, F', ' Hu, Q', null, null, '0', null, null,
        'Attitude Dynamics of Electric Sail from Multibody Perspective', 'WOS:000451372800010', 'Article', null,
        '0731-5090', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('560ff2260d884ab78160b7ba3bd34da8', 'Zou, WD; Yao, FX; Zhang, BH; Guan, ZX', 'Zou, WD', ' Yao, FX', null, null,
        '0', null, null, 'Improved Meta-ELM with error feedback incremental ELM as hidden nodes', 'WOS:000451178200008',
        'Article', null, '0941-0643', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('569b4619411c4db2a06a4ebd270691fa',
        'Song, D; Yang, QH; Lang, YR; Wen, ZS; Xie, Z; Zheng, D; Yan, TY; Deng, YJ; Nakanishi, H; Quan, ZZ; Qing, H',
        'Song, D', ' Yang, QH', null, null, '0', null, null,
        'Manipulation of hippocampal CA3 firing via luminopsins modulates spatial and episodic short-term memory, especially working memory, but not long-term memory',
        'WOS:000449310000046', 'Article', null, '1074-7427', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('57af4f289e8149639c4fb30ef308d34e', 'Guo, YC; Huan, H; Tao, R; Wang, Y', 'Guo, YC', ' Huan, H', null, null, '0',
        null, null, 'Frequency tracking loop with wide pull-in range for weak DSSS signal', 'WOS:000451087000015',
        'Article', '2019-11-15 00:00:00', '0013-5194', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55',
        0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('58fbb08f19c0424f83f4ee4d706ede30', 'Wu, Q; Wang, CC; Huang, B; Wang, GY; Cao, SL', 'Wu, Q', ' Wang, CC', null,
        null, '0', null, null, 'Measurement and prediction of cavitating flow-induced vibrations',
        'WOS:000452062300009', 'Article', null, '1001-6058', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('5942f5930dc24f00a8a3574f7d352ab9', 'Jia, Y; Luo, X; Han, BL; Liang, GH; Zhao, JH; Zhao, YT', 'Jia, Y',
        ' Luo, X', null, null, '0', null, null, 'Stability Criterion for Dynamic Gaits of Quadruped Robot',
        'WOS:000455145000049', 'Article', null, '2076-3417', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('5a032c8de1304f21b2800cd9e740e0a3', 'Yang, WM; Liao, NF; He, SF; Cheng, HB; Li, HS', 'Yang, WM', ' Liao, NF',
        null, null, '0', null, null,
        'Large-aperture UV (250 similar to 400 nm) imaging spectrometer based on a solid Sagnac interferometer',
        'WOS:000454149000087', 'Article', '2019-12-24 00:00:00', '1094-4087', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('5abf768c47f04de0a49ce392a68543d3', 'Zhang, XG; Liu, X; Dong, WP; Hu, GK; Yi, P; Huang, YH; Xiao, K',
        'Zhang, XG', ' Liu, X', null, null, '0', null, null,
        'Corrosion Behaviors of 5A06 Aluminum Alloy in Ethylene Glycol', 'WOS:000452568200032', 'Article', null,
        '1452-3981', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('5b1b4a1b990c4937813833a72000ea7c', 'Yang, JQ; Wang, GX; Gong, XD; Zhang, JG', 'Yang, JQ', ' Wang, GX', null,
        null, '0', null, null,
        'High-pressure behavior and Hirshfeld surface analysis of nitrogen-rich materials: triazido-s-triazine (TAT) and triazido-s-heptazine (TAH)',
        'WOS:000444829500019', 'Article', null, '0022-2461', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('5be2e88944dd460fae7b2686adc14b88', 'Sun, SX; Zhao, BB; Zhang, GP; Luo, YJ', 'Sun, SX', ' Zhao, BB', null, null,
        '0', null, null, 'Applying Mechanically Activated Al/PTFE in CMDB Propellant', 'WOS:000450162700004', 'Article',
        null, '0721-3115', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('5ca68c86636149ee913c0de16043039f', 'Guo, SX; Cai, XJ; Gao, BF', 'Guo, SX', ' Cai, XJ', null, null, '0', null,
        null,
        'A tensor-mass method-based vascular model and its performance evaluation for interventional surgery virtual reality simulator',
        'WOS:000449691300009', 'Article', null, '1478-5951', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('5f3624fa57f1455bad62562bdf0efffc', 'Peng, H; Wang, JZ; Shen, W; Shi, DW; Huang, Y', 'Peng, H', ' Wang, JZ',
        null, null, '0', null, null,
        'Controllable regenerative braking process for hybrid battery-ultracapacitor electric drive systems',
        'WOS:000454696000012', 'Article', '2019-12-18 00:00:00', '1755-4535', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('602ee8d962c04ab98f3f6c5aa6d07537', 'Fu, WQ; Dong, LC; Shi, JB; Tong, B; Cai, ZX; Zhi, JG; Dong, YP', 'Fu, WQ',
        ' Dong, LC', null, null, '0', null, null,
        'Multicomponent spiropolymerization of diisocyanides, alkynes and carbon dioxide for constructing 1,6-dioxospiro[4,4]nonane-3,8-diene as structural units under one-pot catalyst-free conditions',
        'WOS:000451658100007', 'Article', '2019-12-14 00:00:00', '1759-9954', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('617ba25bbf964027801d198bad480c7b', 'Liu, MC; Li, S; Li, L; Jin, WQ; Chen, G', 'Liu, MC', ' Li, S', null, null,
        '0', null, null,
        'Infrared HDR image fusion based on response model of cooled IRFPA under variable integration time',
        'WOS:000449130100028', 'Article', null, '1350-4495', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('61fb4be92ac9410496f1860d935b17bb', 'Wang, J; Liu, WC; Ma, L; Chen, H; Chen, L', 'Wang, J', ' Liu, WC', null,
        null, '0', null, null, 'IORN: An Effective Remote Sensing Image Scene Classification Framework',
        'WOS:000454208400013', 'Article', null, '1545-598X', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('62a0dc1b815d4dc4ba03e2b80cad4675', 'Liu, YS; Ma, XL; Ding, Y; Yang, Z; Roesky, HW', 'Liu, YS', ' Ma, XL', null,
        null, '0', null, null,
        'N-Tosyl Hydrazone Precursor for Diazo Compounds as Intermediates in the Synthesis of Aluminum Complexes',
        'WOS:000450374500022', 'Article', '2019-11-12 00:00:00', '0276-7333', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('62e5ff363e434f24b33119bc650c017c', 'Liu, FS; Li, ZS; Wang, ZM; Dai, XY; He, X; Lee, CF', 'Liu, FS', ' Li, ZS',
        null, null, '0', null, null,
        'Microscopic study on diesel spray under cavitating conditions by injecting fuel into water',
        'WOS:000448226600086', 'Article', '2019-11-15 00:00:00', '0306-2619', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('635429308d8345519bd3a8f8c87dbd68', 'Wang, Q; Han, R; Huang, QL; Hao, J; Lv, N; Li, TY; Tang, BJ', 'Wang, Q',
        ' Han, R', null, null, '0', null, null,
        'Research on energy conservation and emissions reduction based on AHP-fuzzy synthetic evaluation model: A case study of tobacco enterprises',
        'WOS:000445981200009', 'Article', '2019-11-10 00:00:00', '0959-6526', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('63d19712dae64759a2f1239a380b7f2d', 'Sajid, M; Imran, M; Salahuddin; Iqbal, J', 'Sajid, M', ' Imran, M', null,
        null, '0', null, null,
        'Tailoring structural, surface, optical, and dielectric properties of CuO nanosheets for applications in high-frequency devices',
        'WOS:000448242100001', 'Article', null, '0947-8396', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('65073f8bbc1044f4914c39d2a091d9a8', 'Kong, XS; Wang, F; Zhang, XQ; Liu, ZH; Wang, XL', 'Kong, XS', ' Wang, F',
        null, null, '0', null, null,
        'Dielectric properties of cubic boron nitride modulated by an ultrashort laser pulse', 'WOS:000451571700014',
        'Article', '2019-11-27 00:00:00', '2469-9926', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55',
        0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('66dfa4e245fa4ecf8bcde900f90d92f1', 'Liu, YL; Du, HQ; Wang, ZX; Mei, WB', 'Liu, YL', ' Du, HQ', null, null, '0',
        null, null, 'Convex MR brain image reconstruction via non-convex total variation minimization',
        'WOS:000449769200002', 'Article', null, '0899-9457', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('67f01d428a704f55a0748c87eb34692e', 'Lu, H; Shi, KZ; Zhu, YF; Lv, YS; Niu, ZD', 'Lu, H', ' Shi, KZ', null, null,
        '0', null, null,
        'Sensing Urban Transportation Events from Multi-Channel Social Signals with the Word2vec Fusion Model',
        'WOS:000454817100012', 'Article', null, '1424-8220', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('69af169da0c5447e85b714e9fa1496a6', 'Yang, TR; Liu, WL', 'Yang, TR', ' Liu, WL', null, null, '0', null, null,
        'Does air pollution affect public health and health inequality? Empirical evidence from China',
        'WOS:000447568700005', 'Article', '2019-12-01 00:00:00', '0959-6526', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('69cfd877dc404180af221f4788fbd535', 'Ji, JN; Chen, SL', 'Ji, JN', ' Chen, SL', null, null, '0', null, null,
        'Asymmetric abstraction of two chemically-equivalent methylene hydrogens: significant enantioselectivity of endoperoxide presented by fumitremorgin B endoperoxidase',
        'WOS:000448665900047', 'Article', '2019-11-07 00:00:00', '1463-9076', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('6a148ce286664f80b227c5a0a89e3f1e', 'Zhang, YH; An, JP; Yang, K; Gao, XZ; Wu, JS', 'Zhang, YH', ' An, JP', null,
        null, '0', null, null,
        'Energy-Efficient User Scheduling and Power Control for Multi-Cell OFDMA Networks Based on Channel Distribution Information',
        'WOS:000446881400004', 'Article', '2019-11-15 00:00:00', '1053-587X', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('6a97fc4dce0e465e84ac0c5918d0f853', 'Pang, B; Xiu, ZY', 'Pang, B', ' Xiu, ZY', null, null, '0', null, null,
        'Stratified L-prefilter convergence structures in stratified L-topological spaces', 'WOS:000448418300018',
        'Article', null, '1432-7643', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('6bb5ee99cd724442a52c4f93f7624f81', 'Yuan, XC; Lyu, YJ; Wang, B; Liu, QH; Wu, Q', 'Yuan, XC', ' Lyu, YJ', null,
        null, '0', null, null, 'China''s energy transition strategy at the city level: The role of renewable energy',
        'WOS:000449133300078', 'Article', '2019-12-20 00:00:00', '0959-6526', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('6bbf8a33358147c69b0c43eb35258dae', 'Gao, F; Zhu, LH; Shen, M; Sharif, K; Wan, ZG; Ren, K', 'Gao, F',
        ' Zhu, LH', null, null, '0', null, null,
        'A Blockchain-Based Privacy-Preserving Payment Mechanism for Vehicle-to-Grid Networks', 'WOS:000451962400025',
        'Article', null, '0890-8044', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('6c620a32f37d48699e77c45589c28c8c', 'Xu, YL; Yang, ZM; Yue, BZ; Zhao, LY', 'Xu, YL', ' Yang, ZM', null, null,
        '0', null, null, 'Probabilistic sensitivity analysis for the frame structure of missiles',
        'WOS:000453596600009', 'Article', null, '0954-4062', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('6f545715a85d4c348eaca8459ef2288f', 'Shen, JY; Elwany, A; Cui, LR', 'Shen, JY', ' Elwany, A', null, null, '0',
        null, null, 'Reliability modeling for systems degrading in K cyclical regimes based on gamma processes',
        'WOS:000452280300017', 'Article', null, '1748-006X', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('6f78bc1633c342ea99587b09b6e5cb98',
        'Zhang, XP; Chen, SS; Wu, YG; Jin, SH; Wang, XJ; Wang, YQ; Shang, FQ; Chen, K; Du, JY; Shu, QH', 'Zhang, XP',
        ' Chen, SS', null, null, '0', null, null, 'A novel cocrystal composed of CL-20 and an energetic ionic salt',
        'WOS:000451016200017', 'Article', '2019-12-07 00:00:00', '1359-7345', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('70ab434259b04ff784a48c74b0bcd40c', 'Ma, WH; Wang, NF; Sui, X; Li, SP; Xie, K', 'Ma, WH', ' Wang, NF', null,
        null, '0', null, null,
        'Thermal Safety of a Gun-Launched Missile''s Solid Rocket Motor Under Conditions of High Environm. Temp. and Overloaded Forces',
        'WOS:000452614000012', 'Article', null, '0721-3115', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('70dabf15293041a990f44dd5bbd5d48a', 'Ma, Y; Yu, BY; Xue, MM', 'Ma, Y', ' Yu, BY', null, null, '0', null, null,
        'Spatial Heterogeneous Characteristics of Ridesharing in Beijing-Tianjin-Hebei Region of China',
        'WOS:000451814000352', 'Article', null, '1996-1073', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('70fe68a0341b420fabf4df55fe3200d2', 'Liu, X; Lin, HY; Xiong, LM', 'Liu, X', ' Lin, HY', null, null, '0', null,
        null, 'Forbidden Subgraphs and Weak Locally Connected Graphs', 'WOS:000451607500040', 'Article', null,
        '0911-0119', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('71745f4d866744cab2fd9b38bfa8b7d3',
        'Li, BH; Jiang, L; Li, XW; Lin, ZM; Huang, LL; Wang, AD; Han, WN; Wang, Z; Lu, YF', 'Li, BH', ' Jiang, L', null,
        null, '0', null, null,
        'Flexible Gray-Scale Surface Patterning Through Spatiotemporal-Interference-Based Femtosecond Laser Shaping',
        'WOS:000453480900020', 'Article', '2019-12-17 00:00:00', '2195-1071', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('7485bb14b43e4837902194810c9a89b7', 'Guo, HX; Liang, ZQ; Wang, XB; Zhou, TF; Jiao, L; Teng, LL; Shen, WH',
        'Guo, HX', ' Liang, ZQ', null, null, '0', null, null,
        'Influence of chisel edge thinning on helical point micro-drilling performance', 'WOS:000452076900062',
        'Article', null, '0268-3768', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('74cafcefa41d47f3afb47fa87cf6c291', 'Dong, ZC; Zhang, XY; Shi, WH; Zhou, H; Lei, HS; Liang, J', 'Dong, ZC',
        ' Zhang, XY', null, null, '0', null, null,
        'Study of Size Effect on Microstructure and Mechanical Properties of AlSi10Mg Samples Made by Selective Laser Melting',
        'WOS:000456419200121', 'Article', null, '1996-1944', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('74d8ee154b1c43c887bcb06ecb426fca', 'Ji, HB; Liu, XD; Song, ZY; Zhao, Y', 'Ji, HB', ' Liu, XD', null, null, '0',
        null, null,
        'Time-varying sliding mode guidance scheme for maneuvering target interception with impact angle constraint',
        'WOS:000452316500010', 'Article', null, '0016-0032', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('758a34fb787646c9b74c4231bfaaf596', 'Zhang, Q; Li, F; Wang, Y', 'Zhang, Q', ' Li, F', null, null, '0', null,
        null, 'Mobile Crowd Wireless Charging Toward Rechargeable Sensors for Internet of Things',
        'WOS:000456475500093', 'Article', null, '2327-4662', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('7681bd621b1345ad8c83b40205d48457', 'Sheng, LX; Zhang, XT; Ge, Z; Liang, Z; Liu, XL; Chai, CP; Luo, YJ',
        'Sheng, LX', ' Zhang, XT', null, null, '0', null, null,
        'Preparation and properties of waterborne polyurethane modified by stearyl acrylate for water repellents',
        'WOS:000449402600008', 'Article', null, '1945-9645', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('76c0b36246b94518baa405dcbf1b8ec5',
        'Chen, J; Yuan, XJ; Chen, MJ; Cheng, XD; Zhang, AX; Peng, GT; Song, WL; Fang, DN', 'Chen, J', ' Yuan, XJ', null,
        null, '0', null, null,
        'Ultrabroadband Three-Dimensional Printed Radial Perfectly Symmetric Gradient Honeycomb All-Dielectric Dual-Directional Lightweight Planar Luneburg Lens',
        'WOS:000449887600074', 'Article', '2019-11-07 00:00:00', '1944-8244', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('76dfb650437641d284525da9296316ee', 'Dong, XB; Zhou, TF; Pang, SQ; Liang, ZQ; Ruan, BS; Zhu, ZC; Wang, XB',
        'Dong, XB', ' Zhou, TF', null, null, '0', null, null,
        'Mechanism of burr accumulation and fracture pit formation in ultraprecision microgroove fly cutting of crystalline nickel phosphorus',
        'WOS:000449762400001', 'Article', null, '0960-1317', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('7732f3423aa9476aa0adfc23f26fe70c', 'Yang, JQ; Yin, X; Wu, L; Wu, JT; Zhang, JG; Gozin, M', 'Yang, JQ',
        ' Yin, X', null, null, '0', null, null,
        'Alkaline and Earth Alkaline Energetic Materials Based on a Versatile and Multifunctional 1-Aminotetrazol-5-one Ligand',
        'WOS:000453938700010', 'Article', '2019-12-17 00:00:00', '0020-1669', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('77eed91d30354cae952714acdbfd3cbc', 'Bai, JX; Lu, BC; Han, Q; Li, QS; Qu, LT', 'Bai, JX', ' Lu, BC', null, null,
        '0', null, null,
        '(111) Facets-Oriented Au-Decorated Carbon Nitride Nanoplatelets for Visible-Light-Driven Overall Water Splitting',
        'WOS:000449887600033', 'Article', '2019-11-07 00:00:00', '1944-8244', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('787e79d370884584946574cc3c7a1ee8', 'Li, ZP; Cui, LR; Chen, JH', 'Li, ZP', ' Cui, LR', null, null, '0', null,
        null, 'Traffic accident modelling via self-exciting point processes', 'WOS:000447568900028', 'Article', null,
        '0951-8320', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('78b3e88f4bad4c2b9aa9b70d44977fcc', 'Zhang, M; Gao, CQ; Gao, MW; Zhang, YX; Huang, S', 'Zhang, M', ' Gao, CQ',
        null, null, '0', null, null,
        '16 W single-frequency laser output from an Er: YAG ceramic nonplanar ring oscillator', 'WOS:000449525000001',
        'Article', null, '1612-2011', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('7a08b045db9b4e92bb6a81db34ea4dd4', 'Xiang, CL; Huang, K; Langari, R', 'Xiang, CL', ' Huang, K', null, null,
        '0', null, null,
        'Power-Split Electromechanical Transmission Design and Validation with Three Planetary Gears for Heavy-Duty Vehicle',
        'WOS:000446556200007', 'Article', null, '2228-6187', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('7b164dd73f90495484c246a4ecf5066e', 'Guo, Q; Gao, LJ; Zhai, YB; Xu, W', 'Guo, Q', ' Gao, LJ', null, null, '0',
        null, null, 'Recent developments of miniature ion trap mass spectrometers', 'WOS:000449240600004', 'Review',
        null, '1001-8417', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('7bb5dde959d443a9a483bade8de42c76', 'Duan, SY; Wen, WB; Fang, DN', 'Duan, SY', ' Wen, WB', null, null, '0',
        null, null,
        'A predictive micropolar continuum model for a novel three-dimensional chiral lattice with size effect and tension-twist coupling behavior',
        'WOS:000446291200002', 'Article', null, '0022-5096', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('7c2de363046d4697b6ba81025b5200fb',
        'Zhang, HJ; Wang, W; Pi, SQ; Liu, L; Li, H; Chen, Y; Zhang, YH; Zhang, XH; Li, ZS', 'Zhang, HJ', ' Wang, W',
        null, null, '0', null, null,
        'Gas phase transformation from organic acid to organic sulfuric anhydride: Possibility and atmospheric fate in the initial new particle formation',
        'WOS:000447478100055', 'Article', null, '0045-6535', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('7c558d5b9b56488a8c23b56901e6382f', 'Qian, C; Feng, LH; Yang, AY; Guo, P; Lv, HC', 'Qian, C', ' Feng, LH', null,
        null, '0', null, null,
        'Indoor visible light positioning method based on three light-emitting diodes and an image sensor',
        'WOS:000452360400033', 'Article', null, '0091-3286', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('7c59978b0fa74d779b512b762f4240d7', 'An, XY; Liu, JY; Ye, P; Tian, C; Feng, SS; Dong, YX', 'An, XY', ' Liu, JY',
        null, null, '0', null, null,
        'Axial distribution characteristics of fragments of the warhead with a hollow core', 'WOS:000449140300002',
        'Article', null, '0734-743X', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('7d7283eca3ef48719424a5d71690aa94', 'Fang, WH; Yang, GY', 'Fang, WH', ' Yang, GY', null, null, '0', null, null,
        'Induced Aggregation and Synergistic Coordination Strategy in Cluster Organic Architectures',
        'WOS:000451245900032', 'Review', null, '0001-4842', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('7e79e74fe91b41ef8089acfac1380b63', 'Chen, C; Gou, BC', 'Chen, C', ' Gou, BC', null, null, '0', null, null,
        'Dipole Polarizabilities of the Ground States for Berylliumlike Ions', 'WOS:000455133400016', 'Article', null,
        '0253-6102', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('7eb909d5fa094b5c8d6660bd03bb3a2b', 'Ba, X; Guo, YG; Zhu, JG; Zhang, CN', 'Ba, X', ' Guo, YG', null, null, '0',
        null, null,
        'An Equivalent Circuit Model for Predicting the Core Loss in a Claw-Pole Permanent Magnet Motor With Soft Magnetic Composite Core',
        'WOS:000447832100318', 'Article', null, '0018-9464', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('7efba3c7d8b94a49be56aee865503740', 'Tirop, PK; Zhang, JR', 'Tirop, PK', ' Zhang, JR', null, null, '0', null,
        null, 'Control of pendular motion on tethered satellites systems', 'WOS:000450861500019', 'Article',
        '2019-11-14 00:00:00', '1748-8842', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('7f46c4c081a34d2c9541c16696c5deb9', 'Huo, YX; Ren, HY; Yu, H; Zhao, LY; Yu, SZ; Yan, YJ; Chen, ZY', 'Huo, YX',
        ' Ren, HY', null, null, '0', null, null,
        'CipA-mediating enzyme self-assembly to enhance the biosynthesis of pyrogallol in Escherichia coli',
        'WOS:000450495500011', 'Article', null, '0175-7598', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('7fa456ab77284ced9a1a06b12ee786c4', 'Gu, SC; Xiao, N; Wu, F; Bai, Y; Wu, C; Wu, YY', 'Gu, SC', ' Xiao, N', null,
        null, '0', null, null,
        'Chemical Synthesis of K2S2 and K2S3 for Probing Electrochemical Mechanisms in K-S Batteries',
        'WOS:000453805100002', 'Article', null, '2380-8195', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('802489bc99b2402fba603e33bfa98b5e', 'Li, YZ; Hu, JJ; Wu, ZZ; Liu, C; Peng, FF; Zhang, Y', 'Li, YZ', ' Hu, JJ',
        null, null, '0', null, null, 'Research on QoS service composition based on coevolutionary genetic algorithm',
        'WOS:000451472000018', 'Article', null, '1432-7643', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('81196a5a2a3e4a368d9c6d7d897f2cbc', 'Shen, BL; Chang, J; Wu, CH; Jin, YH; Chen, WL; Song, DL; Mu, Y',
        'Shen, BL', ' Chang, J', null, null, '0', null, null,
        'Local zoom system for agricultural pest detection and recognition', 'WOS:000448721200001', 'Article', null,
        '0946-2171', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('8180af35d50240efad99f16fae643578', 'Li, J; Ning, JG', 'Li, J', ' Ning, JG', null, null, '0', null, null,
        'Experimental and numerical studies on detonation reflections over cylindrical convex surfaces',
        'WOS:000452581400012', 'Article', null, '0010-2180', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('818b7475e5ad4ab8a8f2a1173e161585',
        'Ren, S; Tao, X; Xu, XQ; Gu, AR; Liu, JC; Fan, JP; Ge, JR; Fang, DN; Liang, J', 'Ren, S', ' Tao, X', null, null,
        '0', null, null,
        'Preparation and characteristic of the fly ash cenospheres/mullite composite for high-temperature application',
        'WOS:000441893200035', 'Article', '2019-12-01 00:00:00', '0016-2361', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('818f2fccf2194aebb7e307ea004b0361', 'Li, S; Song, SJ; Wan, YH', 'Li, S', ' Song, SJ', null, null, '0', null,
        null, 'Laplacian twin extreme learning machine for semi-supervised classification', 'WOS:000447385100002',
        'Article', '2019-12-10 00:00:00', '0925-2312', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55',
        0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('82435a1a982141108852d9340c3010fe',
        'Di, QM; Wang, JW; Zhao, ZJ; Liu, JJ; Xu, M; Liu, J; Rong, HP; Chen, WX; Zhang, JT', 'Di, QM', ' Wang, JW',
        null, null, '0', null, null,
        'Near-Infrared Luminescent Ternary Ag3SbS3 Quantum Dots by in situ Conversion of Ag Nanocrystals with Sb(C9H19COOS)(3)',
        'WOS:000453065900011', 'Article', '2019-12-12 00:00:00', '0947-6539', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('8306187c1c144aef9d9b75111d2ef4da',
        'Wang, JF; Chen, SS; Jin, SH; Shi, R; Yu, ZF; Su, Q; Ma, X; Zhang, CY; Shu, QH', 'Wang, JF', ' Chen, SS', null,
        null, '0', null, null,
        'The primary decomposition product of TKX-50 under adiabatic condition and its thermal decomposition',
        'WOS:000452552900060', 'Article', null, '1388-6150', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('83889458cb1440c1b949a121e3673f59',
        'Wu, F; Zhao, SY; Chen, L; Lu, Y; Su, YF; Li, J; Bao, LY; Yao, JY; Zhou, YW; Chen, RJ', 'Wu, F', ' Zhao, SY',
        null, null, '0', null, null,
        'Electron bridging structure glued yolk-shell hierarchical porous carbon/sulfur composite for high performance Li-S batteries',
        'WOS:000449708500023', 'Article', '2019-12-01 00:00:00', '0013-4686', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('83a66c364e6740309c9dc5a0e6a6caac', 'Chen, GL; Sun, J; Chen, J', 'Chen, GL', ' Sun, J', null, null, '0', null,
        null, 'Mean square exponential stabilization of sampled-data Markovian jump systems', 'WOS:000450110800011',
        'Article', '2019-12-01 00:00:00', '1049-8923', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55',
        0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('848dbd7860554cde9bd9b2b36ad424e4', 'Lyu, CQ; Wang, L; Zhang, JH', 'Lyu, CQ', ' Wang, L', null, null, '0', null,
        null, 'Deep learning for DNase I hypersensitive sites identification', 'WOS:000454632500012',
        'Article; Proceedings Paper', null, '1471-2164', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55',
        0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('85969349518c4483b9aa4f8c47efa52a', 'Yang, YT; Song, T', 'Yang, YT', ' Song, T', null, null, '0', null, null,
        'Local Name Translation for Succinct Communication Towards Named Data Networking of Things',
        'WOS:000453624300039', 'Article', null, '1089-7798', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('8637622142fc447199f6c80bc7b4b5fe', 'Yu, QQ; Xiong, R; Wang, LY; Lin, C', 'Yu, QQ', ' Xiong, R', null, null,
        '0', null, null, 'A Comparative Study on Open Circuit Voltage Models for Lithium-ion Batteries',
        'WOS:000441959600001', 'Article', null, '1000-9345', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('8705c1638f724f7ea74809062e1f81a5', 'Chambua, J; Niu, ZD; Yousif, A; Mbelwa, J', 'Chambua, J', ' Niu, ZD', null,
        null, '0', null, null,
        'Tensor factorization method based on review text semantic similarity for rating prediction',
        'WOS:000446949300048', 'Review', '2019-12-30 00:00:00', '0957-4174', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('871d3b044ee14b55957996788cbb86fb', 'Wang, CZ; Zhao, YJ; Zhai, XM; Zhao, XC; Li, JB; Jin, HB', 'Wang, CZ',
        ' Zhao, YJ', null, null, '0', null, null,
        'Confining ferric oxides in porous carbon for efficient lithium storage', 'WOS:000449708500094', 'Article',
        '2019-12-01 00:00:00', '0013-4686', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('8817d638311a42168bf7f7f100c5b03f', 'Wang, XY; Tang, BJ', 'Wang, XY', ' Tang, BJ', null, null, '0', null, null,
        'Review of comparative studies on market mechanisms for carbon emission reduction: a bibliometric analysis',
        'WOS:000452733500009', 'Review', null, '0921-030X', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('8858561ef02343ccba4e8d6e4c52de30', 'Fan, ZY; Jiang, J; Weng, SQ; He, ZH; Liu, ZW', 'Fan, ZY', ' Jiang, J',
        null, null, '0', null, null, 'Adaptive Crowd Segmentation Based on Coherent Motion Detection',
        'WOS:000447008000003', 'Article', null, '1939-8018', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('8a3dc01819634fbe8f96007793c28c57', 'Han, C; Shu, JC; Xiang, K; Yang, HJ; Yuan, J; Cao, MS', 'Han, C',
        ' Shu, JC', null, null, '0', null, null,
        'The synergetic electromagnetic properties and enhanced microwave absorption of BiFeO3/BaFe7(MnTi)(2.5)O-19 composite',
        'WOS:000448831000014', 'Article', null, '0957-4522', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('8e8d5381e4c04e508e0f4f50e9bf630c', 'Yan, YL; Yue, BZ', 'Yan, YL', ' Yue, BZ', null, null, '0', null, null,
        'STUDY ON RIGID-LIQUID COUPLING DYNAMICS OF THE SPACECRAFT WITH ARBITRARY AXISYMMETRICAL TANKS',
        'WOS:000453921000008', 'Article', null, '1727-7191', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('8ee94714be36459aab207ec9ebc569a7', 'Dong, YY; Zhao, YZ; Zhang, SY; Dai, Y; Liu, L; Li, YJ; Chen, Q',
        'Dong, YY', ' Zhao, YZ', null, null, '0', null, null,
        'Recent advances toward practical use of halide perovskite nanocrystals', 'WOS:000456724800006', 'Review',
        '2019-11-28 00:00:00', '2050-7488', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('8f0be7ae48ef4a4a91521248e3b53459', 'Shi, LL; Jayakoby, H; Katupitiya, J; Jin, X', 'Shi, LL', ' Jayakoby, H',
        null, null, '0', null, null, 'Coordinated Control of a Dual-Arm Space Robot', 'WOS:000453557700011', 'Article',
        null, '1070-9932', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('8f42569f914440259982e272422d2120', 'Yu, TL; Lu, SX; Xu, WG', 'Yu, TL', ' Lu, SX', null, null, '0', null, null,
        'A reliable filter for oil-water separation: Bismuth coated superhydrophobic/superoleophilic iron mesh',
        'WOS:000449481200068', 'Article', '2019-11-15 00:00:00', '0925-8388', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('8f451760315e493e968b3da54670e460', 'Ma, C; Lei, HS; Liang, J; Wua, WW; Wang, TJ; Fang, DN', 'Ma, C',
        ' Lei, HS', null, null, '0', null, null,
        'Macroscopic mechanical response of chiral-type cylindrical metastructures under axial compression loading',
        'WOS:000443715000019', 'Article', '2019-11-15 00:00:00', '0264-1275', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('90e908d2986b439ca82336843dda698d', 'Liu, L; Zheng, W; Ma, Z; Liu, YB', 'Liu, L', ' Zheng, W', null, null, '0',
        null, null, 'Study on water corrosion behavior of ZrSiO4 materials', 'WOS:000453768100005', 'Article', null,
        '2226-4108', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('917b742fac874438960b01dac08ea54d', 'Tian, YN; Li, DN; Zhou, PY; Guo, RT; Liu, ZH', 'Tian, YN', ' Li, DN', null,
        null, '0', null, null, 'An ACO-based hyperheuristic with dynamic decision blocks for intercell scheduling',
        'WOS:000449950800014', 'Article', null, '0956-5515', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('922c6e10a751496f883d70adc710e929', 'Meng, T; Cao, MH', 'Meng, T', ' Cao, MH', null, null, '0', null, null,
        'Transition Metal Carbide Complex Architectures for Energy-Related Applications', 'WOS:000450258500003',
        'Review', '2019-11-13 00:00:00', '0947-6539', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55',
        0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('92525ad0aa084bc6b7bef36e3e459c15', 'Zhang, K; Li, JR; Wen, DS; Liu, HL; Wang, HY; Lamusi, A', 'Zhang, K',
        ' Li, JR', null, null, '0', null, null,
        'Study on the Synthesis and Insecticidal Activity of Spinosyn A Derivatives', 'WOS:000455093900027', 'Article',
        '2019-12-25 00:00:00', '0253-2786', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('92b3f7804a0c4ac7919c7271204a0545', 'Wang, B; Sun, YF; Wang, ZH', 'Wang, B', ' Sun, YF', null, null, '0', null,
        null,
        'Agglomeration effect of CO2 emissions and emissions reduction effect of technology: A spatial econometric perspective based on China''s province-level data',
        'WOS:000448092500010', 'Article', '2019-12-10 00:00:00', '0959-6526', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('93a41323855740aa97bbb0d244a56696', 'Chen, J; Kai, SX', 'Chen, J', ' Kai, SX', null, null, '0', null, null,
        'Cooperative transportation control of multiple mobile manipulators through distributed optimization',
        'WOS:000451062400001', 'Article', null, '1674-733X', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('945556563d164b5eb8fdb81dadb32e63', 'Wang, J; Du, ZR; Lian, T', 'Wang, J', ' Du, ZR', null, null, '0', null,
        null, 'Extrusion-calendering process of single-polymer composites based on polyethylene', 'WOS:000451874000005',
        'Article', null, '0032-3888', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('9485197e7ad64b41a0eda7cf3e4e75aa', 'Dong, JZ; Zhao, YC; Cheng, Y; Zhou, XM', 'Dong, JZ', ' Zhao, YC', null,
        null, '0', null, null,
        'Underwater Acoustic Manipulation Using Solid Metamaterials With Broadband Anisotropic Density',
        'WOS:000456058600007', 'Article', null, '0021-8936', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('95b4ad872c13430990df4e2b980ef079', 'An, T; He, W; Chen, SW; Zuo, BL; Qi, XF; Zhao, FQ; Luo, YJ; Yan, QL',
        'An, T', ' He, W', null, null, '0', null, null,
        'Thermal Behavior and Thermolysis Mechanisms of Ammonium Perchlorate under the Effects of Graphene Oxide-Doped Complexes of Triaminoguanidine',
        'WOS:000451933400020', 'Article', '2019-11-29 00:00:00', '1932-7447', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('964cecb5d5334bc5a0e9cfb33d96c946', 'Ding, F; Jin, H', 'Ding, F', ' Jin, H', null, null, '0', null, null,
        'On the Optimal Speed Profile for Eco-Driving on Curved Roads', 'WOS:000452128400021', 'Article', null,
        '1524-9050', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('96c928b9ebbb4a86829c0b5ff7bd4e91', 'Lu, LH; Di, HJ; Lu, Y; Zhang, L; Wang, SZ', 'Lu, LH', ' Di, HJ', null,
        null, '0', null, null, 'A two-level attention-based interaction model for multi-person activity recognition',
        'WOS:000447624800018', 'Article', '2019-12-17 00:00:00', '0925-2312', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('982a90b5e33c49f8a6d72c8d08737503', 'Chu, QZ; Shi, BL; Liao, LJ; Luo, KH; Wang, NF; Huang, CG', 'Chu, QZ',
        ' Shi, BL', null, null, '0', null, null,
        'Ignition and Oxidation of Core-Shell Al/Al2O3 Nanoparticles in an Oxygen Atmosphere: Insights from Molecular Dynamics Simulation',
        'WOS:000454751000057', 'Article', '2019-12-27 00:00:00', '1932-7447', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('98fd9575cec84cecb9fb22f481c96b50', 'Li, PY; Zhang, SH; Zhang, XD', 'Li, PY', ' Zhang, SH', null, null, '0',
        null, null, 'Classically high-dimensional correlation: simulation of high-dimensional entanglement',
        'WOS:000451213200031', 'Article', '2019-11-26 00:00:00', '1094-4087', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('99556907a8f941cd9ddfd8daa89be280',
        'Cai, H; Wang, Y; Rong, KP; Yu, H; Wang, SY; Han, JH; An, GF; Xue, LP; Zhang, W; Wang, HY; Zhou, J', 'Cai, H',
        ' Wang, Y', null, null, '0', null, null,
        'Theoretical analyses for an alkali laser pumped by a pulsed light source', 'WOS:000451729800009', 'Article',
        null, '1042-346X', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('9aba3a189a504cd4a24993bf4184cc14', 'Qiu, SC; Ma, XJ; Huang, BA; Li, DQ; Wang, GY; Zhang, MD', 'Qiu, SC',
        ' Ma, XJ', null, null, '0', null, null,
        'Numerical simulation of single bubble dynamics under acoustic standing waves', 'WOS:000445993700024',
        'Article', null, '1350-4177', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('9c039e328d134eee94f31b20f2ea8cad', 'Sun, XP; Wei, RJ; Yao, ZS; Tao, J', 'Sun, XP', ' Wei, RJ', null, null, '0',
        null, null,
        'Solvent Effects on the Structural Packing and Spin-Crossover Properties of a Mononuclear Iron(II) Complex',
        'WOS:000449887200054', 'Article', null, '1528-7483', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('9c61fd2acea64702917d5bc1f637cb0a', 'Liu, Y; Gao, JY; Shi, XY; Jiang, CY', 'Liu, Y', ' Gao, JY', null, null,
        '0', null, null,
        'Decentralization of Virtual Linkage in Formation Control of Multi-Agents via Consensus Strategies',
        'WOS:000451302800010', 'Article', null, '2076-3417', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('9cd386adc5bb4edf849fdfd3c82693d1', 'Wang, FJ; Wang, MH; Shao, ZQ', 'Wang, FJ', ' Wang, MH', null, null, '0',
        null, null,
        'Dispersion of reduced graphene oxide with montmorillonite for enhancing dielectric properties and thermal stability of cyanoethyl cellulose nanocomposites',
        'WOS:000449946300024', 'Article', null, '0969-0239', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('9cd3ac69ab924b8db35fba13cde046f9', 'Wu, Y; Yu, XL; Lin, X; Li, S; Wei, XL; Zhu, C; Wu, LL', 'Wu, Y', ' Yu, XL',
        null, null, '0', null, null,
        'Experimental investigation of fuel composition and mix-enhancer effects on the performance of paraffin-based hybrid rocket motors',
        'WOS:000449891400056', 'Article', null, '1270-9638', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('a0ffc309ed3449388289de00ecaa41d5', 'Ran, C; Chen, PW', 'Ran, C', ' Chen, PW', null, null, '0', null, null,
        'Shear localization and recrystallization in high strain rate deformation in Ti-5Al-5Mo-5V-1Cr-1Fe alloy',
        'WOS:000443261300038', 'Article', '2019-12-01 00:00:00', '0167-577X', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('a1a3a71acee34ba6b77b3f12eb728533',
        'Ming, ZJ; Nellippallil, AB; Yan, Y; Wang, GX; Goh, CH; Allen, JK; Mistree, F', 'Ming, ZJ', ' Nellippallil, AB',
        null, null, '0', null, null,
        'PDSIDES-A Knowledge-Based Platform for Decision Support in the Design of Engineering Systems',
        'WOS:000448396700003', 'Article', null, '1530-9827', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('a226248decef4251a7147ca439677d3e', 'Liu, LJ; Zhang, Q', 'Liu, LJ', ' Zhang, Q', null, null, '0', null, null,
        'Comparison of detonation characteristics in energy output of gaseous JP-10 and propylene oxide in air',
        'WOS:000438692100018', 'Article', '2019-11-15 00:00:00', '0016-2361', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('a29b24fcd01546ebaf7dd5c5d40f5ef9', 'Huang, J; Chen, SJ; Xue, ZH; Withayachumnankul, W; Fumeaux, C', 'Huang, J',
        ' Chen, SJ', null, null, '0', null, null,
        'Wideband Endfire 3-D-Printed Dielectric Antenna With Designable Permittivity', 'WOS:000451983500019',
        'Article', null, '1536-1225', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('a309b6f85b2940bb9a0d9a2b465cc8b9',
        'Afifi, MA; Wang, YC; Pereira, PHR; Huang, Y; Wang, YW; Cheng, XW; Li, SK; Langdon, TG', 'Afifi, MA',
        ' Wang, YC', null, null, '0', null, null,
        'Mechanical properties of an Al-Zn-Mg alloy processed by ECAP and heat treatments', 'WOS:000449481200074',
        'Article', '2019-11-15 00:00:00', '0925-8388', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55',
        0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('a37ad3ee115a4bd49a51afca237ab94b',
        'Tang, SX; Zhao, Y; Wang, HT; Wang, YQ; Zhu, HX; Chen, Y; Chen, SS; Jin, SH; Yang, ZM; Li, PW; Li, SD',
        'Tang, SX', ' Zhao, Y', null, null, '0', null, null,
        'Preparation of the Sodium Alginate-g-(Polyacrylic Acid-co-Allyltrimethylammonium Chloride) Polyampholytic Superabsorbent Polymer and Its Dye Adsorption Property',
        'WOS:000454726400017', 'Article', null, '1660-3397', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('a3a0d3950630437f8b2dbafb7fe799c9', 'Miao, FC; Zhou, L; Zhang, XR; Cao, TT', 'Miao, FC', ' Zhou, L', null, null,
        '0', null, null,
        'Simulation of shock initiation in explosives using a model combining high computational efficiency with a free choice of mixture rules',
        'WOS:000454615100023', 'Article', null, '2158-3226', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('a3ad0c5cebec4a4593b63b37708774e7', 'Wang, J; Xiong, R; Li, LL; Fang, Y', 'Wang, J', ' Xiong, R', null, null,
        '0', null, null,
        'A comparative analysis and validation for double-filters-based state of charge estimators using battery-in-the-loop approach',
        'WOS:000449891500051', 'Article', '2019-11-01 00:00:00', '0306-2619', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('a50557d5f8954357adf449aad727341a', 'Lian, YM; Ni, M; Zhou, L; Chen, RJ; Yang, W', 'Lian, YM', ' Ni, M', null,
        null, '0', null, null,
        'Synthesis of Biomass-Derived Carbon Induced by Cellular Respiration in Yeast for Supercapacitor Applications',
        'WOS:000453050900026', 'Article', '2019-12-05 00:00:00', '0947-6539', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('a59da5452cb04106ba84ade6a20e4943', 'Xin, HC; Bai, X; Song, YE; Li, BZ; Tao, R', 'Xin, HC', ' Bai, X', null,
        null, '0', null, null,
        'ISAR imaging of target with complex motion associated with the fractional Fourier transform',
        'WOS:000453637100028', 'Article', null, '1051-2004', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('a5be7bc406bc416c8e3373395ca92d7d',
        'Liao, ZR; Wang, JF; Zhang, PJ; Zhang, Y; Miao, YF; Gao, SM; Deng, YL; Geng, LN', 'Liao, ZR', ' Wang, JF', null,
        null, '0', null, null,
        'Recent advances in microfluidic chip integrated electronic biosensors for multiplexed detection',
        'WOS:000447819700032', 'Review', '2019-12-15 00:00:00', '0956-5663', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('a5e4e56c356a46188476c2c248236cbe', 'Khan, AA; Yu, ZN; Khan, U; Dong, L', 'Khan, AA', ' Yu, ZN', null, null,
        '0', null, null, 'Solution Processed Trilayer Structure for High-Performance Perovskite Photodetector',
        'WOS:000452517100002', 'Article', '2019-12-06 00:00:00', '1556-276X', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('a66a57021eae48c3ba9586fe573bcba8', 'Liang, ZQ; Gao, P; Wang, XB; Li, SD; Zhou, TF; Xiang, JF', 'Liang, ZQ',
        ' Gao, P', null, null, '0', null, null,
        'Cutting Performance of Different Coated Micro End Mills in Machining of Ti-6Al-4V', 'WOS:000451314900031',
        'Article', null, '2072-666X', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('a7a8dfdabc014a1c8143083f258ee36a', 'Li, X; Qiao, D; Li, P', 'Li, X', ' Qiao, D', null, null, '0', null, null,
        'Bounded trajectory design and self-adaptive maintenance control near non-synchronized binary systems comprised of small irregular bodies',
        'WOS:000449235500075', 'Article', null, '0094-5765', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('a8023d83c87647179b6eee116eba3baa', 'Wang, B; Sun, YF; Chen, QX; Wang, ZH', 'Wang, B', ' Sun, YF', null, null,
        '0', null, null,
        'Determinants analysis of carbon dioxide emissions in passenger and freight transportation sectors in China',
        'WOS:000454377700012', 'Article', null, '0954-349X', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('ac6e937f76d14137ab3b5d103b371041', 'Wei, TT; Qian, XM; Yuan, MQ', 'Wei, TT', ' Qian, XM', null, null, '0',
        null, null, 'Quantitative risk assessment of direct lightning strike on external floating roof tank',
        'WOS:000454378300019', 'Article', null, '0950-4230', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('ac8920805651474480e6f2680acf7a46', 'Wang, X; Shu, JC; He, XM; Zhang, M; Wang, XX; Gao, C; Yuan, J; Cao, MS',
        'Wang, X', ' Shu, JC', null, null, '0', null, null,
        'Green Approach to Conductive PEDOT:PSS Decorating Magnetic-Graphene to Recover Conductivity for Highly Efficient Absorption',
        'WOS:000449577200046', 'Article', '2019-11-05 00:00:00', '2168-0485', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('acfe2711cf2f4bb4ac5d55544bf3ac2c', 'Lin, J; Liao, NF; Song, CY', 'Lin, J', ' Liao, NF', null, null, '0', null,
        null, 'Compensation method of edge spectral response for interferometric spectrometer', 'WOS:000456725400018',
        'Article', null, '0091-3286', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('ad6c4419ea774471a3301c18df2077da', 'Wang, HT; Lu, SX; Xu, WG; Wu, B; He, G; Cui, S; Zhang, Y', 'Wang, HT',
        ' Lu, SX', null, null, '0', null, null,
        'Synthesis of a Pt/reduced graphene oxide/polydopamine composite material for localized surface plasmon resonance and methanol electrocatalysis',
        'WOS:000456501100017', 'Article', '2019-12-21 00:00:00', '1144-0546', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('ae0bb6432fef40698b50e508aa888248', 'Chen, GJ; Hou, FJ; Chang, KL; Zhai, YB; Du, YQ', 'Chen, GJ', ' Hou, FJ',
        null, null, '0', null, null,
        'Driving factors of electric carbon productivity change based on regional and sectoral dimensions in China',
        'WOS:000449133300037', 'Article', '2019-12-20 00:00:00', '0959-6526', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('aeaf970a9be1445a8a08e08b6592c718', 'Wang, KL; Liu, XT; Pei, PC; Xiao, Y; Wang, YC', 'Wang, KL', ' Liu, XT',
        null, null, '0', null, null,
        'Guiding bubble motion of rechargeable zinc-air battery with electromagnetic force', 'WOS:000444001900020',
        'Article', '2019-11-15 00:00:00', '1385-8947', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55',
        0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('afe8616620334adab5d3ddd2c3b2e8b1', 'Wang, NN; Liu, JX; Chang, WL; Lee, CF', 'Wang, NN', ' Liu, JX', null, null,
        '0', null, null,
        'A numerical study of the combustion and jet characteristics of a hydrogen fueled turbulent hot-jet ignition (THJI) chamber',
        'WOS:000450539500074', 'Article', '2019-11-08 00:00:00', '0360-3199', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('afff3011f13040b180c8febafd7abf1e', 'Bai, JX; Han, Q; Cheng, ZH; Qu, LT', 'Bai, JX', ' Han, Q', null, null, '0',
        null, null,
        'Wall-Mesoporous Graphitic Carbon Nitride Nanotubes for Efficient Photocatalytic Hydrogen Evolution',
        'WOS:000449792900006', 'Article', '2019-11-02 00:00:00', '1861-4728', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('b086318ad0de42ea97914ab4107a74f1', 'Zhao, YJ; Li, C', 'Zhao, YJ', ' Li, C', null, null, '0', null, null,
        'Biosynthesis of Plant Triterpenoid Saponins in Microbial Cell Factories', 'WOS:000451496600002', 'Review',
        '2019-11-21 00:00:00', '0021-8561', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('b136e67ef21244d9b15282938fd2bd04',
        'Huang, YX; Wang, ZH; Jiang, Y; Li, SJ; Li, ZH; Zhang, HQ; Wu, F; Xie, M; Li, L; Chen, RJ', 'Huang, YX',
        ' Wang, ZH', null, null, '0', null, null,
        'Hierarchical porous Co0.85Se@reduced graphene oxide ultrathin nanosheets with vacancy-enhanced kinetics as superior anodes for sodium-ion batteries',
        'WOS:000448994600059', 'Article', null, '2211-2855', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('b22193c9800b4ebe975cda7562f5db8d', 'Wan, SS; Niu, ZD', 'Wan, SS', ' Niu, ZD', null, null, '0', null, null,
        'An e-learning recommendation approach based on the self-organization of learning resource',
        'WOS:000446283900007', 'Article', '2019-11-15 00:00:00', '0950-7051', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('b223913f7aec4ae6bb6fc13bf1340759', 'Zeng, GQ; Zhang, BH; Yao, FX; Chai, SC', 'Zeng, GQ', ' Zhang, BH', null,
        null, '0', null, null,
        'Modified bidirectional extreme learning machine with Gram-Schmidt orthogonalization method',
        'WOS:000443971900041', 'Article', '2019-11-17 00:00:00', '0925-2312', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('b2e42296a6cf4757be3432157b2591c9', 'Hou, ZL; Yang, F; Zhou, ZB; Ao, YF; Yao, B', 'Hou, ZL', ' Yang, F', null,
        null, '0', null, null,
        'Silver-promoted cross-coupling of substituted allyl(trimethyl)silanes with aryl iodides by palladium catalysis',
        'WOS:000453643700006', 'Article', '2019-12-26 00:00:00', '0040-4039', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('b3ecb76acb3c45aaa556d787465a526d', 'Wu, HT; Sun, W; Shen, JR; Mao, Z; Wang, HG; Cai, HQ; Wang, ZH; Sun, KN',
        'Wu, HT', ' Sun, W', null, null, '0', null, null,
        'Electrospinning Derived Hierarchically Porous Hollow CuCo2O4 Nanotubes as an Effectively Bifunctional Catalyst for Reversible Li-O-2 Batteries',
        'WOS:000449577200171', 'Article', '2019-11-05 00:00:00', '2168-0485', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('b3f4515135004ff2b248fdf1dcc157d0', 'Gao, N; Li, W; Sun, R; Xing, XX; Wang, P; Sakai, T', 'Gao, N', ' Li, W',
        null, null, '0', null, null,
        'A fatigue assessment approach involving small crack growth modelling for structural alloy steels with interior fracture behavior',
        'WOS:000451634600014', 'Article', null, '0013-7944', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('b43a345df41e46b4a9a42cf37e9e1296', 'Yin, SP; Zhang, ZH; Cheng, XW; Su, TJ; Hu, ZY; Song, Q; Wang, H',
        'Yin, SP', ' Zhang, ZH', null, null, '0', null, null,
        'Spark plasma sintering of B4C-TiB2-SiC composite ceramics using B4C, Ti3SiC2 and Si as starting materials',
        'WOS:000448226900131', 'Article', '2019-12-01 00:00:00', '0272-8842', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('b4d5f37192104a87a9a0ba82139c29fc', 'Jiang, ZT; Lv, ZT', 'Jiang, ZT', ' Lv, ZT', null, null, '0', null, null,
        'Influences of strains on the formation of the quasi-Dirac cone and the Landau levels in black phosphorus',
        'WOS:000449132100009', 'Article', '2019-11-30 00:00:00', '0375-9601', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('b515852c88494057ac1a0e121023bf3a', 'Xi, FB; Zhu, C', 'Xi, FB', ' Zhu, C', null, null, '0', null, null,
        'On the martingale problem and Feller and strong Feller properties for weakly coupled Levy type operators',
        'WOS:000450385600011', 'Article', null, '0304-4149', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('b5fa3b2a6389496cbd5f4d21f43dfb1e',
        'Zhao, RZ; Sain, B; Wei, QS; Tang, CC; Li, XW; Weiss, T; Huang, LL; Wang, YT; Zentgraf, T', 'Zhao, RZ',
        ' Sain, B', null, null, '0', null, null, 'Multichannel vectorial holographic display and encryption',
        'WOS:000452470500002', 'Article', '2019-11-28 00:00:00', '2047-7538', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('b61a091637ea4291bc2c5b770cbad80d', 'Gao, HC; Jiang, Y; Cui, Y; Zhang, LC; Jia, JS; Hu, J', 'Gao, HC',
        ' Jiang, Y', null, null, '0', null, null,
        'Dual-Cavity Fabry-Perot Interferometric Sensors for the Simultaneous Measurement of High Temperature and High Pressure',
        'WOS:000450618800018', 'Article', '2019-12-15 00:00:00', '1530-437X', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('b90394081e5046e5a0371cb3ad0db70a', 'Mao, JN; Gao, Z; Wu, YP; Alouini, MS', 'Mao, JN', ' Gao, Z', null, null,
        '0', null, null,
        'Over-Sampling Codebook-Based Hybrid Minimum Sum-Mean-Square-Error Precoding for Millimeter-Wave 3D-MIMO',
        'WOS:000454240000013', 'Article', null, '2162-2337', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('b9460b2e403d449a81a39ad5181d2ed1', 'Zhu, ZY; Zheng, HF; Wang, QS; Chen, MX; Li, ZL; Zhang, B', 'Zhu, ZY',
        ' Zheng, HF', null, null, '0', null, null,
        'The study of a novel light concentration and direct heating solar distillation device embedded underground',
        'WOS:000447476500008', 'Article', '2019-12-01 00:00:00', '0011-9164', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('ba43e5ff7e0f46169e5d349967277b17', 'Liu, FS; Hua, Y; Wu, H; Lee, CF; He, X', 'Liu, FS', ' Hua, Y', null, null,
        '0', null, null,
        'An experimental study on soot distribution characteristics of ethanol-gasoline blends in laminar diffusion flames',
        'WOS:000452584800020', 'Article', null, '1743-9671', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('bb6528b060634d0eaa60d2457b689a75',
        'Yang, P; Yao, YF; Mi, ZF; Cao, YF; Liao, H; Yu, BY; Liang, QM; Coffman, D; Wei, YM', 'Yang, P', ' Yao, YF',
        null, null, '0', null, null, 'Social cost of carbon under shared socioeconomic pathways', 'WOS:000455061900020',
        'Article', null, '0959-3780', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('bd58bcfafc6f41ce8b4e5295d8067d1e', 'Khan, NH; Ju, YB; Hassan, ST', 'Khan, NH', ' Ju, YB', null, null, '0',
        null, null,
        'Modeling the impact of economic growth and terrorism on the human development index: collecting evidence from Pakistan',
        'WOS:000451954700074', 'Article', null, '0944-1344', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('bda5d40c38d64f2cb721bdfba7f3ebb6', 'Cai, ZX; Awais, MA; Zhang, N; Yu, LP', 'Cai, ZX', ' Awais, MA', null, null,
        '0', null, null, 'Exploration of Syntheses and Functions of Higher Ladder-type pi-Conjugated Heteroacenes',
        'WOS:000449667900008', 'Review', '2019-11-08 00:00:00', '2451-9294', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('be2cdd91f11743d094bc0998ba236656', 'Zhang, B; Lai, KH; Wang, B; Wang, ZH', 'Zhang, B', ' Lai, KH', null, null,
        '0', null, null,
        'Financial benefits from corporate announced practice of industrial waste recycling: Empirical evidence from chemical industry in China',
        'WOS:000447575900005', 'Article', null, '0921-3449', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('be34f929a9db4d098b519252249de2fe', 'Hua, Y; Liu, FS; Wu, H; Lee, CF; Wang, ZM', 'Hua, Y', ' Liu, FS', null,
        null, '0', null, null,
        'Experimental Evaluation of Various Gasoline Surrogates Based on Soot Formation Characteristics',
        'WOS:000451101300087', 'Article', null, '0887-0624', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('bf16d7405fa14ce8a60c1a13c7e63226', 'Wang, ZY; Li, PF; Song, WD', 'Wang, ZY', ' Li, PF', null, null, '0', null,
        null,
        'Inelastic deformation micromechanism and modified fragmentation model for silicon carbide under dynamic compression',
        'WOS:000443826600023', 'Article', '2019-11-05 00:00:00', '0264-1275', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('bfeccc5ef2454678b036f52d0342e01e', 'Zhang, GW; Cao, RG; Li, P', 'Zhang, GW', ' Cao, RG', null, null, '0', null,
        null, 'Analysis of a Measurement Method for the Railgun Current and the Armature''s Speed and Initial Position',
        'WOS:000450241700007', 'Article', '2019-12-01 00:00:00', '1530-437X', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('c05d88bb888e4a18ad5456cd7498d1ee', 'Zhao, YS; Zheng, HF; Sun, BY; Li, CJ; Wu, Y', 'Zhao, YS', ' Zheng, HF',
        null, null, '0', null, null,
        'Development and performance studies of a novel portable solar cooker using a curved Fresnel lens concentrator',
        'WOS:000451499500026', 'Article', '2019-11-01 00:00:00', '0038-092X', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('c09801c109154fa39efb167f7879caae', 'Li, JH; Wu, HB; Mei, FX', 'Li, JH', ' Wu, HB', null, null, '0', null, null,
        'Hyperchaos in constrained Hamiltonian system and its control', 'WOS:000450770300010', 'Article', null,
        '0924-090X', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('c12eb26ea7ed46c1955e962002fb74d2', 'Zhou, H; Liu, H; Gao, P; Xiang, CL', 'Zhou, H', ' Liu, H', null, null, '0',
        null, null, 'Optimization Design and Performance Analysis of Vehicle Powertrain Mounting System',
        'WOS:000435636900017', 'Article', null, '1000-9345', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('c13d9f504c954fbe96c63ef37edc2b9d', 'Qi, C; Zhu, YL; Gao, F; Yang, K; Jiao, QJ', 'Qi, C', ' Zhu, YL', null,
        null, '0', null, null,
        'Morphology, Structure and Thermal Stability Analysis of Cathode and Anode Material under Overcharge',
        'WOS:000454195300001', 'Article', '2019-12-22 00:00:00', '0013-4651', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('c198dfe2e4344859879a0c58fb04df72', 'Wu, BY; Sheng, XQ', 'Wu, BY', ' Sheng, XQ', null, null, '0', null, null,
        'On the Formulation of Characteristic Mode Theory With Fast Multipole Algorithms', 'WOS:000449107400087',
        'Article', null, '0018-926X', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('c2e9df4f78cd4b2ba6f93062a8e40a6a',
        'Yang, HS; Li, ZL; Lu, B; Gao, J; Jin, XT; Sun, GQ; Zhang, GF; Zhang, PP; Qu, LT', 'Yang, HS', ' Li, ZL', null,
        null, '0', null, null,
        'Reconstruction of Inherent Graphene Oxide Liquid Crystals for Large-Scale Fabrication of Structure-Intact Graphene Aerogel Bulk toward Practical Applications',
        'WOS:000451789200080', 'Article', null, '1936-0851', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('c4115d6551cc48a68cb0cef78a463a3d', 'Zhang, Y; Xin, CX; Zhang, LT; Deng, YL; Wang, X; Chen, XY; Wang, ZQ',
        'Zhang, Y', ' Xin, CX', null, null, '0', null, null,
        'Detection of Fungi from Low-Biomass Spacecraft Assembly Clean Room Aerosols', 'WOS:000448923700001', 'Article',
        '2019-12-01 00:00:00', '1531-1074', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('c4341e69417c453d8e74c12a741412aa', 'Yang, GP; He, X; Yu, B; Hu, CW', 'Yang, GP', ' He, X', null, null, '0',
        null, null, 'Cu1.5PMo12O40-catalyzed condensation cyclization for the synthesis of substituted pyrazoles',
        'WOS:000448052500017', 'Article', null, '0268-2605', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('c4728d603ba04af79eadf1fda9920bc7',
        'Wang, H; Rassu, P; Wang, X; Li, HW; Wang, XR; Wang, XQ; Feng, X; Yin, AX; Li, PF; Jin, X; Chen, SL; Ma, XJ; Wang, B',
        'Wang, H', ' Rassu, P', null, null, '0', null, null,
        'An Iron-Containing Metal-Organic Framework as a Highly Efficient Catalyst for Ozone Decomposition',
        'WOS:000453346300028', 'Article', '2019-12-10 00:00:00', '1433-7851', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('c66e8b23e75c489abc362a3cef758071', 'Wang, S; Du, ZM; Han, ZY; Zhang, ZL; Liu, L; Hao, JY', 'Wang, S',
        ' Du, ZM', null, null, '0', null, null,
        'Study of the Temperature and Flame Characteristics of Two Capacity LiFePO4 Batteries in Thermal Runaway',
        'WOS:000452716400002', 'Article', '2019-12-11 00:00:00', '0013-4651', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('c780e3c7672c4d9b8b4603a6ce82f73f', 'El Moctar, I; Ni, Q; Bai, Y; Wu, F; Wu, C', 'El Moctar, I', ' Ni, Q', null,
        null, '0', null, null, 'Hard carbon anode materials for sodium-ion batteries', 'WOS:000453777500002', 'Review',
        null, '1793-6047', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('c803bfefbf37457aaa11c3523bd54e5c',
        'Wang, YW; Jiang, YX; Ding, S; Li, JW; Song, NJ; Ren, YJ; Hong, DN; Wu, C; Li, B; Wang, F; He, W; Wang, JW; Mei, ZQ',
        'Wang, YW', ' Jiang, YX', null, null, '0', null, null,
        'Small molecule inhibitors reveal allosteric regulation of USP14 via steric blockade', 'WOS:000451782300007',
        'Article', null, '1001-0602', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('c87562b10b344f0ca8e669a972e06099', 'Zhang, N; Wang, Y; Hao, YC; Ni, YM; Su, X; Yin, AX; Hu, CW', 'Zhang, N',
        ' Wang, Y', null, null, '0', null, null,
        'Ultrathin cobalt oxide nanostructures with morphology-dependent electrocatalytic oxygen evolution activity',
        'WOS:000451762800025', 'Article', '2019-11-21 00:00:00', '2040-3364', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('cb034526d8a24ed3bb84e271aa37f6e2', 'Zheng, Q; Shao, HB', 'Zheng, Q', ' Shao, HB', null, null, '0', null, null,
        'Influence of intermolecular H-bonding on the acid-base interfacial properties of -COOH and ferrocene terminated SAM',
        'WOS:000451934600012', 'Article', '2019-11-15 00:00:00', '1572-6657', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('cc19b50945784860aa40d0e57f54fa06', 'Ma, C; Ma, Z; Gao, LH; Liu, YB; Wang, JW; Song, MY; Wang, FC; Ishida, H',
        'Ma, C', ' Ma, Z', null, null, '0', null, null,
        'Laser ablation behavior of nano-copper particle-filled phenolic matrix nanocomposite coatings',
        'WOS:000451105300006', 'Article', '2019-12-15 00:00:00', '1359-8368', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('cc7a98ea4fe140d8a1703a7bec697270', 'Li, SY; Zhao, GQ; Sun, HJ; Amin, M', 'Li, SY', ' Zhao, GQ', null, null,
        '0', null, null, 'Compressive Sensing Imaging of 3-D Object by a Holographic Algorithm', 'WOS:000451994900063',
        'Article', null, '0018-926X', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('ccdf8e34193944abaf09c5ec51225824', 'Zhang, ZY; Zhang, RW; Li, XR; Koepernik, K; Yao, YG; Zhang, HB',
        'Zhang, ZY', ' Zhang, RW', null, null, '0', null, null,
        'High-Throughput Screening and Automated Processing toward Novel Topological Insulators', 'WOS:000449308200010',
        'Article', '2019-11-01 00:00:00', '1948-7185', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55',
        0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('cd6e7c55b9af4dc28cb274ac343dafae', 'Feng, HZ; Lou, WH; Wang, DK; Zheng, FQ', 'Feng, HZ', ' Lou, WH', null,
        null, '0', null, null,
        'Explosion Suppression Mechanism Characteristics of MEMS S&A Device With In Situ Synthetic Primer',
        'WOS:000455072800043', 'Article', null, '2072-666X', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('cdaae82247fb46ada475b3ef3e41234f', 'Cui, H; Liu, CH; Cote, R; Liu, WF', 'Cui, H', ' Liu, CH', null, null, '0',
        null, null,
        'Understanding the Evolution of Industrial Symbiosis with a System Dynamics Model: A Case Study of Hai Hua Industrial Symbiosis, China',
        'WOS:000451531700047', 'Article', null, '2071-1050', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('cef4c84c025d4cf38b76b4b0952376ba', 'Engo, J', 'Engo, J', null, null, null, '0', null, null,
        'Decomposing the decoupling of CO2 emissions from economic growth in Cameroon', 'WOS:000452024600063',
        'Article', null, '0944-1344', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('cf288c043d594343b389ecf27abcd480', 'Hu, ZY; Zhang, ZH; Cheng, XW; Song, Q; Yin, SP; Wang, H; Wang, FC',
        'Hu, ZY', ' Zhang, ZH', null, null, '0', null, null,
        'Microstructure evolution and tensile properties of Ti-(AlxTiy) core-shell structured particles reinforced aluminum matrix composites after hot-rolling/heat-treatment',
        'WOS:000448493600011', 'Article', '2019-11-08 00:00:00', '0921-5093', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('cf5aa08b5819475884520dcb090a9e69', 'Ma, DS; Zhou, JH; Fu, BT; Yu, ZM; Liu, CC; Yao, YG', 'Ma, DS', ' Zhou, JH',
        null, null, '0', null, null, 'Mirror protected multiple nodal line semimetals and material realization',
        'WOS:000449780400001', 'Article', '2019-11-09 00:00:00', '2469-9950', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('cfbdf5e41e35473aa2a0c2734bcb7649', 'Yang, G; Zhang, CP; Yang, HE; Quan, HD', 'Yang, G', ' Zhang, CP', null,
        null, '0', null, null, 'Synthesis of 1H-polychlorofluorocycloolefins', 'WOS:000451938800012', 'Article', null,
        '0022-1139', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('d29e03aae6db401ca6ae956f08590e4c',
        'Zai, HC; Zhang, DL; Li, L; Zhu, C; Ma, S; Zhao, YZ; Zhao, ZG; Chen, CF; Zhou, HP; Li, YJ; Chen, Q', 'Zai, HC',
        ' Zhang, DL', null, null, '0', null, null,
        'Low-temperature-processed inorganic perovskite solar cells via solvent engineering with enhanced mass transport',
        'WOS:000451813300040', 'Article', '2019-12-14 00:00:00', '2050-7488', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('d5725e0e6b33405494983bf50130704c', 'Chen, ZY; Liu, CH; Wang, RN', 'Chen, ZY', ' Liu, CH', null, null, '0',
        null, null, 'Learning to Navigate Connected Autonomous Cars for Long-Term Communication Coverage',
        'WOS:000456670700007', 'Article', null, '1520-9202', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('d6013d40b66345b2a3ee8f3040ab0e05',
        'Wang, HH; Ge, YS; Tan, JW; Hao, LJ; Peng, ZH; Wang, X; Wu, LG; Li, YH; Yang, J; Li, JC; Yang, DX', 'Wang, HH',
        ' Ge, YS', null, null, '0', null, null,
        'The effects of ash inside a platinum-based catalyst diesel particulate filter on particle emissions, gaseous emissions, and unregulated emissions',
        'WOS:000449920100078', 'Article', null, '0944-1344', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('d648cd3991b8492480d1c0188bdf450e', 'Wu, F; Zhou, ZQ; Wang, B; Ma, JL', 'Wu, F', ' Zhou, ZQ', null, null, '0',
        null, null, 'Inshore Ship Detection Based on Convolutional Neural Network in Optical Satellite Images',
        'WOS:000452730100008', 'Article; Proceedings Paper', null, '1939-1404', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('d77d32dbf2084140afe78a477618fe4e', 'Fan, FL; Liu, Y; Hong, YF; Zang, JL; Kang, GG; Zhao, TB; Tan, XD',
        'Fan, FL', ' Liu, Y', null, null, '0', null, null,
        'Highly concentrated phenanthrenequinone-doped poly(MMA-co-ACMO) for volume holography', 'WOS:000451240000007',
        'Article', '2019-11-10 00:00:00', '1671-7694', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55',
        0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('d842be4ca10345058c12c0ad6fe03f06', 'Wang, JL; Liu, KK; Hong, L; Ge, GY; Zhang, C; Hou, JH', 'Wang, JL',
        ' Liu, KK', null, null, '0', null, null,
        'Selenopheno[3,2-b]thiophene-Based Narrow-Bandgap Nonfullerene Acceptor Enabling 13.3% Efficiency for Organic Solar Cells with Thickness-Insensitive Feature',
        'WOS:000453805100015', 'Article', null, '2380-8195', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('d9f9fd16518540dfb2e3b76c53f3ff43', 'Jin, YF; Xiao, SM; Zhang, YX', 'Jin, YF', ' Xiao, SM', null, null, '0',
        null, null, 'Enhancement of tristable energy harvesting using stochastic resonance', 'WOS:000454549700001',
        'Article', null, '1742-5468', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('db27531b7c3c420fbb1bc67ea2efd00a', 'Zhou, ZB; Hou, ZL; Yang, F; Yao, B', 'Zhou, ZB', ' Hou, ZL', null, null,
        '0', null, null,
        'Oxidative cross-coupling of allyl(trimethyl)silanes with aryl boronic acids by palladium catalysis',
        'WOS:000452578000017', 'Article', '2019-12-13 00:00:00', '0040-4020', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('dbf11304da2942bc88b858f6e35ad869', 'Liu, XD; Li, LY; Li, Z; Chen, X; Fernando, T; Iu, HHC; He, GQ', 'Liu, XD',
        ' Li, LY', null, null, '0', null, null,
        'Event-Trigger Particle Filter for Smart Grids With Limited Communication Bandwidth Infrastructure',
        'WOS:000452475200132', 'Article', null, '1949-3053', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('dcb0f87005b8483ea7189d5acf3f6e95', 'Huu, AT; Huang, HY; Guo, YH; Shi, SM; Jian, P', 'Huu, AT', ' Huang, HY',
        null, null, '0', null, null,
        'Integrating Pronunciation into Chinese-Vietnamese Statistical Machine Translation', 'WOS:000452622900007',
        'Article', null, '1007-0214', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('de0166f4c8724013a3f6a6524776b85a', 'Zhang, M; Zhong, S; Mao, P; Sun, YL; Zhang, WP', 'Zhang, M', ' Zhong, S',
        null, null, '0', null, null, 'Macro-model of PV module and its application for partial shading analysis',
        'WOS:000448390000005', 'Article; Proceedings Paper', '2019-11-19 00:00:00', '1752-1416', null, 'u1', 'u1',
        '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('de5f58a6d81a464aab9f9654bf70ca63', 'Zhang, SF; Lee, TH; Wu, H; Pei, JY; Wu, W; Liu, FS; Zhang, CH',
        'Zhang, SF', ' Lee, TH', null, null, '0', null, null,
        'Experimental and kinetic studies on laminar flame characteristics of acetone-butanol-ethanol (ABE) and toluene reference fuel (TRF) blends at atmospheric pressure',
        'WOS:000438692100079', 'Article', '2019-11-15 00:00:00', '0016-2361', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('df1a2dff29db47b6861a1d22ef73e66c', 'Yang, XD; Chen, M; Zhu, R; Zhang, J; Chen, BL', 'Yang, XD', ' Chen, M',
        null, null, '0', null, null, 'Robust Nanoporous Supramolecular Network Through Charge-Transfer Interaction',
        'WOS:000454383500077', 'Article', '2019-12-19 00:00:00', '1944-8244', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('df55fcf3012b4e47a261a8b783e958ff', 'Zhang, XJ; Yi, YN; Zhu, HB; Liu, GY; Sun, LB; Shi, L; Jiang, H; Ma, SP',
        'Zhang, XJ', ' Yi, YN', null, null, '0', null, null,
        'Measurement of tensile strength of nuclear graphite based on ring compression test', 'WOS:000447796300014',
        'Article', '2019-12-01 00:00:00', '0022-3115', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55',
        0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('dfd621005a914dd0a0a04553ea5bd5b1',
        'Guo, Y; Zhang, WX; Wu, HC; Han, JF; Zhang, YL; Lin, SH; Liu, CR; Xu, K; Qiao, JS; Ji, W; Chen, Q; Gao, S; Zhang, WJ; Zhang, XD; Chai, Y',
        'Guo, Y', ' Zhang, WX', null, null, '0', null, null,
        'Discovering the forbidden Raman modes at the edges of layered materials', 'WOS:000454369600034', 'Article',
        null, '2375-2548', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('e01e4d6e5bcd422aaef2408630aeb34d', 'Jia, R; Ma, B; Zheng, CS; Wang, LY; Ba, X; Du, Q; Wang, K', 'Jia, R',
        ' Ma, B', null, null, '0', null, null,
        'Magnetic Properties of Ferromagnetic Particles under Alternating Magnetic Fields: Focus on Particle Detection Sensor Applications',
        'WOS:000454817100063', 'Article', null, '1424-8220', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('e275a13996274776be36c0284475b038', 'Li, MX; Mou, JC; Guo, DL; Qiao, HD; Ma, ZH; Lyu, X', 'Li, MX', ' Mou, JC',
        null, null, '0', null, null,
        'Design and imaging demonstrations of a terahertz quasi-optical Schottky diode detector', 'WOS:000455098300014',
        'Article', null, '1001-9014', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('e2f12852af3143d8b881fdf21b982c38', 'Zhu, C; Wang, XQ; Li, LS; Hao, CX; Hu, YH; Rizvi, AS; Qu, F', 'Zhu, C',
        ' Wang, XQ', null, null, '0', null, null,
        'Online reaction based single-step CE for Protein-ssDNA complex obtainment to assist aptamer selection',
        'WOS:000451936800025', 'Article', '2019-11-17 00:00:00', '0006-291X', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('e3a5edc0229a448f8ec3d24870d43178', 'Yang, JQ; Gong, XD; Mei, HZ; Li, T; Zhang, JG; Gozin, M', 'Yang, JQ',
        ' Gong, XD', null, null, '0', null, null,
        'Design of Zero Oxygen Balance Energetic Materials on the Basis of Diels-Alder Chemistry',
        'WOS:000452929900043', 'Article', '2019-12-07 00:00:00', '0022-3263', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('e433e0d3943b417dbe4cab205eaa4b92', 'Shao, CX; Gao, J; Xu, T; Ji, BX; Xiao, YK; Gao, C; Zhao, Y; Qu, LT',
        'Shao, CX', ' Gao, J', null, null, '0', null, null, 'Wearable fiberform hygroelectric generator',
        'WOS:000448994600079', 'Article', null, '2211-2855', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('e445bb18bd8947139cf0b7b0935d139b', 'Wang, YJ; Zhang, GL; Wang, WZ; Si, LN; Liu, FB', 'Wang, YJ', ' Zhang, GL',
        null, null, '0', null, null,
        'Controlled friction behaviors of gradient porous Cu-Zn composites storing ionic liquids under electric field',
        'WOS:000451737400020', 'Article', null, '2158-3226', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('e4632e12fe3e42a0bfcd47293aa2249d', 'Sultan, M; Wu, JY; Aleem, FE; Imran, M', 'Sultan, M', ' Wu, JY', null,
        null, '0', null, null,
        'Cost and energy analysis of a grid-tie solar system synchronized with utility and fossil fuel generation with major Issues for the attenuation of solar power in Pakistan',
        'WOS:000451499500095', 'Article', '2019-11-01 00:00:00', '0038-092X', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('e50e45141fc6444dafc7bd78483bd2dd', 'Zhang, FP; Wu, D; Yang, JB; Butt, SI; Yan, Y', 'Zhang, FP', ' Wu, D', null,
        null, '0', null, null,
        'High-definition metrology-based machining error identification for non-continuous surfaces',
        'WOS:000450340900011', 'Review', null, '0954-4054', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('e5491b8213e5441580737cfdad2bd854', 'Yang, X; Deng, SGJ; Ji, MY; Zhao, JF; Zheng, WH', 'Yang, X', ' Deng, SGJ',
        null, null, '0', null, null, 'Neural Network Evolving Algorithm Based on the Triplet Codon Encoding Method',
        'WOS:000454717800060', 'Article', null, '2073-4425', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('e769497709574ed1826a4c079f2d1cb0', 'Yang, LQ; Fan, JT; Nam, VB; Rabczuk, T', 'Yang, LQ', ' Fan, JT', null,
        null, '0', null, null,
        'A nanoscale study of the negative strain rate dependency of the strength of metallic glasses by molecular dynamics simulations',
        'WOS:000448665900053', 'Article', '2019-11-07 00:00:00', '1463-9076', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('e793e5eb0fd14ab6af74f42a3462af80', 'Song, NM; Yang, L; Han, JM; Liu, JC; Zhang, GY; Gao, HX', 'Song, NM',
        ' Yang, L', null, null, '0', null, null,
        'Catalytic study on thermal decomposition of Cu-en/(AP, CL-20, RDX and HMX) composite microspheres prepared by spray drying',
        'WOS:000451074200062', 'Article', '2019-12-07 00:00:00', '1144-0546', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('e7947796357a44128b7846fab5c6ed74', 'Li, L; Wang, FJ; Shao, ZQ; Liu, JX; Zhang, QL; Jiao, WZ', 'Li, L',
        ' Wang, FJ', null, null, '0', null, null,
        'Chitosan and carboxymethyl cellulose-multilayered magnetic fluorescent systems for reversible protein immobilization',
        'WOS:000445030100038', 'Article', '2019-12-01 00:00:00', '0144-8617', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('e7b36c00aee7453bb2acb7c63f83c826', 'Wu, MD; Li, B; Zhou, Y; Guo, DL; Liu, Y; Wei, F; Lv, X', 'Wu, MD',
        ' Li, B', null, null, '0', null, null,
        'Design and Measurement of a 220 GHz Wideband 3-D Printed Dielectric Reflectarray', 'WOS:000451983500021',
        'Article', null, '1536-1225', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('e9624f8b9abb4d01bfa30b7ea5242186', 'Song, YX; Du, DM', 'Song, YX', ' Du, DM', null, null, '0', null, null,
        'Asymmetric synthesis of highly functionalized spirothiazolidinone tetrahydroquinolines via a squaramide- catalyzed cascade reaction',
        'WOS:000453230000011', 'Article', '2019-12-28 00:00:00', '1477-0520', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('eaa08f94c31d49a9bf7ca258e84cd82a',
        'Yan, C; Cheng, XB; Yao, YX; Shen, X; Li, BQ; Li, WJ; Zhang, R; Huang, JQ; Li, H; Zhang, Q', 'Yan, C',
        ' Cheng, XB', null, null, '0', null, null,
        'An Armored Mixed Conductor Interphase on a Dendrite-Free Lithium-Metal Anode', 'WOS:000449819500030',
        'Article', null, '0935-9648', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('ec5c3f5ce72d4757898352727bccbeea',
        'Cui, BB; Han, Y; Yang, N; Yang, SS; Zhang, LZ; Wang, Y; Jia, YF; Zhao, L; Zhong, YW; Chen, Q', 'Cui, BB',
        ' Han, Y', null, null, '0', null, null,
        'Propeller-Shaped, Triarylamine-Rich, and Dopant-Free Hole-Transporting Materials for Efficient n-i-p Perovskite Solar Cells',
        'WOS:000452694100071', 'Article', '2019-12-05 00:00:00', '1944-8244', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('ed2603a2745a4295ba03b87fba4bf299', 'Guo, RY; Sun, L; Pan, XY; Yang, XD; Ma, S; Zhang, J', 'Guo, RY', ' Sun, L',
        null, null, '0', null, null,
        'Application of an electron-transfer catalyst in light-induced aerobic oxidation of alcohols',
        'WOS:000449274400011', 'Article', '2019-11-18 00:00:00', '1359-7345', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('ee637fa226a94f468e2fe10069aaca46', 'Pan, LF; Yuan, SH; Lin, JH; Zou, BS; Shi, LJ', 'Pan, LF', ' Yuan, SH',
        null, null, '0', null, null, 'The tunable bandgap effect of SnS films', 'WOS:000448152100002', 'Article',
        '2019-11-21 00:00:00', '0953-8984', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('ef034e77d19a455bbcac3cf1ee0ec95c', 'Huang, YG; Cao, LB; Zhang, J; Pan, L; Liu, YY', 'Huang, YG', ' Cao, LB',
        null, null, '0', null, null, 'Exploring Feature Coupling and Model Coupling for Image Source Identification',
        'WOS:000434453500013', 'Article', null, '1556-6013', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('ef3e6d26b40343c4a6b2b1d75625ff62', 'Li, CX; Gao, K; Zhang, ZP', 'Li, CX', ' Gao, K', null, null, '0', null,
        null, 'Graphitic carbon nitride as polysulfide anchor and barrier for improved lithium-sulfur batteries',
        'WOS:000444753000001', 'Article', '2019-11-16 00:00:00', '0957-4484', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('ef5fd579b9494c71ae6fb1f84922ff33', 'Zeng, YC; Dong, PW; Shi, YY; Li, Y', 'Zeng, YC', ' Dong, PW', null, null,
        '0', null, null,
        'On the Disruptive Innovation Strategy of Renewable Energy Technology Diffusion: An Agent-Based Model',
        'WOS:000451814000355', 'Article', null, '1996-1073', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('f12ce516aedd421685b9bee1e3b11e79', 'Danish; Wang, ZH', 'Danish', ' Wang, ZH', null, null, '0', null, null,
        'Dynamic relationship between tourism, economic growth, and environmental quality', 'WOS:000458931300006',
        'Article', '2019-11-02 00:00:00', '0966-9582', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55',
        0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('f200525c8e9b4e64a7f3be22e336f0ae', 'Jia, YW; Lan, T; Liu, PW; Li, ZG', 'Jia, YW', ' Lan, T', null, null, '0',
        null, null,
        'Polarization-insensitive, high numerical aperture metalens with nanoholes and surface corrugations',
        'WOS:000443842500015', 'Article', '2019-12-15 00:00:00', '0030-4018', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('f2f4e905758847f8aff1bb643e359b70', 'Wang, NN; Liu, JX; Chang, WL; Lee, CFF', 'Wang, NN', ' Liu, JX', null,
        null, '0', null, null, 'A numerical study on effects of pre-chamber syngas reactivity on hot jet ignition',
        'WOS:000445253100001', 'Article', '2019-12-15 00:00:00', '0016-2361', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('f3309bb81d5443afa62c41d5f4736624', 'Wang, QQ; Teng, G; Qiao, XL; Zhao, Y; Kong, JL; Dong, LQ; Cui, XT',
        'Wang, QQ', ' Teng, G', null, null, '0', null, null,
        'Importance evaluation of spectral lines in Laser-induced breakdown spectroscopy for classification of pathogenic bacteria',
        'WOS:000449192700050', 'Article', '2019-11-01 00:00:00', '2156-7085', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('f3457b31ff2641aaa8d8ba333f5095ae', 'Zheng, HY; Hou, SJ; Li, H; Song, ZY; Hao, YY', 'Zheng, HY', ' Hou, SJ',
        null, null, '0', null, null,
        'Power Allocation and User Clustering for Uplink MC-NOMA in D2D Underlaid Cellular Networks',
        'WOS:000454240000036', 'Article', null, '2162-2337', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('f3b8dc5cef4e4199a50577306ce2f5ce',
        'Zhang, EH; Ma, FF; Liu, J; Sun, JY; Chen, WX; Rong, HP; Zhu, XY; Liu, JJ; Xu, M; Zhuang, ZB; Chen, SL; Wen, ZH; Zhang, JT',
        'Zhang, EH', ' Ma, FF', null, null, '0', null, null,
        'Porous platinum-silver bimetallic alloys: surface composition and strain tunability toward enhanced electrocatalysis',
        'WOS:000451772500011', 'Article', '2019-12-14 00:00:00', '2040-3364', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('f58982ee648b46848d058b80f9b09d35', 'Yi, WL; Ji, LC', 'Yi, WL', ' Ji, LC', null, null, '0', null, null,
        'Experimental investigation on the performance of compressor cascade using blended-blade-end-wall contouring technology',
        'WOS:000452281000009', 'Article', null, '0954-4100', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('f58bb3014a1743c98fef0c3bdd5f1eb9', 'Tan, YA; Zhang, XS; Sharif, K; Liang, C; Zhang, QX; Li, YZ', 'Tan, YA',
        ' Zhang, XS', null, null, '0', null, null, 'COVERT TIMING CHANNELS FOR IOT OVER MOBILE NETWORKS',
        'WOS:000455711200008', 'Article', null, '1536-1284', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('f5a103ade6d942b88f38f16686880424', 'Guo, ZW; Huang, GY; Liu, CM; Feng, SS', 'Guo, ZW', ' Huang, GY', null,
        null, '0', null, null,
        'Effect of Eccentric Initiation on the Fragment Velocity Distribution of D-Shaped Casings Filled with Explosive Charges',
        'WOS:000452614000004', 'Article', null, '0721-3115', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('f5b9da957b2b474b873cc74acac48b5d', 'Zhao, JB; Jing, WC; Wang, JZ', 'Zhao, JB', ' Jing, WC', null, null, '0',
        null, null,
        'An indirect optimization scheme for tuning a fractional order PI api using extremum seeking',
        'WOS:000454382300013', 'Article', null, '0957-4158', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('f6b68f80df034c69bce02976956276d5', 'Shi, WT; Yi, WL; Ji, LC', 'Shi, WT', ' Yi, WL', null, null, '0', null,
        null,
        'Effect of inlet total pressure non-uniform distribution on aerodynamic performance and flow field of turbine',
        'WOS:000448097900059', 'Article', null, '0020-7403', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('f7352d2f04e148288ef510a9bffc90c3', 'Yang, T; Xiong, JY; Tang, XC; Misztal, PK', 'Yang, T', ' Xiong, JY', null,
        null, '0', null, null,
        'Predicting Indoor Emissions of Cyclic Volatile Methylsiloxanes from the Use of Personal Care Products by University Students',
        'WOS:000454183400020', 'Article', '2019-12-18 00:00:00', '0013-936X', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('f8ba3c3afafa4ac4b498d4c20a962560', 'Liu, J; Yu, WH; Yang, SY; Hou, YF; Cui, DS; Lyu, X', 'Liu, J', ' Yu, WH',
        null, null, '0', null, null, 'Small signal model and low noise application of InAlAs/InGaAs/InP-based PHEMTs',
        'WOS:000455098300008', 'Article', null, '1001-9014', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('f94949910cef4c1fa970becad21c0698', 'Ge, Q; Zhou, L; Lian, YM; Zhang, XL; Chen, RJ; Yang, W', 'Ge, Q',
        ' Zhou, L', null, null, '0', null, null,
        'Metal-phosphide-doped Li7P3S11 glass-ceramic electrolyte with high ionic conductivity for all-solid-state lithium-sulfur batteries',
        'WOS:000451326800022', 'Article', null, '1388-2481', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('f968806ffe1e4786849aebf870ea93b0', 'Zhang, WW; Yu, ZY; Li, YJ', 'Zhang, WW', ' Yu, ZY', null, null, '0', null,
        null, 'Analysis of flow and phase interaction characteristics in a gas-liquid two-phase pump',
        'WOS:000452156400001', 'Article', '2019-12-05 00:00:00', '1294-4475', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('f96c79b38394408c8b85d3f5f15fa3c2',
        'Guo, T; Wang, ZJ; Huo, H; Tang, W; Zhu, Y; Bi, FQ; Wang, BZ; Meng, ZH; Ge, ZX', 'Guo, T', ' Wang, ZJ', null,
        null, '0', null, null,
        'An Efficient Method of Preparation and Comprehensive Properties for Energetic Salts Based on Nitrofurazan-Functionalized Hydroxytetrazoles',
        'WOS:000450365000018', 'Article', '2019-11-15 00:00:00', '2365-6549', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('fa10591f0f334db182262223c1aeb7ad', 'Li, CG; Wang, WH; Guo, HW; Dietrich, A', 'Li, CG', ' Wang, WH', null, null,
        '0', null, null,
        'Cross-Cultural Analysis of Young Drivers'' Preferences for In-Vehicle Systems and Behavioral Effects Caused by Secondary Tasks',
        'WOS:000451531700257', 'Article', null, '2071-1050', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('fa80bf15ace94e73869d082ed03c313b', 'Liu, SK; Yan, XP; Li, P; Hao, XH; Wang, K', 'Liu, SK', ' Yan, XP', null,
        null, '0', null, null, 'Radar Emitter Recognition Based on SIFT Position and Scale Features',
        'WOS:000451260100051', 'Article', null, '1549-7747', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('fb0cc0ce35f747ceb9d9a241c6664a6f', 'Liu, YY; Hao, Y', 'Liu, YY', ' Hao, Y', null, null, '0', null, null,
        'The dynamic links between CO2 emissions, energy consumption and economic development in the countries along "the Belt and Road"',
        'WOS:000445164200067', 'Article', '2019-12-15 00:00:00', '0048-9697', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('fd1e4c3aa4ab4ccbb274965bd199dff8', 'Xiong, R; Li, LL; Tian, JP', 'Xiong, R', ' Li, LL', null, null, '0', null,
        null,
        'Towards a smarter battery management system: A critical review on battery state of health monitoring methods',
        'WOS:000451102500003', 'Review', '2019-11-30 00:00:00', '0378-7753', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('fe096b43febe4d54a541ea158dfc5000', 'Zhang, DY; Wu, QH; Yao, XL; Jiao, LL', 'Zhang, DY', ' Wu, QH', null, null,
        '0', null, null,
        'Active disturbance rejection control for looper tension of stainless steel strip processing line',
        'WOS:000456636800007', 'Article', null, '1454-8658', null, 'u1', 'u1', '2019-03-26 13:58:55',
        '2019-03-26 13:58:55', 0);
INSERT INTO docmanager.doc_paper (id, author_list, first_author_name, second_author_name, first_author_id,
                                  second_author_id, status, status_1, status_2, paper_name, store_num, doc_type,
                                  publish_date, ISSN, remarks, create_user_id, modify_user_id, create_date, modify_date,
                                  del_flag)
VALUES ('ffe737a909b240bfb6d3abb4615b7b23', 'Ma, X; Zhao, QL; Zhang, H; Wang, ZQ; Arce, GR', 'Ma, X', ' Zhao, QL', null,
        null, '0', null, null, 'Model-driven convolution neural network for inverse lithography', 'WOS:000452612200017',
        'Article', '2019-12-10 00:00:00', '1094-4087', null, 'u1', 'u1', '2019-03-26 13:58:55', '2019-03-26 13:58:55',
        0);
create table sys_dict
(
  id             varchar(100)         not null
    primary key,
  parent_id      varchar(100)         null comment '父字典项 from 字典表',
  name_cn        varchar(500)         null comment '字典中文名',
  name_en        varchar(500)         null comment '字典英文名',
  sort           int                  null comment '用户可手动设置sort值进行排序',
  type_id        varchar(100)         null comment '字典类型 from 字典类型表',
  remarks        varchar(200)         null comment '备注',
  create_user_id varchar(100)         null comment '创建者id',
  modify_user_id varchar(100)         null comment '最后修改者id',
  create_date    datetime             null comment '创建日期',
  modify_date    datetime             null comment '最后修改日期',
  del_flag       tinyint(1) default 0 null comment '是否被删除'
);

INSERT INTO docmanager.sys_dict (id, parent_id, name_cn, name_en, sort, type_id, remarks, create_user_id,
                                 modify_user_id, create_date, modify_date, del_flag)
VALUES ('2322db693e18426a849f399521691414', '', '中国', null, 0, '9b88ccab9c5448469d426b81365f86d6', '', 'u1', 'u1',
        '2019-03-22 14:45:21', '2019-03-22 14:45:21', 0);
INSERT INTO docmanager.sys_dict (id, parent_id, name_cn, name_en, sort, type_id, remarks, create_user_id,
                                 modify_user_id, create_date, modify_date, del_flag)
VALUES ('400c9a9e9adb45c9b4787d3f79faf556', '', '英文', 'English', 0, '0c6b0dca6e48426d928a9b2e5a692f86', '', 'u1', 'u1',
        '2019-03-23 15:42:59', '2019-03-23 15:42:59', 0);
INSERT INTO docmanager.sys_dict (id, parent_id, name_cn, name_en, sort, type_id, remarks, create_user_id,
                                 modify_user_id, create_date, modify_date, del_flag)
VALUES ('5b04adf13dbf4cb8ac9dcc5fbf981d38', '', '中文', 'Chinese', 0, '0c6b0dca6e48426d928a9b2e5a692f86', '', 'u1', 'u1',
        '2019-03-23 15:42:47', '2019-03-23 15:42:47', 0);
INSERT INTO docmanager.sys_dict (id, parent_id, name_cn, name_en, sort, type_id, remarks, create_user_id,
                                 modify_user_id, create_date, modify_date, del_flag)
VALUES ('9c4823b8e62d4970b506e19bc40a3dba', '', '美国', null, 0, '9b88ccab9c5448469d426b81365f86d6', '', 'u1', 'u1',
        '2019-03-23 10:45:15', '2019-03-23 10:45:15', 0);
INSERT INTO docmanager.sys_dict (id, parent_id, name_cn, name_en, sort, type_id, remarks, create_user_id,
                                 modify_user_id, create_date, modify_date, del_flag)
VALUES ('cd496749dd7f477685f2e81a9b8b8b2b', '', '男', null, 0, '22f697cc837b4ad8bced45683a6c71e1', '', 'u1', 'u1',
        '2019-03-25 10:31:39', '2019-03-25 10:31:39', 0);
INSERT INTO docmanager.sys_dict (id, parent_id, name_cn, name_en, sort, type_id, remarks, create_user_id,
                                 modify_user_id, create_date, modify_date, del_flag)
VALUES ('f378396d5b71494280f27d184233a996', '', '女', null, 0, '22f697cc837b4ad8bced45683a6c71e1', '', 'u1', 'u1',
        '2019-03-25 10:31:46', '2019-03-25 10:31:46', 0);
create table sys_dict_type
(
  id             varchar(100)         not null
    primary key,
  name_cn        varchar(100)         null comment '字典类型中文名',
  name_en        varchar(100)         null comment '字典类型英文名',
  sort           int                  null comment '用户可手动设置sort值进行排序',
  parent_id      varchar(100)         null comment '父类型 from 字典类型表',
  remarks        varchar(200)         null comment '备注',
  create_user_id varchar(100)         null comment '创建者id',
  modify_user_id varchar(100)         null comment '最后修改者id',
  create_date    datetime             null comment '创建日期',
  modify_date    datetime             null comment '最后修改日期',
  del_flag       tinyint(1) default 0 null comment '是否被删除'
);

INSERT INTO docmanager.sys_dict_type (id, name_cn, name_en, sort, parent_id, remarks, create_user_id, modify_user_id,
                                      create_date, modify_date, del_flag)
VALUES ('0c6b0dca6e48426d928a9b2e5a692f86', '语言', null, 0, null, '', 'u1', 'u1', '2019-03-23 15:42:03',
        '2019-03-23 15:42:03', 0);
INSERT INTO docmanager.sys_dict_type (id, name_cn, name_en, sort, parent_id, remarks, create_user_id, modify_user_id,
                                      create_date, modify_date, del_flag)
VALUES ('22f697cc837b4ad8bced45683a6c71e1', '性别', null, 0, null, '', 'u1', 'u1', '2019-03-25 10:30:51',
        '2019-03-25 10:30:51', 0);
INSERT INTO docmanager.sys_dict_type (id, name_cn, name_en, sort, parent_id, remarks, create_user_id, modify_user_id,
                                      create_date, modify_date, del_flag)
VALUES ('9b88ccab9c5448469d426b81365f86d6', '国家', null, 0, null, '', 'u1', 'u1', '2019-03-22 14:45:12',
        '2019-03-22 14:45:12', 0);
create table sys_function
(
  id             varchar(100)         not null
    primary key,
  name           varchar(100)         null comment '功能或分类名称',
  code           varchar(100)         null comment '功能或分类代码',
  url            varchar(100)         null comment '如果是功能，则此项代表功能页地址，否则为空',
  icon           varchar(100)         null comment '图标',
  enable         tinyint(1)           null comment '功能是否启用',
  type           int                  null comment '0 - 功能分类，点击展开子功能;1 - 功能，点击进入功能页',
  `index`        int                  null comment '排序，功能栏上自上而下，从0开始递增(相当于数组中的序号)',
  parent_id      varchar(100)         null comment '功能所属的分类 from 功能表',
  remarks        varchar(200)         null comment '备注',
  create_user_id varchar(100)         null comment '创建者id',
  modify_user_id varchar(100)         null comment '最后修改者id',
  create_date    datetime             null comment '创建日期',
  modify_date    datetime             null comment '最后修改日期',
  del_flag       tinyint(1) default 0 null comment '是否被删除'
);

INSERT INTO docmanager.sys_function (id, name, code, url, icon, enable, type, `index`, parent_id, remarks,
                                     create_user_id, modify_user_id, create_date, modify_date, del_flag)
VALUES ('182a27408e3a4d02ae11c82f2b47906a', 'Excel导入', 'tool:importExcel', 'functions/tool/importExcel',
        'fa fa-clipboard', 1, 1, 0, '7ce1a2f2f5314eefb93d8c2b36ad8429', '', 'u1', 'u1', '2019-03-22 13:51:17',
        '2019-03-23 16:32:05', 0);
INSERT INTO docmanager.sys_function (id, name, code, url, icon, enable, type, `index`, parent_id, remarks,
                                     create_user_id, modify_user_id, create_date, modify_date, del_flag)
VALUES ('29f0f151961c4de9a5da1c80f2f61ba0', '论文用户匹配', null, 'functions/doc/paperUserMatch', 'fa fa-indent', 1, 1, 0,
        'be0b9dca7cc94dda8b35ce066db7af48', '', 'u1', 'u1', '2019-03-25 10:36:56', '2019-03-25 10:40:54', 0);
INSERT INTO docmanager.sys_function (id, name, code, url, icon, enable, type, `index`, parent_id, remarks,
                                     create_user_id, modify_user_id, create_date, modify_date, del_flag)
VALUES ('6a2da70f1a014db2a3948f7749e8d5b2', '文献查询', null, 'functions/doc/paperUserSearch', 'fa fa-mortar-board', 1, 1,
        2, 'be0b9dca7cc94dda8b35ce066db7af48', '根据老师/学生名字查询其下属的文献资料', 'u1', 'u1', '2019-03-26 14:55:22',
        '2019-03-26 15:05:59', 0);
INSERT INTO docmanager.sys_function (id, name, code, url, icon, enable, type, `index`, parent_id, remarks,
                                     create_user_id, modify_user_id, create_date, modify_date, del_flag)
VALUES ('7ce1a2f2f5314eefb93d8c2b36ad8429', '工具箱', 'tool:default', null, 'fa fa-suitcase', 1, 0, 1, null, '', 'u1',
        'u1', '2019-03-22 13:50:02', '2019-03-23 16:22:52', 0);
INSERT INTO docmanager.sys_function (id, name, code, url, icon, enable, type, `index`, parent_id, remarks,
                                     create_user_id, modify_user_id, create_date, modify_date, del_flag)
VALUES ('7e0d04b78cac47ffaf876f75fb3c99d1', '论文管理', 'doc:paper', 'functions/doc/paperManager', 'fa fa-building', 0, 1,
        1, 'be0b9dca7cc94dda8b35ce066db7af48', '1、未匹配。2、匹配失败。3、匹配成功。4、匹配完成。', 'u1', 'u1', '2019-03-23 16:32:27',
        '2019-03-26 18:13:18', 0);
INSERT INTO docmanager.sys_function (id, name, code, url, icon, enable, type, `index`, parent_id, remarks,
                                     create_user_id, modify_user_id, create_date, modify_date, del_flag)
VALUES ('be0b9dca7cc94dda8b35ce066db7af48', '文献管理', 'doc:default', null, 'fa fa-file-text', 1, 0, 2, null, '', 'u1',
        'u1', '2019-03-23 16:21:39', '2019-03-23 16:32:21', 0);
INSERT INTO docmanager.sys_function (id, name, code, url, icon, enable, type, `index`, parent_id, remarks,
                                     create_user_id, modify_user_id, create_date, modify_date, del_flag)
VALUES ('f1', '系统功能', 'sys:default', '', 'fa fa-cubes', 1, 0, 0, null, null, null, null, null, null, 0);
INSERT INTO docmanager.sys_function (id, name, code, url, icon, enable, type, `index`, parent_id, remarks,
                                     create_user_id, modify_user_id, create_date, modify_date, del_flag)
VALUES ('f1-1', '用户管理', 'sys:user', 'functions/sys/userManager', 'fa fa-user-plus', 1, 1, 0, 'f1', null, null, null,
        null, null, 0);
INSERT INTO docmanager.sys_function (id, name, code, url, icon, enable, type, `index`, parent_id, remarks,
                                     create_user_id, modify_user_id, create_date, modify_date, del_flag)
VALUES ('f1-2', '角色管理', 'sys:role', 'functions/sys/roleManager', 'fa fa-users', 1, 1, 1, 'f1', null, null, null, null,
        null, 0);
INSERT INTO docmanager.sys_function (id, name, code, url, icon, enable, type, `index`, parent_id, remarks,
                                     create_user_id, modify_user_id, create_date, modify_date, del_flag)
VALUES ('f1-3', '功能管理', 'sys:function', 'functions/sys/functionManager', 'fa fa-cogs', 1, 1, 2, 'f1', null, null, null,
        null, null, 0);
INSERT INTO docmanager.sys_function (id, name, code, url, icon, enable, type, `index`, parent_id, remarks,
                                     create_user_id, modify_user_id, create_date, modify_date, del_flag)
VALUES ('f1-4', '字典管理', 'sys:dict', 'functions/sys/dictManager', 'fa fa-book', 1, 1, 3, 'f1', null, null, null, null,
        null, 0);
create table sys_map_role_function
(
  id             varchar(100)         not null
    primary key,
  function_id    varchar(100)         null comment '功能 from 功能表',
  role_id        varchar(100)         null comment '角色 from 角色表',
  remarks        varchar(200)         null comment '备注',
  create_user_id varchar(100)         null comment '创建者id',
  modify_user_id varchar(100)         null comment '最后修改者id',
  create_date    datetime             null comment '创建日期',
  modify_date    datetime             null comment '最后修改日期',
  del_flag       tinyint(1) default 0 null comment '是否被删除'
);


create table sys_map_user_role
(
  id             varchar(100)         not null
    primary key,
  role_id        varchar(100)         null comment '角色 from 角色表',
  user_id        varchar(100)         null comment '用户 from 用户表',
  remarks        varchar(200)         null comment '备注',
  create_user_id varchar(100)         null comment '创建者id',
  modify_user_id varchar(100)         null comment '最后修改者id',
  create_date    datetime             null comment '创建日期',
  modify_date    datetime             null comment '最后修改日期',
  del_flag       tinyint(1) default 0 null comment '是否被删除'
);

INSERT INTO docmanager.sys_map_user_role (id, role_id, user_id, remarks, create_user_id, modify_user_id, create_date,
                                          modify_date, del_flag)
VALUES ('0c7fd2a3a5864abbbc61b08b3932dccb', 'r1', 'u1', '', 'u1', 'u1', '2019-03-26 18:02:05', '2019-03-26 18:02:05',
        0);
create table sys_role
(
  id             varchar(100)         not null
    primary key,
  code           varchar(100)         null comment '角色代码',
  sort           int                  null comment '排序',
  name           varchar(100)         null comment '角色名',
  remarks        varchar(200)         null comment '备注',
  create_user_id varchar(100)         null comment '创建者id',
  modify_user_id varchar(100)         null comment '最后修改者id',
  create_date    datetime             null comment '创建日期',
  modify_date    datetime             null comment '最后修改日期',
  del_flag       tinyint(1) default 0 null comment '是否被删除'
);

INSERT INTO docmanager.sys_role (id, code, sort, name, remarks, create_user_id, modify_user_id, create_date,
                                 modify_date, del_flag)
VALUES ('52b5883409fb43b8ae1224e0142cde21', 'student', 0, '学生', '', 'u1', 'u1', '2019-03-25 10:34:56',
        '2019-03-25 10:34:56', 0);
INSERT INTO docmanager.sys_role (id, code, sort, name, remarks, create_user_id, modify_user_id, create_date,
                                 modify_date, del_flag)
VALUES ('a406722c6dbe4a7a96f4377804839082', 'teacher', 0, '教师', '', 'u1', 'u1', '2019-03-25 10:34:39',
        '2019-03-25 10:34:39', 0);
INSERT INTO docmanager.sys_role (id, code, sort, name, remarks, create_user_id, modify_user_id, create_date,
                                 modify_date, del_flag)
VALUES ('r1', 'admin', null, '管理员', null, null, null, null, null, 0);
create table sys_user
(
  id               varchar(100)         not null
    primary key,
  sex_id           varchar(100)         null comment '性别 from 字典表',
  user_type        varchar(100)         null comment '用户类型:admin:管理员;teacher:教师;student:学生',
  password         varchar(100)         null comment '密码',
  work_id          varchar(100)         null comment '工号/学号',
  real_name        varchar(100)         null comment '真名',
  username         varchar(100)         null comment '用户名',
  duty             varchar(100)         null comment '职务',
  title            varchar(100)         null comment '职称',
  mobile           varchar(100)         null comment '手机号',
  phone            varchar(100)         null comment '座机',
  email            varchar(100)         null comment '邮箱',
  political_status varchar(100)         null comment '政治面貌',
  healthy          varchar(100)         null comment '健康状况',
  birthplace       varchar(100)         null comment '出生地',
  birthday         datetime             null comment '出生日期',
  hire_date        datetime             null comment '入职/入学日期',
  id_number        varchar(100)         null comment '身份证号',
  remarks          varchar(200)         null comment '备注',
  create_user_id   varchar(100)         null comment '创建者id',
  modify_user_id   varchar(100)         null comment '最后修改者id',
  create_date      datetime             null comment '创建日期',
  modify_date      datetime             null comment '最后修改日期',
  del_flag         tinyint(1) default 0 null comment '是否被删除'
);

INSERT INTO docmanager.sys_user (id, sex_id, user_type, password, work_id, real_name, username, duty, title, mobile,
                                 phone, email, political_status, healthy, birthplace, birthday, hire_date, id_number,
                                 remarks, create_user_id, modify_user_id, create_date, modify_date, del_flag)
VALUES ('u1', null, 'admin', 'admin', null, null, 'admin', null, null, null, null, null, null, null, null, null, null,
        null, null, null, null, null, null, 0);