package team.abc.ssm.modules.web;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import team.abc.ssm.common.web.BaseController;
import team.abc.ssm.common.web.MsgType;
import team.abc.ssm.modules.sys.entity.User;
import team.abc.ssm.modules.sys.service.UserService;

@Controller
public class LoginController extends BaseController {

    @Autowired
    private UserService userService;

    @RequestMapping(value = "login", method = RequestMethod.POST)
    @ResponseBody
    public Object login(@RequestBody User user) {
        Subject subject = SecurityUtils.getSubject();
        UsernamePasswordToken token = new UsernamePasswordToken(user.getUsername(), user.getPassword());
        // 如果已经登陆，则退出已经登陆的用户
        if (subject.isAuthenticated()) {
            subject.logout();
        }
        try {
            subject.login(token);
            subject.getSession().setAttribute("user", userService.getUserByUsername(user));
            return retMsg.Set(MsgType.SUCCESS);
        } catch (AuthenticationException e) {
            return retMsg.Set(MsgType.ERROR);
        }
    }
}
