package team.abc.ssm.modules.doc.dao;

import org.apache.ibatis.annotations.Param;
import team.abc.ssm.modules.author.entity.Author;
import team.abc.ssm.modules.doc.entity.Patent;
import team.abc.ssm.modules.doc.entity.Statistics;
import tk.mybatis.mapper.common.Mapper;

import java.util.Date;
import java.util.List;

public interface PatentMapper extends Mapper<Patent> {

    int getMyPatentAmount(String authorId);

    /** 根据author的Id和page限制返回Patent集合*/
    List<Patent> getPatentList(Author author);

    /**
     * 条件获取著作权统计数量
     *
     * @param subject
     * @param organization
     * @param startDate
     * @param endDate
     * @param paperType
     * @param partition
     * @return team.abc.ssm.modules.doc.entity.Statistics
     * @author zm
     * @date 18:28 2019/5/19
     */
    Statistics getPatentStatisticsRes(
            @Param("subject") String subject,
            @Param("organization") String organization,
            @Param("startDate") Date startDate,
            @Param("endDate") Date endDate,
            @Param("paperType") String paperType,
            @Param("partition") String partition);
}