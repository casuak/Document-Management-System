package wyj;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Suite;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import team.abc.ssm.common.utils.PinyinUtils;
import team.abc.ssm.modules.sys.dao.UserDao;
import team.abc.ssm.modules.sys.entity.User;
import team.abc.ssm.modules.sys.service.UserService;

import javax.annotation.Resource;
import java.util.List;

public class MyJunit4Test {
    @Resource
    private UserDao userDao;

    private UserService userService;

    @Before
    public void init() {
        ApplicationContext context = new ClassPathXmlApplicationContext("classpath:spring-context.xml");
        userService = context.getBean("userService", UserService.class);
    }

    @Test
    public void initUserNicknames() {
        List<User> userList = userService.getAllUsers();
        for (User user : userList) {
            String nicknames = "";
            nicknames += PinyinUtils.getPinyin2(user.getRealName(), true) + ";";
            nicknames += PinyinUtils.getPinyin2(user.getRealName(), false) + ";";

            user.setNicknames(nicknames);
        }
        userService.updateList(userList);
    }

    @Test
    public void test(){
        userDao = userService.userDao;
        List<User> userList = userDao.selectAll();
        return;
    }
}
