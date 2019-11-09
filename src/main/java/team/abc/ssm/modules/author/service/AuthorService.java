package team.abc.ssm.modules.author.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import team.abc.ssm.common.web.SysDocType;
import team.abc.ssm.modules.author.dao.AuthorMapper;
import team.abc.ssm.modules.author.dao.AuthorStatisticsMapper;
import team.abc.ssm.modules.author.entity.Author;
import team.abc.ssm.modules.author.entity.AuthorStatistics;
import team.abc.ssm.modules.doc.dao.PaperDao;
import team.abc.ssm.modules.doc.entity.Fund;
import team.abc.ssm.modules.doc.entity.Paper;
import team.abc.ssm.modules.doc.entity.Patent;
import team.abc.ssm.modules.patent.dao.DocPatentMapper;
import team.abc.ssm.modules.patent.entity.DocPatent;
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
public class AuthorService {

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

    public int getAuthorListCount(Author author) {
        return authorMapper.getAuthorCount(author);
    }

    /**
     * @author zm 条件查询返回相应的List<Author>，若空则返回空的arrayList
     * @date 2019/4/22
     * @param author
     * @return java.util.List<team.abc.ssm.modules.author.entity.Author>
     * @Description
     * version1：20190422
     * 统计每个作者的论文+专利数量
     *      1.1 导师一作，二作不为该导师的学生，计算在导师名下
     *      1.2 导师一作，二作是该导师学生，属于导师和学生
     *      1.3 学生一作，计算在其导师和该学生名下
     *
     * version2: 20190804
     * 取消单个作者的论文+专利数量统计
     */
    public List<Author> getAuthorList(Author author) {
        /*查找出所有条件下的作者列表*/
        List<Author> authors = authorMapper.getAuthorListByPage(author);
        return authors;
    }

    public List<String> getSubList() {
        return authorMapper.getFirstSub();
    }

    public Author getAuthor(String authorId) {
        System.out.println("获取author");
        return authorMapper.selectByPrimaryKey(authorId);
    }

    /**
     * @param
     * @return void
     * @Description 批量插入字典项
     * @author zm
     * @date 9:13 2019/5/9
     */
    public void batchInsertDict(){
        List<Dict> dictList = new ArrayList<>();

        List<String> firstSubList = authorMapper.getFirstSub();

        for (String firstSub : firstSubList){
            Dict tmpDict = new Dict();
            tmpDict.setTypeId(String.valueOf(UUID.randomUUID()));

            tmpDict.setNameCn(firstSub);

            dictList.add(tmpDict);
        }

        System.out.println("打印dicList: "+dictList);

        int resInsert = authorMapper.batchInsert(dictList);
        System.out.println("一级学科插入项："+resInsert);
    }


    /**
     * 统计1.0
     *  @author wh
     *  @date 9:13 2019/9/10
     *
     */
    //获取老师统计列表
//    public List<AuthorStatistics> getAuthorStatisticsList(AuthorStatistics authorStatistics){
//        //获取老师信息
//        List<AuthorStatistics>  preList = authorStatisticsMapper.getAuthorListByPage(authorStatistics);
//        List<AuthorStatistics> resultList = new ArrayList<>();
//
//        //遍历每个老师
//        for (int i = 0; i < preList.size(); i++) {
//            AuthorStatistics teacher = preList.get(i);
//            //获取所有该导师所有学生信息
//            teacher.setStuList(authorStatisticsMapper.getStudentIdListByTeacherId(teacher.getWorkId()));
//
//            //获取论文数量信息
//            if(teacher.getStuList().size()>0){
//                Map params = new HashMap();
//
//                params.put("idlist",teacher.getStuList());
//                params.put("type","Q1");
//                teacher.setTutorQ1(authorStatisticsMapper.getPaperTeacherCount(teacher.getWorkId(),"Q1")+authorStatisticsMapper.getPaperBothStuCount(params));
//                teacher.setStuQ1(getStuPaperNum(teacher.getWorkId(),teacher.getStuList(),"Q1"));
//
//                params.remove("type");
//                params.put("type","Q2");
//                teacher.setTutorQ2(authorStatisticsMapper.getPaperTeacherCount(teacher.getWorkId(),"Q2")+authorStatisticsMapper.getPaperBothStuCount(params));
//                teacher.setStuQ2(getStuPaperNum(teacher.getWorkId(),teacher.getStuList(),"Q2"));
//
//                params.remove("type");
//                params.put("type","Q3");
//                teacher.setTutorQ3(authorStatisticsMapper.getPaperTeacherCount(teacher.getWorkId(),"Q3")+authorStatisticsMapper.getPaperBothStuCount(params));
//                teacher.setStuQ3(getStuPaperNum(teacher.getWorkId(),teacher.getStuList(),"Q3"));
//
//                params.remove("type");
//                params.put("type","Q4");
//                teacher.setTutorQ4(authorStatisticsMapper.getPaperTeacherCount(teacher.getWorkId(),"Q4")+authorStatisticsMapper.getPaperBothStuCount(params));
//                teacher.setStuQ4(getStuPaperNum(teacher.getWorkId(),teacher.getStuList(),"Q4"));
//
//
//                teacher.setStuPaperSum(teacher.getStuQ1()+teacher.getStuQ2()+teacher.getStuQ3()+teacher.getStuQ4());
//                teacher.setTutorPaperSum(teacher.getTutorQ1()+teacher.getTutorQ2()+teacher.getTutorQ3()+teacher.getTutorQ4());
//            }else{
//                teacher.setTutorQ1(authorStatisticsMapper.getPaperTeacherCount(teacher.getWorkId(),"Q1"));
//                teacher.setTutorQ2(authorStatisticsMapper.getPaperTeacherCount(teacher.getWorkId(),"Q2"));
//                teacher.setTutorQ3(authorStatisticsMapper.getPaperTeacherCount(teacher.getWorkId(),"Q3"));
//                teacher.setTutorQ4(authorStatisticsMapper.getPaperTeacherCount(teacher.getWorkId(),"Q4"));
//                teacher.setTutorPaperSum(teacher.getTutorQ1()+teacher.getTutorQ2()+teacher.getTutorQ3()+teacher.getTutorQ4());
//
//                teacher.setStuQ1(0);
//                teacher.setStuQ2(0);
//                teacher.setStuQ3(0);
//                teacher.setStuQ4(0);
//                teacher.setStuPaperSum(0);
//            }
//
//
//            //获取专利数量信息
//            if(teacher.getStuList().size()>0) {
//                teacher.setTutorPatent(authorStatisticsMapper.getPatentTeacherCount(teacher.getWorkId())+authorStatisticsMapper.getPatentStuBothCount(teacher.getStuList()));
//                teacher.setStuPatent(getStuPatentNum(teacher.getWorkId(),teacher.getStuList()));
//            }else{
//                teacher.setTutorPatent(authorStatisticsMapper.getPatentTeacherCount(teacher.getWorkId()));
//                teacher.setStuPatent(0);
//            }
//            //获取老师基金信息 TODO
//            teacher.setNationFocus(authorStatisticsMapper.getFundCount(teacher.getWorkId(),"bc66c15317fc45c09103230de7f7120e"));
//            teacher.setNsfcZDYF(authorStatisticsMapper.getFundCount(teacher.getWorkId(),"703386e1860648a6a397a6a24503bdf6"));
//            teacher.setNationInstrument(authorStatisticsMapper.getFundCount(teacher.getWorkId(),"2163f1d53f5d48f1bee577df1babeac2"));
//            teacher.setNsfcKXZX(authorStatisticsMapper.getFundCount(teacher.getWorkId(),"b8d6b2233c1b4ccaa46e19f405d474cc"));
//            teacher.setNsfcZDAXM(authorStatisticsMapper.getFundCount(teacher.getWorkId(),"9eddd16e476a459d81dd2735e21be83b"));
//            teacher.setNsfcZDIANXM(authorStatisticsMapper.getFundCount(teacher.getWorkId(),"9d8689193b584fd1903fe9abcf42877d"));
//            teacher.setNsfcMSXM(authorStatisticsMapper.getFundCount(teacher.getWorkId(),"a7454d55cfa84120ad404a83049c4476"));
//            teacher.setNsfcQNXM(authorStatisticsMapper.getFundCount(teacher.getWorkId(),"0a541d33521f415a870cbbfe88aaa758"));
//            teacher.setNssfcZDAXM(authorStatisticsMapper.getFundCount(teacher.getWorkId(),"a7b4fed10c524924b0d7b5c5e3e3fefa"));
//            teacher.setNssfcZDIANXM(authorStatisticsMapper.getFundCount(teacher.getWorkId(),"06c377960ec744f2a58b3e320dbea5c6"));
//            teacher.setNssfcYBXM(authorStatisticsMapper.getFundCount(teacher.getWorkId(),"fcff48a07dda4c73bf3ed525be5115cd"));
//            teacher.setNssfcQNXM(authorStatisticsMapper.getFundCount(teacher.getWorkId(),"4d0c8149b3064db69d7b2063bae7c709"));
//            teacher.setFundSum(teacher.getNationFocus()+teacher.getNsfcZDYF()+teacher.getNationInstrument()+teacher.getNsfcKXZX()+teacher.getNsfcZDAXM()
//            +teacher.getNsfcZDIANXM()+teacher.getNsfcMSXM()+teacher.getNsfcQNXM()+teacher.getNssfcZDAXM()+teacher.getNssfcYBXM()+teacher.getNssfcQNXM());
//            resultList.add(teacher);
//            System.out.println("导出第"+preList.indexOf(teacher)+"个导师");
//        }
//
//        return resultList;
//    }
//
//    public int getAuthorStatisticsNum(AuthorStatistics authorStatistics){
//        return  authorStatisticsMapper.getAuthorCount(authorStatistics);
//    }
//
//    int getStuPaperNum(String teacherId, List<String> stuList,String type){
//        int result;
//        result = 0;
//        Map params = new HashMap();
//
//        params.put("idlist",stuList);
//        params.put("type",type);
//
//        //一二作都是学生
//        result +=authorStatisticsMapper.getPaperBothStuCount(params);
//
//        //一作学生二作导师
//        result += authorStatisticsMapper.getPaperStuFirstCount(params);
//
//
//        //一作导师 二作学生
//        params.put("teacherId",teacherId);
//        result += authorStatisticsMapper.getPaperTeaFirstCount(params);
//
//        return result;
//    }
//
//    int getStuPatentNum(String teacherId,List<String> stuList){
//        int result;
//        result = 0;
//
//        Map params = new HashMap();
//        params.put("idlist",stuList);
//        params.put("teacherId",teacherId);
//        //一二作都是学生
//        result += authorStatisticsMapper.getPatentStuBothCount(stuList);
//
//        //一作学生二作导师
//        result += authorStatisticsMapper.getPatentStuFirstCount(stuList);
//
//        //一作导师 二作学生
//        result += authorStatisticsMapper.getPatentTeaFirstCount(params);
//
//        return result;
//    }


    /**
     * 统计2.0
     *  @author wh
     *  @date 9:13 2019/9/19
     *
     */
    public List<AuthorStatistics> getAuthorStatisticsList(AuthorStatistics authorStatistics){

        return authorStatisticsMapper.getAuthorListByPage(authorStatistics);
    }

    public int getAuthorStatisticsNum(AuthorStatistics authorStatistics){
        return  authorStatisticsMapper.getAuthorCount(authorStatistics);
    }


    //新增论文
    public int addPaperCount(List<Paper> paperList){
        if(paperList.size() ==0 ) return -1;
        if(userList.size() == 0)
            userList = userService.getAllUsers();

        String workId="";
        String resultSql = "";
        String insertSql="";

        int year = -1;
        Calendar c = Calendar.getInstance();
        User tmpUser = null;

        for(Paper paper :paperList){
            workId="";
            c.setTime(paper.getPublishDate());
            year = c.get(Calendar.YEAR);

            if((paper.getFirstAuthorType().equals("student")&&paper.getSecondAuthorType() == null)||(paper.getFirstAuthorType().equals("student") && paper.getSecondAuthorType().equals("student")) ){
                //第一作者学生 第二作者学生(或空)   第一作者学生+1 老师+1
                tmpUser = getUser(paper.getFirstAuthorId());
                workId = tmpUser != null ? tmpUser.getTutorWorkId() : "";

                if(!workId.equals(""))
                    resultSql += getPaperTypeSql(paper,workId,1);
                    insertSql += getInsertTutorSql(tmpUser,year);

            }else if(paper.getFirstAuthorType()!= null &&paper.getSecondAuthorType()!= null&&paper.getFirstAuthorType().equals("teacher")&& paper.getSecondAuthorType().equals("student")){
                //第一作者老师 第二作者学生
                tmpUser = getUser(paper.getSecondAuthorId());
                workId = tmpUser != null ? tmpUser.getTutorWorkId() : "";

                if(!workId.equals("")) {
                    if (workId.equals(paper.getFirstAuthorId())) {
                        //学生在老师名下
                        resultSql += getPaperTypeSql(paper, paper.getFirstAuthorId(), 1);
                        insertSql += getInsertTutorSql(tmpUser,year);

                    } else {
                        //学生不在老师名下
                        resultSql += getPaperTypeSql(paper, paper.getFirstAuthorId(), 3);
                    }
                }else{
                    resultSql += getPaperTypeSql(paper, paper.getFirstAuthorId(), 3);
                    tmpUser = getUser(paper.getFirstAuthorId());
                    insertSql += getInsertTutorSql(tmpUser,year);
                }
            }else if(paper.getFirstAuthorType()!= null &&paper.getSecondAuthorType()!= null&&paper.getFirstAuthorType().equals("student") &&paper.getSecondAuthorType().equals("teacher")){
                //第一作者学生  第二作者老师

                tmpUser = getUser(paper.getFirstAuthorId());
                workId = tmpUser != null ? tmpUser.getTutorWorkId() : "";

                if(!workId.equals("")){
                    resultSql += getPaperTypeSql(paper, workId, 2);
                    insertSql += getInsertTutorSql(tmpUser,year);
                    resultSql += getPaperTypeSql(paper, paper.getSecondAuthorId(), 3);

                    tmpUser = getUser(paper.getSecondAuthorId());
                    insertSql += getInsertTutorSql(tmpUser,year);
                }else{
                    resultSql += getPaperTypeSql(paper, paper.getSecondAuthorId(), 3);

                    tmpUser = getUser(paper.getSecondAuthorId());
                    insertSql += getInsertTutorSql(tmpUser,year);
                }


            }else if(paper.getFirstAuthorType().equals("teacher") &&paper.getSecondAuthorType() == null){
                //一作导师 二作空
                resultSql += getPaperTypeSql(paper,paper.getFirstAuthorId(),3);

                tmpUser = getUser(paper.getFirstAuthorId());
                insertSql += getInsertTutorSql(tmpUser,year);
            }

        }
        resultSql = resultSql.substring(0,resultSql.length()-1);
        insertSql = insertSql.substring(0,insertSql.length()-1);
        authorStatisticsMapper.doSql(resultSql);
        authorStatisticsMapper.doSql(insertSql);

        resultSql = resultSql.replace("doc_statistics","doc_statistics_year");
        authorStatisticsMapper.doSql(resultSql);
        return 0;
    }
    //删除论文
    public int deletePaperCount(List<Paper> paperList){
        if(paperList.size() ==0 ) return -1;
        if(userList.size() == 0)
            userList = userService.getAllUsers();

        String workId="";
        String resultSql = "";
        User tmpUser;

        for(Paper paper :paperList){
            workId="";
            if((paper.getFirstAuthorType().equals("student")&&paper.getSecondAuthorType() == null)||(paper.getFirstAuthorType().equals("student") && paper.getSecondAuthorType().equals("student")) ){
                //第一作者学生 第二作者学生(或空)   第一作者学生+1 老师+1
                tmpUser = getUser(paper.getFirstAuthorId());
                workId = tmpUser != null ? tmpUser.getTutorWorkId() : "";
                if(!workId.equals(""))
                    resultSql +=getPaperTypeSql(paper,workId,1);

            }else if(paper.getFirstAuthorType()!= null &&paper.getSecondAuthorType()!= null&&paper.getFirstAuthorType().equals("teacher")&& paper.getSecondAuthorType().equals("student")){
                //第一作者老师 第二作者学生
                tmpUser = getUser(paper.getSecondAuthorId());
                workId = tmpUser != null ? tmpUser.getTutorWorkId() : "";
                if(!workId.equals("")) {
                    if (workId.equals(paper.getFirstAuthorId())) {
                        //学生在老师名下
                        resultSql += getPaperTypeSql(paper, paper.getFirstAuthorId(), 1);
                    } else {
                        //学生不在老师名下
                        resultSql += getPaperTypeSql(paper, paper.getFirstAuthorId(), 3);
                    }
                }else{
                    resultSql += getPaperTypeSql(paper, paper.getFirstAuthorId(), 3);
                }
            }else if(paper.getFirstAuthorType()!= null &&paper.getSecondAuthorType()!= null&&paper.getFirstAuthorType().equals("student") &&paper.getSecondAuthorType().equals("teacher")){
                //第一作者学生  第二作者老师
                tmpUser = getUser(paper.getFirstAuthorId());
                workId = tmpUser != null ? tmpUser.getTutorWorkId() : "";
                if(!workId.equals("")){
                    resultSql += getPaperTypeSql(paper, workId, 2);
                    resultSql += getPaperTypeSql(paper, paper.getSecondAuthorId(), 3);
                }else{
                    resultSql += getPaperTypeSql(paper, paper.getSecondAuthorId(), 3);
                }


            }else if(paper.getFirstAuthorType().equals("teacher") &&paper.getSecondAuthorType() == null){
                //一作导师 二作空
                resultSql += getPaperTypeSql(paper,paper.getFirstAuthorId(),3);
            }

        }

        resultSql = resultSql.replace("+","-");
        resultSql=resultSql.substring(0,resultSql.length()-1);
        authorStatisticsMapper.doSql(resultSql);

        resultSql = resultSql.replace("doc_statistics","doc_statistics_year");
        authorStatisticsMapper.doSql(resultSql);
        return 0;
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
        int year = -1;
        Calendar c = Calendar.getInstance();
        User tmpUser = null;

        for(DocPatent patent:patentList){
            workId="";
            c.setTime(patent.getPatentAuthorizationDate());
            year = c.get(Calendar.YEAR);

            if((patent.getFirstAuthorType().equals("student")&&patent.getSecondAuthorType() == null)||(patent.getFirstAuthorType().equals("student") && patent.getSecondAuthorType().equals("student")) ){
                //第一作者学生 第二作者学生(或空)   第一作者学生+1 老师+1
                tmpUser = getUser(patent.getFirstAuthorWorkId());
                workId = tmpUser != null ? tmpUser.getTutorWorkId() : "";
                if(!workId.equals("")){
                    resultSql+=preTutorSql+workId+"\";";
                    resultSql+=preStuSql+workId+"\";";
                    insertSql += getInsertTutorSql(tmpUser,year);
                }
            }else if(patent.getFirstAuthorType()!= null && patent.getSecondAuthorType()!=null&&patent.getFirstAuthorType().equals("teacher")&& patent.getSecondAuthorType().equals("student")){
                //第一作者老师 第二作者学生
                tmpUser = getUser(patent.getSecondAuthorWorkId());
                workId = tmpUser != null ? tmpUser.getTutorWorkId() : "";
                if(!workId.equals("")) {
                    if (workId.equals(patent.getFirstAuthorWorkId())) {
                        //学生在老师名下
                        resultSql+=preTutorSql+patent.getFirstAuthorWorkId()+"\";";
                        resultSql+=preStuSql+patent.getFirstAuthorWorkId()+"\";";
                        insertSql += getInsertTutorSql(tmpUser,year);

                        tmpUser = getUser(patent.getFirstAuthorWorkId());
                        insertSql += getInsertTutorSql(tmpUser,year);
                    } else {
                        //学生不在老师名下
                        resultSql+=preTutorSql+patent.getFirstAuthorWorkId()+"\";";

                        tmpUser = getUser(patent.getFirstAuthorWorkId());
                        insertSql += getInsertTutorSql(tmpUser,year);
                    }
                }else{
                    tmpUser = getUser(patent.getFirstAuthorWorkId());
                    insertSql += getInsertTutorSql(tmpUser,year);
                    resultSql+=preTutorSql+patent.getFirstAuthorWorkId()+"\";";
                }
            }else if(patent.getFirstAuthorType()!= null && patent.getSecondAuthorType()!=null&&patent.getFirstAuthorType().equals("student") &&patent.getSecondAuthorType().equals("teacher")){
                //第一作者学生  第二作者老师
                tmpUser = getUser(patent.getFirstAuthorWorkId());
                workId = tmpUser != null ? tmpUser.getTutorWorkId() : "";

                if(!workId.equals("")){
                    resultSql += preStuSql+workId+"\";";
                    resultSql += preTutorSql+patent.getSecondAuthorWorkId()+"\";";
                    insertSql += getInsertTutorSql(tmpUser,year);
                }else{
                    tmpUser = getUser(patent.getSecondAuthorWorkId());
                    insertSql += getInsertTutorSql(tmpUser,year);
                    resultSql += preTutorSql+patent.getSecondAuthorWorkId()+"\";";
                }


            }else if(patent.getFirstAuthorType()!= null &&patent.getFirstAuthorType().equals("teacher") &&patent.getSecondAuthorType() == null){
                //一作导师 二作空
                resultSql += preTutorSql+patent.getFirstAuthorWorkId()+"\";";
                tmpUser = getUser(patent.getFirstAuthorWorkId());
                insertSql += getInsertTutorSql(tmpUser,year);
            }


        }
        resultSql = resultSql.substring(0,resultSql.length()-1);
        insertSql = insertSql.substring(0,insertSql.length()-1);

        authorStatisticsMapper.doSql(resultSql);
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

        User tmpUser;
        for(DocPatent patent:patentList){
            workId="";
            if((patent.getFirstAuthorType().equals("student")&&patent.getSecondAuthorType() == null)||(patent.getFirstAuthorType().equals("student") && patent.getSecondAuthorType().equals("student")) ){
                //第一作者学生 第二作者学生(或空)   第一作者学生+1 老师+1
                tmpUser = getUser(patent.getFirstAuthorWorkId());
                workId = tmpUser != null ? tmpUser.getTutorWorkId() : "";
                if(!workId.equals("")){
                    resultSql+=preTutorSql+workId+"\";";
                    resultSql+=preStuSql+workId+"\";";
                }
            }else if(patent.getFirstAuthorType()!= null && patent.getSecondAuthorType()!=null&&patent.getFirstAuthorType().equals("teacher")&& patent.getSecondAuthorType().equals("student")){
                //第一作者老师 第二作者学生
                tmpUser = getUser(patent.getSecondAuthorWorkId());
                workId = tmpUser != null ? tmpUser.getTutorWorkId() : "";
                if(!workId.equals("")) {
                    if (workId.equals(patent.getFirstAuthorWorkId())) {
                        //学生在老师名下
                        resultSql+=preTutorSql+patent.getFirstAuthorWorkId()+"\";";
                        resultSql+=preStuSql+patent.getFirstAuthorWorkId()+"\";";
                    } else {
                        //学生不在老师名下
                        resultSql+=preTutorSql+patent.getFirstAuthorWorkId()+"\";";
                    }
                }else{
                    resultSql+=preTutorSql+patent.getFirstAuthorWorkId()+"\";";
                }
            }else if(patent.getFirstAuthorType()!= null && patent.getSecondAuthorType()!=null&&patent.getFirstAuthorType().equals("student") &&patent.getSecondAuthorType().equals("teacher")){
                //第一作者学生  第二作者老师

                tmpUser = getUser(patent.getFirstAuthorWorkId());
                workId = tmpUser != null ? tmpUser.getTutorWorkId() : "";
                if(!workId.equals("")){
                    resultSql += preStuSql+workId+"\";";
                    resultSql += preTutorSql+patent.getSecondAuthorWorkId()+"\";";
                }else{
                    resultSql += preTutorSql+patent.getSecondAuthorWorkId()+"\";";
                }


            }else if(patent.getFirstAuthorType()!= null &&patent.getFirstAuthorType().equals("teacher") &&patent.getSecondAuthorType() == null){
                //一作导师 二作空
                resultSql += preTutorSql+patent.getFirstAuthorWorkId()+"\";";
            }


        }

        resultSql = resultSql.replace("+","-");
        resultSql=resultSql.substring(0,resultSql.length()-1);
        authorStatisticsMapper.doSql(resultSql);

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
                    resultSql+="update doc_statistics set `nation_focus`=`nation_focus`+1 where `work_id`=\""+fund.getPersonWorkId()+"\";";
                    break;
                case "703386e1860648a6a397a6a24503bdf6":
                    resultSql+="update doc_statistics set `nsfc_zdyf`=`nsfc_zdyf`+1 where `work_id`=\""+fund.getPersonWorkId()+"\";";
                    break;
                case "2163f1d53f5d48f1bee577df1babeac2":
                    resultSql+="update doc_statistics set `nation_instrument`=`nation_instrument`+1 where `work_id`=\""+fund.getPersonWorkId()+"\";";
                    break;
                case "b8d6b2233c1b4ccaa46e19f405d474cc":
                    resultSql+="update doc_statistics set `nsfc_kxzx`=`nsfc_kxzx`+1 where `work_id`=\""+fund.getPersonWorkId()+"\";";
                    break;
                case "9eddd16e476a459d81dd2735e21be83b":
                    resultSql+="update doc_statistics set `nsfc_zdaxm`=`nsfc_zdaxm`+1 where `work_id`=\""+fund.getPersonWorkId()+"\";";
                    break;
                case "9d8689193b584fd1903fe9abcf42877d":
                    resultSql+="update doc_statistics set `nsfc_zdianxm`=`nsfc_zdianxm`+1 where `work_id`=\""+fund.getPersonWorkId()+"\";";
                    break;
                case "a7454d55cfa84120ad404a83049c4476":
                    resultSql+="update doc_statistics set `nsfc_msxm`=`nsfc_msxm`+1 where `work_id`=\""+fund.getPersonWorkId()+"\";";
                    break;
                case "0a541d33521f415a870cbbfe88aaa758":
                    resultSql+="update doc_statistics set `nsfc_qnxm`=`nsfc_qnxm`+1 where `work_id`=\""+fund.getPersonWorkId()+"\";";
                    break;
                case "a7b4fed10c524924b0d7b5c5e3e3fefa":
                    resultSql+="update doc_statistics set `nssfc_zdaxm`=`nssfc_zdaxm`+1 where `work_id`=\""+fund.getPersonWorkId()+"\";";
                    break;
                case "06c377960ec744f2a58b3e320dbea5c6":
                    resultSql+="update doc_statistics set `nssfc_zdianxm`=`nssfc_zdianxm`+1 where `work_id`=\""+fund.getPersonWorkId()+"\";";
                    break;
                case "fcff48a07dda4c73bf3ed525be5115cd":
                    resultSql+="update doc_statistics set `nssfc_ybxm`=`nssfc_ybxm`+1 where `work_id`=\""+fund.getPersonWorkId()+"\";";
                    break;
                case "4d0c8149b3064db69d7b2063bae7c709":
                    resultSql+="update doc_statistics set `nssfc_qnxm`=`nssfc_qnxm`+1 where `work_id`=\""+fund.getPersonWorkId()+"\";";
                    break;
            }
            resultSql+=preSqlSum+fund.getPersonWorkId()+"\";";
        }
        authorStatisticsMapper.doSql(resultSql);
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
        for(Fund fund:fundList){
            switch (fund.getMetricMatch()){
                case "bc66c15317fc45c09103230de7f7120e":
                    resultSql+="update doc_statistics set `nation_focus`=`nation_focus`+1 where `work_id`=\""+fund.getPersonWorkId()+"\";";
                    break;
                case "703386e1860648a6a397a6a24503bdf6":
                    resultSql+="update doc_statistics set `nsfc_zdyf`=`nsfc_zdyf`+1 where `work_id`=\""+fund.getPersonWorkId()+"\";";
                    break;
                case "2163f1d53f5d48f1bee577df1babeac2":
                    resultSql+="update doc_statistics set `nation_instrument`=`nation_instrument`+1 where `work_id`=\""+fund.getPersonWorkId()+"\";";
                    break;
                case "b8d6b2233c1b4ccaa46e19f405d474cc":
                    resultSql+="update doc_statistics set `nsfc_kxzx`=`nsfc_kxzx`+1 where `work_id`=\""+fund.getPersonWorkId()+"\";";
                    break;
                case "9eddd16e476a459d81dd2735e21be83b":
                    resultSql+="update doc_statistics set `nsfc_zdaxm`=`nsfc_zdaxm`+1 where `work_id`=\""+fund.getPersonWorkId()+"\";";
                    break;
                case "9d8689193b584fd1903fe9abcf42877d":
                    resultSql+="update doc_statistics set `nsfc_zdianxm`=`nsfc_zdianxm`+1 where `work_id`=\""+fund.getPersonWorkId()+"\";";
                    break;
                case "a7454d55cfa84120ad404a83049c4476":
                    resultSql+="update doc_statistics set `nsfc_msxm`=`nsfc_msxm`+1 where `work_id`=\""+fund.getPersonWorkId()+"\";";
                    break;
                case "0a541d33521f415a870cbbfe88aaa758":
                    resultSql+="update doc_statistics set `nsfc_qnxm`=`nsfc_qnxm`+1 where `work_id`=\""+fund.getPersonWorkId()+"\";";
                    break;
                case "a7b4fed10c524924b0d7b5c5e3e3fefa":
                    resultSql+="update doc_statistics set `nssfc_zdaxm`=`nssfc_zdaxm`+1 where `work_id`=\""+fund.getPersonWorkId()+"\";";
                    break;
                case "06c377960ec744f2a58b3e320dbea5c6":
                    resultSql+="update doc_statistics set `nssfc_zdianxm`=`nssfc_zdianxm`+1 where `work_id`=\""+fund.getPersonWorkId()+"\";";
                    break;
                case "fcff48a07dda4c73bf3ed525be5115cd":
                    resultSql+="update doc_statistics set `nssfc_ybxm`=`nssfc_ybxm`+1 where `work_id`=\""+fund.getPersonWorkId()+"\";";
                    break;
                case "4d0c8149b3064db69d7b2063bae7c709":
                    resultSql+="update doc_statistics set `nssfc_qnxm`=`nssfc_qnxm`+1 where `work_id`=\""+fund.getPersonWorkId()+"\";";
                    break;
            }
            resultSql+=preSqlSum+fund.getPersonWorkId()+"\";";
        }
        resultSql = resultSql.replace("+","-");
        authorStatisticsMapper.doSql(resultSql);

        resultSql = resultSql.replace("doc_statistics","doc_statistics_year");
        authorStatisticsMapper.doSql(resultSql);
        return 0;
    }



    private User getUser(String workId){
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

    private  String getPaperTypeSql(Paper paper,String workId,int type){
        String preSqlTutor="";
        String preSqlTutorSum="update doc_statistics set `tutor_paper_sum`=`tutor_paper_sum`+1 where `work_id`=\"";

        String preSqlStu="";
        String preSqlStuSum="update doc_statistics set `stu_paper_sum`=`stu_paper_sum`+1 where `work_id`=\"";

        String returnSql="";
        if(paper.getJournalDivision() != null) {
            switch (paper.getJournalDivision()) {
                case "Q1":
                    preSqlTutor = "update doc_statistics set `tutor_q1`=`tutor_q1`+1 where `work_id`=\"";
                    preSqlStu = "update doc_statistics set `stu_q1`=`stu_q1`+1 where `work_id`=\"";
                    break;
                case "Q2":
                    preSqlTutor = "update doc_statistics set `tutor_q2`=`tutor_q2`+1 where `work_id`=\"";
                    preSqlStu = "update doc_statistics set `stu_q2`=`stu_q2`+1 where `work_id`=\"";
                    break;
                case "Q3":
                    preSqlTutor = "update doc_statistics set `tutor_q3`=`tutor_q3`+1 where `work_id`=\"";
                    preSqlStu = "update doc_statistics set `stu_q3`=`stu_q3`+1 where `work_id`=\"";
                    break;
                case "Q4":
                    preSqlTutor = "update doc_statistics set `tutor_q4`=`tutor_q4`+1 where `work_id`=\"";
                    preSqlStu = "update doc_statistics set `stu_q4`=`stu_q4`+1 where `work_id`=\"";
                    break;
                default:
                    break;
            }
        }else{
            preSqlTutor = "update doc_statistics set `tutor_other`=`tutor_other`+1 where `work_id`=\"";
            preSqlStu = "update doc_statistics set `stu_other`=`stu_other`+1 where `work_id`=\"";
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