package team.abc.ssm.modules.document.authorStatistics.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import team.abc.ssm.modules.document.authorSearch.dao.AuthorMapper;
import team.abc.ssm.modules.document.authorSearch.entity.Author;
import team.abc.ssm.modules.document.authorStatistics.dao.AuthorStatisticsMapper;
import team.abc.ssm.modules.document.authorStatistics.entity.AuthorStatistics;
import team.abc.ssm.modules.document.docStatistics.dao.DocPatentMapper;
import team.abc.ssm.modules.document.docStatistics.entity.DocPatent;
import team.abc.ssm.modules.document.fund.entity.Fund;
import team.abc.ssm.modules.document.paper.dao.PaperDao;
import team.abc.ssm.modules.document.paper.entity.Paper;
import team.abc.ssm.modules.sys.dao.UserDao;
import team.abc.ssm.modules.sys.entity.Dict;
import team.abc.ssm.modules.sys.entity.User;
import team.abc.ssm.modules.sys.service.UserService;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * @author zm
 * @description
 * @data 2019/4/2
 */
@Service
public class AuthorStatisticsService {

    @Autowired
    private AuthorMapper authorMapper;

    @Autowired
    private PaperDao paperDao;

    @Autowired
    private DocPatentMapper docPatentMapper;

    @Autowired
    AuthorStatisticsMapper authorStatisticsMapper;

    @Autowired
    UserDao userDao;

    @Autowired
    UserService userService;



    private  List<User> userList = new ArrayList<>();



    public List<String> getSubList() {
        return authorMapper.getFirstSub();
    }




    /**
     * 统计2.0
     *  @author wh
     *  @date 9:13 2019/9/19
     *
     */
    public List<AuthorStatistics> getAuthorStatisticsList(AuthorStatistics authorStatistics){
        List<AuthorStatistics> resultList=new ArrayList<>();
        List<AuthorStatistics> tmpList = authorStatisticsMapper.getAuthorListByPage(authorStatistics);
        List<User> userList = userDao.selectByAuthorStatistics(authorStatistics);
        int flagList[]=new int[500000];
        int flag = 1;
        for(AuthorStatistics tmpAuth:tmpList){
            flag = 1;
            for(User user:userList) {
                if (user.getWorkId().equals(tmpAuth.getWorkId())) {
                    resultList.add(tmpAuth);
                    flagList[userList.indexOf(user)] = 1;
                    flag = 0;
                    break;
                }
            }
        }
        for(int i= 0 ; i<userList.size();i++){
            if(flagList[i] == 0){
                resultList.add(new AuthorStatistics(userList.get(i)));
            }
        }
        return resultList;
    }

    public int getAuthorStatisticsNum(AuthorStatistics authorStatistics){
        List<User> userList = userDao.selectByAuthorStatistics(authorStatistics);
        return userList.size();
    }


    //新增论文
    public List<Paper> addPaperCount(List<Paper> paperList){
        if(paperList.size() ==0 ) return null;
        if(userList.size() == 0)
            userList = userService.getAllUsers();

        String workId="";
        String resultSql = "";
        String insertSql="";

        int year = 0;
        Calendar c = Calendar.getInstance();
        User tmpUser = null;

        List<Paper> revertList=new ArrayList<>();

        for(Paper paper :paperList){
            try {
                workId = "";
                c.setTime(paper.getPublishDate());
                year = c.get(Calendar.YEAR);
                if (year == 0) continue;

                if (("student".equals(paper.getFirstAuthorType()) && paper.getSecondAuthorType() == null) || (("student".equals(paper.getFirstAuthorType())) && "student".equals(paper.getSecondAuthorType()) )) {
                    //第一作者学生 第二作者学生(或空)   第一作者学生+1 老师+1
                    tmpUser = getUser(paper.getFirstAuthorId());
                    workId = tmpUser != null ? tmpUser.getTutorWorkId() : "";

                    if (!workId.equals(""))
                        resultSql += getPaperTypeSql(paper, workId, 1, year);
                    insertSql += getInsertTutorSql(getUser(workId), year);

                } else if (paper.getFirstAuthorType() != null && paper.getSecondAuthorType() != null && "teacher".equals(paper.getFirstAuthorType()) && "student".equals(paper.getSecondAuthorType())) {
                    //第一作者老师 第二作者学生
                    tmpUser = getUser(paper.getSecondAuthorId());
                    workId = tmpUser != null ? tmpUser.getTutorWorkId() : "";

                    if (!workId.equals("")) {
                        if (workId.equals(paper.getFirstAuthorId())) {
                            //学生在老师名下
                            resultSql += getPaperTypeSql(paper, paper.getFirstAuthorId(), 1, year);
                            insertSql += getInsertTutorSql(getUser(paper.getFirstAuthorId()), year);

                        } else {
                            //学生不在老师名下
                            resultSql += getPaperTypeSql(paper, paper.getFirstAuthorId(), 3, year);
                            insertSql += getInsertTutorSql(getUser(paper.getFirstAuthorId()), year);
                        }
                    } else {
                        resultSql += getPaperTypeSql(paper, paper.getFirstAuthorId(), 3, year);
                        tmpUser = getUser(paper.getFirstAuthorId());
                        insertSql += getInsertTutorSql(tmpUser, year);
                    }
                } else if (paper.getFirstAuthorType() != null && paper.getSecondAuthorType() != null && "student".equals(paper.getFirstAuthorType()) && "teacher".equals(paper.getSecondAuthorType())) {
                    //第一作者学生  第二作者老师

                    tmpUser = getUser(paper.getFirstAuthorId());
                    workId = tmpUser != null ? tmpUser.getTutorWorkId() : "";

                    if (!workId.equals("")) {
                        resultSql += getPaperTypeSql(paper, workId, 2, year);
                        insertSql += getInsertTutorSql(getUser(workId), year);

                        resultSql += getPaperTypeSql(paper, paper.getSecondAuthorId(), 3, year);
                        tmpUser = getUser(paper.getSecondAuthorId());
                        insertSql += getInsertTutorSql(tmpUser, year);
                    } else {
                        resultSql += getPaperTypeSql(paper, paper.getSecondAuthorId(), 3, year);

                        tmpUser = getUser(paper.getSecondAuthorId());
                        insertSql += getInsertTutorSql(tmpUser, year);
                    }
                } else if ("teacher".equals(paper.getFirstAuthorType()) && paper.getSecondAuthorType() == null) {
                    //一作导师 二作空
                    resultSql += getPaperTypeSql(paper, paper.getFirstAuthorId(), 3, year);

                    tmpUser = getUser(paper.getFirstAuthorId());
                    insertSql += getInsertTutorSql(tmpUser, year);
                }else if(paper.getFirstAuthorType() == null){
                    revertList.add(paper);
                }
            }catch (Exception e){
                revertList.add(paper);
            }
            year = 0;
        }
        resultSql = resultSql.substring(0,resultSql.length()-1);
        insertSql = insertSql.substring(0,insertSql.length()-1);
        //authorStatisticsMapper.doSql(resultSql);
        authorStatisticsMapper.doSql(insertSql);

        resultSql = resultSql.replace("doc_statistics","doc_statistics_year");
        authorStatisticsMapper.doSql(resultSql);

        return revertList;
}
    //删除论文
    public int deletePaperCount(List<Paper> paperList){
        if(paperList.size() ==0 ) return -1;
        if(userList.size() == 0)
            userList = userService.getAllUsers();

        String workId="";
        String resultSql = "";
        User tmpUser;
        int year =0;
        Calendar c = Calendar.getInstance();

        for(Paper paper :paperList){
            c.setTime(paper.getPublishDate());
            year = c.get(Calendar.YEAR);
            if(year == 0) continue;

            workId="";
            if((paper.getFirstAuthorType().equals("student")&&paper.getSecondAuthorType() == null)||(paper.getFirstAuthorType().equals("student") && paper.getSecondAuthorType().equals("student") ) ){
                //第一作者学生 第二作者学生(或空)   第一作者学生+1 老师+1
                tmpUser = getUser(paper.getFirstAuthorId());
                workId = tmpUser != null ? tmpUser.getTutorWorkId() : "";
                if(!workId.equals(""))
                    resultSql +=getPaperTypeSql(paper,workId,1,year);

            }else if(paper.getFirstAuthorType()!= null &&paper.getSecondAuthorType()!= null&&paper.getFirstAuthorType().equals("teacher")&& paper.getSecondAuthorType().equals("student")){
                //第一作者老师 第二作者学生
                tmpUser = getUser(paper.getSecondAuthorId());
                workId = tmpUser != null ? tmpUser.getTutorWorkId() : "";
                if(!workId.equals("")) {
                    if (workId.equals(paper.getFirstAuthorId())) {
                        //学生在老师名下
                        resultSql += getPaperTypeSql(paper, paper.getFirstAuthorId(), 1,year);
                    } else {
                        //学生不在老师名下
                        resultSql += getPaperTypeSql(paper, paper.getFirstAuthorId(), 3,year);
                    }
                }else{
                    resultSql += getPaperTypeSql(paper, paper.getFirstAuthorId(), 3,year);
                }
            }else if(paper.getFirstAuthorType()!= null &&paper.getSecondAuthorType()!= null&&paper.getFirstAuthorType().equals("student") &&paper.getSecondAuthorType().equals("teacher")){
                //第一作者学生  第二作者老师
                tmpUser = getUser(paper.getFirstAuthorId());
                workId = tmpUser != null ? tmpUser.getTutorWorkId() : "";
                if(!workId.equals("")){
                    resultSql += getPaperTypeSql(paper, workId, 2,year);
                    resultSql += getPaperTypeSql(paper, paper.getSecondAuthorId(), 3,year);
                }else{
                    resultSql += getPaperTypeSql(paper, paper.getSecondAuthorId(), 3,year);
                }


            }else if(paper.getFirstAuthorType().equals("teacher") &&paper.getSecondAuthorType() == null){
                //一作导师 二作空
                resultSql += getPaperTypeSql(paper,paper.getFirstAuthorId(),3,year);
            }
            year = 0;
        }

        resultSql = resultSql.replace("+","-");
        resultSql=resultSql.substring(0,resultSql.length()-1);
       // authorStatisticsMapper.doSql(resultSql);

        resultSql = resultSql.replace("doc_statistics","doc_statistics_year");
        authorStatisticsMapper.doSql(resultSql);
        return 0;
    }

    /** 更新论文统计接口 */
    public int updatePaperCount(List<Paper> paperList){
        List<Paper> oldlist = paperDao.selectDeleteListByIds(paperList);
        deletePaperCount(oldlist);
        addPaperCount(paperList);
        return 1;
    }


    //新增专利
    public int addPatentCount(List<DocPatent> patentList){
        if(patentList.size() == 0) return -1;
        if(userList.size() == 0)
            userList = userService.getAllUsers();

        String preTutorSql="update doc_statistics set `tutor_patent`=`tutor_patent`+1 where `work_id`=\"";
        String preStuSql="update doc_statistics set `stu_patent`=`stu_patent`+1 where `work_id`=\"";
        String resultSql = "";
        String workId  ="";

        String insertSql="";
        int year = 0;
        Calendar c = Calendar.getInstance();
        User tmpUser = null;

        for(DocPatent patent:patentList){
            workId="";
            c.setTime(patent.getPatentAuthorizationDate());
            year = c.get(Calendar.YEAR);
            if(year ==0 ) continue;

            if((patent.getFirstAuthorType().equals("student")&&patent.getSecondAuthorType() == null)||(patent.getFirstAuthorType().equals("student") && patent.getSecondAuthorType().equals("student")) ){
                //第一作者学生 第二作者学生(或空)   第一作者学生+1 老师+1
                tmpUser = getUser(patent.getFirstAuthorWorkId());
                workId = tmpUser != null ? tmpUser.getTutorWorkId() : "";
                if(!workId.equals("")){
                    resultSql+=preTutorSql+workId+"\" and `year` ="+year+";";
                    resultSql+=preStuSql+workId+"\"and `year` ="+year+";";
                    insertSql += getInsertTutorSql(tmpUser,year);
                }
            }else if(patent.getFirstAuthorType()!= null && patent.getSecondAuthorType()!=null&&patent.getFirstAuthorType().equals("teacher")&& patent.getSecondAuthorType().equals("student")){
                //第一作者老师 第二作者学生
                tmpUser = getUser(patent.getSecondAuthorWorkId());
                workId = tmpUser != null ? tmpUser.getTutorWorkId() : "";
                if(!workId.equals("")) {
                    if (workId.equals(patent.getFirstAuthorWorkId())) {
                        //学生在老师名下
                        resultSql+=preTutorSql+patent.getFirstAuthorWorkId()+"\"and `year` ="+year+";";
                        resultSql+=preStuSql+patent.getFirstAuthorWorkId()+"\"and `year` ="+year+";";
                        insertSql += getInsertTutorSql(tmpUser,year);

                        tmpUser = getUser(patent.getFirstAuthorWorkId());
                        insertSql += getInsertTutorSql(tmpUser,year);
                    } else {
                        //学生不在老师名下
                        resultSql+=preTutorSql+patent.getFirstAuthorWorkId()+"\"and `year` ="+year+";";
                        tmpUser = getUser(patent.getFirstAuthorWorkId());
                        insertSql += getInsertTutorSql(tmpUser,year);
                    }
                }else{
                    tmpUser = getUser(patent.getFirstAuthorWorkId());
                    insertSql += getInsertTutorSql(tmpUser,year);
                    resultSql+=preTutorSql+patent.getFirstAuthorWorkId()+"\"and `year` ="+year+";";
                }
            }else if(patent.getFirstAuthorType()!= null && patent.getSecondAuthorType()!=null&&patent.getFirstAuthorType().equals("student") &&patent.getSecondAuthorType().equals("teacher")){
                //第一作者学生  第二作者老师
                tmpUser = getUser(patent.getFirstAuthorWorkId());
                workId = tmpUser != null ? tmpUser.getTutorWorkId() : "";

                if(!workId.equals("")){
                    resultSql += preStuSql+workId+"\"and `year` ="+year+";";
                    resultSql += preTutorSql+patent.getSecondAuthorWorkId()+"\"and `year` ="+year+";";
                    insertSql += getInsertTutorSql(tmpUser,year);
                }else{
                    tmpUser = getUser(patent.getSecondAuthorWorkId());
                    insertSql += getInsertTutorSql(tmpUser,year);
                    resultSql += preTutorSql+patent.getSecondAuthorWorkId()+"\"and `year` ="+year+";";
                }


            }else if(patent.getFirstAuthorType()!= null &&patent.getFirstAuthorType().equals("teacher") &&patent.getSecondAuthorType() == null){
                //一作导师 二作空
                resultSql += preTutorSql+patent.getFirstAuthorWorkId()+"\"and `year` ="+year+";";
                tmpUser = getUser(patent.getFirstAuthorWorkId());
                insertSql += getInsertTutorSql(tmpUser,year);
            }


        }
        resultSql = resultSql.substring(0,resultSql.length()-1);
        insertSql = insertSql.substring(0,insertSql.length()-1);

       //authorStatisticsMapper.doSql(resultSql);
        authorStatisticsMapper.doSql(insertSql);

        resultSql = resultSql.replace("doc_statistics","doc_statistics_year");
        authorStatisticsMapper.doSql(resultSql);
        return 0;
    }

    //删除专利
    public  int deletePatentCount(List<DocPatent> patentList){
        if(patentList.size() == 0) return -1;
        if(userList.size() == 0)
            userList = userService.getAllUsers();
        String preTutorSql="update doc_statistics set `tutor_patent`=`tutor_patent`+1 where `work_id`=\"";
        String preStuSql="update doc_statistics set `stu_patent`=`stu_patent`+1 where `work_id`=\"";
        String resultSql = "";
        String workId  ="";

        int year=0;
        Calendar c = Calendar.getInstance();
        User tmpUser;
        for(DocPatent patent:patentList){
            workId="";
            c.setTime(patent.getPatentAuthorizationDate());
            year = c.get(Calendar.YEAR);
            if(year ==0 ) continue;
            if((patent.getFirstAuthorType().equals("student")&&patent.getSecondAuthorType() == null)||(patent.getFirstAuthorType().equals("student") && patent.getSecondAuthorType().equals("student")) ){
                //第一作者学生 第二作者学生(或空)   第一作者学生+1 老师+1
                tmpUser = getUser(patent.getFirstAuthorWorkId());
                workId = tmpUser != null ? tmpUser.getTutorWorkId() : "";
                if(!workId.equals("")){
                    resultSql+=preTutorSql+workId+"\" and `year` ="+year+";";
                    resultSql+=preStuSql+workId+"\" and `year` ="+year+";";
                }
            }else if(patent.getFirstAuthorType()!= null && patent.getSecondAuthorType()!=null&&patent.getFirstAuthorType().equals("teacher")&& patent.getSecondAuthorType().equals("student")){
                //第一作者老师 第二作者学生
                tmpUser = getUser(patent.getSecondAuthorWorkId());
                workId = tmpUser != null ? tmpUser.getTutorWorkId() : "";
                if(!workId.equals("")) {
                    if (workId.equals(patent.getFirstAuthorWorkId())) {
                        //学生在老师名下
                        resultSql+=preTutorSql+patent.getFirstAuthorWorkId()+"\" and `year` ="+year+";";
                        resultSql+=preStuSql+patent.getFirstAuthorWorkId()+"\" and `year` ="+year+";";
                    } else {
                        //学生不在老师名下
                        resultSql+=preTutorSql+patent.getFirstAuthorWorkId()+"\" and `year` ="+year+";";
                    }
                }else{
                    resultSql+=preTutorSql+patent.getFirstAuthorWorkId()+"\" and `year` ="+year+";";
                }
            }else if(patent.getFirstAuthorType()!= null && patent.getSecondAuthorType()!=null&&patent.getFirstAuthorType().equals("student") &&patent.getSecondAuthorType().equals("teacher")){
                //第一作者学生  第二作者老师

                tmpUser = getUser(patent.getFirstAuthorWorkId());
                workId = tmpUser != null ? tmpUser.getTutorWorkId() : "";
                if(!workId.equals("")){
                    resultSql += preStuSql+workId+"\" and `year` ="+year+";";
                    resultSql += preTutorSql+patent.getSecondAuthorWorkId()+"\" and `year` ="+year+";";
                }else{
                    resultSql += preTutorSql+patent.getSecondAuthorWorkId()+"\" and `year` ="+year+";";
                }


            }else if(patent.getFirstAuthorType()!= null &&patent.getFirstAuthorType().equals("teacher") &&patent.getSecondAuthorType() == null){
                //一作导师 二作空
                resultSql += preTutorSql+patent.getFirstAuthorWorkId()+"\" and `year` ="+year+";";
            }


        }

        resultSql = resultSql.replace("+","-");
        resultSql=resultSql.substring(0,resultSql.length()-1);
       // authorStatisticsMapper.doSql(resultSql);

        resultSql = resultSql.replace("doc_statistics","doc_statistics_year");
        authorStatisticsMapper.doSql(resultSql);
        return 0;
    }

    //增加基金
    public int addFundCount(List<Fund> fundList){
        if(fundList.size() == 0) return -1;
        String resultSql = "";
        String preSqlSum="update doc_statistics set `fund_sum`=`fund_sum`+1 where `work_id`=\"";

        String insertSql="";
        int year = -1;
        User tmpUser = null;

        for(Fund fund:fundList){
            year = fund.getProjectYear();
            tmpUser = getUser(fund.getPersonWorkId());
            insertSql+=getInsertTutorSql(tmpUser,year);
            switch (fund.getMetricMatch()){
                case "bc66c15317fc45c09103230de7f7120e":
                    resultSql+="update doc_statistics set `nation_focus`=`nation_focus`+1 where `work_id`=\""+fund.getPersonWorkId()+"\" and `year` ="+year+";";
                    break;
                case "703386e1860648a6a397a6a24503bdf6":
                    resultSql+="update doc_statistics set `nsfc_zdyf`=`nsfc_zdyf`+1 where `work_id`=\""+fund.getPersonWorkId()+"\" and `year` ="+year+";";
                    break;
                case "2163f1d53f5d48f1bee577df1babeac2":
                    resultSql+="update doc_statistics set `nation_instrument`=`nation_instrument`+1 where `work_id`=\""+fund.getPersonWorkId()+"\" and `year` ="+year+";";
                    break;
                case "b8d6b2233c1b4ccaa46e19f405d474cc":
                    resultSql+="update doc_statistics set `nsfc_kxzx`=`nsfc_kxzx`+1 where `work_id`=\""+fund.getPersonWorkId()+"\" and `year` ="+year+";";
                    break;
                case "9eddd16e476a459d81dd2735e21be83b":
                    resultSql+="update doc_statistics set `nsfc_zdaxm`=`nsfc_zdaxm`+1 where `work_id`=\""+fund.getPersonWorkId()+"\" and `year` ="+year+";";
                    break;
                case "9d8689193b584fd1903fe9abcf42877d":
                    resultSql+="update doc_statistics set `nsfc_zdianxm`=`nsfc_zdianxm`+1 where `work_id`=\""+fund.getPersonWorkId()+"\" and `year` ="+year+";";
                    break;
                case "a7454d55cfa84120ad404a83049c4476":
                    resultSql+="update doc_statistics set `nsfc_msxm`=`nsfc_msxm`+1 where `work_id`=\""+fund.getPersonWorkId()+"\" and `year` ="+year+";";
                    break;
                case "0a541d33521f415a870cbbfe88aaa758":
                    resultSql+="update doc_statistics set `nsfc_qnxm`=`nsfc_qnxm`+1 where `work_id`=\""+fund.getPersonWorkId()+"\" and `year` ="+year+";";
                    break;
                case "a7b4fed10c524924b0d7b5c5e3e3fefa":
                    resultSql+="update doc_statistics set `nssfc_zdaxm`=`nssfc_zdaxm`+1 where `work_id`=\""+fund.getPersonWorkId()+"\" and `year` ="+year+";";
                    break;
                case "06c377960ec744f2a58b3e320dbea5c6":
                    resultSql+="update doc_statistics set `nssfc_zdianxm`=`nssfc_zdianxm`+1 where `work_id`=\""+fund.getPersonWorkId()+"\" and `year` ="+year+";";
                    break;
                case "fcff48a07dda4c73bf3ed525be5115cd":
                    resultSql+="update doc_statistics set `nssfc_ybxm`=`nssfc_ybxm`+1 where `work_id`=\""+fund.getPersonWorkId()+"\" and `year` ="+year+";";
                    break;
                case "4d0c8149b3064db69d7b2063bae7c709":
                    resultSql+="update doc_statistics set `nssfc_qnxm`=`nssfc_qnxm`+1 where `work_id`=\""+fund.getPersonWorkId()+"\" and `year` ="+year+";";
                    break;
            }
            resultSql+=preSqlSum+fund.getPersonWorkId()+"\" and `year` ="+year+"; ";
        }
        //authorStatisticsMapper.doSql(resultSql);
        authorStatisticsMapper.doSql(insertSql);

        resultSql = resultSql.replace("doc_statistics","doc_statistics_year");
        authorStatisticsMapper.doSql(resultSql);
        return 0;
    }

    //删除基金
    public int deleteFundCount(List<Fund> fundList){
        if(fundList.size() == 0) return -1;
        String resultSql = "";
        String preSqlSum="update doc_statistics set `fund_sum`=`fund_sum`+1 where `work_id`=\"";

        String insertSql="";
        int year = -1;
        User tmpUser = null;

        for(Fund fund:fundList){
            year = fund.getProjectYear();
            tmpUser = getUser(fund.getPersonWorkId());
            insertSql+=getInsertTutorSql(tmpUser,year);
            switch (fund.getMetricMatch()){
                case "bc66c15317fc45c09103230de7f7120e":
                    resultSql+="update doc_statistics set `nation_focus`=`nation_focus`+1 where `work_id`=\""+fund.getPersonWorkId()+"\" and `year` ="+year+";";
                    break;
                case "703386e1860648a6a397a6a24503bdf6":
                    resultSql+="update doc_statistics set `nsfc_zdyf`=`nsfc_zdyf`+1 where `work_id`=\""+fund.getPersonWorkId()+"\" and `year` ="+year+";";
                    break;
                case "2163f1d53f5d48f1bee577df1babeac2":
                    resultSql+="update doc_statistics set `nation_instrument`=`nation_instrument`+1 where `work_id`=\""+fund.getPersonWorkId()+"\" and `year` ="+year+";";
                    break;
                case "b8d6b2233c1b4ccaa46e19f405d474cc":
                    resultSql+="update doc_statistics set `nsfc_kxzx`=`nsfc_kxzx`+1 where `work_id`=\""+fund.getPersonWorkId()+"\" and `year` ="+year+";";
                    break;
                case "9eddd16e476a459d81dd2735e21be83b":
                    resultSql+="update doc_statistics set `nsfc_zdaxm`=`nsfc_zdaxm`+1 where `work_id`=\""+fund.getPersonWorkId()+"\" and `year` ="+year+";";
                    break;
                case "9d8689193b584fd1903fe9abcf42877d":
                    resultSql+="update doc_statistics set `nsfc_zdianxm`=`nsfc_zdianxm`+1 where `work_id`=\""+fund.getPersonWorkId()+"\" and `year` ="+year+";";
                    break;
                case "a7454d55cfa84120ad404a83049c4476":
                    resultSql+="update doc_statistics set `nsfc_msxm`=`nsfc_msxm`+1 where `work_id`=\""+fund.getPersonWorkId()+"\" and `year` ="+year+";";
                    break;
                case "0a541d33521f415a870cbbfe88aaa758":
                    resultSql+="update doc_statistics set `nsfc_qnxm`=`nsfc_qnxm`+1 where `work_id`=\""+fund.getPersonWorkId()+"\" and `year` ="+year+";";
                    break;
                case "a7b4fed10c524924b0d7b5c5e3e3fefa":
                    resultSql+="update doc_statistics set `nssfc_zdaxm`=`nssfc_zdaxm`+1 where `work_id`=\""+fund.getPersonWorkId()+"\" and `year` ="+year+";";
                    break;
                case "06c377960ec744f2a58b3e320dbea5c6":
                    resultSql+="update doc_statistics set `nssfc_zdianxm`=`nssfc_zdianxm`+1 where `work_id`=\""+fund.getPersonWorkId()+"\" and `year` ="+year+";";
                    break;
                case "fcff48a07dda4c73bf3ed525be5115cd":
                    resultSql+="update doc_statistics set `nssfc_ybxm`=`nssfc_ybxm`+1 where `work_id`=\""+fund.getPersonWorkId()+"\" and `year` ="+year+";";
                    break;
                case "4d0c8149b3064db69d7b2063bae7c709":
                    resultSql+="update doc_statistics set `nssfc_qnxm`=`nssfc_qnxm`+1 where `work_id`=\""+fund.getPersonWorkId()+"\" and `year` ="+year+";";
                    break;
            }
            resultSql+=preSqlSum+fund.getPersonWorkId()+"\"and `year` ="+year+"; ";
        }

        resultSql = resultSql.replace("+","-");

        resultSql = resultSql.replace("doc_statistics","doc_statistics_year");
        authorStatisticsMapper.doSql(resultSql);
        return 0;
    }



    private User getUser(String workId){
        if(userList.size() ==0)
            userList = userService.getAllUsers();
        for(int i=0; i<userList.size();i++){
            if(userList.get(i).getWorkId()!= null &&userList.get(i).getWorkId().equals(workId)){
                return userList.get(i);
            }
        }
        return null;
    }

    private String getInsertTutorSql(User user,int year){

        Date date = new Date();
        DateFormat format = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
        String str = format.format(date);

        if(user == null) return "";
        String preSql="Insert into doc_statistics_year (`id`,`real_name`,`work_id`,`school`,`major`,`year`,`is_master`,`is_doctor`" +
                "        ,`remarks`,`create_user_id`,`create_date`,`modify_date`,`modify_user_id`) select ";
        preSql+="\""+user.getId()+"\",";
        preSql+="\""+user.getRealName()+"\",";
        preSql+="\""+user.getWorkId()+"\",";
        preSql+="\""+user.getSchool()+"\",";
        preSql+="\""+user.getMajor()+"\",";
        preSql+= year+",";
        preSql+=user.getIsMaster()+",";
        preSql+=user.getIsDoctor()+",";
        preSql+="\""+user.getRemarks()+"\",";
        preSql+="\""+user.getCreateUserId()+"\",";
        preSql+="\""+str+"\",";
        preSql+="\""+str+"\",";
        preSql+="\""+user.getModifyUserId()+"\"";
        preSql+=" from dual WHERE NOT EXISTS (select * from doc_statistics_year where `work_id`=";
        preSql+="\""+user.getWorkId()+"\"";
        preSql+=" and `year`= ";
        preSql+= year +");";
        return preSql;
    }

    private  String getPaperTypeSql(Paper paper,String workId,int type,int year){
        String preSqlTutor="";
        String preSqlTutorSum="update doc_statistics set `tutor_paper_sum`=`tutor_paper_sum`+1 where `year`="+year+" and `work_id`=\"";

        String preSqlStu="";
        String preSqlStuSum="update doc_statistics set `stu_paper_sum`=`stu_paper_sum`+1 where `year`="+year+" and  `work_id`=\"";

        String returnSql="";
        if(paper.getJournalDivision() != null) {
            switch (paper.getJournalDivision()) {
                case "Q1":
                    preSqlTutor = "update doc_statistics set `tutor_q1`=`tutor_q1`+1 where `year`="+year+" and `work_id`=\"";
                    preSqlStu = "update doc_statistics set `stu_q1`=`stu_q1`+1 where `year`="+year+" and `work_id`=\"";
                    break;
                case "Q2":
                    preSqlTutor = "update doc_statistics set `tutor_q2`=`tutor_q2`+1 where `year`="+year+" and `work_id`=\"";
                    preSqlStu = "update doc_statistics set `stu_q2`=`stu_q2`+1 where `year`="+year+" and  `work_id`=\"";
                    break;
                case "Q3":
                    preSqlTutor = "update doc_statistics set `tutor_q3`=`tutor_q3`+1 where `year`="+year+" and  `work_id`=\"";
                    preSqlStu = "update doc_statistics set `stu_q3`=`stu_q3`+1 where `year`="+year+" and `work_id`=\"";
                    break;
                case "Q4":
                    preSqlTutor = "update doc_statistics set `tutor_q4`=`tutor_q4`+1 where `year`="+year+" and `work_id`=\"";
                    preSqlStu = "update doc_statistics set `stu_q4`=`stu_q4`+1 where `year`="+year+" and `work_id`=\"";
                    break;
                default:
                    break;
            }
        }else{
            preSqlTutor = "update doc_statistics set `tutor_other`=`tutor_other`+1 where `year`="+year+" and `work_id`=\"";
            preSqlStu = "update doc_statistics set `stu_other`=`stu_other`+1 where `year`="+year+" and `work_id`=\"";
        }

        switch (type){
            case 1: //学生老师 都+1
                returnSql+= preSqlTutor+workId+"\";";
                returnSql+= preSqlTutorSum+workId+"\";";

                returnSql+=preSqlStu+workId+"\";";
                returnSql+=preSqlStuSum+workId+"\";";
                break;
            case 2://学生+1
                returnSql+=preSqlStu+workId+"\";";
                returnSql+=preSqlStuSum+workId+"\";";
                break;
            case 3://老师+1
                returnSql+= preSqlTutor+workId+"\";";
                returnSql+= preSqlTutorSum+workId+"\";";
                break;

         }

        return returnSql;
    }

    public List<AuthorStatistics> getAuthorStatisticsBySchool(AuthorStatistics authorStatistics){
        List<AuthorStatistics> resultList = authorStatisticsMapper.getAuthorListBySchool(authorStatistics);
        for(AuthorStatistics tmp:resultList){
            if(tmp.getTotalNum()>0){
            tmp.setTutorAverage(1.0*tmp.getTutorPaperSum()/tmp.getTotalNum());
            tmp.setStuAverage(1.0*tmp.getStuPaperSum()/tmp.getTotalNum());
            tmp.setTutorPatentAverage(1.0*tmp.getTutorPatent()/tmp.getTotalNum());
            tmp.setStuPatentAverage(1.0*tmp.getStuPatent()/tmp.getTotalNum());
            }else{
                tmp.setTutorAverage(0);
                tmp.setStuAverage(0);
                tmp.setTutorPatentAverage(0);
                tmp.setStuPatentAverage(0);
            }
        }
        return resultList;
    }

    public List<AuthorStatistics> getAuthorStatisticsByMajor(AuthorStatistics authorStatistics){
        List<AuthorStatistics> resultList = authorStatisticsMapper.getAuthorListByMajor(authorStatistics);

        for(AuthorStatistics tmp:resultList){
            if(tmp.getTotalNum()>0){
                tmp.setTutorAverage(1.0*tmp.getTutorPaperSum()/tmp.getTotalNum());
                tmp.setStuAverage(1.0*tmp.getStuPaperSum()/tmp.getTotalNum());
                tmp.setTutorPatentAverage(1.0*tmp.getTutorPatent()/tmp.getTotalNum());
                tmp.setStuPatentAverage(1.0*tmp.getStuPatent()/tmp.getTotalNum());
            }else{
                tmp.setTutorAverage(0);
                tmp.setStuAverage(0);
                tmp.setTutorPatentAverage(0);
                tmp.setStuPatentAverage(0);
            }
        }
        return resultList;
    }

    public int getAuthorStatisticsCountBySchool(AuthorStatistics authorStatistics){
        return authorStatisticsMapper.selectSchoolListCount(authorStatistics);
    }
    public int getAuthorStatisticsCountByMajor(AuthorStatistics authorStatistics){
        return authorStatisticsMapper.selectMajorListCount(authorStatistics);
    }
}