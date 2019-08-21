package team.abc.ssm.modules.doc.dao;

import java.util.List;
import team.abc.ssm.modules.doc.entity.Fund;

public interface FundDao {

    List<Fund> list(Fund fund);
    int listCount(Fund fund);

    int deleteByIds(List<Fund> list);

    int deleteAll();

    int updateById(Fund fund);
}
