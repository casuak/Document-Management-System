package team.abc.ssm.modules.sys.dao;

import org.apache.ibatis.annotations.Param;
import team.abc.ssm.common.persistence.CrudDao;
import team.abc.ssm.common.persistence.Page;
import team.abc.ssm.modules.sys.entity.Role;

import java.util.List;

public interface RoleDao extends CrudDao<Role> {

    // 通过用户名获取该用户拥有的所有角色
    List<Role> getRolesByUsername(String username);

    // 获取所有角色
    List<Role> getAllRoles();

    List<Role> selectByIds(@Param("list") List<Role> entityList);

    List<Role> selectByPage(Page<Role> page);

    int selectSearchCount(Page page);
}
