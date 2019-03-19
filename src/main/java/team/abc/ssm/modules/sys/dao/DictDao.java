package team.abc.ssm.modules.sys.dao;

import team.abc.ssm.modules.sys.entity.Dict;

import java.util.List;

public interface DictDao {

    int insert(Dict dict);

    int deleteListByIds(List<Dict> dictList);

    int update(Dict dict);

    List<Dict> selectListByPage(Dict dict);

    int selectSearchCount(Dict dict);

    List<Dict> selectParentList(Dict dict);
}
