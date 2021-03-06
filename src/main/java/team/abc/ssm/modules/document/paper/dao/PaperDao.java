package team.abc.ssm.modules.document.paper.dao;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import team.abc.ssm.modules.document.authorSearch.entity.Author;
import team.abc.ssm.modules.document.paper.entity.Paper;

public interface PaperDao {
    int deleteByPrimaryKey(String id);

    int insert(Paper record);

    int insertOrUpdate(Paper record);

    int insertOrUpdateSelective(Paper record);

    int insertSelective(Paper record);

    Paper selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(Paper record);

    int updateByPrimaryKey(Paper record);

    int updateBatch(List<Paper> list);

    int batchInsert(@Param("list") List<Paper> list);

    /**
     * custom dao below
     */

    List<Paper> selectIdsByPage(Paper paper);

    List<Paper> selectListByIds(Paper paper);

    int selectSearchCount(Paper paper);

    List<Paper> selectListByStatus(Paper paper);
    List<Paper> selectPaperListByStatus(String status);

    List<Paper> selectAll();

    int deleteListByIds(List<Paper> paperList);
    int deleteList(List<Paper> paperList);
    List<Paper> selectDeleteListByIds(List<Paper> paperList);

    int convertToSuccessByIds(List<Paper> paperList);

    int deleteByStatus(String status);
    List<Paper> selectByStatus(String status);

    int selectAuthor(
            @Param("paperId") String paperId,
            @Param("authorIndex") int authorIndex,
            @Param("authorWorkId") String authorWorkId);

    int completeAll();

    int countByFirstAuthorIdAndStatus(
            @Param("firstAuthorId") String firstAuthorId,
            @Param("status") String status);

    int selectStudentPaper(
            Author author);

    int selectTeacherPaper(
            Author author);
}