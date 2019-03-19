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
 * getAllList       获取所有角色列表
 * getListByPage    分页查询角色
 * deleteByIdList   通过id批量删除
 * put              添加角色
 */
@Controller
@RequestMapping("api/sys/role")
public class RoleApi extends BaseApi {

    @Autowired
    private RoleService roleService;

    @RequestMapping(value = "getAllList", method = RequestMethod.POST)
    @ResponseBody
    public Object getAllList() {
        return retMsg.Set(MsgType.SUCCESS, roleService.getAllRoles());
    }

    @RequestMapping(value = "getListByPage", method = RequestMethod.POST)
    @ResponseBody
    public Object getListByPage(@RequestBody Role role) {
        return retMsg.Set(MsgType.SUCCESS, roleService.getByPage(role.getPage()));
    }

    @RequestMapping(value = "deleteByIdList", method = RequestMethod.POST)
    @ResponseBody
    public Object deleteByIdList(@RequestBody List<Role> roleList) {
        return retMsg.Set(MsgType.SUCCESS);
    }

    @RequestMapping(value = "put", method = RequestMethod.POST)
    @ResponseBody
    public Object put(@RequestBody Role role){
        roleService.insert(role);
        return retMsg.Set(MsgType.SUCCESS);
    }
}
