package team.abc.ssm.modules.organization.mapper;

import java.util.List;
import team.abc.ssm.modules.organization.domain.CommonOrganize;

public interface CommonOrganizeMapper {
    int deleteByPrimaryKey(String id);

    int insert(CommonOrganize record);

    CommonOrganize selectByPrimaryKey(String id);

    List<CommonOrganize> selectAll();

    int updateByPrimaryKey(CommonOrganize record);
}