package team.abc.ssm.modules.doc.service;

import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

import team.abc.ssm.modules.doc.dao.DanweiNicknamesMapper;
import team.abc.ssm.modules.doc.entity.DanweiNicknames;

@Service
public class DanweiNicknamesService {

    @Resource
    private DanweiNicknamesMapper danweiNicknamesMapper;

    public int deleteByPrimaryKey(String id) {
        return danweiNicknamesMapper.deleteByPrimaryKey(id);
    }

    public int insert(DanweiNicknames record) {
        return danweiNicknamesMapper.insert(record);
    }

    public int insertOrUpdate(DanweiNicknames record) {
        return danweiNicknamesMapper.insertOrUpdate(record);
    }

    public int insertOrUpdateSelective(DanweiNicknames record) {
        return danweiNicknamesMapper.insertOrUpdateSelective(record);
    }

    public int insertSelective(DanweiNicknames record) {
        return danweiNicknamesMapper.insertSelective(record);
    }

    public DanweiNicknames selectByPrimaryKey(String id) {
        return danweiNicknamesMapper.selectByPrimaryKey(id);
    }

    public int updateByPrimaryKeySelective(DanweiNicknames record) {
        return danweiNicknamesMapper.updateByPrimaryKeySelective(record);
    }

    public int updateByPrimaryKey(DanweiNicknames record) {
        return danweiNicknamesMapper.updateByPrimaryKey(record);
    }

    public int updateBatch(List<DanweiNicknames> list) {
        return danweiNicknamesMapper.updateBatch(list);
    }

    public int batchInsert(List<DanweiNicknames> list) {
        return danweiNicknamesMapper.batchInsert(list);
    }

    public List<DanweiNicknames> selectAllList() {
        return danweiNicknamesMapper.selectAllList();
    }

}
