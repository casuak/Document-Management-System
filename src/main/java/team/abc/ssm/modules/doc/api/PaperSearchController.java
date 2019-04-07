package team.abc.ssm.modules.doc.api;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import team.abc.ssm.common.web.AjaxMessage;
import team.abc.ssm.common.web.MsgType;
import team.abc.ssm.modules.author.service.AuthorService;
import team.abc.ssm.modules.doc.entity.Paper;
import team.abc.ssm.modules.doc.service.PaperSearchService;
import team.abc.ssm.modules.sys.entity.User;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author zm
 * @description 查询论文的相关接口
 * @data 2019/3/26
 */
@Controller
@RequestMapping(value = "api/doc/search")
public class PaperSearchController {

    @Autowired
    private AuthorService authorService;

    @Autowired
    private PaperSearchService paperSearchService;

    /*初始化作者查询页面*/
    @RequestMapping(value = "authorInitial", method = RequestMethod.GET)
    public ModelAndView authorInitial() {
        List<User> users = authorService.getDefaultUserList();
        System.out.println(users);

        ModelAndView modelAndView = new ModelAndView();

        modelAndView.addObject("users", users);
        modelAndView.setViewName("functions/doc/authorSearch");
        return modelAndView;
    }

    /*初始化文献管理页面*/
    @RequestMapping(value = "docInitial", method = RequestMethod.GET)
    public ModelAndView docInitial() {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("functions/doc/docSearch");
        return modelAndView;
    }

    /*跳转当前用户文献列表页面*/
    @RequestMapping(value = "searchDocList", method = RequestMethod.GET)
    public String searchDocList() {
        System.out.println("ok");
        return "functions/doc/paperUserSearch/userPaper";
    }

    /*根据条件返回相应的论文+专利+著作权的列表*/
    @RequestMapping(value = "getDocList", method = RequestMethod.POST)
    @ResponseBody
    public Object getDocList(
            HttpServletRequest request, HttpServletResponse response
    ) {
        //论文查询参数
        String paperName = request.getParameter("paperName");
        String firstAuthor = request.getParameter("firstAuthor");
        String secondAuthor = request.getParameter("secondAuthor");
        String otherAuthor = request.getParameter("otherAuthor");
        String journalNum = request.getParameter("journalNum");
        String storeNum = request.getParameter("storeNum");
        String docType = request.getParameter("docType");
        int paperPageIndex = Integer.parseInt(request.getParameter("paperPageIndex"));
        int paperPageSize = Integer.parseInt(request.getParameter("paperPageSize"));

        //专利参数
        String applicationNum = request.getParameter("applicationNum");
        String publicNum = request.getParameter("publicNum");
        String countryCode = request.getParameter("countryCode");
        int patentPageIndex = Integer.parseInt(request.getParameter("patentPageIndex"));
        int patentPageSize = Integer.parseInt(request.getParameter("patentPageSize"));

        //著作权参数
        String copySubject = request.getParameter("copySubject");
        String copyType = request.getParameter("copyType");
        int copyPageIndex = Integer.parseInt(request.getParameter("copyPageIndex"));
        int copyPageSize = Integer.parseInt(request.getParameter("copyPageSize"));


        List<Paper> paperList = paperSearchService.getPaperList(
                paperName,firstAuthor,secondAuthor,otherAuthor,journalNum,storeNum,docType,paperPageIndex,paperPageSize
        );

        //请求返回体：
        AjaxMessage retMsg = new AjaxMessage();
        return retMsg.Set(MsgType.SUCCESS, "hello");
    }

    //for zm to test
    @RequestMapping(value = "test", method = RequestMethod.GET)
    @ResponseBody
    public Object test(@RequestParam(value = "id") String id,
                       @RequestParam(value = "name") String name) {

        System.out.println("ok");
        Map<String, String> paperMap = new HashMap<>();
        paperMap.put("name", "papername1");
        paperMap.put("firstAuthor", "第一作者1");
        paperMap.put("secondAuthor", "第二作者2");

        Map<String, String> patentMap = new HashMap();
        patentMap.put("name", "patentname1");
        patentMap.put("patentType", "专利类型1");

        Map<String, Map> resMap = new HashMap();

        resMap.put("paper", paperMap);
        resMap.put("patent", patentMap);

        System.out.println(resMap);

        AjaxMessage retMsg = new AjaxMessage();

        return retMsg.Set(MsgType.SUCCESS, resMap);

    }

}
