package team.abc.ssm.modules.doc.api;


import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import team.abc.ssm.common.persistence.Page;
import team.abc.ssm.common.web.AjaxMessage;
import team.abc.ssm.common.web.BaseApi;
import team.abc.ssm.common.web.MsgType;
import team.abc.ssm.modules.author.entity.SysUser;
import team.abc.ssm.modules.doc.entity.Fund;
import team.abc.ssm.modules.doc.service.FundService;

@Controller
@RequestMapping("api/doc/fund/")
public class FundApi extends BaseApi {


    @Autowired
    private FundService fundService;

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
}
