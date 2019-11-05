package team.abc.ssm.modules.author.dao;

import team.abc.ssm.modules.author.entity.Author;
import team.abc.ssm.modules.author.entity.AuthorStatistics;
import team.abc.ssm.modules.sys.entity.User;

import java.util.List;
import java.util.Map;

public interface AuthorStatisticsMapper {
   /** 1.0版本 */
    /*List<AuthorStatistics> getAuthorListByPage(AuthorStatistics authorStatistics);
    Integer getAuthorCount(AuthorStatistics authorStatistics);*/

    //获取学生列表
    List<String> getStudentIdListByTeacherId(String teacherId);

    Integer getPaperTeacherCount(String workId,String type); //一二作带有老师名字的直接加

    Integer getPaperBothStuCount(Map<String,Object> info); //一二作都是学生的
    Integer getPaperStuFirstCount(Map<String,Object> info); //一作学生 二作导师
    Integer getPaperTeaFirstCount(Map<String,Object> info); //一作导师 二作学生


    Integer getPatentTeacherCount(String workId);//一二作带有老师名字的直接加
    Integer getPatentStuBothCount(List<String> idlist);//一二作都是学生的
    Integer getPatentStuFirstCount(List<String> idlist); //一作学生 二作导师
    Integer getPatentTeaFirstCount(Map<String,Object> info);//一作导师 二作学生

    //获取基金数量
    Integer getFundCount(String workId,String type);

    /** 2.0版本*/
    void doSql(String sql);
   List<AuthorStatistics> getAuthorListByPage(AuthorStatistics authorStatistics);
   Integer getAuthorCount(AuthorStatistics authorStatistics);

   List<String> selectSchoolList(AuthorStatistics authorStatistics);
    List<String> selectMajorList(AuthorStatistics authorStatistics);
    Integer selectSchoolListCount(AuthorStatistics authorStatistics);
    Integer selectMajorListCount(AuthorStatistics authorStatistics);
   AuthorStatistics selectCountByMajor(String major);
   AuthorStatistics selectCountBySchool(String school);


   Integer insertUser(User user);
}
