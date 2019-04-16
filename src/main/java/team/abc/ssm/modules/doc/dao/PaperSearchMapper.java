package team.abc.ssm.modules.doc.dao;

import org.apache.ibatis.annotations.Param;
import team.abc.ssm.modules.doc.entity.Paper;
import team.abc.ssm.modules.organization.entity.CommonOrganize;

import java.util.List;
import java.util.Map;

public interface PaperSearchMapper {

    /*按页获取paperList*/
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

    /*获取所有的作者身份(中文)*/
    public List<String> getAllAuthorIdentity();

    /*获取所有的论文种类*/
    public List<Map<String,String>> getPaperTypeMap();

    /*获取所有机构*/
    public List<CommonOrganize> getAllOrganize();

    /*获取所有的有效论文数量(del_flag不等于-1)*/
    public Integer getPaperNum();

    /*条件获取PaperList*/
    public List<Paper> getPaperList(
            @Param("paperName") String paperName,
            @Param("firstAuthorWorkNum") String firstAuthorWorkNum,
            @Param("secondAuthorWorkNum") String secondAuthorWorkNum,
            @Param("otherAuthorWorkNum") String otherAuthorWorkNum,
            @Param("ISSN") String ISSN,
            @Param("storeNum") String storeNum,
            @Param("docType") String docType,
            @Param("paperPageIndex") int paperPageIndex,
            @Param("paperPageSize") int paperPageSize
    );

    /*根据Id返回paper*/
    Paper getPaperById(String paperId);
}
