package team.abc.ssm.modules.doc.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import team.abc.ssm.common.web.BaseApi;
import team.abc.ssm.common.web.MsgType;
import team.abc.ssm.modules.doc.service.DanweiNicknamesService;

@Controller
@RequestMapping("api/doc/danweiNicknames")
public class DanweiNicknamesApi extends BaseApi {

    @Autowired
    private DanweiNicknamesService danweiNicknamesService;

    @RequestMapping(value = "selectAllList", method = RequestMethod.POST)
    @ResponseBody
    public Object selectAllList() {
        return retMsg.Set(MsgType.SUCCESS, danweiNicknamesService.selectAllList());
    }
}
