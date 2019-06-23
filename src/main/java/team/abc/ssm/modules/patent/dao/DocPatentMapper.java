package team.abc.ssm.modules.patent.dao;
import org.apache.ibatis.annotations.Param;

import team.abc.ssm.modules.patent.entity.DocPatent;
import team.abc.ssm.modules.sys.entity.User;

import java.util.List;

public interface DocPatentMapper {

    List<DocPatent> selectAllByStatus(@Param("status")String status);

    int deleteByPrimaryKey(String id);

    int insert(DocPatent record);

    int insertSelective(DocPatent record);

    DocPatent selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(DocPatent record);

    int updateByPrimaryKey(DocPatent record);

    /** 按页查询(会有patentName模糊匹配)*/
    List<DocPatent> selectListByPage(DocPatent patent);

    int selectSearchCount(DocPatent patent);
}