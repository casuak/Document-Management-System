package team.abc.ssm.modules.sys.dao.map;

import team.abc.ssm.modules.sys.entity.User;
import team.abc.ssm.modules.sys.entity.map.UserRole;

import java.util.List;

public interface UserRoleDao {

    // 删除某个用户的所有角色关联
    int deleteByUserId(User user);

    // 批量添加
    int insert(List<UserRole> userRoleList);
}
