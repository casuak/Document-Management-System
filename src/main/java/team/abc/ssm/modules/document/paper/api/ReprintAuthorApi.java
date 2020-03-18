package team.abc.ssm.modules.document.paper.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import team.abc.ssm.common.persistence.Page;
import team.abc.ssm.common.web.BaseApi;
import team.abc.ssm.common.web.MsgType;
import team.abc.ssm.modules.document.fund.entity.Fund;
import team.abc.ssm.modules.document.paper.entity.Paper;
import team.abc.ssm.modules.document.paper.entity.ReprintAuthorEntry;
import team.abc.ssm.modules.document.paper.service.ReprintAuthorService;

import java.util.List;

@Controller
@RequestMapping("api/doc/rp/")
public class ReprintAuthorApi extends BaseApi {
    @Autowired
    private ReprintAuthorService reprintAuthorService;

    @RequestMapping(value = "selectListByPage", method = RequestMethod.POST)
    @ResponseBody
    public Object selectListByPage(@RequestBody Paper paper) {
        Page<Paper> data = new Page<>();
        try {
            data.setResultList(reprintAuthorService.selectListByPage(paper));
            data.setTotal(reprintAuthorService.selectSearchCount(paper));
        } catch (Exception e) {
            return retMsg.Set(MsgType.ERROR, e.toString());
        }
        return retMsg.Set(MsgType.SUCCESS, data);
    }

    @RequestMapping(value = "init", method = RequestMethod.POST)
    @ResponseBody
    public Object init() {
        try {
            reprintAuthorService.init();
        } catch (Exception e) {
            e.printStackTrace();
            return retMsg.Set(MsgType.ERROR, e.toString());
        }
        return retMsg.Set(MsgType.SUCCESS);
    }

    @RequestMapping(value = "autoMatch", method = RequestMethod.POST)
    @ResponseBody
    public Object autoMatch() {
        try {
            reprintAuthorService.autoMatch();
        } catch (Exception e) {
            e.printStackTrace();
            return retMsg.Set(MsgType.ERROR, e.toString());
        }
        return retMsg.Set(MsgType.SUCCESS);
    }

    //此处的删除不影响以前论文匹配的结果，下同
    @RequestMapping(value = "deletePaperEntryByIds", method = RequestMethod.POST)
    @ResponseBody
    public Object deletePaperEntryByIds(@RequestBody List<Paper> list) {
        try {
            reprintAuthorService.deletePaperEntryByIds(list);
        } catch (Exception e) {
            return retMsg.Set(MsgType.ERROR, e.toString());
        }
        return retMsg.Set(MsgType.SUCCESS);
    }

    @RequestMapping(value = "deletePaperEntryByStatus", method = RequestMethod.POST)
    @ResponseBody
    public Object deletePaperEntryByStatus(@RequestParam("status") String status) {
        try {
            reprintAuthorService.deleteFundByStatus(status);
        } catch (Exception e) {
            return retMsg.Set(MsgType.ERROR, e.toString());
        }
        return retMsg.Set(MsgType.SUCCESS);
    }

    @RequestMapping(value = "completePaperEntryById", method = RequestMethod.POST)
    @ResponseBody
    public Object completePaperEntryById(@RequestBody List<Paper> list) {
        try {
            reprintAuthorService.completePaperEntryById(list);
        } catch (Exception e) {
            return retMsg.Set(MsgType.ERROR, e.toString());
        }
        return retMsg.Set(MsgType.SUCCESS);
    }

    @RequestMapping(value = "completePaperEntryByStatus", method = RequestMethod.POST)
    @ResponseBody
    public Object completePaperEntryByStatus(@RequestParam("status") String status) {
        try {
            reprintAuthorService.completePaperEntryByStatus(status);
        } catch (Exception e) {
            return retMsg.Set(MsgType.ERROR, e.toString());
        }
        return retMsg.Set(MsgType.SUCCESS);
    }

    @RequestMapping(value = "rollBackToSuccessById", method = RequestMethod.POST)
    @ResponseBody
    public Object rollBackToSuccessById(@RequestBody List<Paper> list) {
        try {
            reprintAuthorService.rollBackToSuccessById(list);
        } catch (Exception e) {
            return retMsg.Set(MsgType.ERROR, e.toString());
        }
        return retMsg.Set(MsgType.SUCCESS);
    }


    @RequestMapping(value = "getEntryList", method = RequestMethod.POST)
    @ResponseBody
    public Object getEntryList(@RequestParam("id") String id) {
        Page<ReprintAuthorEntry> data = new Page<>();
        try {
            data.setResultList(reprintAuthorService.getMatchEntryById(id));
        } catch (Exception e) {
            return retMsg.Set(MsgType.ERROR, e.toString());
        }
        return retMsg.Set(MsgType.SUCCESS, data);
    }

    @RequestMapping(value = "submitChange", method = RequestMethod.POST)
    @ResponseBody
    public Object submitChange(@RequestBody List<ReprintAuthorEntry> list) {
        try {
//            System.out.println("###" + list.size());
//            System.out.println("***" + list.get(0).getPaper());
            reprintAuthorService.updateMatchEntryByPaperId(list, list.get(0).getPaper());
        } catch (Exception e) {
            return retMsg.Set(MsgType.ERROR, e.toString());
        }
        return retMsg.Set(MsgType.SUCCESS);
    }
}
