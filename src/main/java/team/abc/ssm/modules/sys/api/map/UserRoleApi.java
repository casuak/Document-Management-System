package team.abc.ssm.modules.sys.api.map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import team.abc.ssm.common.web.BaseApi;
import team.abc.ssm.common.web.MsgType;
import team.abc.ssm.modules.sys.entity.User;
import team.abc.ssm.modules.sys.entity.map.UserRole;
import team.abc.ssm.modules.sys.service.map.UserRoleService;

import java.util.List;

@Controller
@RequestMapping("api/sys/map/userRole")
public class UserRoleApi extends BaseApi {

    @Autowired
    private UserRoleService userRoleService;

    @RequestMapping(value = "update", method = RequestMethod.POST)
    @ResponseBody
    public Object update(@RequestBody User user) {
        userRoleService.update(user, user.getRoleList());
        return retMsg.Set(MsgType.SUCCESS);
    }
}
