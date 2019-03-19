package team.abc.ssm.modules.sys.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import team.abc.ssm.common.web.BaseApi;
import team.abc.ssm.common.web.MsgType;
import team.abc.ssm.modules.sys.entity.Function;
import team.abc.ssm.modules.sys.entity.Role;
import team.abc.ssm.modules.sys.entity.User;
import team.abc.ssm.modules.sys.service.FunctionService;

import java.util.List;

/**
 * getCategoryList          获取分类列表（按顺序，内含子功能，也按顺序）
 * getCategoryListByUser    获取用户的分类列表（按顺序，内含子功能，也按顺序）frame初始化时调用
 * getCategoryListByRole    获取角色的分类列表（按顺序，内含子功能，也按顺序）角色管理时调用
 * appendFunction           在传入的category的functionList的末尾添加一个新功能
 * appendCategory           在categoryList末尾添加一个新分类，index包含在传入的category中，无需查询数据库
 * delete                   删除（传入的参数可以是分类列表或功能列表，要删除的对象放在第一个，
 * ...                      后续的将被更新index，index在前端更新好）
 * update                   更新
 * updateCategoryList       参数为一个分类列表，更新所有分类以及包含的所有子功能（index更新）
 */
@Controller
@RequestMapping("api/sys/function")
public class FunctionApi extends BaseApi {
    @Autowired
    private FunctionService functionService;

    @RequestMapping(value = "getCategoryList", method = RequestMethod.POST)
    @ResponseBody
    public Object getCategoryList() {
        List<Function> categoryList = functionService.getFunctionTree(null, null);
        return retMsg.Set(MsgType.SUCCESS, categoryList);
    }

    @RequestMapping(value = "getCategoryListByUser", method = RequestMethod.POST)
    @ResponseBody
    public Object getCategoryListByUser(@RequestBody User user) {
        List<Function> categoryList = functionService.getFunctionTree(user, null);
        return retMsg.Set(MsgType.SUCCESS, categoryList);
    }

    @RequestMapping(value = "getCategoryListByRole", method = RequestMethod.POST)
    @ResponseBody
    public Object getCategoryListByRole(@RequestBody Role role) {
        List<Function> categoryList = functionService.getFunctionTree(null, role);
        return retMsg.Set(MsgType.SUCCESS, categoryList);
    }

    @RequestMapping(value = "appendFunction", method = RequestMethod.POST)
    @ResponseBody
    public Object appendFunction(@RequestBody Function category) {
        Function newFunction = functionService.addNewFunction(category);
        if (newFunction != null)
            return retMsg.Set(MsgType.SUCCESS, newFunction);
        else
            return retMsg.Set(MsgType.ERROR);
    }

    @RequestMapping(value = "appendCategory", method = RequestMethod.POST)
    @ResponseBody
    public Object appendCategory(@RequestBody Function category) {
        Function newCategory = functionService.addNewCategory(category);
        if (newCategory != null)
            return retMsg.Set(MsgType.SUCCESS, newCategory);
        else
            return retMsg.Set(MsgType.ERROR);
    }

    @RequestMapping(value = "delete", method = RequestMethod.POST)
    @ResponseBody
    public Object delete(@RequestBody List<Function> list) {
        if (functionService.delete(list))
            return retMsg.Set(MsgType.SUCCESS);
        return retMsg.Set(MsgType.ERROR);
    }

    @RequestMapping(value = "update", method = RequestMethod.POST)
    @ResponseBody
    public Object update(@RequestBody Function function) {
        if (functionService.update(function))
            return retMsg.Set(MsgType.SUCCESS);
        return retMsg.Set(MsgType.ERROR);
    }

    @RequestMapping(value = "updateCategoryList", method = RequestMethod.POST)
    @ResponseBody
    public Object updateCategoryList(@RequestBody List<Function> categoryList){
        functionService.updateCategoryList(categoryList);
        return retMsg.Set(MsgType.SUCCESS);
    }
}
