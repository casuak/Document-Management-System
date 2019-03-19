package team.abc.ssm.modules.sys.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import team.abc.ssm.common.persistence.Page;
import team.abc.ssm.common.web.BaseApi;
import team.abc.ssm.common.web.MsgType;
import team.abc.ssm.modules.sys.entity.Dict;
import team.abc.ssm.modules.sys.service.DictService;

import java.util.List;

/**
 * insert
 * deleteListByIds
 * update
 * selectListByPage
 */
@Controller
@RequestMapping("api/sys/dict")
public class DictApi extends BaseApi {

    @Autowired
    private DictService dictService;

    @RequestMapping(value = "insert", method = RequestMethod.POST)
    @ResponseBody
    public Object insert(@RequestBody Dict dict) {
        try {
            if (dictService.insert(dict))
                return retMsg.Set(MsgType.SUCCESS);
            return retMsg.Set(MsgType.ERROR);
        } catch (Exception e) {
            return retMsg.Set(MsgType.ERROR);
        }
    }

    @RequestMapping(value = "deleteListByIds", method = RequestMethod.POST)
    @ResponseBody
    public Object deleteListByIds(@RequestBody List<Dict> dictList) {
        try {
            if (dictService.deleteListByIds(dictList))
                return retMsg.Set(MsgType.SUCCESS);
            return retMsg.Set(MsgType.ERROR);
        } catch (Exception e) {
            return retMsg.Set(MsgType.ERROR);
        }
    }

    @RequestMapping(value = "update", method = RequestMethod.POST)
    @ResponseBody
    public Object update(@RequestBody Dict dict) {
        try {
            if (dictService.update(dict))
                return retMsg.Set(MsgType.SUCCESS);
            return retMsg.Set(MsgType.ERROR);
        } catch (Exception e) {
            return retMsg.Set(MsgType.ERROR);
        }
    }

    @RequestMapping(value = "selectListByPage", method = RequestMethod.POST)
    @ResponseBody
    public Object selectListByPage(@RequestBody Dict dict) {
        try {
            Page<Dict> page = new Page<>();
            page.setResultList(dictService.selectListByPage(dict));
            page.setTotal(dictService.selectSearchCount(dict));
            return retMsg.Set(MsgType.SUCCESS, page);
        } catch (Exception e) {
            return retMsg.Set(MsgType.ERROR);
        }
    }

    @RequestMapping(value = "selectParentList", method = RequestMethod.POST)
    @ResponseBody
    public Object selectParentList(@RequestBody Dict dict) {
        return retMsg.Set(MsgType.SUCCESS, dictService.selectParentList(dict));
    }
}
