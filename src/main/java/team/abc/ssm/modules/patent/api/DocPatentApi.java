package team.abc.ssm.modules.patent.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
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
     * @date 2019/7/3 9:33
     * @params []
     * @return: java.lang.Object
     * @Description //step1：初始化所有未初始化的专利
     **/
    public Object initAllPatent() throws ParseException {
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
}
