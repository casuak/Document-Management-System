package team.abc.ssm.modules.sys.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import team.abc.ssm.common.utils.UserUtils;
import team.abc.ssm.common.web.BaseApi;
import team.abc.ssm.common.web.MsgType;
import team.abc.ssm.modules.sys.entity.User;
import team.abc.ssm.modules.sys.service.DictService;
import team.abc.ssm.modules.sys.service.UserService;
import team.abc.ssm.modules.sys.service.map.UserRoleService;

import java.util.List;

/**
 * put              添加
 * deleteList       批量删除
 * update           更新
 * getList          分页查询
 * checkUsername    校验用户名重名
 * getCurrentUser   获取当前登陆用户信息
 * login            登陆
 */
@Controller
@RequestMapping("api/sys/user")
public class UserApi extends BaseApi {

    @Autowired
    private UserService userService;

    @Autowired
    private UserRoleService userRoleService;

    @Autowired
    private DictService dictService;

    @RequestMapping(value = "put", method = RequestMethod.POST)
    @ResponseBody
    public Object put(@RequestBody User user) {
        return userService.addUser(user) ? retMsg.Set(MsgType.SUCCESS) : retMsg.Set(MsgType.ERROR);
    }

    @RequestMapping(value = "deleteList", method = RequestMethod.POST)
    @ResponseBody
    public Object deleteList(@RequestBody List<User> userList) {
        return userService.deleteUserByIds(userList) ? retMsg.Set(MsgType.SUCCESS) : retMsg.Set(MsgType.ERROR);
    }

    @RequestMapping(value = "update", method = RequestMethod.POST)
    @ResponseBody
    public Object update(@RequestBody User user) {
        if (userService.update(user))
            return retMsg.Set(MsgType.SUCCESS);
        return retMsg.Set(MsgType.ERROR);
    }

    @RequestMapping(value = "initUser", method = RequestMethod.POST)
    @ResponseBody
    public Object initUser(){
        userService.initUser();
        return retMsg.Set(MsgType.SUCCESS);
    }

    @RequestMapping(value = "getList", method = RequestMethod.POST)
    @ResponseBody
    public Object getList(@RequestBody User user) {
        return retMsg.Set(MsgType.SUCCESS, userService.getUsersByPage(user));
    }

    // 复杂搜索
    @RequestMapping(value = "selectListByPage", method = RequestMethod.POST)
    @ResponseBody
    public Object selectListByPage(@RequestBody User user){
        return retMsg.Set(MsgType.SUCCESS, userService.selectListByPage2(user));
    }

    @RequestMapping(value = "checkUsername", method = RequestMethod.POST)
    @ResponseBody
    public Object checkUsername(@RequestBody User user) {
        if (userService.isUsernameExist(user)) {
            return retMsg.Set(MsgType.ERROR);
        }
        return retMsg.Set(MsgType.SUCCESS);
    }

    @RequestMapping(value = "getCurrentUser", method = RequestMethod.POST)
    @ResponseBody
    public Object getCurrentUser() {
        return retMsg.Set(MsgType.SUCCESS, UserUtils.getCurrentUser());
    }

    /**
     * @author zm
     * @date 2019/7/5 14:16
     * @params [user]
     * @return: java.lang.Object
     * @Description //复杂搜索：专利匹配搜索用户时使用
     **/
    @RequestMapping(value = "selectUserListByPage", method = RequestMethod.POST)
    @ResponseBody
    public Object selectUserListByPage(@RequestBody User user){
        return retMsg.Set(MsgType.SUCCESS, userService.selectUserListByPage(user));
    }

    @RequestMapping(value = "getSchoolList",method = RequestMethod.POST)
    @ResponseBody
    public Object getSchoolList(){
        return retMsg.Set(MsgType.SUCCESS,dictService.getSchoolList());
    }

    @RequestMapping(value = "getMajorList",method = RequestMethod.POST)
    @ResponseBody
    public Object getMajorList(){
        return retMsg.Set(MsgType.SUCCESS,dictService.getMajorList());
    }
}
