package team.abc.ssm.modules.document.docStatistics.dao;

import team.abc.ssm.modules.document.docStatistics.entity.MapUserPatent;

public interface MapUserPatentMapper {
    int deleteByPrimaryKey(String id);

    int insert(MapUserPatent record);

    int insertSelective(MapUserPatent record);

    MapUserPatent selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(MapUserPatent record);

    int updateByPrimaryKey(MapUserPatent record);
}