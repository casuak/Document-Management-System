package team.abc.ssm.modules.doc.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import team.abc.ssm.common.persistence.Page;
import team.abc.ssm.common.web.BaseApi;
import team.abc.ssm.common.web.MsgType;
import team.abc.ssm.modules.doc.entity.Paper;
import team.abc.ssm.modules.doc.service.PaperService;

import java.util.List;

/**
 * selectListByPage     page + searchKey + status
 * initAll              init all paper whose status is null
 */
@Controller
@RequestMapping("api/doc/paper")
public class PaperApi extends BaseApi {

    @Autowired
    private PaperService paperService;

    @RequestMapping(value = "selectListByPage", method = RequestMethod.POST)
    @ResponseBody
    public Object selectListByPage(@RequestBody Paper paper) {
        Page<Paper> data = new Page<>();
        data.setResultList(paperService.selectListByPage(paper));
        data.setTotal(paperService.selectSearchCount(paper));
        return retMsg.Set(MsgType.SUCCESS, data);
    }

    @RequestMapping(value = "initAll", method = RequestMethod.POST)
    @ResponseBody
    public Object initAll() {
        paperService.initAll();
        return retMsg.Set(MsgType.SUCCESS);
    }

    @RequestMapping(value = "deleteListByIds", method = RequestMethod.POST)
    @ResponseBody
    public Object deleteListByIds(@RequestBody List<Paper> paperList) {
        paperService.deleteListByIds(paperList);
        return retMsg.Set(MsgType.SUCCESS);
    }

    @RequestMapping(value = "paperUserMatch", method = RequestMethod.POST)
    @ResponseBody
    public Object paperUserMatch() {
        paperService.paperUserMatch();
        return retMsg.Set(MsgType.SUCCESS);
    }
}
