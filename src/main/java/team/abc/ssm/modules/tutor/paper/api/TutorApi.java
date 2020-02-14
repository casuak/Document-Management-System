package team.abc.ssm.modules.tutor.paper.api;

import net.sf.json.JSONArray;
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
import team.abc.ssm.modules.sys.entity.User;
import team.abc.ssm.modules.tutor.paper.entity.ClaimPaper;
import team.abc.ssm.modules.tutor.paper.entity.TutorPaper;
import team.abc.ssm.modules.tutor.paper.service.TutorService;

import java.util.List;

@Controller
@RequestMapping(value = "/tutor")
public class TutorApi extends BaseApi {

    private static final Logger LOG = LoggerFactory.getLogger(TutorApi.class);

    @Autowired
    private AuthorService authorService;

    @Autowired
    private TutorService tutorService;

     /**
          * @Description  跳转至导师名下论文页面
          * @author wh
          * @date 2020/2/9 14:04
          */
    @RequestMapping(value = "goTutorPaper",method = RequestMethod.GET)
    public ModelAndView goTutorPaper (){
        Subject subject = SecurityUtils.getSubject();
        User user = (User) subject.getSession().getAttribute("user");
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("functions/tutor/consult/paper");
        Author authorNow = authorService.getAuthor(user.getId());
        modelAndView.addObject("author", authorNow);
        return modelAndView;
    }
    /**
     * @Description  跳转至查找论文页面
     * @author wh
     * @date 2020/2/9 14:04
     */
    @RequestMapping(value = "goTutorPaperMatch",method = RequestMethod.GET)
    public ModelAndView goTutorPaperMatch (){
        ModelAndView modelAndView = new ModelAndView();
        //获取机构(学院)类别
        List<String> orgList = tutorService.getOrgList();
        modelAndView.addObject("orgList", JSONArray.fromObject(orgList));
        modelAndView.setViewName("functions/tutor/consult/ClaimPaper");
        Subject subject = SecurityUtils.getSubject();
        User user = (User) subject.getSession().getAttribute("user");
        Author authorNow = authorService.getAuthor(user.getId());
        modelAndView.addObject("author", authorNow);
        return modelAndView;
    }

    /**
     * @Description  跳转至论文认领历史记录页面
     * @author wh
     * @date 2020/2/9 14:04
     */
    @RequestMapping(value = "goTutorPaperMatchHistory",method = RequestMethod.GET)
    public ModelAndView goTutorPaperMatchHistory (){
        Subject subject = SecurityUtils.getSubject();
        User user = (User) subject.getSession().getAttribute("user");
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("functions/tutor/consult/ClaimPaperHistory");
        Author authorNow = authorService.getAuthor(user.getId());
        modelAndView.addObject("author", authorNow);
        return modelAndView;
    }


    /**
     * @Description  跳转至论文认领管理
     * @author wh
     * @date 2020/2/9 14:04
     */
    @RequestMapping(value = "goPaperClaimManage",method = RequestMethod.GET)
    public ModelAndView goPaperClaimManage (){
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("functions/tutor/manage/paperClaimManage");
        return modelAndView;
    }
    /**
     * @Description  跳转至用户查找
     * @author wh
     * @date 2020/2/9 14:04
     */

    @RequestMapping(value = "goSearchUser", method = RequestMethod.GET)
    public ModelAndView doc_paperUserMatch_searchUser(
            @RequestParam("paperId") String paperId,
            @RequestParam("authorIndex") int authorIndex,
            @RequestParam("searchKey") String searchKey,
            @RequestParam("school") String school,
            @RequestParam("publishDate") Long publishDate,
            @RequestParam("workId") String workId,
            @RequestParam("paperIndex")String paperIndex) {
        ModelAndView mv = new ModelAndView("functions/tutor/manage/searchUser");
        mv.addObject("paperId", paperId);
        mv.addObject("authorIndex", authorIndex);
        mv.addObject("searchKey", searchKey);
        mv.addObject("school", school);
        mv.addObject("publishDate", publishDate);
        mv.addObject("workId", workId);
        mv.addObject("paperIndex", paperIndex);
        return mv;
    }


    /**
     * @Description 根据老师workid 查询名下论文
     * @author wh
     * @date 2020/2/9 14:04
     */
    @RequestMapping(value = "selectMyPaperByPage", method = RequestMethod.POST)
    @ResponseBody
    public Object selectMyPaperByPage(
            @RequestBody TutorPaper tutorPaper
    ) {
        //1.获取当前用户的全部的论文List(根据作者工号，论文状态，以及page分页信息)
        List<TutorPaper> myPaperList = tutorService.selectTutorPaperListByPage(tutorPaper);
        //2.获取当前作者论文总数(根据作者工号)
        int myPaperNum = tutorService.getTutorPaperNum(tutorPaper.getTheAuthorWorkId());

        Page<TutorPaper> paperResPage = new Page<>();
        paperResPage.setResultList(myPaperList);
        paperResPage.setTotal(myPaperNum);
        return retMsg.Set(MsgType.SUCCESS, paperResPage);
    }


    /**
     * @Description 根据论文wosid查询论文信息
     * @author wh
     * @date 2020/2/9 14:04
     */
    @RequestMapping(value = "getPaperByWOS", method = RequestMethod.POST)
    @ResponseBody
    public Object selectMyPaperByWosId(
            @RequestBody TutorPaper wosId
    ) {
        //1.获取当前用户的全部的论文List(根据作者工号，论文状态，以及page分页信息)
        List<TutorPaper> myPaperList = tutorService.selectTutorPaperByWosId(wosId.getStoreNum());

        Page<TutorPaper> paperResPage = new Page<>();
        paperResPage.setResultList(myPaperList);
        paperResPage.setTotal(myPaperList.size());
        return retMsg.Set(MsgType.SUCCESS, paperResPage);
    }

    /**
     * @Description 教师认领论文接口
     * @author wh
     * @date 2020/2/9 14:04
     */
    @RequestMapping(value = "tutorClaimPaper", method = RequestMethod.POST)
    @ResponseBody
    public Object tutorClaimPaper(
            @RequestBody ClaimPaper claimPaper
    ) {
        claimPaper.preInsert();
        int n = tutorService.tutorClaimPaper(claimPaper);
        if(n == 1){
            return retMsg.Set(MsgType.SUCCESS);
        }else if( n == -2){
            return  retMsg.Set(MsgType.ERROR,"该论文已被认领");
        }else if (n == -1){
            return retMsg.Set(MsgType.ERROR,"认领失败");
        }else{
            return retMsg.Set(MsgType.ERROR,"未知错误");
        }
    }


    /**
     * @Description  查找教师认领论文历史记录
     * @author wh
     * @date 2020/2/9 14:04
     */
    @RequestMapping(value = "getTutorClaimHistory", method = RequestMethod.POST)
    @ResponseBody
    public Object getTutorClaimHistory(
            @RequestBody ClaimPaper claimPaper
    ) {
        List<ClaimPaper> claimPapers = tutorService.getTutorClaimHistory(claimPaper);
        Page<ClaimPaper> paperResPage = new Page<>();
        paperResPage.setResultList(claimPapers);
        paperResPage.setTotal(claimPapers.size());
        return retMsg.Set(MsgType.SUCCESS, paperResPage);
    }


    /**
     * @Description  管理论文认领记录
     * @author wh
     * @date 2020/2/9 14:04
     */
    @RequestMapping(value = "getTutorClaimManage", method = RequestMethod.POST)
    @ResponseBody
    public Object getTutorClaimManage(
            @RequestBody ClaimPaper claimPaper
    ) {
        List<ClaimPaper> claimPapers = tutorService.getTutorClaimHistory(claimPaper);
        Page<ClaimPaper> paperResPage = new Page<>();
        paperResPage.setResultList(claimPapers);
        paperResPage.setTotal(claimPapers.size());
        return retMsg.Set(MsgType.SUCCESS,paperResPage);
    }



    /**
     * @Description  处理申请更换信息的请求
     * @author wh
     * @date 2020/2/9 14:04
     */
    @RequestMapping(value = "doTutorClaim", method = RequestMethod.POST)
    @ResponseBody
    public Object doTutorClaim(
            @RequestBody  ClaimPaper claimPaper
    ) {
        int n = tutorService.doTutorClaim(claimPaper);
        if( n == 1){
            return retMsg.Set(MsgType.SUCCESS);
        }else {
            return retMsg.Set(MsgType.ERROR);
        }

    }
}
