package team.abc.ssm.modules.sys.dao;

import team.abc.ssm.common.persistence.CrudDao;
import team.abc.ssm.modules.sys.entity.Function;
import team.abc.ssm.modules.sys.entity.Role;

import java.util.List;

public interface FunctionDao extends CrudDao<Function>{

    // 通过用户名获取该用户拥有的所有功能
    List<Function> selectByUsername(String username);

    // 取出所有启用的功能
    List<Function> selectAllEnabled();

    // 由id更新index
    int updateIndex(List<Function> functionList);

    // 获取与角色相关的功能列表
    List<Function> selectByRole(Role role);

    /**
     * //获取全部的机构List(学院)
     *
     * @author zm
     * @return java.util.List<java.lang.String>
     * @date 2019/8/5 11:07
     **/
    List<String> getOrgList();
}
