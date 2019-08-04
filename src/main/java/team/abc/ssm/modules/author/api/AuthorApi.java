package team.abc.ssm.modules.author.api;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import team.abc.ssm.common.persistence.Page;
import team.abc.ssm.common.web.BaseApi;
import team.abc.ssm.common.web.MsgType;
import team.abc.ssm.modules.author.entity.Author;
import team.abc.ssm.modules.author.service.AuthorService;
import team.abc.ssm.modules.doc.entity.Copyright;
import team.abc.ssm.modules.doc.entity.Paper;
import team.abc.ssm.modules.doc.entity.Patent;
import team.abc.ssm.modules.doc.service.CopyrightService;
import team.abc.ssm.modules.doc.service.PaperSearchService;
import team.abc.ssm.modules.doc.service.PaperService;
import team.abc.ssm.modules.doc.service.PatentService;
import team.abc.ssm.modules.organization.service.CommonOrganizeService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author zm
 * @description
 * @data 2019/4/2
 */
@Controller
@RequestMapping(value = "/author")
public class AuthorApi extends BaseApi {

    private static final Logger LOG = LoggerFactory.getLogger(AuthorApi.class);

    @Autowired
    private AuthorService authorService;

    @Autowired
    private PaperSearchService paperSearchService;

    @Autowired
    private PatentService patentService;

    @Autowired
    private CopyrightService copyrightService;

    @Autowired
    private CommonOrganizeService orgService;

    /**
     * @param []
     * @return org.springframework.web.servlet.ModelAndView
     * @Description 跳转到作者查询页面
     * @author zm
     * @date 18:10 2019/5/8
     */
    @RequestMapping(value = "goAuthorSearch",method = RequestMethod.GET)
    public ModelAndView goAuthorSearch (){
        ModelAndView modelAndView = new ModelAndView();

        modelAndView.setViewName("functions/author/authorSearch");

        List<Map<String, String>> paperType = paperSearchService.getPaperType();

        List<String> orgList = orgService.getOrgList();

        List<String> subjectList = authorService.getSubList();

        modelAndView.addObject("paperType", JSONArray.fromObject(paperType));
        modelAndView.addObject("orgList", JSONArray.fromObject(orgList));
        modelAndView.addObject("subjectList", JSONArray.fromObject(subjectList));

        return modelAndView;
    }

    /**
     * @param [authorId, modelAndView]
     * @return org.springframework.web.servlet.ModelAndView
     * @Description 跳转到作者详情页面
     * @author zm
     * @date 15:16 2019/4/23
     */
    @RequestMapping(value = "goAuthorDetail", method = RequestMethod.GET)
    public ModelAndView goAuthorDetail(
                    @RequestParam("authorId") String authorId,
            ModelAndView modelAndView
    ) {
        modelAndView.setViewName("functions/author/authorInfo");
        Author authorNow = authorService.getAuthor(authorId);
        modelAndView.addObject("author", authorNow);
        return modelAndView;
    }

    /**
     * @param [authorId]
     * @return java.lang.Object
     * @Description 加载作者详情页面的内容
     * @author zm
     * @date 14:40 2019/4/23
     */
    @RequestMapping(value = "getAuthorDetail", method = RequestMethod.POST)
    public Object getAuthorDetail(
            @RequestParam("authorId") String authorId,
            @RequestParam("paperPage") Page<Paper> paperPage,
            @RequestParam("patentPage") Page<Patent> patentPage,
            @RequestParam("copyrightPage") Page<Copyright> copyrightPage
    ) {
        Author authorNow = authorService.getAuthor(authorId);
        Page<Author> authorPage = new Page<>();
        authorNow.setPage(authorPage);

        /*获取集合*/
        List<Paper> myPaperList = paperSearchService.getMyPaperByPage(authorNow);
        List<Patent> myPatentList = patentService.getMyPatentByPage(authorNow);
        List<Copyright> myCopyrightList = copyrightService.getMyCopyByPage(authorNow);

        /*设置分页中的数据内容*/
        paperPage.setResultList(myPaperList);
        patentPage.setResultList(myPatentList);
        copyrightPage.setResultList(myCopyrightList);

        /*设置数目*/
        paperPage.setTotal(paperSearchService.getMyPaperAmount(authorId));
        patentPage.setTotal(patentService.getMyPatentAmount(authorId));
        copyrightPage.setTotal(copyrightService.getMyCopyAmount(authorId));

        HashMap<String, Page<?>> pageMap = new HashMap<>();

        pageMap.put("paper", paperPage);
        pageMap.put("patent", patentPage);
        pageMap.put("copyright", copyrightPage);

        //return "functions/author/authorIWnfo";
        return retMsg.Set(MsgType.SUCCESS, pageMap);
    }

    /**
     * @param [author]
     * @return java.lang.Object
     * @author zm 按页查询作者
     * @date 2019/4/22
     */
    @RequestMapping(value = "/getAuthorListByPage", method = RequestMethod.POST)
    @ResponseBody
    public Object getAuthorListByPage(
            @RequestBody Author author
    ) {
        Page<Author> data = new Page<>();
        List<Author> authorList = authorService.getAuthorList(author);
        //设置返回的authorList信息
        data.setResultList(authorList);
        int authorNum = authorService.getAuthorListCount(author);
        //设置查询出的作者总数
        data.setTotal(authorNum);
        return retMsg.Set(MsgType.SUCCESS, data, "getAuthorListByPage-ok");
    }
}
