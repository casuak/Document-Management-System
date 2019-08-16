package team.abc.ssm.modules.patent.api;

import net.sf.json.JSONArray;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import team.abc.ssm.common.persistence.Page;
import team.abc.ssm.common.web.AjaxMessage;
import team.abc.ssm.common.web.BaseApi;
import team.abc.ssm.common.web.MsgType;
import team.abc.ssm.common.web.PatentMatchType;
import team.abc.ssm.modules.author.entity.Author;
import team.abc.ssm.modules.author.service.AuthorService;
import team.abc.ssm.modules.doc.entity.StatisticCondition;
import team.abc.ssm.modules.patent.entity.DocPatent;
import team.abc.ssm.modules.patent.service.DocPatentService;
import team.abc.ssm.modules.sys.service.FunctionService;

import java.text.ParseException;
import java.util.*;

@Controller
@RequestMapping("/api/patent")
public class DocPatentApi extends BaseApi {

    @Autowired
    private DocPatentService patentService;

    @Autowired
    private AuthorService authorService;

    @Autowired
    private FunctionService functionService;

    @RequestMapping(value = "selectListByPage", method = RequestMethod.POST)
    @ResponseBody
    public Object selectListByPage(@RequestBody DocPatent patent) {
        Page<DocPatent> data = new Page<>();
        data.setResultList(patentService.selectListByPage(patent));
        data.setTotal(patentService.selectSearchCount(patent));
        return new AjaxMessage().Set(MsgType.SUCCESS, data);
    }

    @RequestMapping(value = "deleteListByIds", method = RequestMethod.POST)
    @ResponseBody
    public Object deleteListByIds(@RequestBody List<DocPatent> patentList) {
        patentService.deleteListByIds(patentList);
        return retMsg.Set(MsgType.SUCCESS);
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
    public Object setPatentAuthor(
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

    /**
     * @author zm
     * @date 2019/8/4 14:57
     * @params []
     * @return: java.lang.Object
     * @Description //把专利状态设置成2(匹配成功)___全部已完成匹配的专利
     **/
    @RequestMapping(value = "convertToCompleteAll",method = RequestMethod.POST)
    @ResponseBody
    public Object convertToCompleteAll(){
        if (patentService.convertToCompleteAll()){
            return retMsg.Set(MsgType.SUCCESS);
        }else {
            return retMsg.Set(MsgType.ERROR);
        }
    }
    /**
     * @author zm
     * @date 2019/7/5 9:31
     * @params [patentList]
     * @return: java.lang.Object
     * @Description //根据传来的专利list，把专利状态设置成4(匹配完成)，并且插入新的记录在mapUserPatent中。
     **/
    @RequestMapping(value = "convertToCompleteByIds",method = RequestMethod.POST)
    @ResponseBody
    public Object convertToCompleteByIds(
            @RequestBody List<DocPatent> patentList){
        System.out.println("--------------------------zhuanru wancheng ");
        System.out.println(patentList);
        //更改专利的状态
        patentService.convertToCompleteByIds(patentList);
        //插入记录——mapUserPatent
        //patentService.insertPatentMapRecord(ids);
        return retMsg.Set(MsgType.SUCCESS);
    }

    @RequestMapping(value = "changeInstitute", method = RequestMethod.POST)
    @ResponseBody
    public Object changeInstitute(
            @RequestParam("patentId") String patentId,
            @RequestParam("institute") String institute){
        patentService.changeInstitute(patentId,institute);
        return retMsg.Set(MsgType.SUCCESS);
    }

    /**
     * @author zm
     * @date 2019/8/4 16:31
     * @params [sysUser]
     * @return: java.lang.Object
     * @Description //获取当前作者的全部专利(返回分页)
     *
     * docPatent.firstAuthorId暂存作者id
     * docPatent.secondAuthorId暂存作者工号
     * docPatent.page存贮所需分页
     **/
    @RequestMapping(value = "selectMyPatentByPage",method = RequestMethod.POST)
    @ResponseBody
    public Object selectMyPatentByPage(
            @RequestBody DocPatent docPatent){
        //1.提取暂存在docPatent中的authorId，和authorWorkId信息
        String authorId = docPatent.getFirstAuthorId();
        String authorWorkId = docPatent.getSecondAuthorId();
        //2.获取专利列表
        List<DocPatent> myPatentList = patentService.selectMyPatentListByPage(authorWorkId,docPatent);
        //3.获取专利总数
        int myPatentNum = patentService.getMyPatentNum(authorWorkId);
        //4.构造返回分页
        Page<DocPatent> myPatentPage = new Page<>();
        myPatentPage.setResultList(myPatentList);
        myPatentPage.setTotal(myPatentNum);
        System.out.println("-----专利page----");
        System.out.println(myPatentPage);
        AjaxMessage retMsg = new AjaxMessage();
        return retMsg.Set(MsgType.SUCCESS,myPatentPage);
    }

    /*查看专利统计详情*/
    @RequestMapping(value = "selectPatentListByPageGet", method = RequestMethod.GET)
    public Object selectPatentListByPageGet(
            @RequestParam(value = "subject") String subject,
            @RequestParam(value = "institute") String institute,
            @RequestParam(value = "startDate") String startDate,
            @RequestParam(value = "endDate") String endDate,
            @RequestParam(value = "patentType") String patentType,
            ModelAndView modelAndView
    ) {
        //获取专利所有类别
        List<String> patentTypeList = patentService.getAllPatentType();
        //获取学科类别
        List<String> subjectList = authorService.getSubList();
        //获取机构(学院)类别
        List<String> orgList = functionService.getOrgList();

        modelAndView.setViewName("functions/doc/docManage/patentList");

        modelAndView.addObject("patentTypeList", JSONArray.fromObject(patentTypeList));
        modelAndView.addObject("subjectList", JSONArray.fromObject(subjectList));
        modelAndView.addObject("orgList", JSONArray.fromObject(orgList));

        modelAndView.addObject("subject",subject);
        modelAndView.addObject("institute",institute);
        modelAndView.addObject("startDate",startDate);
        modelAndView.addObject("endDate",endDate);
        modelAndView.addObject("patentType",patentType);

        return modelAndView;
    }

    @RequestMapping(value = "selectAllPatentByPage", method = RequestMethod.POST)
    @ResponseBody
    public Object selectAllPatentByPage(
            @RequestBody StatisticCondition condition
    ) {

        System.out.println("_-------------------");
        //1.设置待查询的专利List的状态为：已完成
        condition.setStatus(PatentMatchType.MATCH_FINISHED.toString());
        //2.分页查询patentList
        List<DocPatent> patentList = patentService.selectListByPageWithStatisticCondition(condition);
        //3.查询总数目
        int patentNum = patentService.selectNumWithStatisticCondition(condition);

        Page<DocPatent> patentResPage = new Page<>();
        patentResPage.setResultList(patentList);
        patentResPage.setTotal(patentNum);

        System.out.println(patentResPage);

        return retMsg.Set(MsgType.SUCCESS, patentResPage);
    }
}
