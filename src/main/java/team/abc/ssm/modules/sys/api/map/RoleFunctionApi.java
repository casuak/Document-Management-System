package team.abc.ssm.modules.sys.api.map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import team.abc.ssm.common.web.BaseApi;
import team.abc.ssm.common.web.MsgType;
import team.abc.ssm.modules.sys.entity.Role;
import team.abc.ssm.modules.sys.service.map.RoleFunctionService;

/**
 * update       更新此关联的唯一用户接口是角色管理页面，一次性会更新多个关联
 * ...          方便起见采用先删除此角色与功能的所有关联，再进行添加
 */
@Controller
@RequestMapping("api/sys/map/roleFunction")
public class RoleFunctionApi extends BaseApi {

    @Autowired
    private RoleFunctionService roleFunctionService;

    @RequestMapping(value = "update", method = RequestMethod.POST)
    @ResponseBody
    public Object update(@RequestBody Role role) {
        roleFunctionService.updateByRole(role);
        return retMsg.Set(MsgType.SUCCESS);
    }
}
