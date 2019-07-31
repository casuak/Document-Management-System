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
import team.abc.ssm.modules.doc.entity.Journal;
import team.abc.ssm.modules.doc.service.JournalService;

import java.util.List;


@Controller
@RequestMapping("api/doc/journal")
public class JournalApi extends BaseApi {

    @Autowired
    private JournalService journalService;

    @RequestMapping(value = "list", method = RequestMethod.POST)
    @ResponseBody
    public Object list(@RequestBody Journal journal){
        Page<Journal> page = journalService.list(journal);
        return retMsg.Set(MsgType.SUCCESS, page);
    }

    @RequestMapping(value = "deleteByIds",method = RequestMethod.POST)
    @ResponseBody
    public Object deleteByIds(@RequestBody List<Journal> list){
        journalService.deleteByIds(list);
        return retMsg.Set(MsgType.SUCCESS);
    }
}
