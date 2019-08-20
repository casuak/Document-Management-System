package team.abc.ssm.modules.paper.mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

import team.abc.ssm.modules.doc.entity.StatisticCondition;
import team.abc.ssm.modules.paper.entity.DocPaper;

public interface DocPaperMapper {
    int deleteByPrimaryKey(String id);

    int insert(DocPaper record);

    int insertSelective(DocPaper record);

    DocPaper selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(DocPaper record);

    int updateByPrimaryKey(DocPaper record);

    /**
     * 传入DocPaper，根据约束条件查询返回指定的paperList
     *
     * @author zm
     * @param1 statisticCondition
     * @return java.util.List<team.abc.ssm.modules.paper.entity.DocPaper>
     * @date 2019/8/9 19:07
     **/
    List<DocPaper> selectPapersWithCondition(StatisticCondition statisticCondition);

    /**
     * 传入DocPaper，根据约束条件查询返回指定的paper的数目
     *
     * @author zm
     * @param1 statisticCondition
     * @return int        
     * @date 2019/8/9 19:53
     **/
    int selectPaperNumWithCondition(StatisticCondition statisticCondition);
    
    /**
     * 传入DocPaper，查询并返回指定作者的所有论文List
     * 1.DocPaper中的theAuthorWorkId为待查作者的工号
     * 2.DocPaper中的page存储的是分页信息
     * 3.需要查询的paper状态是：2(已完成)
     *
     * @author zm
     * @param1 DocPaper record
     * @return java.util.List<team.abc.ssm.modules.paper.entity.DocPaper>
     * @date 2019/8/5 11:35
     **/
    List<DocPaper> selectTheAuthorPapers(DocPaper record);

    /**
     * 传入作者的工号，查询返回其下所有的论文数量(status是‘2’)
     *
     * @author zm
     * @param1 authorWorkId
     * @return int
     * @date 2019/8/5 13:33
     **/
    int selectTheAuthorPaperNum(String authorWorkId);

    /**
     * 根据传入参数统计论文的数量，直接全部返回java内统计数目
     *
     * @author zm
     * @param1 statisticCondition
     * @return int
     * @date 2019/8/5 16:25
     **/
    List<DocPaper> getStatisticNumOfPaper(StatisticCondition statisticCondition);
}