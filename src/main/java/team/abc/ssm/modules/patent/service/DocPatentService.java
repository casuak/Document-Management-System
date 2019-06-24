package team.abc.ssm.modules.patent.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import javax.annotation.Resource;

import team.abc.ssm.common.utils.UserUtils;
import team.abc.ssm.modules.author.dao.SysUserMapper;
import team.abc.ssm.modules.author.entity.SysUser;
import team.abc.ssm.modules.patent.dao.DocPatentMapper;
import team.abc.ssm.modules.patent.dao.MapUserPatentMapper;
import team.abc.ssm.modules.patent.entity.DocPatent;
import team.abc.ssm.modules.patent.entity.MapUserPatent;
import team.abc.ssm.modules.sys.entity.User;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

@Service
public class DocPatentService{

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
     * @date 2019/6/24 8:23
     * @params []
     * @return: void
     * @Description //专利初始化
     **/
    public void initialPatent() throws ParseException {
        User userNow = UserUtils.getCurrentUser();

        //0.获取所有status是-1的专利项目
        List<DocPatent> patentList = docPatentMapper.selectAllByStatus("-1");

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        for (DocPatent tmpPatent :
                patentList) {
            //1.授权日期string -> datetime
            tmpPatent.setPatentAuthorizationDate(sdf.parse(tmpPatent.getPatentAuthorizationDateString()));
            String[] authorArray = tmpPatent.getAuthorList().split("[, ;]");
            //2.分割出第一发明人和第二发明人姓名
            tmpPatent.setFirstAuthorName(authorArray[0]);
            tmpPatent.setSecondAuthorName(authorArray[1]);
            //3.设置每个专利的institute项
            tmpPatent.setInstitute(getInstitute(authorArray));
            //4.设置当前tmpPatent为未匹配状态
            tmpPatent.setStatus("0");
            //5.更新修改人和日期信息
            tmpPatent.setModifyDate(new Date());
            tmpPatent.setModifyUserId(userNow.getId());
            //5.mapper层更新
            docPatentMapper.updateByPrimaryKeySelective(tmpPatent);
        }
    }

    /**
     * @author zm
     * @date 2019/6/24 8:22
     * @params [patent]
     * @return: void
     * @Description //作者匹配
     **/
    public void authorMatch(DocPatent patent){
        User loginedUser = UserUtils.getCurrentUser();

        String firstAuthorName = patent.getFirstAuthorName();
        String secondAuthorName = patent.getSecondAuthorName();
        List<SysUser> firstAuthorList = null;
        List<SysUser> secondAuthorList = null;
        SysUser firstAuthor = null;
        SysUser secondAuthor = null;

        firstAuthorList = sysUserMapper.selectAllByRealName(firstAuthorName);

        if(firstAuthorList.size() == 0){
            //1第一发明人无匹配：匹配出错
            patent.setStatus("1");
            patent.setStatus1("2");
            patent.setStatus2("2");
        }else if(firstAuthorList.size() ==1){
            //2第一发明人唯一
            patent.setStatus1("0");
            firstAuthor = firstAuthorList.get(0);
            patent.setFirstAuthorId(firstAuthor.getId());

            if("teacher".equals(firstAuthor.getUserType())){
                //2.1第一作者是导师，去学生表中匹配第二作者
                secondAuthorList = sysUserMapper.selectByRealNameAndUserType(secondAuthorName,"student");
                if(secondAuthorList.size() == 0){
                    //2.1.1第二作者在学生中未找到 —— 情况1：专利仅属于导师
                    patent.setStatus2("2");
                    MapUserPatent userPatent = new MapUserPatent();
                    Date dateNow = new Date();
                    userPatent.setAuthorType(1);
                    userPatent.setPatentId(patent.getId());
                    userPatent.setUserId(firstAuthor.getId());
                    userPatent.setCreateDate(dateNow);
                    userPatent.setModifyDate(dateNow);
                    userPatent.setCreateUserId(loginedUser.getId());
                    userPatent.setModifyUserId(loginedUser.getId());
                    mapUserPatentMapper.insertSelective(userPatent);
                    patent.setStatus("2");
                    patent.setStatus2("2");
                } else if(secondAuthorList.size() == 1) {
                    //2.1.2第二发明人在学生中唯一
                    secondAuthor = secondAuthorList.get(0);
                    if(secondAuthor.getTutorWorkId().equals(firstAuthor.getWorkId())){
                        //2.1.2.1 第二发明人(学生)的导师是第一发明人 —— 情况2：专利属于两者
                        MapUserPatent userPatent1 = new MapUserPatent();
                        MapUserPatent userPatent2 = new MapUserPatent();

                        Date dateNow = new Date();
                        userPatent1.setAuthorType(1);
                        userPatent1.setPatentId(patent.getId());
                        userPatent1.setUserId(firstAuthor.getId());
                        userPatent1.setCreateDate(dateNow);
                        userPatent1.setModifyDate(dateNow);
                        userPatent1.setCreateUserId(loginedUser.getId());
                        userPatent1.setModifyUserId(loginedUser.getId());

                        userPatent2.setAuthorType(2);
                        userPatent2.setPatentId(patent.getId());
                        userPatent2.setUserId(secondAuthor.getId());
                        userPatent2.setCreateDate(dateNow);
                        userPatent2.setModifyDate(dateNow);
                        userPatent2.setCreateUserId(loginedUser.getId());
                        userPatent2.setModifyUserId(loginedUser.getId());

                        mapUserPatentMapper.insertSelective(userPatent1);
                        mapUserPatentMapper.insertSelective(userPatent2);
                        patent.setStatus("2");
                        patent.setStatus2("0");
                        patent.setSecondAuthorId(secondAuthor.getId());
                    }else{
                        //2.1.2.2 第二发明人(学生)的导师不是第一发明人 —— 情况3：专利仅属于该导师
                        MapUserPatent userPatent = new MapUserPatent();
                        Date dateNow = new Date();
                        userPatent.setAuthorType(1);
                        userPatent.setPatentId(patent.getId());
                        userPatent.setUserId(firstAuthor.getId());
                        userPatent.setCreateDate(dateNow);
                        userPatent.setModifyDate(dateNow);
                        userPatent.setCreateUserId(loginedUser.getId());
                        userPatent.setModifyUserId(loginedUser.getId());
                        mapUserPatentMapper.insertSelective(userPatent);
                        patent.setStatus("2");
                        patent.setStatus2("2");
                    }
                }else{
                    int secondMatchFlag = 0;
                    //2.1.3第二发明人在学生中多个
                    for (int i = 0; i < secondAuthorList.size(); i++) {
                        SysUser tmpStudent = secondAuthorList.get(i);
                        String tutorWorkId = tmpStudent.getTutorWorkId();
                        if(tutorWorkId.equals(firstAuthor.getId())){
                            //2.1.3.1 情况4：属于导师和学生
                            MapUserPatent userPatent1 = new MapUserPatent();
                            MapUserPatent userPatent2 = new MapUserPatent();

                            Date dateNow = new Date();
                            userPatent1.setAuthorType(1);
                            userPatent1.setPatentId(patent.getId());
                            userPatent1.setUserId(firstAuthor.getId());
                            userPatent1.setCreateDate(dateNow);
                            userPatent1.setModifyDate(dateNow);
                            userPatent1.setCreateUserId(loginedUser.getId());
                            userPatent1.setModifyUserId(loginedUser.getId());

                            userPatent2.setAuthorType(2);
                            userPatent2.setPatentId(patent.getId());
                            userPatent2.setUserId(tmpStudent.getId());
                            userPatent2.setCreateDate(dateNow);
                            userPatent2.setModifyDate(dateNow);
                            userPatent2.setCreateUserId(loginedUser.getId());
                            userPatent2.setModifyUserId(loginedUser.getId());

                            mapUserPatentMapper.insertSelective(userPatent1);
                            mapUserPatentMapper.insertSelective(userPatent2);
                            secondMatchFlag = 1;
                            patent.setStatus("2");
                            patent.setStatus2("0");
                            patent.setSecondAuthorId(tmpStudent.getId());
                            break;
                        }
                    }
                    //2.1.3.2情况5：仅属于导师
                    if(secondMatchFlag == 0 ){
                        MapUserPatent userPatent = new MapUserPatent();

                        Date dateNow = new Date();
                        userPatent.setAuthorType(1);
                        userPatent.setPatentId(patent.getId());
                        userPatent.setUserId(firstAuthor.getId());
                        userPatent.setCreateDate(dateNow);
                        userPatent.setModifyDate(dateNow);
                        userPatent.setCreateUserId(loginedUser.getId());
                        userPatent.setModifyUserId(loginedUser.getId());

                        mapUserPatentMapper.insertSelective(userPatent);
                        patent.setStatus("2");
                        patent.setStatus2("2");
                    }
                }
            }
            else{
                //2.2第一作者是学生
                int tutorCount = 0;
                String[] authorList = patent.getAuthorList().split("[, ;]");
                SysUser tutor = sysUserMapper.selectByWorkId(firstAuthor.getTutorWorkId());
                for (int i = 1; i < authorList.length; i++) {
                    if (authorList[i].equals(tutor.getRealName())){
                        tutorCount++;
                    }
                }

                if (tutorCount == 0){
                    //2.2.2.1 专利记在学生名下，导师无匹配，人工判断
                    MapUserPatent userPatent = new MapUserPatent();
                    Date dateNow = new Date();
                    userPatent.setAuthorType(1);
                    userPatent.setPatentId(patent.getId());
                    userPatent.setUserId(firstAuthor.getId());
                    userPatent.setCreateDate(dateNow);
                    userPatent.setModifyDate(dateNow);
                    userPatent.setCreateUserId(loginedUser.getId());
                    userPatent.setModifyUserId(loginedUser.getId());
                    mapUserPatentMapper.insertSelective(userPatent);

                    patent.setStatus("2");
                    patent.setStatus2("2");
                }else if(tutorCount ==1){
                    //2.2.1.1专利记在导师和学生名下
                    patent.setSecondAuthorId(tutor.getId());

                    MapUserPatent userPatent1 = new MapUserPatent();
                    MapUserPatent userPatent2 = new MapUserPatent();
                    Date dateNow = new Date();
                    userPatent1.setAuthorType(1);
                    userPatent1.setPatentId(patent.getId());
                    userPatent1.setUserId(firstAuthor.getId());
                    userPatent1.setCreateDate(dateNow);
                    userPatent1.setModifyDate(dateNow);
                    userPatent1.setCreateUserId(loginedUser.getId());
                    userPatent1.setModifyUserId(loginedUser.getId());

                    userPatent2.setAuthorType(2);
                    userPatent2.setPatentId(patent.getId());
                    userPatent2.setUserId(tutor.getId());
                    userPatent2.setCreateDate(dateNow);
                    userPatent2.setModifyDate(dateNow);
                    userPatent2.setCreateUserId(loginedUser.getId());
                    userPatent2.setModifyUserId(loginedUser.getId());

                    mapUserPatentMapper.insertSelective(userPatent1);
                    mapUserPatentMapper.insertSelective(userPatent2);

                    patent.setStatus("2");
                    patent.setStatus2("0");
                    patent.setSecondAuthorId(tutor.getId());
                }else{
                    //2.2.1.2专利记在学生名下，导师的人工判断
                    MapUserPatent userPatent = new MapUserPatent();
                    Date dateNow = new Date();
                    userPatent.setAuthorType(1);
                    userPatent.setPatentId(patent.getId());
                    userPatent.setUserId(firstAuthor.getId());
                    userPatent.setCreateDate(dateNow);
                    userPatent.setModifyDate(dateNow);
                    userPatent.setCreateUserId(loginedUser.getId());
                    userPatent.setModifyUserId(loginedUser.getId());
                    mapUserPatentMapper.insertSelective(userPatent);

                    patent.setStatus("2");
                    patent.setStatus2("2");
                }
            }
        }else {
            //3第一发明人多个
            patent.setStatus1("1");

            int studentAuthorCount = 0;
            int teacherAuthorCount = 0;
            for (int i = 0; i < firstAuthorList.size(); i++) {
                if("student".equals(firstAuthorList.get(i).getUserType())){
                    studentAuthorCount++;
                }else{
                    teacherAuthorCount++;
                }
            }

            if(teacherAuthorCount == firstAuthorList.size()){
                //3.1第一发明人：多个重名导师
                for (SysUser tmpUser : firstAuthorList) {
                    if (tmpUser.getSchool().equals(patent.getInstitute())) {
                        //3.1.1 确定第一发明人
                        patent.setFirstAuthorId(tmpUser.getId());
                        patent.setStatus1("0");
                        firstAuthor = tmpUser;
                        break;
                    }
                }
                secondAuthorList = sysUserMapper.selectByRealNameAndUserType(secondAuthorName,"student");
                if(secondAuthorList.size() == 0){
                    //3.1.1.1 专利仅属于导师
                    MapUserPatent userPatent = new MapUserPatent();
                    Date dateNow = new Date();
                    userPatent.setAuthorType(1);
                    userPatent.setPatentId(patent.getId());
                    userPatent.setUserId(firstAuthor.getId());
                    userPatent.setCreateDate(dateNow);
                    userPatent.setModifyDate(dateNow);
                    userPatent.setCreateUserId(loginedUser.getId());
                    userPatent.setModifyUserId(loginedUser.getId());
                    mapUserPatentMapper.insertSelective(userPatent);

                    patent.setStatus2("2");
                    patent.setStatus("2");
                }else if(secondAuthorList.size() ==1){
                    SysUser tmpStudent = secondAuthorList.get(0);

                    if(tmpStudent.getTutorWorkId().equals(firstAuthor.getWorkId())){
                        //3.1.1.2 同时属于导师和学生
                        MapUserPatent userPatent1 = new MapUserPatent();
                        MapUserPatent userPatent2 = new MapUserPatent();
                        Date dateNow = new Date();
                        userPatent1.setAuthorType(1);
                        userPatent1.setPatentId(patent.getId());
                        userPatent1.setUserId(firstAuthor.getId());
                        userPatent1.setCreateDate(dateNow);
                        userPatent1.setModifyDate(dateNow);
                        userPatent1.setCreateUserId(loginedUser.getId());
                        userPatent1.setModifyUserId(loginedUser.getId());

                        userPatent2.setAuthorType(2);
                        userPatent2.setPatentId(patent.getId());
                        userPatent2.setUserId(tmpStudent.getId());
                        userPatent2.setCreateDate(dateNow);
                        userPatent2.setModifyDate(dateNow);
                        userPatent2.setCreateUserId(loginedUser.getId());
                        userPatent2.setModifyUserId(loginedUser.getId());

                        mapUserPatentMapper.insertSelective(userPatent1);
                        mapUserPatentMapper.insertSelective(userPatent2);

                        patent.setStatus("2");
                        patent.setStatus2("0");
                    }else{
                        //3.1.1.3仅仅属于导师
                        MapUserPatent userPatent = new MapUserPatent();
                        Date dateNow = new Date();
                        userPatent.setAuthorType(1);
                        userPatent.setPatentId(patent.getId());
                        userPatent.setUserId(firstAuthor.getId());
                        userPatent.setCreateDate(dateNow);
                        userPatent.setModifyDate(dateNow);
                        userPatent.setCreateUserId(loginedUser.getId());
                        userPatent.setModifyUserId(loginedUser.getId());
                        mapUserPatentMapper.insert(userPatent);

                        patent.setStatus("2");
                        patent.setStatus2("2");
                    }
                }else {
                    //3.1.4 专利属于导师，学生需人工判断
                    MapUserPatent userPatent = new MapUserPatent();
                    Date dateNow = new Date();
                    userPatent.setAuthorType(1);
                    userPatent.setPatentId(patent.getId());
                    userPatent.setUserId(firstAuthor.getId());
                    userPatent.setCreateDate(dateNow);
                    userPatent.setModifyDate(dateNow);
                    userPatent.setCreateUserId(loginedUser.getId());
                    userPatent.setModifyUserId(loginedUser.getId());
                    mapUserPatentMapper.insert(userPatent);

                    patent.setStatus("3");
                    patent.setStatus2("2");
                }
            }else if(studentAuthorCount == firstAuthorList.size()){
                //3.2第一发明人：多个重名学生
                patent.setStatus1("1");
                int studentCount = 0;
                for (SysUser tmpUser : firstAuthorList) {
                    if (tmpUser.getSchool().equals(patent.getInstitute())) {
                        studentCount++;
                    }
                }

                if (studentCount == 0){
                    //3.2.1
                    patent.setStatus2("2");
                    patent.setStatus("1");
                }else if (studentCount == 1 ){
                    //3.2.2
                    firstAuthor = firstAuthorList.get(0);
                    secondAuthor = sysUserMapper.selectByWorkId(firstAuthor.getTutorWorkId());

                    MapUserPatent userPatent1 = new MapUserPatent();
                    MapUserPatent userPatent2 = new MapUserPatent();
                    Date dateNow = new Date();
                    userPatent1.setAuthorType(1);
                    userPatent1.setPatentId(patent.getId());
                    userPatent1.setUserId(firstAuthor.getId());
                    userPatent1.setCreateDate(dateNow);
                    userPatent1.setModifyDate(dateNow);
                    userPatent1.setCreateUserId(loginedUser.getId());
                    userPatent1.setModifyUserId(loginedUser.getId());

                    userPatent2.setAuthorType(2);
                    userPatent2.setPatentId(patent.getId());
                    userPatent2.setUserId(secondAuthor.getId());
                    userPatent2.setCreateDate(dateNow);
                    userPatent2.setModifyDate(dateNow);
                    userPatent2.setCreateUserId(loginedUser.getId());
                    userPatent2.setModifyUserId(loginedUser.getId());

                    mapUserPatentMapper.insertSelective(userPatent1);
                    mapUserPatentMapper.insertSelective(userPatent2);

                    patent.setStatus("2");
                    patent.setStatus2("0");
                }else{
                    //3.2.3
                    int found = 0;
                    List<SysUser> tutorList = new ArrayList<>();
                    for (SysUser tmpFirstAuthor: firstAuthorList) {
                        SysUser tmpTutor = sysUserMapper.selectByWorkId(tmpFirstAuthor.getTutorWorkId());
                        String[] authorList = patent.getAuthorList().split("[, ;]");
                        for (String author : authorList) {
                            if (tmpTutor.getRealName().equals(author)) {
                                //3.2.3.1
                                firstAuthor = tmpFirstAuthor;
                                secondAuthor = tmpTutor;

                                MapUserPatent userPatent1 = new MapUserPatent();
                                MapUserPatent userPatent2 = new MapUserPatent();
                                Date dateNow = new Date();
                                userPatent1.setAuthorType(1);
                                userPatent1.setPatentId(patent.getId());
                                userPatent1.setUserId(firstAuthor.getId());
                                userPatent1.setCreateDate(dateNow);
                                userPatent1.setModifyDate(dateNow);
                                userPatent1.setCreateUserId(loginedUser.getId());
                                userPatent1.setModifyUserId(loginedUser.getId());

                                userPatent2.setAuthorType(2);
                                userPatent2.setPatentId(patent.getId());
                                userPatent2.setUserId(secondAuthor.getId());
                                userPatent2.setCreateDate(dateNow);
                                userPatent2.setModifyDate(dateNow);
                                userPatent2.setCreateUserId(loginedUser.getId());
                                userPatent2.setModifyUserId(loginedUser.getId());

                                mapUserPatentMapper.insertSelective(userPatent1);
                                mapUserPatentMapper.insertSelective(userPatent2);

                                patent.setStatus("2");
                                patent.setStatus2("0");

                                found = 1;
                                break;
                            }
                        }
                        if(found == 1){
                            break;
                        }
                    }
                    if (found == 0){
                        //3.2.3.2 人工判断
                        patent.setStatus("3");
                        patent.setStatus1("1");
                        patent.setStatus2("2");
                    }
                }
            }else{
                //3.3第一发明人：重名导师和学生都有:人工判断
                patent.setStatus("3");
                patent.setStatus1("1");
                patent.setStatus2("2");
            }
        }
    }

    /**
     * @author zm
     * @date 2019/6/23 20:20
     * @params [authorNames]
     * @return: java.lang.String
     * @Description //统计所有发明人最多多的所属学院，并返回
     **/
    public String getInstitute(String[] authorNames){
        Map<String,Integer> instituteMap = new HashMap<>();
        int maxCount = 0;
        String theInstitute = null;
        for (String authorName : authorNames) {
            List<SysUser> tmpSysUsers = sysUserMapper.selectAllByRealName(authorName);

            for (SysUser tmpUser : tmpSysUsers) {
                if (instituteMap.containsKey(tmpUser.getSchool())) {
                    int tmpInstituteCount = instituteMap.get(tmpUser.getSchool());
                    instituteMap.put(tmpUser.getSchool(), ++tmpInstituteCount);
                } else {
                    instituteMap.put(tmpUser.getSchool(), 1);
                }
            }
        }
        for (String instituteKey:instituteMap.keySet()){
            if(instituteMap.get(instituteKey) > maxCount){
                theInstitute = instituteKey;
            }
        }

        return theInstitute;
    }
}