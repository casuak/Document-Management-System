package team.abc.ssm.modules.patent.service;

import io.swagger.models.auth.In;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

import org.springframework.transaction.annotation.Transactional;
import team.abc.ssm.common.utils.UserUtils;
import team.abc.ssm.common.web.FirstAuMatchType;
import team.abc.ssm.common.web.PatentMatchType;
import team.abc.ssm.common.web.SecondAuMatchType;
import team.abc.ssm.modules.author.dao.SysUserMapper;
import team.abc.ssm.modules.author.entity.SysUser;
import team.abc.ssm.modules.patent.dao.DocPatentMapper;
import team.abc.ssm.modules.patent.dao.MapUserPatentMapper;
import team.abc.ssm.modules.patent.entity.DocPatent;
import team.abc.ssm.modules.sys.entity.User;

import java.beans.Transient;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

import static team.abc.ssm.common.web.PatentMatchType.MATCH_SUCCESS;

@Service
public class DocPatentService {

    @Resource
    private DocPatentMapper docPatentMapper;

    @Autowired
    private SysUserMapper sysUserMapper;

    @Autowired
    private MapUserPatentMapper mapUserPatentMapper;

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

    public List<DocPatent> selectListByPage(DocPatent patent) {
        return docPatentMapper.selectListByPage(patent);
    }

    public int selectSearchCount(DocPatent patent) {
        return docPatentMapper.selectSearchCount(patent);
    }


    /**
     * @author zm
     * @date 2019/6/23 20:20
     * @params [authorNames]
     * @return: java.lang.String
     * @Description //统计发明人的所属学院，决策出最优的patent的学院
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
     * @author zm
     * @date 2019/6/24 8:23
     * @params []
     * @return: void
     * @Description //初始化所有专利
     **/
    public void initialPatent() throws ParseException {
        User userNow = UserUtils.getCurrentUser();
        Date dateNow = new Date();

        String rightPersonStr = null;
        String[] rightPerson = null;
        boolean rightPersonFlag = false;

        //0.获取所有status是-1(未初始化)的专利项目
        List<DocPatent> patentList = docPatentMapper.selectAllByStatus("-1");

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
        for (DocPatent tmpPatent : patentList) {
            rightPersonFlag = false;

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
                tmpPatent.setStatus(PatentMatchType.FILTRATED);
                tmpPatent.setModifyUserId(userNow.getId());
                tmpPatent.setModifyDate(dateNow);
                docPatentMapper.updateByPrimaryKeySelective(tmpPatent);
                continue;
            }
            if (tmpPatent.getAuthorList() == null) {
                //3.1如果authorList为空
                tmpPatent.setStatus(PatentMatchType.AUTHOR_MISSED);
                tmpPatent.setModifyUserId(userNow.getId());
                tmpPatent.setModifyDate(dateNow);
                docPatentMapper.updateByPrimaryKeySelective(tmpPatent);
            } else {
                //3.2authorList不为空
                String[] authorArray = tmpPatent.getAuthorList().split("[, ;]");
                //4分割出第一发明人和第二发明人姓名，设置第一发明人和第二发明人状态
                if (authorArray.length == 1) {
                    //发明人个数 =1，只有一个作者
                    tmpPatent.setStatus2(SecondAuMatchType.ONLY_FIRST_AUTHOR);
                } else {
                    //发明人个数 >1
                    tmpPatent.setSecondAuthorName(authorArray[1]);
                    tmpPatent.setStatus2(SecondAuMatchType.UNMATCHED);
                }
                tmpPatent.setFirstAuthorName(authorArray[0]);
                tmpPatent.setStatus1(FirstAuMatchType.UNMATCHED);
                //5.设置每个专利的institute项
                tmpPatent.setInstitute(getInstitute(authorArray));
                //6.设置当前tmpPatent为未匹配状态
                tmpPatent.setStatus(PatentMatchType.UNMATCHED);
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
     * @date 2019/6/24 8:22
     * @params [patent]
     * @return: void
     * @Description //单个patent的作者匹配函数
     **/
    @Transactional(rollbackFor = Exception.class)
    public String authorMatch(DocPatent docPatent) {
        User userNow = UserUtils.getCurrentUser();
        Date dateNow = new Date();

        docPatent.setFirstAuthorList(
                sysUserMapper.selectByRealNameAndSchool(
                        docPatent.getFirstAuthorName(),
                        docPatent.getInstitute())
        );

        if (docPatent.getFirstAuthorList() == null || docPatent.getFirstAuthorList().size() == 0) {
            //2.1
            docPatent.setStatuses(PatentMatchType.MATCH_ERROR,
                    FirstAuMatchType.NO_MATCHED, null);
        } else {
            if (docPatent.getFirstAuthorList().size() == 1) {
                //2.2
                docPatent.setFirstAuthor(docPatent.getFirstAuthorList().get(0));
                docPatent.setFirstAuthorId(docPatent.getFirstAuthor().getId());
                //判断有无第二作者
                if (docPatent.getStatus2().equals(SecondAuMatchType.ONLY_FIRST_AUTHOR.toString())) {
                    //2.2.1
                    docPatent.setStatuses(MATCH_SUCCESS,
                            FirstAuMatchType.MATCH_SUCCESS,
                            null);
                } else {
                    //2.2.2
                    if ("teacher".equals(docPatent.getFirstAuthor().getUserType())) {
                        //2.2.2.1
                        docPatent.setSecondAuthorList(sysUserMapper.selectByRealNameAndUserType(
                                docPatent.getSecondAuthorName(),
                                "student"));
                        if (docPatent.getSecondAuthorList() == null || docPatent.getSecondAuthorList().size() == 0) {
                            //2.2.2.1.1
                            docPatent.setStatuses(
                                    MATCH_SUCCESS,
                                    FirstAuMatchType.MATCH_SUCCESS,
                                    SecondAuMatchType.NO_MATCHED
                            );
                        } else if (docPatent.getSecondAuthorList().size() == 1) {
                            if (docPatent.getSecondAuthorList().get(0).getTutorWorkId().equals(docPatent.getFirstAuthor().getWorkId())) {
                                //2.2.2.1.2
                                docPatent.setStatuses(
                                        MATCH_SUCCESS,
                                        FirstAuMatchType.MATCH_SUCCESS,
                                        SecondAuMatchType.MATCH_SUCCESS);
                                docPatent.setSecondAuthorId(docPatent.getSecondAuthorList().get(0).getId());
                            } else {
                                //2.2.2.1.3
                                docPatent.setStatuses(
                                        MATCH_SUCCESS,
                                        FirstAuMatchType.MATCH_SUCCESS,
                                        SecondAuMatchType.NO_MATCHED);
                            }
                        } else {
                            int tutorCount = 0;
                            List<String> secondAuthorIds = new ArrayList<>();

                            for (SysUser tmpSecondAuthor :
                                    docPatent.getSecondAuthorList()) {
                                if (tmpSecondAuthor.getTutorWorkId().equals(docPatent.getFirstAuthor().getWorkId())) {
                                    tutorCount++;
                                    secondAuthorIds.add(tmpSecondAuthor.getId());
                                }
                            }
                            if (tutorCount == 0) {
                                //2.2.2.1.4
                                docPatent.setStatuses(
                                        MATCH_SUCCESS,
                                        FirstAuMatchType.MATCH_SUCCESS,
                                        SecondAuMatchType.NO_MATCHED);
                            } else if (tutorCount == 1) {
                                //2.2.2.1.5
                                docPatent.setStatuses(
                                        MATCH_SUCCESS,
                                        FirstAuMatchType.MATCH_SUCCESS,
                                        SecondAuMatchType.MATCH_SUCCESS);
                                docPatent.setSecondAuthorId(secondAuthorIds.get(0));
                            } else {
                                //2.2.2.1.6
                                docPatent.setStatuses(
                                        PatentMatchType.JUDGE_NEEDED,
                                        FirstAuMatchType.MATCH_SUCCESS,
                                        SecondAuMatchType.JUDGE_NEEDED);
                            }
                        }
                    } else {
                        //2.2.2.2 第一作者是学生(唯一)
                        int tutorCount = 0;
                        SysUser theTutor = sysUserMapper.selectByWorkId(docPatent.getFirstAuthor().getTutorWorkId());
                        String[] authorArray = docPatent.getAuthorList().split("[, ;]");
                        for (int i = 1; i < authorArray.length; i++) {
                            if (authorArray[i].equals(theTutor.getRealName())) {
                                tutorCount++;
                            }
                        }
                        if (tutorCount == 0) {
                            //2.2.2.2.1
                            docPatent.setStatuses(
                                    PatentMatchType.JUDGE_NEEDED,
                                    FirstAuMatchType.MATCH_SUCCESS,
                                    SecondAuMatchType.JUDGE_NEEDED);
                        } else if (tutorCount == 1) {
                            //2.2.2.2.2
                            docPatent.setStatuses(
                                    MATCH_SUCCESS,
                                    FirstAuMatchType.MATCH_SUCCESS,
                                    SecondAuMatchType.MATCH_SUCCESS);
                            docPatent.setSecondAuthor(sysUserMapper.selectByWorkId(
                                    docPatent.getFirstAuthor().getTutorWorkId()));
                            docPatent.setSecondAuthorId(docPatent.getSecondAuthor().getId());
                        } else {
                            //2.2.2.2.3
                            docPatent.setStatuses(
                                    PatentMatchType.JUDGE_NEEDED,
                                    FirstAuMatchType.MATCH_SUCCESS,
                                    SecondAuMatchType.JUDGE_NEEDED);
                        }
                    }
                }
            } else {
                //2.3
                //判断有无第二作者
                if (docPatent.getStatus2().equals(SecondAuMatchType.ONLY_FIRST_AUTHOR.toString())) {
                    //2.3.1
                    docPatent.setStatuses(
                            PatentMatchType.JUDGE_NEEDED,
                            FirstAuMatchType.JUDGE_NEEDED, null);
                } else {
                    //2.3.2
                    int studentCount = 0;
                    int teacherCount = 0;
                    List<SysUser> teachertList = new ArrayList<>();
                    List<SysUser> studentList = new ArrayList<>();

                    for (SysUser tmpUser :
                            docPatent.getFirstAuthorList()) {
                        if ("teacher".equals(tmpUser.getUserType())) {
                            teacherCount++;
                        } else {
                            studentCount++;
                        }
                    }
                    if (teacherCount == docPatent.getFirstAuthorList().size()) {
                        //2.3.2.1
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
                            //2.3.2.1.2
                            docPatent.setStatuses(
                                    MATCH_SUCCESS,
                                    FirstAuMatchType.MATCH_SUCCESS,
                                    SecondAuMatchType.MATCH_SUCCESS);

                            docPatent.setSecondAuthor(studentList.get(0));
                            docPatent.setSecondAuthorId(studentList.get(0).getId());
                            docPatent.setFirstAuthor(sysUserMapper.selectByWorkId(
                                    studentList.get(0).getTutorWorkId()));
                            docPatent.setFirstAuthorId(docPatent.getFirstAuthor().getId());
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
                                System.out.println("2.3.2.1.3.1");
                                docPatent.setStatuses(
                                        PatentMatchType.JUDGE_NEEDED,
                                        FirstAuMatchType.MATCH_REPEATED,
                                        SecondAuMatchType.MATCH_REPEATED);
                            } else if (correctTutorNameCount == 1) {
                                //2.3.2.1.3.2
                                System.out.println("2.3.2.1.3.2");
                                docPatent.setStatuses(
                                        MATCH_SUCCESS,
                                        FirstAuMatchType.MATCH_SUCCESS,
                                        SecondAuMatchType.MATCH_SUCCESS);

                                docPatent.setSecondAuthor(resStudentList.get(0));
                                docPatent.setSecondAuthorId(resStudentList.get(0).getId());
                                docPatent.setFirstAuthor(sysUserMapper.selectByWorkId(
                                        resStudentList.get(0).getTutorWorkId()));
                                docPatent.setFirstAuthorId(docPatent.getFirstAuthor().getId());
                            } else {
                                //2.3.2.1.3.3
                                System.out.println("2.3.2.1.3.3");
                                docPatent.setStatuses(
                                        PatentMatchType.JUDGE_NEEDED,
                                        FirstAuMatchType.MATCH_REPEATED,
                                        SecondAuMatchType.MATCH_REPEATED);
                            }
                        }
                    } else if (studentCount == docPatent.getFirstAuthorList().size()) {
                        //2.3.2.2
                        //查询所有重名学生的导师
                        for (SysUser tmpStudent :
                                docPatent.getFirstAuthorList()) {
                            List<SysUser> tmpStudentList = new ArrayList<>();
                            tmpStudentList.add(tmpStudent);
                            if (tmpStudent.getTutorWorkId() == null || "".equals(tmpStudent.getTutorWorkId())) {
                                continue;
                            }
                            SysUser tmpTeacher = sysUserMapper.selectByWorkId(tmpStudent.getTutorWorkId());
                            if (tmpTeacher == null) {
                                continue;
                            }
                            tmpTeacher.setMyStudents(tmpStudentList);
                            teachertList.add(tmpTeacher);
                        }

                        int correctTutorNameCount = 0;
                        String[] authorNameArray = docPatent.getAuthorList().split("[, ;]");
                        List<SysUser> resTeacherList = new ArrayList<>();

                        for (int i = 1; i < authorNameArray.length; i++) {
                            for (SysUser tmpTeacher :
                                    teachertList) {
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
                            docPatent.setSecondAuthor(resTeacherList.get(0));
                            docPatent.setSecondAuthorId(resTeacherList.get(0).getId());
                        } else {
                            //2.3.2.2.3
                            docPatent.setStatuses(
                                    PatentMatchType.JUDGE_NEEDED,
                                    FirstAuMatchType.MATCH_REPEATED,
                                    SecondAuMatchType.UNMATCHED);
                        }
                    } else {
                        //2.3.2.3
                        docPatent.setStatuses(
                                PatentMatchType.JUDGE_NEEDED,
                                FirstAuMatchType.MATCH_REPEATED,
                                SecondAuMatchType.UNMATCHED);
                    }
                }
            }
        }

        //更新当前的patent信息
        docPatent.setModifyDate(dateNow);
        docPatent.setModifyUserId(userNow.getId());
        docPatentMapper.updateByPrimaryKey(docPatent);

        return docPatent.getStatus();
    }

    /**
     * @author zm
     * @date 2019/7/3 10:15
     * @params []
     * @return: java.util.Map<java.lang.String,java.lang.Integer>
     * @Description //对所有已初始化(未匹配)的专利进行专利用户匹配
     **/
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

    /**
     * @author zm
     * @date 2019/7/3 9:48
     * @params [patentList]
     * @return: boolean
     * @Description //根据ids删除patents
     **/
    @Transactional(rollbackFor = Exception.class)
    public boolean deleteListByIds(List<DocPatent> patentList) {
        int count = 0;
        for (DocPatent tmpPatent : patentList) {
            if (docPatentMapper.deleteByPrimaryKey(tmpPatent.getId()) == 1) {
                count++;
            }
        }
        return count == patentList.size();
    }
}