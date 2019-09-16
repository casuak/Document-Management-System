package team.abc.ssm.modules.author.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import team.abc.ssm.common.web.SysDocType;
import team.abc.ssm.modules.author.dao.AuthorMapper;
import team.abc.ssm.modules.author.dao.AuthorStatisticsMapper;
import team.abc.ssm.modules.author.entity.Author;
import team.abc.ssm.modules.author.entity.AuthorStatistics;
import team.abc.ssm.modules.doc.dao.PaperDao;
import team.abc.ssm.modules.patent.dao.DocPatentMapper;
import team.abc.ssm.modules.sys.entity.Dict;
import team.abc.ssm.modules.sys.entity.User;

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




    //获取老师统计列表
    public List<AuthorStatistics> getAuthorStatisticsList(AuthorStatistics authorStatistics){
        //获取老师信息
        List<AuthorStatistics>  preList = authorStatisticsMapper.getAuthorListByPage(authorStatistics);
        List<AuthorStatistics> resultList = new ArrayList<>();

        //遍历每个老师
        for (int i = 0; i < preList.size(); i++) {
            AuthorStatistics teacher = preList.get(i);
            //获取所有该导师所有学生信息
            teacher.setStuList(authorStatisticsMapper.getStudentIdListByTeacherId(teacher.getWorkId()));

            //获取论文数量信息
            if(teacher.getStuList().size()>0){
                Map params = new HashMap();

                params.put("idlist",teacher.getStuList());
                params.put("type","Q1");
                teacher.setTutorQ1(authorStatisticsMapper.getPaperTeacherCount(teacher.getWorkId(),"Q1")+authorStatisticsMapper.getPaperBothStuCount(params));
                teacher.setStuQ1(getStuPaperNum(teacher.getWorkId(),teacher.getStuList(),"Q1"));

                params.remove("type");
                params.put("type","Q2");
                teacher.setTutorQ2(authorStatisticsMapper.getPaperTeacherCount(teacher.getWorkId(),"Q2")+authorStatisticsMapper.getPaperBothStuCount(params));
                teacher.setStuQ2(getStuPaperNum(teacher.getWorkId(),teacher.getStuList(),"Q2"));

                params.remove("type");
                params.put("type","Q3");
                teacher.setTutorQ3(authorStatisticsMapper.getPaperTeacherCount(teacher.getWorkId(),"Q3")+authorStatisticsMapper.getPaperBothStuCount(params));
                teacher.setStuQ3(getStuPaperNum(teacher.getWorkId(),teacher.getStuList(),"Q3"));

                params.remove("type");
                params.put("type","Q4");
                teacher.setTutorQ4(authorStatisticsMapper.getPaperTeacherCount(teacher.getWorkId(),"Q4")+authorStatisticsMapper.getPaperBothStuCount(params));
                teacher.setStuQ4(getStuPaperNum(teacher.getWorkId(),teacher.getStuList(),"Q4"));


                teacher.setStuPaperSum(teacher.getStuQ1()+teacher.getStuQ2()+teacher.getStuQ3()+teacher.getStuQ4());
                teacher.setTutorPaperSum(teacher.getTutorQ1()+teacher.getTutorQ2()+teacher.getTutorQ3()+teacher.getTutorQ4());
            }else{
                teacher.setTutorQ1(authorStatisticsMapper.getPaperTeacherCount(teacher.getWorkId(),"Q1"));
                teacher.setTutorQ2(authorStatisticsMapper.getPaperTeacherCount(teacher.getWorkId(),"Q2"));
                teacher.setTutorQ3(authorStatisticsMapper.getPaperTeacherCount(teacher.getWorkId(),"Q3"));
                teacher.setTutorQ4(authorStatisticsMapper.getPaperTeacherCount(teacher.getWorkId(),"Q4"));
                teacher.setTutorPaperSum(teacher.getTutorQ1()+teacher.getTutorQ2()+teacher.getTutorQ3()+teacher.getTutorQ4());

                teacher.setStuQ1(0);
                teacher.setStuQ2(0);
                teacher.setStuQ3(0);
                teacher.setStuQ4(0);
                teacher.setStuPaperSum(0);
            }


            //获取专利数量信息
            if(teacher.getStuList().size()>0) {
                teacher.setTutorPatent(authorStatisticsMapper.getPatentTeacherCount(teacher.getWorkId())+authorStatisticsMapper.getPatentStuBothCount(teacher.getStuList()));
                teacher.setStuPatent(getStuPatentNum(teacher.getWorkId(),teacher.getStuList()));
            }else{
                teacher.setTutorPatent(authorStatisticsMapper.getPatentTeacherCount(teacher.getWorkId()));
                teacher.setStuPatent(0);
            }
            //获取老师基金信息 TODO
            teacher.setNationFocus(authorStatisticsMapper.getFundCount(teacher.getWorkId(),"bc66c15317fc45c09103230de7f7120e"));
            teacher.setNsfcZDYF(authorStatisticsMapper.getFundCount(teacher.getWorkId(),"703386e1860648a6a397a6a24503bdf6"));
            teacher.setNationInstrument(authorStatisticsMapper.getFundCount(teacher.getWorkId(),"2163f1d53f5d48f1bee577df1babeac2"));
            teacher.setNsfcKXZX(authorStatisticsMapper.getFundCount(teacher.getWorkId(),"b8d6b2233c1b4ccaa46e19f405d474cc"));
            teacher.setNsfcZDAXM(authorStatisticsMapper.getFundCount(teacher.getWorkId(),"9eddd16e476a459d81dd2735e21be83b"));
            teacher.setNsfcZDIANXM(authorStatisticsMapper.getFundCount(teacher.getWorkId(),"9d8689193b584fd1903fe9abcf42877d"));
            teacher.setNsfcMSXM(authorStatisticsMapper.getFundCount(teacher.getWorkId(),"a7454d55cfa84120ad404a83049c4476"));
            teacher.setNsfcQNXM(authorStatisticsMapper.getFundCount(teacher.getWorkId(),"0a541d33521f415a870cbbfe88aaa758"));
            teacher.setNssfcZDAXM(authorStatisticsMapper.getFundCount(teacher.getWorkId(),"a7b4fed10c524924b0d7b5c5e3e3fefa"));
            teacher.setNssfcZDIANXM(authorStatisticsMapper.getFundCount(teacher.getWorkId(),"06c377960ec744f2a58b3e320dbea5c6"));
            teacher.setNssfcYBXM(authorStatisticsMapper.getFundCount(teacher.getWorkId(),"fcff48a07dda4c73bf3ed525be5115cd"));
            teacher.setNssfcQNXM(authorStatisticsMapper.getFundCount(teacher.getWorkId(),"4d0c8149b3064db69d7b2063bae7c709"));
            teacher.setFundSum(teacher.getNationFocus()+teacher.getNsfcZDYF()+teacher.getNationInstrument()+teacher.getNsfcKXZX()+teacher.getNsfcZDAXM()
            +teacher.getNsfcZDIANXM()+teacher.getNsfcMSXM()+teacher.getNsfcQNXM()+teacher.getNssfcZDAXM()+teacher.getNssfcYBXM()+teacher.getNssfcQNXM());
            resultList.add(teacher);
        }

        return resultList;
    }

    public int getAuthorStatisticsNum(AuthorStatistics authorStatistics){
        return  authorStatisticsMapper.getAuthorCount(authorStatistics);
    }

    int getStuPaperNum(String teacherId, List<String> stuList,String type){
        int result;
        result = 0;
        Map params = new HashMap();

        params.put("idlist",stuList);
        params.put("type",type);

        //一二作都是学生
        result +=authorStatisticsMapper.getPaperBothStuCount(params);

        //一作学生二作导师
        result += authorStatisticsMapper.getPaperStuFirstCount(params);


        //一作导师 二作学生
        params.put("teacherId",teacherId);
        result += authorStatisticsMapper.getPaperTeaFirstCount(params);

        return result;
    }

    int getStuPatentNum(String teacherId,List<String> stuList){
        int result;
        result = 0;

        Map params = new HashMap();
        params.put("idlist",stuList);
        params.put("teacherId",teacherId);
        //一二作都是学生
        result += authorStatisticsMapper.getPatentStuBothCount(stuList);

        //一作学生二作导师
        result += authorStatisticsMapper.getPatentStuFirstCount(stuList);

        //一作导师 二作学生
        result += authorStatisticsMapper.getPatentTeaFirstCount(params);

        return result;
    }
}