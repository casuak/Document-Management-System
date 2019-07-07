package team.abc.ssm.modules.patent.dao;

import team.abc.ssm.modules.patent.entity.MapUserPatent;

public interface MapUserPatentMapper {
    int deleteByPrimaryKey(String id);

    int insert(MapUserPatent record);

    int insertSelective(MapUserPatent record);

    MapUserPatent selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(MapUserPatent record);

    int updateByPrimaryKey(MapUserPatent record);
}