package team.abc.ssm.modules.patent.service;

import org.springframework.stereotype.Service;
import javax.annotation.Resource;
import team.abc.ssm.modules.patent.dao.MapUserPatentMapper;
import team.abc.ssm.modules.patent.entity.MapUserPatent;

@Service
public class MapUserPatentService {

    @Resource
    private MapUserPatentMapper mapUserPatentMapper;


    public int deleteByPrimaryKey(String id) {
        return mapUserPatentMapper.deleteByPrimaryKey(id);
    }


    public int insert(MapUserPatent record) {
        return mapUserPatentMapper.insert(record);
    }


    public int insertSelective(MapUserPatent record) {
        return mapUserPatentMapper.insertSelective(record);
    }


    public MapUserPatent selectByPrimaryKey(String id) {
        return mapUserPatentMapper.selectByPrimaryKey(id);
    }


    public int updateByPrimaryKeySelective(MapUserPatent record) {
        return mapUserPatentMapper.updateByPrimaryKeySelective(record);
    }


    public int updateByPrimaryKey(MapUserPatent record) {
        return mapUserPatentMapper.updateByPrimaryKey(record);
    }

}

