package team.abc.ssm.modules.web;

import net.sf.json.JSONObject;
import org.apache.http.HttpRequest;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import team.abc.ssm.common.web.AjaxMessage;
import team.abc.ssm.common.web.BaseController;
import team.abc.ssm.common.web.MsgType;
import team.abc.ssm.modules.doc.entity.Statistics;
import team.abc.ssm.modules.doc.service.PaperSearchService;

import java.util.Date;
import java.util.Map;

@Controller
public class ViewController extends BaseController {

    @Autowired
    private PaperSearchService paperSearchService;

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
    public ModelAndView doc_paperUserMatch_searchUser(
            @RequestParam("paperId") String paperId,
            @RequestParam("authorIndex") int authorIndex,
            @RequestParam("searchKey") String searchKey,
            @RequestParam("school") String school,
            @RequestParam("publishDate") Long publishDate,
            @RequestParam("workId") String workId) {
        ModelAndView mv = new ModelAndView("functions/doc/paperUserMatch/searchUser");
        mv.addObject("paperId", paperId);
        mv.addObject("authorIndex", authorIndex);
        mv.addObject("searchKey", searchKey);
        mv.addObject("school", school);
        mv.addObject("publishDate", publishDate);
        mv.addObject("workId", workId);
        return mv;
    }

    @RequestMapping(value = "functions/patent/searchUser", method = RequestMethod.GET)
    public ModelAndView patentUserSearch(
            @RequestParam("patentId") String patentId,
            @RequestParam("authorIndex") int authorIndex,
            @RequestParam("searchKey") String searchKey,
            @RequestParam("institute") String institute,
            @RequestParam("authorizationDate") String authorizationDate,
            @RequestParam("workId") String workId) {
        System.out.println("lalalalal   ");
        ModelAndView mv = new ModelAndView("functions/patent/searchUser");
        mv.addObject("patentId", patentId);
        mv.addObject("authorIndex", authorIndex);
        mv.addObject("searchKey", searchKey);
        mv.addObject("institute", institute);
        mv.addObject("authorizationDate", authorizationDate);
        mv.addObject("workId", workId);
        return mv;
    }

    /**
     * @author zm
     * @date 2019/7/3 8:47
     * @params []
     * @return: java.lang.String
     * @Description //跳转到：专利用户匹配
     **/
    @RequestMapping(value = "functions/patent/patentUserMatch",method = RequestMethod.GET)
    public String patentUserMatch(){
        return "functions/patent/patentUserMatch";
    }

    /**
     * 统计查询
     *
     * @author zm
     * @date 2019/4/16
     */
    @RequestMapping(value = "doc/statisticalSearch", method = RequestMethod.POST)
    @ResponseBody
    public Object statisticalSearch(
            @RequestParam("subject") String subject,
            @RequestParam("organization") String organization,
            @RequestParam("startDate") Date startDate,
            @RequestParam("endDate") Date endDate,
            @RequestParam("paperType") String paperType,
            @RequestParam("partition") String partition,
            @RequestParam("impactFactor") Integer impactFactor,
            @RequestParam("patentType")String patentType

    ) {
        System.out.println(organization);
        System.out.println(startDate);
        System.out.println(endDate);
        System.out.println(paperType);
        System.out.println(partition);
        System.out.println(impactFactor);
        System.out.println(patentType);

        // 暂时没有影响因子
        try {
            Map<String,Statistics> stasticResMap = paperSearchService.getStatisticRes(subject,organization, startDate, endDate, paperType, partition,patentType);

            return new AjaxMessage().Set(MsgType.SUCCESS, stasticResMap,"获取统计结果成功");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return new AjaxMessage().Set(MsgType.ERROR, null);
    }
}
