package team.abc.ssm.modules.sys.service.map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import team.abc.ssm.modules.sys.dao.map.RoleFunctionDao;
import team.abc.ssm.modules.sys.entity.Function;
import team.abc.ssm.modules.sys.entity.Role;
import team.abc.ssm.modules.sys.entity.map.RoleFunction;

import java.util.ArrayList;
import java.util.List;

@Service
public class RoleFunctionService {

    @Autowired
    private RoleFunctionDao roleFunctionDao;

    /**
     * 更新角色拥有的功能列表
     */
    public boolean updateByRole(Role role) {
        // 先删除角色拥有的所有功能
        roleFunctionDao.deleteByRole(role);
        // 再添加
        List<RoleFunction> list = new ArrayList<>();
        for (Function function : role.getFunctionList()) {
            RoleFunction roleFunction = new RoleFunction();
            roleFunction.setRoleId(role.getId());
            roleFunction.setFunctionId(function.getId());
            roleFunction.preInsert();
            list.add(roleFunction);
        }
        if (list.size() == 0) return true;
        int count = roleFunctionDao.insertList(list);
        return count == list.size();
    }
}
