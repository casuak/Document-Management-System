package team.abc.ssm.modules.doc.dao;

import org.apache.ibatis.annotations.Param;
import team.abc.ssm.modules.author.entity.Author;
import team.abc.ssm.modules.doc.entity.Paper;
import team.abc.ssm.modules.doc.entity.Statistics;
import team.abc.ssm.modules.organization.entity.CommonOrganize;

import java.util.Date;
import java.util.List;
import java.util.Map;

public interface PaperSearchMapper {

    /**按页获取paperList*/
    public List<Paper> getPaperListByPage(
            @Param("paperName") String paperName,
            @Param("firstAuthorWorkNum") String firstAuthorWorkNum,
            @Param("secondAuthorWorkNum") String secondAuthorWorkNum,
            @Param("otherAuthorWorkNum") String otherAuthorWorkNum,
            @Param("issn") String issn,
            @Param("storeNum") String storeNum,
            @Param("docType") String docType,
            @Param("pageIndex") int paperPageIndex,
            @Param("pageSize") int paperPageSize
    );

    /**获取所有的作者身份(中文)*/
    public List<String> getAllAuthorIdentity();

    /**获取所有的论文种类*/
    public List<Map<String,String>> getPaperTypeMap();

    /**获取所有机构*/
    public List<CommonOrganize> getAllOrganize();

    /**获取所有的有效论文数量(del_flag不等于-1)*/
    public Integer getPaperNum();

    /**根据Id返回paper*/
    Paper getPaperById(String paperId);

    /**根据authorId返回有效paper数量*/
    int getMyPaperAmount(String authorId);

    /**根据author来返回Paper*/
    List<Paper> getPaperList(Author author);

    String selectTypeValue(String typeId);


    /**
     * 条件获取论文统计
     *
     * @param subject 第一作者的 major
     * @param organization 论文所属单位
     * @param startDate 发表开始期
     * @param endDate 发表截止期
     * @param paperType 论文种类
     * @param partition 科睿唯安分区
     * @param authorType 作者类型:[student,teacher,Postdoctoral]
     * @return team.abc.ssm.modules.doc.entity.Statistics
     * @author zm
     * @date 18:57 2019/5/19
     */
    public int getDocStatisticsRes(
            @Param("subject") String subject,
            @Param("organization") String organization,
            @Param("startDate") Date startDate,
            @Param("endDate") Date endDate,
            @Param("paperType") String paperType,
            @Param("partition") String partition,
            @Param("authorType") String authorType);
}
