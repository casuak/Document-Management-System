package team.abc.ssm.modules.sys.dao.map;

import team.abc.ssm.common.persistence.CrudDao;
import team.abc.ssm.modules.sys.entity.Role;
import team.abc.ssm.modules.sys.entity.map.RoleFunction;

import java.util.List;

public interface RoleFunctionDao extends CrudDao<RoleFunction> {

    // 删除一个角色的所有功能
    int deleteByRole(Role role);

    int insertList(List<RoleFunction> list);
}
