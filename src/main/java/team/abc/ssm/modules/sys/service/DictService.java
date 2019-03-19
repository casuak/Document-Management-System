package team.abc.ssm.modules.sys.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import team.abc.ssm.modules.sys.dao.DictDao;
import team.abc.ssm.modules.sys.entity.Dict;

import java.util.List;

@Service
public class DictService {

    @Autowired
    private DictDao dictDao;

    public boolean insert(Dict dict) {
        dict.preInsert();
        return dictDao.insert(dict) == 1;
    }

    public boolean deleteListByIds(List<Dict> dictList) {
        return dictList.size() == 0 || dictDao.deleteListByIds(dictList) == dictList.size();
    }

    public boolean update(Dict dict) {
        dict.preUpdate();
        return dictDao.update(dict) == 1;
    }

    public List<Dict> selectListByPage(Dict dict) {
        return dictDao.selectListByPage(dict);
    }

    public int selectSearchCount(Dict dict) {
        return dictDao.selectSearchCount(dict);
    }

    public List<Dict> selectParentList(Dict dict) {
        return dictDao.selectParentList(dict);
    }
}
