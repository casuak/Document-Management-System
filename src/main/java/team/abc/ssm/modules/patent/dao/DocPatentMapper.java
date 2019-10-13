package team.abc.ssm.modules.patent.dao;

import java.util.Date;

import org.apache.ibatis.annotations.Param;

import team.abc.ssm.modules.author.entity.Author;
import team.abc.ssm.modules.doc.entity.StatisticCondition;
import team.abc.ssm.modules.patent.entity.DocPatent;
import team.abc.ssm.modules.sys.entity.User;

import java.util.List;

public interface DocPatentMapper {

    List<DocPatent> selectAllByStatus(@Param("status") String status);

    int deleteByPrimaryKey(String id);

    int deleteByStatus(@Param("status") String status);

    int insert(DocPatent record);

    int insertSelective(DocPatent record);

    DocPatent selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(DocPatent record);

    int updateByPrimaryKey(DocPatent record);

    /**
     * 按页查询(会有patentName模糊匹配)
     */
    List<DocPatent> selectListByPage(DocPatent patent);

    int selectSearchCount(DocPatent patent);

    int setPatentAuthor(
            @Param("patentId") String patentId,
            @Param("authorIndex") int authorIndex,
            @Param("authorId") String authorId);

    int convertToSuccessByIds(List<DocPatent> patentList);

    int convertToCompleteByIds(List<DocPatent> patentList);
    List<DocPatent> selectConvertToCompleteByIds(List<DocPatent> patentList);

    int selectByStatusAndPatentNumberAndDelFlag(
            @Param("status")String status,
            @Param("patentNumber")String patentNumber,
            @Param("delFlag")Boolean delFlag);

    int selectStudentPatent(Author tmpAuthor);

    int selectTeacherPatent(Author tmpAuthor);

    /**
     * @author zm
     * @date 2019/8/4 17:00
     * @params [userId]
     * @return: int
     * @Description //查询个人专利数
     **/
    int selectMyPatentNum(@Param("userWorkId") String userWorkId);

    /**
     * @author zm
     * @date 2019/8/5 8:32
     * @params [docPatent]
     * @return: java.util.List<team.abc.ssm.modules.patent.entity.DocPatent>
     * @Description
     * 
     * 1.返回指定作者的专利List
     * 2作者workId保存在patent的id字段中
     **/
    List<DocPatent> selectMyPatentList(DocPatent docPatent);

    /**
     * 根据给定条件统计专利数目
     * v2->修改为查询所有专利，在service层去判断作者类别所属
     *
     * @author zm
     * @param1 statisticCondition
     * @return int        
     * @date 2019/8/5 16:34
     **/
    List<DocPatent> getStatisticNumOfPatent(StatisticCondition statisticCondition);

    /**
     * 查询返回所有的专利类型
     *
     * @author zm
     * @return java.util.List<java.lang.String>
     * @date 2019/8/5 19:57
     **/
    List<String> selectAllPatentType();

    /**
     * 根据statisticCondition条件查询所有的专利
     *
     * @author zm
     * @param1 statisticCondition
     * @return java.util.List<team.abc.ssm.modules.patent.entity.DocPatent>        
     * @date 2019/8/16 13:45
     **/
    List<DocPatent> selectAllByPageWithStatisticCondition(StatisticCondition statisticCondition);

    int selectNumWithStatisticCondition(StatisticCondition statisticCondition);

    int updateDocPatentBatch(List<DocPatent> patentsForUpdate);
}