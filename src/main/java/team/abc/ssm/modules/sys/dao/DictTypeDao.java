package team.abc.ssm.modules.sys.dao;

import team.abc.ssm.modules.sys.entity.DictType;

import java.util.List;

public interface DictTypeDao {

    int insert(DictType dictType);

    int deleteListByIds(List<DictType> dictTypeList);

    int update(DictType dictType);

    List<DictType> selectListByPage(DictType dictType);

    int selectSearchCount(DictType dictType);

    List<DictType> selectAllList();
}
