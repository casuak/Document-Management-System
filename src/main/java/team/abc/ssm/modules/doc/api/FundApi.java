package team.abc.ssm.modules.doc.api;


import java.util.List;

import net.sf.json.JSONArray;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import team.abc.ssm.common.persistence.Page;
import team.abc.ssm.common.web.AjaxMessage;
import team.abc.ssm.common.web.BaseApi;
import team.abc.ssm.common.web.MsgType;
import team.abc.ssm.modules.author.entity.SysUser;
import team.abc.ssm.modules.author.service.AuthorService;
import team.abc.ssm.modules.doc.entity.Fund;
import team.abc.ssm.modules.doc.entity.StatisticCondition;
import team.abc.ssm.modules.doc.service.FundService;
import team.abc.ssm.modules.sys.service.FunctionService;

@Controller
@RequestMapping("api/doc/fund/")
public class FundApi extends BaseApi {
    @Autowired
    private FundService fundService;

    @Autowired
    private AuthorService authorService;

    @Autowired
    private FunctionService functionService;

    @RequestMapping(value = "initFirst", method = RequestMethod.POST)
    @ResponseBody
    public Object init() {
        fundService.init();
        return retMsg.Set(MsgType.SUCCESS);
    }

    @RequestMapping(value = "list", method = RequestMethod.POST)
    @ResponseBody
    public Object list(@RequestBody Fund fund) {
        Page<Fund> data = new Page<>();
        data.setResultList(fundService.list(fund));
        data.setTotal(fundService.listCount(fund));
        return new AjaxMessage().Set(MsgType.SUCCESS, data);
    }

    @RequestMapping(value = "deleteByIds", method = RequestMethod.POST)
    @ResponseBody
    public Object deleteByIds(@RequestBody List<Fund> list) {
        fundService.deleteByIds(list);
        return retMsg.Set(MsgType.SUCCESS);
    }

    @RequestMapping(value = "deleteFundByStatus", method = RequestMethod.POST)
    @ResponseBody
    public Object deleteFundByStatus(@RequestParam("status") String status) {
        fundService.deleteFundByStatus(status);
        return retMsg.Set(MsgType.SUCCESS);
    }

    @RequestMapping(value = "initAllFund", method = RequestMethod.POST)
    @ResponseBody
    public Object initAllFund() {
        System.out.println("----initAllFund----start----");
        fundService.initFund();
        return retMsg.Set(MsgType.SUCCESS);
    }

    @RequestMapping(value = "matchUserFund", method = RequestMethod.POST)
    @ResponseBody
    public Object matchUserFund() {
        System.out.println("----matchUserFund----start----");
        fundService.matchUserFund();
        return retMsg.Set(MsgType.SUCCESS);
    }

    @RequestMapping(value = "updateFund", method = RequestMethod.POST)
    @ResponseBody
    public Object updateFund(@RequestBody Fund fund) {
        if (fundService.updateFund(fund))
            return retMsg.Set(MsgType.SUCCESS);
        else return retMsg.Set(MsgType.ERROR);
    }

    @RequestMapping(value = "searchForMatch")
    @ResponseBody
    public Object searchForMatch(@RequestParam("id") String id,
                                 @RequestParam("name") String name) {
        List<SysUser> findById = fundService.findById(id);
        List<SysUser> findByName = fundService.findByName(name);
        findById.addAll(findByName);
        return findById;
    }

    @RequestMapping(value = "matchFund", method = RequestMethod.POST)
    @ResponseBody
    public Object matchFund(@RequestBody Fund fund) {
        if (fundService.matchFund(fund))
            return retMsg.Set(MsgType.SUCCESS);
        else return retMsg.Set(MsgType.ERROR);
    }

    /*查看基金统计详情*/
    @RequestMapping(value = "selectFundListByPageGet", method = RequestMethod.GET)
    public Object selectFundListByPageGet(
            @RequestParam(value = "institute") String institute,
            @RequestParam(value = "fundType") String fundType,
            ModelAndView modelAndView
    ) {
        //获取专利所有类别
        List<String> fundTypeList = fundService.getFundTypeList();
        //获取机构(学院)类别
        List<String> orgList = functionService.getOrgList();

        modelAndView.setViewName("functions/doc/docManage/fundList");

        modelAndView.addObject("fundTypeList", JSONArray.fromObject(fundTypeList));
        modelAndView.addObject("orgList", JSONArray.fromObject(orgList));


        modelAndView.addObject("institute",institute);
        modelAndView.addObject("fundType",fundType);

        return modelAndView;
    }

    @RequestMapping(value = "selectAllFundByPage",method = RequestMethod.POST)
    @ResponseBody
    public Object selectAllFundByPage(@RequestBody StatisticCondition condition){
        //1.设置待查询的List的状态为：已完成
        condition.setStatus("2");
        //2.分页查询
        List<Fund> fundList = fundService.selectListByPageWithStatisticCondition(condition);
        //3.查询总数目
        int fundNum = fundService.selectNumWithStatisticCondition(condition);

        Page<Fund> patentResPage = new Page<>();
        patentResPage.setResultList(fundList);
        patentResPage.setTotal(fundNum);

        System.out.println(patentResPage);

        return retMsg.Set(MsgType.SUCCESS, patentResPage);
    }

    @RequestMapping(value = "deleteFundListByIds", method = RequestMethod.POST)
    @ResponseBody
    public Object deleteListByIds(@RequestBody List<Fund> list) {
        fundService.deleteListByIds(list);
        return retMsg.Set(MsgType.SUCCESS);
    }
}
