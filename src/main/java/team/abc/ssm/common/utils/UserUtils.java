package team.abc.ssm.common.utils;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
import team.abc.ssm.modules.sys.entity.User;
import team.abc.ssm.modules.sys.service.UserService;

/**
 * 用户工具类
 */
public class UserUtils {

    private static UserService userService = SpringContextHolder.getBean(UserService.class);

    /**
     * 返回当前登陆用户
     */
    public static User getCurrentUser() {
        Subject subject = SecurityUtils.getSubject();
        return (User) subject.getSession().getAttribute("user");
    }

    /**
     * 刷新当前登陆用户的信息
     */
    public static User refreshCurrentUser() {
        String username = (String) SecurityUtils.getSubject().getPrincipal();
        Subject subject = SecurityUtils.getSubject();
        User _user = new User();
        _user.setUsername(username);
        User user = userService.getUserByUsername(_user);
        subject.getSession().setAttribute("user", user);
        return user;
    }
}
