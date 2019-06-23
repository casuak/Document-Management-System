package team.abc.ssm.modules.patent.service;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import javax.annotation.Resource;
import javax.print.Doc;

import team.abc.ssm.common.utils.UserUtils;
import team.abc.ssm.modules.author.dao.AuthorMapper;
import team.abc.ssm.modules.author.dao.SysUserMapper;
import team.abc.ssm.modules.author.entity.Author;
import team.abc.ssm.modules.author.entity.SysUser;
import team.abc.ssm.modules.patent.dao.DocPatentMapper;
import team.abc.ssm.modules.patent.dao.MapUserPatentMapper;
import team.abc.ssm.modules.patent.entity.DocPatent;
import team.abc.ssm.modules.patent.entity.MapUserPatent;
import team.abc.ssm.modules.sys.entity.User;

import java.util.Date;
import java.util.List;
import java.util.UUID;

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
     * 专利初始化
     * */
    public void initialPatent(){
        //0.获取所有status是-1的专利项目
        List<DocPatent> patentList = docPatentMapper.selectAllByStatus("-1");
        //1.授权日期string -> datetime

        //编程0
        //2.第一作者第二作者分割
        //3.第一作者
    }

    /**
     * 从authorList中分割出第一作者和第二作者的姓名
     */
    public void authorNameDivision(List<DocPatent> patentList){
        for (int i = 0; i < patentList.size(); i++) {
            String authorListStr  = patentList.get(i).getAuthorList();
            String[] tmpAuthorArr = authorListStr.split("[, ;]");
            patentList.get(i).setFirstAuthorName(tmpAuthorArr[0]);
            patentList.get(i).setSecondAuthorName(tmpAuthorArr[1]);
        }
    }

    /**
     * 作者匹配
     */
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
            patent.setStatus1("2");
            patent.setStatus("1");
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
                    userPatent.setId(UUID.randomUUID().toString());
                    userPatent.setAuthorType(1);
                    userPatent.setPatentId(patent.getId());
                    userPatent.setUserId(firstAuthor.getId());
                    userPatent.setCreateDate(dateNow);
                    userPatent.setModifyDate(dateNow);
                    userPatent.setCreateUserId(loginedUser.getId());
                    userPatent.setModifyUserId(loginedUser.getId());
                    mapUserPatentMapper.insert(userPatent);
                } else if(secondAuthorList.size() == 1) {
                    //2.1.2第二发明人在学生中唯一
                    patent.setStatus2("0");
                    secondAuthor = secondAuthorList.get(0);
                    if(secondAuthor.getTutorWorkId().equals(firstAuthor.getWorkId())){
                        //2.1.2.1 第二发明人(学生)的导师是第一发明人 —— 情况2：专利属于两者
                        MapUserPatent userPatent1 = new MapUserPatent();
                        MapUserPatent userPatent2 = new MapUserPatent();

                        Date dateNow = new Date();
                        userPatent1.setId(UUID.randomUUID().toString());
                        userPatent1.setAuthorType(1);
                        userPatent1.setPatentId(patent.getId());
                        userPatent1.setUserId(firstAuthor.getId());
                        userPatent1.setCreateDate(dateNow);
                        userPatent1.setModifyDate(dateNow);
                        userPatent1.setCreateUserId(loginedUser.getId());
                        userPatent1.setModifyUserId(loginedUser.getId());

                        userPatent2.setId(UUID.randomUUID().toString());
                        userPatent2.setAuthorType(2);
                        userPatent2.setPatentId(patent.getId());
                        userPatent2.setUserId(secondAuthor.getId());
                        userPatent2.setCreateDate(dateNow);
                        userPatent2.setModifyDate(dateNow);
                        userPatent2.setCreateUserId(loginedUser.getId());
                        userPatent2.setModifyUserId(loginedUser.getId());

                        mapUserPatentMapper.insert(userPatent1);
                        mapUserPatentMapper.insert(userPatent2);
                    }else{
                        //2.1.2.2 第二发明人(学生)的导师不是第一发明人 —— 情况3：专利仅属于该导师
                        MapUserPatent userPatent = new MapUserPatent();
                        Date dateNow = new Date();
                        userPatent.setId(UUID.randomUUID().toString());
                        userPatent.setAuthorType(1);
                        userPatent.setPatentId(patent.getId());
                        userPatent.setUserId(firstAuthor.getId());
                        userPatent.setCreateDate(dateNow);
                        userPatent.setModifyDate(dateNow);
                        userPatent.setCreateUserId(loginedUser.getId());
                        userPatent.setModifyUserId(loginedUser.getId());
                        mapUserPatentMapper.insert(userPatent);
                    }
                }else{
                    int secondMatchFlag = 0;
                    //2.1.3第二发明人在学生中多个
                    patent.setStatus2("1");
                    for (int i = 0; i < secondAuthorList.size(); i++) {
                        SysUser tmpStudent = secondAuthorList.get(i);
                        String tutorWorkId = tmpStudent.getTutorWorkId();
                        if(tutorWorkId.equals(firstAuthor.getId())){
                            //2.1.3.1 情况4：属于导师和学生
                            MapUserPatent userPatent1 = new MapUserPatent();
                            MapUserPatent userPatent2 = new MapUserPatent();

                            Date dateNow = new Date();
                            userPatent1.setId(UUID.randomUUID().toString());
                            userPatent1.setAuthorType(1);
                            userPatent1.setPatentId(patent.getId());
                            userPatent1.setUserId(firstAuthor.getId());
                            userPatent1.setCreateDate(dateNow);
                            userPatent1.setModifyDate(dateNow);
                            userPatent1.setCreateUserId(loginedUser.getId());
                            userPatent1.setModifyUserId(loginedUser.getId());

                            userPatent2.setId(UUID.randomUUID().toString());
                            userPatent2.setAuthorType(2);
                            userPatent2.setPatentId(patent.getId());
                            userPatent2.setUserId(tmpStudent.getId());
                            userPatent2.setCreateDate(dateNow);
                            userPatent2.setModifyDate(dateNow);
                            userPatent2.setCreateUserId(loginedUser.getId());
                            userPatent2.setModifyUserId(loginedUser.getId());

                            mapUserPatentMapper.insert(userPatent1);
                            mapUserPatentMapper.insert(userPatent2);
                            secondMatchFlag = 1;
                            patent.setSecondAuthorId(tmpStudent.getId());
                            break;
                        }
                    }

                    //2.1.3.2情况5：仅属于导师
                    if(secondMatchFlag == 0 ){
                        MapUserPatent userPatent = new MapUserPatent();

                        Date dateNow = new Date();
                        userPatent.setId(UUID.randomUUID().toString());
                        userPatent.setAuthorType(1);
                        userPatent.setPatentId(patent.getId());
                        userPatent.setUserId(firstAuthor.getId());
                        userPatent.setCreateDate(dateNow);
                        userPatent.setModifyDate(dateNow);
                        userPatent.setCreateUserId(loginedUser.getId());
                        userPatent.setModifyUserId(loginedUser.getId());

                        mapUserPatentMapper.insert(userPatent);
                    }
                }
            }
            else{
                //2.2第一作者是学生

            }
        }else {
            //3第一发明人多个
            patent.setStatus1("1");
        }

    }
}
