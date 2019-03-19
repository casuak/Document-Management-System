package team.abc.ssm.modules.sys.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import team.abc.ssm.common.persistence.Page;
import team.abc.ssm.modules.sys.dao.RoleDao;
import team.abc.ssm.modules.sys.entity.Role;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Service
public class RoleService {

    @Autowired
    private RoleDao roleDao;

    // 通过用户名获取该用户拥有的所有角色
    public Set<String> getRolesByUsername(String username) {
        List<Role> roleList = roleDao.getRolesByUsername(username);
        Set<String> result = new HashSet<>();
        for (Role role : roleList) {
            result.add(role.getCode());
        }
        return result;
    }

    // 获取所有角色
    public List<Role> getAllRoles() {
        return roleDao.getAllRoles();
    }

    // 通过用户名判断一个用户是否是管理员
    public boolean isAdmin(String username) {
        List<Role> roleList = roleDao.getRolesByUsername(username);
        for (Role role : roleList) {
            if (role.getCode().equals("admin"))
                return true;
        }
        return false;
    }

    public Page<Role> getByPage(Page<Role> page) {
        List<Role> roleList = roleDao.selectByPage(page);
        page.setResultList(roleDao.selectByIds(roleList));
        page.setTotal(roleDao.selectSearchCount(page));
        return page;
    }

    public boolean insert(Role role) {
        role.preInsert();
        int count = roleDao.insert(role);
        return count == 1;
    }
}
