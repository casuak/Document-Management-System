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

    int selectByStatusAndPatentNumberAndDelFlag(@Param("status")String status,@Param("patentNumber")String patentNumber,@Param("delFlag")Boolean delFlag);

    int selectStudentPatent(Author tmpAuthor);

    int selectTeacherPatent(Author tmpAuthor);
}