package team.abc.ssm.modules.patent.dao;

import java.util.Date;

import org.apache.ibatis.annotations.Param;

import team.abc.ssm.modules.author.entity.Author;
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
}