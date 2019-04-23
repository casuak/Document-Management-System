package team.abc.ssm.modules.organization.dao;

import java.util.List;
import java.util.Map;

import team.abc.ssm.modules.organization.entity.CommonOrganize;

public interface CommonOrganizeMapper {
    int deleteByPrimaryKey(String id);

    int insert(CommonOrganize record);

    CommonOrganize selectByPrimaryKey(String id);

    List<CommonOrganize> selectAll();

    int updateByPrimaryKey(CommonOrganize record);

    /*获取所有的机构种类*/
    public List<Map<String,String>> getOrgListMap();
}