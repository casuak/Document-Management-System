package team.abc.ssm.modules.sys.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import team.abc.ssm.common.persistence.Page;
import team.abc.ssm.common.utils.PinyinUtils;
import team.abc.ssm.modules.author.entity.AuthorStatistics;
import team.abc.ssm.modules.sys.dao.UserDao;
import team.abc.ssm.modules.sys.entity.User;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Service
@Slf4j
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
        int total = userDao.selectSearchCount(user);
        user.getPage().setTotal(total);
        if (total != 0)
            user.getPage().setResultList(userDao.selectByIds(userList));
        else
            user.getPage().setResultList(new ArrayList<>());
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
        user.preUpdate();
        int count = userDao.update(user);
        return count == 1;
    }

    /**
     * 初始化导入的用户
     */
    public void initUser() {
        List<User> updateList = userDao.selectByStatus("0");
        List<User> teacherInitList = new ArrayList<>();
        setUsersNicknamesAndTutorNicknames(updateList);

        for (User user : updateList) {
            if (user.getUserType().equals("teacher"))
                teacherInitList.add(user);
        }
        if (teacherInitList.size() > 0)
            userDao.insertIntoStatistics(teacherInitList);
        for (User user : updateList) {
            user.setStatus("1");
        }
        int updateCount = (int) Math.ceil(updateList.size() / 1000f);
        for (int i = 0; i < updateCount; i++) {
            int start = i * 1000;
            int end = start + 1000;
            if (end > updateList.size())
                end = updateList.size();
            userDao.updateList(updateList.subList(start, end));
            float progress = (i + 1f) / updateCount * 100f;
            log.info("当前进度：" + progress + "%");
        }

        // 博导和硕导去重
        List<User> teacherList = userDao.selectByUserType("teacher");
        List<User> saveList = new ArrayList<>();
        List<User> deleteList = new ArrayList<>();
        List<String> upList = new ArrayList<>();

        for (User teacher : teacherList) {
            if (teacher.getWorkId() == null || teacher.getWorkId().equals("兼职") || teacher.getWorkId().equals("")) {
                deleteList.add(teacher);
                continue;
            }
            boolean repeat = false;
            for (User u : saveList) {
                if (teacher.getWorkId().equals(u.getWorkId())) {
                    repeat = true;
                    break;
                }
            }
            if (repeat) {
                upList.add(teacher.getWorkId());
                deleteList.add(teacher);
            } else {
                saveList.add(teacher);
            }
        }

        if(deleteList.size()>0){
            userDao.deleteByIds(deleteList);
            userDao.deleteStaByIds(deleteList);
        }

        if(upList.size()>0){
            userDao.updateDoct(upList);
            userDao.updateDoctSta(upList);
        }
    }

    /**
     * 设置用户的nickname和导师的nickname（如果有的话）
     */
    private void setUsersNicknamesAndTutorNicknames(List<User> userList) {
        // 对所有用户添加nickname
        for (User user : userList) {
            String nicknames = "";
            nicknames += PinyinUtils.getPinyin2(user.getRealName(), true) + ";";
            nicknames += PinyinUtils.getPinyin2(user.getRealName(), false) + ";";
            user.setNicknames(nicknames);
            String tutorNicknames = "";
            String tutorName = user.getTutorName();
            if (tutorName != null && !tutorName.equals("")) {
                tutorNicknames += PinyinUtils.getPinyin2(user.getTutorName(), true) + ";";
                tutorNicknames += PinyinUtils.getPinyin2(user.getTutorName(), false) + ";";
                user.setTutorNicknames(tutorNicknames);
            }
        }
    }


    public boolean updateList(List<User> userList) {
        int count = userDao.updateList(userList);
        return count == userList.size();
    }

    public boolean deleteUserByIds(List<User> userList) {
        userDao.deleteStaByIds(userList);
        userDao.deleteStaYearByIds(userList);
        if (userList.size() == 0) return true;
        int count = userDao.deleteByIds(userList);
        return count == userList.size();
    }


    /**
     * @author zm
     * @date 2019/7/5 14:14
     * @params [user]
     * @return: team.abc.ssm.common.persistence.Page<team.abc.ssm.modules.sys.entity.User>
     * @Description //复杂搜索：专利匹配页用_用户搜索
     **/
    public Page<User> selectUserListByPage(User user) {
        Page<User> page = new Page<>();
        page.setResultList(userDao.selectUserListByPage(user));
        page.setTotal(userDao.selectUserSearchCount(user));
        return page;
    }
}
