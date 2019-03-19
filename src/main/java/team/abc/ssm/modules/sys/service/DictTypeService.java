package team.abc.ssm.modules.sys.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import team.abc.ssm.modules.sys.dao.DictTypeDao;
import team.abc.ssm.modules.sys.entity.DictType;

import java.util.List;

@Service
public class DictTypeService {

    @Autowired
    private DictTypeDao dictTypeDao;

    public boolean insert(DictType dictType) {
        dictType.preInsert();
        return dictTypeDao.insert(dictType) == 1;
    }

    public boolean deleteListByIds(List<DictType> dictTypeList) {
        return dictTypeList.size() == 0 || dictTypeDao.deleteListByIds(dictTypeList) == dictTypeList.size();
    }

    public boolean update(DictType dictType) {
        dictType.preUpdate();
        return dictTypeDao.update(dictType) == 1;
    }

    public List<DictType> selectListByPage(DictType dictType) {
        return dictTypeDao.selectListByPage(dictType);
    }

    public int selectSearchCount(DictType dictType) {
        return dictTypeDao.selectSearchCount(dictType);
    }

    public List<DictType> selectAllList(){
        return dictTypeDao.selectAllList();
    }
}
