package team.abc.ssm.modules.doc.dao;

import org.apache.ibatis.annotations.Param;
import team.abc.ssm.modules.doc.entity.Paper;
import team.abc.ssm.modules.organization.domain.CommonOrganize;
import team.abc.ssm.modules.sys.entity.User;

import java.util.List;
import java.util.Map;

public interface PaperSearchMapper {

    /*获取所有的作者身份(中文)*/
    public List<String> getAllAuthorIdentity();

    /*获取所有的论文种类*/
    public List<Map<String,String>> getPaperTypeMap();

    /*获取所有机构*/
    public List<CommonOrganize> getAllOrganize();

    /*条件获取PaperList*/
    public List<Paper> getPaperList(
            @Param("paperName") String paperName,
            @Param("firstAuthorWorkNum") String firstAuthorWorkNum,
            @Param("secondAuthorWorkNum") String secondAuthorWorkNum,
            @Param("otherAuthorWorkNum") String otherAuthorWorkNum,
            @Param("journalNum") String journalNum,
            @Param("storeNum") String storeNum,
            @Param("docType") String docType,
            @Param("paperPageIndex") int paperPageIndex,
            @Param("paperPageSize") int paperPageSize
    );
}
