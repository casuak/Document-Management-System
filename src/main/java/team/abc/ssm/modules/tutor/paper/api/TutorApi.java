package team.abc.ssm.modules.tutor.paper.api;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import team.abc.ssm.common.persistence.Page;
import team.abc.ssm.common.web.BaseApi;
import team.abc.ssm.common.web.MsgType;
import team.abc.ssm.modules.document.authorSearch.entity.Author;
import team.abc.ssm.modules.document.authorSearch.service.AuthorService;
import team.abc.ssm.modules.document.docStatistics.entity.DocPaper;
import team.abc.ssm.modules.document.docStatistics.service.DocPaperService;
import team.abc.ssm.modules.sys.entity.User;

import java.util.List;

@Controller
@RequestMapping(value = "/tutor")
public class TutorApi extends BaseApi {

    private static final Logger LOG = LoggerFactory.getLogger(TutorApi.class);

    @Autowired
    private AuthorService authorService;

    @Autowired
    private DocPaperService docPaperService;


    @RequestMapping(value = "goTutorPaper",method = RequestMethod.GET)
    public ModelAndView goAuthorSearch (){
        Subject subject = SecurityUtils.getSubject();
        User user = (User) subject.getSession().getAttribute("user");
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("functions/tutor/paper");
        Author authorNow = authorService.getAuthor(user.getWorkId());
        modelAndView.addObject("author", authorNow);
        return modelAndView;
    }

    @RequestMapping(value = "selectMyPaperByPage", method = RequestMethod.POST)
    @ResponseBody
    public Object selectMyPaperByPage(
            @RequestBody DocPaper docPaper
    ) {
        //1.获取当前用户的全部的论文List(根据作者工号，论文状态，以及page分页信息)
        List<DocPaper> myPaperList = docPaperService.selectMyPaperListByPage(docPaper);
        //2.获取当前作者论文总数(根据作者工号)
        int myPaperNum = docPaperService.getMyPaperNum(docPaper.getTheAuthorWorkId());

        Page<DocPaper> paperResPage = new Page<>();
        paperResPage.setResultList(myPaperList);
        paperResPage.setTotal(myPaperNum);
        return retMsg.Set(MsgType.SUCCESS, paperResPage);
    }






}
