package team.abc.ssm.modules.doc.dao;

import java.util.List;
import team.abc.ssm.modules.doc.entity.DocPatent;
import tk.mybatis.mapper.common.Mapper;

public interface DocPatentMapper extends Mapper<DocPatent> {
    int deleteByPrimaryKey(String id);

    int insert(DocPatent record);

    DocPatent selectByPrimaryKey(String id);

    List<DocPatent> selectAll();

    int updateByPrimaryKey(DocPatent record);
}