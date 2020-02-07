package team.abc.ssm.modules.tutor.api;

import net.sf.json.JSONArray;
import org.apache.http.client.utils.DateUtils;
import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.poifs.property.Parent;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authz.SimpleAuthorizationInfo;
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
import team.abc.ssm.modules.author.entity.Author;
import team.abc.ssm.modules.author.entity.AuthorStatistics;
import team.abc.ssm.modules.author.service.AuthorService;
import team.abc.ssm.modules.doc.entity.Paper;
import team.abc.ssm.modules.doc.entity.Patent;
import team.abc.ssm.modules.doc.service.PaperSearchService;
import team.abc.ssm.modules.doc.service.PatentService;
import team.abc.ssm.modules.paper.entity.DocPaper;
import team.abc.ssm.modules.paper.service.DocPaperService;
import team.abc.ssm.modules.sys.entity.User;
import team.abc.ssm.modules.sys.service.FunctionService;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.OutputStream;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
