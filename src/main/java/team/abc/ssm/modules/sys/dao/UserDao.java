package team.abc.ssm.modules.sys.dao;

import org.apache.ibatis.annotations.Select;
import team.abc.ssm.modules.author.entity.SysUser;
import team.abc.ssm.modules.sys.entity.User;

import java.util.List;

public interface UserDao {

    // 通过用户名获取用户信息
    User selectByUsername(User user);

    // 模糊搜索结果总数
    int selectSearchCount(User user);

    // 获取所有用户列表
    List<User> selectAll();

    List<User> selectByStatus(String status);

    // 获取所有用户(论文用户匹配中使用到)
    List<User> selectAll2();

    List<User> selectByUserType(String userType);

    // 分页 + 搜索(模糊匹配用户名)获取用户列表（无角色信息）
    List<User> selectByPage(User user);

    // 复杂搜索（包含分页）获取用户id列表(用于论文用户匹配)
    List<User> selectListByPage2(User user);
    // 复杂搜索（不包含分页）的结果总条数
    int selectSearchCount2(User user);

    // 根据ids获取用户列表（有角色信息）
    List<User> selectByIds(List<User> userList);

    // 添加一名新用户
    int insert(User user);

    // 更新用户信息
    int update(User user);

    // 批量更新用户信息
    int updateList(List<User> userList);

    // 删除指定id的用户
    int deleteByIds(List<User> userList);

    //更新用户是博导
    int updateDoct(List<String> userList);

    //向统计表中插入信息
    int insertIntoStatistics(List<User> userList);
    int updateDoctSta(List<String> userList);

    // 删除统计表指定id的用户
    int deleteStaByIds(List<User> userList);
    int deleteStaYearByIds(List<User> userList);

    /**
     * @author zm
     * @date 2019/7/5 14:08
     * @params [user]
     * @return: java.util.List<team.abc.ssm.modules.sys.entity.User>
     * @Description //专利用户匹配用：搜索匹配用户
     **/
    List<User> selectUserListByPage(User user);
    
    /**
     * @author zm
     * @date 2019/7/5 14:10
     * @params [user]
     * @return: int
     * @Description //专利用户匹配用：搜索匹配用户总数
     **/
    int selectUserSearchCount(User user);
}
