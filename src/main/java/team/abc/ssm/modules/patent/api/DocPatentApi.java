package team.abc.ssm.modules.patent.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import team.abc.ssm.common.persistence.Page;
import team.abc.ssm.common.web.AjaxMessage;
import team.abc.ssm.common.web.BaseApi;
import team.abc.ssm.common.web.MsgType;
import team.abc.ssm.modules.patent.entity.DocPatent;
import team.abc.ssm.modules.patent.service.DocPatentService;

import java.text.ParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/api/patent")
public class DocPatentApi extends BaseApi {

    @Autowired
    private DocPatentService patentService;

    @RequestMapping(value = "selectListByPage", method = RequestMethod.POST)
    @ResponseBody
    public Object selectListByPage(@RequestBody DocPatent patent) {
        System.out.println("----DocPatent----selectListByPage----start----");
        Page<DocPatent> data = new Page<>();
        data.setResultList(patentService.selectListByPage(patent));
        data.setTotal(patentService.selectSearchCount(patent));
        System.out.println(data.getResultList());
        System.out.println(data.getTotal());
        System.out.println("----DocPatent----selectListByPage----end----");
        return new AjaxMessage().Set(MsgType.SUCCESS, data);
    }

    @RequestMapping(value = "deleteListByIds", method = RequestMethod.POST)
    @ResponseBody
    public Object deleteListByIds(@RequestBody List<DocPatent> patentList) {
        patentService.deleteListByIds(patentList);
        return retMsg.Set(MsgType.SUCCESS);
    }

    @RequestMapping(value = "searchUser", method = RequestMethod.GET)
    public ModelAndView patentUserSearch(
            @RequestParam("patentId") String patentId,
            @RequestParam("authorIndex") int authorIndex,
            @RequestParam("searchKey") String searchKey,
            @RequestParam("institute") String institute,
            @RequestParam("authorizationDate") Long authorizationDate,
            @RequestParam("workId") String workId)
    {
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
     * @date 2019/7/3 10:19
     * @params [status]
     * @return: java.lang.Object
     * @Description //删除某个状态下的所有专利
     **/
    @RequestMapping(value = "deletePatentByStatus", method = RequestMethod.POST)
    @ResponseBody
    public Object deletePatentByStatus(@RequestParam("status") String status) {
        patentService.deleteByStatus(status);
        return retMsg.Set(MsgType.SUCCESS);
    }

    /**
     * @author zm
     * @date 2019/7/3 10:23
     * @params [patentId, authorIndex, authorId]
     * @return: java.lang.Object
     * @Description //手动设置专利的第一作者或第二作者
     **/
    @RequestMapping(value = "setPatentAuthor", method = RequestMethod.POST)
    @ResponseBody
    public Object selectAuthor(
            @RequestParam("patentId") String patentId,
            @RequestParam("authorIndex") int authorIndex,
            @RequestParam("authorId") String authorId) {
        int res = patentService.setPatentAuthor(patentId, authorIndex, authorId);
        if (res == 1){
            return retMsg.Set(MsgType.SUCCESS);
        }else {
            return retMsg.Set(MsgType.ERROR);
        }
    }

    /**
     * @author zm
     * @date 2019/7/3 9:33
     * @params []
     * @return: java.lang.Object
     * @Description //step1：初始化所有未初始化的专利
     **/
    @RequestMapping(value = "initAllPatent", method = RequestMethod.POST)
    @ResponseBody
    public Object initAllPatent() throws ParseException {
        System.out.println("----initAllPatent----start----");
        patentService.initialPatent();
        return retMsg.Set(MsgType.SUCCESS);
    }

    /**
     * @author zm
     * @date 2019/7/3 10:16
     * @params []
     * @return: java.lang.Object
     * @Description //step2：对所有已初始化的专利进行用户匹配，并返回匹配的结果
     **/
    @RequestMapping(value = "patentUserMatch", method = RequestMethod.POST)
    @ResponseBody
    public Object patentUserMatch() {
        Map<String, Integer> matchResult = new HashMap<>();
        try {
            matchResult = patentService.patentUserMatch();
        } catch (Exception e){
            e.printStackTrace();
        }
        return retMsg.Set(MsgType.SUCCESS,matchResult);
    }

    /**
     * @author zm
     * @date 2019/7/3 14:56
     * @params [patentList]
     * @return: java.lang.Object
     * @Description //把专利状态设置成2(匹配成功)
     **/
    @RequestMapping(value = "convertToSuccessByIds", method = RequestMethod.POST)
    @ResponseBody
    public Object convertToSuccessByIds(@RequestBody List<DocPatent> patentList) {
        patentService.convertToSuccessByIds(patentList);
        return retMsg.Set(MsgType.SUCCESS);
    }
}
