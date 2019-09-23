package team.abc.ssm.modules.patent.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.print.Doc;

import org.springframework.transaction.annotation.Transactional;
import team.abc.ssm.common.utils.UserUtils;
import team.abc.ssm.common.web.FirstAuMatchType;
import team.abc.ssm.common.web.PatentMatchType;
import team.abc.ssm.common.web.SecondAuMatchType;
import team.abc.ssm.modules.author.dao.SysUserMapper;
import team.abc.ssm.modules.author.entity.AuthorStatistics;
import team.abc.ssm.modules.author.entity.SysUser;
import team.abc.ssm.modules.author.service.AuthorService;
import team.abc.ssm.modules.author.service.SysUserService;
import team.abc.ssm.modules.doc.entity.StatisticCondition;
import team.abc.ssm.modules.patent.dao.DocPatentMapper;
import team.abc.ssm.modules.patent.entity.DocPatent;
import team.abc.ssm.modules.patent.entity.MapUserPatent;
import team.abc.ssm.modules.sys.dao.UserDao;
import team.abc.ssm.modules.sys.entity.User;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

import static team.abc.ssm.common.web.PatentMatchType.*;

@Service
public class DocPatentService {
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

    @Resource
    private DocPatentMapper docPatentMapper;

    @Autowired
    private SysUserMapper sysUserMapper;


    @Autowired
    private MapUserPatentService mapUserPatentService;

    @Autowired
    private SysUserService sysUserService;

    @Autowired
    private AuthorService authorService;

    @Autowired
    private UserDao userDao;

    private  List<User> userList=new ArrayList<>();


    public int deleteByPrimaryKey(String id) {
        return docPatentMapper.deleteByPrimaryKey(id);
    }


    public int insert(DocPatent record) {
        return docPatentMapper.insert(record);
    }


    public int insertSelective(DocPatent record) {
        return docPatentMapper.insertSelective(record);
    }


    public DocPatent selectByPrimaryKey(String id) {
        return docPatentMapper.selectByPrimaryKey(id);
    }


    public int updateByPrimaryKeySelective(DocPatent record) {
        return docPatentMapper.updateByPrimaryKeySelective(record);
    }


    public int updateByPrimaryKey(DocPatent record) {
        return docPatentMapper.updateByPrimaryKey(record);
    }

    /*-------------- auto maded --------------*/

    //专利统计详情页面的条件查询
    public List<DocPatent> selectListByPageWithStatisticCondition(StatisticCondition statisticCondition){
        return docPatentMapper.selectAllByPageWithStatisticCondition(statisticCondition);
    }

    //专利统计详情页面的专利数目统计
    public int selectNumWithStatisticCondition(StatisticCondition statisticCondition) {
        return docPatentMapper.selectNumWithStatisticCondition(statisticCondition);
    }

    public List<DocPatent> selectListByPage(DocPatent patent) {
        List<DocPatent> patentList = docPatentMapper.selectListByPage(patent);
        for (DocPatent tmpPatent : patentList) {
            if (tmpPatent.getFirstAuthorId() != null && !tmpPatent.getFirstAuthorId().equals("")) {
                tmpPatent.setFirstAuthor(sysUserMapper.selectByPrimaryKey(tmpPatent.getFirstAuthorId()));
            }

            if (tmpPatent.getSecondAuthorId() != null && !tmpPatent.getSecondAuthorId().equals("")) {
                tmpPatent.setSecondAuthor(sysUserMapper.selectByPrimaryKey(tmpPatent.getSecondAuthorId()));
            }
        }
        return patentList;
    }

    /**
     * 获取指定作者的所有专利List
     **/
    public List<DocPatent> selectMyPatentListByPage(String authorWorkId, DocPatent docPatent) {
        //1.docPatent的id暂时存储当前需要查询的作者的workId
        docPatent.setId(authorWorkId);
        //2.设置需要查找的专利的状态为：已完成
        docPatent.setStatus(PatentMatchType.MATCH_FINISHED.toString());
        //2.查询当前作者的专利List
        return docPatentMapper.selectMyPatentList(docPatent);
    }

    public int selectSearchCount(DocPatent patent) {
        return docPatentMapper.selectSearchCount(patent);
    }

    /**
     * 统计发明人的所属学院，决策出最优的patent的学院(前提是第一作者不确定)
     **/
    public String getInstitute(String[] authorNames) {
        Map<String, Integer> instituteMap = new HashMap<>();
        String theInstitute = null;
        int maxWeight = 0;

        for (String authorName : authorNames) {
            List<SysUser> tmpSysUsers = sysUserMapper.selectAllByRealName(authorName);
            if (tmpSysUsers == null || tmpSysUsers.size() == 0) {
                //如果sys_user表中没有这个用户
                continue;
            }

            for (SysUser tmpUser : tmpSysUsers) {
                if (instituteMap.containsKey(tmpUser.getSchool())) {
                    int tmpInstituteWeight = instituteMap.get(tmpUser.getSchool());
                    instituteMap.put(tmpUser.getSchool(), ++tmpInstituteWeight);
                } else {
                    instituteMap.put(tmpUser.getSchool(), 1);
                }
            }
        }
        for (String instituteKey : instituteMap.keySet()) {
            if (instituteMap.get(instituteKey) > maxWeight) {
                maxWeight = instituteMap.get(instituteKey);
                theInstitute = instituteKey;
            }
        }
        System.out.println(instituteMap);
        return theInstitute;
    }

    /**
     * 初始化所有专利
     **/
    public void initialPatent() throws ParseException {
        User userNow = UserUtils.getCurrentUser();
        Date dateNow = new Date();

        String rightPersonStr = null;
        String[] rightPerson = null;
        boolean rightPersonFlag = false;

        //0.获取所有status是-1(未初始化)的专利项目
        List<DocPatent> patentList = docPatentMapper.selectAllByStatus("-1");

        for (DocPatent tmpPatent : patentList) {
            rightPersonFlag = false;

            //0.看数据库中是有重复的专利
            if (docPatentMapper.selectByStatusAndPatentNumberAndDelFlag(MATCH_FINISHED.toString(),
                    tmpPatent.getPatentNumber(), false) != 0) {
                tmpPatent.setStatus(IMPORT_REPEAT.toString());
                tmpPatent.setModifyUserId(userNow.getId());
                tmpPatent.setModifyDate(dateNow);
                //重复的直接删除
                docPatentMapper.deleteByPrimaryKey(tmpPatent.getId());
                continue;
            }

            //1.授权日期string -> datetime
            tmpPatent.setPatentAuthorizationDate(sdf.parse(tmpPatent.getPatentAuthorizationDateString()));
            //2.过滤掉专利权人不是北理的
            rightPersonStr = tmpPatent.getPatentRightPerson();
            rightPerson = rightPersonStr.split("[, ;]");
            for (String tmpRightPerson : rightPerson) {
                if ("北京理工大学".equals(tmpRightPerson)) {
                    rightPersonFlag = true;
                    break;
                }
            }
            //如果专利权人中没有属于北理的
            if (!rightPersonFlag) {
                tmpPatent.setStatus(PatentMatchType.FILTRATED.toString());
                tmpPatent.setModifyUserId(userNow.getId());
                tmpPatent.setModifyDate(dateNow);
                docPatentMapper.updateByPrimaryKeySelective(tmpPatent);
                continue;
            }
            if (tmpPatent.getAuthorList() == null) {
                //3.1如果authorList为空
                tmpPatent.setStatus(PatentMatchType.AUTHOR_MISSED.toString());
                tmpPatent.setModifyUserId(userNow.getId());
                tmpPatent.setModifyDate(dateNow);
                docPatentMapper.updateByPrimaryKeySelective(tmpPatent);
            } else {
                //3.2authorList不为空
                String[] authorArray = tmpPatent.getAuthorList().split("[, ;]");
                //4分割出第一发明人和第二发明人姓名，设置第一发明人和第二发明人状态
                if (authorArray.length == 1) {
                    //发明人个数 =1，只有一个作者
                    tmpPatent.setStatus2(SecondAuMatchType.ONLY_FIRST_AUTHOR.toString());
                } else {
                    //发明人个数 >1
                    tmpPatent.setSecondAuthorName(authorArray[1]);
                    tmpPatent.setStatus2(SecondAuMatchType.UNMATCHED.toString());
                }
                tmpPatent.setFirstAuthorName(authorArray[0]);
                tmpPatent.setStatus1(FirstAuMatchType.UNMATCHED.toString());
                //5.设置每个专利的institute项(取消)
                // tmpPatent.setInstitute(getInstitute(authorArray));
                //6.设置当前tmpPatent为未匹配状态
                tmpPatent.setStatus(PatentMatchType.UNMATCHED.toString());
                //7.更新修改人和日期信息
                tmpPatent.setModifyDate(dateNow);
                tmpPatent.setModifyUserId(userNow.getId());
                //8.mapper层更新
                docPatentMapper.updateByPrimaryKeySelective(tmpPatent);
            }
        }
    }

    /**
     * @author zm
     * 第一作者唯一的处理：
     **/
    public DocPatent firstAuthorUnique(DocPatent docPatent) {
        //2.2 此时唯一确定第一作者
        docPatent.setFirstAuthor(docPatent.getFirstAuthorList().get(0));
        docPatent.setFirstAuthorId(docPatent.getFirstAuthor().getId());
        docPatent.setFirstAuthorType(docPatent.getFirstAuthor().getUserType());
        /*------ 7.17 new add start------*/
        docPatent.setFirstAuthorWorkId(docPatent.getFirstAuthor().getWorkId());
        /*------ 7.17 new add finish------*/
        docPatent.setInstitute(docPatent.getFirstAuthor().getSchool());
        //判断有无第二作者
        if (docPatent.getStatus2().equals(SecondAuMatchType.ONLY_FIRST_AUTHOR.toString())) {
            //2.2.1 匹配成功，第一作者成功，无第二作者
            docPatent.setStatuses(MATCH_SUCCESS,
                    FirstAuMatchType.MATCH_SUCCESS,
                    null);
        } else {
            //2.2.2 有第二作者
            if ("teacher".equals(docPatent.getFirstAuthor().getUserType())) {
                //2.2.2.1 第一作者是导师(唯一)
                docPatent.setSecondAuthorList(sysUserMapper.selectByRealNameAndUserType(
                        docPatent.getSecondAuthorName(),
                        "student"));
                if (docPatent.getSecondAuthorList() == null || docPatent.getSecondAuthorList().size() == 0) {
                    //2.2.2.1.1 第二作者无匹配
                    docPatent.setStatuses(
                            MATCH_SUCCESS,
                            FirstAuMatchType.MATCH_SUCCESS,
                            SecondAuMatchType.NO_MATCHED
                    );
                } else if (docPatent.getSecondAuthorList().size() == 1) {
                    if (docPatent.getSecondAuthorList().get(0).getTutorWorkId() != null) {
                        if (docPatent.getSecondAuthorList().get(0).getTutorWorkId().equals(docPatent.getFirstAuthor().getWorkId())) {
                            //2.2.2.1.2
                            docPatent.setStatuses(
                                    MATCH_SUCCESS,
                                    FirstAuMatchType.MATCH_SUCCESS,
                                    SecondAuMatchType.MATCH_SUCCESS);
                            docPatent.setSecondAuthorId(docPatent.getSecondAuthorList().get(0).getId());
                            docPatent.setSecondAuthorType(docPatent.getSecondAuthorList().get(0).getUserType());
                            /*------ 7.17 new add start------*/
                            docPatent.setSecondAuthorWorkId(docPatent.getSecondAuthorList().get(0).getWorkId());
                            /*------ 7.17 new add finish------*/
                        } else {
                            //2.2.2.1.3 有导师workId但是不匹配
                            docPatent.setStatuses(
                                    MATCH_SUCCESS,
                                    FirstAuMatchType.MATCH_SUCCESS,
                                    SecondAuMatchType.NO_MATCHED);
                        }
                    } else {
                        //2.2.2.1.4 第二作者没得导师workId
                        docPatent.setStatuses(
                                JUDGE_NEEDED,
                                FirstAuMatchType.MATCH_SUCCESS,
                                SecondAuMatchType.JUDGE_NEEDED);
                    }
                } else {
                    int tutorCount = 0;
                    List<SysUser> secondAuthorStudents = new ArrayList<>();

                    for (SysUser tmpSecondAuthor : docPatent.getSecondAuthorList()) {
                        if (tmpSecondAuthor.getTutorWorkId() != null) {
                            if (tmpSecondAuthor.getTutorWorkId().equals(docPatent.getFirstAuthor().getWorkId())) {
                                tutorCount++;
                                secondAuthorStudents.add(tmpSecondAuthor);
                            }
                        }
                    }
                    if (tutorCount == 0) {
                        //2.2.2.1.5
                        docPatent.setStatuses(
                                MATCH_SUCCESS,
                                FirstAuMatchType.MATCH_SUCCESS,
                                SecondAuMatchType.NO_MATCHED);
                    } else if (tutorCount == 1) {
                        //2.2.2.1.6
                        docPatent.setStatuses(
                                MATCH_SUCCESS,
                                FirstAuMatchType.MATCH_SUCCESS,
                                SecondAuMatchType.MATCH_SUCCESS);
                        docPatent.setSecondAuthorId(secondAuthorStudents.get(0).getId());
                        docPatent.setSecondAuthorType(secondAuthorStudents.get(0).getUserType());

                        /*------ 7.17 new add start------*/
                        docPatent.setSecondAuthorWorkId(secondAuthorStudents.get(0).getWorkId());
                        /*------ 7.17 new add finish------*/
                    } else {
                        //2.2.2.1.7 第二作者有多个的导师都是第一作者
                        if (secondAuthorStudents.size() == 2) {
                            //2.2.2.1.7.1
                            //如果是硕博连读，判断两个的入职时间和授权公告日哪个更接近
                            Date patentAuthorizationDate = docPatent.getPatentAuthorizationDate();
                            SysUser master;
                            SysUser doctor;
                            if (secondAuthorStudents.get(0).getHireDate().before(secondAuthorStudents.get(1).getHireDate())) {
                                //第一个是硕士，第二个是博士
                                master = secondAuthorStudents.get(0);
                                doctor = secondAuthorStudents.get(1);

                            } else {
                                //第一个是博士，第二个是硕士
                                master = secondAuthorStudents.get(1);
                                doctor = secondAuthorStudents.get(0);
                            }

                            if (patentAuthorizationDate.after(master.getHireDate())) {
                                //专利授权日在博士入职后——属于博士
                                docPatent.setSecondAuthorId(doctor.getId());
                                docPatent.setSecondAuthorType(doctor.getUserType());
                                /*------ 7.17 new add start------*/
                                docPatent.setSecondAuthorWorkId(doctor.getWorkId());
                                /*------ 7.17 new add finish------*/
                            } else {
                                //专利授权日在博士入职前——属于硕士
                                docPatent.setSecondAuthorId(master.getId());
                                docPatent.setSecondAuthorType(master.getUserType());
                                /*------ 7.17 new add start------*/
                                docPatent.setSecondAuthorWorkId(master.getWorkId());
                                /*------ 7.17 new add finish------*/
                            }
                            docPatent.setStatuses(
                                    MATCH_SUCCESS,
                                    FirstAuMatchType.MATCH_SUCCESS,
                                    SecondAuMatchType.MATCH_SUCCESS);
                        } else {
                            //2.2.2.1.7.2
                            docPatent.setStatuses(
                                    PatentMatchType.JUDGE_NEEDED,
                                    FirstAuMatchType.MATCH_SUCCESS,
                                    SecondAuMatchType.JUDGE_NEEDED);
                        }
                    }
                }
            } else {
                //2.2.2.2 第一作者是学生(唯一)
                int tutorCount = 0;
                if (docPatent.getFirstAuthor().getTutorWorkId() == null) {
                    //2.2.2.2.0
                    docPatent.setStatuses(
                            PatentMatchType.JUDGE_NEEDED,
                            FirstAuMatchType.MATCH_SUCCESS,
                            SecondAuMatchType.JUDGE_NEEDED);
                } else {
                    SysUser theTutor = sysUserMapper.selectByWorkId(docPatent.getFirstAuthor().getTutorWorkId());
                    /*String[] authorArray = docPatent.getAuthorList().split("[, ;]");
                    if (theTutor != null) {
                        for (int i = 1; i < authorArray.length; i++) {
                            if (authorArray[i].equals(theTutor.getRealName())) {
                                tutorCount++;
                            }
                        }
                    }
                    if (tutorCount == 0) {
                        //2.2.2.2.1 一作导师不在其余发明人中，这样专利仅有一作 -> 20190803修改为属于学生和导师
                        docPatent.setStatuses(
                                PatentMatchType.MATCH_SUCCESS,
                                FirstAuMatchType.MATCH_SUCCESS,
                                SecondAuMatchType.NO_MATCHED);
                    } else if (tutorCount == 1) {
                        //2.2.2.2.2
                        docPatent.setStatuses(
                                PatentMatchType.MATCH_SUCCESS,
                                FirstAuMatchType.MATCH_SUCCESS,
                                SecondAuMatchType.MATCH_SUCCESS);
                        docPatent.setSecondAuthor(sysUserMapper.selectByWorkId(
                                docPatent.getFirstAuthor().getTutorWorkId()));
                        docPatent.setSecondAuthorId(docPatent.getSecondAuthor().getId());
                        *//*------ 7.17 new add start------*//*
                        docPatent.setSecondAuthorWorkId(docPatent.getSecondAuthor().getWorkId());
                        *//*------ 7.17 new add finish------*//*
                    } else {
                        //2.2.2.2.3
                        docPatent.setStatuses(
                                PatentMatchType.JUDGE_NEEDED,
                                FirstAuMatchType.MATCH_SUCCESS,
                                SecondAuMatchType.JUDGE_NEEDED);
                    }*/

                    /*----- 20190803修改,start ----*/
                    /*第一作者存在，如果其导师存在就属于该学生和该导师*/
                    if (theTutor != null) {
                        docPatent.setStatuses(
                                PatentMatchType.MATCH_SUCCESS,
                                FirstAuMatchType.MATCH_SUCCESS,
                                SecondAuMatchType.MATCH_SUCCESS);
                        docPatent.setSecondAuthorId(theTutor.getId());
                        docPatent.setSecondAuthorType(theTutor.getUserType());
                        docPatent.setSecondAuthorWorkId(theTutor.getWorkId());
                    } else {
                        //第一作者没有导师，这个情况应该人工判断
                        docPatent.setStatuses(
                                PatentMatchType.JUDGE_NEEDED,
                                FirstAuMatchType.MATCH_SUCCESS,
                                SecondAuMatchType.JUDGE_NEEDED);
                    }
                    /*----- 20190803修改,end ----*/
                }
            }
        }
        return docPatent;
    }

    /**
     * 单个patent的作者匹配函数
     **/
    @Transactional(rollbackFor = Exception.class)
    public String authorMatch(DocPatent docPatent) {
        User userNow = UserUtils.getCurrentUser();
        Date dateNow = new Date();
        String tmpInstitute;

        docPatent.setFirstAuthorList(sysUserMapper.selectByRealName(docPatent.getFirstAuthorName()));

        if (docPatent.getFirstAuthorList() == null || docPatent.getFirstAuthorList().size() == 0) {
            //2.1
            docPatent.setStatuses(PatentMatchType.MATCH_ERROR,
                    FirstAuMatchType.NO_MATCHED, null);
        } else {
            if (docPatent.getFirstAuthorList().size() == 1) {
                //第一作者唯一的处理方式
                docPatent = firstAuthorUnique(docPatent);
            } else {
                //2.3 第一作者有多个,利用学院来判定
                tmpInstitute = getInstitute(docPatent.getAuthorList().split("[, ;]"));
                docPatent.setFirstAuthorList(sysUserMapper.selectByRealNameAndSchool(
                        docPatent.getFirstAuthorName(), tmpInstitute));

                if (docPatent.getFirstAuthorList().size() == 0) {
                    //利用学院的信息筛选之后的第一作者数量是0
                    docPatent.setStatuses(JUDGE_NEEDED, FirstAuMatchType.UNMATCHED, SecondAuMatchType.UNMATCHED);
                    //设置学院信息以供判断
                    //docPatent.setInstitute(tmpInstitute);
                } else if (docPatent.getFirstAuthorList().size() == 1) {
                    //利用学院的信息筛选之后的第一作者数量是1
                    docPatent = firstAuthorUnique(docPatent);
                } else {
                    //利用学院的信息筛选之后的第一作者数量是>1
                    //判断有无第二作者
                    if (docPatent.getStatus2().equals(SecondAuMatchType.ONLY_FIRST_AUTHOR.toString())) {
                        //2.3.1 只有第一作者，且第一作者重复
                        docPatent.setStatuses(
                                PatentMatchType.JUDGE_NEEDED,
                                FirstAuMatchType.JUDGE_NEEDED, null);
                    } else {
                        //2.3.2
                        int studentCount = 0;
                        int teacherCount = 0;
                        List<SysUser> teacherList = new ArrayList<>();
                        List<SysUser> studentList;

                        for (SysUser tmpUser :
                                docPatent.getFirstAuthorList()) {
                            if ("teacher".equals(tmpUser.getUserType())) {
                                teacherCount++;
                            } else {
                                studentCount++;
                            }
                        }
                        if (teacherCount == docPatent.getFirstAuthorList().size()) {
                            //2.3.2.1 第一作者重复且全是导师
                            studentList = sysUserMapper.selectByRealNameAndUserType(
                                    docPatent.getSecondAuthorName(),
                                    "student");
                            List<SysUser> resStudentList = new ArrayList<>();
                            if (studentList.size() == 0) {
                                //2.3.2.1.1
                                docPatent.setStatuses(
                                        PatentMatchType.JUDGE_NEEDED,
                                        FirstAuMatchType.JUDGE_NEEDED,
                                        SecondAuMatchType.UNMATCHED);
                            } else if (studentList.size() == 1) {
                                docPatent.setSecondAuthorId(studentList.get(0).getId());
                                docPatent.setSecondAuthorType(studentList.get(0).getUserType());
                                /*------ 7.17 new add start------*/
                                docPatent.setSecondAuthorWorkId(studentList.get(0).getWorkId());
                                /*------ 7.17 new add finish------*/
                                if (studentList.get(0).getTutorWorkId() == null) {
                                    //2.3.2.1.2.1
                                    docPatent.setStatuses(
                                            JUDGE_NEEDED,
                                            FirstAuMatchType.MATCH_REPEATED,
                                            SecondAuMatchType.MATCH_SUCCESS);
                                } else {
                                    SysUser tmpTutor = sysUserMapper.selectByWorkId(studentList.get(0).getTutorWorkId());
                                    /*------ 7.19 new add start 如果workId存在但是数据库没有这个人------*/
                                    if (tmpTutor == null) {
                                        docPatent.setStatuses(
                                                MATCH_ERROR,
                                                FirstAuMatchType.NO_MATCHED,
                                                SecondAuMatchType.MATCH_SUCCESS);
                                    } else {
                                        if (tmpTutor.getRealName().equals(docPatent.getFirstAuthorName())) {
                                            //2.3.2.1.2.2
                                            docPatent.setStatuses(
                                                    MATCH_SUCCESS,
                                                    FirstAuMatchType.MATCH_SUCCESS,
                                                    SecondAuMatchType.MATCH_SUCCESS);
                                            docPatent.setFirstAuthorId(tmpTutor.getId());
                                            docPatent.setFirstAuthorType(tmpTutor.getUserType());

                                            /*------ 7.17 new add start------*/
                                            docPatent.setFirstAuthorWorkId(tmpTutor.getWorkId());
                                            /*------ 7.17 new add finish------*/
                                            docPatent.setInstitute(tmpTutor.getSchool());
                                        } else {
                                            //2.3.2.1.2.3
                                            docPatent.setStatuses(
                                                    MATCH_ERROR,
                                                    FirstAuMatchType.MATCH_REPEATED,
                                                    SecondAuMatchType.MATCH_SUCCESS);
                                        }
                                    }
                                }
                            } else {
                                //2.3.2.1.3
                                int correctTutorNameCount = 0;
                                for (SysUser tmpStudent : studentList) {
                                    if (tmpStudent.getTutorWorkId() != null && !"".equals(tmpStudent.getTutorWorkId())) {
                                        SysUser tmpTutor = sysUserMapper.selectByWorkId(tmpStudent.getTutorWorkId());
                                        if (tmpTutor != null) {
                                            if (tmpTutor.getRealName().equals(docPatent.getFirstAuthorName())) {
                                                correctTutorNameCount++;
                                                resStudentList.add(tmpStudent);
                                            }
                                        }
                                    }
                                }

                                if (correctTutorNameCount == 0) {
                                    //2.3.2.1.3.1
                                    docPatent.setStatuses(
                                            PatentMatchType.JUDGE_NEEDED,
                                            FirstAuMatchType.MATCH_REPEATED,
                                            SecondAuMatchType.MATCH_REPEATED);
                                } else if (correctTutorNameCount == 1) {
                                    //2.3.2.1.3.2
                                    docPatent.setStatuses(
                                            MATCH_SUCCESS,
                                            FirstAuMatchType.MATCH_SUCCESS,
                                            SecondAuMatchType.MATCH_SUCCESS);

                                    docPatent.setSecondAuthor(resStudentList.get(0));
                                    docPatent.setSecondAuthorId(resStudentList.get(0).getId());
                                    docPatent.setSecondAuthorType(resStudentList.get(0).getUserType());
                                    /*------ 7.17 new add start------*/
                                    docPatent.setSecondAuthorWorkId(resStudentList.get(0).getWorkId());
                                    /*------ 7.17 new add finish------*/
                                    docPatent.setFirstAuthor(sysUserMapper.selectByWorkId(
                                            resStudentList.get(0).getTutorWorkId()));
                                    docPatent.setFirstAuthorId(docPatent.getFirstAuthor().getId());
                                    docPatent.setFirstAuthorType(docPatent.getFirstAuthor().getUserType());

                                    /*------ 7.17 new add start------*/
                                    docPatent.setFirstAuthorWorkId(docPatent.getFirstAuthor().getWorkId());
                                    /*------ 7.17 new add finish------*/
                                    docPatent.setInstitute(docPatent.getFirstAuthor().getSchool());
                                } else {
                                    //2.3.2.1.3.3
                                    docPatent.setStatuses(
                                            PatentMatchType.JUDGE_NEEDED,
                                            FirstAuMatchType.MATCH_REPEATED,
                                            SecondAuMatchType.MATCH_REPEATED);
                                }
                            }
                        } else if (studentCount == docPatent.getFirstAuthorList().size()) {
                            //2.3.2.2 第一作者重复且全是学生
                            //查询所有重名学生的导师
                            for (SysUser tmpStudent : docPatent.getFirstAuthorList()) {
                                if (tmpStudent.getTutorWorkId() == null || "".equals(tmpStudent.getTutorWorkId())) {
                                    continue;
                                }
                                List<SysUser> tmpStudentList = new ArrayList<>();
                                tmpStudentList.add(tmpStudent);
                                SysUser tmpTeacher = sysUserMapper.selectByWorkId(tmpStudent.getTutorWorkId());
                                if (tmpTeacher == null) {
                                    continue;
                                }
                                tmpTeacher.setMyStudents(tmpStudentList);
                                teacherList.add(tmpTeacher);
                            }

                            int correctTutorNameCount = 0;
                            String[] authorNameArray = docPatent.getAuthorList().split("[, ;]");
                            List<SysUser> resTeacherList = new ArrayList<>();

                            for (int i = 1; i < authorNameArray.length; i++) {
                                for (SysUser tmpTeacher :
                                        teacherList) {
                                    if (tmpTeacher.getRealName().equals(authorNameArray[i])) {
                                        correctTutorNameCount++;
                                        resTeacherList.add(tmpTeacher);
                                    }
                                }
                            }

                            if (correctTutorNameCount == 0) {
                                //2.3.2.2.1
                                docPatent.setStatuses(
                                        PatentMatchType.JUDGE_NEEDED,
                                        FirstAuMatchType.MATCH_REPEATED,
                                        SecondAuMatchType.UNMATCHED);
                            } else if (correctTutorNameCount == 1) {
                                //2.3.2.2.2
                                docPatent.setStatuses(
                                        MATCH_SUCCESS,
                                        FirstAuMatchType.MATCH_SUCCESS,
                                        SecondAuMatchType.MATCH_SUCCESS);
                                docPatent.setFirstAuthor(resTeacherList.get(0).getMyStudents().get(0));
                                docPatent.setFirstAuthorId(docPatent.getFirstAuthor().getId());
                                docPatent.setFirstAuthorType(docPatent.getFirstAuthor().getUserType());

                                /*------ 7.17 new add start------*/
                                docPatent.setFirstAuthorWorkId(docPatent.getFirstAuthor().getWorkId());
                                /*------ 7.17 new add finish------*/
                                docPatent.setSecondAuthor(resTeacherList.get(0));
                                docPatent.setSecondAuthorId(resTeacherList.get(0).getId());
                                docPatent.setSecondAuthorType(resTeacherList.get(0).getUserType());

                                /*------ 7.17 new add start------*/
                                docPatent.setSecondAuthorWorkId(resTeacherList.get(0).getWorkId());
                                /*------ 7.17 new add finish------*/
                                docPatent.setInstitute(docPatent.getFirstAuthor().getSchool());
                            } else {
                                //2.3.2.2.3
                                //判断第一作者是不是硕博连读
                                if (resTeacherList.size() == 2) {
                                    if (resTeacherList.get(0).getWorkId().equals(resTeacherList.get(1).getWorkId())) {
                                        //第一作者是硕博连读
                                        SysUser master;
                                        SysUser doctor;
                                        //区分出硕士生和博士生
                                        if (resTeacherList.get(0).getMyStudents().get(0).getHireDate().before(
                                                resTeacherList.get(1).getMyStudents().get(0).getHireDate())) {
                                            master = resTeacherList.get(0).getMyStudents().get(0);
                                            doctor = resTeacherList.get(1).getMyStudents().get(0);
                                        } else {
                                            master = resTeacherList.get(1).getMyStudents().get(0);
                                            doctor = resTeacherList.get(0).getMyStudents().get(0);
                                        }
                                        //对比硕士和博士入学日期和专利的发表日期
                                        if (docPatent.getPatentAuthorizationDate().after(doctor.getHireDate())) {
                                            docPatent.setFirstAuthorId(doctor.getId());
                                            docPatent.setFirstAuthorType(doctor.getUserType());

                                            /*------ 7.17 new add start------*/
                                            docPatent.setFirstAuthorWorkId(doctor.getWorkId());
                                            /*------ 7.17 new add finish------*/
                                            docPatent.setInstitute(doctor.getSchool());
                                        } else {
                                            docPatent.setFirstAuthorId(master.getId());
                                            docPatent.setFirstAuthorType(master.getUserType());

                                            /*------ 7.17 new add start------*/
                                            docPatent.setFirstAuthorWorkId(master.getWorkId());
                                            /*------ 7.17 new add finish------*/
                                            docPatent.setInstitute(master.getSchool());
                                        }
                                        docPatent.setSecondAuthorId(resTeacherList.get(0).getId());
                                        docPatent.setSecondAuthorType(resTeacherList.get(0).getUserType());
                                        /*------ 7.17 new add start------*/
                                        docPatent.setSecondAuthorWorkId(resTeacherList.get(0).getWorkId());
                                        /*------ 7.17 new add finish------*/
                                        docPatent.setStatuses(
                                                MATCH_SUCCESS,
                                                FirstAuMatchType.MATCH_SUCCESS,
                                                SecondAuMatchType.MATCH_SUCCESS);
                                    }
                                } else {
                                    docPatent.setStatuses(
                                            PatentMatchType.JUDGE_NEEDED,
                                            FirstAuMatchType.MATCH_REPEATED,
                                            SecondAuMatchType.UNMATCHED);
                                }
                            }
                        } else {
                            //2.3.2.3 第一作者重复且导师学生都有
                            docPatent.setStatuses(
                                    PatentMatchType.JUDGE_NEEDED,
                                    FirstAuMatchType.MATCH_REPEATED,
                                    SecondAuMatchType.UNMATCHED);
                        }
                    }
                }
            }
        }

        //更新当前的patent信息
        docPatent.setModifyDate(dateNow);
        docPatent.setModifyUserId(userNow.getId());
        docPatentMapper.updateByPrimaryKeySelective(docPatent);

        return docPatent.getStatus();
    }

    public Map<String, Integer> patentUserMatch() {
        String tmpRes;
        int totalMatch;
        int successMatch = 0;
        int errorMatch = 0;
        int needJudge = 0;
        Map<String, Integer> resMap = new HashMap<>();

        List<DocPatent> patentsForMatch = docPatentMapper.selectAllByStatus(PatentMatchType.UNMATCHED.toString());
        totalMatch = patentsForMatch.size();
        for (DocPatent tmpPatent : patentsForMatch) {
            tmpRes = authorMatch(tmpPatent);
            if (tmpRes.equals(PatentMatchType.MATCH_SUCCESS.toString())) {
                //匹配成功
                successMatch++;
            } else if (tmpRes.equals(PatentMatchType.MATCH_ERROR.toString())) {
                //匹配失败
                errorMatch++;
            } else {
                //需要人工判断
                needJudge++;
            }
        }

        resMap.put("totalMatch", totalMatch);
        resMap.put("success", successMatch);
        resMap.put("error", errorMatch);
        resMap.put("judge", needJudge);

        return resMap;
    }

    @Transactional(rollbackFor = Exception.class)
    public boolean deleteListByIds(List<DocPatent> patentList) {
        patentList=docPatentMapper.selectConvertToCompleteByIds(patentList);
        List<DocPatent> deleteList = new ArrayList<>();
        for (DocPatent tmpPatent : patentList) {
           if(MATCH_FINISHED.toString().equals(tmpPatent.getStatus())){
               deleteList.add(tmpPatent);
           }
        }
        if(deleteList.size()>0)
        authorService.deletePatentCount(deleteList);

        int count = 0;
        for (DocPatent tmpPatent : patentList) {
            if (docPatentMapper.deleteByPrimaryKey(tmpPatent.getId()) == 1) {
                count++;
            }
        }
        return count == patentList.size();
    }

    public boolean deleteByStatus(String status) {
        if(MATCH_FINISHED.toString().equals(status)){
            List<DocPatent> patents = docPatentMapper.selectAllByStatus(status);
            authorService.deletePatentCount(patents);
        }
        docPatentMapper.deleteByStatus(status);
        return true;
    }

    public int setPatentAuthor(String patentId, int authorIndex, String authorId) {
        return docPatentMapper.setPatentAuthor(patentId, authorIndex, authorId);
    }

    public boolean convertToSuccessByIds(List<DocPatent> patentList) {
        patentList=docPatentMapper.selectConvertToCompleteByIds(patentList);
        List<DocPatent> deleteList = new ArrayList<>();
        for (DocPatent tmpPatent : patentList) {
            if(MATCH_FINISHED.toString().equals(tmpPatent.getStatus())){
                deleteList.add(tmpPatent);
            }
        }
        if(deleteList.size()>0)
            authorService.deletePatentCount(deleteList);


        int count = docPatentMapper.convertToSuccessByIds(patentList);
        return count == patentList.size();
    }

    public boolean convertToCompleteAll() {
        List<DocPatent> matchSucPatents = docPatentMapper.selectAllByStatus(MATCH_SUCCESS.toString());
        //统计
        authorService.addPatentCount(matchSucPatents);
        int count = docPatentMapper.convertToCompleteByIds(matchSucPatents);
        return count == matchSucPatents.size();
    }

    public boolean convertToCompleteByIds(List<DocPatent> patentList) {
        List<DocPatent> docPatents = docPatentMapper.selectConvertToCompleteByIds(patentList);
        authorService.addPatentCount(docPatents);

        int count = docPatentMapper.convertToCompleteByIds(patentList);
        return count == patentList.size();
    }

    /**
     * 完成专利后，再mapUserPatent插入记录
     * not used —— 08-05
     **/
    @Transactional(rollbackFor = Exception.class)
    public void insertPatentMapRecord(List<DocPatent> patentList) {
        User userNow = UserUtils.getCurrentUser();
        Date dateNow = new Date();

        for (DocPatent tmpPatent : patentList) {
            MapUserPatent mapUserPatent = new MapUserPatent();

            mapUserPatent.setCreateUserId(userNow.getId());
            mapUserPatent.setModifyUserId(userNow.getId());
            mapUserPatent.setCreateDate(dateNow);
            mapUserPatent.setModifyDate(dateNow);
            mapUserPatent.setPatentId(tmpPatent.getId());

            SysUser firstAuthor = sysUserService.selectByWorkId(tmpPatent.getFirstAuthorWorkId());

            mapUserPatent.setUserWorkId(firstAuthor.getWorkId());
            //1.第一作者记录先插入
            mapUserPatentService.insertSelective(mapUserPatent);
            if ("teacher".equals(firstAuthor.getUserType())) {
                //2.1一作是老师，二作者如果是该导师的学生，则也属于该学生
                if (tmpPatent.getSecondAuthorWorkId() != null && !"".equals(tmpPatent.getSecondAuthorWorkId())) {
                    SysUser secondAuthor = sysUserService.selectByWorkId(tmpPatent.getSecondAuthorWorkId());
                    if (secondAuthor.getTutorWorkId() != null && !"".equals(secondAuthor.getTutorWorkId())) {
                        //第二作者导师存在
                        if (secondAuthor.getTutorWorkId().equals(firstAuthor.getWorkId())) {
                            //第二作者导师是第一作者
                            mapUserPatent.setId(UUID.randomUUID().toString());
                            mapUserPatent.setUserWorkId(secondAuthor.getWorkId());
                            mapUserPatentService.insertSelective(mapUserPatent);
                        }
                    }
                }
            } else if ("student".equals(firstAuthor.getUserType())) {
                //2.2一作是学生属于导师和该学生
                if (firstAuthor.getTutorWorkId() != null && !"".equals(firstAuthor.getTutorWorkId())) {
                    mapUserPatent.setUserWorkId(firstAuthor.getTutorWorkId());
                    mapUserPatent.setId(UUID.randomUUID().toString());
                    mapUserPatentService.insertSelective(mapUserPatent);
                }
            }
        }
    }

    public boolean changeInstitute(String patentId, String institute) {
        DocPatent theDocPatent = docPatentMapper.selectByPrimaryKey(patentId);
        theDocPatent.setInstitute(institute);
        theDocPatent.setModifyUserId(UserUtils.getCurrentUser().getId());
        theDocPatent.setModifyDate(new Date());
        return docPatentMapper.updateByPrimaryKeySelective(theDocPatent) == 1;
    }

    public int getMyPatentNum(String myWorkId) {
        return docPatentMapper.selectMyPatentNum(myWorkId);
    }

    public Map<String,Integer> doPatentStatistics(StatisticCondition statisticCondition){
        //0.专利的已完成状态是4
        statisticCondition.setStatus("4");

        if(userList.size() == 0 )
            userList=userDao.selectAll();
        int totalNum;
        int studentPatentNum = 0,teacherPatentNum = 0,doctorPatentNum = 0;
        Map<String,Integer> statisticsResMap = new HashMap<>();

        List<DocPatent> patentList = docPatentMapper.getStatisticNumOfPatent(statisticCondition);
        totalNum = patentList.size();
        for (DocPatent tmpPatent : patentList) {
            if("teacher".equals(tmpPatent.getFirstAuthorType())){
                teacherPatentNum ++;
            }else if ("student".equals(tmpPatent.getFirstAuthorType())){
                studentPatentNum++;
            }else if ("doctor".equals(tmpPatent.getFirstAuthorType())){
                doctorPatentNum++;
            }

            if("teacher".equals(tmpPatent.getSecondAuthorType())){
                teacherPatentNum ++;
            }else if ("student".equals(tmpPatent.getSecondAuthorType())){
                String teacherId=null;
                for(User user:userList){
                    if(tmpPatent.getSecondAuthorWorkId().equals(user.getWorkId())){
                        teacherId = user.getTutorWorkId();
                        break;
                    }
                }
                if(!teacherId.equals("")&&teacherId!= null &&teacherId.equals(tmpPatent.getFirstAuthorWorkId())){
                    studentPatentNum++;
                }
            }else if ("doctor".equals(tmpPatent.getSecondAuthorType())){
                doctorPatentNum++;
            }
        }
        statisticsResMap.put("studentPatent",studentPatentNum);
        statisticsResMap.put("teacherPatent",teacherPatentNum);
        statisticsResMap.put("doctorPatent",doctorPatentNum);
        statisticsResMap.put("totalPatent",totalNum);
        return statisticsResMap;
    }

    /** 获取所有专利类型 */
    public List<String> getAllPatentType() {
        return docPatentMapper.selectAllPatentType();
    }
}