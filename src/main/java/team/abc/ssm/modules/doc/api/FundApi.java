package team.abc.ssm.modules.doc.api;


import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import team.abc.ssm.common.persistence.Page;
import team.abc.ssm.common.web.BaseApi;
import team.abc.ssm.common.web.MsgType;
import team.abc.ssm.modules.doc.entity.Fund;
import team.abc.ssm.modules.doc.service.FundService;

@Controller
@RequestMapping("api/doc/fund")
public class FundApi extends BaseApi {


    @Autowired
    private FundService fundService;

    @RequestMapping(value = "list", method = RequestMethod.POST)
    @ResponseBody
    public Object list(@RequestBody Fund fund){
        Page<Fund> page = fundService.list(fund);
        return retMsg.Set(MsgType.SUCCESS, page);
    }

    @RequestMapping(value = "deleteByIds",method = RequestMethod.POST)
    @ResponseBody
    public Object deleteByIds(@RequestBody List<Fund> list){
        fundService.deleteByIds(list);
        return retMsg.Set(MsgType.SUCCESS);
    }

    @RequestMapping(value = "deleteAll",method = RequestMethod.POST)
    @ResponseBody
    public Object deleteAll(){
        fundService.deleteAll();
        return retMsg.Set(MsgType.SUCCESS);
    }

    @RequestMapping(value = "updateById",method = RequestMethod.POST)
    @ResponseBody
    public Object updateById(@RequestBody Fund fund ){
        fundService.updateById(fund);
        return retMsg.Set(MsgType.SUCCESS);
    }
}
