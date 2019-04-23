package team.abc.ssm.modules.author.api;

import net.sf.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
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

import java.util.HashMap;
import java.util.List;

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
    AuthorService authorService;

    @Autowired
    PaperSearchService paperSearchService;

    @Autowired
    PatentService patentService;

    @Autowired
    CopyrightService copyrightService;

    /**
     * @author zm
     * @date 2019/4/23
     * @param [authorId, model]
     * @return java.lang.String
     */
    @RequestMapping(value = "getAuthorDetail",method = RequestMethod.GET)
    public String getAuthorDetail(
            @RequestParam("authorId") String authorId,
            Model model
    ){
        Author authorNow = authorService.getAuthor(authorId);

        Page<Paper> paperPage = new Page<>();
        Page<Patent> patentPage = new Page<>();
        Page<Copyright> copyrightPage = new Page<>();

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

        model.addAttribute("paperPage",paperPage);
        model.addAttribute("patentPage",patentPage);
        model.addAttribute("copyrightPage",copyrightPage);

        return "functions/author/authorInfo";
    }

    /**
     * @author zm 按页查询作者
     * @date 2019/4/22
     * @param [author]
     * @return java.lang.Object
     */
    @RequestMapping(value = "/getAuthorListByPage",method = RequestMethod.POST)
    @ResponseBody
    public Object getAuthorListByPage(
            @RequestBody Author author
    ){
        Page<Author> data = new Page<>();
        List<Author> authorList = authorService.getAuthorList(author);
        data.setResultList(authorList);
        LOG.info("查询的作者信息："+authorList);

        int authorNum = authorService.getAuthorListCount(author);
        data.setTotal(authorNum);

        LOG.info("查询的作者个数："+authorNum);
        return retMsg.Set(MsgType.SUCCESS,data,"getAuthorListByPage-ok");

    }

    /*old*/
    @RequestMapping(value = "/getAuthorListByPage1",method = RequestMethod.POST)
    @ResponseBody
    public Object getAuthorListByPage1(String jsonStr){

        JSONObject paramsJsonObject = JSONObject.fromObject(jsonStr);

        Author tmpAuthor = new Author();
        tmpAuthor.setUserType(paramsJsonObject.getString("identity"));
        tmpAuthor.setWorkId(paramsJsonObject.getString("workNum"));
        tmpAuthor.setSubjectId(paramsJsonObject.getString("subject"));              //传过来的是subject的id
        tmpAuthor.setOrganizationId(paramsJsonObject.getString("organization"));    //传过来的是org的ID

        Page<Author> authorPage = new Page<>();

        authorPage.setPageIndex(paramsJsonObject.getInt("pageIndex"));
        authorPage.setPageSize(paramsJsonObject.getInt("pageSize"));

        /*添加分页数据*/
        tmpAuthor.setPage(authorPage);
        System.out.println(tmpAuthor.toString());
        System.out.println(tmpAuthor.getPage());

        List<Author> authorList = authorService.getAuthorList(tmpAuthor);
//
//        System.out.println("作者列表：");
//        System.out.println(authorList);
        LOG.info("作者列表："+authorList);
        return retMsg.Set(MsgType.SUCCESS,authorList);
    }
}
