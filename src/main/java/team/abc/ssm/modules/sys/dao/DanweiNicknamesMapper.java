package team.abc.ssm.modules.sys.dao;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import team.abc.ssm.modules.sys.entity.DanweiNicknames;

public interface DanweiNicknamesMapper {
    int deleteByPrimaryKey(String id);

    int insert(DanweiNicknames record);

    int insertOrUpdate(DanweiNicknames record);

    int insertOrUpdateSelective(DanweiNicknames record);

    int insertSelective(DanweiNicknames record);

    DanweiNicknames selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(DanweiNicknames record);

    int updateByPrimaryKey(DanweiNicknames record);

    int updateBatch(List<DanweiNicknames> list);

    int batchInsert(@Param("list") List<DanweiNicknames> list);

    List<DanweiNicknames> selectAllList();
}