package team.abc.ssm.modules.doc.api;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import team.abc.ssm.common.persistence.Page;
import team.abc.ssm.common.web.AjaxMessage;
import team.abc.ssm.common.web.MsgType;
import team.abc.ssm.modules.author.service.AuthorService;
import team.abc.ssm.modules.doc.entity.Paper;
import team.abc.ssm.modules.doc.service.PaperSearchService;
import team.abc.ssm.modules.organization.service.CommonOrganizeService;
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
    private CommonOrganizeService orgService;

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

        List<Map<String, String>> paperType = paperSearchService.getPaperType();
        List<Map<String,String>> orgList = orgService.getOrgListMap();

        modelAndView.addObject("paperType", JSONArray.fromObject(paperType));
        modelAndView.addObject("orgList", JSONArray.fromObject(orgList));
        return modelAndView;
    }

    /*跳转文献详情页面*/
    @RequestMapping(value = "docDetails",method = RequestMethod.GET)
    public ModelAndView docDetails(){
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("functions/doc/docSearch/docDetails");
        return modelAndView;
    }

    /*跳转论文详情页面*/
    @RequestMapping(value = "paperDetails",method = RequestMethod.GET)
    public ModelAndView paperDetails(
            ModelAndView modelAndView,
            @RequestParam(value = "id") String paperId){
        Paper resPaper = paperSearchService.getPaperById(paperId);
        modelAndView.setViewName("functions/doc/docSearch/docDetails");
        modelAndView.addObject("paperObj",resPaper);
        modelAndView.addObject("isPaper",true);
        return modelAndView;
    }

    /*根据条件返回相应的论文+专利+著作权的列表*/
    @RequestMapping(value = "getDocList", method = RequestMethod.POST)
    @ResponseBody
    public Object getDocList(
            HttpServletRequest request, HttpServletResponse response
    ) {
        //论文查询参数
        String paperName = request.getParameter("paperName");
        String firstAuthorWorkNum = request.getParameter("firstAuthorWorkNum");
        String secondAuthorWorkNum = request.getParameter("secondAuthorWorkNum");
        String otherAuthorWorkNum = request.getParameter("otherAuthorWorkNum");
        String ISSN = request.getParameter("ISSN");
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
                "", "", "", "", "", "", "", 10, 10
        );
        System.out.println(paperList);
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

    /*按页返回paper项(不包含搜索参数)*/
    @RequestMapping(value = "selectPaperListByPagePost",method = RequestMethod.POST)
    @ResponseBody
    public Object selectListByPagePost(
            @RequestBody Paper paper
    ){
        /*参数解析*/
        String paperName = paper.getPaperName();
        String firstAuthorWorkNum = paper.getFirstAuthorName();
        String secondAuthorWorkNum = paper.getSecondAuthorName();
        String otherAuthorWorkNum = paper.getAuthorList();
        String ISSN = paper.getISSN();
        String storeNum = paper.getStoreNum();
        String docType = paper.getDocType();
        Page<Paper> page = paper.getPage();

        List<Paper> paperList = paperSearchService.getPaperListByPage(paperName,firstAuthorWorkNum,secondAuthorWorkNum,otherAuthorWorkNum,ISSN,storeNum,docType,page);

        int paperAmount = paperSearchService.getPaperAmount();

        HashMap<String,Object> resDataMap = new HashMap<>();
        resDataMap.put("paperList",paperList);
        resDataMap.put("paperAmount",paperAmount);
        System.out.println("resDataMap: "+ resDataMap);

        AjaxMessage retMsg = new AjaxMessage();
        return retMsg.Set(MsgType.SUCCESS,resDataMap);
    }

    /*查看论文统计详情*/
    @RequestMapping(value = "selectPaperListByPageGet",method = RequestMethod.GET)
    @ResponseBody
    public Object selectPaperListByPageGet(
            @RequestParam(value = "paperName") String paperName,
            @RequestParam(value = "firstAuthorName") String firstAuthorWorkNum,
            @RequestParam(value = "secondAuthorName") String secondAuthorWorkNum,
            @RequestParam(value = "authorList") String otherAuthorWorkNum,
            @RequestParam(value = "ISSN") String ISSN,
            @RequestParam(value = "storeNum") String storeNum,
            @RequestParam(value = "paperType") String paperType,
            @RequestParam(value = "pageIndex") int pageIndex,
            @RequestParam(value = "pageSize") int pageSize
    ){
        System.out.println("ISSN"+ISSN);
        ModelAndView modelAndView = new ModelAndView();
        Map<String,Object> commonParams = new HashMap<>();
        Map<String,Object> paperParams = new HashMap<>();

        paperParams.put("paperName",paperName);
        paperParams.put("firstAuthorWorkNum",firstAuthorWorkNum);
        paperParams.put("secondAuthorWorkNum",secondAuthorWorkNum);
        paperParams.put("otherAuthorWorkNum",otherAuthorWorkNum);
        paperParams.put("ISSN",ISSN);
        paperParams.put("storeNum",storeNum);
        paperParams.put("paperType",paperType);

        Page<Paper> tmpPage = new Page<>();
        tmpPage.setPageIndex(pageIndex);
        tmpPage.setPageSize(pageSize);

        List<Paper> paperList = paperSearchService.getPaperListByPage(paperName,firstAuthorWorkNum,secondAuthorWorkNum,
                otherAuthorWorkNum,ISSN,storeNum,paperType,tmpPage);
        int paperAmount = paperSearchService.getPaperAmount();
        List<Map<String, String>> paperTypeOption = paperSearchService.getPaperType();

        modelAndView.setViewName("functions/doc/docManage/paperList");
        modelAndView.addObject("paperList",paperList);
        modelAndView.addObject("paperAmount",paperAmount);
        modelAndView.addObject("paperType", JSONArray.fromObject(paperTypeOption));
        modelAndView.addObject("paperParams",JSONObject.fromObject(paperParams));

        return modelAndView;
    }

    /*查看专利统计详情*/
    @RequestMapping(value = "selectPatentListByPageGet",method = RequestMethod.GET)
    public Object selectPatentListByPageGet(){
        return  null;
    }

    /*查看著作权统计详情*/
    @RequestMapping(value = "selectCopyrightListByPageGet",method = RequestMethod.GET)
    public Object selectCopyrightListByPageGet(){
        return  null;
    }
}
