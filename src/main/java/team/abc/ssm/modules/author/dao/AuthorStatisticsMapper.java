package team.abc.ssm.modules.author.dao;

import team.abc.ssm.modules.author.entity.AuthorStatistics;
import java.util.List;
import java.util.Map;

public interface AuthorStatisticsMapper {
    List<AuthorStatistics> getAuthorListByPage(AuthorStatistics authorStatistics);
    Integer getAuthorCount(AuthorStatistics authorStatistics);

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

}
