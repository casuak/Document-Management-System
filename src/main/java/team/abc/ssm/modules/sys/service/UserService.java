package team.abc.ssm.modules.sys.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import team.abc.ssm.common.persistence.Page;
import team.abc.ssm.modules.sys.dao.UserDao;
import team.abc.ssm.modules.sys.entity.User;

import java.util.List;

@Service
public class UserService {

    @Autowired
    public UserDao userDao;

    public User getUserByUsername(User user) {
        return userDao.selectByUsername(user);
    }

    public List<User> getAllUsers() {
        return userDao.selectAll();
    }

    // 特殊需求(PaperService)
    public List<User> getAllUsers2() {
        return userDao.selectAll2();
    }

    public Page<User> getUsersByPage(User user) {
        // 先获取分页的users
        List<User> userList = userDao.selectByPage(user);
        // 再查询具体内容
        userDao.selectByIds(userList);
        user.getPage().setResultList(userDao.selectByIds(userList));
        user.getPage().setTotal(userDao.selectSearchCount(user));
        return user.getPage();
    }

    // 复杂搜索
    public Page<User> selectListByPage2(User user) {
        Page<User> page = new Page<>();
        page.setResultList(userDao.selectListByPage2(user));
        page.setTotal(userDao.selectSearchCount2(user));
        return page;
    }

    public boolean isUsernameExist(User user) {
        return userDao.selectByUsername(user) != null;
    }

    public boolean addUser(User user) {
        if (isUsernameExist(user))
            return false;
        user.preInsert();
        int count = userDao.insert(user);
        return count == 1;
    }

    /**
     * @param user 用户对象
     * @return 成功与否
     */
    public boolean update(User user) {
        int count = userDao.update(user);
        return count == 1;
    }

    public boolean updateList(List<User> userList) {
        int count = userDao.updateList(userList);
        return count == userList.size();
    }

    public boolean deleteUserByIds(List<User> userList) {
        int count = userDao.deleteByIds(userList);
        return count == userList.size();
    }
}
