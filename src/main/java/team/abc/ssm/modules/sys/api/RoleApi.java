package team.abc.ssm.modules.sys.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import team.abc.ssm.common.web.BaseApi;
import team.abc.ssm.common.web.MsgType;
import team.abc.ssm.modules.sys.entity.Role;
import team.abc.ssm.modules.sys.service.RoleService;

import java.util.List;

/**
 * insertOrUpdate
 * deleteListByIds
 * update
 * selectIdList2
 * selectAllList
 */
@Controller
@RequestMapping("api/sys/role")
public class RoleApi extends BaseApi {

    @Autowired
    private RoleService roleService;

    @RequestMapping(value = "insert", method = RequestMethod.POST)
    @ResponseBody
    public Object insert(@RequestBody Role role){
        roleService.insert(role);
        return retMsg.Set(MsgType.SUCCESS);
    }

    @RequestMapping(value = "deleteListByIds", method = RequestMethod.POST)
    @ResponseBody
    public Object deleteListByIds(@RequestBody List<Role> roleList) {
        roleService.deleteListByIds(roleList);
        return retMsg.Set(MsgType.SUCCESS);
    }

    @RequestMapping(value = "update", method = RequestMethod.POST)
    @ResponseBody
    public Object update(@RequestBody Role role) {
        roleService.update(role);
        return retMsg.Set(MsgType.SUCCESS);
    }

    @RequestMapping(value = "selectListByPage", method = RequestMethod.POST)
    @ResponseBody
    public Object selectListByPage(@RequestBody Role role) {
        return retMsg.Set(MsgType.SUCCESS, roleService.getByPage(role.getPage()));
    }

    @RequestMapping(value = "selectAllList", method = RequestMethod.POST)
    @ResponseBody
    public Object selectAllList() {
        return retMsg.Set(MsgType.SUCCESS, roleService.getAllRoles());
    }

}
