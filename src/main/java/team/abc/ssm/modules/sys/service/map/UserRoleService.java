package team.abc.ssm.modules.sys.service.map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import team.abc.ssm.modules.sys.dao.map.UserRoleDao;
import team.abc.ssm.modules.sys.entity.Role;
import team.abc.ssm.modules.sys.entity.User;
import team.abc.ssm.modules.sys.entity.map.UserRole;

import java.util.ArrayList;
import java.util.List;

@Service
public class UserRoleService {

    @Autowired
    private UserRoleDao userRoleDao;

    /**
     * 覆盖式更新一个用户拥有的角色（缺点：丢失创建记录）
     *
     * @param user     目标用户
     * @param roleList 用户拥有的所有角色
     * @return 成功与否
     */
    public boolean update(User user, List<Role> roleList) {
        userRoleDao.deleteByUserId(user);
        if (roleList.size() == 0) return true;
        List<UserRole> userRoleList = new ArrayList<>();
        for (Role role : roleList) {
            UserRole userRole = new UserRole();
            userRole.setRoleId(role.getId());
            userRole.setUserId(user.getId());
            userRole.preInsert();
            userRoleList.add(userRole);
        }
        userRoleDao.insert(userRoleList);
        return true;
    }
}
