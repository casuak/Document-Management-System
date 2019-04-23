package team.abc.ssm.modules.web;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import team.abc.ssm.common.web.BaseController;

@Controller
public class ViewController extends BaseController {

    /**
     * 常规页
     **/
    @RequestMapping(value = "", method = RequestMethod.GET)
    public String index() {
        return "functions/frame";
    }

    @RequestMapping(value = "functions/home", method = RequestMethod.GET)
    public String home() {
        return "functions/home";
    }

    @RequestMapping(value = "login", method = RequestMethod.GET)
    public String login() {
        return "login2";
    }

    @RequestMapping(value = "register", method = RequestMethod.GET)
    public String register() {
        return "register";
    }

    @RequestMapping(value = "403", method = RequestMethod.GET)
    public String _403() {
        return "403";
    }

    /**
     * 系统功能
     **/
    @RequestMapping(value = "functions/sys/userManager", method = RequestMethod.GET)
    @RequiresPermissions("sys:user")
    public String sys_user() {
        return "functions/sys/userManager";
    }

    @RequestMapping(value = "functions/sys/roleManager", method = RequestMethod.GET)
    @RequiresPermissions("sys:role")
    public String sys_role() {
        return "functions/sys/roleManager";
    }

    @RequestMapping(value = "functions/sys/functionManager", method = RequestMethod.GET)
    @RequiresPermissions("sys:function")
    public String sys_function() {
        return "functions/sys/functionManager";
    }

    @RequestMapping(value = "functions/sys/dictManager", method = RequestMethod.GET)
    @RequiresPermissions("sys:dict")
    public String sys_dict() {
        return "functions/sys/dictManager";
    }

    @RequestMapping(value = "functions/sys/dictTypeManager", method = RequestMethod.GET)
    @RequiresPermissions("sys:dict")
    public String sys_dictType() {
        return "functions/sys/dictTypeManager";
    }

    /**
     * 工具箱
     **/
    @RequestMapping(value = "functions/tools/importExcel", method = RequestMethod.GET)
    public String tool_importExcel() {
        return "functions/tool/importExcel";
    }

    // excel导入的两个子页面
    @RequestMapping(value = "functions/tool/importExcel/importData", method = RequestMethod.GET)
    public String tool_importExcel_importData() {
        return "functions/tool/importExcel/importData";
    }

    @RequestMapping(value = "functions/tool/importExcel/templateManager", method = RequestMethod.GET)
    public String tool_importExcel_templateManager() {
        return "functions/tool/importExcel/templateManager";
    }

    @RequestMapping(value = "functions/tool/importExcel/insertOrUpdateTemplate", method = RequestMethod.GET)
    public ModelAndView tool_importExcel_insertOrUpdateTemplate(
            @RequestParam("status") String status,
            @RequestParam("templateId") String templateId) {
        ModelAndView mv = new ModelAndView("functions/tool/importExcel/insertOrUpdateTemplate");
        mv.addObject("status", status);
        mv.addObject("templateId", templateId);
        return mv;
    }

    /**
     * 文献管理
     */
    @RequestMapping(value = "functions/doc/paperManager", method = RequestMethod.GET)
    public String doc_paperManager() {
        return "functions/doc/paperManager";
    }

    @RequestMapping(value = "functions/doc/paperUserMatch", method = RequestMethod.GET)
    public String doc_paperUserMatch() {
        return "functions/doc/paperUserMatch";
    }

    @RequestMapping(value = "functions/doc/paperUserMatch/searchUser", method = RequestMethod.GET)
    public String doc_paperUserMatch_searchUser() {
        return "functions/doc/paperUserMatch/searchUser";
    }

}
