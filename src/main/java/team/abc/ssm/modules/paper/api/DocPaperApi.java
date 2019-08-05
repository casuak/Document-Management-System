package team.abc.ssm.modules.paper.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import team.abc.ssm.common.persistence.Page;
import team.abc.ssm.common.web.BaseApi;
import team.abc.ssm.common.web.MsgType;
import team.abc.ssm.modules.paper.entity.DocPaper;
import team.abc.ssm.modules.paper.service.DocPaperService;

import java.util.List;

/**
 * @ClassName DocPaperApi
 * @Description TODO
 * @Author zm
 * @Date 2019/8/5 11:15
 * @Version 1.0
 **/
@Controller
@RequestMapping("/api/paper")
public class DocPaperApi extends BaseApi {
    @Autowired
    private DocPaperService docPaperService;

    /**
     * 获取制定作者下的所有论文List
     * 1.传入参数的
     *
     * @author zm
     * @param1 paper
     * @return java.lang.Object
     * @date 2019/8/5 11:18
     **/
    @RequestMapping(value = "selectMyPaperByPage",method = RequestMethod.POST)
    @ResponseBody
    public Object selectMyPaperByPage(
            @RequestBody DocPaper docPaper
    ){
        //1.获取当前用户的全部的论文List(根据作者工号，论文状态，以及page分页信息)
        List<DocPaper> myPaperList = docPaperService.selectMyPatentListByPage(docPaper);

        //2.获取当前作者论文总数(根据作者工号)
        int myPaperNum = docPaperService.getMyPaperNum(docPaper.getTheAuthorWorkId());

        Page<DocPaper> paperResPage = new Page<>();
        paperResPage.setResultList(myPaperList);
        paperResPage.setTotal(myPaperNum);


        System.out.println("------我的paper------");
        System.out.println(myPaperList);

        /*String authorId = paper.getAuthorList();
        Author authorNow = authorService.getAuthor(authorId);
        Page page=paper.getPage();
        int pageStart=(page.getPageIndex()-1)*page.getPageSize();
        page.setPageStart(pageStart);
        //设置当前作者的论文Page
        authorNow.setPage(page);
        List<Paper> paperList = paperSearchService.getMyPaperByPage(authorNow);
        paperResPage.setTotal(paperSearchService.getMyPaperCount(authorNow));*/

        return retMsg.Set(MsgType.SUCCESS,paperResPage);
    }
}
